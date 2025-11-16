import 'dart:async';
import 'dart:developer';
import 'dart:math' hide log;

import 'package:coup/src/coup.dart';
import 'package:coup/src/ui/lobby/enums/lobby_alerts.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';

part 'lobby_state.dart';

class LobbyCubit extends Cubit<LobbyState> {
  final RoomRepository _roomRepository;

  LobbyCubit({
    required RoomRepository roomRepository,
  }) : _roomRepository = roomRepository,
       super(LobbyLoadingState(LobbyParams.empty()));

  late String _roomCode;
  late String _playerId;
  StreamSubscription<Room>? _roomSubscription;

  Future<void> init({required String userName, String? roomCode}) async {
    try {
      final data = roomCode == null
          ? await _roomRepository.createRoom(userName)
          : await _roomRepository.joinRoom(userName, roomCode.toUpperCase());

      final roomData = data.$1;
      _playerId = data.$2;
      _roomCode = roomData.code;

      _roomSubscription?.cancel();
      _roomSubscription = _roomRepository
          .getRoomStream(_roomCode)
          .listen(
            (newRoomData) {
              final playerIds = newRoomData.players.map((p) => p.id).toSet();

              if (!playerIds.contains(_playerId)) {
                emit(LobbyErrorState(state.params.copyWith(alert: LobbyAlerts.youWereKicked)));
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
            },
            onError: (error) {
              log('error on listen room $error');
              emit(LobbyErrorState(state.params.copyWith(alert: LobbyAlerts.genericError)));
            },
          );

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

      LobbyAlerts alert = LobbyAlerts.genericError;
      if (error is RoomIsFullException) {
        alert = LobbyAlerts.roomCrowded;
      } else if (error is RoomNotFoundException) {
        alert = LobbyAlerts.genericError;
      }

      emit(LobbyErrorState(state.params.copyWith(alert: alert)));
    }
  }

  void onTapKick(Player player) async {
    try {
      final newPlayersList = state.params.roomData.players.toList();
      newPlayersList.removeWhere((e) => e.id == player.id);

      await _roomRepository.updatePlayers(_roomCode, newPlayersList);
      log('player ${player.id} removed with success');

      emit(
        LobbyLoadedState(
          state.params.copyWith(
            alert: LobbyAlerts.playerRemovedSuccess,
          ),
        ),
      );
    } catch (error, stackTrace) {
      log('Failed to remove player ${player.id}', error: error, stackTrace: stackTrace);
      emit(
        LobbyLoadedState(
          state.params.copyWith(
            alert: LobbyAlerts.playerRemovedFails,
          ),
        ),
      );
    }
  }

  Future<void> leaveRoom() async {
    try {
      if (state.params.roomData.players.length == 1) {
        await _roomSubscription?.cancel();
        await _roomRepository.deleteRoom(_roomCode);

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

        await _roomRepository.updateRoom(_roomCode, newRoomData);
      } else {
        await _roomRepository.updatePlayers(_roomCode, newPlayersList);
      }
    } catch (error, stackTrace) {
      log('Error when delete room $_roomCode or player', error: error, stackTrace: stackTrace);
    }
  }

  void copyCodeTapped() {
    Clipboard.setData(ClipboardData(text: state.params.roomData.code));

    emit(
      LobbyLoadedState(
        state.params.copyWith(alert: LobbyAlerts.codeCopiedSuccess),
      ),
    );
  }

  void clearAlert() {
    switch (state) {
      case LobbyLoadedState():
        emit(LobbyLoadedState(state.params.copyWith()));
        break;
      case LobbyLoadingState():
        emit(LobbyLoadingState(state.params.copyWith()));
        break;
      case LobbyErrorState():
        emit(LobbyErrorState(state.params.copyWith()));
        break;
    }
  }

  @override
  Future<void> close() async {
    if (state is LobbyLoadedState) {
      await leaveRoom();
    }
    _roomSubscription?.cancel();
    return super.close();
  }
}
