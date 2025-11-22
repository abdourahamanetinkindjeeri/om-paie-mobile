import 'package:flutter/material.dart';
import 'package:om_paie_flutter/constants/app_colors.dart';
import 'package:om_paie_flutter/features/auth/auth.service.dart';
import 'package:om_paie_flutter/features/auth/itoken_manager.dart';
import 'package:om_paie_flutter/ui/widgets/otp_form_section.dart';
import 'package:om_paie_flutter/ui/widgets/pin_carousel_section.dart';

// Écran de saisie du code OTP à 6 chiffres
class OtpScreen extends StatefulWidget {
  final String phoneNumber;
  final AuthService authService;
  final ITokenManager tokenManager;

  const OtpScreen({
    Key? key,
    required this.phoneNumber,
    required this.authService,
    required this.tokenManager,
  }) : super(key: key);

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          const PinCarouselSection(), // Réutiliser le carousel PIN
          OtpFormSection(
            phoneNumber: widget.phoneNumber,
            authService: widget.authService,
            tokenManager: widget.tokenManager,
          ),
        ],
      ),
    );
  }
}