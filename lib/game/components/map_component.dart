import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import '../utils/iso_utils.dart';

class MapComponent extends PositionComponent {
  final int mapW;
  final int mapH;

  MapComponent({
    required this.mapW,
    required this.mapH,
  });

  @override
  void render(Canvas canvas) {
    final fill = Paint()
      ..color = const Color(0xFF7AAE4E);

    final border = Paint()
      ..color = Colors.black.withValues(alpha: 0.25)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    for (int y = 0; y < mapH; y++) {
      for (int x = 0; x < mapW; x++) {
        final pos = IsoUtils.tileToWorld(x, y);

        final path = Path()
          ..moveTo(pos.x, pos.y)
          ..lineTo(pos.x + 64, pos.y + 32)
          ..lineTo(pos.x, pos.y + 64)
          ..lineTo(pos.x - 64, pos.y + 32)
          ..close();

        canvas.drawPath(path, fill);
        canvas.drawPath(path, border);
      }
    }
  }
}