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
      offsetY: 0,
      spriteW: 150,
      spriteH: 150,
    ),

    "Cottage": BuildingVisualData(
      width: 2,
      height: 2,
      offsetX: 0,
      offsetY: 0,
      spriteW: 135,
      spriteH: 135,
    ),

    "LumberCamp": BuildingVisualData(
      width: 2,
      height: 2,
      offsetX: 0,
      offsetY: 0,
      spriteW: 155,
      spriteH: 155,
    ),

    "GatherersCamp": BuildingVisualData(
      width: 2,
      height: 2,
      offsetX: 0,
      offsetY: 0,
      spriteW: 155,
      spriteH: 155,
    ),

    "Warehouse": BuildingVisualData(
      width: 3,
      height: 3,
      offsetX: 0,
      offsetY: 0,
      spriteW: 230,
      spriteH: 200,
    ),

    "Market": BuildingVisualData(
      width: 3,
      height: 3,
      offsetX: 0,
      offsetY: 0,
      spriteW: 230,
      spriteH: 200,
    ),

    "Tavern": BuildingVisualData(
      width: 3,
      height: 3,
      offsetX: 0,
      offsetY: 0,
      spriteW: 230,
      spriteH: 200,
    ),

    "Sawmill": BuildingVisualData(
      width: 2,
      height: 2,
      offsetX: 0,
      offsetY: 0,
      spriteW: 170,
      spriteH: 155,
    ),

    "Quarry": BuildingVisualData(
      width: 2,
      height: 2,
      offsetX: 0,
      offsetY: 0,
      spriteW: 165,
      spriteH: 155,
    ),

    "Farm": BuildingVisualData(
      width: 3,
      height: 3,
      offsetX: 0,
      offsetY: 0,
      spriteW: 240,
      spriteH: 210,
    ),

    "Mill": BuildingVisualData(
      width: 2,
      height: 2,
      offsetX: 0,
      offsetY: 0,
      spriteW: 170,
      spriteH: 170,
    ),

    "Bakery": BuildingVisualData(
      width: 2,
      height: 2,
      offsetX: 0,
      offsetY: 0,
      spriteW: 170,
      spriteH: 170,
    ),

    "Workshop": BuildingVisualData(
      width: 2,
      height: 2,
      offsetX: 0,
      offsetY: 0,
      spriteW: 170,
      spriteH: 170,
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
          offsetY: 0,
          spriteW: 150,
          spriteH: 150,
        );
  }
}