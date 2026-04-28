class AvailableBuildingModel {
  final String type;
  final String name;
  final bool canBuild;
  final String? reason;

  AvailableBuildingModel({
    required this.type,
    required this.name,
    required this.canBuild,
    this.reason,
  });

  factory AvailableBuildingModel.fromJson(Map<String, dynamic> json) {
    return AvailableBuildingModel(
      type: json['type'] ?? '',
      name: json['name'] ?? '',
      canBuild: json['canBuild'] ?? false,
      reason: json['reason'],
    );
  }
}
