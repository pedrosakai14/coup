import 'package:flutter/material.dart';
import 'package:coup/src/coup.dart';

class GameAppBar extends StatelessWidget implements PreferredSizeWidget {
  const GameAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      titleSpacing: 0,
      automaticallyImplyLeading: false,
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: <Color>[
              CommonColors.secondaryColor,
              CommonColors.errorColor,
            ],
          ),
        ),
      ),
      title: Row(
        children: [
          SizedBox(width: Sizing.s12),
          CommonChip(
            text: '0HVXY',
            backgroundColor: Colors.transparent,
            border: BoxBorder.fromBorderSide(
              BorderSide(width: Sizing.s1, color: CommonColors.white),
            ),
          ),
          SizedBox(width: Sizing.s12),
          CommonChip(
            text: 'Seu turno',
            backgroundColor: CommonColors.backgroundSecondaryDarkColor,
          ),
        ],
      ),
      actions: [
        IconButton(
          onPressed: () {},
          icon: Icon(
            Icons.exit_to_app,
            color: CommonColors.white,
          ),
        ),
      ],
    );
  }
}
