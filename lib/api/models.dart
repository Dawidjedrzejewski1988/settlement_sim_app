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
      productionPerHour:
          (json['productionPerHour'] as num?)?.toDouble() ?? 0.0,
      buildCostMoney:
          (json['buildCostMoney'] as num?)?.toDouble() ?? 0.0,
      maintenanceCost:
          (json['maintenanceCost'] as num?)?.toDouble() ?? 0.0,
      upgradeCostMoney:
          (json['upgradeCostMoney'] as num?)?.toDouble() ?? 0.0,
      maxWorkers: json['maxWorkers'] ?? 0,
      storageCapacity: json['storageCapacity'] ?? 0,
      housing: json['housing'] ?? 0,
      moraleBonus:
          (json['moraleBonus'] as num?)?.toDouble() ?? 0.0,
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
      productionPerHour:
          (json["productionPerHour"] as num?)?.toDouble() ?? 0.0,
      producedResource: json['producedResource'] != null
          ? Resource.fromJson(json['producedResource'])
          : null,
      input: (json['input'] as List<dynamic>? ?? [])
          .map((e) => Resource.fromJson(e))
          .toList(),
      storageCapacity: json["storageCapacity"] ?? 0,
      housing: json["housing"] ?? 0,
      moraleBonus:
          (json["moraleBonus"] as num?)?.toDouble() ?? 0.0,
      maintenanceCost:
          (json["maintenanceCost"] as num?)?.toDouble() ?? 0.0,
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

  final double moraleChangePerHour;
  final List<String> moraleBreakdown;
  final List<Industry> industries;

  final String? activeTaxPolicy;

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
  });

  factory Settlement.fromJson(Map<String, dynamic> json) {
    return Settlement(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString(),
      resources: (json['resources'] as List<dynamic>? ?? [])
          .map((e) => Resource.fromJson(e))
          .toList(),
      storageCapacity: json['storageCapacity'] ?? 0,
      storageUsed:
          (json['storageUsed'] as num?)?.toDouble() ?? 0.0,
      storageFree:
          (json['storageFree'] as num?)?.toDouble() ?? 0.0,
      population: json['population'] ?? 0,
      morale: (json['morale'] as num?)?.toDouble() ?? 0.0,
      money: (json['money'] as num?)?.toDouble() ?? 0.0,
      moraleChangePerHour:
          (json['moraleChangePerHour'] as num?)?.toDouble() ?? 0.0,
      moraleBreakdown:
          (json['moraleBreakdown'] as List<dynamic>? ?? [])
              .map((e) => e.toString())
              .toList(),
      industries: (json['industries'] as List<dynamic>? ?? [])
          .map((e) => Industry.fromJson(e))
          .toList(),
      activeTaxPolicy: json['activeTaxPolicy']?.toString(),
    );
  }
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

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['id']?.toString() ?? '',
      type: json['type']?.toString(),
      scope: json['scope']?.toString(),
      remainingSeconds: json['remainingSeconds'] ?? 0,
      isMine: json['isMine'] ?? false,
    );
  }
}

class Industry {
  final String type;
  final String? name;
  final int level;
  final double xp;
  final double nextLevelXP;
  final double progressPercent;

  Industry({
    required this.type,
    this.name,
    required this.level,
    required this.xp,
    required this.nextLevelXP,
    required this.progressPercent,
  });

  factory Industry.fromJson(Map<String, dynamic> json) {
    return Industry(
      type: json['type']?.toString() ?? '',
      name: json['name']?.toString(),
      level: json['level'] ?? 0,
      xp: (json['xp'] as num?)?.toDouble() ?? 0.0,
      nextLevelXP:
          (json['nextLevelXP'] as num?)?.toDouble() ?? 0.0,
      progressPercent:
          (json['progressPercent'] as num?)?.toDouble() ?? 0.0,
    );
  }
}

class GameMap {
  final int width;
  final int height;

  GameMap({
    required this.width,
    required this.height,
  });

  factory GameMap.fromJson(Map<String, dynamic> json) {
    return GameMap(
      width: json['width'] ?? 0,
      height: json['height'] ?? 0,
    );
  }
}

class MarketOffer {
  final String id;
  final String resourceType;
  final double remainingQuantity;
  final double minPricePerUnit;
  final double marketPrice;
  final double finalPrice;
  final String sellerSettlementId;

  MarketOffer({
    required this.id,
    required this.resourceType,
    required this.remainingQuantity,
    required this.minPricePerUnit,
    required this.marketPrice,
    required this.finalPrice,
    required this.sellerSettlementId,
  });

  factory MarketOffer.fromJson(Map<String, dynamic> json) {
    return MarketOffer(
      id: json['id']?.toString() ?? '',
      resourceType: json['resourceType']?.toString() ?? '',
      remainingQuantity:
          (json['remainingQuantity'] as num?)?.toDouble() ?? 0.0,
      minPricePerUnit:
          (json['minPricePerUnit'] as num?)?.toDouble() ?? 0.0,
      marketPrice:
          (json['marketPrice'] as num?)?.toDouble() ?? 0.0,
      finalPrice:
          (json['finalPrice'] as num?)?.toDouble() ?? 0.0,
      sellerSettlementId:
          json['sellerSettlementId']?.toString() ?? '',
    );
  }

    Map<String, dynamic> toJson() {
    return {
      "id": id,
      "resourceType": resourceType,
      "remainingQuantity": remainingQuantity,
      "minPricePerUnit": minPricePerUnit,
      "marketPrice": marketPrice,
      "finalPrice": finalPrice,
      "sellerSettlementId": sellerSettlementId,
    };
  }
}

class PolicyOption {
  final String id;
  final String label;

  PolicyOption({
    required this.id,
    required this.label,
  });

  factory PolicyOption.fromJson(Map<String, dynamic> json) {
    return PolicyOption(
      id: json['id']?.toString() ?? '',
      label: json['label']?.toString() ?? '',
    );
  }
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