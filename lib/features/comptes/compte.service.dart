import 'package:om_paie_flutter/core/data/services/api.service.impl.dart';

class CompteService{
  final ApiServiceImpl api;

  CompteService(this.api);


  Future<double> getAccountBalance(String numeroCompte) async {
    final response = await api.getByPath("wallets/", '$numeroCompte/balance');

    // Supposons que l’API renvoie { "balance": 62000 }
    final balance = (response['balance'] as num).toDouble();

    return balance;
  }

}