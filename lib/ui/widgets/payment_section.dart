import 'package:flutter/material.dart';
import 'package:om_paie_flutter/constants/app_colors.dart';

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
                          'Payer',
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
                          'Transférer',
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
          // Recipient input
          TextField(
            controller: _recipientController,
            style: TextStyle(color: theme.textTheme.bodyLarge?.color),
            decoration: InputDecoration(
              hintText: _isPaymentSelected
                  ? 'Saisir le code marchand'
                  : 'Saisir le numéro de téléphone',
              hintStyle: TextStyle(color: theme.textTheme.bodySmall?.color),
              filled: true,
              fillColor: theme.scaffoldBackgroundColor,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            ),
          ),
          const SizedBox(height: 10),
          // Amount input
          TextField(
            controller: _amountController,
            keyboardType: TextInputType.number,
            style: TextStyle(color: theme.textTheme.bodyLarge?.color),
            decoration: InputDecoration(
              hintText: 'Saisir le montant',
              hintStyle: TextStyle(color: theme.textTheme.bodySmall?.color),
              filled: true,
              fillColor: theme.scaffoldBackgroundColor,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            ),
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
              child: const Text(
                'Valider',
                style: TextStyle(
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
                  child: const Text(
                    'Max it',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  'Accéder à Max it',
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
            'Pour toute autre opération',
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
