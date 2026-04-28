import 'package:flame/components.dart';
import '../data/building_definitions.dart';

class BuildPreviewComponent extends PositionComponent {
  SpriteComponent? preview;

  Future<void> setType(String type) async {
    removeAll(children);

    final def = BuildingDefinitions.get(type);

    final sprite = await Sprite.load(_getSprite(type));

    preview = SpriteComponent(
      sprite: sprite,
      size: Vector2(
        def.spriteW,
        def.spriteH,
      ),
      anchor: Anchor.bottomCenter,
    );

    preview!.opacity = 0.55;

    add(preview!);
  }

  void setOpacity(double value) {
    preview?.opacity = value;
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
        return "buildings/house_t1.png";
    }
  }
}
