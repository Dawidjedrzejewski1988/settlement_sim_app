import 'package:flutter/material.dart';

import '../api/models.dart';
import '../ui/ui_system.dart';

class QuestPanel extends StatelessWidget {
  final QuestResponse quests;

  final VoidCallback onClose;

  const QuestPanel({
    super.key,
    required this.quests,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 850,
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
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    "Zadania",
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
              "Aktywne zadania",
              style: UiText.title(
                size: 24,
              ),
            ),

            const SizedBox(height: 14),

            Expanded(
              child: ListView(
                children: [
                  ...quests.active.map(
                    (quest) =>
                        buildQuestCard(
                      quest,
                      false,
                    ),
                  ),

                  if (quests.completed
                      .isNotEmpty) ...[
                    const SizedBox(
                      height: 26,
                    ),

                    Text(
                      "Ukończone",
                      style: UiText.title(
                        size: 24,
                      ),
                    ),

                    const SizedBox(
                      height: 14,
                    ),

                    ...quests.completed.map(
                      (quest) =>
                          buildQuestCard(
                        quest,
                        true,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildQuestCard(
    Quest quest,
    bool completed,
  ) {
    return Container(
      margin: const EdgeInsets.only(
        bottom: 14,
      ),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: completed
            ? Colors.green.withValues(
                alpha: 0.15,
              )
            : Colors.black.withValues(
                alpha: 0.22,
              ),
        borderRadius:
            BorderRadius.circular(22),
        border: Border.all(
          color: completed
              ? Colors.green
              : Colors.white10,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              color: completed
                  ? Colors.green
                      .withValues(
                      alpha: 0.18,
                    )
                  : UiColors.gold
                      .withValues(
                      alpha: 0.18,
                    ),
              borderRadius:
                  BorderRadius.circular(
                16,
              ),
            ),
            child: Icon(
              completed
                  ? Icons.check
                  : Icons.flag,
              color: completed
                  ? Colors.green
                  : UiColors.gold,
              size: 30,
            ),
          ),

          const SizedBox(width: 18),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  quest.description,
                  style: UiText.title(
                    size: 20,
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  completed
                      ? "Ukończone"
                      : "Etap ${quest.stage + 1}",
                  style: UiText.body(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}