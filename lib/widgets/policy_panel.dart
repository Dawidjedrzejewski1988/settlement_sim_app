import 'package:flutter/material.dart';

import '../api/models.dart';
import '../ui/ui_system.dart';

class PolicyPanel extends StatefulWidget {
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
  State<PolicyPanel> createState() =>
      _PolicyPanelState();
}

class _PolicyPanelState
    extends State<PolicyPanel> {

  String selectedType = "tax";

  Policy get currentPolicy {
    switch (selectedType) {

      case "food":
        return widget.foodPolicy;

      case "work":
        return widget.workPolicy;

      default:
        return widget.taxPolicy;
    }
  }

  String? get currentActive {
    switch (selectedType) {

      case "food":
        return widget.activeFoodPolicy;

      case "work":
        return widget.activeWorkPolicy;

      default:
        return widget.activeTaxPolicy;
    }
  }

  IconData get currentIcon {
    switch (selectedType) {

      case "food":
        return Icons.restaurant;

      case "work":
        return Icons.work;

      default:
        return Icons.account_balance;
    }
  }

  String get currentTitle {
    switch (selectedType) {

      case "food":
        return "Polityka żywnościowa";

      case "work":
        return "Polityka pracy";

      default:
        return "Polityka podatkowa";
    }
  }

  String get currentDescription {
    switch (selectedType) {

      case "food":
        return "Kontroluje zużycie żywności oraz morale mieszkańców.";

      case "work":
        return "Wpływa na wydajność pracy i rozwój populacji.";

      default:
        return "Wpływa na dochody osady oraz zadowolenie mieszkańców.";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 1180,
        height: 760,

        padding: const EdgeInsets.all(24),

        decoration: BoxDecoration(
          borderRadius:
              BorderRadius.circular(30),

          border: Border.all(
            color: UiColors.gold,
            width: 2,
          ),

          gradient: const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,

            colors: [
              Color(0xFF6B3610),
              Color(0xFF341505),
              Color(0xFF140601),
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
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,

                    children: [

                      Text(
                        "POLITYKA OSADY",
                        style:
                            UiText.title(size: 36),
                      ),

                      const SizedBox(height: 4),

                      Text(
                        "Zarządzaj podatkami, żywnością i warunkami pracy mieszkańców.",
                        style:
                            UiText.body(size: 14),
                      ),
                    ],
                  ),
                ),

                InkWell(
                  onTap: widget.onClose,

                  borderRadius:
                      BorderRadius.circular(14),

                  child: Container(
                    width: 48,
                    height: 48,

                    decoration: BoxDecoration(
                      color: Colors.black26,

                      borderRadius:
                          BorderRadius.circular(
                        14,
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

            const SizedBox(height: 24),

            Expanded(
              child: Row(
                children: [

                  /// LEFT
                  Container(
                    width: 280,

                    padding:
                        const EdgeInsets.all(18),

                    decoration: BoxDecoration(
                      color: Colors.black
                          .withValues(alpha: 0.18),

                      borderRadius:
                          BorderRadius.circular(
                        24,
                      ),

                      border: Border.all(
                        color: UiColors.gold
                            .withValues(
                          alpha: 0.12,
                        ),
                      ),
                    ),

                    child: Column(
                      children: [

                        categoryButton(
                          type: "tax",
                          icon:
                              Icons.account_balance,
                          title:
                              "Polityka podatkowa",
                        ),

                        const SizedBox(height: 14),

                        categoryButton(
                          type: "food",
                          icon: Icons.restaurant,
                          title:
                              "Polityka żywnościowa",
                        ),

                        const SizedBox(height: 14),

                        categoryButton(
                          type: "work",
                          icon: Icons.work,
                          title:
                              "Polityka pracy",
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(width: 22),

                  /// RIGHT
                  Expanded(
                    child: Container(
                      padding:
                          const EdgeInsets.all(26),

                      decoration: BoxDecoration(
                        color: Colors.black
                            .withValues(alpha: 0.18),

                        borderRadius:
                            BorderRadius.circular(
                          28,
                        ),

                        border: Border.all(
                          color: UiColors.gold
                              .withValues(
                            alpha: 0.12,
                          ),
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
                                width: 78,
                                height: 78,

                                decoration:
                                    BoxDecoration(
                                  shape:
                                      BoxShape.circle,

                                  border: Border.all(
                                    color: UiColors
                                        .gold
                                        .withValues(
                                      alpha: 0.35,
                                    ),
                                  ),
                                ),

                                child: Icon(
                                  currentIcon,
                                  color:
                                      UiColors.gold,
                                  size: 38,
                                ),
                              ),

                              const SizedBox(
                                  width: 20),

                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment
                                          .start,

                                  children: [

                                    Text(
                                      currentTitle,
                                      style:
                                          UiText.title(
                                        size: 34,
                                      ),
                                    ),

                                    const SizedBox(
                                        height: 6),

                                    Text(
                                      currentDescription,
                                      style:
                                          UiText.body(
                                        size: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 30),

                          Text(
                            "DOSTĘPNE POLITYKI",
                            style:
                                UiText.title(size: 22),
                          ),

                          const SizedBox(height: 18),

                          Expanded(
                            child: ListView.builder(
                              itemCount:
                                  currentPolicy
                                      .options.length,

                              itemBuilder: (_, i) {

                                final option =
                                    currentPolicy
                                        .options[i];

                                final selected =
                                    option.id ==
                                        currentActive;

                                return Material(
                                  color:
                                      Colors.transparent,

                                  child: InkWell(
                                    borderRadius:
                                        BorderRadius
                                            .circular(
                                      18,
                                    ),

                                    onTap: () {
                                      widget.onChoose(
                                        selectedType,
                                        option.id,
                                      );
                                    },

                                    child:
                                        AnimatedContainer(
                                      duration:
                                          const Duration(
                                        milliseconds:
                                            180,
                                      ),

                                      margin:
                                          const EdgeInsets
                                              .only(
                                        bottom: 12,
                                      ),

                                      padding:
                                          const EdgeInsets
                                              .symmetric(
                                        horizontal: 18,
                                        vertical: 14,
                                      ),

                                      decoration:
                                          BoxDecoration(
                                        color: selected
                                            ? UiColors
                                                .gold
                                                .withValues(
                                                alpha:
                                                    0.16,
                                              )
                                            : Colors
                                                .black26,

                                        borderRadius:
                                            BorderRadius
                                                .circular(
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
                                      ),

                                      child: Row(
                                        children: [

                                          /// ICON
                                          Container(
                                            width: 58,
                                            height: 58,

                                            decoration:
                                                BoxDecoration(
                                              color: Colors
                                                  .black26,

                                              borderRadius:
                                                  BorderRadius
                                                      .circular(
                                                16,
                                              ),
                                            ),

                                            child: Icon(
                                              currentIcon,
                                              color:
                                                  UiColors
                                                      .gold,
                                              size: 28,
                                            ),
                                          ),

                                          const SizedBox(
                                              width:
                                                  18),

                                          /// NAME + EFFECTS
                                          Expanded(
                                            child:
                                                Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment
                                                      .start,

                                              children: [

                                                Row(
                                                  children: [

                                                    Text(
                                                      option
                                                          .label,

                                                      style:
                                                          TextStyle(
                                                        color:
                                                            selected
                                                                ? Colors.white
                                                                : Colors.white70,

                                                        fontSize:
                                                            24,

                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),

                                                    const SizedBox(
                                                        width:
                                                            18),

                                                    Expanded(
                                                      child:
                                                          Wrap(
                                                        spacing:
                                                            8,
                                                        runSpacing:
                                                            8,

                                                        children: option.effects
                                                            .map(
                                                          (
                                                            e,
                                                          ) {
                                                            return buildEffect(
                                                              e,
                                                            );
                                                          },
                                                        ).toList(),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),

                                          const SizedBox(
                                              width:
                                                  14),

                                          /// ACTIVE
                                          if (selected)
                                            Container(
                                              padding:
                                                  const EdgeInsets
                                                      .symmetric(
                                                horizontal:
                                                    14,
                                                vertical:
                                                    8,
                                              ),

                                              decoration:
                                                  BoxDecoration(
                                                color:
                                                    Colors
                                                        .green,

                                                borderRadius:
                                                    BorderRadius.circular(
                                                  20,
                                                ),
                                              ),

                                              child:
                                                  const Row(
                                                children: [

                                                  Icon(
                                                    Icons
                                                        .check,
                                                    size:
                                                        16,
                                                    color:
                                                        Colors.white,
                                                  ),

                                                  SizedBox(
                                                      width:
                                                          6),

                                                  Text(
                                                    "AKTYWNA",

                                                    style:
                                                        TextStyle(
                                                      color:
                                                          Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize:
                                                          11,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
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

  Widget categoryButton({
    required String type,
    required IconData icon,
    required String title,
  }) {

    final selected =
        selectedType == type;

    return Material(
      color: Colors.transparent,

      child: InkWell(
        borderRadius:
            BorderRadius.circular(18),

        onTap: () {
          setState(() {
            selectedType = type;
          });
        },

        child: AnimatedContainer(
          duration:
              const Duration(milliseconds: 180),

          padding:
              const EdgeInsets.all(16),

          decoration: BoxDecoration(
            color: selected
                ? UiColors.gold.withValues(
                    alpha: 0.16,
                  )
                : Colors.black26,

            borderRadius:
                BorderRadius.circular(18),

            border: Border.all(
              color: selected
                  ? UiColors.gold
                  : Colors.white10,

              width: selected ? 2 : 1,
            ),
          ),

          child: Row(
            children: [

              Container(
                width: 52,
                height: 52,

                decoration: BoxDecoration(
                  color: Colors.black26,

                  borderRadius:
                      BorderRadius.circular(16),
                ),

                child: Icon(
                  icon,
                  color: UiColors.gold,
                  size: 26,
                ),
              ),

              const SizedBox(width: 14),

              Expanded(
                child: Text(
                  title,
                  style:
                      UiText.title(size: 18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildEffect(
    PolicyEffect effect,
  ) {

    IconData icon = Icons.info;

    String text = "";

    bool positive = true;

    switch (effect.type) {

      case "tax_rate":

        final percent =
            ((effect.value - 1) * 100)
                .round();

        icon = Icons.attach_money;

        text =
            "${percent > 0 ? "+" : ""}$percent% podatki";

        positive = percent > 0;

        break;

      case "morale":

        icon = Icons.sentiment_satisfied;

        text =
            "${effect.value > 0 ? "+" : ""}${effect.value.toInt()} morale";

        positive = effect.value > 0;

        break;

      case "food_consumption":

        final percent =
            ((effect.value - 1) * 100)
                .round();

        icon = Icons.restaurant;

        text =
            "${percent > 0 ? "+" : ""}$percent% żywność";

        positive = percent < 0;

        break;

      case "production_speed":

        final percent =
            ((effect.value - 1) * 100)
                .round();

        icon = Icons.factory;

        text =
            "${percent > 0 ? "+" : ""}$percent% produkcja";

        positive = percent > 0;

        break;

      case "population_growth":

        final percent =
            ((effect.value - 1) * 100)
                .round();

        icon = Icons.groups;

        text =
            "${percent > 0 ? "+" : ""}$percent% populacja";

        positive = percent > 0;

        break;
    }

    return Container(
      padding:
          const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 6,
      ),

      decoration: BoxDecoration(
        color: positive
            ? Colors.green.withValues(
                alpha: 0.14,
              )
            : Colors.red.withValues(
                alpha: 0.14,
              ),

        borderRadius:
            BorderRadius.circular(12),

        border: Border.all(
          color: positive
              ? Colors.green.withValues(
                  alpha: 0.35,
                )
              : Colors.red.withValues(
                  alpha: 0.35,
                ),
        ),
      ),

      child: Row(
        mainAxisSize: MainAxisSize.min,

        children: [

          Icon(
            icon,
            size: 14,

            color: positive
                ? Colors.greenAccent
                : Colors.redAccent,
          ),

          const SizedBox(width: 5),

          Text(
            text,

            style: TextStyle(
              color: positive
                  ? Colors.greenAccent
                  : Colors.redAccent,

              fontWeight:
                  FontWeight.bold,

              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}