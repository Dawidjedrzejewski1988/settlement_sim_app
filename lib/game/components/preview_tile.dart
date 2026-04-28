import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class PreviewTile extends PositionComponent {
  bool visible = false;

  int tileX = 0;
  int tileY = 0;

  int widthTiles = 1;
  int heightTiles = 1;

  bool canBuild = true;

  PreviewTile()
      : super(
          size: Vector2.zero(),
          priority: 30,
        );

  @override
  void render(Canvas canvas) {
    if (!visible) return;

    final fillColor =
        canBuild ? const Color(0x6632D74B) : const Color(0x66FF3B30);

    final borderColor =
        canBuild ? const Color(0xFF00E5FF) : const Color(0xFFFF453A);

    final glowColor =
        canBuild ? const Color(0x4400E5FF) : const Color(0x44FF453A);

    for (int y = 0; y < heightTiles; y++) {
      for (int x = 0; x < widthTiles; x++) {
        final dx = (x - y) * 64.0;
        final dy = (x + y) * 32.0;

        final path = Path()
          ..moveTo(dx + 64, dy)
          ..lineTo(dx + 128, dy + 32)
          ..lineTo(dx + 64, dy + 64)
          ..lineTo(dx, dy + 32)
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
            ..color = glowColor
            ..style = PaintingStyle.stroke
            ..strokeWidth = 5,
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
