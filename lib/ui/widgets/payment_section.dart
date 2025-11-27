import 'package:om_paie_flutter/providers/language_provider.dart';
import 'package:flutter/material.dart';
import 'package:om_paie_flutter/constants/app_colors.dart';
import 'package:om_paie_flutter/pages/qr_scanner_screen.dart';
import 'package:provider/provider.dart';
import 'package:om_paie_flutter/constants/app_strings.dart';

class PaymentSection extends StatefulWidget {
  final Future<void> Function(String amount, String recipient) onPayPressed;
  final Future<void> Function(String amount, String recipient)
      onTransferPressed;

  const PaymentSection({
    Key? key,
    required this.onPayPressed,
    required this.onTransferPressed,
  }) : super(key: key);

  @override
  State<PaymentSection> createState() => _PaymentSectionState();
}

class _PaymentSectionState extends State<PaymentSection> {
  bool _isPaymentSelected = true;
  final TextEditingController _recipientController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();

  @override
  void dispose() {
    _recipientController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final lang = Provider.of<LanguageProvider>(context).locale.languageCode;
    final strings = AppStrings.of(lang);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.cardTheme.color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          // Toggle buttons
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _isPaymentSelected = true;
                      _recipientController.clear();
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      color: _isPaymentSelected
                          ? AppColors.primary
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 16,
                          height: 16,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _isPaymentSelected
                                ? Colors.white
                                : Colors.transparent,
                            border: Border.all(
                              color: _isPaymentSelected
                                  ? Colors.white
                                  : AppColors.textSecondary,
                              width: 2,
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          lang == 'fr' ? 'Payer' : 'Pay',
                          style: TextStyle(
                            color: _isPaymentSelected
                                ? Colors.white
                                : AppColors.textSecondary,
                            fontSize: 14,
                            fontWeight: _isPaymentSelected
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _isPaymentSelected = false;
                      _recipientController.clear();
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      color: !_isPaymentSelected
                          ? AppColors.primary
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 16,
                          height: 16,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: !_isPaymentSelected
                                ? Colors.white
                                : Colors.transparent,
                            border: Border.all(
                              color: !_isPaymentSelected
                                  ? Colors.white
                                  : AppColors.textSecondary,
                              width: 2,
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          lang == 'fr' ? 'Transférer' : 'Transfer',
                          style: TextStyle(
                            color: !_isPaymentSelected
                                ? Colors.white
                                : AppColors.textSecondary,
                            fontSize: 14,
                            fontWeight: !_isPaymentSelected
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: const Icon(
                  Icons.refresh,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          // Input fields with single scan button on the right
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 70,
                child: Column(
                  children: [
                    // Recipient input
                    TextField(
                      controller: _recipientController,
                      style: TextStyle(color: theme.textTheme.bodyLarge?.color),
                      decoration: InputDecoration(
                        hintText: _isPaymentSelected
                            ? (lang == 'fr'
                                ? 'Saisir le code marchand'
                                : 'Enter merchant code')
                            : (lang == 'fr'
                                ? 'Saisir le numéro de téléphone'
                                : 'Enter phone number'),
                        hintStyle:
                            TextStyle(color: theme.textTheme.bodySmall?.color),
                        filled: true,
                        fillColor: theme.scaffoldBackgroundColor,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 10),
                      ),
                    ),
                    const SizedBox(height: 10),
                    // Amount input
                    TextField(
                      controller: _amountController,
                      keyboardType: TextInputType.number,
                      style: TextStyle(color: theme.textTheme.bodyLarge?.color),
                      decoration: InputDecoration(
                        hintText:
                            lang == 'fr' ? 'Saisir le montant' : 'Enter amount',
                        hintStyle:
                            TextStyle(color: theme.textTheme.bodySmall?.color),
                        filled: true,
                        fillColor: theme.scaffoldBackgroundColor,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 10),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              // Single scan button for both fields
              Expanded(
                flex: 30,
                child: GestureDetector(
                  onTap: () async {
                    // Ouvrir la caméra pour scanner le QR code
                    final result = await Navigator.push<String>(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const QRScannerScreen(),
                      ),
                    );

                    if (result != null && result.isNotEmpty) {
                      // Basculer automatiquement vers Transférer après le scan
                      setState(() {
                        if (_isPaymentSelected) {
                          _isPaymentSelected =
                              false; // Passer en mode Transfert
                        }
                        _recipientController.text = result;
                      });

                      // Afficher un message et focus sur le champ montant
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(lang == 'fr'
                                ? 'Numéro scanné: $result\nMode Transfert activé'
                                : 'Scanned number: $result\nTransfer mode activated'),
                            backgroundColor: AppColors.primary,
                            duration: const Duration(seconds: 2),
                          ),
                        );

                        // Focus sur le champ montant pour saisie
                        FocusScope.of(context).nextFocus();
                      }
                    }
                  },
                  child: Container(
                    height:
                        94, // Height to match both input fields combined (42 + 10 + 42)
                    decoration: BoxDecoration(
                      color: theme.scaffoldBackgroundColor,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: AppColors.primary,
                        width: 2,
                      ),
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.qr_code_scanner,
                        color: AppColors.primary,
                        size: 32,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Validate button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                if (_recipientController.text.isNotEmpty &&
                    _amountController.text.isNotEmpty) {
                  if (_isPaymentSelected) {
                    widget.onPayPressed(
                        _amountController.text, _recipientController.text);
                  } else {
                    widget.onTransferPressed(
                        _amountController.text, _recipientController.text);
                  }
                  _recipientController.clear();
                  _amountController.clear();
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 0,
              ),
              child: Text(
                strings.validateButton,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          // Max it button
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            decoration: BoxDecoration(
              color: theme.scaffoldBackgroundColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    lang == 'fr' ? 'Max it' : 'Max it',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  lang == 'fr' ? 'Accéder à Max it' : 'Access Max it',
                  style: TextStyle(
                    color: theme.textTheme.bodyLarge?.color,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 6),
          Text(
            lang == 'fr'
                ? 'Pour toute autre opération'
                : 'For any other operation',
            style: TextStyle(
              color: theme.textTheme.bodySmall?.color,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}
