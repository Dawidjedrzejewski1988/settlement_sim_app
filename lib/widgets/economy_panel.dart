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

  String icon(String code) {
    switch (code) {
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

  String name(String code) {
    switch (code) {
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
        return code;
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
        width: 1050,
        height: 760,
        padding: const EdgeInsets.all(24),
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
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    "Ekonomia Osady",
                    style: UiText.title(
                      size: 32,
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

            const SizedBox(height: 24),

            Text(
              "Zasoby",
              style: UiText.title(
                size: 24,
              ),
            ),

            const SizedBox(height: 18),

            Expanded(
              child: ListView.separated(
                physics:
                    const BouncingScrollPhysics(),
                itemCount:
                    settlement.resources.length,
                separatorBuilder:
                    (_, __) =>
                        const SizedBox(height: 14),
                itemBuilder: (_, i) {
                  final r =
                      settlement.resources[i];

                  final perHour =
                      rate(r.code);

                  return Container(
                    padding:
                        const EdgeInsets.symmetric(
                      horizontal: 22,
                      vertical: 18,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black
                          .withValues(
                        alpha: 0.18,
                      ),
                      borderRadius:
                          BorderRadius.circular(
                        22,
                      ),
                      border: Border.all(
                        color: Colors.white10,
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 72,
                          height: 72,
                          alignment:
                              Alignment.center,
                          decoration: BoxDecoration(
                            color: Colors.black
                                .withValues(
                              alpha: 0.18,
                            ),
                            borderRadius:
                                BorderRadius.circular(
                              18,
                            ),
                          ),
                          child: Text(
                            icon(r.code),
                            style:
                                const TextStyle(
                              fontSize: 38,
                            ),
                          ),
                        ),

                        const SizedBox(width: 18),

                        Expanded(
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment
                                    .start,
                            children: [
                              Text(
                                name(r.code),
                                style:
                                    UiText.title(
                                  size: 22,
                                ),
                              ),

                              const SizedBox(
                                height: 6,
                              ),

                              Text(
                                r.amount
                                    .toStringAsFixed(
                                  0,
                                ),
                                style:
                                    UiText.value(
                                  size: 28,
                                  color:
                                      UiColors
                                          .gold,
                                ),
                              ),
                            ],
                          ),
                        ),

                        Container(
                          padding:
                              const EdgeInsets.symmetric(
                            horizontal: 18,
                            vertical: 12,
                          ),
                          decoration:
                              BoxDecoration(
                            color: Colors.black
                                .withValues(
                              alpha: 0.18,
                            ),
                            borderRadius:
                                BorderRadius.circular(
                              16,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.end,
                            children: [
                              Text(
                                "${perHour >= 0 ? "+" : ""}${perHour.toStringAsFixed(1)}/h",
                                style:
                                    UiText.value(
                                  size: 20,
                                  color:
                                      perHour >= 0
                                          ? Colors
                                              .greenAccent
                                          : Colors
                                              .redAccent,
                                ),
                              ),

                              const SizedBox(
                                height: 4,
                              ),

                              Text(
                                "na godzinę",
                                style:
                                    UiText.body(
                                  size: 12,
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