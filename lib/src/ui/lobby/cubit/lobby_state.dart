part of 'lobby_cubit.dart';

class LobbyParams {
  final String playerId;
  final Room roomData;
  final LobbyAlerts? alert;

  const LobbyParams({
    required this.playerId,
    required this.roomData,
    this.alert,
  });

  LobbyParams copyWith({
    String? playerId,
    Room? roomData,
    LobbyAlerts? alert,
  }) {
    return LobbyParams(
      playerId: playerId ?? this.playerId,
      roomData: roomData ?? this.roomData,
      alert: alert,
    );
  }

  factory LobbyParams.empty() => LobbyParams(
    roomData: Room(
      code: '',
      hostId: '',
      status: RoomStatus.waiting,
      players: [],
    ),
    playerId: '',
  );
}

abstract class LobbyState {
  final LobbyParams params;

  const LobbyState(this.params);
}

class LobbyLoadingState extends LobbyState {
  const LobbyLoadingState(super.params);
}

class LobbyErrorState extends LobbyState {
  const LobbyErrorState(super.params);
}

class LobbyLoadedState extends LobbyState {
  const LobbyLoadedState(super.params);
}
