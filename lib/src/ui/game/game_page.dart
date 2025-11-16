import 'package:coup/src/ui/game/cubit/game_cubit.dart';
import 'package:coup/src/ui/game/views/game_loaded_view.dart';
import 'package:coup/src/ui/game/widgets/game_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:coup/src/coup.dart';

class GamePage extends StatefulWidget {
  static const String routeName = '/game-page';

  const GamePage({super.key});

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  late final textTheme = Theme.of(context).textTheme;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GameCubit()..init(),
      child: BlocConsumer<GameCubit, GameState>(
        listener: (context, state) {},
        builder: (context, state) {
          late Widget body;

          switch (state.status) {
            case GameStateStatus.loaded:
              body = GameLoadedView();
              break;
            case GameStateStatus.loading:
              body = Center(
                child: Text(Strings.loading),
              );
              break;
            case GameStateStatus.error:
              body = Center(
                child: Text(Strings.genericError),
              );
              break;
          }

          return Scaffold(
            appBar: const GameAppBar(),
            body: body,
          );
        },
      ),
    );
  }
}
