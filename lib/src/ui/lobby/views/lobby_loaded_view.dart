import 'package:coup/src/coup.dart';
import 'package:coup/src/ui/lobby/widgets/code_card.dart';
import 'package:coup/src/ui/lobby/widgets/player_card.dart';
import 'package:flutter/material.dart';

class LobbyLoadedView extends StatelessWidget {
  final Room roomData;
  final String playerId;
  final Function(Player) onTapKick;

  const LobbyLoadedView({
    super.key,
    required this.roomData,
    required this.playerId,
    required this.onTapKick,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: Sizing.s16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: Sizing.s12),
          CodeCard(roomCode: roomData.code),
          SizedBox(height: Sizing.s16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Jogadores (${roomData.players.length}/6)',
                style: textTheme.titleMedium,
              ),
              if (roomData.players.length < 2)
                Text(
                  'Precisa de\n2 a 6 jogadores',
                  textAlign: TextAlign.end,
                  style: textTheme.bodyMedium?.copyWith(color: CommonColors.errorColor, fontWeight: FontWeight.w600),
                ),
            ],
          ),
          SizedBox(height: Sizing.s16),
          ListView.separated(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: roomData.players.length,
            separatorBuilder: (context, index) => SizedBox(height: Sizing.s12),
            itemBuilder: (context, index) {
              final player = roomData.players[index];

              return PlayerCard(
                player: player,
                isCurrentPlayer: playerId == player.id,
                isCurrentPlayerHost: playerId == roomData.hostId,
                onTapKick: () => onTapKick(player),
              );
            },
          ),
          SizedBox(height: Sizing.s16),
        ],
      ),
    );
  }
}
