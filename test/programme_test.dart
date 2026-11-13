import 'package:flutter_test/flutter_test.dart';
import 'package:carthago/models/destination.dart';
import 'package:carthago/models/programme.dart';

Destination fausse(String id, double cout) => Destination(
      id: id,
      nom: 'Test $id',
      ville: 'Tunis',
      categorie: 'Plage',
      description: 'Données de test',
      cout: cout,
    );

void main() {
  test('ajout normal : total et budget restant corrects', () {
    final p = Programme(100);
    final resultat = p.ajouter(fausse('a', 40));

    expect(resultat, ResultatAjout.ok);
    expect(p.total, 40);
    expect(p.budgetRestant, 60);
  });

  test('budget dépassé : la liste doit rester inchangée', () {
    final p = Programme(100);
    p.ajouter(fausse('a', 40));
    final resultat = p.ajouter(fausse('b', 70));

    expect(resultat, ResultatAjout.budgetDepasse);
    expect(p.total, 40);
    expect(p.budgetRestant, 60);
  });
  test('doublon : la liste doit rester inchangée', () {
    final p = Programme(100);
    p.ajouter(fausse('a', 40));
    final resultat = p.ajouter(fausse('a', 50));

    expect(resultat, ResultatAjout.doublon);
    expect(p.total, 40);
    expect(p.budgetRestant, 60);
  });
  test('ajout qui tombe exactement sur le budget', () {
    final p = Programme(100);
    p.ajouter(fausse('a', 40));
    final resultat = p.ajouter(fausse('b', 60));

    expect(resultat, ResultatAjout.ok);
    expect(p.total, 100);
    expect(p.budgetRestant, 0);
  });



}