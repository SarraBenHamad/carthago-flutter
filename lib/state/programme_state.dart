import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/destination.dart';
import '../models/programme.dart';

class ProgrammeState extends ChangeNotifier {
  static const String _cleBudget = 'budget';
  static const String _cleIds = 'ids';

  Programme? _programme;

  Programme? get programme => _programme;

  Future<void> restaurer(List<Destination> toutes) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final budget = prefs.getDouble(_cleBudget);
      if (budget == null || budget <= 0) return;

      final ids = prefs.getStringList(_cleIds) ?? [];
      final restaure = Programme(budget);
      for (final id in ids) {
        for (final d in toutes) {
          if (d.id == id) {
            restaure.ajouter(d);
            break;
          }
        }
      }
      _programme = restaure;
    } catch (_) {
      _programme = null;
    }
  }

  Future<void> _sauvegarder() async {
    final prefs = await SharedPreferences.getInstance();
    final p = _programme;
    if (p == null) {
      await prefs.remove(_cleBudget);
      await prefs.remove(_cleIds);
      return;
    }
    await prefs.setDouble(_cleBudget, p.budget);
    await prefs.setStringList(
      _cleIds,
      p.destinations.map((d) => d.id).toList(),
    );
  }

  void creer(double budget) {
    _programme = Programme(budget);
    notifyListeners();
    _sauvegarder();
  }

  void supprimer() {
    _programme = null;
    notifyListeners();
    _sauvegarder();
  }

  ResultatAjout ajouter(Destination d) {
    final resultat = _programme!.ajouter(d);
    if (resultat == ResultatAjout.ok) {
      notifyListeners();
      _sauvegarder();
    }
    return resultat;
  }

  void retirer(Destination d) {
    _programme?.retirer(d);
    notifyListeners();
    _sauvegarder();
  }
}