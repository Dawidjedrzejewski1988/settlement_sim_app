import 'package:flame/components.dart';

import '../constants/game_constants.dart';
import '../components/map_component.dart';

class IsoUtils {
  static Vector2 tileToWorld(
    int x,
    int y,
  ) {
    final px = (x - y) * GameConstants.tileW / 2;

    final py = (x + y) * GameConstants.tileH / 2;

    return Vector2(
          px,
          py,
        ) +
        MapComponent.mapOffset;
  }

  static Vector2 worldToTile(
    double x,
    double y,
  ) {
    final localX = x - MapComponent.mapOffset.x;

    final localY = y - MapComponent.mapOffset.y;

    final tx = ((localY / GameConstants.tileH) + (localX / GameConstants.tileW))
        .floorToDouble();

    final ty = ((localY / GameConstants.tileH) - (localX / GameConstants.tileW))
        .floorToDouble();

    return Vector2(
      tx,
      ty,
    );
  }
}
