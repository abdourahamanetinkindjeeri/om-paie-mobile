import 'dart:io';
import 'package:om_paie_flutter/core/data/services/api.service.impl.dart';
import 'package:om_paie_flutter/features/auth/auth.service.dart';
import 'package:om_paie_flutter/features/auth/token.manager.dart';
import 'package:om_paie_flutter/features/comptes/compte.service.dart';
import 'package:om_paie_flutter/features/users/user.service.dart';
import 'package:om_paie_flutter/ui/console/console_styles.dart';
import 'package:om_paie_flutter/ui/console/inscription_console.dart';
import 'package:om_paie_flutter/ui/console/login_console.dart';

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
    print("\n===== ${blue}🏦 MENU PRINCIPAL$reset =====");
    print("1. Inscription");
    print("2. Login");
    print("3. Quitter");

    stdout.write("\n${blue}Votre choix : $reset");
    final choix = stdin.readLineSync()?.trim() ?? "";

    if (choix == "1") {
      await inscription(authService);
    } else if (choix == "2") {
      await loginMenu(authService, compteService, userService, tokenManager);
    } else if (choix == "3") {
      print("$blue 👋 Au revoir !$reset");
      break;
    } else {
      print("${red}⚠️ Choix invalide, réessayez.$reset");
    }
  }
}
