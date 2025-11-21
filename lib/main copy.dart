import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

void main() => runApp(const OrangeMoneyApp());

class OrangeMoneyApp extends StatelessWidget {
  const OrangeMoneyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: OrangeMoneyLoginScreen(),
    );
  }
}

class OrangeMoneyLoginScreen extends StatefulWidget {
  const OrangeMoneyLoginScreen({super.key});

  @override
  State<OrangeMoneyLoginScreen> createState() => _OrangeMoneyLoginScreenState();
}

class _OrangeMoneyLoginScreenState extends State<OrangeMoneyLoginScreen> {
  int _currentCarouselIndex = 0;
  final TextEditingController _phoneController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  final List<Map<String, String>> _carouselItems = const [
    {
      'icon': '↗️',
      'title': 'Transférer',
      'description':
          'Envoyez rapidement et en toute sécurité de l\'argent à un proche qui possède un compte Orange Money.',
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
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  void _onLogin() {
    if (_formKey.currentState!.validate()) {
      // Traitement de la connexion ici
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      LayoutBuilder(
                        builder: (context, constraints) {
                          // Hauteur responsives du carousel et des dots
                          double carouselHeight =
                              constraints.maxWidth * 0.62; // Ratio adaptable
                          double indicatorSize = carouselHeight *
                              0.07; // 7% de la hauteur du carousel

                          return Column(
                            children: [
                              CarouselSlider.builder(
                                itemCount: _carouselItems.length,
                                options: CarouselOptions(
                                  height: carouselHeight,
                                  viewportFraction: 1.0,
                                  enableInfiniteScroll: true,
                                  autoPlay: true,
                                  autoPlayInterval: const Duration(seconds: 4),
                                  onPageChanged: (index, reason) {
                                    setState(() {
                                      _currentCarouselIndex = index;
                                    });
                                  },
                                ),
                                itemBuilder: (context, index, realIndex) {
                                  final item = _carouselItems[index];
                                  return Container(
                                    padding: const EdgeInsets.all(24),
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                        colors: [
                                          Colors.orange.withOpacity(0.2),
                                          Colors.transparent,
                                        ],
                                      ),
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Container(
                                              width: 56,
                                              height: 56,
                                              decoration: BoxDecoration(
                                                color: Colors.orange,
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                              child: Center(
                                                child: Text(
                                                  item['icon']!,
                                                  style: const TextStyle(
                                                      fontSize: 28),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 12),
                                            Container(
                                              width: 56,
                                              height: 56,
                                              decoration: BoxDecoration(
                                                color: Colors.orange
                                                    .withOpacity(0.3),
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                                border: Border.all(
                                                  color: Colors.orange,
                                                  width: 2,
                                                ),
                                              ),
                                              child: const Icon(
                                                Icons.arrow_forward,
                                                color: Colors.orange,
                                                size: 28,
                                              ),
                                            ),
                                            const Spacer(),
                                            RichText(
                                              text: const TextSpan(
                                                children: [
                                                  TextSpan(
                                                    text: 'Orange ',
                                                    style: TextStyle(
                                                      color: Colors.orange,
                                                      fontSize: 22,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  TextSpan(
                                                    text: 'Money',
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 22,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 24),
                                        RichText(
                                          text: TextSpan(
                                            children: [
                                              TextSpan(
                                                text: '${item['title']} ',
                                                style: const TextStyle(
                                                  color: Colors.orange,
                                                  fontSize: 24,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              const TextSpan(
                                                text: 'de l\'argent',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 24,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(height: 12),
                                        Text(
                                          item['description']!,
                                          style: const TextStyle(
                                            color: Colors.white70,
                                            fontSize: 14,
                                            height: 1.5,
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                              const SizedBox(height: 16),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: List.generate(
                                  _carouselItems.length,
                                  (index) => Container(
                                    width: indicatorSize,
                                    height: indicatorSize,
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 4),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: _currentCarouselIndex == index
                                          ? Colors.orange
                                          : Colors.grey,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                      const SizedBox(height: 32),
                      // Welcome section with Form
                      const Text(
                        'Bienvenue sur OM Pay!',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Entrez votre numéro mobile pour vous connecter',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Form(
                        key: _formKey,
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 16,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFF2A2A2A),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: Colors.grey.withOpacity(0.3),
                                ),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 24,
                                    height: 24,
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.green,
                                    ),
                                    child: const Center(
                                      child: Text(
                                        '🇸🇳',
                                        style: TextStyle(fontSize: 16),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  const Text(
                                    '+221',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  const Icon(
                                    Icons.arrow_drop_down,
                                    color: Colors.white,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: TextFormField(
                                controller: _phoneController,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                                decoration: InputDecoration(
                                  hintText: 'Saisir mon numéro',
                                  hintStyle: TextStyle(
                                    color: Colors.grey.withOpacity(0.5),
                                    fontSize: 16,
                                  ),
                                  filled: true,
                                  fillColor: const Color(0xFF2A2A2A),
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 16,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide(
                                      color: Colors.grey.withOpacity(0.3),
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide(
                                      color: Colors.grey.withOpacity(0.3),
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: const BorderSide(
                                      color: Colors.orange,
                                    ),
                                  ),
                                ),
                                keyboardType: TextInputType.phone,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Veuillez entrer votre numéro';
                                  }
                                  if (!RegExp(r'^[0-9]{9}$').hasMatch(value)) {
                                    return 'Numéro invalide';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _onLogin,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            elevation: 0,
                          ),
                          child: const Text(
                            'Se connecter',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // Footer
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                '© Copyright - Orange Money Group, tous droits réservés',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey.withOpacity(0.5),
                  fontSize: 11,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
