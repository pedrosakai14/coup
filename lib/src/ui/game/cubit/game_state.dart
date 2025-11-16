part of 'game_cubit.dart';

enum GameStateStatus { loaded, loading, error }

class GameState {
  final GameStateStatus status;

  const GameState({
    this.status = GameStateStatus.loading,
  });
}
