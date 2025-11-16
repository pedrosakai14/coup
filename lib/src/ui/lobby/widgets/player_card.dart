import 'package:coup/src/coup.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PlayerCard extends StatelessWidget {
  final Player player;
  final bool isCurrentPlayer;
  final bool isCurrentPlayerHost;
  final VoidCallback onTapKick;

  const PlayerCard({
    super.key,
    required this.player,
    required this.isCurrentPlayer,
    required this.isCurrentPlayerHost,
    required this.onTapKick,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Container(
      padding: EdgeInsets.all(Sizing.s16),
      decoration: BoxDecoration(
        color: CommonColors.backgroundSecondaryCardColor,
        borderRadius: CommonConstants.borderRadius16,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: CommonColors.backgroundPrimaryColor,
                child: player.isHost
                    ? Padding(
                        padding: EdgeInsets.only(bottom: Sizing.s2, right: Sizing.s4),
                        child: Icon(
                          AppIcons.crown,
                          size: Sizing.s18,
                          color: CommonColors.secondaryColor,
                        ),
                      )
                    : Text(
                        player.name.characters.first.toUpperCase(),
                        style: textTheme.bodyLarge?.copyWith(
                          color: CommonColors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
              ),
              SizedBox(width: Sizing.s12),
              Text(
                player.name,
                style: textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w500),
              ),
              SizedBox(width: Sizing.s8),
              if (isCurrentPlayer)
                Container(
                  padding: EdgeInsets.symmetric(horizontal: Sizing.s8, vertical: Sizing.s4),
                  decoration: BoxDecoration(
                    color: CommonColors.secondaryColor,
                    borderRadius: CommonConstants.borderRadius16,
                  ),
                  child: Text(
                    Strings.you,
                    style: textTheme.bodySmall?.copyWith(color: Colors.white, fontWeight: FontWeight.w600),
                  ),
                ),
              SizedBox(width: Sizing.s8),
              if (player.isHost)
                Container(
                  padding: EdgeInsets.symmetric(horizontal: Sizing.s8, vertical: Sizing.s4),
                  decoration: BoxDecoration(
                    color: CommonColors.secondaryColor,
                    borderRadius: CommonConstants.borderRadius16,
                  ),
                  child: Text(
                    Strings.host,
                    style: textTheme.bodySmall?.copyWith(color: Colors.white, fontWeight: FontWeight.w600),
                  ),
                ),
            ],
          ),
          if (!player.isHost && !isCurrentPlayer && isCurrentPlayerHost)
            Row(
              children: [
                GestureDetector(
                  onTap: onTapKick,
                  child: Icon(
                    CupertinoIcons.person_crop_circle_badge_xmark,
                    color: CommonColors.errorColor,
                    size: Sizing.s28,
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
