import 'package:flutter/material.dart';
import 'package:om_paie_flutter/constants/app_colors.dart';

class DashboardHeader extends StatelessWidget {
  final Map<String, dynamic>? userProfile;
  final List<Map<String, dynamic>> comptes;
  final VoidCallback onMenuPressed;

  const DashboardHeader({
    Key? key,
    this.userProfile,
    this.comptes = const [],
    required this.onMenuPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userName = '${userProfile?['prenom'] ?? ''} ${userProfile?['nom'] ?? 'Utilisateur'}'.trim();
    final balance = comptes.isNotEmpty ? comptes[0]['solde']?.toString() ?? '0' : '0';
    final devise = comptes.isNotEmpty ? comptes[0]['devise'] ?? 'CFA' : 'CFA';

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
                    onTap: onMenuPressed,
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
                            'Solde: $balance $devise',
                            style: const TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
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
                child: Image.network(
                  'https://api.qrserver.com/v1/create-qr-code/?size=80x80&data=OM_PAY_${userName.hashCode}',
                  width: 80,
                  height: 80,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 80,
                      height: 80,
                      color: AppColors.surface,
                      child: const Icon(
                        Icons.qr_code,
                        color: AppColors.textPrimary,
                        size: 40,
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
