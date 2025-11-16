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
    return SingleChildScrollView(
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
            Strings.joinRoomModalSubtitle,
            style: textTheme.bodyMedium?.copyWith(),
            textAlign: TextAlign.start,
          ),
          SizedBox(height: Sizing.s24),
          TextFormField(
            controller: userNameController,
            maxLength: CommonConstants.NAME_MAX_LENGTH,
            onTapOutside: (PointerDownEvent event) => FocusScope.of(context).unfocus(),
            decoration: InputDecoration(
              label: Text(Strings.username),
              border: OutlineInputBorder(
                borderRadius: CommonConstants.borderRadius8,
              ),
            ),
          ),
          SizedBox(height: Sizing.s16),
          TextFormField(
            controller: roomCodeController,
            maxLength: 5,
            onTapOutside: (PointerDownEvent event) => FocusScope.of(context).unfocus(),
            decoration: InputDecoration(
              label: Text(Strings.roomCode),
              border: OutlineInputBorder(
                borderRadius: CommonConstants.borderRadius8,
              ),
            ),
          ),
          SizedBox(height: Sizing.s16),
          CommonElevatedButton(
            onTap: userNameController.text.isNotEmpty && roomCodeController.text.isNotEmpty
                ? () {
                    Navigator.of(context).popAndPushNamed(
                      LobbyPage.routeName,
                      arguments: LobbyPageArgs(
                        userName: userNameController.text,
                        roomCode: roomCodeController.text,
                      ),
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
