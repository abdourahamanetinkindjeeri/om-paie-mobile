# om_paie_flutter

Ce projet est une application Flutter multi-plateforme pour la gestion de paie Orange Money.

## Prérequis

- Flutter SDK : <https://docs.flutter.dev/get-started/install>
- Dart (installé avec Flutter)

## Installation

1. Cloner le dépôt :

   ```bash
   git clone <repo-url>
   cd om_paie_flutter
   ```

2. Installer les dépendances :

   ```bash
   flutter pub get
   ```

## Lancement

Pour lancer l’application sur un émulateur ou un appareil :

```bash
flutter run
```

## Comment ça marche Flutter ?

Flutter utilise le langage Dart et fonctionne par widgets. Dans ce projet :

- **Point d’entrée** : `lib/main.dart` initialise l’application et configure les routes.
- **Pages** : Les écrans principaux sont dans `lib/pages/` (ex : login, dashboard, scanner, signup).
- **UI** : Les composants graphiques réutilisables sont dans `lib/ui/` (ex : widgets, thèmes, styles).
- **Modèles** : Les structures de données sont dans `lib/model/`.
- **Providers** : La gestion d’état (ex : utilisateur, authentification) est dans `lib/providers/`.
- **Routes** : La navigation entre les pages est gérée dans `lib/routes/`.
- **Core** : Les services partagés (API, stockage, utilitaires) sont dans `lib/core/`.

### Commandes utiles

- Lancer l’application :

  ```bash
  flutter run
  ```

- Construire une version Android :

  ```bash
  flutter build apk --release
  ```

- Exécuter les tests :

  ```bash
  flutter test
  ```

## Structure du projet

- `lib/` : Code source principal (pages, modèles, providers, UI, core, routes)
- `bin/` : Outils CLI (console)
- `android/`, `ios/`, `web/`, `linux/`, `macos/`, `windows/` : Plateformes cibles
- `assets/` : Ressources (images, polices)
- `test/` : Tests unitaires

## API & Configuration

L’application et les outils CLI interagissent avec une API backend. L’URL de l’API peut être modifiée dans les scripts du dossier `bin/`.

## Outils CLI

Les scripts dans `bin/` permettent d’interagir avec l’API (inscription, login, gestion de comptes). Pour les utiliser :

```bash
 dart run bin/main.console.dart
```

## Tests

Pour exécuter les tests :

```bash
 flutter test
```

## Contribution

Les contributions sont les bienvenues !

Pour toute question ou suggestion, ouvrez une issue sur le dépôt.
