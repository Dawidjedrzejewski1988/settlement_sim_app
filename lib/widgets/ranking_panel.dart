import 'package:flutter/material.dart';

import '../api/models.dart';
import '../ui/ui_system.dart';

class RankingPanel extends StatelessWidget {
  final List<RankingEntry> ranking;

  final VoidCallback onClose;

  const RankingPanel({
    super.key,
    required this.ranking,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 920,
        height: 720,

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
              Color(0xFF6B3610),
              Color(0xFF3A1906),
              Color(0xFF190902),
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

            Row(
              children: [

                Expanded(
                  child: Text(
                    "Ranking Graczy",
                    style: UiText.title(size: 34),
                  ),
                ),

                InkWell(
                  onTap: onClose,

                  borderRadius: BorderRadius.circular(12),

                  child: Container(
                    width: 42,
                    height: 42,

                    alignment: Alignment.center,

                    decoration: BoxDecoration(
                      color: Colors.black26,
                      borderRadius: BorderRadius.circular(12),
                    ),

                    child: const Icon(
                      Icons.close,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            Expanded(
              child: ListView.builder(
                itemCount: ranking.length,

                itemBuilder: (context, index) {
                  final entry = ranking[index];

                  final isTop1 = index == 0;
                  final isTop2 = index == 1;
                  final isTop3 = index == 2;

                  Color borderColor = Colors.white10;

                  if (isTop1) borderColor = Colors.amber;
                  if (isTop2) borderColor = Colors.grey;
                  if (isTop3) borderColor = Colors.brown;

                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),

                    padding: const EdgeInsets.all(18),

                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.22),

                      borderRadius: BorderRadius.circular(22),

                      border: Border.all(
                        color: borderColor,
                        width: 1.5,
                      ),
                    ),

                    child: Row(
                      children: [

                        Container(
                          width: 62,
                          alignment: Alignment.center,

                          child: Text(
                            "#${index + 1}",

                            style: UiText.title(size: 30).copyWith(
                              color: isTop1
                                  ? Colors.amber
                                  : Colors.white,
                            ),
                          ),
                        ),

                        const SizedBox(width: 12),

                        Expanded(
                          flex: 3,

                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,

                            children: [

                              Text(
                                entry.username,

                                style: UiText.title(size: 22),
                              ),
                            ],
                          ),
                        ),

                        statBox(
                          icon: "👥",
                          value: entry.population.toString(),
                        ),

                        statBox(
                          icon: "😊",
                          value: "${entry.morale.toStringAsFixed(0)}%",
                        ),

                        statBox(
                          icon: "💰",
                          value: entry.money.toStringAsFixed(0),
                        ),

                        SizedBox(
                          width: 140,

                          child: Align(
                            alignment: Alignment.centerRight,

                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,

                              children: [

                                Text(
                                  "WYNIK",

                                  style: UiText.body(size: 10).copyWith(
                                    color: Colors.white54,
                                  ),
                                ),

                                Text(
                                  entry.score.toStringAsFixed(0),

                                  style: UiText.title(size: 28).copyWith(
                                    color: UiColors.gold,
                                  ),
                                ),
                              ],
                            ),
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

  Widget statBox({
    required String icon,
    required String value,
  }) {
    return SizedBox(
      width: 100,

      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,

        children: [

          Text(
            icon,
            style: const TextStyle(fontSize: 16),
          ),

          const SizedBox(width: 6),

          Text(
            value,
            style: UiText.body(),
          ),
        ],
      ),
    );
  }
}