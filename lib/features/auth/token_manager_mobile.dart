import 'package:om_paie_flutter/core/storage/secure_storage.dart';
import 'package:om_paie_flutter/features/auth/itoken_manager.dart';

class TokenManagerMobile implements ITokenManager {
  final SecureStorage _secureStorage;

  String? _accessToken;
  String? _refreshToken;
  DateTime? _accessTokenExpiry;

  TokenManagerMobile({SecureStorage? secureStorage})
      : _secureStorage = secureStorage ?? SecureStorage.getInstance();

  @override
  String? get accessToken => _accessToken;

  @override
  String? get refreshToken => _refreshToken;

  @override
  DateTime? get accessTokenExpiry => _accessTokenExpiry;

  /// Vérifie si l'access token est expiré
  @override
  bool get isAccessTokenExpired {
    if (_accessToken == null || _accessTokenExpiry == null) return true;
    return DateTime.now().isAfter(_accessTokenExpiry!);
  }

  /// Définit les tokens et les sauvegarde de manière sécurisée
  @override
  Future<void> setTokens({
    required String accessToken,
    required String refreshToken,
    DateTime? accessTokenExpiry,
  }) async {
    _accessToken = accessToken;
    _refreshToken = refreshToken;
    _accessTokenExpiry =
        accessTokenExpiry ?? DateTime.now().add(const Duration(hours: 1));

    // Sauvegarder dans le stockage sécurisé
    await _secureStorage.write(
      key: SecureStorageKeys.accessToken,
      value: accessToken,
    );
    await _secureStorage.write(
      key: SecureStorageKeys.refreshToken,
      value: refreshToken,
    );
    await _secureStorage.write(
      key: SecureStorageKeys.accessTokenExpiry,
      value: _accessTokenExpiry!.toIso8601String(),
    );
  }

  /// Supprime les tokens en mémoire et du stockage sécurisé
  @override
  Future<void> clearTokens() async {
    _accessToken = null;
    _refreshToken = null;
    _accessTokenExpiry = null;

    await _secureStorage.delete(key: SecureStorageKeys.accessToken);
    await _secureStorage.delete(key: SecureStorageKeys.refreshToken);
    await _secureStorage.delete(key: SecureStorageKeys.accessTokenExpiry);
  }

  /// Charge les tokens depuis le stockage sécurisé
  @override
  Future<void> loadTokens() async {
    _accessToken = await _secureStorage.read(
      key: SecureStorageKeys.accessToken,
    );
    _refreshToken = await _secureStorage.read(
      key: SecureStorageKeys.refreshToken,
    );

    final expiryString = await _secureStorage.read(
      key: SecureStorageKeys.accessTokenExpiry,
    );

    if (expiryString != null) {
      try {
        _accessTokenExpiry = DateTime.parse(expiryString);
      } catch (e) {
        // Si le parsing échoue, on ignore et l'expiry reste null
        _accessTokenExpiry = null;
      }
    }
  }

  /// Vérifie si des tokens sont stockés
  Future<bool> hasStoredTokens() async {
    final hasAccess = await _secureStorage.containsKey(
      key: SecureStorageKeys.accessToken,
    );
    final hasRefresh = await _secureStorage.containsKey(
      key: SecureStorageKeys.refreshToken,
    );
    return hasAccess && hasRefresh;
  }
}
