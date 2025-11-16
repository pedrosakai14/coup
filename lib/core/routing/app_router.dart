import 'package:flutter/material.dart';
import 'package:coup/src/coup.dart';

class AppRouter {
  const AppRouter._();

  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case HomePage.routeName:
        return MaterialPageRoute(builder: (context) => const HomePage());

      case LobbyPage.routeName:
        final routeArgs = settings.arguments as LobbyPageArgs;
        return MaterialPageRoute(
          builder: (context) => LobbyPage(
            userName: routeArgs.userName,
            roomCode: routeArgs.roomCode,
          ),
        );

      case GamePage.routeName:
        return MaterialPageRoute(builder: (context) => const GamePage());
    }

    return null;
  }
}
