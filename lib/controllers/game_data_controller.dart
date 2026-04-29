import '../api/services.dart';
import '../api/models.dart';
import '../logic/game_loader.dart';

class GameDataController {
  final SettlementService settlementService;
  final BuildingService buildingService;
  final EventService eventService;

  GameDataController({
    required this.settlementService,
    required this.buildingService,
    required this.eventService,
  });

  Future<Map<String, dynamic>> loadSettlement() async {
    final response = await settlementService.getSettlement();

    final result = <String, dynamic>{};

    GameLoader.loadResources(
      data: response,
      onLoaded: (
        wood,
        plank,
        berries,
        stone,
        bread,
        money,
        morale,
        population,
      ) {
        result["wood"] = wood;
        result["plank"] = plank;
        result["berries"] = berries;
        result["stone"] = stone;
        result["bread"] = bread;
        result["money"] = money;
        result["morale"] = morale;
        result["population"] = population;
      },
    );

    return result;
  }

  Future<List<AvailableBuilding>> loadBuildings() async {
    return await buildingService.getAvailableBuildings();
  }

  Future<List<Event>> loadEvents() async {
    return await eventService.getEvents();
  }
}