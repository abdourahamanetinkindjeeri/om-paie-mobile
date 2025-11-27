import 'package:flutter/material.dart';
import 'package:om_paie_flutter/constants/app_colors.dart';
import 'package:qr_flutter/qr_flutter.dart';

class DashboardHeader extends StatefulWidget {
  final Map<String, dynamic>? userProfile;
  final List<Map<String, dynamic>> comptes;
  final Map<String, dynamic>? qrCode;
  final VoidCallback onMenuPressed;
  final VoidCallback? onBalanceRefresh;

  const DashboardHeader({
    Key? key,
    this.userProfile,
    this.comptes = const [],
    this.qrCode,
    required this.onMenuPressed,
    this.onBalanceRefresh,
  }) : super(key: key);

  @override
  State<DashboardHeader> createState() => _DashboardHeaderState();
}

class _DashboardHeaderState extends State<DashboardHeader> {
  bool _isBalanceVisible = true;

  @override
  Widget build(BuildContext context) {
    final userName =
        '${widget.userProfile?['prenom'] ?? ''} ${widget.userProfile?['nom'] ?? 'Utilisateur'}'
            .trim();
    final balance = widget.comptes.isNotEmpty
        ? (widget.comptes[0]['solde'] is num
            ? (widget.comptes[0]['solde'] as num).toStringAsFixed(3)
            : widget.comptes[0]['solde']?.toString() ?? '0')
        : '0';
    final devise = widget.comptes.isNotEmpty
        ? widget.comptes[0]['devise'] ?? 'CFA'
        : 'CFA';
    final displayBalance = _isBalanceVisible ? '$balance $devise' : '****';

    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.fromLTRB(15, 8, 15, 8),
      decoration: const BoxDecoration(
        color: Colors.black, // Couleur sombre forcée pour le header
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: widget.onMenuPressed,
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        child: Icon(
                          Icons.menu,
                          color: theme.textTheme.bodyLarge?.color,
                          size: 24,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Bonjour',
                            style: TextStyle(
                              color: theme.textTheme.bodyLarge?.color,
                              fontSize: 14,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                          Text(
                            userName,
                            style: const TextStyle(
                              color: AppColors.primary,
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 2),
                          Row(
                            children: [
                              Text(
                                displayBalance,
                                style: const TextStyle(
                                  color: AppColors.primary,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(width: 6),
                              IconButton(
                                onPressed: () {
                                  if (widget.onBalanceRefresh != null) {
                                    widget.onBalanceRefresh!();
                                  }
                                  setState(() {
                                    _isBalanceVisible = !_isBalanceVisible;
                                  });
                                },
                                icon: Icon(
                                  _isBalanceVisible
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: theme.textTheme.bodySmall?.color,
                                  size: 14,
                                ),
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  border: Border.all(
                      color: theme.textTheme.bodyLarge?.color ?? Colors.white,
                      width: 2),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: QrImageView(
                    data: widget.qrCode?['qr_string'] ??
                        'OM_PAY_${userName.hashCode}',
                    version: 5,
                    size: 100,
                    gapless: true,
                    dataModuleStyle: const QrDataModuleStyle(
                      dataModuleShape: QrDataModuleShape.square,
                      color: Colors.black,
                    ),
                    eyeStyle: const QrEyeStyle(
                      eyeShape: QrEyeShape.circle,
                      color: Colors.black,
                    ),
                    backgroundColor: Colors.white,
                    errorCorrectionLevel: QrErrorCorrectLevel.M,
                    errorStateBuilder: (cxt, err) {
                      return Container(
                        width: 100,
                        height: 100,
                        color: theme.cardTheme.color,
                        child: Icon(
                          Icons.qr_code,
                          color: theme.textTheme.bodyLarge?.color,
                          size: 60,
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
