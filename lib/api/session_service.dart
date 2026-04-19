import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/available_buildings.dart';
import '../models/building.dart';
import '../models/session.dart';
import '../models/settlement.dart';
import 'token_storage.dart';

class SessionService {
  static const String baseUrl = "https://www.settlementsim.pl";

  Future<Map<String, String>> _authHeaders({bool withJson = false}) async {
    final token = await TokenStorage.getToken();
    if (token == null || token.isEmpty)
      throw Exception("Brak tokena logowania.");
    return {
      "Authorization": "Bearer $token",
      if (withJson) "Content-Type": "application/json",
    };
  }

  Future<List<Session>> getSessions() async {
    final response = await http.get(Uri.parse("$baseUrl/api/sessions"),
        headers: await _authHeaders());
    if (response.statusCode != 200) throw Exception(_parseError(response.body));
    final List<dynamic> data = jsonDecode(response.body);
    return data.map((e) => Session.fromJson(e)).toList();
  }

  Future<String> joinSession(String sessionId) async {
    final response = await http.post(
      Uri.parse("$baseUrl/api/sessions/$sessionId/join"),
      headers: await _authHeaders(withJson: true),
    );
    if (response.statusCode != 200) throw Exception(_parseError(response.body));

    if (response.body.isNotEmpty) {
      final decoded = jsonDecode(response.body);
      if (decoded is Map<String, dynamic> && decoded["accessToken"] != null) {
        final newToken = decoded["accessToken"].toString();
        await TokenStorage.saveToken(newToken);
        return newToken;
      }
    }
    return await TokenStorage.getToken() ?? "";
  }

  Future<Settlement> getSettlement() async {
    final response = await http.get(Uri.parse("$baseUrl/api/settlement"),
        headers: await _authHeaders());
    if (response.statusCode != 200) throw Exception(_parseError(response.body));
    return Settlement.fromJson(jsonDecode(response.body));
  }

  Future<List<Building>> getBuildings() async {
    final response = await http.get(Uri.parse("$baseUrl/api/buildings"),
        headers: await _authHeaders());
    if (response.statusCode != 200) throw Exception(_parseError(response.body));
    final List<dynamic> data = jsonDecode(response.body);
    return data.map((e) => Building.fromJson(e)).toList();
  }

  Future<void> buildBuilding(String type, int x, int y) async {
    final response = await http.post(
      Uri.parse("$baseUrl/api/buildings"),
      headers: await _authHeaders(withJson: true),
      body: jsonEncode({
        "type": type,
        "tileX": x,
        "tileY": y,
      }),
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      print("Błąd budowania: ${response.body}");
      throw Exception(_parseError(response.body));
    }
  }

  Future<void> updateWorkers(String buildingId, int workers) async {
    final response = await http.patch(
      Uri.parse("$baseUrl/api/buildings/$buildingId/workers"),
      headers: await _authHeaders(withJson: true),
      body:
          workers.toString(),
    );

    if (response.statusCode != 200) throw Exception(_parseError(response.body));
  }

  Future<void> upgradeBuilding(String buildingId) async {
    final response = await http.patch(
      Uri.parse("$baseUrl/api/buildings/$buildingId/upgrade"),
      headers: await _authHeaders(),
    );
    if (response.statusCode != 200) throw Exception(_parseError(response.body));
  }

  Future<void> deleteBuilding(String buildingId) async {
    final response = await http.delete(
        Uri.parse("$baseUrl/api/buildings/$buildingId"),
        headers: await _authHeaders());
    if (response.statusCode != 200) throw Exception(_parseError(response.body));
  }

  Future<List<AvailableBuilding>> getAvailableBuildings() async {
    final response = await http.get(
        Uri.parse("$baseUrl/api/buildings/available"),
        headers: await _authHeaders());
    if (response.statusCode != 200) throw Exception(_parseError(response.body));
    final List<dynamic> data = jsonDecode(response.body);
    return data.map((e) => AvailableBuilding.fromJson(e)).toList();
  }

  String _parseError(String body) {
    try {
      final data = jsonDecode(body);
      if (data is Map) {
        if (data["errors"] is Map)
          return (data["errors"] as Map)
              .values
              .expand((e) => (e as List))
              .join("\n");
        return (data["error"] ?? data["message"] ?? data["title"] ?? body)
            .toString();
      }
      return body;
    } catch (_) {
      return body;
    }
  }
}
