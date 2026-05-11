import 'package:flutter/material.dart';

import '../api/models.dart';
import '../ui/ui_system.dart';

class EconomyPanel extends StatelessWidget {
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

  Map<String, String> resourceData(
    String code,
  ) {
    switch (code) {
      case "Wood":
        return {
          "name": "Drewno",
          "icon":
              "assets/icons/resources/wood_icon.png",
        };

      case "Stone":
        return {
          "name": "Kamień",
          "icon":
              "assets/icons/resources/stone_icon.png",
        };

      case "Bread":
        return {
          "name": "Chleb",
          "icon":
              "assets/icons/resources/bread_icon.png",
        };

      case "Plank":
        return {
          "name": "Deski",
          "icon":
              "assets/icons/resources/plank_icon.png",
        };

      case "Berries":
        return {
          "name": "Jagody",
          "icon":
              "assets/icons/resources/berries_icon.png",
        };

      case "StoneTools":
        return {
          "name": "Narzędzia",
          "icon":
              "assets/icons/resources/stonetools_icon.png",
        };

      case "Wheat":
        return {
          "name": "Pszenica",
          "icon":
              "assets/icons/resources/wheat_icon.png",
        };

      case "Flour":
        return {
          "name": "Mąka",
          "icon":
              "assets/icons/resources/flour_icon.png",
        };

      default:
        return {
          "name": code,
          "icon":
              "assets/icons/resources/wood_icon.png",
        };
    }
  }

  double rate(String code) {
    switch (code) {
      case "Wood":
        return woodPerSec * 3600;

      case "Stone":
        return stonePerSec * 3600;

      case "Bread":
        return breadPerSec * 3600;

      case "Plank":
        return plankPerSec * 3600;

      case "Berries":
        return berriesPerSec * 3600;

      default:
        return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 980,
        height: 720,

        padding: const EdgeInsets.all(22),

        decoration: BoxDecoration(
          borderRadius:
              BorderRadius.circular(26),

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
          crossAxisAlignment:
              CrossAxisAlignment.start,

          children: [
            /// ===== HEADER =====
            Row(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Container(
                        width: 54,
                        height: 54,
                        padding:
                            const EdgeInsets.all(8),

                        decoration: BoxDecoration(
                          color: Colors.black
                              .withValues(
                            alpha: 0.18,
                          ),

                          borderRadius:
                              BorderRadius.circular(
                            14,
                          ),
                        ),

                        child: Image.asset(
                          "assets/icons/stats/gold_icon.png",

                          fit: BoxFit.contain,

                          filterQuality:
                              FilterQuality.none,
                        ),
                      ),

                      const SizedBox(width: 14),

                      Text(
                        "Ekonomia Osady",
                        style:
                            UiText.title(size: 30),
                      ),
                    ],
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

            const SizedBox(height: 22),

            Text(
              "Produkcja surowców",
              style: UiText.title(
                size: 22,
              ),
            ),

            const SizedBox(height: 14),

            Expanded(
            child: GridView.builder(
              physics:
                  const BouncingScrollPhysics(),

              gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,

                crossAxisSpacing: 12,
                mainAxisSpacing: 12,

                childAspectRatio: 4.8,
              ),

              itemCount:
                  settlement.resources.length,

              itemBuilder: (_, i) {
                final r =
                    settlement.resources[i];

                final data =
                    resourceData(r.code);

                final perHour =
                    rate(r.code);

                final positive =
                    perHour >= 0;

                return Container(
                  padding:
                      const EdgeInsets.symmetric(
                    horizontal: 14,
                  ),

                  decoration: BoxDecoration(
                    color: Colors.black.withValues(
                      alpha: 0.18,
                    ),

                    borderRadius:
                        BorderRadius.circular(16),

                    border: Border.all(
                      color: Colors.white10,
                    ),
                  ),

                  child: Row(
                    children: [
                      /// ===== IKONA =====
                      Container(
                        width: 46,
                        height: 46,

                        padding:
                            const EdgeInsets.all(4),

                        decoration: BoxDecoration(
                          color: Colors.black
                              .withValues(
                            alpha: 0.18,
                          ),

                          borderRadius:
                              BorderRadius.circular(
                            12,
                          ),
                        ),

                        child: Image.asset(
                          data["icon"]!,

                          fit: BoxFit.contain,

                          filterQuality:
                              FilterQuality.none,
                        ),
                      ),

                      const SizedBox(width: 12),

                      /// ===== NAZWA =====
                      Expanded(
                        child: Text(
                          data["name"]!,

                          overflow:
                              TextOverflow.ellipsis,

                          style: UiText.title(
                            size: 18,
                          ),
                        ),
                      ),

                      /// ===== ILOŚĆ =====
                      SizedBox(
                        width: 52,

                        child: Text(
                          r.amount
                              .toStringAsFixed(0),

                          textAlign:
                              TextAlign.center,

                          style: UiText.value(
                            size: 22,
                            color: UiColors.gold,
                          ),
                        ),
                      ),

                      const SizedBox(width: 12),

                      /// ===== PRODUKCJA =====
                      Container(
                        padding:
                            const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 8,
                        ),

                        decoration:
                            BoxDecoration(
                          color: Colors.black
                              .withValues(
                            alpha: 0.18,
                          ),

                          borderRadius:
                              BorderRadius.circular(
                            12,
                          ),
                        ),

                        child: Row(
                          children: [
                            Icon(
                              positive
                                  ? Icons
                                      .trending_up
                                  : Icons
                                      .trending_down,

                              size: 15,

                              color: positive
                                  ? Colors
                                      .greenAccent
                                  : Colors
                                      .redAccent,
                            ),

                            const SizedBox(
                              width: 4,
                            ),

                            Text(
                              "${positive ? "+" : ""}${perHour.toStringAsFixed(1)}/h",

                              style:
                                  UiText.value(
                                size: 16,

                                color: positive
                                    ? Colors
                                        .greenAccent
                                    : Colors
                                        .redAccent,
                              ),
                            ),
                          ],
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