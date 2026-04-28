import '../services/building_service.dart';

class BuildingActions {
  final BuildingService service;

  BuildingActions(this.service);

  Future<void> build({
    required String type,
    required int x,
    required int y,
  }) async {
    await service.buildBuilding(
      type: type,
      tileX: x,
      tileY: y,
    );
  }

  Future<void> workers({
    required String id,
    required int workers,
  }) async {
    await service.updateWorkers(
      buildingId: id,
      workers: workers,
    );
  }

  Future<void> upgrade({
    required String id,
  }) async {
    await service.upgrade(
      buildingId: id,
    );
  }

  Future<void> delete({
    required String id,
  }) async {
    await service.delete(
      buildingId: id,
    );
  }
}