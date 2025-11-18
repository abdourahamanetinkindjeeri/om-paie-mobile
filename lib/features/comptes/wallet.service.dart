// import 'package:om_paie_flutter/core/data/services/api.service.impl.dart';
// import 'wallet.entity.dart';

// class WalletService {
//   final ApiServiceImpl api;

//   WalletService(this.api);

//   /// Récupérer tous les wallets (endpoint renvoie une liste JSON)
//   Future<List<Wallet>> getWallets() async {
//     final response = await api.get("wallets"); // utilise get() qui retourne List<dynamic>
//     print(response);
//     return response
//         .map((json) => Wallet.fromJson(json as Map<String, dynamic>))
//         .toList();
//   }

//   /// Récupérer un wallet par son ID (endpoint renvoie un objet JSON)
//   Future<Wallet> getWalletById(String id) async {
//     final response = await api.getObject("wallets/$id"); // utilise getObject()
//     return Wallet.fromJson(response);
//   }

//   /// Créer un wallet
//   Future<Wallet> createWallet(Map<String, dynamic> data) async {
//     final response = await api.post("wallets", data);
//     return Wallet.fromJson(response);
//   }

//   /// Mettre à jour un wallet
//   Future<Wallet> updateWallet(String id, Map<String, dynamic> data) async {
//     final response = await api.put("wallets/$id", data);
//     return Wallet.fromJson(response);
//   }

//   /// Supprimer un wallet
//   Future<void> deleteWallet(String id) async {
//     await api.delete("wallets/$id");
//   }
// }
