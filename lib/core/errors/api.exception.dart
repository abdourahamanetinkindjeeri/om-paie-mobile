class ApiException implements Exception {
  final String message;
  final int statusCode;
  final Map<String, dynamic>? details; // Pour les erreurs de validation

  ApiException(this.message, this.statusCode, {this.details});

  @override
  String toString() {
    if (details != null && details!.isNotEmpty) {
      return 'ApiException: $message (code: $statusCode)\nDétails: $details';
    }
    return 'ApiException: $message (code: $statusCode)';
  }
}

class TokenExpiredException extends ApiException {
  TokenExpiredException() : super('Token expired', 401);
}
