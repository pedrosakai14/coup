import 'dart:async';
import 'dart:developer';
import 'dart:math' hide log;

import 'package:coup/src/coup.dart';
import 'package:coup/src/ui/lobby/enums/lobby_alerts.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'lobby_state.dart';

class LobbyCubit extends Cubit<LobbyState> {
  LobbyCubit() : super(LobbyLoadingState(LobbyParams.empty()));

  final database = FirebaseDatabase.instance;
  late String _roomCode;
  late DatabaseReference _roomRef;
  late String _playerId;

  StreamSubscription<DatabaseEvent>? _roomSubscription;

  Future<void> init({required String userName, String? roomCode}) async {
    try {
      _roomCode = roomCode?.toUpperCase() ?? randomRoomCode;
      _roomRef = database.ref('rooms/$_roomCode');

      final data = roomCode == null ? await _createRoom(userName) : await _joinRoom(userName);

      final roomData = data.$1;
      _playerId = data.$2;

      roomData.players.sort(
        (a, b) {
          if (a.isHost) return -1;

          if (b.isHost) return 1;

          return a.name.toLowerCase().compareTo(b.name.toLowerCase());
        },
      );

      _roomSubscription?.cancel();
      _roomSubscription = _roomRef.onValue.listen((DatabaseEvent event) {
        if (event.snapshot.value == null) {
          log('A sala $_roomCode foi deletada.');
          emit(LobbyErrorState(state.params.copyWith(alert: LobbyAlerts.genericError)));
          return;
        }

        try {
          final roomDataMap = event.snapshot.value as Map<dynamic, dynamic>;
          final newRoomData = Room.fromMap(roomDataMap);

          final playerIdsInRoom = newRoomData.players.map((p) => p.id).toSet();
          if (!playerIdsInRoom.contains(_playerId) && _playerId != newRoomData.hostId) {
            log('jogador $_playerId expulso');
            emit(
              LobbyErrorState(
                state.params.copyWith(alert: LobbyAlerts.youWereKicked),
              ),
            );
            return;
          }

          if (state is LobbyLoadedState) {
            emit(
              LobbyLoadedState(
                state.params.copyWith(
                  roomData: newRoomData,
                ),
              ),
            );
          }
        } catch (error, stackTrace) {
          log('Erro ao processar atualização da sala', error: error, stackTrace: stackTrace);
          emit(LobbyErrorState(state.params));
        }
      });

      emit(
        LobbyLoadedState(
          state.params.copyWith(
            roomData: roomData,
            playerId: _playerId,
          ),
        ),
      );
    } catch (error, stackTrace) {
      log('Error when init lobby cubit', error: error, stackTrace: stackTrace);
      emit(LobbyErrorState(state.params));
    }
  }

  Future<(Room, String)> _createRoom(String userName) async {
    final playerId = randomPlayerId;
    final hostPlayer = Player(
      id: playerId,
      name: userName,
      isHost: true,
    );

    final roomData = Room(
      code: _roomCode,
      hostId: hostPlayer.id,
      status: RoomStatus.waiting,
      players: [
        hostPlayer,
      ],
    );

    final TransactionResult result = await _roomRef.runTransaction((Object? data) {
      if (data != null) return Transaction.abort();
      return Transaction.success(roomData.toMap());
    });

    if (!result.committed) throw Exception('room already exists');

    log('room $_roomCode create');
    return (roomData, playerId);
  }

  Future<(Room, String)> _joinRoom(String userName) async {
    final playerId = randomPlayerId;
    final newPlayer = Player(
      id: playerId,
      name: userName,
    );

    final TransactionResult result = await _roomRef.runTransaction((Object? data) {
      if (data == null) return Transaction.success(data);

      final currentRoom = Room.fromMap(data as Map<dynamic, dynamic>);
      if (currentRoom.players.length == CommonConstants.MAX_PLAYERS) {
        emit(
          LobbyErrorState(
            state.params.copyWith(
              alert: LobbyAlerts.roomCrowded,
            ),
          ),
        );
        emit(LobbyErrorState(state.params.copyWith()));
        return Transaction.abort();
      }

      String finalUserName = userName;
      final allNames = currentRoom.players.map((e) => e.name).toSet();
      if (allNames.contains(finalUserName)) {
        int i = 2;
        while (true) {
          final newName = '$userName ($i)';
          if (!allNames.contains(newName)) {
            finalUserName = newName;
            break;
          }
          i++;
          if (i > CommonConstants.MAX_PLAYERS) return Transaction.abort();
        }
      }

      final newPlayersList = currentRoom.players.toList();
      newPlayersList.add(newPlayer.copyWith(name: finalUserName));
      final newRoomData = currentRoom.copyWith(players: newPlayersList);

      return Transaction.success(newRoomData.toMap());
    });

    if (!result.committed || result.snapshot.value is! Map<dynamic, dynamic>) {
      emit(
        LobbyErrorState(
          state.params.copyWith(
            alert: LobbyAlerts.genericError,
          ),
        ),
      );
      emit(LobbyErrorState(state.params.copyWith()));
      throw Exception('Failed to join room. It might be full or was deleted.');
    }

    log('join room $_roomCode with success');
    final finalRoomData = Room.fromMap(result.snapshot.value as Map<dynamic, dynamic>);
    return (finalRoomData, playerId);
  }

  void onTapKick(Player player) async {
    try {
      final newPlayersList = state.params.roomData.players.toList();
      newPlayersList.removeWhere((e) => e.id == player.id);

      final playersMap = {
        for (var p in newPlayersList) p.id: p.toMap(),
      };
      await _roomRef.child('players').set(playersMap);
      log('player ${player.id} removed with success');

      emit(
        LobbyLoadedState(
          state.params.copyWith(
            alert: LobbyAlerts.playerRemovedSuccess,
          ),
        ),
      );
      emit(LobbyLoadedState(state.params.copyWith()));
    } catch (error, stackTrace) {
      log('Failed to remove player ${player.id}', error: error, stackTrace: stackTrace);
      emit(
        LobbyLoadedState(
          state.params.copyWith(
            alert: LobbyAlerts.playerRemovedFails,
          ),
        ),
      );
      emit(LobbyLoadedState(state.params.copyWith()));
    }
  }

  void leaveRoom() async {
    try {
      if (state.params.roomData.players.length == 1) {
        await _roomSubscription?.cancel();
        await _roomRef.remove();

        log('room $_roomCode deleted');
        return;
      }

      final newPlayersList = state.params.roomData.players.toList();
      newPlayersList.removeWhere((e) => e.id == state.params.playerId);

      if (state.params.playerId == state.params.roomData.hostId) {
        final newHostPlayer = newPlayersList.first.copyWith(isHost: true);
        newPlayersList[0] = newHostPlayer;

        final newRoomData = state.params.roomData.copyWith(
          hostId: newHostPlayer.id,
          players: newPlayersList,
        );

        await _roomRef.set(newRoomData.toMap());
      } else {
        final playersMap = {
          for (var p in newPlayersList) p.id: p.toMap(),
        };
        await _roomRef.child('players').set(playersMap);
      }
    } catch (error, stackTrace) {
      log('Error when delete room $_roomCode or player', error: error, stackTrace: stackTrace);
    }
  }

  String get randomRoomCode {
    const String chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    Random random = Random();
    return String.fromCharCodes(Iterable.generate(5, (_) => chars.codeUnitAt(random.nextInt(chars.length))));
  }

  String get randomPlayerId => 'player_${Random().nextInt(10000)}';

  @override
  Future<void> close() {
    if (state is LobbyLoadedState) {
      leaveRoom();
    }
    _roomSubscription?.cancel();
    return super.close();
  }
}
