double? lireMontant(String saisie) {
  return double.tryParse(saisie.trim().replaceAll(',', '.'));
}

String? validerBudget(String saisie) {
  if (saisie.trim().isEmpty) {
    return 'Saisis un budget.';
  }
  final montant = lireMontant(saisie);
  if (montant == null || montant.isNaN || montant.isInfinite) {
    return 'Le budget doit être un nombre.';
  }
  if (montant <= 0) {
    return 'Le budget doit être supérieur à 0.';
  }
  return null;
}