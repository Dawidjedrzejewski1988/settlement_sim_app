import 'package:flutter/material.dart';
import '../ui/ui_system.dart';

class TopHud extends StatelessWidget {
  final double wood;
  final double plank;
  final double berries;
  final double stone;
  final double bread;
  final double flour;
  final double wheat;
  final double stoneTools;

  final double money;
  final double morale;
  final double moralePerHour;

  final List<String> moraleBreakdown;

  final int population;

  const TopHud({
    super.key,
    required this.wood,
    required this.plank,
    required this.berries,
    required this.stone,
    required this.bread,
    required this.flour,
    required this.wheat,
    required this.stoneTools,
    required this.money,
    required this.population,
    required this.morale,
    required this.moralePerHour,
    required this.moraleBreakdown,
  });

  Widget hudItem({
    required String iconPath,
    required String tooltip,
    required String value,
    required Color color,
  }) {
    return Tooltip(
      message: tooltip,
      preferBelow: false,

      decoration: BoxDecoration(
        color: const Color(0xFF1B120D),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: UiColors.gold.withValues(
            alpha: 0.4,
          ),
        ),
      ),

      textStyle: const TextStyle(
        color: Colors.white,
        fontSize: 13,
      ),

      child: Container(
        width: 96,
        padding: const EdgeInsets.symmetric(
          horizontal: 6,
          vertical: 3,
        ),

        decoration: BoxDecoration(
          color: const Color(0x5520120C),

          borderRadius:
              BorderRadius.circular(12),

          border: Border.all(
            color: Colors.white.withValues(
              alpha: 0.06,
            ),
          ),
        ),

        child: Row(
          children: [
            Image.asset(
              iconPath,
              width: 36,
              height: 36,
              fit: BoxFit.contain,
              filterQuality:
                  FilterQuality.none,
            ),

            const SizedBox(width: 4),

            AnimatedSwitcher(
              duration: const Duration(
                milliseconds: 200,
              ),

              child: Text(
                value,
                key: ValueKey(value),

                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                  height: 1,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color moraleColor() {
    if (morale >= 70) {
      return Colors.greenAccent;
    }

    if (morale >= 40) {
      return Colors.orangeAccent;
    }

    return Colors.redAccent;
  }

  String moraleTooltip() {
    final buffer = StringBuffer();

    buffer.writeln(
      "Morale: ${morale.toStringAsFixed(0)}%",
    );

    buffer.writeln();

    if (moralePerHour > 0) {
      buffer.writeln(
        "Zmiana: +${moralePerHour.toStringAsFixed(1)}/h",
      );
    } else {
      buffer.writeln(
        "Zmiana: ${moralePerHour.toStringAsFixed(1)}/h",
      );
    }

    if (moraleBreakdown.isNotEmpty) {
      buffer.writeln();
      buffer.writeln("Źródła:");

      for (final entry in moraleBreakdown) {
        buffer.writeln("• $entry");
      }
    }

    return buffer.toString();
  }

@override
Widget build(BuildContext context) {
  return Positioned(
    top: 12,
    left: 0,
    right: 0,

    child: SafeArea(
      child: Stack(
        children: [
          Align(
            alignment: Alignment.topCenter,

            child: UiPanel(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 4,
              ),

              child: Wrap(
                spacing: 6,
                runSpacing: 6,
                crossAxisAlignment:
                    WrapCrossAlignment.center,

                children: [
                  hudItem(
                    iconPath:
                        "assets/icons/resources/wood_icon.png",
                    tooltip: "Drewno",
                    value: wood.toInt().toString(),
                    color: Colors.white,
                  ),

                  hudItem(
                    iconPath:
                        "assets/icons/resources/plank_icon.png",
                    tooltip: "Deski",
                    value: plank.toInt().toString(),
                    color: Colors.orangeAccent,
                  ),

                  hudItem(
                    iconPath:
                        "assets/icons/resources/berries_icon.png",
                    tooltip: "Jagody",
                    value: berries.toInt().toString(),
                    color: Colors.redAccent,
                  ),

                  hudItem(
                    iconPath:
                        "assets/icons/resources/stone_icon.png",
                    tooltip: "Kamień",
                    value: stone.toInt().toString(),
                    color: Colors.grey.shade300,
                  ),

                  hudItem(
                    iconPath:
                        "assets/icons/resources/bread_icon.png",
                    tooltip: "Chleb",
                    value: bread.toInt().toString(),
                    color: Colors.amber,
                  ),

                  hudItem(
                    iconPath:
                        "assets/icons/resources/flour_icon.png",
                    tooltip: "Mąka",
                    value: flour.toInt().toString(),
                    color: Colors.white,
                  ),

                  hudItem(
                    iconPath:
                        "assets/icons/resources/wheat_icon.png",
                    tooltip: "Pszenica",
                    value: wheat.toInt().toString(),
                    color: Colors.amberAccent,
                  ),

                  hudItem(
                    iconPath:
                        "assets/icons/resources/stonetools_icon.png",
                    tooltip: "Narzędzia",
                    value:
                        stoneTools.toInt().toString(),
                    color: Colors.cyanAccent,
                  ),

                  Container(
                    width: 1,
                    height: 22,
                    margin:
                        const EdgeInsets.symmetric(
                      horizontal: 4,
                    ),
                    color: Colors.white.withValues(
                      alpha: 0.12,
                    ),
                  ),

                  hudItem(
                    iconPath:
                        "assets/icons/stats/gold_icon.png",
                    tooltip: "Monety",
                    value: money.toInt().toString(),
                    color: Colors.yellowAccent,
                  ),

                  hudItem(
                    iconPath:
                        "assets/icons/stats/population_icon.png",
                    tooltip: "Ludność",
                    value: population.toString(),
                    color:
                        Colors.lightBlueAccent,
                  ),

                  hudItem(
                    iconPath:
                        "assets/icons/stats/morale_icon.png",
                    tooltip: moraleTooltip(),
                    value:
                        "${morale.toStringAsFixed(0)}%",
                    color: moraleColor(),
                  ),
                ],
              ),
            ),
          ),

          /// ===== PRZYCISK WYJŚCIA =====
          Positioned(
            right: 12,
            top: 0,

            child: SizedBox(
              width: 120,

              child: UiButton(
                text: "Wyjdź",
                icon: Icons.logout,
                color: UiColors.blue,

                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ),
          ),
        ],
      ),
    ),
  );
}}