# Implémentation du Dashboard Orange Money

## 📋 Vue d'ensemble

Ce document décrit l'implémentation du dashboard Orange Money qui s'affiche après une connexion réussie.

## 🎯 Fonctionnalités implémentées

### 1. **Écran Dashboard** (`dashboard_screen.dart`)
- Affichage du profil utilisateur
- Chargement automatique des informations depuis l'API
- Menu latéral avec options (Profil, Paramètres, Aide, Déconnexion)
- Gestion de l'état de chargement
- Navigation vers la page de connexion lors de la déconnexion

### 2. **En-tête Dashboard** (`dashboard_header.dart`)
- Affichage du nom d'utilisateur personnalisé
- Affichage du rôle utilisateur (si disponible)
- QR code généré dynamiquement
- Menu hamburger pour accéder aux options
- Design conforme à la charte Orange Money

### 3. **Section de Paiement** (`payment_section.dart`)
- Toggle entre "Payer" et "Transférer"
- Champs de saisie pour :
  - Numéro/code marchand
  - Montant
- Bouton "Valider" avec validation des champs
- Bouton d'accès à "Max it"
- Design responsive et interactif

### 4. **Historique des Transactions** (`transaction_history.dart`)
- Liste des transactions récentes
- Affichage des détails :
  - Type de transaction (avec icône)
  - Destinataire
  - Montant (en vert si positif, blanc si négatif)
  - Date et heure
- Bouton de rafraîchissement
- Design cards avec séparation visuelle

## 🔄 Flux de Navigation

```
LoginScreen 
    ↓ (saisie numéro)
PinCodeScreen 
    ↓ (saisie PIN)
    ├─→ Confirmation OTP automatique → DashboardScreen
    └─→ OtpScreen (saisie manuelle) → DashboardScreen
```

## 🎨 Design

Le dashboard respecte la charte graphique Orange Money :
- **Couleur primaire** : Orange (#FF6B00)
- **Fond** : Noir (#1A1A1A)
- **Surface** : Gris foncé (#2A2A2A)
- **Texte primaire** : Blanc
- **Texte secondaire** : Gris (#9E9E9E)

## 📁 Fichiers modifiés/créés

### Nouveaux fichiers :
1. `/lib/ui/screen/dashboard_screen.dart` - Écran principal du dashboard
2. `/lib/ui/widgets/dashboard_header.dart` - En-tête avec profil et QR code
3. `/lib/ui/widgets/payment_section.dart` - Section paiement/transfert
4. `/lib/ui/widgets/transaction_history.dart` - Historique des transactions

### Fichiers modifiés :
1. `/lib/main.dart` - Ajout de la route `/dashboard`
2. `/lib/ui/widgets/pin_form_section.dart` - Navigation vers dashboard après connexion
3. `/lib/ui/widgets/otp_form_section.dart` - Navigation vers dashboard après OTP

## 🔧 Utilisation

### Accès au dashboard
Après une connexion réussie (PIN + OTP), l'utilisateur est automatiquement redirigé vers le dashboard.

### Déconnexion
1. Ouvrir le menu (icône hamburger en haut à gauche)
2. Sélectionner "Déconnexion"
3. Les tokens sont supprimés et l'utilisateur est redirigé vers l'écran de connexion

## 🚀 Prochaines étapes possibles

1. **Intégration API réelle** :
   - Récupérer les vraies transactions depuis le backend
   - Implémenter les paiements et transferts

2. **Fonctionnalités additionnelles** :
   - Page de profil détaillée
   - Paramètres utilisateur
   - Page d'aide et support
   - Notifications push

3. **Améliorations UX** :
   - Pull-to-refresh sur l'historique
   - Pagination des transactions
   - Filtres et recherche dans l'historique
   - Animation de transitions

4. **Sécurité** :
   - Gestion du refresh token automatique
   - Session timeout
   - Biométrie pour confirmation de transactions

## 📝 Notes techniques

- **État** : Utilisation de `StatefulWidget` pour la gestion de l'état local
- **Navigation** : `pushReplacement` pour éviter le retour arrière vers l'écran de connexion
- **Tokens** : Stockage via `ITokenManager` (implémentation mobile)
- **API** : Appels asynchrones avec gestion d'erreurs
- **Responsive** : Layouts flexibles avec `Expanded` et `SingleChildScrollView`

## ✅ Code Clean

Le code respecte les principes suivants :
- **Séparation des responsabilités** : Widgets réutilisables et modulaires
- **Nommage cohérent** : Convention Dart/Flutter
- **Gestion d'erreurs** : Try-catch avec messages utilisateur
- **Bonnes pratiques** : Dispose des controllers, mounted checks
- **Architecture** : Structure de dossiers logique (screen/widgets)
