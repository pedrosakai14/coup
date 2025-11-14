import 'package:flutter/material.dart';
import 'package:coup/src/coup.dart';

const String _CREATE_ROOM_STRING = 'Criar sala';

class CreateRoomModal extends StatefulWidget {
  const CreateRoomModal({super.key});

  @override
  State<CreateRoomModal> createState() => _CreateRoomModalState();
}

class _CreateRoomModalState extends State<CreateRoomModal> {
  late final textTheme = Theme.of(context).textTheme;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(Sizing.s24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            _CREATE_ROOM_STRING,
            style: textTheme.titleMedium?.copyWith(),
            textAlign: TextAlign.start,
          ),
        ],
      ),
    );
  }
}
