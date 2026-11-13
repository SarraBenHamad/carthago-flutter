import 'package:flutter/material.dart';
import 'models/destination.dart';
import 'screens/liste_screen.dart';
import 'services/destination_service.dart';
import 'state/programme_state.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  final ProgrammeState _etat = ProgrammeState();
  late final Future<List<Destination>> _chargement = _demarrer();

  Future<List<Destination>> _demarrer() async {
    final toutes = await DestinationService.charger();
    await _etat.restaurer(toutes);
    return toutes;
  }

  @override
  Widget build(BuildContext context) {
    const fond = Color(0xFFF7F5F0);

    return MaterialApp(
      title: 'Carthago Pocket',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF0B7A75)),
        scaffoldBackgroundColor: fond,
        appBarTheme: const AppBarTheme(
          backgroundColor: fond,
          surfaceTintColor: Colors.transparent,
          scrolledUnderElevation: 0,
        ),
      ),
      home: FutureBuilder<List<Destination>>(
        future: _chargement,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Scaffold(
              body: Center(
                child: Padding(
                  padding: EdgeInsets.all(24),
                  child: Text(
                    'Impossible de charger les destinations.',
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            );
          }
          if (!snapshot.hasData) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
          return ListeScreen(toutes: snapshot.data!, etat: _etat);
        },
      ),
    );
  }
}