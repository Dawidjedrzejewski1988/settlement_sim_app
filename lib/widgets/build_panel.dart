import 'package:flutter/material.dart';
import '../ui/ui_system.dart';
import '../api/models.dart';

class BuildPanel extends StatefulWidget {
  final List<AvailableBuilding> buildings;
  final Function(String) onSelect;

  const BuildPanel({
    super.key,
    required this.buildings,
    required this.onSelect,
  });

  @override
  State<BuildPanel> createState() => _BuildPanelState();
}

class _BuildPanelState extends State<BuildPanel> {
  String category = "Wszystkie";

  final categories = const [
    "Wszystkie",
    "Mieszkalne",
    "Produkcja",
    "Ekonomia",
  ];

  String getCategory(String type) {
    switch (type) {
      case "House":
      case "Cottage":
        return "Mieszkalne";

      case "LumberCamp":
      case "GatherersCamp":
      case "Quarry":
      case "Farm":
      case "Mill":
      case "Bakery":
      case "Sawmill":
      case "Workshop":
        return "Produkcja";

      case "Warehouse":
      case "Market":
      case "Tavern":
        return "Ekonomia";

      default:
        return "Wszystkie";
    }
  }

  String icon(String type) {
    switch (type) {
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

  List<AvailableBuilding> get filtered {
    if (category == "Wszystkie") {
      return widget.buildings;
    }

    return widget.buildings.where((b) {
      return getCategory(b.type) == category;
    }).toList();
  }

  String costText(AvailableBuilding b) {
    if (b.cost.isEmpty) return "-";

    return b.cost.map((e) {
      return "${e.name}: ${e.amount.toInt()}";
    }).join(" | ");
  }

  Widget categoryButton(String text) {
    final active = category == text;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            category = text;
          });
        },
        child: Container(
          height: 42,
          decoration: UiDecor.card(active: active),
          child: Center(
            child: Text(
              text,
              style: UiText.value(
                size: 13,
                color: active ? UiColors.gold : Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildCard(AvailableBuilding b) {
    final canBuild = b.canBuild;

    return InkWell(
      onTap: canBuild ? () => widget.onSelect(b.type) : null,
      borderRadius: BorderRadius.circular(14),
      child: Opacity(
        opacity: canBuild ? 1 : 0.55,
        child: Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.all(12),
          decoration: UiDecor.card(active: canBuild),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(icon(b.type), style: const TextStyle(fontSize: 24)),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      b.name,
                      style: UiText.title(size: 18),
                    ),
                  ),
                  if (canBuild)
                    const Icon(Icons.arrow_forward_ios,
                        color: UiColors.gold, size: 16),
                  if (!canBuild)
                    const Icon(Icons.lock, color: Colors.red),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                canBuild ? costText(b) : (b.reason ?? "Zablokowane"),
                style: UiText.body(
                  size: 13,
                  color: canBuild ? UiColors.textSoft : Colors.redAccent,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 18,
      bottom: 18,
      child: SizedBox(
        width: 380,
        height: 560,
        child: UiPanel(
          child: Column(
            children: [
              Text("Budowa", style: UiText.title(size: 28)),
              const SizedBox(height: 14),
              Row(children: categories.map(categoryButton).toList()),
              const SizedBox(height: 14),
              Expanded(
                child: ListView.builder(
                  itemCount: filtered.length,
                  itemBuilder: (_, index) {
                    return buildCard(filtered[index]);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}