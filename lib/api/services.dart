import './api_client.dart';
import './models.dart';

class AuthService {
  final api = ApiClient();

  Future<void> login(String email, String password) async {
    final res = await api.dio.post("/api/auth/login", data: {
      "email": email,
      "password": password,
    });

    final token = res.data["accessToken"];

    if (token != null) {
      await api.storage.write(key: "token", value: token);
    }
  }

  Future<void> register(String username, String email, String password) async {
    await api.dio.post("/api/auth/register", data: {
      "username": username,
      "email": email,
      "password": password,
    });
  }
}

class BuildingService {
  final dio = ApiClient().dio;

  Future<List<Building>> getBuildings() async {
    final res = await dio.get("/api/buildings");
    return (res.data as List).map((e) => Building.fromJson(e)).toList();
  }

  Future<List<AvailableBuilding>> getAvailableBuildings() async {
    final res = await dio.get("/api/buildings/available");
    return (res.data as List)
        .map((e) => AvailableBuilding.fromJson(e))
        .toList();
  }

  Future<void> buildBuilding({
    required String type,
    required int tileX,
    required int tileY,
  }) async {
    await dio.post("/api/buildings", data: {
      "type": type,
      "tileX": tileX,
      "tileY": tileY,
    });
  }

  Future<void> updateWorkers({
    required String buildingId,
    required int workers,
  }) async {
    await dio.patch("/api/buildings/$buildingId/workers", data: workers);
  }

  Future<void> upgrade(String buildingId) async {
    await dio.patch("/api/buildings/$buildingId/upgrade");
  }

  Future<void> delete(String buildingId) async {
    await dio.delete("/api/buildings/$buildingId");
  }
}

class EventService {
  final dio = ApiClient().dio;

  Future<List<Event>> getEvents() async {
    final res = await dio.get("/api/events");
    return (res.data as List).map((e) => Event.fromJson(e)).toList();
  }
}

class IndustryService {
  final dio = ApiClient().dio;

  Future<List<Industry>> getIndustries() async {
    final res = await dio.get("/api/industries");
    return (res.data as List).map((e) => Industry.fromJson(e)).toList();
  }
}

class MapService {
  final dio = ApiClient().dio;

  Future<GameMap> getMap() async {
    final res = await dio.get("/api/map");
    return GameMap.fromJson(res.data);
  }
}

class MarketService {
  final dio = ApiClient().dio;

  Future<List<MarketResource>> getResources() async {
    final res = await dio.get("/api/market/resources");
    return (res.data as List).map((e) => MarketResource.fromJson(e)).toList();
  }

  Future<void> buy({
    required String resourceType,
    required double quantity,
  }) async {
    await dio.post("/api/market/buy", data: {
      "resourceType": resourceType,
      "quantity": quantity,
    });
  }

  Future<void> sell({
    required String resourceType,
    required double quantity,
  }) async {
    await dio.post("/api/market/sell", data: {
      "resourceType": resourceType,
      "quantity": quantity,
    });
  }

  Future<List<MarketHistoryEntry>> getHistory() async {
    final res = await dio.get("/api/market/history");
    return (res.data as List)
        .map((e) => MarketHistoryEntry.fromJson(e))
        .toList();
  }

  Future<List<MarketTransport>> getTransports() async {
    final res = await dio.get("/api/market/transports");
    return (res.data as List).map((e) => MarketTransport.fromJson(e)).toList();
  }
}

class PolicyService {
  final dio = ApiClient().dio;

  Future<Policy> getTaxPolicy() async {
    final res = await dio.get("/api/policy/tax");
    return Policy.fromJson(res.data);
  }

  Future<void> chooseTaxPolicy(String optionId) async {
    await dio.post("/api/policy/tax", data: {
      "optionId": optionId,
    });
  }

  Future<Policy> getFoodPolicy() async {
    final res = await dio.get("/api/policy/food");
    return Policy.fromJson(res.data);
  }

  Future<void> chooseFoodPolicy(String optionId) async {
    await dio.post("/api/policy/food", data: {
      "optionId": optionId,
    });
  }

  Future<Policy> getWorkPolicy() async {
    final res = await dio.get("/api/policy/work");
    return Policy.fromJson(res.data);
  }

  Future<void> chooseWorkPolicy(String optionId) async {
    await dio.post("/api/policy/work", data: {
      "optionId": optionId,
    });
  }
}

class SessionService {
  final api = ApiClient();

  Future<List<Session>> getSessions() async {
    final res = await api.dio.get("/api/sessions");
    return (res.data as List).map((e) => Session.fromJson(e)).toList();
  }

  Future<SessionJoinResponse> joinSession(String id) async {
    final res = await api.dio.post("/api/sessions/$id/join");

    final data = SessionJoinResponse.fromJson(res.data);

    if (data.accessToken != null) {
      await api.storage.write(key: "token", value: data.accessToken);
    }

    return data;
  }

  Future<Session> getSession(String id) async {
    final res = await api.dio.get("/api/sessions/$id");
    return Session.fromJson(res.data);
  }

  Future<Session> createSession(String name) async {
    final res = await api.dio.post("/api/sessions", data: {
      "name": name,
    });

    return Session.fromJson(res.data);
  }

  Future<void> deleteSession(String id) async {
    await api.dio.delete("/api/sessions/$id");
  }
}

class SettlementService {
  final dio = ApiClient().dio;

  Future<Settlement> getSettlement() async {
    final res = await dio.get("/api/settlement");
    return Settlement.fromJson(res.data);
  }
}

class QuestService {
  final dio = ApiClient().dio;

  Future<QuestResponse> getQuests() async {
    final res = await dio.get("/api/quests");
    return QuestResponse.fromJson(res.data);
  }
}

class RankingService {
  final dio = ApiClient().dio;

  Future<List<RankingEntry>> getRanking() async {
    final res = await dio.get("/api/ranking");
    return (res.data as List).map((e) => RankingEntry.fromJson(e)).toList();
  }
}
