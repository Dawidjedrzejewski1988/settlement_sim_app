import '../models/building_definition.dart';

const List<BuildingDefinition> buildingDefinitions = [
  BuildingDefinition(
    type: 0,
    name: "Cottage",
    assetPath: "assets/buildings/tier0/cottage.png",
    cost: {"Wood": 10},
  ),
  BuildingDefinition(
    type: 1,
    name: "Gatherers Camp",
    assetPath: "assets/buildings/tier0/gathererscamp.png",
    cost: {"Wood": 15},
  ),
  BuildingDefinition(
    type: 2,
    name: "Lumber Camp",
    assetPath: "assets/buildings/tier0/lumbercamp.png",
    cost: {"Wood": 20},
  ),
  BuildingDefinition(
    type: 3,
    name: "Market",
    assetPath: "assets/buildings/tier0/market.png",
    cost: {"Wood": 40, "Stone": 10},
  ),
  BuildingDefinition(
    type: 4,
    name: "Research Lab",
    assetPath: "assets/buildings/tier0/researchlab.png",
    cost: {"Wood": 30, "Stone": 15},
  ),
  BuildingDefinition(
    type: 5,
    name: "Sawmill",
    assetPath: "assets/buildings/tier0/sawmill.png",
    cost: {"Wood": 35},
  ),
  BuildingDefinition(
    type: 6,
    name: "Warehouse",
    assetPath: "assets/buildings/tier0/warehouse.png",
    cost: {"Wood": 25, "Stone": 10},
  ),
  BuildingDefinition(
    type: 7,
    name: "Bakery",
    assetPath: "assets/buildings/tier1/bakery.png",
    cost: {"Wood": 30, "Stone": 10},
  ),
  BuildingDefinition(
    type: 8,
    name: "Farm",
    assetPath: "assets/buildings/tier1/farm.png",
    cost: {"Wood": 20},
  ),
  BuildingDefinition(
    type: 9,
    name: "Mill",
    assetPath: "assets/buildings/tier1/mill.png",
    cost: {"Wood": 35, "Stone": 10},
  ),
  BuildingDefinition(
    type: 10,
    name: "Quarry",
    assetPath: "assets/buildings/tier1/quarry.png",
    cost: {"Wood": 30},
  ),
  BuildingDefinition(
    type: 11,
    name: "Tavern",
    assetPath: "assets/buildings/tier1/tavern.png",
    cost: {"Wood": 45, "Stone": 20},
  ),
  BuildingDefinition(
    type: 12,
    name: "Workshop",
    assetPath: "assets/buildings/tier1/workshop.png",
    cost: {"Wood": 40, "Stone": 15},
  ),
  BuildingDefinition(
    type: 13,
    name: "Unknown",
    assetPath: "assets/buildings/tier0/warehouse.png",
    cost: {},
  ),
];
