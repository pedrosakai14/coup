import 'package:coup/src/coup.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CodeCard extends StatelessWidget {
  final String roomCode;
  final VoidCallback onTap;

  const CodeCard({
    super.key,
    required this.roomCode,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Container(
      decoration: BoxDecoration(
        color: CommonColors.backgroundPrimaryCardColor,
        borderRadius: CommonConstants.borderRadius20,
      ),
      padding: EdgeInsets.symmetric(vertical: Sizing.s16),
      child: Column(
        children: [
          Text(
            Strings.roomCode,
            style: textTheme.titleSmall?.copyWith(
              color: CommonColors.primaryColor,
            ),
          ),
          SizedBox(height: Sizing.s8),
          Text(
            roomCode.characters.map((e) => '$e ').toList().join(),
            style: textTheme.titleLarge?.copyWith(
              color: CommonColors.primaryColor,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: Sizing.s12),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: Sizing.s16),
            child: ElevatedButton(
              onPressed: onTap,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                overlayColor: CommonColors.secondaryColor,
                side: BorderSide(
                  color: CommonColors.primaryColor,
                  width: Sizing.s1,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.copy,
                    color: CommonColors.primaryColor,
                  ),
                  SizedBox(width: Sizing.s8),
                  Text(
                    Strings.codeCardCopyCodeBtn,
                    style: textTheme.bodyMedium?.copyWith(
                      color: CommonColors.primaryColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
