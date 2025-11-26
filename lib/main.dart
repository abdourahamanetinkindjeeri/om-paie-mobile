import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:om_paie_flutter/constants/app_colors.dart';
import 'package:om_paie_flutter/constants/app_strings.dart';
import 'package:om_paie_flutter/constants/app_themes.dart';
import 'package:om_paie_flutter/core/config.dart';
import 'package:om_paie_flutter/core/data/services/api.service.impl.dart';
import 'package:om_paie_flutter/core/storage/secure_storage.dart';
import 'package:om_paie_flutter/core/storage/storage_migration.dart';
import 'package:om_paie_flutter/features/auth/auth.service.dart';
import 'package:om_paie_flutter/features/auth/token_manager_mobile.dart';
import 'package:om_paie_flutter/features/comptes/compte.service.dart';
import 'package:om_paie_flutter/providers/auth_provider.dart';
import 'package:om_paie_flutter/providers/compte_provider.dart';
import 'package:om_paie_flutter/providers/theme_provider.dart';
import 'package:om_paie_flutter/routes/route.dart';
import 'package:om_paie_flutter/ui/widgets/carousel_section.dart';
import 'package:om_paie_flutter/ui/widgets/login_form_section.dart';
import 'package:om_paie_flutter/ui/widgets/pin_carousel_section.dart';
import 'package:om_paie_flutter/ui/widgets/pin_form_section.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Charger la configuration
  await Config.load();

  // Migrer les données de SharedPreferences vers SecureStorage si nécessaire
  await StorageMigration.migrateTokens();

  // Initialiser les services
  final tokenManager = TokenManagerMobile();
  await tokenManager.loadTokens();

  final secureStorage = SecureStorage.getInstance();

  final apiService = ApiServiceImpl(
    Config.apiBaseUrl,
    tokenManager: tokenManager,
    client: http.Client(),
  );

  final authService = AuthService(apiService);
  final compteService = CompteService(apiService);

  runApp(
    MultiProvider(
      providers: [
        // Provider pour le thème
        ChangeNotifierProvider(
          create: (_) => ThemeProvider(secureStorage),
        ),
        // Provider pour l'authentification
        ChangeNotifierProvider(
          create: (_) => AuthProvider(
            authService: authService,
            tokenManager: tokenManager,
          ),
        ),
        // Provider pour les comptes
        ChangeNotifierProvider(
          create: (_) => CompteProvider(
            compteService: compteService,
          ),
        ),
      ],
      child: const OrangeMoneyApp(),
    ),
  );
}

class OrangeMoneyApp extends StatelessWidget {
  const OrangeMoneyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          title: AppStrings.appTitle,
          debugShowCheckedModeBanner: false,
          theme: AppThemes.lightTheme,
          darkTheme: AppThemes.darkTheme,
          themeMode: themeProvider.themeMode,
          initialRoute: AppRoutes.home,
          onGenerateRoute: (settings) {
            final authProvider = Provider.of<AuthProvider>(context, listen: false);
            final compteProvider =
                Provider.of<CompteProvider>(context, listen: false);

            return AppRoutes.onGenerateRoute(
              settings,
              authService: authProvider.authService,
              tokenManager: authProvider.tokenManager,
              compteService: compteProvider.compteService,
            );
          },
          routes: {
            AppRoutes.home: (context) => const LoginScreen(),
            AppRoutes.login: (context) => const LoginScreen(),
          },
          onUnknownRoute: (settings) => AppRoutes.onUnknownRoute(settings),
        );
      },
    );
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

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

  const PinCodeScreen({
    Key? key,
    required this.phoneNumber,
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
            authService: context.read<AuthProvider>().authService,
            tokenManager: context.read<AuthProvider>().tokenManager,
            compteService: context.read<CompteProvider>().compteService,
          ),
        ],
      ),
    );
  }
}
