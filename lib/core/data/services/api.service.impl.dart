import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:om_paie_flutter/core/errors/api.exception.dart';
import 'package:om_paie_flutter/core/network/iapi.service.dart';
import 'package:om_paie_flutter/features/auth/token.manager.dart';

class ApiServiceImpl implements IApiService {
  final String baseUrl;
  final http.Client client;
  final TokenManager tokenManager; // plus nullable

  ApiServiceImpl(
      this.baseUrl, {
        required this.tokenManager,
        http.Client? client,
      }) : client = client ?? http.Client();

  Map<String, String> _jsonHeaders() {
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    if (tokenManager?.accessToken != null) {
      headers['Authorization'] = 'Bearer ${tokenManager!.accessToken}';
    }

    return headers;
  }


  // ----------------------------------------------------------
  // GET (retourne une LISTE)
  // ----------------------------------------------------------
  @override
  Future<List<dynamic>> get(String endpoint) async {
    final response = await client.get(
      Uri.parse('$baseUrl/$endpoint'),
      headers: _jsonHeaders(),
    );

    final body = _handleResponse(response, "GET");

    if (body is List) return body;

    throw ApiException("GET: La réponse n'est pas une liste JSON", 500);
  }

  // ----------------------------------------------------------
  // GET (retourne un OBJET)
  // ----------------------------------------------------------
  @override
  Future<Map<String, dynamic>> getObject(String endpoint) async {
    final response = await client.get(
      Uri.parse('$baseUrl/$endpoint'),
      headers: _jsonHeaders(),
    );

    final body = _handleResponse(response, "GET OBJECT");

    if (body is Map<String, dynamic>) return body;

    throw ApiException("GET OBJECT: La réponse n'est pas un objet JSON", 500);
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
    final response = await client.post(
      Uri.parse('$baseUrl/$endpoint'),
      headers: _jsonHeaders(),
      body: jsonEncode(data),
    );

    final body = _handleResponse(response, "POST");

    if (body is Map<String, dynamic>) return body;

    throw ApiException("POST: La réponse n'est pas un objet JSON", 500);
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
    final response = await client.delete(
      Uri.parse('$baseUrl/$endpoint'),
      headers: _jsonHeaders(),
    );

    if (response.statusCode != 200 && response.statusCode != 204) {
      throw ApiException("Erreur DELETE", response.statusCode);
    }
  }

  // ----------------------------------------------------------
  // HANDLE RESPONSE (Standard)
  // ----------------------------------------------------------
  dynamic _handleResponse(http.Response response, String method) {
    final statusCode = response.statusCode;
    final raw = response.body;

    try {
      final decoded = jsonDecode(raw);

      // Errors Laravel / Node ou backend custom
      if (statusCode >= 400) {
        final message = decoded['message'] ?? "Erreur $method";
        throw ApiException(message, statusCode);
      }

      return decoded;
    } catch (e) {
      throw ApiException(
        "Erreur JSON ($method): ${e.toString()}",
        statusCode,
      );
    }
  }
}
