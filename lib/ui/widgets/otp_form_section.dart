import 'package:provider/provider.dart';
import 'package:om_paie_flutter/providers/auth_provider.dart';
import 'package:om_paie_flutter/providers/language_provider.dart';
import 'package:flutter/material.dart';
import 'package:om_paie_flutter/constants/app_colors.dart';
import 'package:om_paie_flutter/constants/app_strings.dart';

class OtpFormSection extends StatefulWidget {
  final String phoneNumber;

  const OtpFormSection({
    Key? key,
    required this.phoneNumber,
  }) : super(key: key);

  @override
  State<OtpFormSection> createState() => _OtpFormSectionState();
}

class _OtpFormSectionState extends State<OtpFormSection> {
  final List<TextEditingController> _controllers =
      List<TextEditingController>.generate(
    6,
    (int index) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List<FocusNode>.generate(
    6,
    (int index) => FocusNode(),
  );

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNodes[0].requestFocus();
    });
  }

  @override
  void dispose() {
    for (TextEditingController controller in _controllers) {
      controller.dispose();
    }
    for (FocusNode node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  String get otpCode {
    return _controllers.map<String>((TextEditingController c) => c.text).join();
  }

  void _onOtpChanged(int index, String value) {
    if (value.isNotEmpty && index < 5) {
      _focusNodes[index + 1].requestFocus();
    } else if (value.isEmpty && index > 0) {
      _focusNodes[index - 1].requestFocus();
    }

    if (otpCode.length == 6) {
      _confirmOtp();
    }
  }

  Future<void> _confirmOtp() async {
    try {
      final authService = context.read<AuthProvider>().authService;
      final tokenManager = context.read<AuthProvider>().tokenManager;

      final confirmResponse = await authService.confirmLoginOTP(
        telephone: widget.phoneNumber,
        otpCode: otpCode,
      );

      await tokenManager.setTokens(
        accessToken: confirmResponse['access_token'],
        refreshToken: confirmResponse['refresh_token'],
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Connexion réussie !'),
            backgroundColor: AppColors.primary,
          ),
        );
        // Naviguer vers le dashboard
        Navigator.of(context).pushReplacementNamed('/dashboard');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur confirmation OTP: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final lang = Provider.of<LanguageProvider>(context).locale.languageCode;
    final strings = AppStrings.of(lang);
    return Expanded(
      flex: 5,
      child: Container(
        color: AppColors.background,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            children: <Widget>[
              const SizedBox(height: 20),
              Text(
                lang == 'fr' ? 'Saisir le code OTP' : 'Enter OTP code',
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '${strings.countryCode} ${widget.phoneNumber}',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 14,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 35),
              // Champs OTP
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List<Widget>.generate(6, (int index) {
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: 50,
                    height: 60,
                    child: TextField(
                      controller: _controllers[index],
                      focusNode: _focusNodes[index],
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.number,
                      maxLength: 1,
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                      decoration: InputDecoration(
                        counterText: '',
                        filled: true,
                        fillColor: AppColors.surface,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: AppColors.border),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: AppColors.border),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: AppColors.primary,
                            width: 2,
                          ),
                        ),
                      ),
                      onChanged: (String value) => _onOtpChanged(index, value),
                      onTap: () {
                        _controllers[index].selection =
                            TextSelection.fromPosition(
                          TextPosition(offset: _controllers[index].text.length),
                        );
                      },
                    ),
                  );
                }),
              ),
              const SizedBox(height: 30),
              Text(
                strings.copyright,
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
