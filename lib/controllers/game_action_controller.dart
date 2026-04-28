import '../logic/building_actions.dart';

class GameActionController {
  final BuildingActions actions;

  GameActionController(
    this.actions,
  );

  Future<void> build({
    required String token,
    required String settlementId,
    required String type,
    required int x,
    required int y,
  }) async {
    await actions.build(
      token: token,
      settlementId: settlementId,
      type: type,
      x: x,
      y: y,
    );
  }

  Future<void> workers({
    required String token,
    required dynamic id,
    required int workers,
  }) async {
    await actions.workers(
      token: token,
      id: id,
      workers: workers,
    );
  }

  Future<void> upgrade({
    required String token,
    required dynamic id,
  }) async {
    await actions.upgrade(
      token: token,
      id: id,
    );
  }

  Future<void> delete({
    required String token,
    required dynamic id,
  }) async {
    await actions.delete(
      token: token,
      id: id,
    );
  }
}
