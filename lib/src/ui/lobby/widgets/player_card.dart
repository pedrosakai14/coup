import 'package:coup/src/coup.dart';
import 'package:flutter/material.dart';

class PlayerCard extends StatelessWidget {
  final Player player;

  const PlayerCard({
    required this.player,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Container(
      padding: EdgeInsets.all(Sizing.s16),
      decoration: BoxDecoration(
        color: Color(0xFFEEEEEE),
        borderRadius: BorderRadius.all(Radius.circular(Sizing.s16)),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: CommonColors.backgroundPrimaryColor,
            child: Text(
              player.name.characters.first,
              style: textTheme.bodyLarge?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          SizedBox(width: Sizing.s12),
          Text(
            player.name,
            style: textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
