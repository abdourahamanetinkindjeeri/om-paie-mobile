import 'package:flutter/material.dart';
import 'package:om_paie_flutter/constants/app_colors.dart';
import 'package:om_paie_flutter/features/auth/auth.service.dart';
import 'package:om_paie_flutter/features/auth/itoken_manager.dart';
import 'package:om_paie_flutter/features/comptes/compte.service.dart';
import 'package:om_paie_flutter/ui/widgets/dashboard_header.dart';
import 'package:om_paie_flutter/ui/widgets/payment_section.dart';
import 'package:om_paie_flutter/ui/widgets/transaction_history.dart';

class DashboardScreen extends StatefulWidget {
  final AuthService authService;
  final ITokenManager tokenManager;
  final CompteService compteService;

  const DashboardScreen({
    Key? key,
    required this.authService,
    required this.tokenManager,
    required this.compteService,
  }) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  Map<String, dynamic>? _userProfile;
  List<Map<String, dynamic>> _comptes = [];
  List<Map<String, dynamic>> _historiqueTransactions = [];
  Map<String, dynamic>? _qrCode;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    try {
      final profile = await widget.authService.getProfile();
      if (mounted) {
        setState(() {
          _userProfile = profile['user'];
          _comptes = List<Map<String, dynamic>>.from(profile['comptes'] ?? []);
          _historiqueTransactions = List<Map<String, dynamic>>.from(
              profile['historique_transactions'] ?? []);
          _qrCode = profile['qr_code'];
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur lors du chargement du profil: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  String? _getPrincipalAccountId() {
    // Vérifier d'abord les comptes avec type 'principal'
    for (final compte in _comptes) {
      if (compte['type'] == 'principal' && compte['numero_compte'] != null) {
        return compte['numero_compte'] as String;
      }
    }
    // Sinon, chercher le premier compte disponible
    for (final compte in _comptes) {
      final numeroCompte = compte['numero_compte'];
      if (numeroCompte != null) {
        return numeroCompte as String;
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: AppColors.background,
        body: Center(
          child: CircularProgressIndicator(
            color: AppColors.primary,
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            DashboardHeader(
              userProfile: _userProfile,
              comptes: _comptes,
              qrCode: _qrCode,
              onMenuPressed: () {
                // Ouvrir le menu latéral
                _showMenuDrawer();
              },
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    PaymentSection(
                      onPayPressed: (amount, recipient) async {
                        await _handlePayment(amount, recipient);
                      },
                      onTransferPressed: (amount, recipient) async {
                        await _handleTransfer(amount, recipient);
                      },
                    ),
                    const SizedBox(height: 20),
                    TransactionHistory(
                      transactions: _historiqueTransactions,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showMenuDrawer() {
    // Afficher le menu latéral
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.person, color: AppColors.primary),
                title: const Text('Mon profil',
                    style: TextStyle(color: AppColors.textPrimary)),
                onTap: () {
                  Navigator.pop(context);
                  // Naviguer vers le profil
                },
              ),
              ListTile(
                leading: const Icon(Icons.settings, color: AppColors.primary),
                title: const Text('Paramètres',
                    style: TextStyle(color: AppColors.textPrimary)),
                onTap: () {
                  Navigator.pop(context);
                  // Naviguer vers les paramètres
                },
              ),
              ListTile(
                leading: const Icon(Icons.help, color: AppColors.primary),
                title: const Text('Aide',
                    style: TextStyle(color: AppColors.textPrimary)),
                onTap: () {
                  Navigator.pop(context);
                  // Naviguer vers l'aide
                },
              ),
              const Divider(color: AppColors.border),
              ListTile(
                leading: const Icon(Icons.logout, color: Colors.red),
                title: const Text('Déconnexion',
                    style: TextStyle(color: Colors.red)),
                onTap: () {
                  Navigator.pop(context);
                  _handleLogout();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _handlePayment(String amount, String recipient) async {
    final principalAccountId = _getPrincipalAccountId();
    if (principalAccountId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Aucun compte principal trouvé'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      final response = await widget.compteService.payement(
        numeroCompte: principalAccountId,
        codeMerchant: recipient,
        montant: int.parse(amount),
      );

      if (response['success'] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Paiement effectué avec succès'),
            backgroundColor: Colors.green,
          ),
        );
        // Refresh profile to update balance
        _loadUserProfile();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content:
                Text('Erreur: ${response['message'] ?? 'Paiement échoué'}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erreur lors du paiement: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _handleTransfer(String amount, String recipient) async {
    final principalAccountId = _getPrincipalAccountId();
    if (principalAccountId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Aucun compte principal trouvé'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      final response = await widget.compteService.transfer(
        numeroCompte: principalAccountId,
        telephoneDestinataire: recipient,
        montant: int.parse(amount),
      );

      if (response['success'] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Transfert effectué avec succès'),
            backgroundColor: Colors.green,
          ),
        );
        // Refresh profile to update balance
        _loadUserProfile();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content:
                Text('Erreur: ${response['message'] ?? 'Transfert échoué'}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erreur lors du transfert: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _handleLogout() async {
    await widget.tokenManager.clearTokens();
    if (mounted) {
      Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
    }
  }
}
