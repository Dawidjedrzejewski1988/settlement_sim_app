import 'dart:ui';

import 'package:flame/components.dart';

import '../constants/game_constants.dart';
import '../utils/iso_utils.dart';

class GridComponent extends PositionComponent {
  final int mapW;
  final int mapH;

  bool visibleGrid = false;

  GridComponent({
    required this.mapW,
    required this.mapH,
  });

  @override
  void render(Canvas canvas) {
    if (!visibleGrid) return;

    final border = Paint()
      ..color = const Color(0x88FFFFFF)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    for (int y = 0; y < mapH; y++) {
      for (int x = 0; x < mapW; x++) {
        final pos = IsoUtils.tileToWorld(x, y);

        final path = Path()
          ..moveTo(pos.x, pos.y)
          ..lineTo(
            pos.x + GameConstants.tileW / 2,
            pos.y + GameConstants.tileH / 2,
          )
          ..lineTo(
            pos.x,
            pos.y + GameConstants.tileH,
          )
          ..lineTo(
            pos.x - GameConstants.tileW / 2,
            pos.y + GameConstants.tileH / 2,
          )
          ..close();

        canvas.drawPath(path, border);
      }
    }
  }
}