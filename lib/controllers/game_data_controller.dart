import '../services/building_service.dart';
import '../services/event_service.dart';
import '../services/settlement_service.dart';
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

  Future<List<dynamic>> loadBuildings() async {
    final response = await buildingService.getAvailableBuildings();
    return response;
  }

  Future<List<dynamic>> loadEvents() async {
    final response = await eventService.getEvents();

    if (response is List) {
      return response;
    }

    return [];
  }
}