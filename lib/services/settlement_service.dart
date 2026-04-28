// lib/services/settlement_service.dart

import 'package:dio/dio.dart';

class SettlementService {
  final Dio dio = Dio(
    BaseOptions(
      baseUrl: "https://settlementsim.pl",
      headers: {
        "Content-Type": "application/json",
      },
    ),
  );

  Future<Response> getSettlement(String token) async {
    return await dio.get(
      "/api/settlement",
      options: Options(
        headers: {
          "Authorization": "Bearer $token",
        },
      ),
    );
  }
}
