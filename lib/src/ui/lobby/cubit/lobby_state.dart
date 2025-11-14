part of 'lobby_cubit.dart';

abstract class LobbyState {
  const LobbyState();
}

class LobbyLoadingState implements LobbyState {
  const LobbyLoadingState();
}

class LobbyErrorState implements LobbyState {
  const LobbyErrorState();
}

class LobbyLoadedState implements LobbyState {
  final Room roomData;

  const LobbyLoadedState({
    required this.roomData,
  });
}
