class AppStringsFr {
  String get appTitle => 'Orange Money';
  String get welcomeMessage => 'Bienvenue sur OM Pay!';
  String get loginInstruction =>
      'Entrez votre numéro mobile pour vous\nconnecter';
  String get pinInstruction => 'Entrez votre code PIN';
  String get loginButton => 'Se connecter';
  String get validateButton => 'Valider';
  String get copyright =>
      '© Copyright - Orange Money Group, tous droits réservés';
  String get phoneHint => 'Saisir mon numéro';
  String get countryCode => '+ 221';
  String get countryFlag => '🇸🇳';
  String get errorLoadProfile => 'Erreur lors du chargement du profil';
  String get noPrincipalAccount => 'Aucun compte principal trouvé';
  String get paymentSuccess => 'Paiement effectué avec succès';
  String get paymentError => 'Paiement échoué';
  String get paymentErrorGeneric => 'Erreur lors du paiement';
  String get transferSuccess => 'Transfert effectué avec succès';
  String get transferError => 'Transfert échoué';
  String get transferErrorGeneric => 'Erreur lors du transfert';
}

class AppStringsEn {
  String get appTitle => 'Orange Money';
  String get welcomeMessage => 'Welcome to OM Pay!';
  String get loginInstruction => 'Enter your mobile number to\nsign in';
  String get pinInstruction => 'Enter your PIN code';
  String get loginButton => 'Sign in';
  String get validateButton => 'Validate';
  String get copyright =>
      '© Copyright - Orange Money Group, all rights reserved';
  String get phoneHint => 'Enter my number';
  String get countryCode => '+ 221';
  String get countryFlag => '🇸🇳';
  String get errorLoadProfile => 'Error loading profile';
  String get noPrincipalAccount => 'No main account found';
  String get paymentSuccess => 'Payment successful';
  String get paymentError => 'Payment failed';
  String get paymentErrorGeneric => 'Error during payment';
  String get transferSuccess => 'Transfer successful';
  String get transferError => 'Transfer failed';
  String get transferErrorGeneric => 'Error during transfer';
}

class AppStrings {
  static AppStringsFr fr = AppStringsFr();
  static AppStringsEn en = AppStringsEn();

  static dynamic of(String lang) {
    if (lang == 'en') return en;
    return fr;
  }
}
