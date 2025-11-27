import 'package:flutter/material.dart';
import 'package:om_paie_flutter/constants/app_colors.dart';
import 'package:om_paie_flutter/providers/dashboard_provider.dart';
import 'package:om_paie_flutter/providers/theme_provider.dart';
import 'package:om_paie_flutter/ui/widgets/dashboard_header.dart';
import 'package:om_paie_flutter/ui/widgets/payment_section.dart';
import 'package:om_paie_flutter/ui/widgets/transaction_history.dart';
import 'package:provider/provider.dart';
import 'package:om_paie_flutter/providers/language_provider.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    // Charger les données utilisateur au montage
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DashboardProvider>().loadUserProfile();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DashboardProvider>(
      builder: (context, dashboardProvider, child) {

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
            'name': dashboardProvider.userProfile?['nom'] ?? '',
            'phone': dashboardProvider.userProfile?['telephone'] ?? '',
          },
          'en': {
            'dark': 'Dark',
            'scanner': 'Scanner',
            'language': 'English',
            'logout': 'Logout',
            'version': 'OMPAY Version - 1.1.0(35)',
            'name': dashboardProvider.userProfile?['nom'] ?? '',
            'phone': dashboardProvider.userProfile?['telephone'] ?? '',
          },
        };
        final l = labels[lang] ?? labels['fr'];

        if (dashboardProvider.isLoading) {
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
                      dashboardProvider.logout(context);
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
                    userProfile: dashboardProvider.userProfile,
                    comptes: dashboardProvider.comptes,
                    qrCode: dashboardProvider.qrCode,
                    onMenuPressed: () {
                      Scaffold.of(context).openDrawer();
                    },
                    onBalanceRefresh: () {
                      dashboardProvider.loadUserProfile();
                    },
                  ),
                ),
                PaymentSection(
                  onPayPressed: (amount, recipient) async {
                    try {
                      final response = await dashboardProvider.handlePayment(amount, recipient);
                      if (response['success'] == true) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Paiement effectué avec succès'),
                            backgroundColor: Colors.green,
                          ),
                        );
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
                  },
                  onTransferPressed: (amount, recipient) async {
                    try {
                      final response = await dashboardProvider.handleTransfer(amount, recipient);
                      if (response['success'] == true) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Transfert effectué avec succès'),
                            backgroundColor: Colors.green,
                          ),
                        );
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
                  },
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: TransactionHistory(
                    transactions: dashboardProvider.historiqueTransactions,
                    onTransactionTap: (transaction) {
                      _showTransactionDetails(context, transaction, languageProvider);
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showTransactionDetails(BuildContext context, Map<String, dynamic> transaction, LanguageProvider languageProvider) {
    final lang = languageProvider.locale.languageCode;
    final direction = transaction['direction'] as String?;
    final isDebit = direction == 'debit';

    final labels = {
      'fr': {
        'title': 'Détails de la transaction',
        'type': 'Type',
        'contact': isDebit ? 'Numéro du receveur' : 'Numéro de l\'émetteur',
        'reference': 'Référence',
        'amount': 'Montant',
        'date': 'Date',
        'close': 'Fermer',
      },
      'en': {
        'title': 'Transaction Details',
        'type': 'Type',
        'contact': isDebit ? 'Receiver Number' : 'Sender Number',
        'reference': 'Reference',
        'amount': 'Amount',
        'date': 'Date',
        'close': 'Close',
      },
    };
    final l = labels[lang] ?? labels['fr']!;

    final metadata = transaction['metadata'] as Map<String, dynamic>? ?? {};
    String contactNumber;
    if (isDebit) {
      contactNumber = metadata['receiver_number'] ?? metadata['user_phone'] ?? 'N/A';
    } else {
      contactNumber = metadata['sender_number'] ?? 'N/A';
    }
    final reference = transaction['id'] ?? transaction['date_transaction'] ?? 'N/A';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l['title']!),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${l['type']!}: ${transaction['type'] ?? 'N/A'}'),
            Text('${l['contact']!}: $contactNumber'),
            Text('${l['reference']!}: $reference'),
            Text('${l['amount']!}: ${transaction['montant'] ?? 'N/A'} CFA'),
            Text('${l['date']!}: ${transaction['date_transaction'] ?? 'N/A'}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l['close']!),
          ),
        ],
      ),
    );
  }

}


