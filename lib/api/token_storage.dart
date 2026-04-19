import 'package:shared_preferences/shared_preferences.dart';

class TokenStorage {
  static const String _key = 'token';
  static String? _cachedToken;

  static Future<void> saveToken(String token) async {
    _cachedToken = token;

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_key, token);
    } catch (e) {
      print("Błąd zapisu tokena: $e");
    }
  }

  static Future<String?> getToken() async {
    if (_cachedToken != null && _cachedToken!.isNotEmpty) {
      return _cachedToken;
    }

    try {
      final prefs = await SharedPreferences.getInstance();
      _cachedToken = prefs.getString(_key);
      return _cachedToken;
    } catch (e) {
      print("Błąd odczytu tokena: $e");
      return null;
    }
  }

  static Future<void> clearToken() async {
    _cachedToken = null;

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_key);
    } catch (e) {
      print("Błąd usuwania tokena: $e");
    }
  }

  static Future<bool> isLoggedIn() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }
}
