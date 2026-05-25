import 'dart:ui';

import 'package:flame/components.dart';

import '../constants/game_constants.dart';
import '../utils/iso_utils.dart';
import '../systems/terrain_mask.dart';

class GridComponent extends PositionComponent {
  final int mapW;
  final int mapH;

  static const double gridOffsetY = -1333;

  bool visibleGrid = false;

  GridComponent({
    required this.mapW,
    required this.mapH,
  });

  @override
  void render(Canvas canvas) {
    if (!visibleGrid) return;

    final border = Paint()
      ..color = const Color(0x22FFFFFF)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.7;

    for (int y = 0; y < mapH; y++) {
      for (int x = 0; x < mapW; x++) {
        final pos = IsoUtils.tileToWorld(
          x,
          y,
        );

        final renderPos = Vector2(
          pos.x,
          pos.y + gridOffsetY,
        );

        if (!TerrainMask.canBuildAtPixel(
          renderPos.x.toInt(),
          renderPos.y.toInt(),
        )) {
          continue;
        }

        final path = Path()
          ..moveTo(
            renderPos.x,
            renderPos.y,
          )
          ..lineTo(
            renderPos.x + GameConstants.tileW / 2,
            renderPos.y + GameConstants.tileH / 2,
          )
          ..lineTo(
            renderPos.x,
            renderPos.y + GameConstants.tileH,
          )
          ..lineTo(
            renderPos.x - GameConstants.tileW / 2,
            renderPos.y + GameConstants.tileH / 2,
          )
          ..close();

        canvas.drawPath(
          path,
          border,
        );
      }
    }
  }
}
