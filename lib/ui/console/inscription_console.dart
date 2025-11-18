import 'dart:io';
import 'package:om_paie_flutter/core/errors/api.exception.dart';
import 'package:om_paie_flutter/features/auth/auth.service.dart';
import 'package:om_paie_flutter/ui/console/console_styles.dart';

// ================= INSCRIPTION =================
Future<void> inscription(AuthService authService) async {
  print("\n===== $blue📝 INSCRIPTION UTILISATEUR $reset =====\n");

  stdout.write("${blue}Téléphone (+221...) : $reset");
  final telephone = stdin.readLineSync()?.trim() ?? "";

  stdout.write("${blue}Email : $reset");
  final email = stdin.readLineSync()?.trim() ?? "";

  stdout.write("${blue}Nom : ${reset}");
  final nom = stdin.readLineSync()?.trim() ?? "";

  stdout.write("${blue}Prénom : ${reset}");
  final prenom = stdin.readLineSync()?.trim() ?? "";

  stdout.write("${blue}Type pièce (cin/passport) : ${reset}");
  final typePiece = stdin.readLineSync()?.trim() ?? "";

  stdout.write("${blue}Numéro pièce : ${reset}");
  final numeroPiece = stdin.readLineSync()?.trim() ?? "";

  stdout.write("${blue}Adresse : ${reset}");
  final adresse = stdin.readLineSync()?.trim() ?? "";

  stdout.write("${blue}Code PIN à 4 chiffres : ${reset}");
  final code = stdin.readLineSync()?.trim() ?? "";

  try {
    final res = await authService.register({
      "telephone": telephone,
      "email": email,
      "nom": nom,
      "prenom": prenom,
      "type_piece": typePiece,
      "numero": numeroPiece,
      "adresse": adresse,
      "code": code
    });

    print("\n${green}📩 OTP envoyé à $telephone${reset}");
    print("${green}Message : ${res.message}${reset}");
    print("\n ${green} OTP : (${res.codeOtp})");
    print("${green}Expire dans : ${res.expiresInMinutes} minutes${reset}");

    stdout.write("\n${blue}👉 Entrez le code OTP reçu : ${reset}");
    final otp = stdin.readLineSync()?.trim() ?? "";

    if (otp.isEmpty) {
      print("${red}⚠️ OTP manquant.${reset}");
      return;
    }

    final confirm = await authService.confirmRegister(
      telephone: telephone,
      codeOtp: otp,
    );

    print("\n${green}✅ INSCRIPTION RÉUSSIE !${reset}");
    print("${green}Message : ${confirm['message']}${reset}");
    print("${green}Utilisateur créé : ${confirm['data']}${reset}");
  } catch (e) {
    if (e is ApiException) {
      print("${red}❌ Erreur lors de l'inscription :${reset}");
      print("${red}   Message : ${e.message}${reset}");
      print("${red}   Code HTTP : ${e.statusCode}${reset}");

      if (e.details != null && e.details!.isNotEmpty) {
        print("\n${red}📋 Détails des erreurs de validation :${reset}");
        e.details!.forEach((field, errors) {
          print("${red}   • $field :${reset}");
          if (errors is List) {
            for (var error in errors) {
              print("${red}     - $error${reset}");
            }
          } else {
            print("${red}     - $errors${reset}");
          }
        });
      }
    } else {
      print("${red}❌ Erreur lors de l'inscription : $e${reset}");
    }
  }
}
