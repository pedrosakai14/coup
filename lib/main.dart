import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:coup/src/coup.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'coup',
      theme: getThemeData(context),
      onGenerateRoute: onGenerateRoute,
      home: HomePage(),
    );
  }

  ThemeData getThemeData(BuildContext context) {
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.white,
        primary: CommonColors.primaryColor,
      ),
      textTheme: Theme.of(context).textTheme.copyWith(
        titleMedium: Theme.of(context).textTheme.titleMedium?.copyWith(
          color: CommonColors.primaryColor,
        ),
        titleSmall: Theme.of(context).textTheme.titleSmall?.copyWith(
          color: CommonColors.primaryColor,
        ),
        bodyLarge: Theme.of(context).textTheme.bodyLarge?.copyWith(
          color: CommonColors.primaryColor,
        ),
        bodyMedium: Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: CommonColors.primaryColor,
        ),
      ),
    );
  }

  Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      case HomePage.routeName:
        return MaterialPageRoute(builder: (context) => HomePage());
      case LobbyPage.routeName:
        final routeArgs = args as Map<String, dynamic>? ?? {};
        return MaterialPageRoute(
          builder: (context) => LobbyPage(
            userName: routeArgs['userName'] as String,
            roomCode: routeArgs['roomCode'] as String?,
          ),
        );
    }

    return null;
  }
}
