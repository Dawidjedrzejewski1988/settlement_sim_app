import 'package:flutter/material.dart';

import '../api/models.dart';
import '../ui/ui_system.dart';

class PolicyPanel extends StatelessWidget {
  final Policy taxPolicy;
  final Policy foodPolicy;
  final Policy workPolicy;

  final String? activeTaxPolicy;
  final String? activeFoodPolicy;
  final String? activeWorkPolicy;

  final VoidCallback onClose;

  final Function(
    String type,
    String optionId,
  ) onChoose;

  const PolicyPanel({
    super.key,
    required this.taxPolicy,
    required this.foodPolicy,
    required this.workPolicy,
    required this.activeTaxPolicy,
    required this.activeFoodPolicy,
    required this.activeWorkPolicy,
    required this.onClose,
    required this.onChoose,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 980,
        height: 700,

        padding: const EdgeInsets.all(24),

        decoration: BoxDecoration(
          borderRadius:
              BorderRadius.circular(28),

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

            /// HEADER
            Row(
              children: [

                Expanded(
                  child: Text(
                    "Polityka Osady",
                    style:
                        UiText.title(size: 34),
                  ),
                ),

                InkWell(
                  onTap: onClose,

                  borderRadius:
                      BorderRadius.circular(
                    12,
                  ),

                  child: Container(
                    width: 42,
                    height: 42,

                    alignment: Alignment.center,

                    decoration: BoxDecoration(
                      color: Colors.black26,

                      borderRadius:
                          BorderRadius.circular(
                        12,
                      ),
                    ),

                    child: const Icon(
                      Icons.close,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [

                    buildPolicySection(
                      icon:
                          Icons.account_balance,

                      title:
                          "Polityka podatkowa",

                      description:
                          "Określa poziom podatków mieszkańców.",

                      type: "tax",

                      policy: taxPolicy,

                      activeOptionId:
                          activeTaxPolicy,
                    ),

                    const SizedBox(height: 16),

                    buildPolicySection(
                      icon: Icons.restaurant,

                      title:
                          "Polityka żywnościowa",

                      description:
                          "Kontroluje zużycie żywności oraz jakość racji.",

                      type: "food",

                      policy: foodPolicy,

                      activeOptionId:
                          activeFoodPolicy,
                    ),

                    const SizedBox(height: 16),

                    buildPolicySection(
                      icon: Icons.work,

                      title:
                          "Polityka pracy",

                      description:
                          "Wpływa na produkcję oraz wzrost populacji.",

                      type: "work",

                      policy: workPolicy,

                      activeOptionId:
                          activeWorkPolicy,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildPolicySection({
    required IconData icon,
    required String title,
    required String description,
    required String type,
    required Policy policy,
    required String? activeOptionId,
  }) {
    return Container(
      padding: const EdgeInsets.all(18),

      decoration: BoxDecoration(
        color: Colors.black.withValues(
          alpha: 0.14,
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

          /// TOP
          Row(
            children: [

              Container(
                width: 42,
                height: 42,

                decoration: BoxDecoration(
                  color: UiColors.gold
                      .withValues(
                    alpha: 0.12,
                  ),

                  borderRadius:
                      BorderRadius.circular(
                    12,
                  ),
                ),

                child: Icon(
                  icon,
                  color: UiColors.gold,
                  size: 22,
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
                      title,
                      style:
                          UiText.title(
                        size: 24,
                      ),
                    ),

                    const SizedBox(height: 2),

                    Text(
                      description,
                      style:
                          UiText.body(
                        size: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          /// BUTTONS
          Wrap(
            spacing: 10,
            runSpacing: 10,

            children:
                policy.options.map((option) {

              final selected =
                  activeOptionId ==
                      option.id;

              return InkWell(
                borderRadius:
                    BorderRadius.circular(
                  16,
                ),

                onTap: () {
                  onChoose(
                    type,
                    option.id,
                  );
                },

                child: AnimatedContainer(
                  duration:
                      const Duration(
                    milliseconds: 180,
                  ),

                  height: 52,

                  padding:
                      const EdgeInsets.symmetric(
                    horizontal: 18,
                  ),

                  decoration: BoxDecoration(
                    color: selected
                        ? UiColors.gold
                        : Colors.black
                            .withValues(
                            alpha: 0.22,
                          ),

                    borderRadius:
                        BorderRadius.circular(
                      16,
                    ),

                    border: Border.all(
                      color: selected
                          ? UiColors.gold
                          : Colors.white10,
                    ),

                    boxShadow: selected
                        ? [
                            BoxShadow(
                              color: UiColors
                                  .gold
                                  .withValues(
                                alpha: 0.25,
                              ),

                              blurRadius: 10,
                            ),
                          ]
                        : [],
                  ),

                  child: Row(
                    mainAxisSize:
                        MainAxisSize.min,

                    children: [

                      Text(
                        option.label,

                        style:
                            UiText.title(
                          size: 15,
                        ).copyWith(
                          color: selected
                              ? Colors.white
                              : Colors.white70,
                        ),
                      ),

                      if (selected) ...[

                        const SizedBox(
                            width: 10),

                        Container(
                          padding:
                              const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 3,
                          ),

                          decoration:
                              BoxDecoration(
                            color:
                                Colors.green,

                            borderRadius:
                                BorderRadius.circular(
                              20,
                            ),
                          ),

                          child: const Text(
                            "AKTYWNA",

                            style: TextStyle(
                              color:
                                  Colors.white,

                              fontWeight:
                                  FontWeight.bold,

                              fontSize: 9,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}