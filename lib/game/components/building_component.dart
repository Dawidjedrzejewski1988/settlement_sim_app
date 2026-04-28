import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/collisions.dart';

import '../data/building_definitions.dart';

/// 🔥 CACHE SPRITE (GLOBALNY)
class SpriteCache {
  static final Map<String, Sprite> _cache = {};

  static Future<Sprite> get(String path) async {
    if (_cache.containsKey(path)) return _cache[path]!;

    final sprite = await Sprite.load(path);
    _cache[path] = sprite;
    return sprite;
  }
}

class BuildingComponent extends SpriteComponent
    with TapCallbacks, CollisionCallbacks {
  final Map data;
  final Function(Map data)? onTapBuilding;

  BuildingComponent({
    required this.data,
    required Vector2 position,
    this.onTapBuilding,
  }) : super(
          position: position,
          anchor: Anchor.bottomCenter,
        );

  @override
  Future<void> onLoad() async {
    final type = data["type"];
    final def = BuildingDefinitions.get(type);

    /// 🔥 zamiast Sprite.load
    sprite = await SpriteCache.get(
      _getSprite(type),
    );

    size = Vector2(
      def.spriteW,
      def.spriteH,
    );

    add(
      RectangleHitbox(
        position: Vector2(
          -size.x * 0.15,
          -size.y * 0.95,
        ),
        size: Vector2(
          size.x * 1.3,
          size.y,
        ),
      ),
    );
  }

  @override
  void onTapDown(TapDownEvent event) {
    onTapBuilding?.call(data);
  }

  String _getSprite(String type) {
    switch (type) {
      case "House":
        return "buildings/house_t1.png";

      case "Cottage":
        return "buildings/cottage_t1.png";

      case "LumberCamp":
        return "buildings/lumbercamp_t1.png";

      case "GatherersCamp":
        return "buildings/gathererscamp_t1.png";

      case "Warehouse":
        return "buildings/warehouse_t1.png";

      case "Market":
        return "buildings/market_t1.png";

      case "Tavern":
        return "buildings/tavern_t1.png";

      case "Sawmill":
        return "buildings/sawmill_t1.png";

      case "Quarry":
        return "buildings/quarry_t1.png";

      case "Farm":
        return "buildings/farm_t1.png";

      case "Mill":
        return "buildings/mill_t1.png";

      case "Bakery":
        return "buildings/bakery_t2.png";

      case "Workshop":
        return "buildings/workshop_t1.png";

      default:
        return "buildings/cottage_t1.png";
    }
  }
}