class SettlementModel {
  final String id;
  final String name;
  final double money;
  final int population;
  final double morale;
  final int storageCapacity;
  final double storageUsed;
  final double storageFree;

  SettlementModel({
    required this.id,
    required this.name,
    required this.money,
    required this.population,
    required this.morale,
    required this.storageCapacity,
    required this.storageUsed,
    required this.storageFree,
  });

  factory SettlementModel.fromJson(Map<String, dynamic> json) {
    return SettlementModel(
      id: json["id"] ?? "",
      name: json["name"] ?? "",
      money: (json["money"] ?? 0).toDouble(),
      population: json["population"] ?? 0,
      morale: (json["morale"] ?? 0).toDouble(),
      storageCapacity: json["storageCapacity"] ?? 0,
      storageUsed: (json["storageUsed"] ?? 0).toDouble(),
      storageFree: (json["storageFree"] ?? 0).toDouble(),
    );
  }
}
