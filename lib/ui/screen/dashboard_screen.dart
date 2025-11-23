import 'package:flutter/material.dart';
import 'package:om_paie_flutter/constants/app_colors.dart';
import 'package:om_paie_flutter/features/auth/auth.service.dart';
import 'package:om_paie_flutter/features/auth/itoken_manager.dart';
import 'package:om_paie_flutter/ui/widgets/dashboard_header.dart';
import 'package:om_paie_flutter/ui/widgets/payment_section.dart';
import 'package:om_paie_flutter/ui/widgets/transaction_history.dart';

class DashboardScreen extends StatefulWidget {
  final AuthService authService;
  final ITokenManager tokenManager;

  const DashboardScreen({
    Key? key,
    required this.authService,
    required this.tokenManager,
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
          _historiqueTransactions = List<Map<String, dynamic>>.from(profile['historique_transactions'] ?? []);
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
                      onPayPressed: (amount, recipient) {
                        _handlePayment(amount, recipient);
                      },
                      onTransferPressed: (amount, recipient) {
                        _handleTransfer(amount, recipient);
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
                title: const Text('Mon profil', style: TextStyle(color: AppColors.textPrimary)),
                onTap: () {
                  Navigator.pop(context);
                  // Naviguer vers le profil
                },
              ),
              ListTile(
                leading: const Icon(Icons.settings, color: AppColors.primary),
                title: const Text('Paramètres', style: TextStyle(color: AppColors.textPrimary)),
                onTap: () {
                  Navigator.pop(context);
                  // Naviguer vers les paramètres
                },
              ),
              ListTile(
                leading: const Icon(Icons.help, color: AppColors.primary),
                title: const Text('Aide', style: TextStyle(color: AppColors.textPrimary)),
                onTap: () {
                  Navigator.pop(context);
                  // Naviguer vers l'aide
                },
              ),
              const Divider(color: AppColors.border),
              ListTile(
                leading: const Icon(Icons.logout, color: Colors.red),
                title: const Text('Déconnexion', style: TextStyle(color: Colors.red)),
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

  void _handlePayment(String amount, String recipient) {
    // Logique de paiement
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Paiement de $amount CFA vers $recipient'),
        backgroundColor: AppColors.primary,
      ),
    );
  }

  void _handleTransfer(String amount, String recipient) {
    // Logique de transfert
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Transfert de $amount CFA vers $recipient'),
        backgroundColor: AppColors.primary,
      ),
    );
  }

  Future<void> _handleLogout() async {
    await widget.tokenManager.clearTokens();
    if (mounted) {
      Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
    }
  }
}
