class User {
  final String id;
  final String telephone;
  final String email;
  final String nom;
  final String prenom;
  final String typePiece;
  final String numero;
  final String adresse;
  final String code;

  final DateTime? createdAt; // géré automatiquement
  final DateTime? updatedAt; // géré automatiquement

  const User({
    required this.id,
    required this.telephone,
    required this.email,
    required this.nom,
    required this.prenom,
    required this.typePiece,
    required this.numero,
    required this.adresse,
    required this.code,
    this.createdAt,
    this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'] ?? '',
      telephone: json['telephone'] ?? '',
      email: json['email'] ?? '',
      nom: json['nom'] ?? '',
      prenom: json['prenom'] ?? '',
      typePiece: json['type_piece'] ?? '',
      numero: json['numero'] ?? '',
      adresse: json['adresse'] ?? '',
      code: json['code'] ?? '',
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'telephone': telephone,
      'email': email,
      'nom': nom,
      'prenom': prenom,
      'type_piece': typePiece,
      'numero': numero,
      'adresse': adresse,
      'code': code,
      // ❌ n'envoie pas createdAt / updatedAt car gérés par ton système
    };
  }
}
