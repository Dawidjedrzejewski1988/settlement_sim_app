import 'package:dio/dio.dart';

class BuildingService {
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

  Future<Response> getBuildings(
    String token,
    String settlementId,
  ) async {
    _auth(token);

    return await dio.get(
      "/api/buildings",
      queryParameters: {
        "settlementId": settlementId,
      },
    );
  }

  Future<Response> getAvailableBuildings(
    String token,
  ) async {
    _auth(token);

    return await dio.get(
      "/api/buildings/available",
    );
  }

  Future<void> buildBuilding({
    required String token,
    required String settlementId,
    required String type,
    required int tileX,
    required int tileY,
  }) async {
    _auth(token);

    await dio.post(
      "/api/buildings",
      data: {
        "type": type,
        "tileX": tileX,
        "tileY": tileY,
      },
    );
  }

  Future<void> setWorkers({
    required String token,
    required String buildingId,
    required int workers,
  }) async {
    _auth(token);

    await dio.patch(
      "/api/buildings/$buildingId/workers",
      data: workers,
    );
  }

  Future<void> upgradeBuilding({
    required String token,
    required String buildingId,
  }) async {
    _auth(token);

    await dio.patch(
      "/api/buildings/$buildingId/upgrade",
    );
  }

  Future<void> deleteBuilding({
    required String token,
    required String buildingId,
  }) async {
    _auth(token);

    await dio.delete(
      "/api/buildings/$buildingId",
    );
  }
}
