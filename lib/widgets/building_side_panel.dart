import 'package:flutter/material.dart';
import '../api/models.dart';
import '../ui/ui_system.dart';

class BuildingSidePanel extends StatefulWidget {
  final Building building;
  final int timer;
  final VoidCallback onUpgrade;
  final VoidCallback onDelete;
  final VoidCallback onClose;

  final Function(int workers) onSetWorkers;

  const BuildingSidePanel({
    super.key,
    required this.building,
    required this.timer,
    required this.onUpgrade,
    required this.onDelete,
    required this.onClose,
    required this.onSetWorkers,
  });

  @override
  State<BuildingSidePanel> createState() => _BuildingSidePanelState();
}

class _BuildingSidePanelState extends State<BuildingSidePanel> {
  late int workers;

  @override
  void initState() {
    super.initState();
    workers = widget.building.workers;
  }

  @override
  void didUpdateWidget(covariant BuildingSidePanel oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.building.id != widget.building.id) {
      workers = widget.building.workers;
    }
  }

  bool isProductionBuilding() {
    switch (widget.building.type) {
      case "LumberCamp":
      case "Sawmill":
      case "GatherersCamp":
      case "Quarry":
      case "Workshop":
      case "Farm":
      case "Mill":
      case "Bakery":
        return true;

      default:
        return false;
    }
  }

  bool isHousingBuilding() {
    return widget.building.type == "House" || widget.building.type == "Cottage";
  }

  bool isWarehouse() {
    return widget.building.type == "Warehouse";
  }

  bool isTavern() {
    return widget.building.type == "Tavern";
  }

  bool busy() {
    return widget.building.status == "Constructing" ||
        widget.building.status == "Upgrading";
  }

  String buildingName(String type) {
    switch (type) {
      case "LumberCamp":
        return "Obóz drwali";

      case "Sawmill":
        return "Tartak";

      case "GatherersCamp":
        return "Zbieracze";

      case "Quarry":
        return "Kamieniołom";

      case "Workshop":
        return "Warsztat";

      case "Farm":
        return "Farma";

      case "Mill":
        return "Młyn";

      case "Bakery":
        return "Piekarnia";

      case "Cottage":
        return "Chata";

      case "House":
        return "Dom";

      case "Warehouse":
        return "Magazyn";

      case "Market":
        return "Rynek";

      case "Tavern":
        return "Tawerna";

      default:
        return type;
    }
  }

  String statusName(String status) {
    switch (status) {
      case "Active":
        return "Aktywny";

      case "Constructing":
        return "Budowa";

      case "Upgrading":
        return "Ulepszanie";

      default:
        return status;
    }
  }

  String icon() {
    switch (widget.building.type) {
      case "House":
        return "🏠";

      case "Cottage":
        return "🏡";

      case "LumberCamp":
        return "🪵";

      case "GatherersCamp":
        return "🍓";

      case "Warehouse":
        return "📦";

      case "Market":
        return "🛒";

      case "Tavern":
        return "🍺";

      case "Sawmill":
        return "🪚";

      case "Quarry":
        return "🪨";

      case "Farm":
        return "🌾";

      case "Mill":
        return "⚙";

      case "Bakery":
        return "🍞";

      case "Workshop":
        return "🔨";

      default:
        return "🏘";
    }
  }

  Widget rowStat(
    String left,
    String right, {
    Color color = Colors.white,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              left,
              style: UiText.body(),
            ),
          ),
          Text(
            right,
            style: UiText.value(color: color),
          ),
        ],
      ),
    );
  }

  Widget progressBar() {
    if (widget.timer <= 0) {
      return const SizedBox();
    }

    final value = (1 - (widget.timer / 60)).clamp(0, 1).toDouble();

    return Column(
      children: [
        const SizedBox(height: 12),
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: LinearProgressIndicator(
            value: value,
            minHeight: 12,
            backgroundColor: Colors.black38,
            valueColor: const AlwaysStoppedAnimation(
              UiColors.gold,
            ),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          "${widget.timer}s",
          style: UiText.body(),
        ),
      ],
    );
  }

  Widget actionButton({
    required String text,
    required Color color,
    required VoidCallback? onTap,
    IconData? icon,
  }) {
    return SizedBox(
      height: 56,
      child: UiButton(
        text: text,
        icon: icon,
        color: color,
        onTap: onTap,
      ),
    );
  }

  Widget workersSection() {
    if (!isProductionBuilding()) {
      return const SizedBox();
    }

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.16),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                "👷 Robotnicy",
                style: UiText.title(size: 18),
              ),
              const Spacer(),
              Text(
                "$workers / ${widget.building.maxWorkers}",
                style: UiText.value(
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 30,
                  child: UiButton(
                    text: "-",
                    color: busy() || workers <= 0
                        ? Colors.grey.withValues(alpha: 0.25)
                        : UiColors.red,
                    onTap: busy() || workers <= 0
                        ? null
                        : () {
                            setState(() {
                              workers--;
                            });

                            widget.onSetWorkers(workers);
                          },
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: SizedBox(
                  height: 30,
                  child: UiButton(
                    text: "+",
                    color: busy() || workers >= widget.building.maxWorkers
                        ? Colors.grey.withValues(alpha: 0.25)
                        : UiColors.green,
                    onTap: busy() || workers >= widget.building.maxWorkers
                        ? null
                        : () {
                            setState(() {
                              workers++;
                            });

                            widget.onSetWorkers(workers);
                          },
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget productionSection() {
    if (!isProductionBuilding()) {
      return const SizedBox();
    }

    final currentProduction = widget.building.maxWorkers == 0
        ? 0.0
        : widget.building.productionPerHour *
            (widget.building.workers / widget.building.maxWorkers);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        rowStat(
          "⚙ Produkcja/h",
          "${widget.building.productionPerHour.toStringAsFixed(0)}/h",
          color: Colors.greenAccent,
        ),
        rowStat(
          "⏱ Aktualnie",
          "${currentProduction.toStringAsFixed(0)}/h",
          color: Colors.lightGreenAccent,
        ),
        if (widget.building.producedResource != null)
          rowStat(
            "📦 Produkuje",
            widget.building.producedResource!.name ?? "-",
            color: Colors.greenAccent,
          ),
        if (widget.building.input.isNotEmpty) ...[
          const SizedBox(height: 6),
          Text(
            "Wymagane surowce",
            style: UiText.title(size: 18),
          ),
          const SizedBox(height: 10),
          ...widget.building.input.map(
            (e) => rowStat(
              "📥 ${e.name}",
              "${e.amount.toStringAsFixed(0)}/h",
              color: Colors.orangeAccent,
            ),
          ),
        ],
      ],
    );
  }

  Widget warehouseSection() {
    if (!isWarehouse()) {
      return const SizedBox();
    }

    final used = widget.building.usedStorage;
    final max = widget.building.storageCapacity;
    final percent = max <= 0 ? 0.0 : ((used / max).clamp(0.0, 1.0)).toDouble();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        rowStat(
          "📦 Magazyn",
          "${used.toStringAsFixed(0)} / ${max.toStringAsFixed(0)}",
          color: Colors.orangeAccent,
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: LinearProgressIndicator(
            value: percent,
            minHeight: 14,
            backgroundColor: Colors.black38,
            valueColor: AlwaysStoppedAnimation(
              percent > 0.9 ? Colors.redAccent : Colors.orangeAccent,
            ),
          ),
        ),
        const SizedBox(height: 10),
        rowStat(
          "📥 Wolne miejsce",
          widget.building.freeStorage.toStringAsFixed(0),
        ),
      ],
    );
  }

  Widget housingSection() {
    if (!isHousingBuilding()) {
      return const SizedBox();
    }

    return Column(
      children: [
        rowStat(
          "👥 Mieszkańcy",
          "${widget.building.currentResidents} / ${widget.building.housing}",
        ),
        rowStat(
          "💰 Podatki",
          "+${widget.building.taxIncome.toStringAsFixed(0)}/h",
          color: Colors.greenAccent,
        ),
      ],
    );
  }

  Widget tavernSection() {
    if (!isTavern()) {
      return const SizedBox();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        rowStat(
          "😊 Morale",
          "+${widget.building.moraleBonus}",
          color: Colors.greenAccent,
        ),
        const SizedBox(height: 10),
        Text(
          "Efekty",
          style: UiText.title(size: 18),
        ),
        const SizedBox(height: 10),
        rowStat("🍺 Rozrywka", "+2 morale"),
        rowStat("🎵 Muzyka", "+1 morale"),
        rowStat("😊 Komfort", "+1 morale"),
      ],
    );
  }

  Widget commonSection() {
    return Column(
      children: [
        rowStat(
          "💰 Utrzymanie",
          "${widget.building.maintenanceCost.toStringAsFixed(0)}/h",
          color: Colors.redAccent,
        ),
      ],
    );
  }

  Widget buildSpecificSection() {
    if (isWarehouse()) {
      return warehouseSection();
    }

    if (isHousingBuilding()) {
      return housingSection();
    }

    if (isTavern()) {
      return tavernSection();
    }

    return productionSection();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
        top: 10,
        right: 10,
        bottom: null,
        child: SizedBox(
          width: 420,
          child: Container(
            constraints: const BoxConstraints(
              maxHeight: 760,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(26),
              border: Border.all(
                color: UiColors.gold,
                width: 2,
              ),
              gradient: const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF6A3813),
                  Color(0xFF3B1C08),
                  Color(0xFF1F0D04),
                ],
              ),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black54,
                  blurRadius: 18,
                  offset: Offset(-6, 0),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            "${icon()} ${buildingName(widget.building.type)}",
                            style: UiText.title(size: 30),
                          ),
                        ),
                        IconButton(
                          onPressed: widget.onClose,
                          icon: const Icon(
                            Icons.close,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      statusName(widget.building.status),
                      style: UiText.body(
                        color:
                            busy() ? Colors.orangeAccent : Colors.greenAccent,
                      ),
                    ),
                    progressBar(),
                    const SizedBox(height: 18),
                    Container(
                      height: 120,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(
                          alpha: 0.18,
                        ),
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(
                          color: Colors.white12,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          icon(),
                          style: const TextStyle(
                            fontSize: 56,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    commonSection(),
                    const SizedBox(height: 10),
                    buildSpecificSection(),
                    const SizedBox(height: 16),
                    workersSection(),
                    const SizedBox(height: 10),
                    actionButton(
                      text: "Zburz budynek",
                      icon: Icons.delete_forever,
                      color: UiColors.red,
                      onTap: widget.onDelete,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
