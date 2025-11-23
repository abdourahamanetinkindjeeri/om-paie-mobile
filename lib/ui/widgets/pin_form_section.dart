import 'package:flutter/material.dart';
import 'package:om_paie_flutter/constants/app_colors.dart';
import 'package:om_paie_flutter/constants/app_strings.dart';
import 'package:om_paie_flutter/features/auth/auth.service.dart';
import 'package:om_paie_flutter/features/auth/itoken_manager.dart';
import 'package:om_paie_flutter/features/comptes/compte.service.dart';
import 'package:om_paie_flutter/ui/screen/otp_screen.dart';
import 'package:om_paie_flutter/ui/screen/dashboard_screen.dart';

class PinFormSection extends StatefulWidget {
  final String phoneNumber;
  final AuthService authService;
  final ITokenManager tokenManager;
  final CompteService compteService;

  const PinFormSection({
    Key? key,
    required this.phoneNumber,
    required this.authService,
    required this.tokenManager,
    required this.compteService,
  }) : super(key: key);

  @override
  State<PinFormSection> createState() => _PinFormSectionState();
}

class _PinFormSectionState extends State<PinFormSection> {
  final List<TextEditingController> _controllers = List<TextEditingController>.generate(
    4,
    (int index) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List<FocusNode>.generate(
    4,
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

  String get pinCode {
    return _controllers.map<String>((TextEditingController c) => c.text).join();
  }

  void _onPinChanged(int index, String value) {
    if (value.isNotEmpty && index < 3) {
      _focusNodes[index + 1].requestFocus();
    } else if (value.isEmpty && index > 0) {
      _focusNodes[index - 1].requestFocus();
    }

    if (pinCode.length == 4) {
      _performLogin();
    }
  }

  Future<void> _performLogin() async {
    try {
      final loginResponse = await widget.authService.login(
        telephone: widget.phoneNumber,
        code: pinCode,
      );

      if (mounted) {
        _showOtpConfirmationDialog(loginResponse['code_otp']);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur login: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _showOtpConfirmationDialog(String otpCode) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmation OTP'),
          content: const Text('Voulez-vous utiliser le code OTP automatiquement ou le saisir manuellement ?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _confirmOtpDirectly(otpCode);
              },
              child: const Text('Utiliser automatiquement'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _navigateToOtpScreen();
              },
              child: const Text('Saisir manuellement'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _confirmOtpDirectly(String otpCode) async {
    try {
      final confirmResponse = await widget.authService.confirmLoginOTP(
        telephone: widget.phoneNumber,
        otpCode: otpCode,
      );

      await widget.tokenManager.setTokens(
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
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => DashboardScreen(
              authService: widget.authService,
              tokenManager: widget.tokenManager,
              compteService: widget.compteService,
            ),
          ),
        );
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

  void _navigateToOtpScreen() {
    Navigator.push(
      context,
      MaterialPageRoute<OtpScreen>(
        builder: (BuildContext context) => OtpScreen(
          phoneNumber: widget.phoneNumber,
          authService: widget.authService,
          tokenManager: widget.tokenManager,
          compteService: widget.compteService,
        ),
      ),
    );
  }

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
              const SizedBox(height: 20),
              Text(
                AppStrings.pinInstruction,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '+221 ${widget.phoneNumber}',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 14,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 35),
              // Champs PIN
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List<Widget>.generate(4, (int index) {
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 6),
                    width: 60,
                    height: 70,
                    child: TextField(
                      controller: _controllers[index],
                      focusNode: _focusNodes[index],
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.number,
                      maxLength: 1,
                      obscureText: true,
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 28,
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
                      onChanged: (String value) => _onPinChanged(index, value),
                      onTap: () {
                        _controllers[index].selection = TextSelection.fromPosition(
                          TextPosition(offset: _controllers[index].text.length),
                        );
                      },
                    ),
                  );
                }),
              ),
              const SizedBox(height: 30),
              // Bouton valider
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: pinCode.length == 4
                      ? () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Connexion réussie !'),
                              backgroundColor: AppColors.primary,
                            ),
                          );
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    disabledBackgroundColor: AppColors.border,
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    AppStrings.validateButton,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
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