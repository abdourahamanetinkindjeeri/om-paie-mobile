#!/usr/bin/env bash
set -e

echo "🔧 Nettoyage du projet..."
flutter clean

echo "📦 Récupération des dépendances..."
flutter pub get

echo "🚀 Compilation APK en mode release..."
flutter build apk --release --split-per-abi

echo "✅ APK généré dans build/app/outputs/flutter-apk/"
