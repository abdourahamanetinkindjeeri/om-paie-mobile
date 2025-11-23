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
    final userName = '${widget.userProfile?['prenom'] ?? ''} ${widget.userProfile?['nom'] ?? 'Utilisateur'}'.trim();
    final balance = widget.comptes.isNotEmpty ? widget.comptes[0]['solde']?.toString() ?? '0' : '0';
    final devise = widget.comptes.isNotEmpty ? widget.comptes[0]['devise'] ?? 'CFA' : 'CFA';
    final displayBalance = _isBalanceVisible ? '$balance $devise' : '****';

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: AppColors.background,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
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
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            'Bonjour ',
                            style: const TextStyle(
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
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            'Solde: $displayBalance',
                            style: const TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
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
                              _isBalanceVisible ? Icons.visibility : Icons.visibility_off,
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
                ],
              ),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.textPrimary, width: 2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Container(
                  width: 100,
                  height: 100,
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.border, width: 1),
                  ),
                  child: Builder(
                    builder: (context) {
                      // Récupérer la chaîne QR correctement
                      String qrData;
                      if (widget.qrCode != null && widget.qrCode!['qr_string'] != null) {
                        qrData = widget.qrCode!['qr_string'] as String;
                      } else {
                        // Générer un QR code de secours avec les données de l'utilisateur
                        qrData = '{"user_id":"${userName.hashCode}","telephone":"","nom_complet":"$userName","type":"om_paie_user"}';
                      }
                      
                      return QrImageView(
                        data: qrData,
                        version: QrVersions.auto,
                        size: 88.0,
                        gapless: true,
                        dataModuleStyle: const QrDataModuleStyle(
                          dataModuleShape: QrDataModuleShape.square,
                          color: Colors.black,
                        ),
                        eyeStyle: const QrEyeStyle(
                          eyeShape: QrEyeShape.square,
                          color: Colors.black,
                        ),
                        backgroundColor: Colors.white,
                        errorCorrectionLevel: QrErrorCorrectLevel.H,
                        errorStateBuilder: (cxt, err) {
                          return Container(
                            width: 88,
                            height: 88,
                            color: AppColors.surface,
                            child: const Icon(
                              Icons.qr_code,
                              color: AppColors.textPrimary,
                              size: 44,
                            ),
                          );
                        },
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
