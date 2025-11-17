import 'package:om_paie_flutter/core/data/services/api.service.impl.dart';
import 'package:om_paie_flutter/features/auth/register.response.dart';

class AuthService {
  final ApiServiceImpl api;

  AuthService(this.api);

  Future<RegisterResponse> register(Map<String, dynamic> userData) async {
    final response = await api.post("auth/register", userData);
    return RegisterResponse.fromJson(response);
  }

  /// Confirmation via OTP
  Future<Map<String, dynamic>> confirmRegister({
    required String telephone,
    required String codeOtp,
  }) async {
    final body = {
      "telephone": telephone,
      "code_otp": codeOtp,
    };

    // ✅ Correction : on envoie directement body
    final response = await api.post(
      "auth/register/confirmation",
      body,
    );

    return response; // success, message, data(tokens)
  }

  // --- LOGIN ---
  Future<Map<String, dynamic>> login({
    required String telephone,
    required String code,
  }) async {
    final body = {
      "telephone": telephone,
      "code": code,
    };

    final response = await api.post(
      "auth/login",
      body,
    );

    return response;
  }

  Future<Map<String, dynamic>> confirmLoginOTP({
    required String telephone,
    required String otpCode, // ← note le nom
  }) async {
    final body = {
      "telephone": telephone,
      "otp_code": otpCode, // ← clé exacte attendue par le backend
    };

    final response = await api.post(
      "auth/login/confirm", // ← endpoint exact du Swagger
      body,
    );

    return response; // success, message, access_token, refresh_token
  }


}


