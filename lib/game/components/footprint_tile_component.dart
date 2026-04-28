import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class FootprintTileComponent extends PositionComponent {
  final Color color;

  FootprintTileComponent({
    required Vector2 position,
    required this.color,
  }) : super(
          position: position,
          size: Vector2(64, 32),
          anchor: Anchor.center,
        );

  @override
  void render(Canvas canvas) {
    final paint = Paint()..color = color.withOpacity(0.45);

    final path = Path()
      ..moveTo(size.x / 2, 0)
      ..lineTo(size.x, size.y / 2)
      ..lineTo(size.x / 2, size.y)
      ..lineTo(0, size.y / 2)
      ..close();

    canvas.drawPath(path, paint);
  }
}
