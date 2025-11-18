import 'dart:io';
import 'package:om_paie_flutter/features/comptes/compte.service.dart';
import 'package:om_paie_flutter/ui/console/console_styles.dart';

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
