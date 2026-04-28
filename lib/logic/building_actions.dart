import '../services/building_service.dart';

class BuildingActions {
  final BuildingService service;

  BuildingActions(
    this.service,
  );

  Future<void> build({
    required String token,
    required String settlementId,
    required String type,
    required int x,
    required int y,
  }) async {
    await service.buildBuilding(
      token: token,
      settlementId: settlementId,
      type: type,
      tileX: x,
      tileY: y,
    );
  }

  Future<void> workers({
    required String token,
    required dynamic id,
    required int workers,
  }) async {
    await service.setWorkers(
      token: token,
      buildingId: id,
      workers: workers,
    );
  }

  Future<void> upgrade({
    required String token,
    required dynamic id,
  }) async {
    await service.upgradeBuilding(
      token: token,
      buildingId: id,
    );
  }

  Future<void> delete({
    required String token,
    required dynamic id,
  }) async {
    await service.deleteBuilding(
      token: token,
      buildingId: id,
    );
  }
}
