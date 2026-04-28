class BuildValidator {
  static bool canBuild({
    required int x,
    required int y,
    required int w,
    required int h,
    required int mapW,
    required int mapH,
    required List<dynamic> buildings,
  }) {
    if (x < 0 || y < 0) return false;

    if (x + w > mapW) return false;
    if (y + h > mapH) return false;

    for (int yy = y; yy < y + h; yy++) {
      for (int xx = x; xx < x + w; xx++) {
        for (final b in buildings) {
          if (b['tileX'] == xx && b['tileY'] == yy) {
            return false;
          }
        }
      }
    }

    return true;
  }
}
