import 'package:flutter/material.dart';
import 'package:coup/src/coup.dart';

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
    return SingleChildScrollView(
      padding: EdgeInsets.all(Sizing.s24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            Strings.createRoom,
            textAlign: TextAlign.start,
            style: textTheme.titleMedium?.copyWith(),
          ),
          SizedBox(height: Sizing.s8),
          Text(
            Strings.createRoomModalSubtitle,
            textAlign: TextAlign.start,
            style: textTheme.bodyMedium?.copyWith(
              color: CommonColors.tertiaryColor,
            ),
          ),
          SizedBox(height: Sizing.s24),
          TextFormField(
            controller: controller,
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
          CommonElevatedButton(
            onTap: controller.text.isNotEmpty
                ? () {
                    Navigator.of(context).popAndPushNamed(
                      LobbyPage.routeName,
                      arguments: LobbyPageArgs(
                        userName: controller.text,
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
