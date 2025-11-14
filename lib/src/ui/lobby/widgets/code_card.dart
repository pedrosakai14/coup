import 'package:coup/src/coup.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CodeCard extends StatelessWidget {
  final String roomCode;

  const CodeCard({
    super.key,
    required this.roomCode,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Container(
      decoration: BoxDecoration(color: Color(0xFFd1dae4), borderRadius: BorderRadius.all(Radius.circular(Sizing.s20))),
      padding: EdgeInsets.symmetric(vertical: Sizing.s16),
      child: Column(
        children: [
          Text(
            'Código da Sala',
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
              onPressed: () async {
                await Clipboard.setData(ClipboardData(text: roomCode));
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Código copiado com sucesso',
                      style: textTheme.bodyMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    backgroundColor: CommonColors.secondaryColor,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                overlayColor: CommonColors.secondaryColor,
                side: BorderSide(
                  color: CommonColors.primaryColor,
                  width: 1.0,
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
                    'Copiar código',
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
