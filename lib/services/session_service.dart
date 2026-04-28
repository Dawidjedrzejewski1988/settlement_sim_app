import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SessionService {
  final storage = const FlutterSecureStorage();

  final Dio dio = Dio(
    BaseOptions(
      baseUrl: "https://settlementsim.pl",
      headers: {
        "Content-Type": "application/json",
      },
    ),
  );

  Future<void> setToken() async {
    final token = await storage.read(key: "token");

    dio.options.headers["Authorization"] = "Bearer $token";
  }

  Future<Response> getSessions() async {
    await setToken();
    return await dio.get("/api/sessions");
  }

  Future<Response> createSession(String name) async {
    await setToken();

    return await dio.post(
      "/api/sessions",
      data: {
        "name": name,
      },
    );
  }

  Future<Response> joinSession(String sessionId) async {
    await setToken();
    return await dio.post("/api/sessions/$sessionId/join");
  }

  Future<Response> deleteSession(String sessionId) async {
    await setToken();
    return await dio.delete("/api/sessions/$sessionId");
  }
}
