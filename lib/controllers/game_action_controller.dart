import '../logic/building_actions.dart';

class GameActionController {
  final BuildingActions actions;

  GameActionController(this.actions);

  Future<void> build({
    required String type,
    required int x,
    required int y,
  }) async {
    await actions.build(
      type: type,
      x: x,
      y: y,
    );
  }

  Future<void> workers({
    required String id,
    required int workers,
  }) async {
    await actions.workers(
      id: id,
      workers: workers,
    );
  }

  Future<void> upgrade({
    required String id,
  }) async {
    await actions.upgrade(
      id: id,
    );
  }

  Future<void> delete({
    required String id,
  }) async {
    await actions.delete(
      id: id,
    );
  }
}