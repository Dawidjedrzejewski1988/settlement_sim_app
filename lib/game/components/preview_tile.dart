import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import '../constants/game_constants.dart';

class PreviewTile extends PositionComponent {
  bool visible = false;

  int tileX = 0;
  int tileY = 0;

  int widthTiles = 1;
  int heightTiles = 1;

  bool canBuild = true;

  PreviewTile()
      : super(
          priority: 30,
        );

  @override
  void render(Canvas canvas) {
    if (!visible) return;

    final fillPaint = Paint()
      ..color = canBuild
          ? const Color(
              0x3322C55E,
            )
          : const Color(
              0x44EF4444,
            )
      ..style = PaintingStyle.fill;

    final borderPaint = Paint()
      ..color = canBuild
          ? const Color(
              0x8822C55E,
            )
          : const Color(
              0x99EF4444,
            )
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;

    for (int y = 0; y < heightTiles; y++) {
      for (int x = 0; x < widthTiles; x++) {
        final dx =
            (x - y) * (GameConstants.tileW / 2) + GameConstants.tileW / 2;

        final dy = (x + y) * (GameConstants.tileH / 2);

        final path = Path()
          ..moveTo(
            dx,
            dy,
          )
          ..lineTo(
            dx + GameConstants.tileW / 2,
            dy + GameConstants.tileH / 2,
          )
          ..lineTo(
            dx,
            dy + GameConstants.tileH,
          )
          ..lineTo(
            dx - GameConstants.tileW / 2,
            dy + GameConstants.tileH / 2,
          )
          ..close();

        canvas.drawPath(
          path,
          fillPaint,
        );

        canvas.drawPath(
          path,
          borderPaint,
        );
      }
    }
  }
}
