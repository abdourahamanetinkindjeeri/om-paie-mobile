import 'package:flutter/material.dart';
import 'package:om_paie_flutter/features/auth/auth.service.dart';
import 'package:om_paie_flutter/features/auth/itoken_manager.dart';
import 'package:om_paie_flutter/features/comptes/compte.service.dart';
import 'package:om_paie_flutter/ui/screen/dashboard_screen.dart';
import 'package:om_paie_flutter/ui/screen/otp_screen.dart';

/// Classe de gestion des routes de l'application
class AppRoutes {
  // Noms des routes
  static const String home = '/';
  static const String login = '/login';
  static const String pinCode = '/pin-code';
  static const String otp = '/otp';
  static const String dashboard = '/dashboard';
  static const String profile = '/profile';
  static const String settings = '/settings';
  static const String help = '/help';
  static const String transfer = '/transfer';
  static const String payment = '/payment';
  static const String transactions = '/transactions';

  /// Générateur de routes dynamiques pour les routes avec paramètres
  static Route<dynamic>? onGenerateRoute(
    RouteSettings settings, {
    required AuthService authService,
    required ITokenManager tokenManager,
    required CompteService compteService,
  }) {
    switch (settings.name) {
      case dashboard:
        return MaterialPageRoute(
          builder: (context) => DashboardScreen(
            authService: authService,
            tokenManager: tokenManager,
            compteService: compteService,
          ),
        );

      case otp:
        final args = settings.arguments as Map<String, dynamic>?;
        if (args != null && args['phoneNumber'] != null) {
          return MaterialPageRoute(
            builder: (context) => OtpScreen(
              phoneNumber: args['phoneNumber'] as String,
              authService: authService,
              tokenManager: tokenManager,
              compteService: compteService,
            ),
          );
        }
        return null;

      default:
        return null;
    }
  }

  /// Route par défaut en cas d'erreur
  static Route<dynamic> onUnknownRoute(RouteSettings settings) {
    return MaterialPageRoute(
      builder: (context) => Scaffold(
        body: Center(
          child: Text('Page non trouvée: ${settings.name}'),
        ),
      ),
    );
  }
}
