import 'package:flame/components.dart';

class CameraSystem {
  static void center({
    required CameraComponent cam,
    required double zoom,
  }) {
      cam.viewfinder.position = Vector2(
        2000,
        1333,
      );

    cam.viewfinder.zoom = zoom;
  }

  static void drag({
    required CameraComponent cam,
    required Vector2 delta,
    required double zoom,
  }) {
    cam.viewfinder.position -= delta / zoom;
  }
}