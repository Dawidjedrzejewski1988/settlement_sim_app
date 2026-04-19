import 'dart:ui';

class IsoUtils {
  static const double tileWidth = 256.0;
  static const double tileHeight = 128.0;

  static Offset gridToScreen(
      int gridX, int gridY, double startX, double startY) {
    final screenX = startX + (gridX - gridY) * (tileWidth / 2);
    final screenY = startY + (gridX + gridY) * (tileHeight / 2);
    return Offset(screenX, screenY);
  }

  static Offset screenToGrid(
      double screenX, double screenY, double startX, double startY) {
    final relX = screenX - startX;
    final relY = screenY - startY;

    final twHalf = tileWidth / 2;
    final thHalf = tileHeight / 2;

    final gridX = ((relX / twHalf + relY / thHalf) / 2);
    final gridY = ((relY / thHalf - relX / twHalf) / 2);

    return Offset(gridX, gridY);
  }
}
