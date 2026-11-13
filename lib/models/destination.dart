class Destination {
  final String id;
  final String nom;
  final String ville;
  final String categorie;
  final String description;
  final double cout;

  Destination({
    required this.id,
    required this.nom,
    required this.ville,
    required this.categorie,
    required this.description,
    required this.cout,
  });

//transformer json en un edestination
  factory Destination.fromJson(Map<String, dynamic> json) {
    return Destination(
      id: json['id'] as String,
      nom: json['nom'] as String,
      ville: json['ville'] as String,
      categorie: json['categorie'] as String,
      description: json['description'] as String,
      cout: (json['cout'] as num).toDouble(),
    );
  }
}
//mes notes: final une destination ne change plus une fois elle est crée