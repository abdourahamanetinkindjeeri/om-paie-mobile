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

}