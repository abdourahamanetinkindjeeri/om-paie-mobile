// ================= VALIDATION =================

bool isValidEmail(String email) {
  final emailRegex =
      RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
  return emailRegex.hasMatch(email);
}

bool isValidPhone(String phone) {
  final phoneRegex = RegExp(r'^\+221[0-9]{9}$');
  return phoneRegex.hasMatch(phone);
}

bool isValidNumeroPiece(String numero, String type) {
  if (type == 'cni') {
    // Format attendu: chiffres avec tirets ou lettre + 13 chiffres
    final cniRegex1 = RegExp(r'^\d{1}-\d{3}-\d{3}-\d{3}-\d{3}-\d{2}$');
    final cniRegex2 = RegExp(r'^[A-Z]\d{13}$');
    return cniRegex1.hasMatch(numero) || cniRegex2.hasMatch(numero);
  } else if (type == 'passport') {
    // Format attendu: lettre + 13 chiffres
    final passportRegex = RegExp(r'^[A-Z]\d{13}$');
    return passportRegex.hasMatch(numero);
  } else if (type == 'permis') {
    // Format attendu: lettre + 13 chiffres
    final permisRegex = RegExp(r'^[A-Z]\d{13}$');
    return permisRegex.hasMatch(numero);
  }
  return false;
}

bool isValidPin(String code) {
  final pinRegex = RegExp(r'^\d{4}$');
  return pinRegex.hasMatch(code);
}
