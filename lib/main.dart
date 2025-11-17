import 'dart:io';

void main() {
  print("Console OK !");
  print("Entrez votre nom : ");
  final nom = stdin.readLineSync();
  print("Bonjour $nom");
}
