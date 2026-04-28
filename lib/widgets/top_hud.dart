// lib/widgets/top_hud.dart

import 'package:flutter/material.dart';
import '../ui/ui_system.dart';

class TopHud extends StatelessWidget {
  final double wood;
  final double plank;
  final double berries;
  final double stone;
  final double bread;

  final double money;
  final double morale;
  final int population;

  const TopHud({
    super.key,
    required this.wood,
    required this.plank,
    required this.berries,
    required this.stone,
    required this.bread,
    required this.money,
    required this.population,
    required this.morale,
  });

  Widget statCard({
    required String icon,
    required String title,
    required Widget value,
  }) {
    return Container(
      width: 118,
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 8,
      ),
      decoration: UiDecor.card(),
      child: Row(
        children: [
          Text(
            icon,
            style: const TextStyle(fontSize: 20),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  overflow: TextOverflow.ellipsis,
                  style: UiText.body(size: 11),
                ),
                const SizedBox(height: 2),
                value,
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget animatedValue({
    required String text,
    required Color color,
  }) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 450),
      transitionBuilder: (child, animation) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, 0.35),
            end: Offset.zero,
          ).animate(animation),
          child: FadeTransition(
            opacity: animation,
            child: child,
          ),
        );
      },
      child: Text(
        text,
        key: ValueKey(text),
        overflow: TextOverflow.ellipsis,
        style: UiText.value(
          size: 18,
          color: color,
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

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 12,
      left: 12,
      right: 12,
      child: SafeArea(
        child: UiPanel(
          padding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 10,
          ),
          child: Row(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      statCard(
                        icon: "🪵",
                        title: "Drewno",
                        value: animatedValue(
                          text: wood.toInt().toString(),
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 8),
                      statCard(
                        icon: "🪚",
                        title: "Deski",
                        value: animatedValue(
                          text: plank.toInt().toString(),
                          color: Colors.orangeAccent,
                        ),
                      ),
                      const SizedBox(width: 8),
                      statCard(
                        icon: "🍓",
                        title: "Jagody",
                        value: animatedValue(
                          text: berries.toInt().toString(),
                          color: Colors.redAccent,
                        ),
                      ),
                      const SizedBox(width: 8),
                      statCard(
                        icon: "🪨",
                        title: "Kamień",
                        value: animatedValue(
                          text: stone.toInt().toString(),
                          color: Colors.grey.shade300,
                        ),
                      ),
                      const SizedBox(width: 8),
                      statCard(
                        icon: "🍞",
                        title: "Chleb",
                        value: animatedValue(
                          text: bread.toInt().toString(),
                          color: Colors.amber,
                        ),
                      ),
                      const SizedBox(width: 8),
                      statCard(
                        icon: "💰",
                        title: "Monety",
                        value: animatedValue(
                          text: money.toInt().toString(),
                          color: Colors.yellowAccent,
                        ),
                      ),
                      const SizedBox(width: 8),
                      statCard(
                        icon: "👥",
                        title: "Ludność",
                        value: animatedValue(
                          text: population.toString(),
                          color: Colors.lightBlueAccent,
                        ),
                      ),
                      const SizedBox(width: 8),
                      statCard(
                        icon: "😊",
                        title: "Morale",
                        value: animatedValue(
                          text: "${morale.toStringAsFixed(0)}%",
                          color: moraleColor(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),
              SizedBox(
                width: 130,
                child: UiButton(
                  text: "Wyjdź",
                  icon: Icons.logout,
                  color: UiColors.blue,
                  onTap: () {
                    Navigator.pop(context);
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
