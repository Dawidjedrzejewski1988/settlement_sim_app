import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flame/game.dart';

import '../game/settlement_game.dart';

import '../api/services.dart';
import '../api/models.dart';

import '../logic/game_loader.dart';
import '../logic/building_actions.dart';

import '../controllers/game_data_controller.dart';
import '../controllers/live_refresh_controller.dart';

import '../widgets/top_hud.dart';
import '../widgets/build_panel.dart';
import '../widgets/building_side_panel.dart';
import '../widgets/build_confirm_dialog.dart';
import '../widgets/market_panel.dart';
import '../widgets/create_offer_dialog.dart';
import '../widgets/policy_panel.dart';

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

  final buildingService = BuildingService();
  final settlementService = SettlementService();
  final eventService = EventService();
  final marketService = MarketService();
  final policyService = PolicyService();

  late GameDataController dataController;
  late BuildingActions actions;

  final liveRefresh = LiveRefreshController();

  Timer? eventTimer;
  Timer? hudTimer;

  List<Event> events = [];
  List<AvailableBuilding> availableBuildings = [];
  List<MarketOffer> marketOffers = [];

  Policy? policyData;

  String? selectedType;
  Building? selectedBuilding;

  bool showBuildPanel = false;
  bool showMarket = false;
  bool showPolicy = false;
  bool loading = false;
  bool offlineChecked = false;

  double wood = 0;
  double plank = 0;
  double berries = 0;
  double stone = 0;
  double bread = 0;

  double money = 0;
  double morale = 0;

  int population = 0;

  double woodPerSec = 0;
  double plankPerSec = 0;
  double berriesPerSec = 0;
  double stonePerSec = 0;
  double breadPerSec = 0;
  double moneyPerSec = 0;

  @override
  void initState() {
    super.initState();

    dataController = GameDataController(
      settlementService: settlementService,
      buildingService: buildingService,
      eventService: eventService,
    );

    actions = BuildingActions(buildingService);

    game = SettlementGame(
      token: widget.token,
      settlementId: widget.settlementId,
      onTileTap: openBuildMenu,
      onBuildingTap: openBuildingPanel,
    );

    loadAll();
    loadEvents();

    liveRefresh.start(
      onRefresh: () async {
        await loadAll();
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
    liveRefresh.stop();
    eventTimer?.cancel();
    hudTimer?.cancel();
    super.dispose();
  }

  void tickHud() {
    if (!mounted) return;

    setState(() {
      wood += woodPerSec;
      plank += plankPerSec;
      berries += berriesPerSec;
      stone += stonePerSec;
      bread += breadPerSec;
      money += moneyPerSec;
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
      text = e.response != null
          ? "Błąd ${e.response?.statusCode}"
          : (e.message ?? text);
    }

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
    await game.refreshBuildings();
    calculateRates();
  }

  Future<void> loadSettlement() async {
    try {
      final data = await dataController.loadSettlement();

      if (!mounted) return;

      setState(() {
        wood = data["wood"];
        plank = data["plank"];
        berries = data["berries"];
        stone = data["stone"];
        bread = data["bread"];
        money = data["money"];
        morale = data["morale"];
        population = data["population"];
      });
    } catch (_) {}
  }

  Future<void> loadAvailableBuildings() async {
    try {
      final data = await dataController.loadBuildings();

      if (!mounted) return;

      setState(() {
        availableBuildings = data;
      });
    } catch (_) {}
  }

  Future<void> loadEvents() async {
    try {
      final data = await dataController.loadEvents();

      if (!mounted) return;

      setState(() {
        events = data;
      });
    } catch (_) {}
  }

  Future<void> loadMarket() async {
    try {
      final data = await marketService.getOffers();

      if (!mounted) return;

    setState(() {
      marketOffers = data;
    });
    } catch (e) {
      showError(e);
    }
  }

  Future<void> buyMarket(String id) async {
    try {
    await marketService.buyOffer(
      offerId: id,
      quantity: 1,
    );

      await loadMarket();
      await loadAll();
    } catch (e) {
      showError(e);
    }
  }

  Future<void> createOffer() async {
    final data = await showCreateOfferDialog(
      context: context,
    );

    if (data == null) return;

    try {
      await marketService.createOffer(
        settlementId: widget.settlementId,
        resourceType: data["resourceType"],
        quantity: data["quantity"],
        pricePerUnit: data["pricePerUnit"],
      );

      await loadMarket();
      await loadAll();
    } catch (e) {
      showError(e);
    }
  }

  Future<void> loadPolicy() async {
    try {
      final data = await policyService.getTaxPolicy();

      if (!mounted) return;

      setState(() {
        policyData = data;
      });
    } catch (e) {
      showError(e);
    }
  }

  Future<void> choosePolicy(String optionId) async {
    try {
      await policyService.chooseTaxPolicy(optionId);

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
    return GameLoader.getTimer(
      building: selectedBuilding,
      events: events,
    );
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
      wood: wood,
      stone: stone,
      money: money,
    );

    if (ok != true) return;

    try {
      setState(() {
        loading = true;
      });

      await actions.build(
        type: selectedType!,
        x: x,
        y: y,
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

      actions.upgrade(
        id: selectedBuilding!.id,
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

      actions.delete(
        id: selectedBuilding!.id,
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
      actions.workers(
        id: selectedBuilding!.id,
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
            wood: wood,
            plank: plank,
            berries: berries,
            stone: stone,
            bread: bread,
            money: money,
            morale: morale,
            population: population,
          ),
          if (showBuildPanel)
            BuildPanel(
              buildings: availableBuildings,
              onSelect: selectBuilding,
            ),
          if (showMarket)
            MarketPanel(
              offers: marketOffers,
              onClose: () {
                setState(() {
                  showMarket = false;
                });
              },
              onBuy: buyMarket,
              onCreate: createOffer,
            ),
          if (showPolicy && policyData != null)
            PolicyPanel(
              policy: {
                "id": policyData!.id,
                "title": policyData!.title,
                "description": policyData!.description,
                "options": policyData!.options
                    .map((e) => {
                          "id": e.id,
                          "label": e.label,
                        })
                    .toList(),
              },
              onClose: () {
                setState(() {
                  showPolicy = false;
                });
              },
              onChoose: choosePolicy,
            ),
          if (selectedBuilding != null)
            BuildingSidePanel(
              building: {
                "id": selectedBuilding!.id,
                "type": selectedBuilding!.type,
                "workers": selectedBuilding!.workers,
                "status": selectedBuilding!.status,
                "maxWorkers": selectedBuilding!.maxWorkers,
              },
              timer: getTimer(),
              onUpgrade: upgradeBuilding,
              onDelete: deleteBuilding,
              onClose: () {
                setState(() {
                  selectedBuilding = null;
                });
              },
              onSetWorkers: setWorkers,
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
                    text: showBuildPanel ? "Zamknij Menu" : "Budowa",
                    icon: Icons.home_work,
                    color: UiColors.green,
                    onTap: () {
                      setState(() {
                        showBuildPanel = !showBuildPanel;
                        showMarket = false;
                        showPolicy = false;
                        selectedBuilding = null;
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

                      if (!mounted) return;

                      setState(() {
                        showMarket = true;
                        showBuildPanel = false;
                        showPolicy = false;
                        selectedBuilding = null;
                      });
                    },
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: 180,
                  child: UiButton(
                    text: "Podatki",
                    icon: Icons.account_balance,
                    color: UiColors.blue,
                    onTap: () async {
                      await loadPolicy();

                      if (!mounted) return;

                      setState(() {
                        showPolicy = true;
                        showMarket = false;
                        showBuildPanel = false;
                        selectedBuilding = null;
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