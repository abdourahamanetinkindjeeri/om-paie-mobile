import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final List<Map<String, String>> _carouselItems = const [
    {
      'icon': '↗️',
      'title': 'Transférer',
      'description':
          'Envoyez rapidement et en toute sécurité de l\'argent à un proche qui possède un compte Orange Money.',
      "image": "assets/images/transfer.png"
    },
    {
      'icon': '📱',
      'title': 'Payer',
      'description':
          'Payez vos factures et vos achats en toute simplicité avec Orange Money.',
    },
    {
      'icon': '💰',
      'title': 'Économiser',
      'description':
          'Gérez votre argent facilement et en toute sécurité avec Orange Money.',
    },
  ];
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
