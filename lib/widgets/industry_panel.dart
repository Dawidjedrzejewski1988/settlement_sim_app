import 'package:flutter/material.dart';
import '../api/models.dart';
import '../ui/ui_system.dart';

class IndustryPanel extends StatefulWidget {
  final List<Industry> industries;
  final VoidCallback onClose;

  const IndustryPanel({
    super.key,
    required this.industries,
    required this.onClose,
  });

  @override
  State<IndustryPanel> createState() => _IndustryPanelState();
}

class _IndustryPanelState extends State<IndustryPanel> {
  late Industry selectedIndustry;

  @override
  void initState() {
    super.initState();
    selectedIndustry = widget.industries.first;
  }

  IconData getIcon(String type) {
    switch (type) {
      case "Wood":
        return Icons.forest;
      case "Farming":
        return Icons.agriculture;
      default:
        return Icons.auto_awesome;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 1100,
        height: 720,
        padding: const EdgeInsets.all(22),
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
              Color(0xFF6A3813),
              Color(0xFF3B1C08),
              Color(0xFF1B0B03),
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
                  child: Text(
                    "Rozwój Przemysłu",
                    style: UiText.title(size: 34),
                  ),
                ),
                IconButton(
                  onPressed: widget.onClose,
                  icon: const Icon(Icons.close, color: Colors.white),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              "Rozwijaj specjalizacje osady i odblokowuj nowe bonusy produkcyjne.",
              style: UiText.body(),
            ),
            const SizedBox(height: 22),
            Expanded(
              child: Row(
                children: [
                  /// LEFT
                  SizedBox(
                    width: 320,
                    child: Column(
                      children: [
                        Expanded(
                          child: ListView.separated(
                            itemCount: widget.industries.length,
                            separatorBuilder: (_, __) =>
                                const SizedBox(height: 14),
                            itemBuilder: (context, index) {
                              final industry = widget.industries[index];
                              final selected = selectedIndustry == industry;

                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    selectedIndustry = industry;
                                  });
                                },
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 180),
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(18),
                                    border: Border.all(
                                      color: selected
                                          ? UiColors.gold
                                          : UiColors.gold
                                              .withValues(alpha: 0.14),
                                    ),
                                    gradient: LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [
                                        const Color(0xFF241106),
                                        Colors.black.withValues(alpha: 0.18),
                                      ],
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 58,
                                        height: 58,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: UiColors.gold
                                                .withValues(alpha: 0.45),
                                          ),
                                        ),
                                        child: Icon(
                                          getIcon(industry.type),
                                          color: UiColors.gold,
                                          size: 30,
                                        ),
                                      ),
                                      const SizedBox(width: 14),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    industry.name ??
                                                        industry.type,
                                                    style:
                                                        UiText.title(size: 20),
                                                  ),
                                                ),
                                                Text(
                                                  "LVL ${industry.level}",
                                                  style: UiText.body(),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 6),
                                            Text(
                                              "${industry.xp.toStringAsFixed(0)} / ${industry.nextLevelXP.toStringAsFixed(0)} XP",
                                              style: UiText.body(size: 13),
                                            ),
                                            const SizedBox(height: 8),
                                            ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              child: LinearProgressIndicator(
                                                minHeight: 8,
                                                value:
                                                    industry.progressPercent /
                                                        100,
                                                backgroundColor: Colors.black54,
                                                valueColor:
                                                    const AlwaysStoppedAnimation(
                                                        UiColors.gold),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 14),
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(
                              color: UiColors.gold.withValues(alpha: 0.14),
                            ),
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                const Color(0xFF241106),
                                Colors.black.withValues(alpha: 0.18),
                              ],
                            ),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(Icons.lightbulb, color: UiColors.gold),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  "Im wyższy poziom specjalizacji, tym większe bonusy do produkcji.",
                                  style: UiText.body(),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(width: 18),

                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: UiColors.gold.withValues(alpha: 0.12),
                        ),
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Colors.black.withValues(alpha: 0.20),
                            const Color(0xFF140802),
                          ],
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 78,
                                height: 78,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: UiColors.gold.withValues(alpha: 0.4),
                                  ),
                                ),
                                child: Icon(
                                  getIcon(selectedIndustry.type),
                                  color: UiColors.gold,
                                  size: 40,
                                ),
                              ),
                              const SizedBox(width: 18),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      selectedIndustry.name ?? "",
                                      style: UiText.title(size: 34),
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      selectedIndustry.description ?? "",
                                      style: UiText.body(),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(14),
                                  border: Border.all(
                                    color:
                                        UiColors.gold.withValues(alpha: 0.35),
                                  ),
                                ),
                                child: Text(
                                  "LVL ${selectedIndustry.level}",
                                  style: UiText.title(size: 22),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 26),
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  "${selectedIndustry.xp.toStringAsFixed(0)} / ${selectedIndustry.nextLevelXP.toStringAsFixed(0)} XP",
                                  style: UiText.body(),
                                ),
                              ),
                              Text(
                                "${selectedIndustry.progressPercent.toStringAsFixed(0)}%",
                                style: UiText.body(),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: LinearProgressIndicator(
                              minHeight: 12,
                              value: selectedIndustry.progressPercent / 100,
                              backgroundColor: Colors.black54,
                              valueColor:
                                  const AlwaysStoppedAnimation(UiColors.gold),
                            ),
                          ),
                          const SizedBox(height: 28),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "AKTYWNE BONUSY",
                                  style: UiText.title(size: 20),
                                ),
                                const SizedBox(height: 18),
                                Wrap(
                                  spacing: 14,
                                  runSpacing: 14,
                                  children: selectedIndustry.rewards
                                      .where((r) => r.unlocked)
                                      .map((reward) {
                                    return Container(
                                      width: 300,
                                      padding: const EdgeInsets.all(14),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(16),
                                        color: Colors.green
                                            .withValues(alpha: 0.10),
                                        border: Border.all(
                                          color: Colors.green
                                              .withValues(alpha: 0.25),
                                        ),
                                      ),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            width: 34,
                                            height: 34,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Colors.green
                                                  .withValues(alpha: 0.20),
                                            ),
                                            child: const Icon(
                                              Icons.check,
                                              color: Colors.green,
                                              size: 18,
                                            ),
                                          ),
                                          const SizedBox(width: 12),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  reward.title,
                                                  style: UiText.title(size: 18),
                                                ),
                                                const SizedBox(height: 4),
                                                Text(
                                                  reward.description,
                                                  style: UiText.body(),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  }).toList(),
                                ),
                                const Spacer(),
                                Container(height: 1, color: Colors.white10),
                                const SizedBox(height: 24),
                                Text(
                                  "PROGRES SPECJALIZACJI",
                                  style: UiText.title(size: 20),
                                ),
                                const SizedBox(height: 24),
                                Expanded(
                                  child: Center(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: selectedIndustry.rewards
                                          .map((reward) {
                                        final unlocked = reward.unlocked;
                                        final current =
                                            selectedIndustry.level ==
                                                reward.level;

                                        return Row(
                                          children: [
                                            Tooltip(
                                              preferBelow: false,
                                              decoration: BoxDecoration(
                                                color: const Color(0xFF2A1608),
                                                borderRadius:
                                                    BorderRadius.circular(14),
                                                border: Border.all(
                                                  color: UiColors.gold
                                                      .withValues(alpha: 0.25),
                                                ),
                                              ),
                                              textStyle: UiText.body(),
                                              message:
                                                  "${reward.title}\n${reward.description}",
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  AnimatedContainer(
                                                    duration: const Duration(
                                                        milliseconds: 180),
                                                    width: 68,
                                                    height: 68,
                                                    decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      color: unlocked
                                                          ? Colors.green
                                                              .withValues(
                                                                  alpha: 0.18)
                                                          : current
                                                              ? UiColors.gold
                                                                  .withValues(
                                                                      alpha:
                                                                          0.18)
                                                              : Colors.black45,
                                                      border: Border.all(
                                                        color: unlocked
                                                            ? Colors.green
                                                            : current
                                                                ? UiColors.gold
                                                                : Colors
                                                                    .white24,
                                                        width: 2,
                                                      ),
                                                    ),
                                                    child: Icon(
                                                      unlocked
                                                          ? Icons.check
                                                          : current
                                                              ? Icons
                                                                  .radio_button_checked
                                                              : Icons.lock,
                                                      color: unlocked
                                                          ? Colors.green
                                                          : current
                                                              ? UiColors.gold
                                                              : Colors.white70,
                                                      size: 24,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 10),
                                                  Text(
                                                    "LVL ${reward.level}",
                                                    style:
                                                        UiText.body(size: 14),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            if (reward !=
                                                selectedIndustry.rewards.last)
                                              Container(
                                                width: 90,
                                                height: 2,
                                                margin:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 14),
                                                color: Colors.white24,
                                              ),
                                          ],
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
