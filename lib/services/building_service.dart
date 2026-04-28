import '../api/api_client.dart';

class BuildingService {
  final dio = ApiClient().dio;

  Future<List<dynamic>> getBuildings(String settlementId) async {
    final res = await dio.get(
      "/api/buildings",
      queryParameters: {"settlementId": settlementId},
    );
    return res.data;
  }

  Future<List<dynamic>> getAvailableBuildings() async {
    final res = await dio.get("/api/buildings/available");
    return res.data;
  }

  Future<void> buildBuilding({
    required String type,
    required int tileX,
    required int tileY,
  }) async {
    await dio.post(
      "/api/buildings",
      data: {
        "type": type,
        "tileX": tileX,
        "tileY": tileY,
      },
    );
  }

  // ✅ DODAJ TO
  Future<void> updateWorkers({
    required String buildingId,
    required int workers,
  }) async {
    await dio.patch(
      "/api/buildings/$buildingId/workers",
      data: workers,
    );
  }

  // ✅ DODAJ TO
  Future<void> upgrade({
    required String buildingId,
  }) async {
    await dio.patch(
      "/api/buildings/$buildingId/upgrade",
    );
  }

  // ✅ DODAJ TO
  Future<void> delete({
    required String buildingId,
  }) async {
    await dio.delete(
      "/api/buildings/$buildingId",
    );
  }
}