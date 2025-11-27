import 'package:provider/provider.dart';
import 'package:om_paie_flutter/providers/language_provider.dart';
import 'package:flutter/material.dart';
import 'package:om_paie_flutter/constants/app_colors.dart';

class TransactionHistory extends StatefulWidget {
  final List<Map<String, dynamic>> transactions;
  final Function(Map<String, dynamic> transaction)? onTransactionTap;

  const TransactionHistory({
    Key? key,
    this.transactions = const [],
    this.onTransactionTap,
  }) : super(key: key);

  @override
  State<TransactionHistory> createState() => _TransactionHistoryState();
}

class _TransactionHistoryState extends State<TransactionHistory> {
  List<Map<String, dynamic>> get _transactions => widget.transactions.map((t) {
        final type = t['type'] as String;
        final montant = t['montant'] as int;
        final direction = t['direction'] as String;
        final dateTransaction = t['date_transaction'] as String;
        final metadata = t['metadata'] as Map<String, dynamic>;

        String title;
        String recipient;
        String amount;
        bool isPositive;

        switch (type) {
          case 'payment':
            title = metadata['merchant_name'] ?? 'Paiement';
            recipient = metadata['user_phone'] ?? '';
            break;
          case 'transfer':
            title = 'Transfert';
            recipient = direction == 'debit'
                ? metadata['receiver_number'] ?? ''
                : metadata['sender_number'] ?? '';
            break;
          case 'withdrawal':
            title = metadata['description'] ?? 'Retrait';
            recipient = 'Point de vente';
            break;
          default:
            title = type;
            recipient = '';
        }

        amount = direction == 'debit' ? '- $montant' : '+ $montant';
        isPositive = direction == 'credit';

        // Format date: from "2025-11-18 09:35:04" to "18/11 09:35"
        String formattedDate;
        final dateParts = dateTransaction.split(' ');
        if (dateParts.length >= 2) {
          final date = dateParts[0].split('-');
          final time = dateParts[1].split(':');
          formattedDate = '${date[2]}/${date[1]} ${time[0]}:${time[1]}';
        } else {
          formattedDate = dateTransaction;
        }

        return {
          'type': type,
          'title': title,
          'recipient': recipient,
          'amount': amount,
          'date': formattedDate,
          'isPositive': isPositive,
        };
      }).toList();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final lang = Provider.of<LanguageProvider>(context).locale.languageCode;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                lang == 'fr' ? 'Historique' : 'History',
                style: TextStyle(
                  color: theme.textTheme.bodyLarge?.color,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                onPressed: () {
                  // Rafraîchir l'historique
                  setState(() {});
                },
                icon: const Icon(
                  Icons.refresh,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Expanded(
            child: ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: _transactions.length,
              itemBuilder: (context, index) {
                final originalTransaction = widget.transactions[index];
                final processedTransaction = _transactions[index];
                return Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () => widget.onTransactionTap?.call(originalTransaction),
                    borderRadius: BorderRadius.circular(10),
                    splashColor: AppColors.primary.withOpacity(0.3),
                    highlightColor: AppColors.primary.withOpacity(0.1),
                    child: _buildTransactionItem(processedTransaction),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionItem(Map<String, dynamic> transaction) {
    final theme = Theme.of(context);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.cardTheme.color,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: AppColors.primary.withOpacity(0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Icône
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: theme.scaffoldBackgroundColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              _getTransactionIcon(transaction['type']),
              color: theme.textTheme.bodySmall?.color,
              size: 20,
            ),
          ),
          const SizedBox(width: 10),
          // Détails de la transaction
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction['title'],
                  style: TextStyle(
                    color: theme.textTheme.bodyLarge?.color,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  transaction['recipient'],
                  style: TextStyle(
                    color: theme.textTheme.bodySmall?.color,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          // Montant et date avec icônes
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                children: [
                  Text(
                    '${transaction['amount']} CFA',
                    style: TextStyle(
                      color: transaction['isPositive']
                          ? Colors.green
                          : theme.textTheme.bodyLarge?.color,
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Icon(
                    Icons.search,
                    color: theme.textTheme.bodySmall?.color,
                    size: 14,
                  ),
                  const SizedBox(width: 3),
                  Icon(
                    Icons.keyboard_arrow_down,
                    color: theme.textTheme.bodySmall?.color,
                    size: 14,
                  ),
                ],
              ),
              const SizedBox(height: 2),
              Text(
                transaction['date'],
                style: TextStyle(
                  color: theme.textTheme.bodySmall?.color,
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  IconData _getTransactionIcon(String type) {
    switch (type) {
      case 'achat_pass':
        return Icons.card_giftcard;
      case 'achat_credit':
        return Icons.phone_android;
      case 'retrait':
        return Icons.attach_money;
      default:
        return Icons.receipt;
    }
  }
}
