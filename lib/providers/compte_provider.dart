import 'package:flutter/foundation.dart';
import 'package:om_paie_flutter/features/comptes/compte.service.dart';

/// Provider pour gérer les comptes et transactions
class CompteProvider with ChangeNotifier {
  final CompteService _compteService;

  List<Map<String, dynamic>> _comptes = [];
  List<Map<String, dynamic>> _transactions = [];
  Map<String, dynamic>? _qrCode;
  bool _isLoading = false;
  String? _error;

  CompteProvider({required CompteService compteService})
      : _compteService = compteService;

  // Getters
  CompteService get compteService => _compteService;
  List<Map<String, dynamic>> get comptes => _comptes;
  List<Map<String, dynamic>> get transactions => _transactions;
  Map<String, dynamic>? get qrCode => _qrCode;
  bool get isLoading => _isLoading;
  String? get error => _error;

  /// Obtenir le compte principal
  Map<String, dynamic>? get principalAccount {
    for (final compte in _comptes) {
      if (compte['type'] == 'principal') {
        return compte;
      }
    }
    return _comptes.isNotEmpty ? _comptes.first : null;
  }

  /// Obtenir le solde du compte principal
  double get balance {
    final principal = principalAccount;
    if (principal != null && principal['solde'] != null) {
      return (principal['solde'] as num).toDouble();
    }
    return 0.0;
  }

  /// Charger les comptes de l'utilisateur
  Future<void> loadComptes(List<Map<String, dynamic>> comptes) async {
    _comptes = comptes;
    notifyListeners();
  }

  /// Charger les transactions
  Future<void> loadTransactions(List<Map<String, dynamic>> transactions) async {
    _transactions = transactions;
    notifyListeners();
  }

  /// Charger le QR code
  void loadQrCode(Map<String, dynamic>? qrCode) {
    _qrCode = qrCode;
    notifyListeners();
  }

  /// Effectuer un paiement
  Future<bool> makePayment({
    required String numeroCompte,
    required String codeMerchant,
    required int montant,
  }) async {
    _setLoading(true);
    _error = null;

    try {
      final response = await _compteService.payement(
        numeroCompte: numeroCompte,
        codeMerchant: codeMerchant,
        montant: montant,
      );

      if (response['success'] == true) {
        // Mettre à jour le solde localement
        _updateBalance(numeroCompte, -montant);
        _setLoading(false);
        return true;
      } else {
        _error = response['message'] ?? 'Erreur lors du paiement';
        _setLoading(false);
        return false;
      }
    } catch (e) {
      _error = e.toString();
      _setLoading(false);
      return false;
    }
  }

  /// Effectuer un transfert
  Future<bool> makeTransfer({
    required String numeroCompte,
    required String telephoneDestinataire,
    required int montant,
  }) async {
    _setLoading(true);
    _error = null;

    try {
      final response = await _compteService.transfer(
        numeroCompte: numeroCompte,
        telephoneDestinataire: telephoneDestinataire,
        montant: montant,
      );

      if (response['success'] == true) {
        // Mettre à jour le solde localement
        _updateBalance(numeroCompte, -montant);
        _setLoading(false);
        return true;
      } else {
        _error = response['message'] ?? 'Erreur lors du transfert';
        _setLoading(false);
        return false;
      }
    } catch (e) {
      _error = e.toString();
      _setLoading(false);
      return false;
    }
  }

  /// Mettre à jour le solde d'un compte
  void _updateBalance(String numeroCompte, int montant) {
    for (int i = 0; i < _comptes.length; i++) {
      if (_comptes[i]['numero_compte'] == numeroCompte) {
        final currentBalance = (_comptes[i]['solde'] as num).toDouble();
        _comptes[i]['solde'] = currentBalance + montant;
        break;
      }
    }
    notifyListeners();
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

  /// Réinitialiser les données
  void clear() {
    _comptes = [];
    _transactions = [];
    _qrCode = null;
    _error = null;
    notifyListeners();
  }
}
