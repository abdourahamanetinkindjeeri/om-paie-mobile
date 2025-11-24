# Providers - Gestion de l'état de l'application

Ce dossier contient les providers pour gérer l'état global de l'application sans injection de dépendances manuelle.

## Providers disponibles

### 1. AuthProvider (`auth_provider.dart`)

Gère l'authentification et le profil utilisateur.

**Méthodes principales :**

- `login(phoneNumber, pinCode)` - Connexion avec téléphone et PIN
- `register(userData)` - Enregistrement d'un nouvel utilisateur
- `confirmRegisterOtp(telephone, codeOtp)` - Confirmation de l'enregistrement avec OTP
- `confirmLoginOtp(telephone, otpCode)` - Confirmation de la connexion avec OTP
- `loadUserProfile()` - Charger le profil utilisateur
- `logout()` - Déconnexion
- `checkAuthStatus()` - Vérifier si l'utilisateur est connecté

**Propriétés :**

- `userProfile` - Profil de l'utilisateur connecté
- `isAuthenticated` - État de connexion
- `isLoading` - État de chargement
- `error` - Message d'erreur éventuel

**Utilisation :**

```dart
// Accéder au provider
final authProvider = Provider.of<AuthProvider>(context);

// Ou avec listen: false pour éviter le rebuild
final authProvider = Provider.of<AuthProvider>(context, listen: false);

// Ou avec Consumer
Consumer<AuthProvider>(
  builder: (context, authProvider, child) {
    return Text(authProvider.userProfile?['nom'] ?? 'Utilisateur');
  },
)

// Ou avec context.read/context.watch
final authProvider = context.read<AuthProvider>(); // Ne rebuild pas
final isAuthenticated = context.watch<AuthProvider>().isAuthenticated; // Rebuild
```

### 2. CompteProvider (`compte_provider.dart`)

Gère les comptes, transactions et opérations financières.

**Méthodes principales :**

- `loadComptes(comptes)` - Charger les comptes
- `loadTransactions(transactions)` - Charger les transactions
- `loadQrCode(qrCode)` - Charger le QR code
- `makePayment(numeroCompte, codeMerchant, montant)` - Effectuer un paiement
- `makeTransfer(numeroCompte, telephoneDestinataire, montant)` - Effectuer un transfert
- `deposit(numeroCompte, montant)` - Déposer de l'argent
- `withdraw(numeroCompte, montant)` - Retirer de l'argent

**Propriétés :**

- `comptes` - Liste des comptes
- `transactions` - Liste des transactions
- `qrCode` - QR code de l'utilisateur
- `principalAccount` - Compte principal
- `balance` - Solde du compte principal
- `isLoading` - État de chargement
- `error` - Message d'erreur éventuel

**Utilisation :**

```dart
// Effectuer un paiement
final compteProvider = context.read<CompteProvider>();
final success = await compteProvider.makePayment(
  numeroCompte: '123456',
  codeMerchant: 'MERCHANT_CODE',
  montant: 5000,
);

if (success) {
  // Paiement réussi
} else {
  // Afficher l'erreur
  print(compteProvider.error);
}

// Afficher le solde
Consumer<CompteProvider>(
  builder: (context, compteProvider, child) {
    return Text('Solde: ${compteProvider.balance} FCFA');
  },
)
```

### 3. ServiceProvider (`service_provider.dart`)

Initialise et fournit les services de base (API, Auth, Compte).

**Utilisation :**
Ce provider est utilisé en interne et n'est généralement pas accédé directement dans les widgets.

## Configuration dans main.dart

Les providers sont configurés dans `main.dart` avec `MultiProvider` :

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialisation des services
  await Config.load();
  final tokenManager = TokenManagerMobile();
  await tokenManager.loadTokens();

  final apiService = ApiServiceImpl(
    Config.apiBaseUrl,
    tokenManager: tokenManager,
    client: http.Client(),
  );

  final authService = AuthService(apiService);
  final compteService = CompteService(apiService);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthProvider(
            authService: authService,
            tokenManager: tokenManager,
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => CompteProvider(
            compteService: compteService,
          ),
        ),
      ],
      child: const OrangeMoneyApp(),
    ),
  );
}
```

## Avantages de l'utilisation des Providers

1. **Pas d'injection de dépendances manuelle** - Plus besoin de passer les services à travers les constructeurs
2. **État partagé** - L'état est accessible depuis n'importe où dans l'arbre des widgets
3. **Rebuild optimisé** - Seuls les widgets qui écoutent les changements sont reconstruits
4. **Code plus propre** - Séparation claire entre la logique métier et l'UI
5. **Facilité de test** - Les providers peuvent être facilement mockés pour les tests

## Bonnes pratiques

1. **Utilisez `context.read<T>()` pour les actions** - Ne provoque pas de rebuild
2. **Utilisez `context.watch<T>()` pour l'affichage** - Rebuild automatique quand l'état change
3. **Utilisez `Consumer<T>` pour des rebuilds ciblés** - Optimise les performances
4. **Gérez les erreurs** - Toujours vérifier `provider.error` après une opération
5. **Nettoyez les erreurs** - Appelez `clearError()` quand nécessaire
