class Compte {
  final String id;
  final String userId;
  final double balance;
  final String currency;
  final DateTime updatedAt;
  final DateTime createdAt;
  final bool isMain;

  Compte({
    required this.id,
    required this.userId,
    required this.balance,
    required this.currency,
    required this.updatedAt,
    required this.createdAt,
    this.isMain = false,
  });

  /// Factory pour convertir un JSON en objet Compte
  factory Compte.fromJson(Map<String, dynamic> json) {
    return Compte(
      id: json['_id'] as String,
      userId: json['user_id'] as String,
      balance: (json['balance'] as num).toDouble(),
      currency: json['currency'] as String,
      updatedAt: DateTime.parse(json['updated_at']),
      createdAt: DateTime.parse(json['created_at']),
      isMain: json['is_main'] as bool,
    );
  }

  /// Méthode pour convertir un objet Compte en JSON
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'user_id': userId,
      'balance': balance,
      'currency': currency,
      'updated_at': updatedAt.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
      'is_main': isMain,
    };
  }
}
