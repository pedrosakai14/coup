import 'package:coup/src/coup.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  static const String routeName = '/home-page';

  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  void onTap({required bool isCreate}) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      builder: (context) {
        return SafeArea(
          child: ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(Sizing.s8),
              topRight: Radius.circular(Sizing.s8),
            ),
            child: Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: isCreate ? CreateRoomModal() : JoinRoomModal(),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image(
            image: AssetImage(Assets.homePage),
            fit: BoxFit.cover,
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: SizedBox(
              height: Sizing.s300,
              width: MediaQuery.sizeOf(context).width,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      CommonColors.black.withValues(alpha: 0.0),
                      CommonColors.black,
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CommonElevatedButton(
                onTap: () => onTap(isCreate: false),
                text: Strings.joinRoom,
                horizontalPadding: Sizing.s24,
              ),
              CommonElevatedButton(
                onTap: () => onTap(isCreate: true),
                text: Strings.createRoom,
                horizontalPadding: Sizing.s24,
                verticalPadding: Sizing.s20,
              ),
              SizedBox(height: Sizing.s12),
            ],
          ),
        ],
      ),
    );
  }
}
