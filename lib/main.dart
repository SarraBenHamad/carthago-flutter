import 'package:flutter/material.dart';
import 'screens/liste_screen.dart';
import 'state/programme_state.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  final ProgrammeState _etat = ProgrammeState();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Carthago Pocket',
      theme: ThemeData(colorSchemeSeed: Colors.teal, useMaterial3: true),
      home: ListeScreen(etat: _etat),
    );
  }
}