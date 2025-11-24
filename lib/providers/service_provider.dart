import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:om_paie_flutter/core/config.dart';
import 'package:om_paie_flutter/core/data/services/api.service.impl.dart';
import 'package:om_paie_flutter/features/auth/auth.service.dart';
import 'package:om_paie_flutter/features/auth/token_manager_mobile.dart';
import 'package:om_paie_flutter/features/comptes/compte.service.dart';

/// Provider pour initialiser et fournir les services
class ServiceProvider with ChangeNotifier {
  late final TokenManagerMobile _tokenManager;
  late final ApiServiceImpl _apiService;
  late final AuthService _authService;
  late final CompteService _compteService;

  bool _isInitialized = false;

  ServiceProvider() {
    _initialize();
  }

  // Getters
  TokenManagerMobile get tokenManager => _tokenManager;
  ApiServiceImpl get apiService => _apiService;
  AuthService get authService => _authService;
  CompteService get compteService => _compteService;
  bool get isInitialized => _isInitialized;

  /// Initialiser les services
  Future<void> _initialize() async {
    try {
      // Charger la configuration
      await Config.load();

      // Initialiser le token manager
      _tokenManager = TokenManagerMobile();
      await _tokenManager.loadTokens();

      // Initialiser l'API service
      _apiService = ApiServiceImpl(
        Config.apiBaseUrl,
        tokenManager: _tokenManager,
        client: http.Client(),
      );

      // Initialiser les services métier
      _authService = AuthService(_apiService);
      _compteService = CompteService(_apiService);

      _isInitialized = true;
      notifyListeners();
    } catch (e) {
      debugPrint('Erreur lors de l\'initialisation des services: $e');
      rethrow;
    }
  }
}
