import 'package:coup/src/coup.dart';
import 'package:coup/src/ui/lobby/cubit/lobby_cubit.dart';
import 'package:coup/src/ui/lobby/views/lobby_loaded_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LobbyPage extends StatefulWidget {
  static const String routeName = '/lobby-page';

  final String? roomCode;
  final String userName;

  const LobbyPage({
    super.key,
    required this.userName,
    this.roomCode,
  });

  @override
  State<LobbyPage> createState() => _LobbyPageState();
}

class _LobbyPageState extends State<LobbyPage> {
  late final textTheme = Theme.of(context).textTheme;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LobbyCubit()
        ..init(
          userName: widget.userName,
          roomCode: widget.roomCode,
        ),
      child: BlocConsumer<LobbyCubit, LobbyState>(
        listener: (context, state) {
          if (state.params.alert == null) return;

          final alertSnack = state.params.alert!.alertSnack;

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                alertSnack.$1,
                style: textTheme.bodyMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
              backgroundColor: alertSnack.$2,
            ),
          );

          if (state.params.alert!.shouldPop) {
            Navigator.of(context).pop();
          }
        },
        builder: (context, state) {
          final cubit = context.read<LobbyCubit>();

          late Widget body;
          Widget? bottomNavigationBar;

          switch (state) {
            case LobbyLoadedState():
              final isHost = state.params.playerId == state.params.roomData.hostId;
              final canTapButton = state.params.roomData.players.length > 1 && isHost;

              bottomNavigationBar = SafeArea(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(color: Colors.grey, width: 0.5),
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: Sizing.s24, vertical: Sizing.s20),
                    child: CommonElevatedButton(
                      onTap: canTapButton ? () {} : null,
                      text: isHost ? 'Começar jogo' : 'Aguardando host começar',
                    ),
                  ),
                ),
              );

              body = LobbyLoadedView(
                roomData: state.params.roomData,
                playerId: state.params.playerId,
                onTapKick: cubit.onTapKick,
              );
              break;
            case LobbyLoadingState():
              body = Center(
                child: Text(Strings.loading),
              );
              break;
            case LobbyErrorState():
              body = Center(
                child: Text('Error'),
              );
              break;
          }

          return Scaffold(
            appBar: AppBar(
              title: Text('Lobby'),
              leading: IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: Icon(Icons.arrow_back),
              ),
            ),
            bottomNavigationBar: bottomNavigationBar,
            body: body,
          );
        },
      ),
    );
  }
}
