import 'package:flutter/foundation.dart';
import 'package:om_paie_flutter/features/auth/auth.service.dart';
import 'package:om_paie_flutter/features/auth/token_manager_mobile.dart';

/// Provider pour gérer l'authentification
class AuthProvider with ChangeNotifier {
  final AuthService _authService;
  final TokenManagerMobile _tokenManager;

  Map<String, dynamic>? _userProfile;
  bool _isAuthenticated = false;
  bool _isLoading = false;
  String? _error;

  AuthProvider({
    required AuthService authService,
    required TokenManagerMobile tokenManager,
  })  : _authService = authService,
        _tokenManager = tokenManager;

  // Getters
  AuthService get authService => _authService;
  TokenManagerMobile get tokenManager => _tokenManager;
  Map<String, dynamic>? get userProfile => _userProfile;
  bool get isAuthenticated => _isAuthenticated;
  bool get isLoading => _isLoading;
  String? get error => _error;

  /// Connexion avec numéro de téléphone et code PIN
  Future<bool> login(String phoneNumber, String pinCode) async {
    _setLoading(true);
    _error = null;

    try {
      final response = await _authService.login(
        telephone: phoneNumber,
        code: pinCode,
      );

      if (response['success'] == true) {
        _isAuthenticated = true;
        await loadUserProfile();
        _setLoading(false);
        return true;
      } else {
        _error = response['message'] ?? 'Erreur de connexion';
        _setLoading(false);
        return false;
      }
    } catch (e) {
      _error = e.toString();
      _setLoading(false);
      return false;
    }
  }

  /// Enregistrement d'un nouvel utilisateur
  Future<bool> register(Map<String, dynamic> userData) async {
    _setLoading(true);
    _error = null;

    try {
      final response = await _authService.register(userData);

      if (response.success) {
        _setLoading(false);
        return true;
      } else {
        _error = response.message;
        _setLoading(false);
        return false;
      }
    } catch (e) {
      _error = e.toString();
      _setLoading(false);
      return false;
    }
  }

  /// Confirmation de l'enregistrement avec OTP
  Future<bool> confirmRegisterOtp({
    required String telephone,
    required String codeOtp,
  }) async {
    _setLoading(true);
    _error = null;

    try {
      final response = await _authService.confirmRegister(
        telephone: telephone,
        codeOtp: codeOtp,
      );

      if (response['success'] == true) {
        _isAuthenticated = true;
        await loadUserProfile();
        _setLoading(false);
        return true;
      } else {
        _error = response['message'] ?? 'Code OTP invalide';
        _setLoading(false);
        return false;
      }
    } catch (e) {
      _error = e.toString();
      _setLoading(false);
      return false;
    }
  }

  /// Confirmation de la connexion avec OTP
  Future<bool> confirmLoginOtp({
    required String telephone,
    required String otpCode,
  }) async {
    _setLoading(true);
    _error = null;

    try {
      final response = await _authService.confirmLoginOTP(
        telephone: telephone,
        otpCode: otpCode,
      );

      if (response['success'] == true) {
        _isAuthenticated = true;
        await loadUserProfile();
        _setLoading(false);
        return true;
      } else {
        _error = response['message'] ?? 'Code OTP invalide';
        _setLoading(false);
        return false;
      }
    } catch (e) {
      _error = e.toString();
      _setLoading(false);
      return false;
    }
  }

  /// Charger le profil utilisateur
  Future<void> loadUserProfile() async {
    try {
      _userProfile = await _authService.getProfile();
      _isAuthenticated = true;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isAuthenticated = false;
      notifyListeners();
    }
  }

  /// Déconnexion
  Future<void> logout() async {
    await _tokenManager.clearTokens();
    _userProfile = null;
    _isAuthenticated = false;
    _error = null;
    notifyListeners();
  }

  /// Vérifier si l'utilisateur est connecté
  Future<void> checkAuthStatus() async {
    final accessToken = _tokenManager.accessToken;
    if (accessToken != null && accessToken.isNotEmpty) {
      try {
        await loadUserProfile();
      } catch (e) {
        _isAuthenticated = false;
        notifyListeners();
      }
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  /// Effacer les erreurs
  void clearError() {
    _error = null;
    notifyListeners();
  }
}
