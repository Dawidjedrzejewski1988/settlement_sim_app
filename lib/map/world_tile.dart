import 'tile_type.dart';

class WorldTile {
  TileType type;
  bool occupied;

  WorldTile({
    required this.type,
    this.occupied = false,
  });

  bool get isBuildable {
    return !occupied && (type == TileType.grass || type == TileType.fertile);
  }
}
