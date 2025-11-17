import 'dart:convert';
import 'dart:io';

class TokenManager {
  String? _accessToken;
  String? _refreshToken;

  // Optionnel : fichier local pour persister les tokens
  final String storageFile;

  TokenManager({this.storageFile = 'tokens.json'});

  String? get accessToken => _accessToken;
  String? get refreshToken => _refreshToken;

  void setTokens({required String accessToken, required String refreshToken}) {
    _accessToken = accessToken;
    _refreshToken = refreshToken;
    _saveToFile();
  }

  void clearTokens() {
    _accessToken = null;
    _refreshToken = null;
    _deleteFile();
  }

  Future<void> _saveToFile() async {
    final file = File(storageFile);
    final data = {
      'access_token': _accessToken,
      'refresh_token': _refreshToken,
    };
    await file.writeAsString(jsonEncode(data));
  }

  Future<void> loadTokens() async {
    final file = File(storageFile);
    if (await file.exists()) {
      final data = jsonDecode(await file.readAsString());
      _accessToken = data['access_token'];
      _refreshToken = data['refresh_token'];
    }
  }

  Future<void> _deleteFile() async {
    final file = File(storageFile);
    if (await file.exists()) {
      await file.delete();
    }
  }
}
