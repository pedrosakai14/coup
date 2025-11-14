import 'package:flutter/material.dart';
import 'package:coup/src/coup.dart';

class CommonElevatedButton extends StatelessWidget {
  final String text;
  final VoidCallback? onTap;

  const CommonElevatedButton({
    super.key,
    required this.text,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(
          vertical: Sizing.s16,
          horizontal: Sizing.s16,
        ),
        elevation: 0.0,
        backgroundColor: Color(0xFF5d2842),
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
    );
  }
}
