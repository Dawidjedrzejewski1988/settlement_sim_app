import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import '../game/settlement_game.dart';
import '../api/services.dart';
import '../api/models.dart';

import '../widgets/top_hud.dart';
import '../widgets/build_panel.dart';
import '../widgets/building_side_panel.dart';
import '../widgets/build_confirm_dialog.dart';
import '../widgets/market_panel.dart';
import '../widgets/policy_panel.dart';
import '../widgets/industry_panel.dart';
import '../widgets/quest_panel.dart';
import '../widgets/ranking_panel.dart';
import '../widgets/event_panel.dart';
import '../widgets/economy_panel.dart';

import '../ui/ui_system.dart';

class GameScreen extends StatefulWidget {
  final String token;
  final String settlementId;

  const GameScreen({
    super.key,
    required this.token,
    required this.settlementId,
  });

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late SettlementGame game;
  Settlement? settlementData;
  final buildingService = BuildingService();
  final settlementService = SettlementService();
  final eventService = EventService();
  final marketService = MarketService();
  final policyService = PolicyService();
  final industryService = IndustryService();
  final questService = QuestService();
  final rankingService = RankingService();
  final Set<String> knownEvents = {};

  Timer? eventTimer;
  Timer? hudTimer;

  List<Event> events = [];
  List<AvailableBuilding> availableBuildings = [];
  List<MarketResource> marketResources = [];
  List<MarketHistoryEntry> marketHistory = [];
  List<Industry> industries = [];
  List<RankingEntry> ranking = [];

  Policy? taxPolicy;
  Policy? foodPolicy;
  Policy? workPolicy;
  String? selectedType;
  Building? selectedBuilding;
  QuestResponse? questData;
  Timer? refreshTimer;

  bool isRefreshing = false;
  bool showRanking = false;
  bool showQuests = false;
  bool showBuildPanel = false;
  bool showMarket = false;
  bool showPolicy = false;
  bool loading = false;
  bool offlineChecked = false;
  bool showIndustries = false;
  bool showEconomy = false;

  double woodPerSec = 0;
  double plankPerSec = 0;
  double berriesPerSec = 0;
  double stonePerSec = 0;
  double breadPerSec = 0;
  double moneyPerSec = 0;
  double resource(String code) {
    if (settlementData == null) return 0;

    try {
      return settlementData!.resources.firstWhere((r) => r.code == code).amount;
    } catch (_) {
      return 0;
    }
  }

  void closeAllPanels() {
    showBuildPanel = false;
    showMarket = false;
    showPolicy = false;
    showIndustries = false;
    showQuests = false;
    showRanking = false;
    showEconomy = false;
    selectedBuilding = null;
  }

  @override
  void initState() {
    super.initState();
    game = SettlementGame(
      token: widget.token,
      settlementId: widget.settlementId,
      onTileTap: openBuildMenu,
      onBuildingTap: openBuildingPanel,
    );

    loadAll();
    loadEvents();

    refreshTimer = Timer.periodic(
      const Duration(seconds: 5),
      (_) async {
        if (isRefreshing) return;

        isRefreshing = true;

        try {
          await loadAll();
        } finally {
          isRefreshing = false;
        }
      },
    );

    eventTimer = Timer.periodic(
      const Duration(seconds: 1),
      (_) => loadEvents(),
    );

    hudTimer = Timer.periodic(
      const Duration(seconds: 1),
      (_) => tickHud(),
    );
  }

  @override
  void dispose() {
    refreshTimer?.cancel();
    eventTimer?.cancel();
    hudTimer?.cancel();
    super.dispose();
  }

  void tickHud() {
    if (!mounted || settlementData == null) return;

    setState(() {
      settlementData = Settlement(
        id: settlementData!.id,
        name: settlementData!.name,
        resources: settlementData!.resources.map((r) {
          double add = 0;

          switch (r.code) {
            case "Wood":
              add = woodPerSec;
              break;

            case "Plank":
              add = plankPerSec;
              break;

            case "Berries":
              add = berriesPerSec;
              break;

            case "Stone":
              add = stonePerSec;
              break;

            case "Bread":
              add = breadPerSec;
              break;
          }

          return Resource(
            code: r.code,
            name: r.name,
            amount: r.amount + add,
          );
        }).toList(),
        storageCapacity: settlementData!.storageCapacity,
        storageUsed: settlementData!.storageUsed,
        storageFree: settlementData!.storageFree,
        population: settlementData!.population,
        morale: settlementData!.morale,
        money: settlementData!.money + moneyPerSec,
        moraleChangePerHour: settlementData!.moraleChangePerHour,
        moraleBreakdown: settlementData!.moraleBreakdown,
        industries: settlementData!.industries,
        activeTaxPolicy: settlementData!.activeTaxPolicy,
        activeFoodPolicy: settlementData!.activeFoodPolicy,
        activeWorkPolicy: settlementData!.activeWorkPolicy,
      );
    });
  }

  void calculateRates() {
    woodPerSec = 0;
    plankPerSec = 0;
    berriesPerSec = 0;
    stonePerSec = 0;
    breadPerSec = 0;
    moneyPerSec = 0;

    for (final b in game.buildingsData.cast<Building>()) {
      if (b.status != "Active") continue;

      final production = b.productionPerHour;
      final type = b.type;

      switch (type) {
        case "LumberCamp":
          woodPerSec += production / 3600;
          break;

        case "Sawmill":
          plankPerSec += production / 3600;
          break;

        case "GatherersCamp":
          berriesPerSec += production / 3600;
          break;

        case "Quarry":
          stonePerSec += production / 3600;
          break;

        case "Bakery":
          breadPerSec += production / 3600;
          break;
      }

      final maintenance = b.maintenanceCost;
      moneyPerSec -= maintenance / 3600;
    }
  }

  void showError(dynamic e) {
    String text = "Nieznany błąd";

    if (e is DioException) {
      final data = e.response?.data;

      if (data is Map && data["error"] != null) {
        text = data["error"].toString();
      } else if (data is String) {
        text = data;
      } else {
        text = e.message ?? text;
      }
    } else {
      text = e.toString();
    }

    debugPrint(e.toString());

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.red,
        content: Text(text),
      ),
    );
  }

  Future<void> loadAll() async {
    await loadSettlement();
    await loadAvailableBuildings();
    if (game.isLoaded) {
      await game.refreshBuildings();
    }
    calculateRates();
  }

  Future<void> loadSettlement() async {
    try {
      final settlement = await settlementService.getSettlement();

      if (!mounted) return;

      setState(() {
        settlementData = settlement;
      });
    } catch (_) {}
  }

  Future<void> loadAvailableBuildings() async {
    try {
      final data = await buildingService.getAvailableBuildings();

      if (!mounted) return;

      setState(() {
        availableBuildings = data;
      });
    } catch (_) {}
  }

  Future<void> loadEvents() async {
    try {
      final data = await eventService.getEvents();

      if (!mounted) return;

      for (final e in data) {
        if (!knownEvents.contains(e.id)) {
          knownEvents.add(e.id);

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: UiColors.gold,
              content: Text(
                "Nowe wydarzenie: ${e.type}",
              ),
            ),
          );
        }
      }

      setState(() {
        events = data;
      });
    } catch (_) {}
  }

  Future<void> loadMarket() async {
    try {
      final data = await marketService.getResources();

      if (!mounted) return;

      setState(() {
        marketResources = data;
      });
    } catch (e) {
      showError(e);
    }
  }

  Future<void> tradeMarket(
    String resourceType,
    double quantity,
    bool isBuy,
  ) async {
    try {
      if (isBuy) {
        await marketService.buy(
          resourceType: resourceType,
          quantity: quantity,
        );
      } else {
        await marketService.sell(
          resourceType: resourceType,
          quantity: quantity,
        );
      }

      await loadMarket();
      await loadMarketHistory();
      await loadAll();
    } catch (e) {
      showError(e);
    }
  }

  Future<void> loadMarketHistory() async {
    try {
      final data = await marketService.getHistory();

      if (!mounted) return;

      setState(() {
        marketHistory = data;
      });
    } catch (e) {
      showError(e);
    }
  }

  Future<void> loadRanking() async {
    try {
      final data = await rankingService.getRanking();

      if (!mounted) return;

      setState(() {
        ranking = data;
      });
    } catch (e) {
      showError(e);
    }
  }

  Future<void> loadQuests() async {
    try {
      final data = await questService.getQuests();

      if (!mounted) return;

      setState(() {
        questData = data;
      });
    } catch (e) {
      showError(e);
    }
  }

  Future<void> loadPolicy() async {
    try {
      final tax = await policyService.getTaxPolicy();

      final food = await policyService.getFoodPolicy();

      final work = await policyService.getWorkPolicy();

      if (!mounted) return;

      setState(() {
        taxPolicy = tax;
        foodPolicy = food;
        workPolicy = work;
      });
    } catch (e) {
      showError(e);
    }
  }

  Future<void> loadIndustries() async {
    try {
      final data = await industryService.getIndustries();

      if (!mounted) return;

      setState(() {
        industries = data;
      });
    } catch (e) {
      showError(e);
    }
  }

  Future<void> choosePolicy(
    String policyType,
    String optionId,
  ) async {
    try {
      switch (policyType) {
        case "tax":
          await policyService.chooseTaxPolicy(optionId);
          break;

        case "food":
          await policyService.chooseFoodPolicy(optionId);
          break;

        case "work":
          await policyService.chooseWorkPolicy(optionId);
          break;
      }

      await loadAll();
      await loadPolicy();
    } catch (e) {
      showError(e);
    }
  }

  AvailableBuilding? getBuildingData(String type) {
    try {
      return availableBuildings.firstWhere(
        (e) => e.type == type,
      );
    } catch (_) {
      return null;
    }
  }

  int getTimer() {
    if (selectedBuilding == null) return 0;

    for (final e in events) {
      if ((e.scope ?? "").contains(selectedBuilding!.id) &&
          e.remainingSeconds > 0) {
        return e.remainingSeconds;
      }
    }

    return 0;
  }

  void openBuildingPanel(Map data) {
    setState(() {
      selectedBuilding = Building.fromJson(
        Map<String, dynamic>.from(data),
      );
      showBuildPanel = false;
      showMarket = false;
      showPolicy = false;
    });
  }

  Future<void> openBuildMenu(
    int x,
    int y,
  ) async {
    if (selectedType == null) return;

    final data = getBuildingData(selectedType!);

    if (data == null) return;

    final ok = await showBuildConfirmDialog(
      context: context,
      data: {
        "type": data.type,
        "name": data.name,
        "cost": data.cost
            .map((e) => {
                  "code": e.code,
                  "amount": e.amount,
                })
            .toList(),
      },
      wood: resource("Wood"),
      stone: resource("Stone"),
      money: settlementData?.money ?? 0,
    );

    if (ok != true) return;

    try {
      setState(() {
        loading = true;
      });

      await buildingService.buildBuilding(
        type: selectedType!,
        tileX: x,
        tileY: y,
      );

      selectedType = null;

      await game.setSelectedBuildType(null);

      await loadAll();
    } catch (e) {
      showError(e);
    } finally {
      if (mounted) {
        setState(() {
          loading = false;
        });
      }
    }
  }

  Future<void> upgradeBuilding() async {
    if (selectedBuilding == null) return;

    try {
      setState(() {
        loading = true;
      });

      await buildingService.upgrade(
        selectedBuilding!.id,
      );

      selectedBuilding = null;

      await loadAll();
    } catch (e) {
      showError(e);
    } finally {
      if (mounted) {
        setState(() {
          loading = false;
        });
      }
    }
  }

  Future<void> deleteBuilding() async {
    if (selectedBuilding == null) return;

    try {
      setState(() {
        loading = true;
      });

      await buildingService.delete(
        selectedBuilding!.id,
      );

      selectedBuilding = null;

      await loadAll();
    } catch (e) {
      showError(e);
    } finally {
      if (mounted) {
        setState(() {
          loading = false;
        });
      }
    }
  }

  Future<void> setWorkers(int workers) async {
    if (selectedBuilding == null) return;

    try {
      await buildingService.updateWorkers(
        buildingId: selectedBuilding!.id,
        workers: workers,
      );

      await loadAll();
    } catch (e) {
      showError(e);
    }
  }

  void selectBuilding(String type) async {
    selectedType = type;

    setState(() {
      showBuildPanel = false;
      showMarket = false;
      showPolicy = false;
      selectedBuilding = null;
    });

    await game.setSelectedBuildType(type);
  }

  void cancelBuildMode() async {
    selectedType = null;

    await game.setSelectedBuildType(null);

    if (!mounted) return;

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: GameWidget(game: game),
          ),

          TopHud(
            wood: resource("Wood"),
            plank: resource("Plank"),
            berries: resource("Berries"),
            stone: resource("Stone"),
            bread: resource("Bread"),
            flour: resource("Flour"),
            wheat: resource("Wheat"),
            stoneTools: resource("StoneTools"),
            money: settlementData?.money ?? 0,
            morale: settlementData?.morale ?? 0,
            moralePerHour: settlementData?.moraleChangePerHour ?? 0,
            moraleBreakdown: settlementData?.moraleBreakdown ?? [],
            population: settlementData?.population ?? 0,
          ),

          Positioned(
            left: 18,
            top: 100,
            child: EventPanel(events: events),
          ),

          if (showBuildPanel)
            BuildPanel(
              buildings: availableBuildings,
              onSelect: selectBuilding,
            ),

          if (showMarket)
            MarketPanel(
              resources: marketResources,
              history: marketHistory,
              onClose: () {
                setState(() {
                  showMarket = false;
                });
              },
              onTrade: tradeMarket,
            ),

          if (showPolicy &&
              taxPolicy != null &&
              foodPolicy != null &&
              workPolicy != null)
            PolicyPanel(
              taxPolicy: taxPolicy!,
              foodPolicy: foodPolicy!,
              workPolicy: workPolicy!,
              activeTaxPolicy: settlementData?.activeTaxPolicy,
              activeFoodPolicy: settlementData?.activeFoodPolicy,
              activeWorkPolicy: settlementData?.activeWorkPolicy,
              onClose: () {
                setState(() {
                  showPolicy = false;
                });
              },
              onChoose: (
                policyType,
                optionId,
              ) async {
                await choosePolicy(
                  policyType,
                  optionId,
                );

                if (!mounted) return;

                setState(() {});
              },
            ),

          if (showIndustries)
            IndustryPanel(
              industries: industries,
              onClose: () {
                setState(() {
                  showIndustries = false;
                });
              },
            ),

          if (showQuests && questData != null)
            QuestPanel(
              quests: questData!,
              onClose: () {
                setState(() {
                  showQuests = false;
                });
              },
            ),

          if (showRanking)
            RankingPanel(
              ranking: ranking,
              onClose: () {
                setState(() {
                  showRanking = false;
                });
              },
            ),

          if (showEconomy && settlementData != null)
            EconomyPanel(
              settlement: settlementData!,
              woodPerSec: woodPerSec,
              plankPerSec: plankPerSec,
              berriesPerSec: berriesPerSec,
              stonePerSec: stonePerSec,
              breadPerSec: breadPerSec,
              moneyPerSec: moneyPerSec,
              onClose: () {
                setState(() {
                  showEconomy = false;
                });
              },
            ),

          if (selectedBuilding != null)
            BuildingSidePanel(
              building: selectedBuilding!,
              timer: getTimer(),
              onUpgrade: upgradeBuilding,
              onDelete: deleteBuilding,
              onSetWorkers: setWorkers,
              onClose: () {
                setState(() {
                  selectedBuilding = null;
                });
              },
            ),

          Positioned(
            right: 18,
            bottom: 18,
            child: Column(
              children: [
                if (selectedType != null)
                  SizedBox(
                    width: 180,
                    child: UiButton(
                      text: "Anuluj Budowę",
                      icon: Icons.close,
                      color: UiColors.red,
                      onTap: cancelBuildMode,
                    ),
                  ),

                if (selectedType != null) const SizedBox(height: 10),

                SizedBox(
                  width: 180,
                  child: UiButton(
                    text: showBuildPanel ? "Zamknij" : "Budowa",
                    icon: Icons.home_work,
                    color: UiColors.green,
                    onTap: () {
                      setState(() {
                        closeAllPanels();

                        showBuildPanel = !showBuildPanel;
                      });
                    },
                  ),
                ),

                const SizedBox(height: 10),

                SizedBox(
                  width: 180,
                  child: UiButton(
                    text: "Rynek",
                    icon: Icons.store,
                    color: UiColors.gold,
                    onTap: () async {
                      await loadMarket();
                      await loadMarketHistory();

                      if (!mounted) return;

                      setState(() {
                        closeAllPanels();

                        showMarket = true;
                      });
                    },
                  ),
                ),

                const SizedBox(height: 10),

                SizedBox(
                  width: 180,
                  child: UiButton(
                    text: "Polityka",
                    icon: Icons.account_balance,
                    color: UiColors.blue,
                    onTap: () async {
                      await loadPolicy();

                      if (!mounted) return;

                      setState(() {
                        closeAllPanels();

                        showPolicy = true;
                      });
                    },
                  ),
                ),

                const SizedBox(height: 10),

                SizedBox(
                  width: 180,
                  child: UiButton(
                    text: "Technologie",
                    icon: Icons.science,
                    color: UiColors.gold,
                    onTap: () async {
                      await loadIndustries();

                      if (!mounted) return;

                      setState(() {
                        closeAllPanels();

                        showIndustries = true;
                      });
                    },
                  ),
                ),

                const SizedBox(height: 10),

                SizedBox(
                  width: 180,
                  child: UiButton(
                    text: "Zadania",
                    icon: Icons.flag,
                    color: UiColors.green,
                    onTap: () async {
                      await loadQuests();

                      if (!mounted) return;

                      setState(() {
                        closeAllPanels();

                        showQuests = true;
                      });
                    },
                  ),
                ),

                const SizedBox(height: 10),

                SizedBox(
                  width: 180,
                  child: UiButton(
                    text: "Ranking",
                    icon: Icons.leaderboard,
                    color: UiColors.blue,
                    onTap: () async {
                      await loadRanking();

                      if (!mounted) return;

                      setState(() {
                        closeAllPanels();

                        showRanking = true;
                      });
                    },
                  ),
                ),

                const SizedBox(height: 10),

                SizedBox(
                  width: 180,
                  child: UiButton(
                    text: "Ekonomia",
                    icon: Icons.bar_chart,
                    color: UiColors.blue,
                    onTap: () {
                      setState(() {
                        closeAllPanels();

                        showEconomy = true;
                      });
                    },
                  ),
                ),
              ],
            ),
          ),

          if (loading)
            Positioned.fill(
              child: Container(
                color: Colors.black54,
                child: const Center(
                  child: CircularProgressIndicator(
                    color: UiColors.gold,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
