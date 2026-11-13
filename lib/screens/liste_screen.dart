import 'package:flutter/material.dart';
import '../models/destination.dart';
import '../services/destination_service.dart';
import '../state/programme_state.dart';
import '../widgets/destination_image.dart';
import 'detail_screen.dart';
import 'programme_screen.dart';

class ListeScreen extends StatefulWidget {
  final List<Destination> toutes;
  final ProgrammeState etat;

  const ListeScreen({super.key, required this.toutes, required this.etat});

  @override
  State<ListeScreen> createState() => _ListeScreenState();
}

class _ListeScreenState extends State<ListeScreen> {
  String _recherche = '';
  String? _categorie;

  void _ouvrirProgramme() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => ProgrammeScreen(etat: widget.etat)),
    );
  }

  void _ouvrirDetail(Destination d) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => DetailScreen(destination: d, etat: widget.etat),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final categories =
        widget.toutes.map((d) => d.categorie).toSet().toList()..sort();

    final resultats = DestinationService.filtrer(
      widget.toutes,
      recherche: _recherche,
      categorie: _categorie,
    );

    return Scaffold(
      floatingActionButton: ListenableBuilder(
        listenable: widget.etat,
        builder: (context, _) {
          final p = widget.etat.programme;
          final texte = p == null
              ? 'Créer mon programme'
              : '${p.destinations.length} lieu(x) · '
                  '${p.budgetRestant.toStringAsFixed(0)} TND restants';
          return FloatingActionButton.extended(
            onPressed: _ouvrirProgramme,
            icon: const Icon(Icons.luggage_rounded),
            label: Text(texte),
          );
        },
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Découvre la Tunisie',
                    style: theme.textTheme.headlineMedium
                        ?.copyWith(fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Compose ton programme selon ton budget',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Rechercher une destination',
                  prefixIcon: const Icon(Icons.search_rounded),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                ),
                onChanged: (valeur) {
                  setState(() => _recherche = valeur);
                },
              ),
            ),
            SizedBox(
              height: 48,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: const Text('Toutes'),
                      showCheckmark: false,
                      selected: _categorie == null,
                      onSelected: (_) {
                        setState(() => _categorie = null);
                      },
                    ),
                  ),
                  for (final c in categories)
                    Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ChoiceChip(
                        label: Text(c),
                        showCheckmark: false,
                        selected: _categorie == c,
                        onSelected: (_) {
                          setState(() => _categorie = c);
                        },
                      ),
                    ),
                ],
              ),
            ),
            Expanded(
              child: resultats.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.search_off_rounded,
                            size: 48,
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                          const SizedBox(height: 8),
                          const Text('Aucune destination trouvée'),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.fromLTRB(20, 8, 20, 96),
                      itemCount: resultats.length,
                      itemBuilder: (context, index) {
                        final d = resultats[index];
                        return _CarteDestination(
                          destination: d,
                          onTap: () => _ouvrirDetail(d),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CarteDestination extends StatelessWidget {
  final Destination destination;
  final VoidCallback onTap;

  const _CarteDestination({required this.destination, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: SizedBox(
          height: 200,
          child: Stack(
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
                    colors: [Colors.transparent, Colors.black87],
                  ),
                ),
              ),
              Positioned(
                left: 16,
                right: 16,
                bottom: 14,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      destination.nom,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.titleLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(
                          Icons.place_rounded,
                          size: 16,
                          color: Colors.white70,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          destination.ville,
                          style: const TextStyle(color: Colors.white70),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Positioned(
                top: 12,
                left: 12,
                child: _Pastille(texte: destination.categorie),
              ),
              Positioned(
                top: 12,
                right: 12,
                child: _Pastille(
                  texte: '${destination.cout.toStringAsFixed(0)} TND',
                ),
              ),
              Positioned.fill(
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(onTap: onTap),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Pastille extends StatelessWidget {
  final String texte;

  const _Pastille({required this.texte});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        texte,
        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
      ),
    );
  }
}