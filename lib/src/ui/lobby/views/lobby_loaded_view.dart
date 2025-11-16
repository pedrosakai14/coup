import 'package:coup/src/coup.dart';
import 'package:coup/src/ui/lobby/cubit/lobby_cubit.dart';
import 'package:coup/src/ui/lobby/widgets/code_card.dart';
import 'package:coup/src/ui/lobby/widgets/player_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LobbyLoadedView extends StatelessWidget {
  final Room roomData;
  final String playerId;

  const LobbyLoadedView({
    super.key,
    required this.roomData,
    required this.playerId,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final cubit = context.read<LobbyCubit>();

    final sortedPlayers = roomData.players.toList()
      ..sort((a, b) {
        if (a.isHost) return -1;
        if (b.isHost) return 1;
        return a.name.toLowerCase().compareTo(b.name.toLowerCase());
      });

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: Sizing.s16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: Sizing.s12),
          CodeCard(
            roomCode: roomData.code,
            onTap: cubit.copyCodeTapped,
          ),
          SizedBox(height: Sizing.s16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                Strings.lobbyLoadedViewPlayersNumber(sortedPlayers.length),
                style: textTheme.titleMedium,
              ),
              if (sortedPlayers.length < 2)
                Text(
                  Strings.lobbyLoadedViewAlert,
                  textAlign: TextAlign.end,
                  style: textTheme.bodyMedium?.copyWith(color: CommonColors.errorColor, fontWeight: FontWeight.w600),
                ),
            ],
          ),
          SizedBox(height: Sizing.s16),
          ListView.separated(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: sortedPlayers.length,
            separatorBuilder: (context, index) => SizedBox(height: Sizing.s12),
            itemBuilder: (context, index) {
              final player = sortedPlayers[index];

              return PlayerCard(
                player: player,
                isCurrentPlayer: playerId == player.id,
                isCurrentPlayerHost: playerId == roomData.hostId,
                onTapKick: () => cubit.onTapKick(player),
              );
            },
          ),
          SizedBox(height: Sizing.s16),
        ],
      ),
    );
  }
}
