import '../api/api_client.dart';

class SessionService {
  final api = ApiClient();

  Future<List<dynamic>> getSessions() async {
    final response = await api.dio.get("/api/sessions");
    return response.data;
  }

  Future<Map<String, dynamic>> joinSession(String id) async {
    final response = await api.dio.post("/api/sessions/$id/join");

    final newToken = response.data["accessToken"];

    if (newToken != null) {
      await api.storage.write(key: "token", value: newToken);
    }

    return response.data;
  }
}