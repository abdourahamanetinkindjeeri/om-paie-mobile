import 'dart:convert';
import 'dart:io';

class TokenManager {
  String? _accessToken;
  String? _refreshToken;

  // Fichier local pour persister les tokens
  final String storageFile;

  TokenManager({this.storageFile = 'tokens.json'});

  String? get accessToken => _accessToken;
  String? get refreshToken => _refreshToken;

  /// Définit les tokens et les sauvegarde dans un fichier
  Future<void> setTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    _accessToken = accessToken;
    _refreshToken = refreshToken;
    await _saveToFile();
  }

  /// Supprime les tokens en mémoire et du fichier
  Future<void> clearTokens() async {
    _accessToken = null;
    _refreshToken = null;
    await _deleteFile();
  }

  /// Sauvegarde les tokens dans un fichier JSON
  Future<void> _saveToFile() async {
    try {
      final file = File(storageFile);
      final data = {
        'access_token': _accessToken,
        'refresh_token': _refreshToken,
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
