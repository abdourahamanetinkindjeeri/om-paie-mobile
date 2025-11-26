import 'package:flutter/material.dart';

class AppColors {
  // Couleurs communes
  static const Color primary = Color(0xFFFF6B00);
  static const Color primaryLight = Color(0xFFFFAB00);

  // Thème sombre (actuel)
  static const Color darkBackground = Color(0xFF1A1A1A);
  static const Color darkSurface = Color(0xFF2A2A2A);
  static const Color darkBorder = Color(0xFF404040);
  static const Color darkTextPrimary = Colors.white;
  static const Color darkTextSecondary = Color(0xFF9E9E9E);
  static const Color darkTextMuted = Color(0xFF6E6E6E);
  static const Color darkIndicatorInactive = Color(0xFF505050);

  // Thème clair
  static const Color lightBackground = Colors.white;
  static const Color lightSurface = Color(0xFFF5F5F5);
  static const Color lightBorder = Color(0xFFE0E0E0);
  static const Color lightTextPrimary = Color(0xFF1A1A1A);
  static const Color lightTextSecondary = Color(0xFF6E6E6E);
  static const Color lightTextMuted = Color(0xFF9E9E9E);
  static const Color lightIndicatorInactive = Color(0xFFB0B0B0);

  // Compatibilité arrière (utilise le thème sombre par défaut)
  static const Color background = darkBackground;
  static const Color surface = darkSurface;
  static const Color border = darkBorder;
  static const Color textPrimary = darkTextPrimary;
  static const Color textSecondary = darkTextSecondary;
  static const Color textMuted = darkTextMuted;
  static const Color indicatorInactive = darkIndicatorInactive;
}