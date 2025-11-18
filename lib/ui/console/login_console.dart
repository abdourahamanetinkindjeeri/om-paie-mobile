import 'dart:io';
import 'package:om_paie_flutter/features/auth/auth.service.dart';
import 'package:om_paie_flutter/features/auth/token.manager.dart';
import 'package:om_paie_flutter/features/comptes/compte.service.dart';
import 'package:om_paie_flutter/features/users/user.service.dart';
import 'package:om_paie_flutter/ui/console/console_styles.dart';
import 'package:om_paie_flutter/ui/console/user_console.dart';

// ================= LOGIN =================
Future<void> loginMenu(AuthService authService, CompteService compteService,
    UserService userService, TokenManager tokenManager) async {
  stdout.write("\n${blue}Téléphone : ${reset}");
  final telephone = stdin.readLineSync()?.trim() ?? "";

  stdout.write("${blue}Code PIN : ${reset}");
  final code = stdin.readLineSync()?.trim() ?? "";

  try {
    final loginResponse =
        await authService.login(telephone: telephone, code: code);

    print("\n${green}${loginResponse['message']}${reset}");
    print("${green}➡️ OTP (pour test) : ${loginResponse['code_otp']}${reset}");

    stdout.write("\n${blue}Entrez le code OTP reçu : ${reset}");
    final otp = stdin.readLineSync()?.trim() ?? "";

    final confirmResponse = await authService.confirmLoginOTP(
      telephone: telephone,
      otpCode: otp,
    );

    print("\n${green}✅ LOGIN CONFIRMÉ !${reset}");

    // Sauvegarde tokens
    tokenManager.setTokens(
      accessToken: confirmResponse['access_token'],
      refreshToken: confirmResponse['refresh_token'],
    );

    await userMenu(compteService, userService);
  } catch (e) {
    print("${red}❌ Erreur login : $e${reset}");
  }
}
