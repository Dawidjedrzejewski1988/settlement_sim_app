class BuildingSize {
  final int width;
  final int height;

  const BuildingSize({
    required this.width,
    required this.height,
  });
}

class BuildingSizes {
  static const Map<String, BuildingSize> sizes = {
    "LumberCamp": BuildingSize(width: 2, height: 2),
    "GatherersCamp": BuildingSize(width: 2, height: 2),
    "Cottage": BuildingSize(width: 2, height: 2),
    "House": BuildingSize(width: 3, height: 3),
    "Warehouse": BuildingSize(width: 4, height: 4),
    "Market": BuildingSize(width: 4, height: 4),
    "Sawmill": BuildingSize(width: 3, height: 2),
    "Quarry": BuildingSize(width: 3, height: 2),
    "Workshop": BuildingSize(width: 3, height: 2),
    "Farm": BuildingSize(width: 4, height: 3),
    "Mill": BuildingSize(width: 3, height: 3),
    "Bakery": BuildingSize(width: 3, height: 3),
    "Tavern": BuildingSize(width: 4, height: 3),
  };

  static BuildingSize get(String type) {
    return sizes[type] ?? const BuildingSize(width: 1, height: 1);
  }
}
