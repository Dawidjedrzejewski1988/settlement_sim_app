import 'package:flutter/services.dart';
import 'package:image/image.dart' as img;

class TerrainMask {
  static late img.Image mask;

  static const double maskOffsetX = 0;
  static const double maskOffsetY = 1333;

  static Future<void> load() async {
    final data = await rootBundle.load(
      'assets/world/world_mask.png',
    );

    final Uint8List bytes = data.buffer.asUint8List();

    mask = img.decodeImage(bytes)!;
  }

  static bool canBuildAtPixel(
    int x,
    int y,
  ) {
    x -= maskOffsetX.toInt();
    y -= maskOffsetY.toInt();

    if (x < 0 || y < 0 || x >= mask.width || y >= mask.height) {
      return false;
    }

    final pixel = mask.getPixel(
      x,
      y,
    );

    final r = pixel.r.toInt();

    final g = pixel.g.toInt();

    final b = pixel.b.toInt();

    return r > 200 && g > 200 && b > 200;
  }
}
