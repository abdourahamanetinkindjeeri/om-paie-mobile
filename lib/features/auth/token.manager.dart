class RegisterResponse {
  final bool success;
  final String message;
  final String identifier;
  final String codeOtp;
  final int expiresInMinutes;

  RegisterResponse({
    required this.success,
    required this.message,
    required this.identifier,
    required this.codeOtp,
    required this.expiresInMinutes,
  });

  factory RegisterResponse.fromJson(Map<String, dynamic> json) {
    return RegisterResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      identifier: json['identifier'] ?? '',
      codeOtp: json['code_otp'] ?? '',
      expiresInMinutes: json['expires_in_minutes'] ?? 0,
    );
  }
}
