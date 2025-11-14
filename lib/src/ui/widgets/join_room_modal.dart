import 'package:coup/src/coup.dart';
import 'package:flutter/material.dart';

const String _JOIN_ROOM_STRING = 'Entrar em sala';

class JoinRoomModal extends StatefulWidget {
  const JoinRoomModal({super.key});

  @override
  State<JoinRoomModal> createState() => _JoinRoomModalState();
}

class _JoinRoomModalState extends State<JoinRoomModal> {
  late final textTheme = Theme.of(context).textTheme;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(Sizing.s24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            _JOIN_ROOM_STRING,
            style: textTheme.titleMedium?.copyWith(),
            textAlign: TextAlign.start,
          ),
        ],
      ),
    );
  }
}
