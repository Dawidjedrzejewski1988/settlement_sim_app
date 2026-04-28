// lib/services/policy_service.dart

import 'package:dio/dio.dart';

class PolicyService {
  final Dio dio = Dio(
    BaseOptions(
      baseUrl: "https://settlementsim.pl",
      headers: {
        "Content-Type": "application/json",
      },
    ),
  );

  void _auth(String token) {
    dio.options.headers["Authorization"] = "Bearer $token";
  }

  Future<Response> getTaxPolicy(
    String token,
  ) async {
    _auth(token);

    return await dio.get(
      "/api/policy/tax",
    );
  }

  Future<void> chooseTaxPolicy({
    required String token,
    required String optionId,
  }) async {
    _auth(token);

    await dio.post(
      "/api/policy/tax",
      data: {
        "optionId": optionId,
      },
    );
  }
}
