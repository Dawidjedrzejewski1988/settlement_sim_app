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

  Future<Map<String, dynamic>> loadSettlement(
    String token,
  ) async {
    final response = await settlementService.getSettlement(
      token,
    );

    final result = <String, dynamic>{};

    GameLoader.loadResources(
      data: response.data,
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

  Future<List<dynamic>> loadBuildings(
    String token,
  ) async {
    final response = await buildingService.getAvailableBuildings(
      token,
    );

    return response.data;
  }

  Future<List<dynamic>> loadEvents(
    String token,
  ) async {
    final response = await eventService.getEvents(
      token,
    );

    if (response.data is List) {
      return response.data;
    }

    return [];
  }
}
