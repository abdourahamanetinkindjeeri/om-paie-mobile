import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Service de stockage sécurisé pour les données sensibles (tokens, credentials)
class SecureStorage {
  static SecureStorage? _instance;
  late final FlutterSecureStorage _storage;

  SecureStorage._() {
    _storage = const FlutterSecureStorage(
      aOptions: AndroidOptions(
        encryptedSharedPreferences: true,
      ),
      iOptions: IOSOptions(
        accessibility: KeychainAccessibility.first_unlock,
      ),
    );
  }

  /// Singleton pour obtenir l'instance du service
  static SecureStorage getInstance() {
    _instance ??= SecureStorage._();
    return _instance!;
  }

  /// Sauvegarder une valeur de manière sécurisée
  Future<void> write({required String key, required String value}) async {
    await _storage.write(key: key, value: value);
  }

  /// Lire une valeur sécurisée
  Future<String?> read({required String key}) async {
    return await _storage.read(key: key);
  }

  /// Supprimer une valeur
  Future<void> delete({required String key}) async {
    await _storage.delete(key: key);
  }

  /// Vérifier si une clé existe
  Future<bool> containsKey({required String key}) async {
    return await _storage.containsKey(key: key);
  }

  /// Supprimer toutes les valeurs
  Future<void> deleteAll() async {
    await _storage.deleteAll();
  }

  /// Lire toutes les valeurs
  Future<Map<String, String>> readAll() async {
    return await _storage.readAll();
  }
}

/// Clés de stockage sécurisé
class SecureStorageKeys {
  // Tokens d'authentification
  static const String accessToken = 'secure_access_token';
  static const String refreshToken = 'secure_refresh_token';
  static const String accessTokenExpiry = 'secure_access_token_expiry';

  // Credentials
  static const String userPin = 'secure_user_pin';
  static const String biometricKey = 'secure_biometric_key';
}
