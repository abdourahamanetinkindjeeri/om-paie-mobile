import 'dart:io';
import 'package:om_paie_flutter/features/users/user.service.dart';
import 'package:om_paie_flutter/ui/console/console_styles.dart';

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
