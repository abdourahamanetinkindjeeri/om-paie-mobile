// import 'package:flutter/material.dart';

// void main() {
//   runApp(const OrangeMoneyApp());
// }

// class OrangeMoneyApp extends StatelessWidget {
//   const OrangeMoneyApp({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Orange Money',
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData(
//         primaryColor: const Color(0xFFFF6B00),
//         scaffoldBackgroundColor: Colors.black,
//       ),
//       home: const LoginScreen(),
//     );
//   }
// }

// class LoginScreen extends StatefulWidget {
//   const LoginScreen({Key? key}) : super(key: key);

//   @override
//   State<LoginScreen> createState() => _LoginScreenState();
// }

// class _LoginScreenState extends State<LoginScreen> {
//   final TextEditingController _phoneController = TextEditingController();
//   final PageController _pageController = PageController();
//   int _currentPage = 0;

//   @override
//   void dispose() {
//     _phoneController.dispose();
//     _pageController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFF1A1A1A),
//       body: Column(
//         children: [
//           // PARTIE 1: Carousel
//           _buildCarouselSection(),

//           // PARTIE 2: Inputs et indicateurs
//           _buildFormSection(),
//         ],
//       ),
//     );
//   }

//   // PARTIE 1: Section Carousel
//   Widget _buildCarouselSection() {
//     return Expanded(
//       flex: 6,
//       child: PageView(
//         controller: _pageController,
//         onPageChanged: (index) {
//           setState(() {
//             _currentPage = index;
//           });
//         },
//         children: [
//           _buildCarouselPage(
//             title: 'Transférer',
//             description:
//                 'Envoyez rapidement et en toute\nsécurité de l\'argent à un proche qui\npossède un compte Orange Money.',
//           ),
//           _buildCarouselPage(
//             title: 'Recevoir',
//             description:
//                 'Recevez de l\'argent en toute sécurité\nsur votre compte Orange Money\npartout et à tout moment.',
//           ),
//           _buildCarouselPage(
//             title: 'Payer',
//             description:
//                 'Effectuez vos paiements rapidement\net en toute sécurité avec\nOrange Money.',
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildCarouselPage({
//     required String title,
//     required String description,
//   }) {
//     return Container(
//       margin: const EdgeInsets.fromLTRB(0, 50, 0, 0),
//       child: Stack(
//         children: [
//           // Image avec bordures arrondies
//           Positioned.fill(
//             child: ClipRRect(
//               borderRadius: const BorderRadius.only(
//                 topLeft: Radius.circular(40),
//                 topRight: Radius.circular(40),
//               ),
//               child: Stack(
//                 fit: StackFit.expand,
//                 children: [
//                   Image.network(
//                     'https://images.unsplash.com/photo-1594744803329-e58b31de8bf5?w=800',
//                     fit: BoxFit.cover,
//                     errorBuilder: (context, error, stackTrace) {
//                       return Container(
//                         color: Colors.grey[800],
//                         child: const Icon(
//                           Icons.person,
//                           size: 100,
//                           color: Colors.grey,
//                         ),
//                       );
//                     },
//                   ),
//                   // Gradient overlay
//                   Container(
//                     decoration: BoxDecoration(
//                       gradient: LinearGradient(
//                         begin: Alignment.topCenter,
//                         end: Alignment.bottomCenter,
//                         colors: [
//                           Colors.black.withOpacity(0.6),
//                           Colors.black.withOpacity(0.85),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           // Contenu
//           Positioned(
//             top: 30,
//             left: 20,
//             right: 20,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 // Logo et titre Orange Money
//                 Row(
//                   children: [
//                     Container(
//                       width: 45,
//                       height: 45,
//                       decoration: BoxDecoration(
//                         color: Colors.white,
//                         borderRadius: BorderRadius.circular(10),
//                         border: Border.all(
//                           color: const Color(0xFFFF6B00),
//                           width: 2.5,
//                         ),
//                       ),
//                       child: const Center(
//                         child: Icon(
//                           Icons.arrow_forward_rounded,
//                           color: Color(0xFFFF6B00),
//                           size: 24,
//                         ),
//                       ),
//                     ),
//                     const SizedBox(width: 10),
//                     Container(
//                       width: 45,
//                       height: 45,
//                       decoration: BoxDecoration(
//                         color: const Color(0xFFFF6B00),
//                         borderRadius: BorderRadius.circular(10),
//                         border: Border.all(
//                           color: const Color(0xFFFFAB00),
//                           width: 2.5,
//                         ),
//                       ),
//                       child: const Center(
//                         child: Icon(
//                           Icons.check_rounded,
//                           color: Colors.white,
//                           size: 24,
//                         ),
//                       ),
//                     ),
//                     const SizedBox(width: 14),
//                     RichText(
//                       text: const TextSpan(
//                         children: [
//                           TextSpan(
//                             text: 'Orange ',
//                             style: TextStyle(
//                               color: Color(0xFFFF6B00),
//                               fontSize: 26,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                           TextSpan(
//                             text: 'Money',
//                             style: TextStyle(
//                               color: Colors.white,
//                               fontSize: 26,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 35),
//                 // Titre de la page
//                 RichText(
//                   text: TextSpan(
//                     children: [
//                       TextSpan(
//                         text: '$title ',
//                         style: const TextStyle(
//                           color: Color(0xFFFF6B00),
//                           fontSize: 30,
//                           fontWeight: FontWeight.bold,
//                           height: 1.2,
//                         ),
//                       ),
//                       const TextSpan(
//                         text: 'de l\'argent',
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontSize: 30,
//                           fontWeight: FontWeight.w300,
//                           height: 1.2,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 const SizedBox(height: 14),
//                 // Description
//                 Text(
//                   description,
//                   style: const TextStyle(
//                     color: Colors.white,
//                     fontSize: 15,
//                     height: 1.5,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   // PARTIE 2: Section Formulaire avec indicateurs
//   Widget _buildFormSection() {
//     return Expanded(
//       flex: 5,
//       child: Container(
//         color: const Color(0xFF1A1A1A),
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
//           child: Column(
//             children: [
//               // Indicateurs de page
//               _buildPageIndicators(),
//               const SizedBox(height: 35),

//               // Titre de bienvenue
//               const Text(
//                 'Bienvenue sur OM Pay!',
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontSize: 22,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               const SizedBox(height: 8),
//               const Text(
//                 'Entrez votre numéro mobile pour vous\nconnecter',
//                 textAlign: TextAlign.center,
//                 style: TextStyle(
//                   color: Color(0xFF9E9E9E),
//                   fontSize: 14,
//                   height: 1.4,
//                 ),
//               ),
//               const SizedBox(height: 28),

//               // Champs de saisie
//               _buildPhoneInputRow(),
//               const SizedBox(height: 24),

//               // Bouton de connexion
//               _buildLoginButton(),
//               const SizedBox(height: 18),

//               // Copyright
//               const Text(
//                 '© Copyright - Orange Money Group, tous droits réservés',
//                 textAlign: TextAlign.center,
//                 style: TextStyle(
//                   color: Color(0xFF6E6E6E),
//                   fontSize: 11,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildPageIndicators() {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: List.generate(3, (index) {
//         return GestureDetector(
//           onTap: () {
//             _pageController.animateToPage(
//               index,
//               duration: const Duration(milliseconds: 300),
//               curve: Curves.easeInOut,
//             );
//           },
//           child: AnimatedContainer(
//             duration: const Duration(milliseconds: 300),
//             margin: const EdgeInsets.symmetric(horizontal: 4),
//             width: _currentPage == index ? 32 : 12,
//             height: 12,
//             decoration: BoxDecoration(
//               color: _currentPage == index
//                   ? const Color(0xFFFF6B00)
//                   : const Color(0xFF505050),
//               borderRadius: BorderRadius.circular(6),
//             ),
//           ),
//         );
//       }),
//     );
//   }

//   Widget _buildPhoneInputRow() {
//     return Row(
//       children: [
//         // Sélecteur de pays
//         Container(
//           padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 18),
//           decoration: BoxDecoration(
//             color: const Color(0xFF2A2A2A),
//             border: Border.all(color: const Color(0xFF404040)),
//             borderRadius: BorderRadius.circular(10),
//           ),
//           child: Row(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Container(
//                 width: 28,
//                 height: 20,
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(3),
//                 ),
//                 child: const Text(
//                   '🇸🇳',
//                   style: TextStyle(fontSize: 20),
//                 ),
//               ),
//               const SizedBox(width: 8),
//               const Text(
//                 '+ 221',
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontSize: 15,
//                   fontWeight: FontWeight.w500,
//                 ),
//               ),
//               const SizedBox(width: 6),
//               const Icon(
//                 Icons.keyboard_arrow_down,
//                 color: Colors.white,
//                 size: 22,
//               ),
//             ],
//           ),
//         ),
//         const SizedBox(width: 12),
//         // Champ de saisie du numéro
//         Expanded(
//           child: TextField(
//             controller: _phoneController,
//             keyboardType: TextInputType.phone,
//             style: const TextStyle(
//               color: Colors.white,
//               fontSize: 15,
//             ),
//             decoration: InputDecoration(
//               hintText: 'Saisir mon numéro',
//               hintStyle: const TextStyle(
//                 color: Color(0xFF6E6E6E),
//                 fontSize: 15,
//               ),
//               filled: true,
//               fillColor: const Color(0xFF2A2A2A),
//               border: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(10),
//                 borderSide: const BorderSide(color: Color(0xFF404040)),
//               ),
//               enabledBorder: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(10),
//                 borderSide: const BorderSide(color: Color(0xFF404040)),
//               ),
//               focusedBorder: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(10),
//                 borderSide: const BorderSide(
//                   color: Color(0xFFFF6B00),
//                   width: 2,
//                 ),
//               ),
//               contentPadding: const EdgeInsets.symmetric(
//                 horizontal: 16,
//                 vertical: 18,
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildLoginButton() {
//     return SizedBox(
//       width: double.infinity,
//       child: ElevatedButton(
//         onPressed: () {
//           // Action de connexion
//           if (_phoneController.text.isNotEmpty) {
//             ScaffoldMessenger.of(context).showSnackBar(
//               const SnackBar(
//                 content: Text('Connexion en cours...'),
//                 backgroundColor: Color(0xFFFF6B00),
//               ),
//             );
//           }
//         },
//         style: ElevatedButton.styleFrom(
//           backgroundColor: const Color(0xFFFF6B00),
//           padding: const EdgeInsets.symmetric(vertical: 18),
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(12),
//           ),
//           elevation: 0,
//         ),
//         child: const Text(
//           'Se connecter',
//           style: TextStyle(
//             color: Colors.white,
//             fontSize: 17,
//             fontWeight: FontWeight.w600,
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';

void main() {
  runApp(const OrangeMoneyApp());
}

// Custom Clip Path pour la forme ondulée
class CustomClipPath extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    double width = size.width;
    double height = size.height;
    final path = Path();

    // Départ en bas à gauche
    path.moveTo(0, height);

    // Première courbe qui monte
    path.quadraticBezierTo(width / 4, height - 100, width / 2, height - 50);

    // Deuxième courbe qui redescend un peu
    path.quadraticBezierTo(3 * width / 4, height, width, height - 80);

    // Fermer vers le coin haut droit
    path.lineTo(width, 0);

    // Puis revenir en haut gauche
    path.lineTo(0, 0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class OrangeMoneyApp extends StatelessWidget {
  const OrangeMoneyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Orange Money',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFFFF6B00),
        scaffoldBackgroundColor: Colors.black,
      ),
      home: const LoginScreen(),
    );
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _phoneController = TextEditingController();
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _phoneController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      body: Column(
        children: [
          // PARTIE 1: Carousel
          _buildCarouselSection(),

          // PARTIE 2: Inputs et indicateurs
          _buildFormSection(),
        ],
      ),
    );
  }

  // PARTIE 1: Section Carousel
  Widget _buildCarouselSection() {
    return Expanded(
      flex: 6,
      child: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _currentPage = index;
          });
        },
        children: [
          _buildCarouselPage(
            title: 'Transférer',
            description:
                'Envoyez rapidement et en toute\nsécurité de l\'argent à un proche qui\npossède un compte Orange Money.',
          ),
          _buildCarouselPage(
            title: 'Recevoir',
            description:
                'Recevez de l\'argent en toute sécurité\nsur votre compte Orange Money\npartout et à tout moment.',
          ),
          _buildCarouselPage(
            title: 'Payer',
            description:
                'Effectuez vos paiements rapidement\net en toute sécurité avec\nOrange Money.',
          ),
        ],
      ),
    );
  }

  Widget _buildCarouselPage({
    required String title,
    required String description,
  }) {
    return Container(
      margin: const EdgeInsets.fromLTRB(0, 50, 0, 0),
      child: Stack(
        children: [
          // Image avec CustomClipPath pour la forme ondulée
          Positioned.fill(
            child: ClipPath(
              clipper: CustomClipPath(),
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.network(
                      'https://images.unsplash.com/photo-1594744803329-e58b31de8bf5?w=800',
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.grey[800],
                          child: const Icon(
                            Icons.person,
                            size: 100,
                            color: Colors.grey,
                          ),
                        );
                      },
                    ),
                    // Gradient overlay
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.black.withOpacity(0.6),
                            Colors.black.withOpacity(0.85),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Contenu
          Positioned(
            top: 30,
            left: 20,
            right: 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Logo et titre Orange Money
                Row(
                  children: [
                    Container(
                      width: 45,
                      height: 45,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: const Color(0xFFFF6B00),
                          width: 2.5,
                        ),
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.arrow_forward_rounded,
                          color: Color(0xFFFF6B00),
                          size: 24,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Container(
                      width: 45,
                      height: 45,
                      decoration: BoxDecoration(
                        color: const Color(0xFFFF6B00),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: const Color(0xFFFFAB00),
                          width: 2.5,
                        ),
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.check_rounded,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    RichText(
                      text: const TextSpan(
                        children: [
                          TextSpan(
                            text: 'Orange ',
                            style: TextStyle(
                              color: Color(0xFFFF6B00),
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextSpan(
                            text: 'Money',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 35),
                // Titre de la page
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: '$title ',
                        style: const TextStyle(
                          color: Color(0xFFFF6B00),
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          height: 1.2,
                        ),
                      ),
                      const TextSpan(
                        text: 'de l\'argent',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                          fontWeight: FontWeight.w300,
                          height: 1.2,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
                // Description
                Text(
                  description,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // PARTIE 2: Section Formulaire avec indicateurs
  Widget _buildFormSection() {
    return Expanded(
      flex: 5,
      child: Container(
        color: const Color(0xFF1A1A1A),
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            children: [
              // Indicateurs de page
              _buildPageIndicators(),
              const SizedBox(height: 35),

              // Titre de bienvenue
              const Text(
                'Bienvenue sur OM Pay!',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Entrez votre numéro mobile pour vous\nconnecter',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFF9E9E9E),
                  fontSize: 14,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 28),

              // Champs de saisie
              _buildPhoneInputRow(),
              const SizedBox(height: 24),

              // Bouton de connexion
              _buildLoginButton(),
              const SizedBox(height: 18),

              // Copyright
              const Text(
                '© Copyright - Orange Money Group, tous droits réservés',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFF6E6E6E),
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPageIndicators() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, (index) {
        return GestureDetector(
          onTap: () {
            _pageController.animateToPage(
              index,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            );
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            margin: const EdgeInsets.symmetric(horizontal: 4),
            width: _currentPage == index ? 32 : 12,
            height: 12,
            decoration: BoxDecoration(
              color: _currentPage == index
                  ? const Color(0xFFFF6B00)
                  : const Color(0xFF505050),
              borderRadius: BorderRadius.circular(6),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildPhoneInputRow() {
    return Row(
      children: [
        // Sélecteur de pays
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 18),
          decoration: BoxDecoration(
            color: const Color(0xFF2A2A2A),
            border: Border.all(color: const Color(0xFF404040)),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 28,
                height: 20,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(3),
                ),
                child: const Text(
                  '🇸🇳',
                  style: TextStyle(fontSize: 20),
                ),
              ),
              const SizedBox(width: 8),
              const Text(
                '+ 221',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(width: 6),
              const Icon(
                Icons.keyboard_arrow_down,
                color: Colors.white,
                size: 22,
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        // Champ de saisie du numéro
        Expanded(
          child: TextField(
            controller: _phoneController,
            keyboardType: TextInputType.phone,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 15,
            ),
            decoration: InputDecoration(
              hintText: 'Saisir mon numéro',
              hintStyle: const TextStyle(
                color: Color(0xFF6E6E6E),
                fontSize: 15,
              ),
              filled: true,
              fillColor: const Color(0xFF2A2A2A),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Color(0xFF404040)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Color(0xFF404040)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(
                  color: Color(0xFFFF6B00),
                  width: 2,
                ),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 18,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLoginButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          // Action de connexion
          if (_phoneController.text.isNotEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Connexion en cours...'),
                backgroundColor: Color(0xFFFF6B00),
              ),
            );
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFFF6B00),
          padding: const EdgeInsets.symmetric(vertical: 18),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
        child: const Text(
          'Se connecter',
          style: TextStyle(
            color: Colors.white,
            fontSize: 17,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
