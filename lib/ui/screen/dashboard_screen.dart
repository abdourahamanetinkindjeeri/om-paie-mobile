import 'package:flutter/material.dart';
import 'package:om_paie_flutter/constants/app_colors.dart';
import 'package:om_paie_flutter/features/auth/auth.service.dart';
import 'package:om_paie_flutter/features/auth/itoken_manager.dart';
import 'package:om_paie_flutter/features/comptes/compte.service.dart';
import 'package:om_paie_flutter/providers/theme_provider.dart';
import 'package:om_paie_flutter/ui/widgets/dashboard_header.dart';
import 'package:om_paie_flutter/ui/widgets/payment_section.dart';
import 'package:om_paie_flutter/ui/widgets/transaction_history.dart';
import 'package:provider/provider.dart';
import 'package:om_paie_flutter/providers/language_provider.dart';

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
  // ...existing code...
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
    final theme = Theme.of(context);
    final themeProvider = Provider.of<ThemeProvider>(context);
    final languageProvider = Provider.of<LanguageProvider>(context);
    final lang = languageProvider.locale.languageCode;

    // Labels pour le drawer
    final labels = {
      'fr': {
        'dark': 'Sombre',
        'scanner': 'Scanner',
        'language': 'Français',
        'logout': 'Se déconnecter',
        'version': 'OMPAY Version - 1.1.0(35)',
        'name': _userProfile?['nom'] ?? '',
        'phone': _userProfile?['telephone'] ?? '',
      },
      'en': {
        'dark': 'Dark',
        'scanner': 'Scanner',
        'language': 'English',
        'logout': 'Logout',
        'version': 'OMPAY Version - 1.1.0(35)',
        'name': _userProfile?['nom'] ?? '',
        'phone': _userProfile?['telephone'] ?? '',
      },
    };
    final l = labels[lang] ?? labels['fr'];

    if (_isLoading) {
      return Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        body: Center(
          child: CircularProgressIndicator(
            color: AppColors.primary,
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      drawer: Drawer(
        child: Container(
          color: theme.cardTheme.color,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.grey[300],
                      child:
                          Icon(Icons.person, size: 48, color: Colors.grey[700]),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      l?['name'] ?? '',
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      l?['phone'] ?? '',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.settings, color: AppColors.primary),
                      const SizedBox(width: 8),
                      Text(l?['dark'] ?? ''),
                    ],
                  ),
                  Switch(
                    value: themeProvider.themeMode == ThemeMode.dark,
                    onChanged: (val) {
                      themeProvider.toggleTheme();
                    },
                    activeColor: AppColors.primary,
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.qr_code_scanner,
                          color: AppColors.primary),
                      const SizedBox(width: 8),
                      Text(l?['scanner'] ?? ''),
                    ],
                  ),
                  Switch(
                    value: false, // À relier à la logique scanner si besoin
                    onChanged: (val) {},
                    activeColor: AppColors.primary,
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  const Icon(Icons.language, color: AppColors.primary),
                  const SizedBox(width: 8),
                  Text(l?['language'] ?? ''),
                  const SizedBox(width: 8),
                  DropdownButton<String>(
                    value: lang,
                    items: const [
                      DropdownMenuItem(value: 'fr', child: Text('Français')),
                      DropdownMenuItem(value: 'en', child: Text('English')),
                    ],
                    onChanged: (newLang) {
                      if (newLang != null) {
                        languageProvider.setLocale(Locale(newLang));
                      }
                    },
                  ),
                ],
              ),
              const SizedBox(height: 24),
              ListTile(
                leading: const Icon(Icons.logout, color: Colors.red),
                title: Text(l?['logout'] ?? '',
                    style: const TextStyle(color: Colors.red)),
                onTap: () {
                  Navigator.pop(context);
                  _handleLogout();
                },
              ),
              const Spacer(),
              Center(
                child: Text(
                  l?['version'] ?? '',
                  style: const TextStyle(
                      color: AppColors.primary, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Builder(
              builder: (context) => DashboardHeader(
                userProfile: _userProfile,
                comptes: _comptes,
                qrCode: _qrCode,
                onMenuPressed: () {
                  Scaffold.of(context).openDrawer();
                },
                onBalanceRefresh: () {
                  _loadUserProfile();
                },
              ),
            ),
            PaymentSection(
              onPayPressed: (amount, recipient) async {
                await _handlePayment(amount, recipient);
              },
              onTransferPressed: (amount, recipient) async {
                await _handleTransfer(amount, recipient);
              },
            ),
            const SizedBox(height: 8),
            Expanded(
              child: TransactionHistory(
                transactions: _historiqueTransactions,
              ),
            ),
          ],
        ),
      ),
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

    // Ajout du préfixe +221 si absent
    String recipientFormatted = recipient.trim();
    if (!recipientFormatted.startsWith('+221')) {
      // Retire les éventuels zéros initiaux
      recipientFormatted =
          '+221' + recipientFormatted.replaceFirst(RegExp(r'^0+'), '');
    }

    try {
      final response = await widget.compteService.transfer(
        numeroCompte: principalAccountId,
        telephoneDestinataire: recipientFormatted,
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
