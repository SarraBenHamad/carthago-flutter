import 'package:flutter/foundation.dart';
import '../models/destination.dart';
import '../models/programme.dart';

class ProgrammeState extends ChangeNotifier {
  Programme? _programme;

  Programme? get programme => _programme;

  void creer(double budget) {
    _programme = Programme(budget);
    notifyListeners();
  }

  void supprimer() {
    _programme = null;
    notifyListeners();
  }

  ResultatAjout ajouter(Destination d) {
    final resultat = _programme!.ajouter(d);
    if (resultat == ResultatAjout.ok) {
      notifyListeners();
    }
    return resultat;
  }

  void retirer(Destination d) {
    _programme?.retirer(d);
    notifyListeners();
  }
}