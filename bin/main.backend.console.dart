import 'dart:io';
import 'package:om_paie_flutter/core/data/services/api.service.impl.dart';
import 'package:om_paie_flutter/core/errors/api.exception.dart';
import 'package:om_paie_flutter/features/auth/auth.service.dart';
import 'package:om_paie_flutter/features/auth/token.manager.dart';
import 'package:om_paie_flutter/features/comptes/compte.service.dart';
import 'package:om_paie_flutter/features/users/user.service.dart';

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
  final userService = UserService(api);

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
      await loginMenu(authService, compteService, userService, tokenManager);
    } else if (choix == "3") {
      print("${blue}👋 Au revoir !${reset}");
      break;
    } else {
      print("${red}⚠️ Choix invalide, réessayez.${reset}");
    }
  }
}

// ================= VALIDATION =================
bool isValidEmail(String email) {
  final emailRegex =
      RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
  return emailRegex.hasMatch(email);
}

bool isValidPhone(String phone) {
  final phoneRegex = RegExp(r'^\+221[0-9]{9}$');
  return phoneRegex.hasMatch(phone);
}

bool isValidNumeroPiece(String numero, String type) {
  if (type == 'cni') {
    // Format attendu: chiffres avec tirets ou lettre + 13 chiffres
    final cniRegex1 = RegExp(r'^\d{1}-\d{3}-\d{3}-\d{3}-\d{3}-\d{2}$');
    final cniRegex2 = RegExp(r'^[A-Z]\d{13}$');
    return cniRegex1.hasMatch(numero) || cniRegex2.hasMatch(numero);
  } else if (type == 'passport') {
    // Format attendu: lettre + 13 chiffres
    final passportRegex = RegExp(r'^[A-Z]\d{13}$');
    return passportRegex.hasMatch(numero);
  } else if (type == 'permis') {
    // Format attendu: lettre + 13 chiffres
    final permisRegex = RegExp(r'^[A-Z]\d{13}$');
    return permisRegex.hasMatch(numero);
  }
  return false;
}

bool isValidPin(String code) {
  final pinRegex = RegExp(r'^\d{4}$');
  return pinRegex.hasMatch(code);
}

// ================= INSCRIPTION =================
// Future<void> inscription(AuthService authService) async {
//   print("\n===== ${blue}📝 INSCRIPTION UTILISATEUR${reset} =====\n");

//   String telephone;
//   do {
//     stdout.write("${blue}Téléphone (+221...) : ${reset}");
//     telephone = stdin.readLineSync()?.trim() ?? "";
//     if (!isValidPhone(telephone)) {
//       print(
//           "${red}❌ Format téléphone invalide. Utilisez +221XXXXXXXXX${reset}");
//     }
//   } while (!isValidPhone(telephone));

//   String email;
//   do {
//     stdout.write("${blue}Email : ${reset}");
//     email = stdin.readLineSync()?.trim() ?? "";
//     if (!isValidEmail(email)) {
//       print("${red}❌ Format email invalide. Exemple: nom@domaine.com${reset}");
//     }
//   } while (!isValidEmail(email));

//   stdout.write("${blue}Nom : ${reset}");
//   final nom = stdin.readLineSync()?.trim() ?? "";

//   stdout.write("${blue}Prénom : ${reset}");
//   final prenom = stdin.readLineSync()?.trim() ?? "";

//   String typePiece;
//   // do {
//     stdout.write("${blue}Type pièce (cni/passport/permis) : ${reset}");
//     typePiece = stdin.readLineSync()?.trim() ?? "";
//     // if (!['cni', 'passport', 'permis'].contains(typePiece)) {
//     //   print(
//     //       "${red}❌ Type pièce invalide. Choisissez: cni, passport, ou permis${reset}");
//     // }
//   // } while (!['cni', 'passport', 'permis'].contains(typePiece));

//   String numeroPiece;
//   do {
//     stdout.write("${blue}Numéro pièce : ${reset}");
//     numeroPiece = stdin.readLineSync()?.trim() ?? "";
//     if (!isValidNumeroPiece(numeroPiece, typePiece)) {
//       if (typePiece == 'cni') {
//         print(
//             "${red}❌ Format CNI invalide. Exemple: 1-234-567-890-123-45 ou A1234567890123${reset}");
//       } else {
//         print("${red}❌ Format invalide. Exemple: A1234567890123${reset}");
//       }
//     }
//   } while (!isValidNumeroPiece(numeroPiece, typePiece));

//   stdout.write("${blue}Adresse : ${reset}");
//   final adresse = stdin.readLineSync()?.trim() ?? "";

//   String code;
//   do {
//     stdout.write("${blue}Code PIN à 4 chiffres : ${reset}");
//     code = stdin.readLineSync()?.trim() ?? "";
//     if (!isValidPin(code)) {
//       print("${red}❌ Code PIN doit être exactement 4 chiffres${reset}");
//     }
//   } while (!isValidPin(code));

//   try {
//     final res = await authService.register({
//       "telephone": telephone,
//       "email": email,
//       "nom": nom,
//       "prenom": prenom,
//       "type_piece": typePiece,
//       "numero_piece": numeroPiece,
//       "adresse": adresse,
//       "code": int.parse(code)
//     });

//     print("\n${green}📩 OTP envoyé à $telephone${reset}");
//     print("${green}Message : ${res.message}${reset}");
//     print("\n ${green} OTP : (${res.codeOtp})");
//     print("${green}Expire dans : ${res.expiresInMinutes} minutes${reset}");

//     stdout.write("\n${blue}👉 Entrez le code OTP reçu : ${reset}");
//     final otp = stdin.readLineSync()?.trim() ?? "";

//     if (otp.isEmpty) {
//       print("${red}⚠️ OTP manquant.${reset}");
//       return;
//     }

//     final confirm = await authService.confirmRegister(
//       telephone: telephone,
//       codeOtp: otp,
//     );

//     print("\n${green}✅ INSCRIPTION RÉUSSIE !${reset}");
//     print("${green}Message : ${confirm['message']}${reset}");
//     print("${green}Utilisateur créé : ${confirm['data']}${reset}");
//   } catch (e) {
//     print("${red}❌ Erreur lors de l'inscription : $e${reset}");
//   }
// }

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
    print(
        "\n${green}💰 Solde du compte $numeroCompte : ${balanceData['solde']} XOF${reset}");
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
  stdout
      .write("\n${blue}Voulez-vous effectuer un transfert ? (o/n) : ${reset}");
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

// ================= MENU UTILISATEUR =================
Future<void> userMenu(
    CompteService compteService, UserService userService) async {
  while (true) {
    print("\n===== ${blue}👤 MENU UTILISATEUR${reset} =====");
    print("1. Opérations sur compte");
    print("2. Récupérer QR Code");
    print("3. Retour au menu principal");

    stdout.write("\n${blue}Votre choix : ${reset}");
    final choix = stdin.readLineSync()?.trim() ?? "";

    if (choix == "1") {
      await compteMenu(compteService);
    } else if (choix == "2") {
      await getQrCode(userService);
    } else if (choix == "3") {
      break;
    } else {
      print("${red}⚠️ Choix invalide, réessayez.${reset}");
    }
  }
}

// ================= QR CODE =================
Future<void> getQrCode(UserService userService) async {
  print("\n===== ${blue}📱 RÉCUPÉRATION QR CODE${reset} =====\n");

  try {
    print("${blue}🔄 Récupération du QR code utilisateur...${reset}");

    final qrCodeSvg = await userService.getUserQrCode();

    print("${green}✅ QR Code récupéré avec succès !${reset}");
    print("${blue}📄 Contenu SVG (aperçu) :${reset}");
    print(qrCodeSvg.substring(0, 200) + "...");

    // Sauvegarder le QR code dans un fichier
    final fileName = "qrcode_user_${DateTime.now().millisecondsSinceEpoch}.svg";
    final file = File(fileName);
    await file.writeAsString(qrCodeSvg);

    print("${green}💾 QR Code sauvegardé dans : ${file.path}${reset}");

    // Afficher des instructions
    print("\n${blue}💡 Pour visualiser le QR code :${reset}");
    print("   - Ouvrez le fichier SVG dans un navigateur web");
    print("   - Ou utilisez un lecteur de QR code");
  } catch (e) {
    print("${red}❌ Erreur lors de la récupération du QR code : $e${reset}");
  }
}
