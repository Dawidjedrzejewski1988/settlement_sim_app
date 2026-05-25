import 'package:flutter/material.dart';

import '../api/models.dart';
import '../ui/ui_system.dart';

class EconomyPanel extends StatefulWidget {
  final Settlement settlement;

  final double woodPerSec;
  final double plankPerSec;
  final double berriesPerSec;
  final double stonePerSec;
  final double breadPerSec;
  final double moneyPerSec;

  final VoidCallback onClose;

  const EconomyPanel({
    super.key,
    required this.settlement,
    required this.woodPerSec,
    required this.plankPerSec,
    required this.berriesPerSec,
    required this.stonePerSec,
    required this.breadPerSec,
    required this.moneyPerSec,
    required this.onClose,
  });

  @override
  State<EconomyPanel> createState() => _EconomyPanelState();
}

class _EconomyPanelState extends State<EconomyPanel> {
  int tab = 0;

  Map<String, String> data(String code) {
    switch (code) {
      case "Wood":
        return {"name": "Drewno", "icon": "assets/icons/resources/wood_icon.png"};

      case "Stone":
        return {"name": "Kamień", "icon": "assets/icons/resources/stone_icon.png"};

      case "Bread":
        return {"name": "Chleb", "icon": "assets/icons/resources/bread_icon.png"};

      case "Plank":
        return {"name": "Deski", "icon": "assets/icons/resources/plank_icon.png"};

      case "Berries":
        return {"name": "Jagody", "icon": "assets/icons/resources/berries_icon.png"};

      case "StoneTools":
        return {"name": "Narzędzia", "icon": "assets/icons/resources/stonetools_icon.png"};

      case "Wheat":
        return {"name": "Pszenica", "icon": "assets/icons/resources/wheat_icon.png"};

      case "Flour":
        return {"name": "Mąka", "icon": "assets/icons/resources/flour_icon.png"};

      default:
        return {"name": code, "icon": "assets/icons/resources/wood_icon.png"};
    }
  }

  double rate(String code) {
    switch (code) {
      case "Wood":
        return widget.woodPerSec * 3600;

      case "Stone":
        return widget.stonePerSec * 3600;

      case "Bread":
        return widget.breadPerSec * 3600;

      case "Plank":
        return widget.plankPerSec * 3600;

      case "Berries":
        return widget.berriesPerSec * 3600;

      default:
        return 0;
    }
  }

  Widget tabButton(String text, int index) {
    final active = tab == index;

    return InkWell(
      onTap: () => setState(() => tab = index),

      borderRadius: BorderRadius.circular(14),

      child: Container(
        height: 46,

        padding: const EdgeInsets.symmetric(horizontal: 18),

        alignment: Alignment.center,

        decoration: BoxDecoration(
          color: active ? UiColors.gold : Colors.black.withValues(alpha: 0.18),

          borderRadius: BorderRadius.circular(14),

          border: Border.all(color: active ? UiColors.gold : Colors.white10),
        ),

        child: Text(
          text,

          style: UiText.title(size: 15).copyWith(
            color: active ? Colors.white : Colors.white70,
          ),
        ),
      ),
    );
  }

  Widget card({
    required String icon,
    required String title,
    required String amount,
    required String rate,
    required bool positive,
    String? subtitle,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14),

      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.18),

        borderRadius: BorderRadius.circular(16),

        border: Border.all(color: Colors.white10),
      ),

      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,

            padding: const EdgeInsets.all(4),

            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.18),

              borderRadius: BorderRadius.circular(12),
            ),

            child: Image.asset(icon, filterQuality: FilterQuality.none),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Text(title, overflow: TextOverflow.ellipsis, style: UiText.title(size: 18)),

                if (subtitle != null)
                  Text(
                    subtitle,

                    style: UiText.body(size: 11).copyWith(
                      color: Colors.white60,
                    ),
                  ),
              ],
            ),
          ),

          SizedBox(
            width: 70,

            child: Text(
              amount,

              textAlign: TextAlign.center,

              style: UiText.value(size: 22, color: UiColors.gold),
            ),
          ),

          const SizedBox(width: 12),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),

            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.18),

              borderRadius: BorderRadius.circular(12),
            ),

            child: Row(
              children: [
                Icon(
                  positive ? Icons.trending_up : Icons.trending_down,

                  size: 15,

                  color: positive ? Colors.greenAccent : Colors.redAccent,
                ),

                const SizedBox(width: 4),

                Text(
                  "${positive ? "+" : ""}$rate/h",

                  style: UiText.value(
                    size: 16,
                    color: positive ? Colors.greenAccent : Colors.redAccent,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget consumption({
    required String icon,
    required String title,
    required String value,
    required Color color,
    required String subtitle,
  }) {
    return Container(
      padding: const EdgeInsets.all(18),

      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.18),

        borderRadius: BorderRadius.circular(18),

        border: Border.all(color: Colors.white10),
      ),

      child: Row(
        children: [
          Container(
            width: 58,
            height: 58,

            padding: const EdgeInsets.all(8),

            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.18),

              borderRadius: BorderRadius.circular(14),
            ),

            child: Image.asset(icon, filterQuality: FilterQuality.none),
          ),

          const SizedBox(width: 16),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Text(title, style: UiText.body(size: 14)),

                const SizedBox(height: 4),

                Text(
                  value,

                  style: UiText.value(size: 28, color: color),
                ),

                const SizedBox(height: 4),

                Text(
                  subtitle,

                  style: UiText.body(size: 12).copyWith(
                    color: Colors.white60,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final upkeep = widget.moneyPerSec < 0 ? widget.moneyPerSec.abs() * 3600 : 0.0;

    return Center(
      child: Container(
        width: 980,
        height: 720,

        padding: const EdgeInsets.all(22),

        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(26),

          border: Border.all(color: UiColors.gold, width: 2),

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
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            Row(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Container(
                        width: 54,
                        height: 54,

                        padding: const EdgeInsets.all(8),

                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.18),

                          borderRadius: BorderRadius.circular(14),
                        ),

                        child: Image.asset(
                          "assets/icons/stats/gold_icon.png",
                          filterQuality: FilterQuality.none,
                        ),
                      ),

                      const SizedBox(width: 14),

                      Text("Ekonomia Osady", style: UiText.title(size: 30)),
                    ],
                  ),
                ),

                IconButton(
                  onPressed: widget.onClose,

                  icon: const Icon(Icons.close, color: Colors.white),
                ),
              ],
            ),

            const SizedBox(height: 22),

            Row(
              children: [
                tabButton("Produkcja", 0),

                const SizedBox(width: 10),

                tabButton("Konsumpcja", 1),
              ],
            ),

            const SizedBox(height: 20),

            Expanded(
              child: tab == 0
                  ? GridView.builder(
                      physics: const BouncingScrollPhysics(),

                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 4.8,
                      ),

                      itemCount: widget.settlement.resources.length + 1,

                      itemBuilder: (_, i) {
                        if (i == 0) {
                          return card(
                            icon: "assets/icons/stats/gold_icon.png",

                            title: "Złoto",

                            amount: widget.settlement.money.toStringAsFixed(0),

                            rate: (widget.moneyPerSec * 3600).toStringAsFixed(1),

                            positive: widget.moneyPerSec >= 0,

                            subtitle: "Utrzymanie: -${upkeep.toStringAsFixed(1)}/h",
                          );
                        }

                        final r = widget.settlement.resources[i - 1];

                        final d = data(r.code);

                        final perHour = rate(r.code);

                        return card(
                          icon: d["icon"]!,

                          title: d["name"]!,

                          amount: r.amount.toStringAsFixed(0),

                          rate: perHour.toStringAsFixed(1),

                          positive: perHour >= 0,
                        );
                      },
                    )
                  : SingleChildScrollView(
                      child: Column(
                        children: [
                          consumption(
                            icon: "assets/icons/resources/bread_icon.png",

                            title: "Konsumpcja żywności",

                            value: "-${widget.settlement.foodConsumptionPerHour.toStringAsFixed(1)}/h",

                            color: Colors.orangeAccent,

                            subtitle: "Mieszkańcy konsumują jedzenie",
                          ),

                          const SizedBox(height: 14),

                          consumption(
                            icon: "assets/icons/resources/wood_icon.png",

                            title: "Zużycie drewna",

                            value: "-${widget.settlement.woodConsumptionPerHour.toStringAsFixed(1)}/h",

                            color: widget.settlement.hasWoodShortage
                                ? Colors.redAccent
                                : Colors.orangeAccent,

                            subtitle: widget.settlement.hasWoodShortage
                                ? "Brakuje drewna w osadzie"
                                : "Ogrzewanie i potrzeby mieszkańców",
                          ),

                          const SizedBox(height: 14),

                          consumption(
                            icon: "assets/icons/stats/population_icon.png",

                            title: "Satysfakcja żywności",

                            value: "${(widget.settlement.foodSatisfaction * 100).toStringAsFixed(0)}%",

                            color: widget.settlement.foodSatisfaction >= 0.8
                                ? Colors.greenAccent
                                : Colors.redAccent,

                            subtitle: widget.settlement.foodSatisfaction >= 0.8
                                ? "Mieszkańcy są dobrze wyżywieni"
                                : "Osada cierpi na niedobory żywności",
                          ),
                        ],
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}