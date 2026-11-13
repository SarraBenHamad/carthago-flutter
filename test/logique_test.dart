import 'package:flutter_test/flutter_test.dart';
import 'package:carthago/models/destination.dart';
import 'package:carthago/services/destination_service.dart';
import 'package:carthago/services/validation.dart';

Destination dest(String id, String nom, String categorie) => Destination(
      id: id,
      nom: nom,
      ville: 'Tunis',
      categorie: categorie,
      description: 'Données de test',
      cout: 50,
    );

void main() {
  final donnees = [
    dest('a', 'Île de Djerba', 'Plage'),
    dest('b', 'Sidi Bou Saïd', 'Patrimoine'),
    dest('c', 'Plage de Hammamet', 'Plage'),
  ];

  test('recherche insensible aux majuscules', () {
    final r = DestinationService.filtrer(donnees, recherche: 'djerba');
    expect(r.length, 1);
    expect(r.first.id, 'a');
  });

  test('filtre par catégorie', () {
    final r = DestinationService.filtrer(donnees, categorie: 'Plage');
    expect(r.length, 2);
  });

  test('recherche sans résultat : liste vide', () {
    final r = DestinationService.filtrer(donnees, recherche: 'zzz');
    expect(r, isEmpty);
  });

  test('budget valide avec virgule', () {
    expect(validerBudget('150,5'), isNull);
    expect(lireMontant('150,5'), 150.5);
  });

  test('budget vide refusé', () {
    expect(validerBudget('  '), isNotNull);
  });

  test('budget non numérique refusé', () {
    expect(validerBudget('abc'), isNotNull);
  });

  test('budget négatif ou nul refusé', () {
    expect(validerBudget('0'), isNotNull);
    expect(validerBudget('-20'), isNotNull);
  });
}