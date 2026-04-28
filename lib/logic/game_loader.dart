class GameLoader {
  static void loadResources({
    required Map data,
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
    final Map<String, double> resources = {};

    for (final item in data["resources"]) {
      resources[item["code"]] = (item["amount"] as num).toDouble();
    }

    onLoaded(
      resources["Wood"] ?? 0,
      resources["Plank"] ?? 0,
      resources["Berries"] ?? 0,
      resources["Stone"] ?? 0,
      resources["Bread"] ?? 0,
      (data["money"] as num).toDouble(),
      (data["morale"] as num).toDouble(),
      data["population"] ?? 0,
    );
  }

  static int getTimer({
    required Map? building,
    required List events,
  }) {
    if (building == null) {
      return 0;
    }

    final id = building["id"].toString();

    for (final e in events) {
      final scope = e["scope"]?.toString() ?? "";

      final sec = e["remainingSeconds"] ?? 0;

      if (sec > 0 && scope.contains(id)) {
        return sec;
      }
    }

    return 0;
  }
}
