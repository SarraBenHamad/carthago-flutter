import 'package:flutter/material.dart';
import '../models/destination.dart';
import '../services/destination_service.dart';

class ListeScreen extends StatefulWidget {
  const ListeScreen({super.key});

  @override
  State<ListeScreen> createState() => _ListeScreenState();
}

class _ListeScreenState extends State<ListeScreen> {
  List<Destination> _toutes = [];
  String _recherche = '';
  String? _categorie; // null = toutes les catégories
  bool _chargement = true;

  @override
  void initState() {
    super.initState();
    _charger();
  }

  Future<void> _charger() async {
    final donnees = await DestinationService.charger();
    if (!mounted) return;
    setState(() {
      _toutes = donnees;
      _chargement = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final categories = _toutes.map((destination) => destination.categorie).toSet().toList()
      ..sort();

    final resultats = DestinationService.filtrer(
      _toutes,
      recherche: _recherche,
      categorie: _categorie,
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Carthago Pocket')),
      body: _chargement
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: TextField(
                    decoration: const InputDecoration(
                      hintText: 'Rechercher une destination',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (valeur) {
                      setState(() {
                        _recherche = valeur;
                      });
                    },
                  ),
                ),
                SizedBox(
                  height: 48,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: ChoiceChip(
                          label: const Text('Toutes'),
                          selected: _categorie == null,
                          onSelected: (_) {
                            setState(() {
                              _categorie = null;
                            });
                          },
                        ),
                      ),
                      for (final c in categories)
                        Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: ChoiceChip(
                            label: Text(c),
                            selected: _categorie == c,
                            onSelected: (_) {
                              setState(() {
                                _categorie = c;
                              });
                            },
                          ),
                        ),
                    ],
                  ),
                ),
                Expanded(
                  child: resultats.isEmpty
                      ? const Center(child: Text('Aucune destination trouvée'))
                      : ListView.builder(
                          itemCount: resultats.length,
                          itemBuilder: (context, index) {
                            final d = resultats[index];
                            return ListTile(
                              title: Text(d.nom),
                              subtitle: Text('${d.ville} · ${d.categorie}'),
                              trailing:
                                  Text('${d.cout.toStringAsFixed(0)} TND'),
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute<void>(
                                    builder: (context) => Scaffold(
                                      appBar: AppBar(title: Text(d.nom)),
                                      body: Padding(
                                        padding: const EdgeInsets.all(16),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text('${d.ville} · ${d.categorie}'),
                                            const SizedBox(height: 16),
                                            Text(d.description),
                                            const SizedBox(height: 16),
                                            Text('Coût : ${d.cout.toStringAsFixed(0)} TND'),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                ),
              ],
            ),
    );
  }
}
