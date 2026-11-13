import 'package:flutter/material.dart';
import '../models/destination.dart';
import '../models/programme.dart';
import '../state/programme_state.dart';
import '../widgets/destination_image.dart';
import 'programme_screen.dart';

const Size _tailleBouton = Size.fromHeight(52);

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
    final ok = resultat == ResultatAjout.ok;

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
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: ok ? null : Theme.of(context).colorScheme.error,
        content: Text(
          message,
          style: TextStyle(color: ok ? null : Colors.white),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final couleurs = theme.colorScheme;

    return ListenableBuilder(
      listenable: etat,
      builder: (context, _) {
        final programme = etat.programme;
        final dejaAjoutee = programme?.contient(destination) ?? false;

        Widget action;
        if (programme == null) {
          action = FilledButton.icon(
            style: FilledButton.styleFrom(minimumSize: _tailleBouton),
            icon: const Icon(Icons.luggage_rounded),
            label: const Text('Créer mon programme'),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => ProgrammeScreen(etat: etat)),
              );
            },
          );
        } else if (dejaAjoutee) {
          action = OutlinedButton.icon(
            style: OutlinedButton.styleFrom(minimumSize: _tailleBouton),
            icon: const Icon(Icons.remove_circle_outline_rounded),
            label: const Text('Retirer du programme'),
            onPressed: () => etat.retirer(destination),
          );
        } else {
          action = FilledButton.icon(
            style: FilledButton.styleFrom(minimumSize: _tailleBouton),
            icon: const Icon(Icons.add_rounded),
            label: const Text('Ajouter au programme'),
            onPressed: () => _ajouter(context),
          );
        }

        return Scaffold(
          body: CustomScrollView(
            slivers: [
              SliverAppBar(
                pinned: true,
                expandedHeight: 300,
                foregroundColor: Colors.white,
                backgroundColor: couleurs.primary,
                flexibleSpace: FlexibleSpaceBar(
                  title: Text(
                    destination.nom,
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      Hero(
                        tag: 'img-${destination.id}',
                        child: DestinationImage(id: destination.id),
                      ),
                      const DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [Colors.black26, Colors.black54],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Wrap(
                        spacing: 8,
                        children: [
                          Chip(
                            avatar: const Icon(Icons.place_rounded, size: 18),
                            label: Text(destination.ville),
                          ),
                          Chip(label: Text(destination.categorie)),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        destination.description,
                        style: theme.textTheme.bodyLarge?.copyWith(height: 1.5),
                      ),
                      const SizedBox(height: 20),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.payments_rounded, color: couleurs.primary),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Coût estimatif',
                                    style: theme.textTheme.titleMedium,
                                  ),
                                  Text(
                                    'Valeur indicative',
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: couleurs.onSurfaceVariant,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              '${destination.cout.toStringAsFixed(0)} TND',
                              style: theme.textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.w800,
                                color: couleurs.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (programme != null) ...[
                        const SizedBox(height: 12),
                        Text(
                          'Budget restant : '
                          '${programme.budgetRestant.toStringAsFixed(0)} TND',
                          style: theme.textTheme.bodyMedium,
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
          bottomNavigationBar: SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
              child: action,
            ),
          ),
        );
      },
    );
  }
}