class InputValidator {
  static bool isValidEmail(String email) {
    final emailRegex =
        RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    return emailRegex.hasMatch(email);
  }

  static bool isValidPhone(String phone) {
    final phoneRegex = RegExp(r'^\+221[0-9]{9}$');
    return phoneRegex.hasMatch(phone);
  }

  static bool isValidNumeroPiece(String numero, String type) {
    if (type == 'cni' || type == 'cin') {
      final cniRegex1 = RegExp(r'^\d{1}-\d{3}-\d{3}-\d{3}-\d{3}-\d{2}$');
      final cniRegex2 = RegExp(r'^[A-Z]\d{13}$');
      return cniRegex1.hasMatch(numero) || cniRegex2.hasMatch(numero);
    } else if (type == 'passport' || type == 'permis') {
      final regex = RegExp(r'^[A-Z]\d{13}$');
      return regex.hasMatch(numero);
    }
    return false;
  }

  static bool isValidPin(String code) {
    final pinRegex = RegExp(r'^\d{4}$');
    return pinRegex.hasMatch(code);
  }
}
