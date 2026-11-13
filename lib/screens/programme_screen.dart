import 'package:flutter/material.dart';
import '../models/programme.dart';
import '../services/validation.dart';
import '../state/programme_state.dart';
import '../widgets/destination_image.dart';

class ProgrammeScreen extends StatefulWidget {
  final ProgrammeState etat;

  const ProgrammeScreen({super.key, required this.etat});

  @override
  State<ProgrammeScreen> createState() => _ProgrammeScreenState();
}

class _ProgrammeScreenState extends State<ProgrammeScreen> {
  final TextEditingController _controleur = TextEditingController();
  String? _erreur;

  @override
  void dispose() {
    _controleur.dispose();
    super.dispose();
  }

  void _creer() {
    final erreur = validerBudget(_controleur.text);
    if (erreur != null) {
      setState(() => _erreur = erreur);
      return;
    }
    setState(() => _erreur = null);
    widget.etat.creer(lireMontant(_controleur.text)!);
  }

  Future<void> _reinitialiser() async {
    final confirme = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Réinitialiser ?'),
        content: const Text('Le programme et son budget seront supprimés.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Annuler'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Supprimer'),
          ),
        ],
      ),
    );
    if (confirme == true) {
      _controleur.clear();
      widget.etat.supprimer();
    }
  }

  Widget _formulaire(BuildContext context) {
    final theme = Theme.of(context);
    final couleurs = theme.colorScheme;

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: couleurs.primaryContainer,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.savings_rounded,
                size: 48,
                color: couleurs.onPrimaryContainer,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Quel est ton budget ?',
              style: theme.textTheme.headlineSmall
                  ?.copyWith(fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 8),
            Text(
              'Chaque lieu ajouté sera déduit de ce montant.',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: couleurs.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 24),
            TextField(
              controller: _controleur,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                labelText: 'Budget en TND',
                filled: true,
                fillColor: Colors.white,
                errorText: _erreur,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                style: FilledButton.styleFrom(
                  minimumSize: const Size.fromHeight(52),
                ),
                onPressed: _creer,
                child: const Text('Créer le programme'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _carteBudget(BuildContext context, Programme programme) {
    final couleurs = Theme.of(context).colorScheme;
    final progression =
        (programme.total / programme.budget).clamp(0.0, 1.0).toDouble();

    return Container(
      margin: const EdgeInsets.fromLTRB(20, 8, 20, 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [couleurs.primary, couleurs.primary.withOpacity(0.7)],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Budget restant',
            style: TextStyle(color: Colors.white70),
          ),
          const SizedBox(height: 4),
          Text(
            '${programme.budgetRestant.toStringAsFixed(0)} TND',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 36,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: progression,
              minHeight: 8,
              backgroundColor: Colors.white24,
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Dépensé : ${programme.total.toStringAsFixed(0)} TND '
            'sur ${programme.budget.toStringAsFixed(0)} TND',
            style: const TextStyle(color: Colors.white70),
          ),
        ],
      ),
    );
  }

  Widget _ligne(BuildContext context, Programme programme, int index) {
    final theme = Theme.of(context);
    final d = programme.destinations[index];

    return Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 12),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: SizedBox(
              width: 64,
              height: 64,
              child: DestinationImage(id: d.id),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  d.nom,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleMedium
                      ?.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 2),
                Text(
                  '${d.ville} · ${d.cout.toStringAsFixed(0)} TND',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline_rounded),
            tooltip: 'Retirer',
            onPressed: () => widget.etat.retirer(d),
          ),
        ],
      ),
    );
  }

  Widget _resume(BuildContext context, Programme programme) {
    final couleurs = Theme.of(context).colorScheme;

    return Column(
      children: [
        _carteBudget(context, programme),
        Expanded(
          child: programme.destinations.isEmpty
              ? Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.map_outlined,
                        size: 48,
                        color: couleurs.onSurfaceVariant,
                      ),
                      const SizedBox(height: 8),
                      const Text('Aucune destination ajoutée.'),
                    ],
                  ),
                )
              : ListView.builder(
                  itemCount: programme.destinations.length,
                  itemBuilder: (context, index) =>
                      _ligne(context, programme, index),
                ),
        ),
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: TextButton.icon(
              onPressed: _reinitialiser,
              icon: const Icon(Icons.restart_alt_rounded),
              label: const Text('Réinitialiser le programme'),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mon programme')),
      body: ListenableBuilder(
        listenable: widget.etat,
        builder: (context, _) {
          final programme = widget.etat.programme;
          if (programme == null) {
            return _formulaire(context);
          }
          return _resume(context, programme);
        },
      ),
    );
  }
}