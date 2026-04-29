import 'dart:convert';
import 'package:http/http.dart' as http;

class BuildSystem {
  static Future<void> build({
    required String apiUrl,
    required String token,
    required String type,
    required int x,
    required int y,
  }) async {
    final response = await http.post(
      Uri.parse('$apiUrl/api/buildings'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'type': type,
        'tileX': x,
        'tileY': y,
      }),
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception(
        'Build failed: ${response.statusCode} ${response.body}',
      );
    }
  }
}
