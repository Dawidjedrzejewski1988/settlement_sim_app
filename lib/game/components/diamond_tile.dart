import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class DiamondTile extends PositionComponent {
  bool visibleGrid = false;

  bool hover = false;
  bool blocked = false;

  DiamondTile({
    required Vector2 position,
  }) : super(
          position: position,
          size: Vector2(128, 64),
          anchor: Anchor.topLeft,
          priority: 2,
        );

  @override
  void render(Canvas canvas) {
    if (!visibleGrid) return;

    final path = Path()
      ..moveTo(size.x / 2, 0)
      ..lineTo(size.x, size.y / 2)
      ..lineTo(size.x / 2, size.y)
      ..lineTo(0, size.y / 2)
      ..close();

    if (hover) {
      final fill = Paint()
        ..color = (blocked ? const Color(0x66FF3B30) : const Color(0x6632D74B))
            .withValues(alpha: 0.45);

      canvas.drawPath(path, fill);
    }

    final glow = Paint()
      ..color = (blocked ? const Color(0xFFFF453A) : const Color(0xFF00E5FF))
          .withValues(alpha: hover ? 0.90 : 0.40)
      ..style = PaintingStyle.stroke
      ..strokeWidth = hover ? 2.4 : 1.0;

    final line = Paint()
      ..color = const Color(0xAA000000)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.5;

    canvas.drawPath(path, glow);
    canvas.drawPath(path, line);
  }
}
