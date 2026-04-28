import 'package:flame/components.dart';

class CameraSystem {
  static void center({
    required CameraComponent cam,
    required int mapW,
    required int mapH,
    required double tileW,
    required double tileH,
    required double zoom,
  }) {
    final centerX = (mapW - mapH) * tileW / 4;
    final centerY = (mapW + mapH) * tileH / 4;

    cam.viewfinder.position = Vector2(
      centerX,
      centerY,
    );

    cam.viewfinder.zoom = zoom;
  }

  static void drag(
    CameraComponent cam,
    Vector2 delta,
    double zoom,
  ) {
    cam.viewfinder.position -= delta / zoom;
  }
}
