import 'package:flame/components.dart';

import '../data/building_definitions.dart';
import '../utils/sprite_cache.dart';

class BuildPreviewComponent extends PositionComponent {
  SpriteComponent? preview;

  Future<void> setType(
    String type,
  ) async {
    if (preview != null) {
      remove(preview!);
    }

    final def = BuildingDefinitions.get(type);

    final sprite = await SpriteCache.get(
      _getSprite(type),
    );

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

  void setOpacity(
    double value,
  ) {
    preview?.opacity = value;
  }

  String _getSprite(
    String type,
  ) {
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

      case "Sawmill":
        return "buildings/sawmill.png";

      case "Quarry":
        return "buildings/quarry.png";

      case "Farm":
        return "buildings/farm_png";

      case "Mill":
        return "buildings/mill.png";

      case "Bakery":
        return "buildings/bakery.png";

      case "Workshop":
        return "buildings/workshop.png";

      default:
        return "buildings/house.png";
    }
  }
}
