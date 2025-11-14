import 'package:flutter/material.dart';
import 'package:coup/src/coup.dart';

class CommonElevatedButton extends StatelessWidget {
  final String text;
  final VoidCallback? onTap;
  final double horizontalPadding;
  final double verticalPadding;

  const CommonElevatedButton({
    super.key,
    required this.text,
    this.onTap,
    this.horizontalPadding = 0.0,
    this.verticalPadding = 0.0,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: verticalPadding),
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(
            vertical: Sizing.s16,
            horizontal: Sizing.s16,
          ),
          elevation: 0.0,
          backgroundColor: CommonColors.backgroundPrimaryColor,
          disabledBackgroundColor: Color(0xFFadadad),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(Sizing.s8)),
          ),
        ),
        child: Text(
          text,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
