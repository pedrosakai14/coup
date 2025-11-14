import 'package:flutter/material.dart';
import 'package:coup/src/coup.dart';

const String _modalSubtitleString = 'Digite seu nome para criar uma nova sala';
const String _userNameString = 'nome de usuário';

class CreateRoomModal extends StatefulWidget {
  const CreateRoomModal({super.key});

  @override
  State<CreateRoomModal> createState() => _CreateRoomModalState();
}

class _CreateRoomModalState extends State<CreateRoomModal> {
  late final textTheme = Theme.of(context).textTheme;
  late final TextEditingController controller;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController();
    controller.addListener(onTextChanged);
  }

  void onTextChanged() => setState(() {});

  @override
  void dispose() {
    controller.removeListener(onTextChanged);
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(Sizing.s24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            Strings.createRoom,
            style: textTheme.titleMedium?.copyWith(),
            textAlign: TextAlign.start,
          ),
          SizedBox(height: Sizing.s8),
          Text(
            _modalSubtitleString,
            style: textTheme.bodyMedium?.copyWith(
              color: Colors.black87,
            ),
            textAlign: TextAlign.start,
          ),
          SizedBox(height: Sizing.s24),
          TextFormField(
            controller: controller,
            maxLength: 30,
            onTapOutside: (PointerDownEvent event) => FocusScope.of(context).unfocus(),
            decoration: InputDecoration(
              label: Text(_userNameString),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(Sizing.s8)),
              ),
            ),
          ),
          SizedBox(height: Sizing.s16),
          CommonElevatedButton(
            onTap: controller.text.isNotEmpty
                ? () {
                    Navigator.of(context).popAndPushNamed(
                      LobbyPage.routeName,
                      arguments: {
                        'userName': controller.text,
                      }
                    );
                  }
                : null,
            text: Strings.btnContinue,
          ),
        ],
      ),
    );
  }
}
