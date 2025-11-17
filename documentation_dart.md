
# 🦋 Documentation complète sur Dart

## 1. Introduction à Dart

### 1.1 Présentation du langage
Dart est un langage **open-source**, développé par **Google**, orienté objet, compilé et optimisé pour les interfaces utilisateurs modernes.  
Il est la base de **Flutter**, mais peut aussi être utilisé pour :

- des **applications console**
- des **applications web**
- des **applications serveur**
- des **scripts** ou outils CLI

Il compile en **code natif (AOT)** ou **JIT (Just In Time)**.

### 1.2 Environnement et outils
- **Installation :**
  ```bash
  sudo apt install dart
  ```
- **Vérification :**
  ```bash
  dart --version
  ```
- **Création d’un projet console :**
  ```bash
  dart create -t console mon_projet
  cd mon_projet
  dart run
  ```

Structure du projet :
```
mon_projet/
├── bin/
│   └── mon_projet.dart
├── lib/
├── pubspec.yaml
└── test/
```

---

## 2. Concepts de base

### 2.1 Variables et Types
```dart
var nom = "Twist";
String prenom = "Price";
int age = 25;
double taille = 1.75;
bool estActif = true;

final dateNaissance = DateTime(2000);
const PI = 3.14;
```

### 2.2 Collections : List & Map
```dart
// List
List<String> fruits = ['pomme', 'mangue', 'banane'];
fruits.add('orange');
fruits.forEach(print);

// Map
Map<String, int> notes = {'Math': 15, 'Info': 18};
notes['Physique'] = 16;
notes.forEach((k, v) => print('$k : $v'));
```

---

## 3. Fonctions

### 3.1 Déclaration classique
```dart
int somme(int a, int b) {
  return a + b;
}
```

### 3.2 Paramètres nommés et optionnels
```dart
void saluer({String prenom = "Inconnu", int age = 0}) {
  print('Bonjour $prenom, tu as $age ans.');
}

saluer(prenom: 'Twist', age: 23);
```

### 3.3 Fonctions fléchées et callbacks
```dart
int multiplier(int x, int y) => x * y;

void operation(int a, int b, Function calcul) {
  print('Résultat: ${calcul(a, b)}');
}

operation(3, 4, (x, y) => x + y);
```

---

## 4. Programmation Orientée Objet

### 4.1 Classe et Constructeur
```dart
class Personne {
  String nom;
  int age;

  Personne(this.nom, this.age);
  Personne.deJeune(this.nom) : age = 18;

  factory Personne.fromJson(Map<String, dynamic> json) {
    return Personne(json['nom'], json['age']);
  }

  void afficher() => print('$nom a $age ans');
}
```

### 4.2 Héritage
```dart
class Employe extends Personne {
  String poste;

  Employe(String nom, int age, this.poste) : super(nom, age);

  @override
  void afficher() => print('$nom ($poste) - $age ans');
}
```

### 4.3 Interface & Mixins
```dart
abstract class Volant {
  void voler();
}

mixin Chantant {
  void chanter() => print("Je chante !");
}

class Oiseau implements Volant with Chantant {
  @override
  void voler() => print("Je vole !");
}
```

---

## 5. Asynchronisme : Future / async / await
```dart
Future<String> chargerDonnees() async {
  await Future.delayed(Duration(seconds: 2));
  return "Données chargées";
}

void main() async {
  print("Chargement...");
  String resultat = await chargerDonnees();
  print(resultat);
}
```

---

## 6. Exceptions
```dart
void division(int a, int b) {
  try {
    var res = a ~/ b;
    print(res);
  } on IntegerDivisionByZeroException {
    print("Division par zéro interdite !");
  } finally {
    print("Opération terminée");
  }
}
```

---

## 7. Gestion des dépendances
```yaml
dependencies:
  http: ^1.2.0
```
Installation :
```bash
dart pub get
```

---

## 8. Architecture d’une application console avec Backend (JSON Server)

### 8.1 Structure
```
mon_projet/
├── bin/
│   └── main.dart
├── lib/
│   ├── services/
│   │   ├── api_service.dart
│   │   └── user_service.dart
│   ├── entities/
│   │   └── user.dart
│   └── utils/
│       └── config.dart
└── pubspec.yaml
```

### 8.2 DTO (Entity)
```dart
class User {
  final int id;
  final String name;
  final String email;

  User({required this.id, required this.name, required this.email});

  factory User.fromJson(Map<String, dynamic> json) =>
      User(id: json['id'], name: json['name'], email: json['email']);

  Map<String, dynamic> toJson() =>
      {'id': id, 'name': name, 'email': email};
}
```

### 8.3 ApiService (Générique)
```dart
import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl;
  ApiService(this.baseUrl);

  Future<List<dynamic>> get(String endpoint) async {
    final response = await http.get(Uri.parse('$baseUrl/$endpoint'));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Erreur GET: ${response.statusCode}');
    }
  }

  Future<Map<String, dynamic>> post(String endpoint, Map data) async {
    final response = await http.post(
      Uri.parse('$baseUrl/$endpoint'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );
    return jsonDecode(response.body);
  }
}
```

### 8.4 Service spécifique (UserService)
```dart
import '../entities/user.dart';
import 'api_service.dart';

class UserService {
  final ApiService api;

  UserService(this.api);

  Future<List<User>> getUsers() async {
    final data = await api.get('users');
    return data.map<User>((json) => User.fromJson(json)).toList();
  }
}
```

### 8.5 Vue / Console
```dart
import '../lib/services/api_service.dart';
import '../lib/services/user_service.dart';

void main() async {
  final api = ApiService('http://localhost:3000');
  final userService = UserService(api);

  final users = await userService.getUsers();
  for (var u in users) {
    print('${u.name} - ${u.email}');
  }
}
```

### 8.6 Lancement du backend
```bash
npm install -g json-server
json-server --watch db.json --port 3000
```

---

## 9. Conclusion
Dart est un langage :  
- **Simple** à lire et proche de Java/C#
- **Puissant** (POO, async, typage fort, collections modernes)
- **Flexible** : un même langage pour console, web, mobile et serveur

---

_Auteur : Twist Price_
