import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:om_paie_flutter/constants/app_colors.dart';
import 'package:om_paie_flutter/constants/app_strings.dart';
import 'package:om_paie_flutter/core/config.dart';
import 'package:om_paie_flutter/core/data/services/api.service.impl.dart';
import 'package:om_paie_flutter/features/auth/auth.service.dart';
import 'package:om_paie_flutter/features/auth/token_manager_mobile.dart';
import 'package:om_paie_flutter/ui/widgets/carousel_section.dart';
import 'package:om_paie_flutter/ui/widgets/login_form_section.dart';
import 'package:om_paie_flutter/ui/widgets/pin_carousel_section.dart';
import 'package:om_paie_flutter/ui/widgets/pin_form_section.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Charger la configuration
  await Config.load();

  // Initialiser les services
  final tokenManager = TokenManagerMobile();
  await tokenManager.loadTokens();

  final apiService = ApiServiceImpl(
    Config.apiBaseUrl,
    tokenManager: tokenManager,
    client: http.Client(),
  );

  // final apiService = ApiServiceImpl(
  //   "http://localhost:8000/api",
  //   tokenManager: tokenManager,
  // );

  final authService = AuthService(apiService);

  runApp(OrangeMoneyApp(
    authService: authService,
    tokenManager: tokenManager,
  ));
}

class OrangeMoneyApp extends StatelessWidget {
  final AuthService authService;
  final TokenManagerMobile tokenManager;

  const OrangeMoneyApp({
    Key? key,
    required this.authService,
    required this.tokenManager,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppStrings.appTitle,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: AppColors.primary,
        scaffoldBackgroundColor: Colors.black,
      ),
      home: LoginScreen(
        authService: authService,
        tokenManager: tokenManager,
      ),
    );
  }
}

class LoginScreen extends StatefulWidget {
  final AuthService authService;
  final TokenManagerMobile tokenManager;

  const LoginScreen({
    Key? key,
    required this.authService,
    required this.tokenManager,
  }) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _phoneController = TextEditingController();
  final PageController _pageController = PageController();
  int _currentPage = 0;
  String _countryCode = '+221'; // Code pays par défaut

  @override
  void dispose() {
    _phoneController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          CarouselSection(
            pageController: _pageController,
            currentPage: _currentPage,
            onPageChanged: (int index) {
              setState(() {
                _currentPage = index;
              });
            },
          ),
          LoginFormSection(
            currentPage: _currentPage,
            phoneController: _phoneController,
            pageController: _pageController,
            onCountryCodeChanged: (String newCode) {
              setState(() {
                _countryCode = newCode;
              });
            },
            onLoginPressed: () {
              if (_phoneController.text.isNotEmpty) {
                // Combiner le code pays avec le numéro saisi
                final fullPhoneNumber = '$_countryCode${_phoneController.text}';
                Navigator.push(
                  context,
                  MaterialPageRoute<PinCodeScreen>(
                    builder: (BuildContext context) => PinCodeScreen(
                      phoneNumber: fullPhoneNumber,
                      authService: widget.authService,
                      tokenManager: widget.tokenManager,
                    ),
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}

// Écran de saisie du code PIN à 4 chiffres
class PinCodeScreen extends StatefulWidget {
  final String phoneNumber;
  final AuthService authService;
  final TokenManagerMobile tokenManager;

  const PinCodeScreen({
    Key? key,
    required this.phoneNumber,
    required this.authService,
    required this.tokenManager,
  }) : super(key: key);

  @override
  State<PinCodeScreen> createState() => _PinCodeScreenState();
}

class _PinCodeScreenState extends State<PinCodeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          const PinCarouselSection(),
          PinFormSection(
            phoneNumber: widget.phoneNumber,
            authService: widget.authService,
            tokenManager: widget.tokenManager,
          ),
        ],
      ),
    );
  }
}
