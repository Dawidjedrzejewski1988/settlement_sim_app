import 'dart:math';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class TerrainTileComponent extends PositionComponent {
  static final Random _rng = Random();

  final int tileX;
  final int tileY;

  TerrainTileComponent({
    required Vector2 position,
    required this.tileX,
    required this.tileY,
  }) : super(
          position: position,
          size: Vector2(128, 64),
          anchor: Anchor.topLeft,
          priority: 0,
        );

  late final Paint basePaint;
  late final Paint detailPaint;
  late final Paint dirtPaint;
  late final Paint shadowPaint;

  late final int variant;
  late final bool hasStone;
  late final bool hasBush;
  late final bool hasFlower;
  late final bool hasDirt;

  @override
  Future<void> onLoad() async {
    variant = (tileX * 13 + tileY * 7 + _rng.nextInt(4)) % 4;

    hasStone = _rng.nextDouble() < 0.035;
    hasBush = _rng.nextDouble() < 0.045;
    hasFlower = _rng.nextDouble() < 0.020;
    hasDirt = _rng.nextDouble() < 0.055;

    Color grass;

    switch (variant) {
      case 0:
        grass = const Color(0xFF76B947);
        break;
      case 1:
        grass = const Color(0xFF6EAF42);
        break;
      case 2:
        grass = const Color(0xFF83C14F);
        break;
      default:
        grass = const Color(0xFF7AB84A);
    }

    basePaint = Paint()..color = grass;
    detailPaint = Paint()..color = const Color(0x22000000);
    dirtPaint = Paint()..color = const Color(0xFF7A5B39);
    shadowPaint = Paint()..color = const Color(0x22000000);
  }

  @override
  void render(Canvas canvas) {
    final diamond = Path()
      ..moveTo(size.x / 2, 0)
      ..lineTo(size.x, size.y / 2)
      ..lineTo(size.x / 2, size.y)
      ..lineTo(0, size.y / 2)
      ..close();

    canvas.drawPath(diamond, basePaint);

    final line = Paint()
      ..color = const Color(0x11000000)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.7;

    canvas.drawPath(diamond, line);

    if (hasDirt) {
      canvas.drawOval(
        Rect.fromCenter(
          center: Offset(64, 32),
          width: 24,
          height: 10,
        ),
        dirtPaint,
      );
    }

    if (hasStone) {
      canvas.drawOval(
        const Rect.fromLTWH(72, 28, 10, 6),
        Paint()..color = const Color(0xFF9C9C9C),
      );

      canvas.drawOval(
        const Rect.fromLTWH(78, 31, 7, 5),
        Paint()..color = const Color(0xFF777777),
      );
    }

    if (hasBush) {
      canvas.drawCircle(
        const Offset(58, 30),
        7,
        Paint()..color = const Color(0xFF3E7D27),
      );

      canvas.drawCircle(
        const Offset(64, 27),
        6,
        Paint()..color = const Color(0xFF4D8F31),
      );
    }

    if (hasFlower) {
      canvas.drawCircle(
        const Offset(70, 30),
        2.2,
        Paint()..color = const Color(0xFFFFD54F),
      );

      canvas.drawCircle(
        const Offset(74, 33),
        1.8,
        Paint()..color = const Color(0xFFFF7043),
      );
    }

    canvas.drawOval(
      Rect.fromCenter(
        center: const Offset(64, 52),
        width: 80,
        height: 8,
      ),
      shadowPaint,
    );
  }
}
