import 'package:flutter/material.dart';

class GameLoadedView extends StatefulWidget {
  const GameLoadedView({super.key});

  @override
  State<GameLoadedView> createState() => _GameLoadedViewState();
}

class _GameLoadedViewState extends State<GameLoadedView> {
  @override
  Widget build(BuildContext context) {
    return const Text('game');
  }
}
