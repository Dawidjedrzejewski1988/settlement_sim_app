import 'tile_type.dart';
import 'world_tile.dart';

class WorldMap {
  final int size;
  late List<List<WorldTile>> tiles;

  WorldMap(this.size) {
    tiles = List.generate(
      size,
      (x) => List.generate(
        size,
        (y) => WorldTile(type: TileType.grass),
      ),
    );

    _generateMap();
  }

  void _generateMap() {
    // =========================================================
    // 1) START: WSZYSTKO JAKO TRAWA
    // =========================================================
    for (int x = 0; x < size; x++) {
      for (int y = 0; y < size; y++) {
        tiles[x][y].type = TileType.grass;
      }
    }

    // =========================================================
    // 2) RZEKA - po prawej stronie, lekko ukośna
    // =========================================================
    for (int y = 0; y < size; y++) {
      int x = (size * 0.72).toInt() + ((y - size / 2) * 0.15).toInt();

      if (_inBounds(x, y)) {
        tiles[x][y].type = TileType.water;
      }
      if (_inBounds(x + 1, y)) {
        tiles[x + 1][y].type = TileType.water;
      }
    }

    // =========================================================
    // 3) GŁÓWNA DROGA POZIOMA
    // =========================================================
    for (int x = 6; x < size - 10; x++) {
      if (_inBounds(x, size ~/ 2)) {
        tiles[x][size ~/ 2].type = TileType.road;
      }
    }

    // =========================================================
    // 4) GŁÓWNA DROGA PIONOWA
    // =========================================================
    for (int y = 8; y < size - 8; y++) {
      if (_inBounds(size ~/ 2, y)) {
        tiles[size ~/ 2][y].type = TileType.road;
      }
    }

    // =========================================================
    // 5) MAŁA BOCZNA DROGA
    // =========================================================
    for (int x = 10; x < 18; x++) {
      if (_inBounds(x, size ~/ 2 + 6)) {
        tiles[x][size ~/ 2 + 6].type = TileType.road;
      }
    }

    // =========================================================
    // 6) STREFA ŻYZNEJ ZIEMI (pod farmy)
    // =========================================================
    for (int x = 4; x < 12; x++) {
      for (int y = size - 12; y < size - 6; y++) {
        if (_inBounds(x, y)) {
          tiles[x][y].type = TileType.fertile;
        }
      }
    }

    // =========================================================
    // 7) STREFA BLOKAD (skały / las / przeszkody)
    // =========================================================
    for (int x = size - 9; x < size - 3; x++) {
      for (int y = 4; y < 10; y++) {
        if (_inBounds(x, y)) {
          tiles[x][y].type = TileType.blocked;
        }
      }
    }

    // =========================================================
    // 8) DODATKOWE BLOKADY na obrzeżach
    // =========================================================
    for (int x = 0; x < 4; x++) {
      for (int y = 0; y < 6; y++) {
        if (_inBounds(x, y)) {
          tiles[x][y].type = TileType.blocked;
        }
      }
    }

    for (int x = size - 5; x < size; x++) {
      for (int y = size - 6; y < size; y++) {
        if (_inBounds(x, y)) {
          tiles[x][y].type = TileType.blocked;
        }
      }
    }
  }

  bool _inBounds(int x, int y) {
    return x >= 0 && x < size && y >= 0 && y < size;
  }

  WorldTile get(int x, int y) {
    return tiles[x][y];
  }
}
