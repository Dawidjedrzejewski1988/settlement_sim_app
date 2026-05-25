import 'package:flame/components.dart';

class MapComponent extends SpriteComponent {
  static const double mapWidth = 4000;

  static const double mapHeight = 2667;

  static final Vector2 mapOffset = Vector2(
    2000,
    1333,
  );

  MapComponent()
      : super(
          anchor: Anchor.center,
        );

  @override
  Future<void> onLoad() async {
    sprite = await Sprite.load(
      'world/world.png',
    );

    size = Vector2(
      mapWidth,
      mapHeight,
    );

    position = mapOffset;
  }
}
