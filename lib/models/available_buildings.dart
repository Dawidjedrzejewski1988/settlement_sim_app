import 'resource.dart';

class AvailableBuilding {
  final int type;
  final String? name;
  final int tier;
  final bool canBuild;
  final String? reason;
  final List<Resource>? cost;
  final List<Resource>? input;
  final Resource? producedResource;
  final double productionPerTick;
  final int maxWorkers;
  final int storageCapacity;
  final int housing;
  final double moraleBonus;
  final bool producesKnowledge;

  AvailableBuilding({
    required this.type,
    required this.name,
    required this.tier,
    required this.canBuild,
    required this.reason,
    required this.cost,
    required this.input,
    required this.producedResource,
    required this.productionPerTick,
    required this.maxWorkers,
    required this.storageCapacity,
    required this.housing,
    required this.moraleBonus,
    required this.producesKnowledge,
  });

  factory AvailableBuilding.fromJson(Map<String, dynamic> json) {
    final costJson = json['cost'] as List<dynamic>? ?? [];
    final inputJson = json['input'] as List<dynamic>? ?? [];

    return AvailableBuilding(
      type: json['type'] ?? 0,
      name: json['name']?.toString(),
      tier: json['tier'] ?? 0,
      canBuild: json['canBuild'] ?? false,
      reason: json['reason']?.toString(),
      cost: costJson.map((e) => Resource.fromJson(e)).toList(),
      input: inputJson.map((e) => Resource.fromJson(e)).toList(),
      producedResource: json['producedResource'] != null
          ? Resource.fromJson(json['producedResource'])
          : null,
      productionPerTick: (json['productionPerTick'] as num?)?.toDouble() ?? 0.0,
      maxWorkers: json['maxWorkers'] ?? 0,
      storageCapacity: json['storageCapacity'] ?? 0,
      housing: json['housing'] ?? 0,
      moraleBonus: (json['moraleBonus'] as num?)?.toDouble() ?? 0.0,
      producesKnowledge: json['producesKnowledge'] ?? false,
    );
  }
}
