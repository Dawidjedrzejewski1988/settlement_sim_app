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

    final fillColor =
        canBuild
            ? const Color(0x6632D74B)
            : const Color(0x66FF3B30);

    final borderColor =
        canBuild
            ? const Color(0xFF00E5FF)
            : const Color(0xFFFF453A);

    for (int y = 0; y < heightTiles; y++) {
      for (int x = 0; x < widthTiles; x++) {
        final dx =
            (x - y) * (GameConstants.tileW / 2)
            + GameConstants.tileW / 2;

        final dy =
            (x + y) * (GameConstants.tileH / 2);

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
          Paint()
            ..color = fillColor
            ..style = PaintingStyle.fill,
        );

        canvas.drawPath(
          path,
          Paint()
            ..color = borderColor
            ..style = PaintingStyle.stroke
            ..strokeWidth = 2,
        );
      }
    }
  }
}