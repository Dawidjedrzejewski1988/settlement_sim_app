// lib/widgets/market_panel.dart

import 'package:flutter/material.dart';
import '../ui/ui_system.dart';

class MarketPanel extends StatelessWidget {
  final List<dynamic> offers;
  final VoidCallback onClose;
  final VoidCallback onCreate;
  final Function(String id) onBuy;

  const MarketPanel({
    super.key,
    required this.offers,
    required this.onClose,
    required this.onCreate,
    required this.onBuy,
  });

  String icon(String type) {
    switch (type) {
      case "Wood":
        return "🪵";
      case "Stone":
        return "🪨";
      case "Bread":
        return "🍞";
      case "Plank":
        return "🪚";
      case "Berries":
        return "🍓";
      case "StoneTools":
        return "🔨";
      case "Wheat":
        return "🌾";
      case "Flour":
        return "⚪";
      default:
        return "📦";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 90,
      left: 20,
      right: 20,
      bottom: 20,
      child: UiPanel(
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    "Rynek",
                    style: UiText.title(
                      size: 28,
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
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: UiButton(
                text: "Wystaw Ofertę",
                icon: Icons.add_business,
                color: UiColors.gold,
                onTap: onCreate,
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: offers.isEmpty
                  ? const Center(
                      child: Text(
                        "Brak ofert",
                        style: TextStyle(
                          color: Colors.white70,
                        ),
                      ),
                    )
                  : ListView.builder(
                      itemCount: offers.length,
                      itemBuilder: (_, i) {
                        final o = offers[i];

                        final id = o["id"].toString();

                        final type = o["resourceType"].toString();

                        final qty = (o["remainingQuantity"] as num).toDouble();

                        final price = (o["finalPrice"] as num).toDouble();

                        return Container(
                          margin: const EdgeInsets.only(
                            bottom: 10,
                          ),
                          padding: const EdgeInsets.all(
                            12,
                          ),
                          decoration: UiDecor.card(),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  "${icon(type)} $type | ${qty.toInt()} szt.",
                                  style: UiText.body(),
                                ),
                              ),
                              Text(
                                "${price.toStringAsFixed(0)} 💰",
                                style: UiText.value(
                                  color: Colors.yellowAccent,
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              SizedBox(
                                width: 110,
                                child: UiButton(
                                  text: "Kup",
                                  color: UiColors.green,
                                  onTap: () => onBuy(id),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
