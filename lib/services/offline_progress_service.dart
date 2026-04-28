import 'package:shared_preferences/shared_preferences.dart';

class OfflineProgressService {
  static const _wood = "offline_wood";
  static const _stone = "offline_stone";
  static const _money = "offline_money";
  static const _time = "offline_time";

  Future<void> save({
    required double wood,
    required double stone,
    required double money,
  }) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setDouble(_wood, wood);
    await prefs.setDouble(_stone, stone);
    await prefs.setDouble(_money, money);
    await prefs.setInt(
      _time,
      DateTime.now().millisecondsSinceEpoch,
    );
  }

  Future<Map<String, dynamic>> compare({
    required double wood,
    required double stone,
    required double money,
  }) async {
    final prefs = await SharedPreferences.getInstance();

    final oldWood = prefs.getDouble(_wood) ?? wood;
    final oldStone = prefs.getDouble(_stone) ?? stone;
    final oldMoney = prefs.getDouble(_money) ?? money;

    final oldTime =
        prefs.getInt(_time) ?? DateTime.now().millisecondsSinceEpoch;

    final now = DateTime.now().millisecondsSinceEpoch;

    final seconds = ((now - oldTime) / 1000).floor();

    return {
      "wood": (wood - oldWood).clamp(0, 999999),
      "stone": (stone - oldStone).clamp(0, 999999),
      "money": (money - oldMoney).clamp(0, 999999),
      "seconds": seconds,
    };
  }
}
