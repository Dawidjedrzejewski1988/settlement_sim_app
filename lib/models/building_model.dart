class BuildingModel {
  final String id;
  final String type;
  final String name;
  final int workers;
  final String status;
  final int maxWorkers;
  final double productionPerHour;
  final int tileX;
  final int tileY;

  BuildingModel({
    required this.id,
    required this.type,
    required this.name,
    required this.workers,
    required this.status,
    required this.maxWorkers,
    required this.productionPerHour,
    required this.tileX,
    required this.tileY,
  });

  factory BuildingModel.fromJson(Map<String, dynamic> json) {
    return BuildingModel(
      id: json["id"],
      type: json["type"],
      name: json["name"] ?? "",
      workers: json["workers"] ?? 0,
      status: json["status"] ?? "",
      maxWorkers: json["maxWorkers"] ?? 0,
      productionPerHour: (json["productionPerHour"] ?? 0).toDouble(),
      tileX: json["tileX"] ?? 0,
      tileY: json["tileY"] ?? 0,
    );
  }
}
