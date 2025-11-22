import 'package:shared_preferences/shared_preferences.dart';
import 'package:om_paie_flutter/features/auth/itoken_manager.dart';

class TokenManagerMobile implements ITokenManager {
  static const String _accessTokenKey = 'access_token';
  static const String _refreshTokenKey = 'refresh_token';
  static const String _accessTokenExpiryKey = 'access_token_expiry';

  String? _accessToken;
  String? _refreshToken;
  DateTime? _accessTokenExpiry;

  String? get accessToken => _accessToken;
  String? get refreshToken => _refreshToken;
  DateTime? get accessTokenExpiry => _accessTokenExpiry;

  /// Vérifie si l'access token est expiré
  bool get isAccessTokenExpired {
    if (_accessToken == null || _accessTokenExpiry == null) return true;
    return DateTime.now().isAfter(_accessTokenExpiry!);
  }

  /// Définit les tokens et les sauvegarde dans SharedPreferences
  Future<void> setTokens({
    required String accessToken,
    required String refreshToken,
    DateTime? accessTokenExpiry,
  }) async {
    _accessToken = accessToken;
    _refreshToken = refreshToken;
    _accessTokenExpiry = accessTokenExpiry ?? DateTime.now().add(const Duration(hours: 1)); // default 1h

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_accessTokenKey, accessToken);
    await prefs.setString(_refreshTokenKey, refreshToken);
    await prefs.setString(_accessTokenExpiryKey, _accessTokenExpiry!.toIso8601String());
  }

  /// Supprime les tokens en mémoire et de SharedPreferences
  Future<void> clearTokens() async {
    _accessToken = null;
    _refreshToken = null;
    _accessTokenExpiry = null;

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_accessTokenKey);
    await prefs.remove(_refreshTokenKey);
    await prefs.remove(_accessTokenExpiryKey);
  }

  /// Charge les tokens depuis SharedPreferences, si disponible
  Future<void> loadTokens() async {
    final prefs = await SharedPreferences.getInstance();
    _accessToken = prefs.getString(_accessTokenKey);
    _refreshToken = prefs.getString(_refreshTokenKey);
    final expiryString = prefs.getString(_accessTokenExpiryKey);
    if (expiryString != null) {
      _accessTokenExpiry = DateTime.parse(expiryString);
    }
  }
}