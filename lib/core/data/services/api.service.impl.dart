import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:om_paie_flutter/core/errors/api.exception.dart';
import 'package:om_paie_flutter/core/network/iapi.service.dart';
import 'package:om_paie_flutter/features/auth/token.manager.dart';

class ApiServiceImpl implements IApiService {
  final String baseUrl;
  final http.Client client;
  final TokenManager tokenManager; // plus nullable
  final Future<Map<String, dynamic>> Function()? refreshCallback;
  bool _isRefreshing = false;

  ApiServiceImpl(
      this.baseUrl, {
        required this.tokenManager,
        this.refreshCallback,
        http.Client? client,
      }) : client = client ?? http.Client();

  Map<String, String> _jsonHeaders() {
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    if (tokenManager.accessToken != null) {
      headers['Authorization'] = 'Bearer ${tokenManager.accessToken}';
    }

    return headers;
  }

  // Helper to execute request with automatic token refresh on 401
  Future<T> _executeWithRetry<T>(Future<T> Function() request) async {
    try {
      return await request();
    } on TokenExpiredException {
      if (refreshCallback == null || _isRefreshing) rethrow;

      _isRefreshing = true;
      try {
        final refreshResult = await refreshCallback!();
        // Assume refreshResult contains new tokens
        final newAccessToken = refreshResult['access_token'] as String?;
        final newRefreshToken = refreshResult['refresh_token'] as String?;
        if (newAccessToken != null && newRefreshToken != null) {
          await tokenManager.setTokens(
            accessToken: newAccessToken,
            refreshToken: newRefreshToken,
            accessTokenExpiry: DateTime.now().add(Duration(hours: 1)), // adjust based on backend
          );
          // Retry the original request
          return await request();
        } else {
          rethrow;
        }
      } finally {
        _isRefreshing = false;
      }
    }
  }


  // ----------------------------------------------------------
  // GET (retourne une LISTE)
  // ----------------------------------------------------------
  @override
  Future<List<dynamic>> get(String endpoint) async {
    return _executeWithRetry(() async {
      final response = await client.get(
        Uri.parse('$baseUrl/$endpoint'),
        headers: _jsonHeaders(),
      );

      final body = _handleResponse(response, "GET");

      if (body is List) return body;

      throw ApiException("GET: La réponse n'est pas une liste JSON", 500);
    });
  }

  // ----------------------------------------------------------
  // GET (retourne un OBJET)
  // ----------------------------------------------------------
  @override
  Future<Map<String, dynamic>> getObject(String endpoint) async {
    return _executeWithRetry(() async {
      final response = await client.get(
        Uri.parse('$baseUrl/$endpoint'),
        headers: _jsonHeaders(),
      );

      final body = _handleResponse(response, "GET OBJECT");

      if (body is Map<String, dynamic>) return body;

      throw ApiException("GET OBJECT: La réponse n'est pas un objet JSON", 500);
    });
  }

  // ----------------------------------------------------------
  // GET /resource/value => OBJET
  // ----------------------------------------------------------
  @override
  Future<Map<String, dynamic>> getByPath(String resource, String value) async {
    return getObject('$resource/$value');
  }

  // ----------------------------------------------------------
  // GET /resource/value => LISTE
  // ----------------------------------------------------------
  @override
  Future<List<dynamic>> getListByPath(String resource, String value) async {
    return get('$resource/$value');
  }

  // ----------------------------------------------------------
  // POST
  // ----------------------------------------------------------
  @override
  Future<Map<String, dynamic>> post(String endpoint, Map<String, dynamic> data) async {
    return _executeWithRetry(() async {
      final response = await client.post(
        Uri.parse('$baseUrl/$endpoint'),
        headers: _jsonHeaders(),
        body: jsonEncode(data),
      );

      final body = _handleResponse(response, "POST");

      if (body is Map<String, dynamic>) return body;

      throw ApiException("POST: La réponse n'est pas un objet JSON", 500);
    });
  }

  // ----------------------------------------------------------
  // PUT
  // ----------------------------------------------------------
  @override
  Future<Map<String, dynamic>> put(String endpoint, Map<String, dynamic> data) async {
    final response = await client.put(
      Uri.parse('$baseUrl/$endpoint'),
      headers: _jsonHeaders(),
      body: jsonEncode(data),
    );

    final body = _handleResponse(response, "PUT");

    if (body is Map<String, dynamic>) return body;

    throw ApiException("PUT: La réponse n'est pas un objet JSON", 500);
  }

  // ----------------------------------------------------------
  // DELETE
  // ----------------------------------------------------------
  @override
  Future<void> delete(String endpoint) async {
    return _executeWithRetry(() async {
      final response = await client.delete(
        Uri.parse('$baseUrl/$endpoint'),
        headers: _jsonHeaders(),
      );

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw ApiException("Erreur DELETE", response.statusCode);
      }
    });
  }

  // ----------------------------------------------------------
  // GET RAW (pour SVG, images, etc.)
  // ----------------------------------------------------------
  Future<String> getRaw(String endpoint) async {
    return _executeWithRetry(() async {
      final response = await client.get(
        Uri.parse('$baseUrl/$endpoint'),
        headers: _jsonHeaders(),
      );

      if (response.statusCode >= 400) {
        throw ApiException("Erreur GET RAW", response.statusCode);
      }

      return response.body;
    });
  }

  // ----------------------------------------------------------
  // HANDLE RESPONSE (Standard)
  // ----------------------------------------------------------
  dynamic _handleResponse(http.Response response, String method) {
    final statusCode = response.statusCode;
    final raw = response.body;

    try {
      final decoded = jsonDecode(raw);

      // Special handling for 401 - token expired
      if (statusCode == 401) {
        throw TokenExpiredException();
      }

      // Errors Laravel / Node ou backend custom
      if (statusCode >= 400) {
        final message = decoded['message'] ?? "Erreur $method";
        
        // Extraction des détails de validation pour 422
        Map<String, dynamic>? details;
        if (statusCode == 422 && decoded['errors'] != null) {
          details = decoded['errors'] as Map<String, dynamic>?;
        }
        
        throw ApiException(message, statusCode, details: details);
      }

      return decoded;
    } catch (e) {
      if (e is TokenExpiredException) rethrow;
      if (e is ApiException) rethrow;
      throw ApiException(
        "Erreur JSON ($method): ${e.toString()}",
        statusCode,
      );
    }
  }
}
