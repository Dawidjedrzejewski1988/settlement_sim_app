import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/auth_response.dart';
import 'token_storage.dart';

class AuthService {
  static const String baseUrl = "https://www.settlementsim.pl";

  Future<AuthResponse> login(String email, String password) async {
    final response = await http
        .post(
          Uri.parse("$baseUrl/api/auth/login"),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode({"email": email.trim(), "password": password}),
        )
        .timeout(const Duration(seconds: 15));

    if (response.statusCode != 200) {
      throw Exception(_parseError(response.body));
    }

    final Map<String, dynamic> data = jsonDecode(response.body);
    final auth = AuthResponse.fromJson(data);

    if (auth.accessToken.isNotEmpty) {
      await TokenStorage.saveToken(auth.accessToken);
    }

    return auth;
  }

  Future<void> register(String email, String password) async {
    final response = await http
        .post(
          Uri.parse("$baseUrl/api/auth/register"),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode({"email": email.trim(), "password": password}),
        )
        .timeout(const Duration(seconds: 15));

    if (response.statusCode != 200) {
      throw Exception(_parseError(response.body));
    }
  }

  Future<void> saveNewToken(String token) async {
    await TokenStorage.saveToken(token);
  }

  Future<String?> getToken() async {
    return TokenStorage.getToken();
  }

  Future<void> logout() async {
    await TokenStorage.clearToken();
  }

  String _parseError(String body) {
    try {
      final dynamic data = jsonDecode(body);

      if (data is Map<String, dynamic>) {
        if (data["errors"] != null && data["errors"] is Map<String, dynamic>) {
          final errors = data["errors"] as Map<String, dynamic>;
          return errors.values
              .expand((e) => (e as List).map((x) => x.toString()))
              .join("\n");
        }

        if (data["error"] != null) {
          return data["error"].toString();
        }

        if (data["message"] != null) {
          return data["message"].toString();
        }

        if (data["title"] != null) {
          return data["title"].toString();
        }
      }

      return body.isNotEmpty ? body : "Wystąpił nieznany błąd.";
    } catch (_) {
      return body.isNotEmpty ? body : "Wystąpił nieznany błąd.";
    }
  }
}
