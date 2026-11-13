import 'package:flutter/material.dart';
import 'screens/liste_screen.dart';
import 'services/destination_service.dart';

void main() async {
 runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
          title: 'Carthago Pocket',
          theme: ThemeData(colorSchemeSeed: Colors.teal, useMaterial3: true),
          home: const ListeScreen(),
        );
      }
}
