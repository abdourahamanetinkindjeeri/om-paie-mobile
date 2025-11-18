import 'dart:io';
import 'package:om_paie_flutter/features/comptes/compte.service.dart';
import 'package:om_paie_flutter/features/users/user.service.dart';
import 'package:om_paie_flutter/ui/console/console_styles.dart';
import 'package:om_paie_flutter/ui/console/compte_console.dart';
import 'package:om_paie_flutter/ui/console/qrcode_console.dart';

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
