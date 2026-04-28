class BuildingUpgradeData {
  final int level;
  final double cost;
  final bool canUpgrade;

  const BuildingUpgradeData({
    required this.level,
    required this.cost,
    required this.canUpgrade,
  });
}

class BuildingUpgradeDatabase {
  static BuildingUpgradeData get(String type) {
    switch (type) {
      case "LumberCamp":
        return const BuildingUpgradeData(
          level: 1,
          cost: 50,
          canUpgrade: true,
        );

      case "GatherersCamp":
        return const BuildingUpgradeData(
          level: 1,
          cost: 45,
          canUpgrade: true,
        );

      case "Warehouse":
        return const BuildingUpgradeData(
          level: 1,
          cost: 70,
          canUpgrade: true,
        );

      case "Quarry":
        return const BuildingUpgradeData(
          level: 1,
          cost: 60,
          canUpgrade: true,
        );

      case "Farm":
        return const BuildingUpgradeData(
          level: 1,
          cost: 65,
          canUpgrade: true,
        );

      case "Market":
        return const BuildingUpgradeData(
          level: 1,
          cost: 100,
          canUpgrade: true,
        );

      case "House":
        return const BuildingUpgradeData(
          level: 1,
          cost: 80,
          canUpgrade: true,
        );

      default:
        return const BuildingUpgradeData(
          level: 1,
          cost: 0,
          canUpgrade: false,
        );
    }
  }
}
