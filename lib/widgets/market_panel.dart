import 'package:flutter/material.dart';

import '../ui/ui_system.dart';
import '../api/models.dart';

class MarketPanel extends StatefulWidget {
  final List<MarketOffer> offers;
  final List<MarketHistoryEntry> history;

  final VoidCallback onClose;
  final VoidCallback onCreate;

  final Function(String id) onBuy;

  const MarketPanel({
    super.key,
    required this.offers,
    required this.history,
    required this.onClose,
    required this.onCreate,
    required this.onBuy,
  });

  @override
  State<MarketPanel> createState() => _MarketPanelState();
}

class _MarketPanelState extends State<MarketPanel> {
  String selectedResource = "Wszystkie";

  bool showHistory = false;

  final List<String> resources = [
    "Wszystkie",
    "Wood",
    "Stone",
    "Bread",
    "Plank",
    "Berries",
    "StoneTools",
    "Wheat",
    "Flour",
  ];

  String iconPath(String type) {
    switch (type) {
      case "Wood":
        return "assets/icons/resources/wood_icon.png";

      case "Stone":
        return "assets/icons/resources/stone_icon.png";

      case "Bread":
        return "assets/icons/resources/bread_icon.png";

      case "Plank":
        return "assets/icons/resources/plank_icon.png";

      case "Berries":
        return "assets/icons/resources/berries_icon.png";

      case "StoneTools":
        return "assets/icons/resources/stonetools_icon.png";

      case "Wheat":
        return "assets/icons/resources/wheat_icon.png";

      case "Flour":
        return "assets/icons/resources/flour_icon.png";

      default:
        return "assets/icons/resources/wood_icon.png";
    }
  }

  String name(String type) {
    switch (type) {
      case "Wszystkie":
        return "Wszystkie";

      case "Wood":
        return "Drewno";

      case "Stone":
        return "Kamień";

      case "Bread":
        return "Chleb";

      case "Plank":
        return "Deski";

      case "Berries":
        return "Jagody";

      case "StoneTools":
        return "Narzędzia";

      case "Wheat":
        return "Pszenica";

      case "Flour":
        return "Mąka";

      default:
        return type;
    }
  }

  @override
  Widget build(BuildContext context) {
    final filteredOffers = widget.offers.where((o) {
      return selectedResource == "Wszystkie" ||
          o.resourceType == selectedResource;
    }).toList();

    return Center(
      child: Container(
        width: 980,
        height: 720,
        padding: const EdgeInsets.all(22),
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
              offset: Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    "Rynek Osady",
                    style: UiText.title(size: 30),
                  ),
                ),

                SizedBox(
                  width: 220,
                  height: 52,
                  child: UiButton(
                    text: "Wystaw ofertę",
                    icon: Icons.add_business,
                    color: UiColors.gold,
                    onTap: widget.onCreate,
                  ),
                ),

                const SizedBox(width: 14),

                IconButton(
                  onPressed: widget.onClose,
                  icon: const Icon(
                    Icons.close,
                    color: Colors.white,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 18),

            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 10,
              ),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.16),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: Colors.white10),
              ),
              child: DropdownButtonFormField<String>(
                initialValue: selectedResource,
                dropdownColor: const Color(0xFF3B1C08),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.black.withValues(alpha: 0.15),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                style: const TextStyle(color: Colors.white),
                items: resources.map((e) {
                  return DropdownMenuItem(
                    value: e,
                    child: Text(name(e)),
                  );
                }).toList(),
                onChanged: (v) {
                  setState(() {
                    selectedResource = v ?? "Wszystkie";
                  });
                },
              ),
            ),

            const SizedBox(height: 18),

            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.18),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: Colors.white10),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          showHistory = false;
                        });
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 180),
                        height: 52,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: !showHistory
                              ? UiColors.gold
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Text(
                          "Oferty",
                          style: UiText.title(size: 18),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 8),

                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          showHistory = true;
                        });
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 180),
                        height: 52,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: showHistory
                              ? UiColors.gold
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Text(
                          "Historia",
                          style: UiText.title(size: 18),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 18),

            Expanded(
              child: showHistory
                  ? buildHistory()
                  : buildOffers(filteredOffers),
            ),
          ],
        ),
      ),
    );
  }

  Widget resourceIcon(String type) {
    return Container(
      width: 58,
      height: 58,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.22),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.06),
        ),
      ),
      child: Image.asset(
        iconPath(type),
        fit: BoxFit.contain,
        filterQuality: FilterQuality.none,
      ),
    );
  }

  Widget buildOffers(List<MarketOffer> filteredOffers) {
    if (filteredOffers.isEmpty) {
      return Center(
        child: Text(
          "Brak ofert",
          style: UiText.body(),
        ),
      );
    }

    return ListView.separated(
      itemCount: filteredOffers.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (_, i) {
        final o = filteredOffers[i];

        return Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.16),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: Colors.white10),
          ),
          child: Row(
            children: [
              resourceIcon(o.resourceType),

              const SizedBox(width: 14),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name(o.resourceType),
                      style: UiText.title(size: 18),
                    ),

                    const SizedBox(height: 4),

                    Row(
                      children: [
                        Text(
                          "${o.remainingQuantity.toInt()} szt.",
                          style: UiText.body(size: 14),
                        ),

                        const SizedBox(width: 14),

                        Text(
                          "${o.finalPrice.toStringAsFixed(0)} zł/szt.",
                          style: UiText.value(
                            size: 15,
                            color: Colors.yellowAccent,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              SizedBox(
                width: 120,
                height: 46,
                child: UiButton(
                  text: "Kup",
                  icon: Icons.shopping_cart,
                  color: UiColors.green,
                  onTap: () => widget.onBuy(o.id),
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
            color: Colors.black.withValues(alpha: 0.16),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: Colors.white10),
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
                      style: UiText.body(size: 14),
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