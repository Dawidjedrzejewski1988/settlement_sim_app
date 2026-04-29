import '../api/models.dart';

class GameLoader {
  static void loadResources({
    required Settlement data,
    required Function(
      double wood,
      double plank,
      double berries,
      double stone,
      double bread,
      double money,
      double morale,
      int population,
    ) onLoaded,
  }) {
    double get(String code) {
      return data.resources
          .firstWhere(
            (r) => r.code == code,
            orElse: () => Resource(code: code, amount: 0),
          )
          .amount;
    }

    onLoaded(
      get("Wood"),
      get("Plank"),
      get("Berries"),
      get("Stone"),
      get("Bread"),
      data.money,
      data.morale,
      data.population,
    );
  }

  static int getTimer({
    required Building? building,
    required List<Event> events,
  }) {
    if (building == null) return 0;

    final id = building.id;

    for (final e in events) {
      final scope = e.scope ?? "";
      final sec = e.remainingSeconds;

      if (sec > 0 && scope.contains(id)) {
        return sec;
      }
    }

    return 0;
  }
}