import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthService {
  final storage = const FlutterSecureStorage();

  final Dio dio = Dio(
    BaseOptions(
      baseUrl: "https://settlementsim.pl",
      headers: {
        "Content-Type": "application/json",
      },
    ),
  );

  Future<Response> login(String email, String password) async {
    final response = await dio.post(
      "/api/auth/login",
      data: {
        "email": email,
        "password": password,
      },
    );

    final token = response.data["accessToken"];

    await storage.write(
      key: "token",
      value: token,
    );

    return response;
  }

  Future<Response> register(String email, String password) async {
    return await dio.post(
      "/api/auth/register",
      data: {
        "email": email,
        "password": password,
      },
    );
  }
}
