import 'dart:convert';
import 'package:http/http.dart' as http;

class MapSystem {
  static Future<Map<String, int>> load(String apiUrl) async {
    try {
      final response = await http.get(Uri.parse('$apiUrl/api/map'));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        return {
          'width': data['width'] ?? 60,
          'height': data['height'] ?? 60,
        };
      }
    } catch (_) {}

    return {
      'width': 60,
      'height': 60,
    };
  }
}
