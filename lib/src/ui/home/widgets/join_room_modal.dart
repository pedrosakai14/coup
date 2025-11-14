import 'package:coup/src/coup.dart';
import 'package:flutter/material.dart';

class JoinRoomModal extends StatefulWidget {
  const JoinRoomModal({super.key});

  @override
  State<JoinRoomModal> createState() => _JoinRoomModalState();
}

class _JoinRoomModalState extends State<JoinRoomModal> {
  late final textTheme = Theme.of(context).textTheme;
  late final TextEditingController userNameController;
  late final TextEditingController roomCodeController;

  @override
  void initState() {
    super.initState();
    userNameController = TextEditingController();
    userNameController.addListener(onTextChanged);

    roomCodeController = TextEditingController();
    roomCodeController.addListener(onTextChanged);
  }

  void onTextChanged() => setState(() {});

  @override
  void dispose() {
    userNameController.removeListener(onTextChanged);
    userNameController.dispose();

    roomCodeController.removeListener(onTextChanged);
    roomCodeController.dispose();
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
            Strings.joinRoom,
            style: textTheme.titleMedium?.copyWith(),
            textAlign: TextAlign.start,
          ),
          SizedBox(height: Sizing.s8),
          Text(
            'Digite seu nome para criar uma nova sala',
            style: textTheme.bodyMedium?.copyWith(),
            textAlign: TextAlign.start,
          ),
          SizedBox(height: Sizing.s24),
          TextFormField(
            controller: userNameController,
            maxLength: 30,
            onTapOutside: (PointerDownEvent event) => FocusScope.of(context).unfocus(),
            decoration: InputDecoration(
              label: Text('nome de usuário'),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(Sizing.s8)),
              ),
            ),
          ),
          SizedBox(height: Sizing.s16),
          TextFormField(
            controller: roomCodeController,
            maxLength: 6,
            onTapOutside: (PointerDownEvent event) => FocusScope.of(context).unfocus(),
            decoration: InputDecoration(
              label: Text('código da sala'),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(Sizing.s8)),
              ),
            ),
          ),
          SizedBox(height: Sizing.s16),
          CommonElevatedButton(
            onTap: userNameController.text.isNotEmpty && roomCodeController.text.isNotEmpty
                ? () {
                    Navigator.of(context).popAndPushNamed(LobbyPage.routeName);
                  }
                : null,
            text: Strings.btnContinue,
          ),
        ],
      ),
    );
  }
}
