import 'dart:io';

import 'package:om_paie_flutter/core/data/services/api.service.impl.dart';
import 'package:om_paie_flutter/features/auth/auth.service.dart';
import 'package:om_paie_flutter/features/auth/token.manager.dart';
import 'package:om_paie_flutter/features/comptes/compte.entity.dart';
import 'package:om_paie_flutter/features/comptes/compte.service.dart';
import 'package:om_paie_flutter/features/comptes/wallet.service.dart';
import 'package:om_paie_flutter/features/users/user.entity.dart';
import 'package:om_paie_flutter/features/users/user.service.dart';
import 'package:intl/intl.dart';
//
void main() async {
  print("Console OK !");

  // Configuration de l'API avec gestion des tokens et refresh automatique
  final tokenManager = TokenManager();
  await tokenManager.loadTokens(); // Charger les tokens existants

  // Créer l'API d'abord sans callback
  final api = ApiServiceImpl(
    'http://localhost:8000/api',
    tokenManager: tokenManager,
  );

  // Maintenant configurer le callback avec l'API déjà créée
  final authService = AuthService(api);
  // Note: Dans une vraie app, on pourrait setter le callback après création

  final userService = UserService(api);

  try {
    print("🔄 Récupération du QR code utilisateur...");

    // Récupérer le QR code SVG
    final qrCodeSvg = await userService.getUserQrCode();

    print("✅ QR Code récupéré avec succès !");
    print("📱 Contenu SVG (aperçu):");
    print(qrCodeSvg.substring(0, 200) + "..."); // Afficher les premiers caractères

    // Sauvegarder le QR code dans un fichier
    final file = File('qrcode_user.svg');
    await file.writeAsString(qrCodeSvg);
    print("💾 QR Code sauvegardé dans: ${file.path}");

  } catch (e) {
    print("❌ Erreur lors de la récupération du QR code: $e");
  }

  // Code existant pour les wallets (optionnel)
  /*
  final walletService = WalletService(api);

  try {
    final wallet = await walletService.getWalletById("a05abf1a-d6bb-434a-8a89-8abd1ed3dd86");
    final formattedDate = DateFormat('dd/MM/yyyy HH:mm:ss').format(wallet.updatedAt);
    print("Wallet unique: ${wallet.id} → Balance: ${wallet.balance} → $formattedDate");
  } catch (e) {
    print("Erreur WalletService: $e");
  }
  */
}
