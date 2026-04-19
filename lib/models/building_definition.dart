class BuildingDefinition {
  final String type;
  final String name;
  final String assetPath;
  final Map<String, int> cost;

  const BuildingDefinition({
    required this.type,
    required this.name,
    required this.assetPath,
    required this.cost,
  });
}
