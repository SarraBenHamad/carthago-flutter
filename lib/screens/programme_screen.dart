import 'package:flutter/material.dart';
import '../models/programme.dart';
import '../services/validation.dart';
import '../state/programme_state.dart';

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

  Widget _formulaire() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Quel est ton budget pour ce programme ?',
            style: TextStyle(fontSize: 18),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _controleur,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(
              labelText: 'Budget en TND',
              border: const OutlineInputBorder(),
              errorText: _erreur,
            ),
          ),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: _creer,
            child: const Text('Créer le programme'),
          ),
        ],
      ),
    );
  }

  Widget _resume(Programme programme) {
    final progression = (programme.total / programme.budget).clamp(0.0, 1.0);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Budget : ${programme.budget.toStringAsFixed(0)} TND'),
              Text('Total : ${programme.total.toStringAsFixed(0)} TND'),
              Text(
                'Restant : ${programme.budgetRestant.toStringAsFixed(0)} TND',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              LinearProgressIndicator(value: progression, minHeight: 8),
            ],
          ),
        ),
        Expanded(
          child: programme.destinations.isEmpty
              ? const Center(child: Text('Aucune destination ajoutée.'))
              : ListView.builder(
                  itemCount: programme.destinations.length,
                  itemBuilder: (context, index) {
                    final d = programme.destinations[index];
                    return ListTile(
                      title: Text(d.nom),
                      subtitle: Text(
                        '${d.ville} · ${d.cout.toStringAsFixed(0)} TND',
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete_outline),
                        tooltip: 'Retirer',
                        onPressed: () => widget.etat.retirer(d),
                      ),
                    );
                  },
                ),
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: TextButton(
            onPressed: () {
              _controleur.clear();
              widget.etat.supprimer();
            },
            child: const Text('Réinitialiser le programme'),
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
            return _formulaire();
          }
          return _resume(programme);
        },
      ),
    );
  }
}