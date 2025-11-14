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
      builder: (context) {
        return SafeArea(
          child: ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(Sizing.s8),
              topRight: Radius.circular(Sizing.s8),
            ),
            child: isCreate ? CreateRoomModal() : JoinRoomModal(),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              height: 300.0,
              width: MediaQuery.sizeOf(context).width,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0xFF151515).withValues(alpha: 0.0),
                      Color(0xFF151515),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(right: Sizing.s24, left: Sizing.s24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                CommonElevatedButton(
                  onTap: () => onTap(isCreate: false),
                  text: Strings.joinRoom,
                ),
                SizedBox(height: Sizing.s16),
                CommonElevatedButton(
                  onTap: () => onTap(isCreate: true),
                  text: Strings.createRoom,
                ),
                SizedBox(height: Sizing.s24),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
