import 'package:flutter/material.dart';

import '../api/models.dart';
import '../ui/ui_system.dart';

class IndustryPanel extends StatelessWidget {
  final List<Industry> industries;

  final VoidCallback onClose;

  const IndustryPanel({
    super.key,
    required this.industries,
    required this.onClose,
  });

  IconData getIcon(String type) {
    switch (type) {
      case "Wood":
        return Icons.forest;

      case "Stone":
        return Icons.landscape;

      case "Food":
        return Icons.agriculture;

      case "Crafting":
        return Icons.handyman;

      case "Trade":
        return Icons.store;

      default:
        return Icons.auto_awesome;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 900,
        height: 700,
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
                    "Technologie i Przemysł",
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
                itemCount: industries.length,
                separatorBuilder: (_, __) =>
                    const SizedBox(height: 14),
                itemBuilder: (context, index) {
                  final industry = industries[index];

                  return Container(
                    padding:
                        const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 16,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(
                        alpha: 0.20,
                      ),
                      borderRadius:
                          BorderRadius.circular(22),
                      border: Border.all(
                        color: Colors.white10,
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 72,
                          height: 72,
                          decoration: BoxDecoration(
                            color:
                                UiColors.gold.withValues(
                              alpha: 0.18,
                            ),
                            borderRadius:
                                BorderRadius.circular(
                              18,
                            ),
                          ),
                          child: Icon(
                            getIcon(industry.type),
                            color: UiColors.gold,
                            size: 38,
                          ),
                        ),

                        const SizedBox(width: 20),

                        Expanded(
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment
                                    .start,
                            mainAxisSize:
                                MainAxisSize.min,
                            children: [
                              Text(
                                industry.name ??
                                    industry.type,
                                style: UiText.title(
                                  size: 24,
                                ),
                              ),

                              const SizedBox(
                                height: 4,
                              ),

                              Text(
                                "Poziom ${industry.level}",
                                style:
                                    UiText.body(),
                              ),

                              const SizedBox(
                                height: 18,
                              ),

                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      "${industry.xp.toStringAsFixed(0)} / ${industry.nextLevelXP.toStringAsFixed(0)} XP",
                                      style:
                                          UiText.body(),
                                    ),
                                  ),

                                  Text(
                                    "${industry.progressPercent.toStringAsFixed(1)}%",
                                    style:
                                        UiText.body(),
                                  ),
                                ],
                              ),

                              const SizedBox(
                                height: 10,
                              ),

                              ClipRRect(
                                borderRadius:
                                    BorderRadius
                                        .circular(
                                  12,
                                ),
                                child:
                                    LinearProgressIndicator(
                                  minHeight: 14,
                                  value:
                                      industry.progressPercent /
                                          100,
                                  backgroundColor:
                                      Colors
                                          .black54,
                                  valueColor:
                                      const AlwaysStoppedAnimation(
                                    UiColors.gold,
                                  ),
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