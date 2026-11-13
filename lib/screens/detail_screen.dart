import 'package:flutter/material.dart';
import '../models/destination.dart';
import '../models/programme.dart';
import '../state/programme_state.dart';
import 'programme_screen.dart';

class DetailScreen extends StatelessWidget {
  final Destination destination;
  final ProgrammeState etat;

  const DetailScreen({
    super.key,
    required this.destination,
    required this.etat,
  });

  void _ajouter(BuildContext context) {
    final resultat = etat.ajouter(destination);
    final restant = etat.programme!.budgetRestant.toStringAsFixed(0);

    String message;
    switch (resultat) {
      case ResultatAjout.ok:
        message = '${destination.nom} ajoutée. Budget restant : $restant TND';
        break;
      case ResultatAjout.doublon:
        message = 'Cette destination est déjà dans ton programme.';
        break;
      case ResultatAjout.budgetDepasse:
        message = 'Budget dépassé : il te reste $restant TND, '
            'cette destination coûte ${destination.cout.toStringAsFixed(0)} TND.';
        break;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: etat,
      builder: (context, _) {
        final programme = etat.programme;
        final dejaAjoutee = programme?.contient(destination) ?? false;

        Widget action;
        if (programme == null) {
          action = Column(
            children: [
              const Text(
                'Crée d\'abord un programme avec un budget pour ajouter des destinations.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              FilledButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ProgrammeScreen(etat: etat),
                    ),
                  );
                },
                child: const Text('Créer mon programme'),
              ),
            ],
          );
        } else if (dejaAjoutee) {
          action = OutlinedButton(
            onPressed: () => etat.retirer(destination),
            child: const Text('Retirer du programme'),
          );
        } else {
          action = FilledButton(
            onPressed: () => _ajouter(context),
            child: const Text('Ajouter au programme'),
          );
        }

        return Scaffold(
          appBar: AppBar(title: Text(destination.nom)),
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${destination.ville} · ${destination.categorie}',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 16),
                Text(destination.description),
                const SizedBox(height: 16),
                Text(
                  'Coût estimatif : ${destination.cout.toStringAsFixed(0)} TND',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                if (programme != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    'Budget restant : ${programme.budgetRestant.toStringAsFixed(0)} TND',
                  ),
                ],
                const Spacer(),
                SizedBox(width: double.infinity, child: action),
              ],
            ),
          ),
        );
      },
    );
  }
}