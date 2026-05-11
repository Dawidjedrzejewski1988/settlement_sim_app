import 'package:flutter/material.dart';

import '../api/models.dart';
import '../ui/ui_system.dart';

class EventPanel extends StatelessWidget {
  final List<Event> events;

  const EventPanel({
    super.key,
    required this.events,
  });

  String icon(String type) {
    switch (type) {
      case "Fire":
        return "🔥";

      case "Festival":
        return "🎉";

      case "Plague":
        return "☠️";

      case "Storm":
        return "⛈️";

      case "TradeBoom":
        return "💰";

      default:
        return "📜";
    }
  }

  String effect(String type) {
    switch (type) {
      case "Drought":
        return "-50% produkcji żywności";

      case "Fire":
        return "-30% produkcji drewna";

      case "Festival":
        return "+20 morale mieszkańców";

      case "Storm":
        return "-25% wydajności budynków";

      case "TradeBoom":
        return "+50% dochodu z handlu";

      case "Plague":
        return "-10 populacji";

      default:
        return "Nieznany efekt";
    }
  }

  String title(String type) {
    switch (type) {
      case "Drought":
        return "Susza";

      case "Fire":
        return "Pożar";

      case "Festival":
        return "Festiwal";

      case "Storm":
        return "Burza";

      case "TradeBoom":
        return "Boom handlowy";

      case "Plague":
        return "Zaraza";

      default:
        return type;
    }
  }

  String formatTime(int seconds) {
    final m = (seconds ~/ 60)
        .toString()
        .padLeft(2, '0');

    final s = (seconds % 60)
        .toString()
        .padLeft(2, '0');

    return "$m:$s";
  }

  @override
  Widget build(BuildContext context) {
    if (events.isEmpty) {
      return const SizedBox.shrink();
    }

    return Positioned(
      left: 18,
      top: 100,
      child: Container(
        width: 320,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius:
              BorderRadius.circular(22),
          border: Border.all(
            color: UiColors.gold,
          ),
          color: const Color(0xCC1F0D04),
          boxShadow: const [
            BoxShadow(
              color: Colors.black54,
              blurRadius: 12,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            Text(
              "Aktywne wydarzenia",
              style: UiText.title(size: 22),
            ),

            const SizedBox(height: 14),

            ...events.map((e) {
              return Container(
                margin:
                    const EdgeInsets.only(
                  bottom: 10,
                ),
                padding:
                    const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.black
                      .withValues(
                    alpha: 0.20,
                  ),
                  borderRadius:
                      BorderRadius.circular(
                    16,
                  ),
                  border: Border.all(
                    color: Colors.white10,
                  ),
                ),
                child: Row(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(
                      icon(e.type ?? ""),
                      style:
                          const TextStyle(
                        fontSize: 28,
                      ),
                    ),

                    const SizedBox(width: 12),

                    Expanded(
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment
                                .start,
                        children: [
                          Text(
                            title(e.type ?? ""),
                            style:
                                UiText.title(
                              size: 17,
                            ),
                          ),

                          const SizedBox(
                            height: 2,
                          ),

                          Text(
                            effect(
                              e.type ?? "",
                            ),
                            style:
                                UiText.body(
                              size: 13,
                            ),
                          ),

                          const SizedBox(
                            height: 6,
                          ),

                          Row(
                            children: [
                              const Icon(
                                Icons.timer,
                                size: 16,
                                color: UiColors
                                    .gold,
                              ),

                              const SizedBox(
                                width: 4,
                              ),

                              Text(
                                formatTime(
                                  e.remainingSeconds,
                                ),
                                style:
                                    UiText.body(
                                  size: 13,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}