import 'dart:io';

import 'package:om_paie_flutter/core/data/services/api.service.impl.dart';
import 'package:om_paie_flutter/features/comptes/compte.entity.dart';
import 'package:om_paie_flutter/features/comptes/compte.service.dart';
import 'package:om_paie_flutter/features/comptes/wallet.service.dart';
import 'package:om_paie_flutter/features/users/user.entity.dart';
import 'package:om_paie_flutter/features/users/user.service.dart';
import 'package:intl/intl.dart';

void main() async{
  print("Console OK !");

  final api = ApiServiceImpl('http://localhost:3000');
  // final userService = UserService(api);
  //
  // final users = await userService.getUsers();
  // for (var u in users) {
  //   print('${u.nom} - ${u.email}');
  // }
  //
  // final user = await userService.getByIdUser("a05ab647-b1f1-4d92-8ca5-9f05b82a766f");
  // print("👤 ${user.nom} ${user.prenom} - ${user.email}");
  //
  //
  // final json = {
  //   '_id': 'a05abf1a-d6bb-434a-8a89-8abd1ed3dd86',
  //   'user_id': 'a05abf1a-4f9e-4de2-90a3-15543b63574a',
  //   'balance': 62000,
  //   'currency': 'XOF',
  //   'updated_at': '2025-11-17T00:42:44.745Z',
  //   'created_at': '2025-11-14T10:28:57.079Z',
  //   'is_main': true,
  // };


  final walletService = WalletService(api);


  try {
    // Récupérer tous les wallets
    // final wallets = await walletService.getWallets();
    // for (var wallet in wallets) {
    //   print("Wallet ${wallet.id} → Balance: ${wallet.balance} ");
    // }

    // Récupérer un wallet par ID
    final wallet = await walletService.getWalletById("a05abf1a-d6bb-434a-8a89-8abd1ed3dd86");


    final formattedDate = DateFormat('dd/MM/yyyy HH:mm:ss').format(wallet.updatedAt);
    print("Wallet unique: ${wallet.id} → Balance: ${wallet.balance} → $formattedDate");

    // Créer un wallet
  //   final newWallet = await walletService.createWallet({
  //     "balance": 100000,
  //     "currency": "XOF",
  //     "userid": "a05ab647-b1f1-4d92-8ca5-9f05b82a766f",
  //     "is_main": false,
  //   });
  //   print("Wallet créé: ${newWallet.id}");
  //
  //   // Mettre à jour un wallet
  //   final updatedWallet = await walletService.updateWallet(newWallet.id, {"balance": 120000});
  //   print("Wallet mis à jour: ${updatedWallet.balance}");
  //
  //   // Supprimer un wallet
  //   await walletService.deleteWallet(newWallet.id);
  //   print("Wallet supprimé !");
  } catch (e) {
    print("Erreur WalletService: $e");
  }
}
