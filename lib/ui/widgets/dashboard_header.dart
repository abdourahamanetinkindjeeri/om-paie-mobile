import 'package:flutter/material.dart';
import 'package:om_paie_flutter/constants/app_colors.dart';
import 'package:qr_flutter/qr_flutter.dart';

class DashboardHeader extends StatefulWidget {
  final Map<String, dynamic>? userProfile;
  final List<Map<String, dynamic>> comptes;
  final Map<String, dynamic>? qrCode;
  final VoidCallback onMenuPressed;

  const DashboardHeader({
    Key? key,
    this.userProfile,
    this.comptes = const [],
    this.qrCode,
    required this.onMenuPressed,
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
        ? widget.comptes[0]['solde']?.toString() ?? '0'
        : '0';
    final devise = widget.comptes.isNotEmpty
        ? widget.comptes[0]['devise'] ?? 'CFA'
        : 'CFA';
    final displayBalance = _isBalanceVisible ? '$balance $devise' : '****';

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
      decoration: const BoxDecoration(
        color: AppColors.background,
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
                        padding: const EdgeInsets.all(8),
                        child: const Icon(
                          Icons.menu,
                          color: AppColors.textPrimary,
                          size: 28,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Bonjour',
                            style: TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: 18,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                          Text(
                            userName,
                            style: const TextStyle(
                              color: AppColors.primary,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Text(
                                displayBalance,
                                style: const TextStyle(
                                  color: AppColors.primary,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(width: 8),
                              IconButton(
                                onPressed: () {
                                  setState(() {
                                    _isBalanceVisible = !_isBalanceVisible;
                                  });
                                },
                                icon: Icon(
                                  _isBalanceVisible
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: AppColors.textSecondary,
                                  size: 16,
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
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.textPrimary, width: 2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: QrImageView(
                    data: widget.qrCode?['qr_string'] ??
                        'OM_PAY_${userName.hashCode}',
                    version: 5,
                    size: 90,
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
                        width: 90,
                        height: 90,
                        color: AppColors.surface,
                        child: const Icon(
                          Icons.qr_code,
                          color: AppColors.textPrimary,
                          size: 50,
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
