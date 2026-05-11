import 'package:flutter/material.dart';
import '../ui/ui_system.dart';

Future<Map<String, dynamic>?> showCreateOfferDialog({
  required BuildContext context,
}) async {
  final qtyController = TextEditingController(
    text: "10",
  );

  final priceController = TextEditingController(
    text: "1",
  );

  String selected = "Wood";

  final resources = [
    {
      "code": "Wood",
      "name": "Drewno",
      "icon":
          "assets/icons/resources/wood_icon.png",
    },
    {
      "code": "Plank",
      "name": "Deski",
      "icon":
          "assets/icons/resources/plank_icon.png",
    },
    {
      "code": "Berries",
      "name": "Jagody",
      "icon":
          "assets/icons/resources/berries_icon.png",
    },
    {
      "code": "Stone",
      "name": "Kamień",
      "icon":
          "assets/icons/resources/stone_icon.png",
    },
    {
      "code": "StoneTools",
      "name": "Narzędzia",
      "icon":
          "assets/icons/resources/stonetools_icon.png",
    },
    {
      "code": "Wheat",
      "name": "Pszenica",
      "icon":
          "assets/icons/resources/wheat_icon.png",
    },
    {
      "code": "Flour",
      "name": "Mąka",
      "icon":
          "assets/icons/resources/flour_icon.png",
    },
    {
      "code": "Bread",
      "name": "Chleb",
      "icon":
          "assets/icons/resources/bread_icon.png",
    },
  ];

  return showDialog<Map<String, dynamic>>(
    context: context,
    barrierColor: Colors.black54,
    builder: (_) {
      return StatefulBuilder(
        builder: (context, setLocal) {
          final selectedData =
              resources.firstWhere(
            (e) =>
                e["code"].toString() ==
                selected,
          );

          return AlertDialog(
            backgroundColor:
                const Color(0xFF2B1407),

            shape: RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.circular(24),

              side: BorderSide(
                color: UiColors.gold
                    .withValues(alpha: 0.7),
                width: 2,
              ),
            ),

            titlePadding:
                const EdgeInsets.fromLTRB(
              24,
              20,
              20,
              0,
            ),

            contentPadding:
                const EdgeInsets.fromLTRB(
              24,
              20,
              24,
              12,
            ),

            actionsPadding:
                const EdgeInsets.fromLTRB(
              20,
              0,
              20,
              20,
            ),

            title: Row(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Container(
                        width: 52,
                        height: 52,
                        padding:
                            const EdgeInsets.all(8),

                        decoration: BoxDecoration(
                          color: Colors.black
                              .withValues(
                            alpha: 0.20,
                          ),

                          borderRadius:
                              BorderRadius.circular(
                            14,
                          ),

                          border: Border.all(
                            color: Colors.white
                                .withValues(
                              alpha: 0.06,
                            ),
                          ),
                        ),

                        child: Image.asset(
                          "assets/icons/stats/gold_icon.png",
                          fit: BoxFit.contain,
                          filterQuality:
                              FilterQuality.none,
                        ),
                      ),

                      const SizedBox(width: 14),

                      Text(
                        "Wystaw ofertę",
                        style:
                            UiText.title(size: 28),
                      ),
                    ],
                  ),
                ),

                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    Icons.close,
                    color: Colors.white,
                  ),
                ),
              ],
            ),

            content: SizedBox(
              width: 430,

              child: Column(
                mainAxisSize:
                    MainAxisSize.min,

                crossAxisAlignment:
                    CrossAxisAlignment.start,

                children: [
                  /// ===== SUROWIEC =====
                  Text(
                    "Surowiec",
                    style: UiText.body(
                      size: 15,
                    ),
                  ),

                  const SizedBox(height: 8),

                  PopupMenuButton<String>(
                    tooltip: "",

                    color:
                        const Color(0xFF2B1407),

                    shape:
                        RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(
                        16,
                      ),

                      side: BorderSide(
                        color: UiColors.gold
                            .withValues(
                          alpha: 0.5,
                        ),
                      ),
                    ),

                    onSelected: (v) {
                      setLocal(() {
                        selected = v;
                      });
                    },

                    itemBuilder: (context) {
                      return resources.map((e) {
                        final active =
                            e["code"] ==
                                selected;

                        return PopupMenuItem<
                            String>(
                          value:
                              e["code"].toString(),

                          padding:
                              const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),

                          child: Container(
                            padding:
                                const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 8,
                            ),

                            decoration:
                                BoxDecoration(
                              color: active
                                  ? UiColors.gold
                                      .withValues(
                                      alpha:
                                          0.14,
                                    )
                                  : Colors
                                      .transparent,

                              borderRadius:
                                  BorderRadius
                                      .circular(
                                12,
                              ),
                            ),

                            child: Row(
                              children: [
                                Image.asset(
                                  e["icon"]
                                      .toString(),

                                  width: 32,
                                  height: 32,

                                  fit: BoxFit
                                      .contain,

                                  filterQuality:
                                      FilterQuality
                                          .none,
                                ),

                                const SizedBox(
                                  width: 14,
                                ),

                                Text(
                                  e["name"]
                                      .toString(),

                                  style:
                                      const TextStyle(
                                    color: Colors
                                        .white,

                                    fontWeight:
                                        FontWeight
                                            .w600,

                                    fontSize:
                                        15,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList();
                    },

                    child: Container(
                      padding:
                          const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),

                      decoration: BoxDecoration(
                        color: Colors.black
                            .withValues(
                          alpha: 0.18,
                        ),

                        borderRadius:
                            BorderRadius.circular(
                          16,
                        ),

                        border: Border.all(
                          color: Colors.white12,
                        ),
                      ),

                      child: Row(
                        children: [
                          Container(
                            width: 46,
                            height: 46,
                            padding:
                                const EdgeInsets.all(
                              6,
                            ),

                            decoration:
                                BoxDecoration(
                              color: Colors.black
                                  .withValues(
                                alpha: 0.18,
                              ),

                              borderRadius:
                                  BorderRadius
                                      .circular(
                                12,
                              ),
                            ),

                            child: Image.asset(
                              selectedData[
                                      "icon"]
                                  .toString(),

                              fit: BoxFit.contain,

                              filterQuality:
                                  FilterQuality
                                      .none,
                            ),
                          ),

                          const SizedBox(
                            width: 14,
                          ),

                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment
                                      .start,

                              children: [
                                Text(
                                  selectedData[
                                          "name"]
                                      .toString(),

                                  style:
                                      const TextStyle(
                                    color: Colors
                                        .white,

                                    fontSize:
                                        17,

                                    fontWeight:
                                        FontWeight
                                            .w700,
                                  ),
                                ),

                                const SizedBox(
                                    height: 2),

                                Text(
                                  "Kliknij aby zmienić surowiec",

                                  style:
                                      TextStyle(
                                    color: Colors
                                        .white
                                        .withValues(
                                      alpha:
                                          0.5,
                                    ),

                                    fontSize:
                                        12,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const Icon(
                            Icons.expand_more,
                            color: Colors.white70,
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 18),

                  /// ===== PODGLĄD =====
                  Container(
                    padding:
                        const EdgeInsets.all(14),

                    decoration: BoxDecoration(
                      color: Colors.black
                          .withValues(
                        alpha: 0.14,
                      ),

                      borderRadius:
                          BorderRadius.circular(
                        18,
                      ),

                      border: Border.all(
                        color: Colors.white10,
                      ),
                    ),

                    child: Row(
                      children: [
                        Container(
                          width: 64,
                          height: 64,
                          padding:
                              const EdgeInsets.all(
                            8,
                          ),

                          decoration: BoxDecoration(
                            color: Colors.black
                                .withValues(
                              alpha: 0.20,
                            ),

                            borderRadius:
                                BorderRadius.circular(
                              14,
                            ),
                          ),

                          child: Image.asset(
                            selectedData["icon"]
                                .toString(),

                            fit: BoxFit.contain,

                            filterQuality:
                                FilterQuality.none,
                          ),
                        ),

                        const SizedBox(width: 14),

                        Expanded(
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment
                                    .start,

                            children: [
                              Text(
                                selectedData[
                                        "name"]
                                    .toString(),

                                style:
                                    UiText.title(
                                  size: 20,
                                ),
                              ),

                              const SizedBox(
                                  height: 4),

                              Text(
                                "Towar zostanie wystawiony na rynku osady.",

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
                  ),

                  const SizedBox(height: 18),

                  /// ===== ILOŚĆ =====
                  Text(
                    "Ilość",
                    style: UiText.body(
                      size: 15,
                    ),
                  ),

                  const SizedBox(height: 8),

                  TextField(
                    controller:
                        qtyController,

                    keyboardType:
                        TextInputType.number,

                    style: const TextStyle(
                      color: Colors.white,
                    ),

                    decoration: inputDecor(
                      hint: "Np. 50",
                      icon:
                          Icons.inventory_2_outlined,
                    ),
                  ),

                  const SizedBox(height: 18),

                  /// ===== CENA =====
                  Text(
                    "Cena za sztukę",
                    style: UiText.body(
                      size: 15,
                    ),
                  ),

                  const SizedBox(height: 8),

                  TextField(
                    controller:
                        priceController,

                    keyboardType:
                        TextInputType.number,

                    style: const TextStyle(
                      color: Colors.white,
                    ),

                    decoration: inputDecor(
                      hint: "Np. 3",
                      icon:
                          Icons.monetization_on,
                    ),
                  ),
                ],
              ),
            ),

            actions: [
              SizedBox(
                width: 150,
                height: 52,

                child: UiButton(
                  text: "Anuluj",
                  icon: Icons.close,
                  color: UiColors.red,

                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
              ),

              const SizedBox(width: 10),

              SizedBox(
                width: 190,
                height: 52,

                child: UiButton(
                  text: "Wystaw ofertę",
                  icon: Icons.store,
                  color: UiColors.gold,

                  onTap: () {
                    final qty =
                        double.tryParse(
                              qtyController.text,
                            ) ??
                            0;

                    final price =
                        double.tryParse(
                              priceController.text,
                            ) ??
                            0;

                    if (qty <= 0 ||
                        price <= 0) {
                      return;
                    }

                    Navigator.pop(
                      context,
                      {
                        "resourceType":
                            selected,
                        "quantity": qty,
                        "pricePerUnit":
                            price,
                      },
                    );
                  },
                ),
              ),
            ],
          );
        },
      );
    },
  );
}

InputDecoration inputDecor({
  String? hint,
  IconData? icon,
}) {
  return InputDecoration(
    hintText: hint,

    hintStyle: const TextStyle(
      color: Colors.white38,
    ),

    prefixIcon: icon != null
        ? Icon(
            icon,
            color: UiColors.gold,
          )
        : null,

    filled: true,

    fillColor: Colors.black.withValues(
      alpha: 0.18,
    ),

    contentPadding:
        const EdgeInsets.symmetric(
      horizontal: 16,
      vertical: 16,
    ),

    enabledBorder: OutlineInputBorder(
      borderRadius:
          BorderRadius.circular(16),

      borderSide: const BorderSide(
        color: Colors.white12,
      ),
    ),

    focusedBorder: OutlineInputBorder(
      borderRadius:
          BorderRadius.circular(16),

      borderSide: const BorderSide(
        color: UiColors.gold,
        width: 2,
      ),
    ),
  );
}