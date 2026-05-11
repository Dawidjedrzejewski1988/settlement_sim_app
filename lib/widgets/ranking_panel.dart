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
        width: 900,
        height: 720,
        padding: const EdgeInsets.all(24),
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
        ),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    "Ranking",
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

            Expanded(
              child: ListView.separated(
                itemCount: ranking.length,
                separatorBuilder:
                    (_, __) =>
                        const SizedBox(
                  height: 12,
                ),
                itemBuilder:
                    (context, index) {
                  final entry =
                      ranking[index];

                  return Container(
                    padding:
                        const EdgeInsets.all(
                      18,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black
                          .withValues(
                        alpha: 0.20,
                      ),
                      borderRadius:
                          BorderRadius.circular(
                        22,
                      ),
                      border: Border.all(
                        color:
                            Colors.white10,
                      ),
                    ),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 60,
                          child: Text(
                            "#${index + 1}",
                            style:
                                UiText.title(
                              size: 28,
                            ),
                          ),
                        ),

                        Expanded(
                          flex: 3,
                          child: Text(
                            entry
                                .settlementName,
                            style:
                                UiText.title(
                              size: 24,
                            ),
                          ),
                        ),

                        Expanded(
                          child: Text(
                            "👥 ${entry.population}",
                            style:
                                UiText.body(),
                          ),
                        ),

                        Expanded(
                          child: Text(
                            "😊 ${entry.morale.toStringAsFixed(0)}%",
                            style:
                                UiText.body(),
                          ),
                        ),

                        Expanded(
                          child: Text(
                            "💰 ${entry.money.toStringAsFixed(0)}",
                            style:
                                UiText.body(),
                          ),
                        ),

                        Expanded(
                          child: Align(
                            alignment:
                                Alignment
                                    .centerRight,
                            child: Text(
                              entry.score
                                  .toStringAsFixed(
                                0,
                              ),
                              style:
                                  UiText.title(
                                size: 26,
                              ),
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
}