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
      "icon": "🪵",
    },
    {
      "code": "Plank",
      "name": "Deski",
      "icon": "🪚",
    },
    {
      "code": "Berries",
      "name": "Jagody",
      "icon": "🍓",
    },
    {
      "code": "Stone",
      "name": "Kamień",
      "icon": "🪨",
    },
    {
      "code": "StoneTools",
      "name": "Narzędzia",
      "icon": "🔨",
    },
    {
      "code": "Wheat",
      "name": "Pszenica",
      "icon": "🌾",
    },
    {
      "code": "Flour",
      "name": "Mąka",
      "icon": "⚪",
    },
    {
      "code": "Bread",
      "name": "Chleb",
      "icon": "🍞",
    },
  ];

  return showDialog<Map<String, dynamic>>(
    context: context,
    builder: (_) {
      return StatefulBuilder(
        builder: (context, setLocal) {
          return AlertDialog(
            backgroundColor: const Color(
              0xFF3A1D07,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(22),
              side: const BorderSide(
                color: UiColors.gold,
                width: 2,
              ),
            ),
            titlePadding: const EdgeInsets.fromLTRB(
              24,
              22,
              18,
              0,
            ),
            contentPadding: const EdgeInsets.all(24),
            actionsPadding: const EdgeInsets.fromLTRB(
              18,
              0,
              18,
              18,
            ),
            title: Row(
              children: [
                Expanded(
                  child: Text(
                    "Wystaw ofertę",
                    style: UiText.title(
                      size: 28,
                    ),
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
              width: 420,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Text(
                    "Surowiec",
                    style: UiText.body(),
                  ),

                  const SizedBox(height: 8),

                  Container(
                    padding:
                        const EdgeInsets.symmetric(
                      horizontal: 14,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(
                        alpha: 0.18,
                      ),
                      borderRadius:
                          BorderRadius.circular(16),
                      border: Border.all(
                        color: Colors.white12,
                      ),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: selected,
                        isExpanded: true,
                        dropdownColor:
                            const Color(0xFF3A1D07),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                        items: resources.map((e) {
                          return DropdownMenuItem<
                              String>(
                            value:
                                e["code"].toString(),
                            child: Row(
                              children: [
                                Text(
                                  e["icon"]
                                      .toString(),
                                  style:
                                      const TextStyle(
                                    fontSize: 22,
                                  ),
                                ),

                                const SizedBox(
                                  width: 12,
                                ),

                                Text(
                                  e["name"]
                                      .toString(),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                        onChanged: (v) {
                          if (v == null) {
                            return;
                          }

                          setLocal(() {
                            selected = v;
                          });
                        },
                      ),
                    ),
                  ),

                  const SizedBox(height: 18),

                  Text(
                    "Ilość",
                    style: UiText.body(),
                  ),

                  const SizedBox(height: 8),

                  TextField(
                    controller: qtyController,
                    keyboardType:
                        TextInputType.number,
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                    decoration: inputDecor(
                      hint: "Np. 50",
                    ),
                  ),

                  const SizedBox(height: 18),

                  Text(
                    "Cena za sztukę",
                    style: UiText.body(),
                  ),

                  const SizedBox(height: 8),

                  TextField(
                    controller: priceController,
                    keyboardType:
                        TextInputType.number,
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                    decoration: inputDecor(
                      hint: "Np. 3",
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
                width: 180,
                height: 52,
                child: UiButton(
                  text: "Wystaw ofertę",
                  icon: Icons.store,
                  color: UiColors.gold,
                  onTap: () {
                    final qty = double.tryParse(
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
}) {
  return InputDecoration(
    hintText: hint,
    hintStyle: const TextStyle(
      color: Colors.white38,
    ),
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