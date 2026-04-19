import 'resource.dart';

class Settlement {
  final String id;
  final String? name;
  final List<Resource> resources;

  final int storageCapacity;
  final double storageUsed;
  final double storageFree;

  final int population;
  final double morale;
  final double gold;
  final double knowledge;

  Settlement({
    required this.id,
    required this.name,
    required this.resources,
    required this.storageCapacity,
    required this.storageUsed,
    required this.storageFree,
    required this.population,
    required this.morale,
    required this.gold,
    required this.knowledge,
  });

  factory Settlement.fromJson(Map<String, dynamic> json) {
    final resourcesJson = json['resources'] as List<dynamic>? ?? [];

    return Settlement(
      id: (json['settlementId'] ?? json['id'] ?? "").toString(),
      name: json['name']?.toString(),
      resources: resourcesJson
          .map((e) => Resource.fromJson(e as Map<String, dynamic>))
          .toList(),
      storageCapacity: json['storageCapacity'] ?? 0,
      storageUsed: (json['storageUsed'] as num?)?.toDouble() ?? 0.0,
      storageFree: (json['storageFree'] as num?)?.toDouble() ?? 0.0,
      population: json['population'] ?? 0,
      morale: (json['morale'] as num?)?.toDouble() ?? 0.0,
      gold: (json['gold'] as num?)?.toDouble() ?? 0.0,
      knowledge: (json['knowledge'] as num?)?.toDouble() ?? 0.0,
    );
  }
}
