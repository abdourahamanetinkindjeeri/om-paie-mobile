import 'dart:io';

import 'package:om_paie_flutter/core/data/services/api.service.impl.dart';
import 'package:om_paie_flutter/features/auth/auth.service.dart';
import 'package:intl/intl.dart';

void main() async {
  print(" **************************** Utilisation du backend ****************************");
  final api = ApiServiceImpl("http://localhost:8000/api");
  final authService = AuthService(api);
  //
  // // Étape 1 : inscription
  // final res = await authService.register({
  //   "telephone": "+221779234567",
  //   "email": "dev1.test1ghost@gmail.com",
  //   "nom": "Diop",
  //   "prenom": "Mamadou",
  //   "type_piece": "cin",
  //   "numero": "A1234567891120",
  //   "adresse": "Dakar, Sénégal",
  //   "code": "1234"
  // });
  //
  // print("OTP envoyé : ${res.codeOtp} - ${res.success} - ${res.expiresInMinutes} minutes - ${res.message}");
  //
  // // Étape 2 : demander OTP et numéro
  // stdout.write("👉 Entrez votre numéro de téléphone : ");
  // final numero = stdin.readLineSync();
  //
  // stdout.write("👉 Entrez le code OTP reçu : ");
  // final otp = stdin.readLineSync();
  //
  // if (numero != null && otp != null) {
  //   try {
  //     final confirmRes = await authService.confirmRegister(
  //       telephone: numero,
  //       codeOtp: otp,
  //     );
  //
  //     print("✅ Confirmation réussie : ${confirmRes['message']}");
  //     print("Données : ${confirmRes['data']}");
  //   } catch (e) {
  //     print("❌ Erreur lors de la confirmation : $e");
  //   }
  // } else {
  //   print("⚠️ Numéro ou OTP manquant.");
  // }

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
      codeOtp: otp,
    );

    print("\n✅ Login confirmé !");
    print("Access Token : ${confirmResponse['data']['access_token']}");
    print("Refresh Token: ${confirmResponse['data']['refresh_token']}");

  } catch (e) {
    print("\n❌ Erreur : $e");
  }
}
