import 'dart:io';

class Config {
  // URL de base de l'API - modifier selon votre environnement
  static String apiBaseUrl = 'http://localhost:8000/api';

  // Pour charger d'autres configurations si nécessaire
  static Future<void> load() async {
    try {
      final envFile = File('.env');
      if (await envFile.exists()) {
        final lines = await envFile.readAsLines();
        for (final line in lines) {
          if (line.startsWith('API_BASE_URL=')) {
            apiBaseUrl = line.substring('API_BASE_URL='.length);
            break;
          }
        }
      }
    } catch (e) {
      // Ignore
    }
  }
}