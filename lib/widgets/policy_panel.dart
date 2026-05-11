import 'package:flutter/material.dart';

import '../api/models.dart';
import '../ui/ui_system.dart';

class PolicyPanel extends StatelessWidget {
  final Policy policy;
  final String? activeOptionId;

  final VoidCallback onClose;
  final Function(String optionId) onChoose;

  const PolicyPanel({
    super.key,
    required this.policy,
    required this.activeOptionId,
    required this.onClose,
    required this.onChoose,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 760,
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
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    "Polityka Osady",
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

            const SizedBox(height: 26),

            Container(
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                color: Colors.black.withValues(
                  alpha: 0.16,
                ),
                borderRadius:
                    BorderRadius.circular(22),
                border: Border.all(
                  color: Colors.white10,
                ),
              ),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.account_balance,
                        color: UiColors.gold,
                      ),

                      const SizedBox(width: 10),

                      Text(
                        "Polityka podatkowa",
                        style: UiText.title(
                          size: 24,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  Text(
                    "Określa poziom opodatkowania mieszkańców.",
                    style: UiText.body(),
                  ),

                  const SizedBox(height: 26),

                  Row(
                    children: policy.options.map(
                      (option) {
                        final selected =
                            activeOptionId ==
                                option.id;

                        return Expanded(
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(
                              horizontal: 4,
                            ),
                            child: SizedBox(
                              height: 72,
                              child: InkWell(
                                borderRadius:
                                    BorderRadius.circular(
                                  18,
                                ),
                                onTap: () =>
                                    onChoose(
                                  option.id,
                                ),
                                child: AnimatedContainer(
                                  duration:
                                      const Duration(
                                    milliseconds:
                                        180,
                                  ),
                                  decoration:
                                      BoxDecoration(
                                    color: selected
                                        ? UiColors
                                            .gold
                                        : Colors
                                            .black
                                            .withValues(
                                            alpha:
                                                0.22,
                                          ),
                                    borderRadius:
                                        BorderRadius.circular(
                                      18,
                                    ),
                                    border:
                                        Border.all(
                                      color: selected
                                          ? UiColors
                                              .gold
                                          : Colors
                                              .white10,
                                      width:
                                          selected
                                              ? 2
                                              : 1,
                                    ),
                                    boxShadow:
                                        selected
                                            ? [
                                                BoxShadow(
                                                  color: UiColors.gold.withValues(
                                                    alpha:
                                                        0.35,
                                                  ),
                                                  blurRadius:
                                                      12,
                                                ),
                                              ]
                                            : [],
                                  ),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment
                                            .center,
                                    children: [
                                      Text(
                                        option.label
                                            .replaceAll(
                                          " podatki",
                                          "",
                                        ),
                                        textAlign:
                                            TextAlign
                                                .center,
                                        style:
                                            UiText.title(
                                          size: 18,
                                        ).copyWith(
                                          color: selected
                                              ? Colors
                                                  .white
                                              : Colors
                                                  .white70,
                                        ),
                                      ),

                                      if (selected)
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(
                                            top: 6,
                                          ),
                                          child:
                                              Container(
                                            padding:
                                                const EdgeInsets.symmetric(
                                              horizontal:
                                                  10,
                                              vertical:
                                                  4,
                                            ),
                                            decoration:
                                                BoxDecoration(
                                              color: Colors
                                                  .green,
                                              borderRadius:
                                                  BorderRadius.circular(
                                                20,
                                              ),
                                            ),
                                            child:
                                                const Text(
                                              "AKTYWNA",
                                              style:
                                                  TextStyle(
                                                color: Colors
                                                    .white,
                                                fontWeight:
                                                    FontWeight.bold,
                                                fontSize:
                                                    11,
                                              ),
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ).toList(),
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