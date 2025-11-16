import 'package:flutter/material.dart';
import 'package:coup/src/coup.dart';

class CommonChip extends StatelessWidget {
  final String text;
  final Color? backgroundColor;
  final BoxBorder? border;

  const CommonChip({
    super.key,
    required this.text,
    this.backgroundColor,
    this.border,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: Sizing.s8, vertical: Sizing.s4),
      decoration: BoxDecoration(
        color: backgroundColor ?? CommonColors.secondaryColor,
        borderRadius: CommonConstants.borderRadius16,
        border: border,
      ),
      child: Text(
        text,
        style: textTheme.bodySmall?.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
