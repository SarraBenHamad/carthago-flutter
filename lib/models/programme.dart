import 'destination.dart';

enum ResultatAjout { ok, doublon, budgetDepasse }

class Programme {
  final double budget;
  final List<Destination> _destinations = [];

  Programme(this.budget);

  List<Destination> get destinations => List.unmodifiable(_destinations);

  double get total {
    double somme = 0;
    for (final dest in _destinations) {
      somme += dest.cout;
    }
    return somme;
  }

  double get budgetRestant {
    return budget - total;
  }

  bool contient(Destination d) {
    for (final dest in _destinations) {
      if (dest.id == d.id) {
        return true;
      }
    } 
    return false;
  }

  ResultatAjout ajouter(Destination d) {
    if (contient(d)) {
      return ResultatAjout.doublon;
    }
    if (budgetRestant < d.cout) {
      return ResultatAjout.budgetDepasse;
    }
    _destinations.add(d);
    return ResultatAjout.ok;
  }

  void retirer(Destination d) {
    _destinations.removeWhere((dest) => dest.id == d.id);
  }
}