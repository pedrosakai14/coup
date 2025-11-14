import 'dart:developer';
import 'dart:math' hide log;

import 'package:coup/src/coup.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'lobby_state.dart';

class LobbyCubit extends Cubit<LobbyState> {
  LobbyCubit() : super(LobbyLoadingState());

  final database = FirebaseDatabase.instance;
  late String _roomCode;
  late DatabaseReference _roomRef;

  Future<void> init({required String userName, String? roomCode}) async {
    try {
      _roomCode = roomCode ?? randomRoomCode;
      _roomRef = database.ref('rooms/$_roomCode');

      final roomData = roomCode == null ? await _createRoom(userName) : await _joinRoom(userName);

      emit(LobbyLoadedState(roomData: roomData));
    } catch (error, stackTrace) {
      log('Error when init lobby cubit', error: error, stackTrace: stackTrace);
      emit(LobbyErrorState());
    }
  }

  Future<Room> _createRoom(String userName) async {
    final hostPlayer = Player(
      id: randomPlayerId,
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
    return roomData;
  }

  Future<Room> _joinRoom(String userName) async {
    final newPlayer = Player(
      id: randomPlayerId,
      name: userName,
    );

    final TransactionResult result = await _roomRef.runTransaction((Object? data) {
      if (data == null) return Transaction.success(data);

      final currentRoom = Room.fromMap(data as Map<dynamic, dynamic>);
      if (currentRoom.players.length == 6) {
        log('sala lotada');
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
          if (i > 6) return Transaction.abort();
        }
      }

      final newPlayersList = currentRoom.players.toList();
      newPlayersList.add(newPlayer.copyWith(name: finalUserName));
      final newRoomData = currentRoom.copyWith(players: newPlayersList);

      return Transaction.success(newRoomData.toMap());
    });

    if (!result.committed) {
      throw Exception('Failed to join room. It might be full or was deleted.');
    }

    log('join room $_roomCode with success');
    final finalRoomData = Room.fromMap(result.snapshot.value as Map<dynamic, dynamic>);
    return finalRoomData;
  }

  void deleteRoom() async {
    try {
      await _roomRef.remove();

      log('room $_roomCode deleted');
    } catch (error, stackTrace) {
      log('Error when delete room $_roomCode', error: error, stackTrace: stackTrace);
    }
  }

  String get randomRoomCode {
    const String chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    Random random = Random();
    return String.fromCharCodes(Iterable.generate(5, (_) => chars.codeUnitAt(random.nextInt(chars.length))));
  }

  String get randomPlayerId => 'player_${Random().nextInt(10000)}';
}
