import 'dart:io';
import 'package:om_paie_flutter/core/data/services/api.service.impl.dart';
import 'package:om_paie_flutter/features/auth/auth.service.dart';
import 'package:om_paie_flutter/features/auth/token.manager.dart';
import 'package:om_paie_flutter/features/comptes/compte.service.dart';

// === Codes ANSI ===
const String green = "\x1B[32m";
const String red = "\x1B[31m";
const String blue = "\x1B[34m";
const String reset = "\x1B[0m";

Future<void> main() async {
  final tokenManager = TokenManager();
  await tokenManager.loadTokens();

  final api = ApiServiceImpl(
    "http://localhost:8000/api",
    tokenManager: tokenManager,
  );

  final authService = AuthService(api);
  final compteService = CompteService(api);

  while (true) {
    print("\n===== ${blue}🏦 MENU PRINCIPAL${reset} =====");
    print("1. Inscription");
    print("2. Login");
    print("3. Quitter");

    stdout.write("\n${blue}Votre choix : ${reset}");
    final choix = stdin.readLineSync()?.trim() ?? "";

    if (choix == "1") {
      await inscription(authService);
    } else if (choix == "2") {
      await loginMenu(authService, compteService, tokenManager);
    } else if (choix == "3") {
      print("${blue}👋 Au revoir !${reset}");
      break;
    } else {
      print("${red}⚠️ Choix invalide, réessayez.${reset}");
    }
  }
}

// ================= INSCRIPTION =================
Future<void> inscription(AuthService authService) async {
  print("\n===== ${blue}📝 INSCRIPTION UTILISATEUR${reset} =====\n");

  stdout.write("${blue}Téléphone (+221...) : ${reset}");
  final telephone = stdin.readLineSync()?.trim() ?? "";

  stdout.write("${blue}Email : ${reset}");
  final email = stdin.readLineSync()?.trim() ?? "";

  stdout.write("${blue}Nom : ${reset}");
  final nom = stdin.readLineSync()?.trim() ?? "";

  stdout.write("${blue}Prénom : ${reset}");
  final prenom = stdin.readLineSync()?.trim() ?? "";

  stdout.write("${blue}Type pièce (cin/passport/permis) : ${reset}");
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
    print("${green} OTP : (${res.codeOtp})");
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
    print("${red}❌ Erreur lors de l'inscription : $e${reset}");
  }
}

// ================= LOGIN =================
Future<void> loginMenu(AuthService authService, CompteService compteService, TokenManager tokenManager) async {
  stdout.write("\n${blue}Téléphone : ${reset}");
  final telephone = stdin.readLineSync()?.trim() ?? "";

  stdout.write("${blue}Code PIN : ${reset}");
  final code = stdin.readLineSync()?.trim() ?? "";

  try {
    final loginResponse = await authService.login(telephone: telephone, code: code);

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

    await compteMenu(compteService);

  } catch (e) {
    print("${red}❌ Erreur login : $e${reset}");
  }
}

// ================= MENU COMPTE =================
Future<void> compteMenu(CompteService compteService) async {
  stdout.write("\n${blue}Entrez le numéro de compte : ${reset}");
  final numeroCompte = stdin.readLineSync()?.trim() ?? "";

  if (numeroCompte.isEmpty) {
    print("${red}⚠️ Numéro de compte manquant.${reset}");
    return;
  }

  // --- Solde ---
  try {
    final balanceData = await compteService.getBalance(numeroCompte);
    print("\n${green}💰 Solde du compte $numeroCompte : ${balanceData['solde']} XOF${reset}");
  } catch (e) {
    print("${red}❌ Impossible de récupérer le solde : $e${reset}");
  }

  // --- Historique ---
  stdout.write("\n${blue}Afficher l'historique ? (o/n) : ${reset}");
  final showHistory = stdin.readLineSync()?.trim().toLowerCase() ?? "";

  if (showHistory == "o") {
    try {
      final historyResponse = await compteService.getHistory(numeroCompte);
      final List<dynamic> transactions = historyResponse["data"];

      print("\n${blue}📜 Historique des transactions :${reset}\n");

      for (var tx in transactions) {
        String receiver = "N/A";
        if (tx['type'] == "transfer") {
          receiver = tx['metadata']?['receiver_number'] ?? "N/A";
        } else if (tx['type'] == "payment") {
          receiver = tx['metadata']?['merchant_name'] ?? "N/A";
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
      print("${blue}Page ${historyResponse['pagination']['current_page']} "
          "/ ${historyResponse['pagination']['total_pages']}${reset}");

    } catch (e) {
      print("${red}❌ Impossible de récupérer l'historique : $e${reset}");
    }
  }

  // --- Transfert ---
  stdout.write("\n${blue}Voulez-vous effectuer un transfert ? (o/n) : ${reset}");
  final transfertChoice = stdin.readLineSync()?.trim().toLowerCase() ?? "";

  if (transfertChoice == "o") {
    stdout.write("${blue}Numéro du destinataire : ${reset}");
    final destinataire = stdin.readLineSync()?.trim() ?? "";

    stdout.write("${blue}Montant à transférer : ${reset}");
    final montantInput = stdin.readLineSync()?.trim() ?? "0";
    final montant = int.tryParse(montantInput) ?? 0;

    if (destinataire.isNotEmpty && montant > 0) {
      try {
        final transfert = await compteService.transfer(
          numeroCompte: numeroCompte,
          telephoneDestinataire: destinataire,
          montant: montant,
        );

        final data = transfert["data"];

        print("\n${green}🎉 Transfert réussi !${reset}");
        print("""
----------------------------------------
Référence    : ${data['reference']}
Montant      : ${data['montant']} XOF
Statut       : ${data['statut']}
Date         : ${data['date_transfert']}

Expéditeur   : ${data['expediteur']['numero']}
Nouveau solde: ${data['expediteur']['nouveau_solde']}

Destinataire : ${data['destinataire']['numero']}
Nom          : ${data['destinataire']['nom_complet']}
----------------------------------------
""");

      } catch (e) {
        print("${red}❌ Erreur transfert : $e${reset}");
      }
    } else {
      print("${red}⚠️ Données de transfert invalides.${reset}");
    }
  }

  // --- Paiement ---
  stdout.write("\n${blue}Voulez-vous effectuer un paiement ? (o/n) : ${reset}");
  final payChoice = stdin.readLineSync()?.trim().toLowerCase() ?? "";

  if (payChoice == "o") {
    stdout.write("${blue}Code marchand : ${reset}");
    final codeMerchant = stdin.readLineSync()?.trim() ?? "";

    stdout.write("${blue}Montant à payer : ${reset}");
    final montantInput = stdin.readLineSync()?.trim() ?? "0";
    final montant = int.tryParse(montantInput) ?? 0;

    if (codeMerchant.isNotEmpty && montant > 0) {
      try {
        final paiement = await compteService.payement(
          numeroCompte: numeroCompte,
          codeMerchant: codeMerchant,
          montant: montant,
        );

        final data = paiement['data'];

        print("\n${green}💳 Paiement réussi !${reset}");
        print("""
----------------------------------------
Référence  : ${data['reference']}
Montant    : ${data['montant']} XOF
Statut     : ${data['statut']}
Date       : ${data['date_payment'] ?? DateTime.now()}
Destinataire: ${data['destinataire']?['nom_complet'] ?? codeMerchant}
----------------------------------------
""");

      } catch (e) {
        print("${red}❌ Erreur paiement : $e${reset}");
      }
    } else {
      print("${red}⚠️ Données de paiement invalides.${reset}");
    }
  }
}
