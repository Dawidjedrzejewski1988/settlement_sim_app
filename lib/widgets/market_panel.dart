import 'package:flutter/material.dart';

import '../api/models.dart';
import '../ui/ui_system.dart';

class MarketPanel extends StatefulWidget {
  final List<MarketResource> resources;

  final List<MarketHistoryEntry> history;

  final VoidCallback onClose;

  final Function(
    String resourceType,
    double quantity,
    bool isBuy,
  ) onTrade;

  const MarketPanel({
    super.key,
    required this.resources,
    required this.history,
    required this.onClose,
    required this.onTrade,
  });

  @override
  State<MarketPanel> createState() => _MarketPanelState();
}

class _MarketPanelState extends State<MarketPanel> {
  bool showHistory = false;

  final Map<String, TextEditingController> controllers = {};

  @override
  void dispose() {
    for (final c in controllers.values) {
      c.dispose();
    }

    super.dispose();
  }

  TextEditingController controller(
    String type,
  ) {
    if (!controllers.containsKey(type)) {
      controllers[type] = TextEditingController(text: "10");
    }

    return controllers[type]!;
  }

  String iconPath(String type) {
    switch (type.toUpperCase()) {
      case "WOOD":
        return "assets/icons/resources/wood_icon.png";

      case "STONE":
        return "assets/icons/resources/stone_icon.png";

      case "BREAD":
        return "assets/icons/resources/bread_icon.png";

      case "PLANK":
        return "assets/icons/resources/plank_icon.png";

      case "BERRIES":
        return "assets/icons/resources/berries_icon.png";

      case "STONETOOLS":
        return "assets/icons/resources/stonetools_icon.png";

      case "WHEAT":
        return "assets/icons/resources/wheat_icon.png";

      case "FLOUR":
        return "assets/icons/resources/flour_icon.png";

      default:
        return "assets/icons/resources/wood_icon.png";
    }
  }

  String name(String type) {
    switch (type.toUpperCase()) {
      case "WOOD":
        return "Drewno";

      case "STONE":
        return "Kamień";

      case "BREAD":
        return "Chleb";

      case "PLANK":
        return "Deski";

      case "BERRIES":
        return "Jagody";

      case "STONETOOLS":
        return "Narzędzia";

      case "WHEAT":
        return "Pszenica";

      case "FLOUR":
        return "Mąka";

      default:
        return type;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 1100,
        height: 760,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28),
          border: Border.all(
            color: UiColors.gold,
            width: 2,
          ),
          gradient: const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF6F3811),
              Color(0xFF3D1B07),
              Color(0xFF1B0B03),
            ],
          ),
          boxShadow: const [
            BoxShadow(
              color: Colors.black54,
              blurRadius: 20,
              offset: Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          children: [
            /// HEADER
            Row(
              children: [
                Expanded(
                  child: Text(
                    "Rynek Osady",
                    style: UiText.title(size: 34),
                  ),
                ),
                IconButton(
                  onPressed: widget.onClose,
                  icon: const Icon(
                    Icons.close,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            /// TABS
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.black.withValues(
                  alpha: 0.18,
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Colors.white10,
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: tabButton(
                      text: "Rynek",
                      active: !showHistory,
                      onTap: () {
                        setState(() {
                          showHistory = false;
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: tabButton(
                      text: "Historia",
                      active: showHistory,
                      onTap: () {
                        setState(() {
                          showHistory = true;
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 18),

            Expanded(
              child: showHistory
                  ? buildHistory()
                  : buildResources(
                      widget.resources,
                    ),
            ),

            const SizedBox(height: 8),

            Text(
              "Ceny zmieniają się wraz z podażą i popytem",
              style: UiText.body(
                size: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget tabButton({
    required String text,
    required bool active,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        height: 56,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: active ? UiColors.gold : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          text,
          style: UiText.title(size: 20),
        ),
      ),
    );
  }

  Widget resourceIcon(String type) {
    return Container(
      width: 54,
      height: 54,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.black.withValues(
          alpha: 0.24,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withValues(
            alpha: 0.05,
          ),
        ),
      ),
      child: Image.asset(
        iconPath(type),
        fit: BoxFit.contain,
        filterQuality: FilterQuality.none,
      ),
    );
  }

  Widget buildResources(
    List<MarketResource> resources,
  ) {
    if (resources.isEmpty) {
      return Center(
        child: Text(
          "Brak zasobów na rynku",
          style: UiText.body(),
        ),
      );
    }

    return ListView.separated(
      itemCount: resources.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (_, i) {
        final r = resources[i];

        final quantityController = controller(r.resourceType);

        return Container(
          height: 92,
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 10,
          ),
          decoration: BoxDecoration(
            color: Colors.black.withValues(
              alpha: 0.14,
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Colors.white10,
            ),
          ),
          child: Row(
            children: [
              resourceIcon(r.resourceType),

              const SizedBox(width: 14),

              /// INFO
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name(r.resourceType),
                      style: UiText.title(size: 18),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Text(
                          "Dostępne: ${r.quantity.toStringAsFixed(0)}",
                          style: UiText.body(
                            size: 13,
                          ),
                        ),
                        const SizedBox(width: 18),
                        Text(
                          "Kup: ${r.buyPrice.toStringAsFixed(0)} zł",
                          style: UiText.value(
                            size: 13,
                            color: Colors.greenAccent,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          "Sprzedaj: ${r.sellPrice.toStringAsFixed(0)} zł",
                          style: UiText.value(
                            size: 13,
                            color: UiColors.gold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              /// ACTIONS
              SizedBox(
                width: 360,
                child: Row(
                  children: [
                    SizedBox(
                      width: 74,
                      height: 42,
                      child: TextField(
                        controller: quantityController,
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                        ),
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.zero,
                          filled: true,
                          fillColor: Colors.black26,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    SizedBox(
                      width: 118,
                      height: 42,
                      child: UiButton(
                        text: "Kup",
                        icon: Icons.shopping_cart,
                        color: UiColors.green,
                        onTap: () => widget.onTrade(
                          r.resourceType,
                          double.tryParse(
                                quantityController.text,
                              ) ??
                              1,
                          true,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    SizedBox(
                      width: 132,
                      height: 42,
                      child: UiButton(
                        text: "Sprzedaj",
                        icon: Icons.sell,
                        color: UiColors.gold,
                        onTap: () => widget.onTrade(
                          r.resourceType,
                          double.tryParse(
                                quantityController.text,
                              ) ??
                              1,
                          false,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget buildHistory() {
    if (widget.history.isEmpty) {
      return Center(
        child: Text(
          "Brak historii transakcji",
          style: UiText.body(),
        ),
      );
    }

    return ListView.separated(
      itemCount: widget.history.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (_, i) {
        final h = widget.history[i];

        return Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.black.withValues(
              alpha: 0.14,
            ),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: Colors.white10,
            ),
          ),
          child: Row(
            children: [
              resourceIcon(h.resourceType),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name(h.resourceType),
                      style: UiText.title(size: 18),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "${h.quantity.toInt()} szt. • ${h.pricePerUnit.toStringAsFixed(0)} zł/szt.",
                      style: UiText.body(size: 13),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    "${h.totalPrice.toStringAsFixed(0)} zł",
                    style: UiText.value(
                      size: 18,
                      color: UiColors.gold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Prowizja ${h.commission.toStringAsFixed(0)} zł",
                    style: UiText.body(size: 12),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
