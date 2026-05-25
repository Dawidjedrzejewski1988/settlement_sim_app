enum BuildingType {
  lumberCamp,
  sawmill,
  gatherersCamp,
  quarry,
  workshop,
  farm,
  mill,
  bakery,
  cottage,
  house,
  warehouse,
  market,
  tavern;

  static BuildingType fromString(String value) {
    switch (value) {
      case "LumberCamp":
        return BuildingType.lumberCamp;
      case "Sawmill":
        return BuildingType.sawmill;
      case "GatherersCamp":
        return BuildingType.gatherersCamp;
      case "Quarry":
        return BuildingType.quarry;
      case "Workshop":
        return BuildingType.workshop;
      case "Farm":
        return BuildingType.farm;
      case "Mill":
        return BuildingType.mill;
      case "Bakery":
        return BuildingType.bakery;
      case "Cottage":
        return BuildingType.cottage;
      case "House":
        return BuildingType.house;
      case "Warehouse":
        return BuildingType.warehouse;
      case "Market":
        return BuildingType.market;
      case "Tavern":
        return BuildingType.tavern;
      default:
        throw Exception("Unknown BuildingType: $value");
    }
  }

  String toApi() {
    switch (this) {
      case BuildingType.lumberCamp:
        return "LumberCamp";
      case BuildingType.sawmill:
        return "Sawmill";
      case BuildingType.gatherersCamp:
        return "GatherersCamp";
      case BuildingType.quarry:
        return "Quarry";
      case BuildingType.workshop:
        return "Workshop";
      case BuildingType.farm:
        return "Farm";
      case BuildingType.mill:
        return "Mill";
      case BuildingType.bakery:
        return "Bakery";
      case BuildingType.cottage:
        return "Cottage";
      case BuildingType.house:
        return "House";
      case BuildingType.warehouse:
        return "Warehouse";
      case BuildingType.market:
        return "Market";
      case BuildingType.tavern:
        return "Tavern";
    }
  }
}

enum BuildingStatus {
  active,
  constructing,
  upgrading;

  static BuildingStatus fromString(String value) {
    switch (value) {
      case "Active":
        return BuildingStatus.active;
      case "Constructing":
        return BuildingStatus.constructing;
      case "Upgrading":
        return BuildingStatus.upgrading;
      default:
        throw Exception("Unknown status: $value");
    }
  }

  String toApi() {
    switch (this) {
      case BuildingStatus.active:
        return "Active";
      case BuildingStatus.constructing:
        return "Constructing";
      case BuildingStatus.upgrading:
        return "Upgrading";
    }
  }
}

enum ResourceType {
  wood,
  plank,
  berries,
  stone,
  stoneTools,
  wheat,
  flour,
  bread;
}

enum SessionStatus {
  running,
  finished;

  static SessionStatus fromString(String value) {
    switch (value) {
      case "Running":
        return SessionStatus.running;
      case "Finished":
        return SessionStatus.finished;
      default:
        throw Exception("Unknown session status: $value");
    }
  }
}

class AuthResponse {
  final String accessToken;
  final int? userId;

  AuthResponse({
    required this.accessToken,
    this.userId,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      accessToken: (json['accessToken'] ?? '').toString(),
      userId: (json['userId'] as num?)?.toInt(),
    );
  }
}

class Resource {
  final String code;
  final String? name;
  final double amount;

  Resource({
    required this.code,
    this.name,
    required this.amount,
  });

  factory Resource.fromJson(Map<String, dynamic> json) {
    return Resource(
      code: json['code']?.toString() ?? '',
      name: json['name']?.toString(),
      amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "code": code,
      "name": name,
      "amount": amount,
    };
  }
}

class AvailableBuilding {
  final String type;
  final String name;
  final int tier;
  final bool canBuild;
  final String? reason;

  final List<Resource> cost;
  final List<Resource> input;
  final Resource? producedResource;

  final double productionPerHour;

  final double buildCostMoney;
  final double maintenanceCost;
  final double upgradeCostMoney;

  final int maxWorkers;
  final int storageCapacity;
  final int housing;
  final double moraleBonus;

  AvailableBuilding({
    required this.type,
    required this.name,
    required this.tier,
    required this.canBuild,
    required this.reason,
    required this.cost,
    required this.input,
    required this.producedResource,
    required this.productionPerHour,
    required this.buildCostMoney,
    required this.maintenanceCost,
    required this.upgradeCostMoney,
    required this.maxWorkers,
    required this.storageCapacity,
    required this.housing,
    required this.moraleBonus,
  });

  factory AvailableBuilding.fromJson(Map<String, dynamic> json) {
    return AvailableBuilding(
      type: json["type"] as String,
      name: json['name'] as String,
      tier: json['tier'] ?? 0,
      canBuild: json['canBuild'] ?? false,
      reason: json['reason']?.toString(),
      cost: (json['cost'] as List<dynamic>? ?? [])
          .map((e) => Resource.fromJson(e))
          .toList(),
      input: (json['input'] as List<dynamic>? ?? [])
          .map((e) => Resource.fromJson(e))
          .toList(),
      producedResource: json['producedResource'] != null
          ? Resource.fromJson(json['producedResource'])
          : null,
      productionPerHour: (json['productionPerHour'] as num?)?.toDouble() ?? 0.0,
      buildCostMoney: (json['buildCostMoney'] as num?)?.toDouble() ?? 0.0,
      maintenanceCost: (json['maintenanceCost'] as num?)?.toDouble() ?? 0.0,
      upgradeCostMoney: (json['upgradeCostMoney'] as num?)?.toDouble() ?? 0.0,
      maxWorkers: json['maxWorkers'] ?? 0,
      storageCapacity: json['storageCapacity'] ?? 0,
      housing: json['housing'] ?? 0,
      moraleBonus: (json['moraleBonus'] as num?)?.toDouble() ?? 0.0,
    );
  }
}

class Building {
  final String id;
  final String type;
  final String? name;

  final int workers;
  final String status;
  final int maxWorkers;

  final double productionPerHour;

  final Resource? producedResource;
  final List<Resource> input;

  final int storageCapacity;
  final int housing;
  final double moraleBonus;
  final double maintenanceCost;
  final double usedStorage;
  final double freeStorage;
  final int currentResidents;
  final double taxIncome;

  final int tileX;
  final int tileY;

  Building({
    required this.id,
    required this.type,
    required this.name,
    required this.workers,
    required this.status,
    required this.maxWorkers,
    required this.productionPerHour,
    required this.producedResource,
    required this.input,
    required this.storageCapacity,
    required this.housing,
    required this.moraleBonus,
    required this.maintenanceCost,
    required this.usedStorage,
    required this.freeStorage,
    required this.currentResidents,
    required this.taxIncome,
    required this.tileX,
    required this.tileY,
  });

  factory Building.fromJson(Map<String, dynamic> json) {
    return Building(
      id: json["id"].toString(),
      type: json["type"].toString(),
      name: json["name"],
      workers: json["workers"] ?? 0,
      status: json["status"] ?? "",
      maxWorkers: json["maxWorkers"] ?? 0,
      productionPerHour: (json["productionPerHour"] as num?)?.toDouble() ?? 0.0,
      producedResource: json['producedResource'] != null
          ? Resource.fromJson(json['producedResource'])
          : null,
      input: (json['input'] as List<dynamic>? ?? [])
          .map((e) => Resource.fromJson(e))
          .toList(),
      storageCapacity: json["storageCapacity"] ?? 0,
      housing: json["housing"] ?? 0,
      moraleBonus: (json["moraleBonus"] as num?)?.toDouble() ?? 0.0,
      maintenanceCost: (json["maintenanceCost"] as num?)?.toDouble() ?? 0.0,
      usedStorage: (json["usedStorage"] as num?)?.toDouble() ?? 0,
      freeStorage: (json["freeStorage"] as num?)?.toDouble() ?? 0,
      currentResidents: json["currentResidents"] ?? 0,
      taxIncome: (json["taxIncome"] as num?)?.toDouble() ?? 0,
      tileX: json["tileX"] ?? 0,
      tileY: json["tileY"] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "type": type,
      "name": name,
      "workers": workers,
      "status": status,
      "maxWorkers": maxWorkers,
      "productionPerHour": productionPerHour,
      "producedResource": producedResource?.toJson(),
      "input": input.map((e) => e.toJson()).toList(),
      "storageCapacity": storageCapacity,
      "housing": housing,
      "usedStorage": usedStorage,
      "freeStorage": freeStorage,
      "currentResidents": currentResidents,
      "taxIncome": taxIncome,
      "moraleBonus": moraleBonus,
      "maintenanceCost": maintenanceCost,
      "tileX": tileX,
      "tileY": tileY,
    };
  }
}

class Session {
  final String id;
  final String? name;
  final int playerCount;
  final DateTime? createdAt;
  final String? status;

  Session({
    required this.id,
    required this.name,
    required this.playerCount,
    required this.createdAt,
    required this.status,
  });

  factory Session.fromJson(Map<String, dynamic> json) {
    return Session(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString(),
      playerCount: (json['playerCount'] as num?)?.toInt() ?? 0,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'].toString())
          : null,
      status: json['status']?.toString(),
    );
  }
}

class SessionJoinResponse {
  final String settlementId;
  final String? accessToken;

  SessionJoinResponse({
    required this.settlementId,
    this.accessToken,
  });

  factory SessionJoinResponse.fromJson(Map<String, dynamic> json) {
    return SessionJoinResponse(
      settlementId: json['settlementId']?.toString() ?? "",
      accessToken: json['accessToken']?.toString(),
    );
  }
}

class Settlement {
  final String id;

  final String? name;

  final List<Resource> resources;

  final int storageCapacity;

  final double storageUsed;
  final double storageFree;

  final int population;

  final double morale;
  final double money;
  final double lastNetIncome;
  final double lastTaxPerPerson;
  final double moraleChangePerHour;

  final List<String> moraleBreakdown;

  final List<Industry> industries;

  final String? activeTaxPolicy;
  final String? activeFoodPolicy;
  final String? activeWorkPolicy;

  final double foodConsumptionPerHour;
  final double woodConsumptionPerHour;
  final double foodSatisfaction;
  final bool hasWoodShortage;
  final bool showWelcome;

  Settlement({
    required this.id,
    required this.name,
    required this.resources,
    required this.storageCapacity,
    required this.storageUsed,
    required this.storageFree,
    required this.population,
    required this.morale,
    required this.money,
    required this.moraleChangePerHour,
    required this.moraleBreakdown,
    required this.industries,
    required this.activeTaxPolicy,
    required this.activeFoodPolicy,
    required this.activeWorkPolicy,
    required this.foodConsumptionPerHour,
    required this.woodConsumptionPerHour,
    required this.foodSatisfaction,
    required this.hasWoodShortage,
    required this.lastNetIncome,
    required this.lastTaxPerPerson,
    required this.showWelcome,
  });

  factory Settlement.fromJson(
    Map<String, dynamic> json,
  ) =>
      Settlement(
        id: json["id"]?.toString() ?? "",
        name: json["name"]?.toString(),
        resources: (json["resources"] as List<dynamic>? ?? [])
            .map((e) => Resource.fromJson(e))
            .toList(),
        storageCapacity: json["storageCapacity"] ?? 0,
        storageUsed: (json["storageUsed"] as num?)?.toDouble() ?? 0,
        storageFree: (json["storageFree"] as num?)?.toDouble() ?? 0,
        population: json["population"] ?? 0,
        morale: (json["morale"] as num?)?.toDouble() ?? 0,
        money: (json["money"] as num?)?.toDouble() ?? 0,
        lastNetIncome: (json["lastNetIncome"] as num?)?.toDouble() ?? 0,
        lastTaxPerPerson: (json["lastTaxPerPerson"] as num?)?.toDouble() ?? 0,
        moraleChangePerHour:
            (json["moraleChangePerHour"] as num?)?.toDouble() ?? 0,
        moraleBreakdown: (json["moraleBreakdown"] as List<dynamic>? ?? [])
            .map((e) => e.toString())
            .toList(),
        industries: (json["industries"] as List<dynamic>? ?? [])
            .map((e) => Industry.fromJson(e))
            .toList(),
        activeTaxPolicy: json["activeTaxPolicy"]?.toString(),
        activeFoodPolicy: json["activeFoodPolicy"]?.toString(),
        activeWorkPolicy: json["activeWorkPolicy"]?.toString(),
        foodConsumptionPerHour:
            (json["foodConsumptionPerHour"] as num?)?.toDouble() ?? 0,
        woodConsumptionPerHour:
            (json["woodConsumptionPerHour"] as num?)?.toDouble() ?? 0,
        foodSatisfaction: (json["foodSatisfaction"] as num?)?.toDouble() ?? 0,
        hasWoodShortage: json["hasWoodShortage"] ?? false,
        showWelcome: json["showWelcome"] ?? false,
      );
}

class BuildingDefinition {
  final String type;

  final String name;

  final String assetPath;

  const BuildingDefinition({
    required this.type,
    required this.name,
    required this.assetPath,
  });
}

class Event {
  final String id;

  final String? type;
  final String? scope;

  final int remainingSeconds;

  final bool isMine;

  Event({
    required this.id,
    this.type,
    this.scope,
    required this.remainingSeconds,
    required this.isMine,
  });

  factory Event.fromJson(
    Map<String, dynamic> json,
  ) =>
      Event(
        id: json["id"]?.toString() ?? "",
        type: json["type"]?.toString(),
        scope: json["scope"]?.toString(),
        remainingSeconds: json["remainingSeconds"] ?? 0,
        isMine: json["isMine"] ?? false,
      );
}

class IndustryReward {
  final int level;

  final String title;
  final String description;

  final bool unlocked;

  IndustryReward({
    required this.level,
    required this.title,
    required this.description,
    required this.unlocked,
  });

  factory IndustryReward.fromJson(
    Map<String, dynamic> json,
  ) =>
      IndustryReward(
        level: json["level"] ?? 0,
        title: json["title"]?.toString() ?? "",
        description: json["description"]?.toString() ?? "",
        unlocked: json["unlocked"] ?? false,
      );
}

class Industry {
  final String type;

  final String? name;
  final String? description;

  final int level;

  final double xp;
  final double nextLevelXP;
  final double progressPercent;

  final List<IndustryReward> rewards;

  Industry({
    required this.type,
    this.name,
    this.description,
    required this.level,
    required this.xp,
    required this.nextLevelXP,
    required this.progressPercent,
    required this.rewards,
  });

  factory Industry.fromJson(
    Map<String, dynamic> json,
  ) =>
      Industry(
        type: json["type"]?.toString() ?? "",
        name: json["name"]?.toString(),
        description: json["description"]?.toString(),
        level: json["level"] ?? 0,
        xp: (json["xp"] as num?)?.toDouble() ?? 0,
        nextLevelXP: (json["nextLevelXP"] as num?)?.toDouble() ?? 0,
        progressPercent: (json["progressPercent"] as num?)?.toDouble() ?? 0,
        rewards: (json["rewards"] as List<dynamic>? ?? [])
            .map((e) => IndustryReward.fromJson(e))
            .toList(),
      );
}

class GameMap {
  final int width;

  final int height;

  GameMap({
    required this.width,
    required this.height,
  });

  factory GameMap.fromJson(
    Map<String, dynamic> json,
  ) =>
      GameMap(
        width: json["width"] ?? 0,
        height: json["height"] ?? 0,
      );
}

class MarketResource {
  final String resourceType;

  final double quantity;
  final double currentPrice;
  final double buyPrice;
  final double sellPrice;

  MarketResource({
    required this.resourceType,
    required this.quantity,
    required this.currentPrice,
    required this.buyPrice,
    required this.sellPrice,
  });

  factory MarketResource.fromJson(
    Map<String, dynamic> json,
  ) =>
      MarketResource(
        resourceType: json["resourceType"]?.toString() ?? "",
        quantity: (json["quantity"] as num?)?.toDouble() ?? 0,
        currentPrice: (json["currentPrice"] as num?)?.toDouble() ?? 0,
        buyPrice: (json["buyPrice"] as num?)?.toDouble() ?? 0,
        sellPrice: (json["sellPrice"] as num?)?.toDouble() ?? 0,
      );
}

class MarketTransport {
  final String id;

  final String resourceType;

  final double quantity;

  final DateTime? arrivalTime;

  final int remainingSeconds;

  MarketTransport({
    required this.id,
    required this.resourceType,
    required this.quantity,
    required this.arrivalTime,
    required this.remainingSeconds,
  });

  factory MarketTransport.fromJson(
    Map<String, dynamic> json,
  ) =>
      MarketTransport(
        id: json["id"]?.toString() ?? "",
        resourceType: json["resourceType"]?.toString() ?? "",
        quantity: (json["quantity"] as num?)?.toDouble() ?? 0,
        arrivalTime: json["arrivalTime"] != null
            ? DateTime.tryParse(json["arrivalTime"].toString())
            : null,
        remainingSeconds: json["remainingSeconds"] ?? 0,
      );
}

class PolicyEffect {
  final String type;

  final double value;

  PolicyEffect({
    required this.type,
    required this.value,
  });

  factory PolicyEffect.fromJson(
    Map<String, dynamic> json,
  ) =>
      PolicyEffect(
        type: json["type"]?.toString() ?? "",
        value: (json["value"] as num?)?.toDouble() ?? 0,
      );
}

class PolicyOption {
  final String id;

  final String label;

  final List<PolicyEffect> effects;

  PolicyOption({
    required this.id,
    required this.label,
    required this.effects,
  });

  factory PolicyOption.fromJson(
    Map<String, dynamic> json,
  ) =>
      PolicyOption(
        id: json["id"]?.toString() ?? "",
        label: json["label"]?.toString() ?? "",
        effects: (json["effects"] as List<dynamic>? ?? [])
            .map((e) => PolicyEffect.fromJson(e))
            .toList(),
      );
}

class Policy {
  final String? id;
  final String? title;
  final String? description;
  final List<PolicyOption> options;

  Policy({
    this.id,
    this.title,
    this.description,
    required this.options,
  });

  factory Policy.fromJson(Map<String, dynamic> json) {
    return Policy(
      id: json['id']?.toString(),
      title: json['title']?.toString(),
      description: json['description']?.toString(),
      options: (json['options'] as List<dynamic>? ?? [])
          .map((e) => PolicyOption.fromJson(e))
          .toList(),
    );
  }
}

class Quest {
  final String id;
  final String description;
  final bool isCompleted;
  final int stage;

  Quest({
    required this.id,
    required this.description,
    required this.isCompleted,
    required this.stage,
  });

  factory Quest.fromJson(Map<String, dynamic> json) => Quest(
        id: json["id"]?.toString() ?? "",
        description: json["description"]?.toString() ?? "",
        isCompleted: json["isCompleted"] ?? false,
        stage: json["stage"] ?? 0,
      );
}

class QuestResponse {
  final List<Quest> active;
  final List<Quest> completed;

  QuestResponse({
    required this.active,
    required this.completed,
  });

  factory QuestResponse.fromJson(Map<String, dynamic> json) => QuestResponse(
        active: (json["active"] as List<dynamic>? ?? [])
            .map((e) => Quest.fromJson(e))
            .toList(),
        completed: (json["completed"] as List<dynamic>? ?? [])
            .map((e) => Quest.fromJson(e))
            .toList(),
      );
}

class RankingEntry {
  final String settlementId;
  final String username;

  final int population;

  final double money;
  final double morale;
  final double score;

  RankingEntry({
    required this.settlementId,
    required this.username,
    required this.population,
    required this.money,
    required this.morale,
    required this.score,
  });

  factory RankingEntry.fromJson(Map<String, dynamic> json) => RankingEntry(
        settlementId: json["settlementId"]?.toString() ?? "",
        username: json["username"]?.toString() ?? "",
        population: json["population"] ?? 0,
        money: (json["money"] as num?)?.toDouble() ?? 0.0,
        morale: (json["morale"] as num?)?.toDouble() ?? 0.0,
        score: (json["score"] as num?)?.toDouble() ?? 0.0,
      );
}

class MarketHistoryEntry {
  final String id;

  final String resourceType;

  final double quantity;
  final double pricePerUnit;
  final double totalPrice;
  final double commission;

  final DateTime? executedAt;

  MarketHistoryEntry({
    required this.id,
    required this.resourceType,
    required this.quantity,
    required this.pricePerUnit,
    required this.totalPrice,
    required this.commission,
    required this.executedAt,
  });

  factory MarketHistoryEntry.fromJson(
    Map<String, dynamic> json,
  ) =>
      MarketHistoryEntry(
        id: json["id"]?.toString() ?? "",
        resourceType: json["resourceType"]?.toString() ?? "",
        quantity: (json["quantity"] as num?)?.toDouble() ?? 0.0,
        pricePerUnit: (json["pricePerUnit"] as num?)?.toDouble() ?? 0.0,
        totalPrice: (json["totalPrice"] as num?)?.toDouble() ?? 0.0,
        commission: (json["commission"] as num?)?.toDouble() ?? 0.0,
        executedAt: json["executedAt"] != null
            ? DateTime.tryParse(json["executedAt"].toString())
            : null,
      );
}
