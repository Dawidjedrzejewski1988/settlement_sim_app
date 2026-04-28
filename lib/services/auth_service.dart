import '../api/api_client.dart';

class AuthService {
  final api = ApiClient();

  Future<void> login(String email, String password) async {
    final response = await api.dio.post(
      "/api/auth/login",
      data: {
        "email": email,
        "password": password,
      },
    );

    final token = response.data["accessToken"];

    await api.storage.write(
      key: "token",
      value: token,
    );
  }

  Future<void> register(String email, String password) async {
    await api.dio.post(
      "/api/auth/register",
      data: {
        "email": email,
        "password": password,
      },
    );
  }
}