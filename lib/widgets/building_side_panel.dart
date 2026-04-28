// lib/widgets/building_side_panel.dart

import 'package:flutter/material.dart';
import '../ui/ui_system.dart';
import '../game/data/building_definitions.dart';

class BuildingSidePanel extends StatelessWidget {
  final Map building;
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

  String icon() {
    switch (building["type"]) {
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

  bool busy() {
    final s = building["status"].toString();

    return s == "Constructing" || s == "Upgrading";
  }

  Widget rowStat(
    String left,
    String right, {
    Color color = Colors.white,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Expanded(
            child: Text(
              left,
              style: UiText.body(),
            ),
          ),
          Text(
            right,
            style: UiText.value(
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget progressBar() {
    if (timer <= 0) {
      return const SizedBox();
    }

    final value = (1 - (timer / 60)).clamp(0, 1).toDouble();

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
          "$timer s",
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
        onTap: onTap,
        color: color,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final workers = building["workers"] ?? 0;
    final maxWorkers = building["maxWorkers"] ?? 0;
    final production = building["productionPerHour"] ?? 0;
    final morale = building["moraleBonus"] ?? 0;
    final storage = building["storageCapacity"] ?? 0;
    final housing = building["housing"] ?? 0;
    final maintenance = building["maintenanceCost"] ?? 0;
    final tileX = building["tileX"] ?? 0;
    final tileY = building["tileY"] ?? 0;

    final produced = building["producedResource"]?["name"] ?? "-";

    final def = BuildingDefinitions.get(
      building["type"],
    );

    return Positioned(
      top: 10,
      right: 10,
      bottom: 10,
      child: SizedBox(
        width: 410,
        child: Container(
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        "${icon()} ${building["name"]}",
                        style: UiText.title(
                          size: 30,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: onClose,
                      icon: const Icon(
                        Icons.close,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                Text(
                  building["status"].toString(),
                  style: UiText.body(
                    color: busy() ? Colors.orangeAccent : Colors.greenAccent,
                  ),
                ),
                progressBar(),
                const SizedBox(height: 18),
                Container(
                  height: 120,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.18),
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
                const SizedBox(height: 18),
                rowStat("📍 Pozycja", "$tileX,$tileY"),
                rowStat("📐 Rozmiar", "${def.width}x${def.height}"),
                rowStat("👷 Robotnicy", "$workers / $maxWorkers"),
                rowStat(
                  "⚙ Produkcja/h",
                  "$production",
                  color: Colors.greenAccent,
                ),
                rowStat("📦 Produkt", produced),
                if (housing > 0)
                  rowStat(
                    "🏠 Mieszkania",
                    "+$housing",
                  ),
                if (storage > 0)
                  rowStat(
                    "📦 Magazyn",
                    "+$storage",
                  ),
                if (morale > 0)
                  rowStat(
                    "😊 Morale",
                    "+$morale",
                  ),
                rowStat(
                  "💰 Utrzymanie",
                  "$maintenance/h",
                  color: Colors.redAccent,
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: actionButton(
                        text: "- Worker",
                        color: UiColors.red,
                        onTap: busy() || workers <= 0
                            ? null
                            : () => onSetWorkers(
                                  workers - 1,
                                ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: actionButton(
                        text: "+ Worker",
                        color: UiColors.green,
                        onTap: busy() || workers >= maxWorkers
                            ? null
                            : () => onSetWorkers(
                                  workers + 1,
                                ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                actionButton(
                  text: "Ulepsz",
                  icon: Icons.arrow_upward,
                  color: UiColors.gold,
                  onTap: busy() ? null : onUpgrade,
                ),
                const SizedBox(height: 12),
                actionButton(
                  text: "Usuń",
                  icon: Icons.delete,
                  color: UiColors.red,
                  onTap: onDelete,
                ),
                const Spacer(),
                actionButton(
                  text: "Zamknij",
                  icon: Icons.close,
                  color: UiColors.blue,
                  onTap: onClose,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
