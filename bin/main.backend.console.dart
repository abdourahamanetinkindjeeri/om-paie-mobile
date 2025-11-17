import 'dart:io';
import 'package:om_paie_flutter/core/data/services/api.service.impl.dart';
import 'package:om_paie_flutter/features/auth/auth.service.dart';
import 'package:om_paie_flutter/features/auth/token.manager.dart';
import 'package:om_paie_flutter/features/comptes/compte.service.dart';

void main() async {
  final tokenManager = TokenManager();
  await tokenManager.loadTokens();

  final api = ApiServiceImpl(
    "http://localhost:8000/api",
    tokenManager: tokenManager,
  );

  final authService = AuthService(api);
  final compteService = CompteService(api);

  stdout.write("Entrez votre téléphone : ");
  final telephone = stdin.readLineSync()?.trim() ?? "";

  stdout.write("Entrez votre code : ");
  final code = stdin.readLineSync()?.trim() ?? "";

  try {
    // --- LOGIN ---
    final loginResponse =
    await authService.login(telephone: telephone, code: code);

    print("\n${loginResponse['message']}");
    print("➡️ OTP (pour test) : ${loginResponse['code_otp']}");

    stdout.write("\nEntrez le code OTP reçu : ");
    final otp = stdin.readLineSync()?.trim() ?? "";

    final confirmResponse = await authService.confirmLoginOTP(
      telephone: telephone,
      otpCode: otp,
    );

    print("\n✅ Login confirmé !");

    // Sauvegarde access_token + refresh_token
    tokenManager.setTokens(
      accessToken: confirmResponse['access_token'],
      refreshToken: confirmResponse['refresh_token'],
    );

    // --- SOLDE DU COMPTE ---
    stdout.write("\nEntrez le numéro de compte : ");
    final numeroCompte = stdin.readLineSync()?.trim() ?? "";

    if (numeroCompte.isEmpty) {
      print("⚠️ Numéro de compte manquant.");
      return;
    }

    final balanceData = await compteService.getBalance(numeroCompte);

    print("\n💰 Solde du compte $numeroCompte : ${balanceData['solde']} XOF");

    // --- HISTORIQUE ---
    stdout.write("\nAfficher l'historique ? (o/n) : ");
    final choix = stdin.readLineSync()?.trim().toLowerCase() ?? "";

    if (choix == "o") {
      final historyResponse = await compteService.getHistory(numeroCompte);

      print("\n📜 Historique des transactions :\n");

      final List<dynamic> transactions = historyResponse["data"];

//       for (var tx in transactions) {
//         print("""
// -----------------------------
// Réf       : ${tx['reference']}
// Type      : ${tx['type']}
// Montant   : ${tx['montant']} XOF
// Statut    : ${tx['statut']}
// Direction : ${tx['direction']}
// Date      : ${tx['date_transaction']}
// """);
//       }
//
//       print("-----------------------------");
//       print("Page ${historyResponse['pagination']['current_page']} "
//           "/ ${historyResponse['pagination']['total_pages']}");

      for (var tx in transactions) {

        // déterminer le receveur selon le type
        String receiver = "N/A";

        if (tx['type'] == "transfer") {
          receiver = tx['metadata']?['receiver_number'] ?? "N/A";
        } else if (tx['type'] == "payment") {
          receiver = tx['metadata']?['merchant_code'] ?? "N/A";
        }

        print("""
-----------------------------
Réf       : ${tx['reference']}
Type      : ${tx['type']}
Montant   : ${tx['montant']} XOF
Statut    : ${tx['statut']}
Direction : ${tx['direction']}
Receveur  : $receiver
Date      : ${tx['date_transaction']}
""");
      }
      print("-----------------------------");
      print("Page ${historyResponse['pagination']['current_page']} "
          "/ ${historyResponse['pagination']['total_pages']}");

    }



  } catch (e) {
    print("\n❌ Erreur : $e");
  }
}
