import 'package:flutter/material.dart';

import 'services/destination_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final destinations = await DestinationService.charger();
  debugPrint('Destinations chargées : ${destinations.length}');
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        body: Center(
          child: Text('Hello World!'),
        ),
      ),
    );
  }
}
