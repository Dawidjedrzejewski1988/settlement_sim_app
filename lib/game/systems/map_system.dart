import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:developer' as dev;

class MapSystem {
  static Future<Map<String, int>> load({
    required String apiUrl,
    required String token,
  }) async {
    try {
      final response = await http.get(
        Uri.parse('$apiUrl/api/map'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        return {
          'width': data['width'] ?? 60,
          'height': data['height'] ?? 60,
        };
      } else {
        dev.log("MAP ERROR: ${response.statusCode} ${response.body}");
      }
    } catch (e) {
      dev.log("MAP EXCEPTION: $e");
    }

    return {
      'width': 60,
      'height': 60,
    };
  }
}