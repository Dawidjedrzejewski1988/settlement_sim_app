import 'package:flame/components.dart';

class SpriteCache {
  static final Map<String, Sprite> _cache = {};

  static Future<Sprite> get(String path) async {
    if (_cache.containsKey(path)) {
      return _cache[path]!;
    }

    final sprite = await Sprite.load(path);

    _cache[path] = sprite;

    return sprite;
  }
}