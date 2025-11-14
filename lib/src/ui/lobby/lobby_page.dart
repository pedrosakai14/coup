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
  final LobbyCubit cubit = LobbyCubit();

  @override
  void initState() {
    super.initState();
    cubit.init(userName: widget.userName, roomCode: widget.roomCode);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LobbyCubit, LobbyState>(
      bloc: cubit,
      builder: (context, state) {
        late Widget body;
        Widget? bottomNavigationBar;

        switch (state) {
          case LobbyLoadedState():
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
                    onTap: state.roomData.players.length > 1 ? () {} : null,
                    text: 'Começar jogo',
                  ),
                ),
              ),
            );

            body = LobbyLoadedView(roomData: state.roomData);
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
                cubit.deleteRoom();
                Navigator.of(context).pop();
              },
              icon: Icon(Icons.arrow_back),
            ),
          ),
          bottomNavigationBar: bottomNavigationBar,
          body: body,
        );
      },
    );
  }
}
