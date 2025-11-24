import 'package:shared_preferences/shared_preferences.dart';
import 'package:om_paie_flutter/core/storage/secure_storage.dart';

/// Utilitaire pour migrer les données de SharedPreferences vers SecureStorage
class StorageMigration {
  static const String _migrationKey = 'storage_migration_completed';

  /// Migre les tokens de SharedPreferences vers SecureStorage
  static Future<void> migrateTokens() async {
    final prefs = await SharedPreferences.getInstance();

    // Vérifier si la migration a déjà été effectuée
    final migrationCompleted = prefs.getBool(_migrationKey) ?? false;
    if (migrationCompleted) {
      return;
    }

    final secureStorage = SecureStorage.getInstance();

    // Migrer l'access token
    final accessToken = prefs.getString('access_token');
    if (accessToken != null && accessToken.isNotEmpty) {
      await secureStorage.write(
        key: SecureStorageKeys.accessToken,
        value: accessToken,
      );
      await prefs.remove('access_token');
    }

    // Migrer le refresh token
    final refreshToken = prefs.getString('refresh_token');
    if (refreshToken != null && refreshToken.isNotEmpty) {
      await secureStorage.write(
        key: SecureStorageKeys.refreshToken,
        value: refreshToken,
      );
      await prefs.remove('refresh_token');
    }

    // Migrer l'expiry du token
    final tokenExpiry = prefs.getString('access_token_expiry');
    if (tokenExpiry != null && tokenExpiry.isNotEmpty) {
      await secureStorage.write(
        key: SecureStorageKeys.accessTokenExpiry,
        value: tokenExpiry,
      );
      await prefs.remove('access_token_expiry');
    }

    // Marquer la migration comme complétée
    await prefs.setBool(_migrationKey, true);
  }

  /// Réinitialise l'état de migration (pour les tests)
  static Future<void> resetMigration() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_migrationKey);
  }

  /// Vérifie si la migration a été effectuée
  static Future<bool> isMigrationCompleted() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_migrationKey) ?? false;
  }
}
