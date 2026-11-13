import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:carthago/models/destination.dart';
import 'package:carthago/state/programme_state.dart';

Destination dest(String id, double cout) => Destination(
      id: id,
      nom: 'Test $id',
      ville: 'Tunis',
      categorie: 'Plage',
      description: 'Données de test',
      cout: cout,
    );

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final toutes = [dest('a', 40), dest('b', 60)];

  test('le programme est restauré après un redémarrage', () async {
    SharedPreferences.setMockInitialValues({});

    final avant = ProgrammeState();
    avant.creer(200);
    avant.ajouter(toutes[0]);
    await Future.delayed(const Duration(milliseconds: 50));

    final apres = ProgrammeState();
    await apres.restaurer(toutes);

    expect(apres.programme, isNotNull);
    expect(apres.programme!.budget, 200);
    expect(apres.programme!.destinations.length, 1);
    expect(apres.programme!.destinations.first.id, 'a');
  });

  test('sans sauvegarde : aucun programme', () async {
    SharedPreferences.setMockInitialValues({});

    final etat = ProgrammeState();
    await etat.restaurer(toutes);

    expect(etat.programme, isNull);
  });

  test('données sauvegardées corrompues : pas de plantage', () async {
    SharedPreferences.setMockInitialValues({'budget': 'abc'});

    final etat = ProgrammeState();
    await etat.restaurer(toutes);

    expect(etat.programme, isNull);
  });
}