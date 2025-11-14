import 'package:coup/src/coup.dart';
import 'package:coup/src/ui/lobby/widgets/code_card.dart';
import 'package:coup/src/ui/lobby/widgets/player_card.dart';
import 'package:flutter/material.dart';

class LobbyLoadedView extends StatefulWidget {
  final Room roomData;

  const LobbyLoadedView({
    super.key,
    required this.roomData,
  });

  @override
  State<LobbyLoadedView> createState() => _LobbyLoadedViewState();
}

class _LobbyLoadedViewState extends State<LobbyLoadedView> {
  late final textTheme = Theme.of(context).textTheme;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: Sizing.s16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: Sizing.s12),
          CodeCard(roomCode: widget.roomData.code),
          SizedBox(height: Sizing.s16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Jogadores (${widget.roomData.players.length}/6)',
                style: textTheme.titleMedium,
              ),
              if (widget.roomData.players.length < 2)
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
            itemCount: widget.roomData.players.length,
            separatorBuilder: (context, index) => SizedBox(height: Sizing.s12),
            itemBuilder: (context, index) {
              final player = widget.roomData.players[index];

              return PlayerCard(player: player);
            },
          ),
        ],
      ),
    );
  }
}
