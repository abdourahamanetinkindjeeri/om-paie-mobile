# om_paie_flutter (om-paie-mobile)

README en français — guide d'installation et d'utilisation pour le projet Flutter + outils CLI inclus.

## Table des matières

- Contexte
- Prérequis
- Installation
- Lancer l'application mobile
- Lancer les outils CLI (debug / backend console)
- Structure du projet
- Tests et qualité
- Bonnes pratiques et prochaines étapes

## Contexte

Ce dépôt contient une application Flutter multi-plateforme ainsi que des utilitaires en ligne de commande (dans `bin/`) pour interagir rapidement avec l'API (inscription, login, gestion de comptes/wallets). Le code CLI utilise le package interne `om_paie_flutter` pour réutiliser les services (API, auth, comptes...).

## Prérequis

- Flutter (compatible avec le SDK Dart indiqué dans `pubspec.yaml`, ici SDK >= 3.5.0)
- Dart (installé via Flutter)
- Une API backend locale ou distante (quelques scripts CLI appellent `http://localhost:3000` ou `http://localhost:8000/api` par défaut dans `bin/`)

Vérifier les versions :

```bash
flutter --version
flutter pub get
```

## Installation

1. Cloner le dépôt

```bash
git clone <repo-url>
cd om_paie_flutter
```

2. Récupérer les dépendances

```bash
flutter pub get
# ou si vous utilisez Dart pur pour les binaires : dart pub get
```

3. Configuration API

Les scripts CLI (dans `bin/`) contiennent des URLs d'API codées en dur (ex : `http://localhost:3000` ou `http://localhost:8000/api`). Pour les exécuter, démarrez l'API locale ou modifiez la valeur directement dans les fichiers CLI si besoin.

Idéalement, vous pouvez paramétrer l'URL via une variable d'environnement ou un argument (amélioration recommandée) ; pour l'instant, adaptez le code dans `bin/main.console.dart` et `bin/main.backend.console.dart`.

## Lancer l'application mobile

Pour lancer sur un émulateur ou un appareil connecté :

```bash
flutter run
```

Pour construire une release Android :

```bash
flutter build apk --release
```

## Lancer les outils CLI

Deux binaires CLI utiles sont fournis :

- `bin/main.console.dart` — PoC / tests de `WalletService`, `UserService` (utilise `ApiServiceImpl('http://localhost:3000')`).
- `bin/main.backend.console.dart` — CLI backend interactif (inscription, login, menu comptes) (utilise `http://localhost:8000/api`).

Exemples d'exécution (nécessite une API en écoute aux bonnes URLs) :

```bash
# Depuis la racine du projet
dart run bin/main.console.dart
# ou
dart run bin/main.backend.console.dart
```

Si vous préférez, exécutez `dart pub get` puis lancez le binaire :

```bash
dart pub get
dart run bin/main.backend.console.dart
```

## Structure du projet

Principaux dossiers :

- `lib/` : code principal (actuellement `main.dart` et packages réutilisables).
- `core/` : logique partagée (data, network, errors).
- `features/` : fonctionnalités par domaine (`auth/`, `comptes/`, `users/`, etc.).
- `bin/` : outils CLI pour tester et interagir avec l'API.
- `android/ ios/ linux/ macos/ web/ windows/` : plateformes Flutter.
- `test/` : tests (actuellement boilerplate).

## Tests et qualité

Le projet inclut `flutter_lints` via `analysis_options.yaml`. Commandes utiles :

```bash
flutter analyze
flutter test
dart format --set-exit-if-changed .
```

Conseils immédiats :

- Ajouter des tests unitaires pour `ApiServiceImpl`, `AuthService`, `CompteService` et `WalletService` en mockant les appels HTTP.
- Mettre en place un workflow CI (ex : GitHub Actions) pour exécuter `flutter analyze` et `flutter test` à chaque PR.

## Bonnes pratiques et prochaines étapes recommandées

1. Améliorer la documentation du README (fait) et ajouter des guides pour contributeurs.
2. Paramétrer l'URL de l'API via une variable d'environnement ou un fichier de configuration au lieu de la coder en dur dans `bin/`.
3. Ajouter tests unitaires et d'intégration pour couvrir le code métier.
4. Mettre en place CI (lint, analyze, tests) et automatiser les mises à jour de dépendances (dependabot ou équivalent).
5. Ajouter `flutter_secure_storage` (ou équivalent) pour le stockage sécurisé des tokens côté mobile et revoir `TokenManager` pour s'assurer du stockage sécurisé côté CLI si nécessaire.
6. Nettoyer le dépôt : ajouter/mettre à jour `.gitignore` pour exclure `build/`, `.dart_tool/`, `ios/Pods/` si nécessaire et envisager de réécrire l'historique si `build/` a été committé par erreur.

## Contribution

Les contributions sont bienvenues. Ouvrez une issue pour discuter d'une fonctionnalité, puis une PR pour proposer des changements. Merci d'ajouter des tests et de garder la CI verte.

---

Si tu veux, je peux :

- créer un workflow GitHub Actions minimal (analyse + tests) ;
- ajouter un exemple de test unitaire pour `WalletService` ;
- refactorer les binaires pour utiliser une variable d'environnement pour l'URL de l'API.

Dis laquelle de ces actions tu veux que je fasse en suite.
