import 'dart:io';
import 'package:om_paie_flutter/core/data/services/api.service.impl.dart';
import 'package:om_paie_flutter/features/auth/auth.service.dart';
import 'package:om_paie_flutter/features/auth/token.manager.dart';

void main() async {
  print(" **************************** Utilisation du backend ****************************");

  final tokenManager = TokenManager();
  await tokenManager.loadTokens(); // Charger les tokens existants si présents

  final api = ApiServiceImpl("http://localhost:8000/api", tokenManager: tokenManager);
  final authService = AuthService(api);

  // --- Étape 1 : Login ---
  stdout.write("Entrez votre téléphone : ");
  final telephone = stdin.readLineSync()?.trim() ?? "";

  stdout.write("Entrez votre code : ");
  final code = stdin.readLineSync()?.trim() ?? "";

  try {
    final loginResponse = await authService.login(
      telephone: telephone,
      code: code,
    );

    print("\n${loginResponse['message']}");
    print("OTP (pour test) : ${loginResponse['code_otp']}");

    // --- Étape 2 : Confirmation OTP ---
    stdout.write("\nEntrez le code OTP reçu : ");
    final otp = stdin.readLineSync()?.trim() ?? "";

    final confirmResponse = await authService.confirmLoginOTP(
      telephone: telephone,
      otpCode: otp, // utilisation du code OTP saisi
    );

    print("\n✅ Login confirmé !");

    // Sauvegarde des tokens dans TokenManager
    await tokenManager.setTokens(
      accessToken: confirmResponse['access_token'],
      refreshToken: confirmResponse['refresh_token'],
    );

    print("Access Token sauvegardé : ${tokenManager.accessToken}");
    print("Refresh Token sauvegardé: ${tokenManager.refreshToken}");

  } catch (e) {
    print("\n❌ Erreur : $e");
  }
}
