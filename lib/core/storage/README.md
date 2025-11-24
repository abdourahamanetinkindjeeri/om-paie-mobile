# Stockage Sécurisé - Secure Storage

Ce module fournit un système de stockage sécurisé pour les données sensibles de l'application, notamment les tokens d'authentification.

## Caractéristiques

- **Chiffrement natif** : Utilise `flutter_secure_storage` pour chiffrer les données
- **Stockage sécurisé** :
  - Android : Utilise `EncryptedSharedPreferences`
  - iOS : Utilise le `Keychain`
  - Windows/Linux : Utilise le stockage sécurisé du système
- **Singleton** : Une seule instance partagée dans toute l'application

## Utilisation

### SecureStorage

Service principal pour stocker et récupérer des données sensibles.

```dart
// Obtenir l'instance
final secureStorage = SecureStorage.getInstance();

// Écrire une valeur
await secureStorage.write(
  key: 'ma_cle',
  value: 'ma_valeur_secrete',
);

// Lire une valeur
final value = await secureStorage.read(key: 'ma_cle');

// Vérifier si une clé existe
final exists = await secureStorage.containsKey(key: 'ma_cle');

// Supprimer une valeur
await secureStorage.delete(key: 'ma_cle');

// Supprimer toutes les valeurs
await secureStorage.deleteAll();

// Lire toutes les valeurs
final allValues = await secureStorage.readAll();
```

### TokenManagerMobile

Gère automatiquement le stockage sécurisé des tokens d'authentification.

```dart
// Créer une instance
final tokenManager = TokenManagerMobile();

// Sauvegarder les tokens
await tokenManager.setTokens(
  accessToken: 'mon_access_token',
  refreshToken: 'mon_refresh_token',
  accessTokenExpiry: DateTime.now().add(Duration(hours: 1)),
);

// Charger les tokens au démarrage
await tokenManager.loadTokens();

// Accéder aux tokens
final accessToken = tokenManager.accessToken;
final refreshToken = tokenManager.refreshToken;

// Vérifier si le token est expiré
if (tokenManager.isAccessTokenExpired) {
  // Rafraîchir le token
}

// Vérifier si des tokens sont stockés
final hasTokens = await tokenManager.hasStoredTokens();

// Effacer les tokens (déconnexion)
await tokenManager.clearTokens();
```

## Clés de stockage

Les clés prédéfinies sont disponibles dans `SecureStorageKeys` :

```dart
class SecureStorageKeys {
  // Tokens
  static const String accessToken = 'secure_access_token';
  static const String refreshToken = 'secure_refresh_token';
  static const String accessTokenExpiry = 'secure_access_token_expiry';

  // Credentials
  static const String userPin = 'secure_user_pin';
  static const String biometricKey = 'secure_biometric_key';
}
```

## Configuration Android

Pour Android, les options suivantes sont configurées :

```dart
AndroidOptions(
  encryptedSharedPreferences: true,
)
```

## Configuration iOS

Pour iOS, les options suivantes sont configurées :

```dart
IOSOptions(
  accessibility: KeychainAccessibility.first_unlock,
)
```

Cela signifie que les données sont accessibles après le premier déverrouillage de l'appareil.

## Avantages

1. **Sécurité** : Les données sont chiffrées au repos
2. **Multi-plateforme** : Fonctionne sur Android, iOS, Windows, Linux, macOS et Web
3. **Facile à utiliser** : API simple et intuitive
4. **Persistant** : Les données survivent aux redémarrages de l'application
5. **Async** : Toutes les opérations sont asynchrones et non-bloquantes

## Notes importantes

- Sur Android, `encryptedSharedPreferences` nécessite Android API 18+
- Sur iOS, le Keychain est synchronisé via iCloud si activé
- Sur Web, les données sont stockées dans le stockage local du navigateur (moins sécurisé)
- Toujours gérer les erreurs lors des opérations de lecture/écriture

## Migration depuis SharedPreferences

Si vous migrez depuis `shared_preferences`, vous pouvez faire :

```dart
// Lire depuis shared_preferences
final prefs = await SharedPreferences.getInstance();
final oldToken = prefs.getString('access_token');

if (oldToken != null) {
  // Sauvegarder dans secure storage
  final secureStorage = SecureStorage.getInstance();
  await secureStorage.write(
    key: SecureStorageKeys.accessToken,
    value: oldToken,
  );

  // Supprimer de shared_preferences
  await prefs.remove('access_token');
}
```
