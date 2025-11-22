import 'dart:convert';
import 'dart:io';
import 'package:om_paie_flutter/features/auth/itoken_manager.dart';

class TokenManager implements ITokenManager {
  String? _accessToken;
  String? _refreshToken;
  DateTime? _accessTokenExpiry;

  // Fichier local pour persister les tokens
  final String storageFile;

  TokenManager({this.storageFile = 'tokens.json'});

  String? get accessToken => _accessToken;
  String? get refreshToken => _refreshToken;
  DateTime? get accessTokenExpiry => _accessTokenExpiry;

  /// Vérifie si l'access token est expiré
  bool get isAccessTokenExpired {
    if (_accessToken == null || _accessTokenExpiry == null) return true;
    return DateTime.now().isAfter(_accessTokenExpiry!);
  }

  /// Définit les tokens et les sauvegarde dans un fichier
  Future<void> setTokens({
    required String accessToken,
    required String refreshToken,
    DateTime? accessTokenExpiry,
  }) async {
    _accessToken = accessToken;
    _refreshToken = refreshToken;
    _accessTokenExpiry = accessTokenExpiry ?? DateTime.now().add(Duration(hours: 1)); // default 1h
    await _saveToFile();
  }

  /// Supprime les tokens en mémoire et du fichier
  Future<void> clearTokens() async {
    _accessToken = null;
    _refreshToken = null;
    _accessTokenExpiry = null;
    await _deleteFile();
  }

  /// Sauvegarde les tokens dans un fichier JSON
  Future<void> _saveToFile() async {
    try {
      final file = File(storageFile);
      final data = {
        'access_token': _accessToken,
        'refresh_token': _refreshToken,
        'access_token_expiry': _accessTokenExpiry?.toIso8601String(),
      };
      await file.writeAsString(jsonEncode(data));
    } catch (e) {
      print("Erreur lors de la sauvegarde des tokens: $e");
    }
  }

  /// Charge les tokens depuis le fichier, si disponible
  Future<void> loadTokens() async {
    try {
      final file = File(storageFile);
      if (await file.exists()) {
        final content = await file.readAsString();
        if (content.isNotEmpty) {
          final Map<String, dynamic> data = jsonDecode(content);
          _accessToken = data['access_token'] as String?;
          _refreshToken = data['refresh_token'] as String?;
          _accessTokenExpiry = data['access_token_expiry'] != null
              ? DateTime.parse(data['access_token_expiry'])
              : null;
        }
      }
    } catch (e) {
      print("Erreur lors du chargement des tokens: $e");
    }
  }

  /// Supprime le fichier contenant les tokens
  Future<void> _deleteFile() async {
    try {
      final file = File(storageFile);
      if (await file.exists()) {
        await file.delete();
      }
    } catch (e) {
      print("Erreur lors de la suppression du fichier de tokens: $e");
    }
  }
}
