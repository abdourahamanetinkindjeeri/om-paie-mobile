// import 'package:flutter/material.dart';

// class CustomClipPath extends CustomClipper<Path> {
//   @override
//   Path getClip(Size size) {
//     double width = size.width;
//     double height = size.height;

//     final path = Path();

//     path.lineTo(0, height - 50);
//     path.quadraticBezierTo(width / 4, height, width / 2, height - 50);
//     path.quadraticBezierTo(3 * width / 4, height - 100, width, height - 50);
//     path.lineTo(width, 0);
//     path.close();

//     return path;
//   }

//   @override
//   bool shouldReclip(CustomClipper<Path> oldClipper) {
//     return false;
//   }
// }

import 'package:flutter/material.dart';

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
