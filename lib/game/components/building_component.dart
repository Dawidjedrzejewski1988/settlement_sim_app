import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/collisions.dart';
import '../utils/sprite_cache.dart';
import '../data/building_definitions.dart';

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
          priority: data["tileY"] ?? 0,
        );

  @override
  Future<void> onLoad() async {
    final type = data["type"];
    final def = BuildingDefinitions.get(type);

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
        return "buildings/house.png";

      case "Cottage":
        return "buildings/cottage.png";

      case "LumberCamp":
        return "buildings/lumbercamp.png";

      case "GatherersCamp":
        return "buildings/gathererscamp.png";

      case "Warehouse":
        return "buildings/warehouse.png";

      case "Market":
        return "buildings/market.png";

      case "Tavern":
        return "buildings/tavern.png";

      case "Sawmill":
        return "buildings/sawmill.png";

      case "Quarry":
        return "buildings/quarry.png";

      case "Farm":
        return "buildings/farm.png";

      case "Mill":
        return "buildings/mill.png";

      case "Bakery":
        return "buildings/bakery.png";

      case "Workshop":
        return "buildings/workshop.png";

      default:
        return "buildings/cottage.png";
    }
  }
}
