import 'package:om_paie_flutter/core/data/services/api.service.impl.dart';

class CompteService{
  final ApiServiceImpl api;

  CompteService(this.api);


  Future<Map<String, dynamic>> getBalance(String numeroCompte) async {
    return await api.getObject("comptes/$numeroCompte/balance");
  }


  Future<Map<String, dynamic>> getHistory(
      String numeroCompte, {
        int page = 1,
        int limit = 10,
      }) async {
    return await api.getObject("comptes/$numeroCompte/history?page=$page&limit=$limit");
  }

  Future<Map<String, dynamic>> transfer({
    required String numeroCompte,
    required String telephoneDestinataire,
    required int montant,
  }) async {
    return await api.post(
      "comptes/$numeroCompte/transfer",
      {
        "telephone": telephoneDestinataire,
        "montant": montant
      },
    );
  }

  Future<Map<String, dynamic>> payement({
    required String numeroCompte,
    required String codeMerchant,
    required int montant,
  }) async {
    return await api.post(
      "comptes/$numeroCompte/payment",
      {
        "code_marchand": codeMerchant,
        "montant": montant
      },
    );
  }

}