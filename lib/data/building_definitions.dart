import '../models/building_definition.dart';

const List<BuildingDefinition> buildingDefinitions = [
  BuildingDefinition(
    type: "Cottage",
    name: "Cottage",
    assetPath: "assets/buildings/tier0/cottage.png",
    cost: {"Wood": 10},
  ),
  BuildingDefinition(
    type: "GatherersCamp",
    name: "Gatherers Camp",
    assetPath: "assets/buildings/tier0/gathererscamp.png",
    cost: {"Wood": 15},
  ),
  BuildingDefinition(
    type: "LumberCamp",
    name: "Lumber Camp",
    assetPath: "assets/buildings/tier0/lumbercamp.png",
    cost: {"Wood": 20},
  ),
  BuildingDefinition(
    type: "Market",
    name: "Market",
    assetPath: "assets/buildings/tier0/market.png",
    cost: {"Wood": 40, "Stone": 10},
  ),
  BuildingDefinition(
    type: "Workshop",
    name: "Research Lab",
    assetPath: "assets/buildings/tier0/researchlab.png",
    cost: {"Wood": 30, "Stone": 15},
  ),
  BuildingDefinition(
    type: "Sawmill",
    name: "Sawmill",
    assetPath: "assets/buildings/tier0/sawmill.png",
    cost: {"Wood": 35},
  ),
  BuildingDefinition(
    type: "Warehouse",
    name: "Warehouse",
    assetPath: "assets/buildings/tier0/warehouse.png",
    cost: {"Wood": 25, "Stone": 10},
  ),
  BuildingDefinition(
    type: "Bakery",
    name: "Bakery",
    assetPath: "assets/buildings/tier1/bakery.png",
    cost: {"Wood": 30, "Stone": 10},
  ),
  BuildingDefinition(
    type: "Farm",
    name: "Farm",
    assetPath: "assets/buildings/tier1/farm.png",
    cost: {"Wood": 20},
  ),
  BuildingDefinition(
    type: "Mill",
    name: "Mill",
    assetPath: "assets/buildings/tier1/mill.png",
    cost: {"Wood": 35, "Stone": 10},
  ),
  BuildingDefinition(
    type: "Quarry",
    name: "Quarry",
    assetPath: "assets/buildings/tier1/quarry.png",
    cost: {"Wood": 30},
  ),
  BuildingDefinition(
    type: "Tavern",
    name: "Tavern",
    assetPath: "assets/buildings/tier1/tavern.png",
    cost: {"Wood": 45, "Stone": 20},
  ),
  BuildingDefinition(
    type: "Workshop",
    name: "Workshop",
    assetPath: "assets/buildings/tier1/workshop.png",
    cost: {"Wood": 40, "Stone": 15},
  ),
];