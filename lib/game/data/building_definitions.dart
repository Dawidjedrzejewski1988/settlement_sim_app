class BuildingVisualData {
  final int width;
  final int height;

  final double offsetX;
  final double offsetY;

  final double spriteW;
  final double spriteH;

  const BuildingVisualData({
    required this.width,
    required this.height,
    required this.offsetX,
    required this.offsetY,
    required this.spriteW,
    required this.spriteH,
  });
}

class BuildingDefinitions {
  static const Map<String, BuildingVisualData> data = {
    "House": BuildingVisualData(
      width: 2,
      height: 2,
      offsetX: 0,
      offsetY: -8,
      spriteW: 220,
      spriteH: 220,
    ),
    "Cottage": BuildingVisualData(
      width: 2,
      height: 2,
      offsetX: 0,
      offsetY: -8,
      spriteW: 200,
      spriteH: 200,
    ),
    "LumberCamp": BuildingVisualData(
      width: 2,
      height: 2,
      offsetX: 0,
      offsetY: -10,
      spriteW: 230,
      spriteH: 230,
    ),
    "GatherersCamp": BuildingVisualData(
      width: 2,
      height: 2,
      offsetX: 0,
      offsetY: -10,
      spriteW: 230,
      spriteH: 230,
    ),
    "Warehouse": BuildingVisualData(
      width: 3,
      height: 3,
      offsetX: 0,
      offsetY: -18,
      spriteW: 320,
      spriteH: 280,
    ),
    "Market": BuildingVisualData(
      width: 3,
      height: 3,
      offsetX: 0,
      offsetY: -18,
      spriteW: 320,
      spriteH: 280,
    ),
    "Tavern": BuildingVisualData(
      width: 3,
      height: 3,
      offsetX: 0,
      offsetY: -18,
      spriteW: 320,
      spriteH: 280,
    ),
    "Sawmill": BuildingVisualData(
      width: 2,
      height: 2,
      offsetX: 0,
      offsetY: -10,
      spriteW: 240,
      spriteH: 220,
    ),
    "Quarry": BuildingVisualData(
      width: 2,
      height: 2,
      offsetX: 0,
      offsetY: -10,
      spriteW: 230,
      spriteH: 220,
    ),
    "Farm": BuildingVisualData(
      width: 3,
      height: 3,
      offsetX: 0,
      offsetY: -16,
      spriteW: 320,
      spriteH: 280,
    ),
    "Mill": BuildingVisualData(
      width: 2,
      height: 2,
      offsetX: 0,
      offsetY: -14,
      spriteW: 240,
      spriteH: 240,
    ),
    "Bakery": BuildingVisualData(
      width: 2,
      height: 2,
      offsetX: 0,
      offsetY: -14,
      spriteW: 240,
      spriteH: 240,
    ),
    "Workshop": BuildingVisualData(
      width: 2,
      height: 2,
      offsetX: 0,
      offsetY: -14,
      spriteW: 240,
      spriteH: 240,
    ),
  };

  static BuildingVisualData get(
    String type,
  ) {
    return data[type] ??
        const BuildingVisualData(
          width: 2,
          height: 2,
          offsetX: 0,
          offsetY: -10,
          spriteW: 220,
          spriteH: 220,
        );
  }
}
