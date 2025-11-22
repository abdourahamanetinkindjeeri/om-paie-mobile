import 'package:flutter/material.dart';
import 'package:om_paie_flutter/constants/app_colors.dart';
import 'package:om_paie_flutter/constants/app_strings.dart';
import 'package:om_paie_flutter/ui/widgets/login_button.dart';
import 'package:om_paie_flutter/ui/widgets/page_indicators.dart';
import 'package:om_paie_flutter/ui/widgets/phone_input_row.dart';

class LoginFormSection extends StatelessWidget {
  final int currentPage;
  final TextEditingController phoneController;
  final PageController pageController;
  final VoidCallback onLoginPressed;
  final ValueChanged<String>? onCountryCodeChanged;

  const LoginFormSection({
    Key? key,
    required this.currentPage,
    required this.phoneController,
    required this.pageController,
    required this.onLoginPressed,
    this.onCountryCodeChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 5,
      child: Container(
        color: AppColors.background,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            children: <Widget>[
              PageIndicators(
                currentPage: currentPage,
                onPageChanged: (int index) {
                  pageController.animateToPage(
                    index,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                },
              ),
              const SizedBox(height: 35),
              Text(
                AppStrings.welcomeMessage,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                AppStrings.loginInstruction,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 14,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 28),
              PhoneInputRow(
                controller: phoneController,
                onCountryCodeChanged: onCountryCodeChanged,
              ),
              const SizedBox(height: 24),
              LoginButton(
                onPressed: onLoginPressed,
              ),
              const SizedBox(height: 18),
              Text(
                AppStrings.copyright,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: AppColors.textMuted,
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
