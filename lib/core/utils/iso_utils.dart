import 'package:flame/components.dart';
import '../constants/game_constants.dart';

class IsoUtils {
  static Vector2 tileToWorld(int x, int y) {
    final px = (x - y) * GameConstants.tileW / 2;
    final py = (x + y) * GameConstants.tileH / 2;

    return Vector2(px, py);
  }

  static Vector2 worldToTile(double x, double y) {
    final tx =
        ((y / GameConstants.tileH) + (x / GameConstants.tileW)).floorToDouble();

    final ty =
        ((y / GameConstants.tileH) - (x / GameConstants.tileW)).floorToDouble();

    return Vector2(tx, ty);
  }
}
