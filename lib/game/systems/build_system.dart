import 'dart:convert';
import 'package:http/http.dart' as http;

class BuildSystem {
  static Future<void> buildHouse({
    required String apiUrl,
    required String token,
    required int x,
    required int y,
  }) async {
    try {
      await http.post(
        Uri.parse('$apiUrl/api/buildings'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'tileX': x,
          'tileY': y,
          'type': 'House',
        }),
      );
    } catch (_) {}
  }
}
