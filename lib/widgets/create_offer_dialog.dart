// lib/widgets/create_offer_dialog.dart

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
    "Wood",
    "Plank",
    "Berries",
    "Stone",
    "StoneTools",
    "Wheat",
    "Flour",
    "Bread",
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
              borderRadius: BorderRadius.circular(18),
              side: const BorderSide(
                color: UiColors.gold,
                width: 2,
              ),
            ),
            title: const Text(
              "Wystaw ofertę",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            content: SizedBox(
              width: 360,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Surowiec",
                    style: TextStyle(
                      color: Colors.white70,
                    ),
                  ),
                  const SizedBox(
                    height: 6,
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black26,
                      borderRadius: BorderRadius.circular(
                        12,
                      ),
                      border: Border.all(
                        color: UiColors.gold,
                      ),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        dropdownColor: const Color(
                          0xFF3A1D07,
                        ),
                        value: selected,
                        isExpanded: true,
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                        items: resources
                            .map(
                              (e) => DropdownMenuItem(
                                value: e,
                                child: Text(
                                  e,
                                ),
                              ),
                            )
                            .toList(),
                        onChanged: (v) {
                          if (v == null) {
                            return;
                          }

                          setLocal(
                            () {
                              selected = v;
                            },
                          );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 14,
                  ),
                  const Text(
                    "Ilość",
                    style: TextStyle(
                      color: Colors.white70,
                    ),
                  ),
                  const SizedBox(
                    height: 6,
                  ),
                  TextField(
                    controller: qtyController,
                    keyboardType: TextInputType.number,
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                    decoration: inputDecor(),
                  ),
                  const SizedBox(
                    height: 14,
                  ),
                  const Text(
                    "Cena za sztukę",
                    style: TextStyle(
                      color: Colors.white70,
                    ),
                  ),
                  const SizedBox(
                    height: 6,
                  ),
                  TextField(
                    controller: priceController,
                    keyboardType: TextInputType.number,
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                    decoration: inputDecor(),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(
                    context,
                  );
                },
                child: const Text(
                  "Anuluj",
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  final qty = double.tryParse(
                        qtyController.text,
                      ) ??
                      0;

                  final price = double.tryParse(
                        priceController.text,
                      ) ??
                      0;

                  if (qty <= 0 || price <= 0) {
                    return;
                  }

                  Navigator.pop(
                    context,
                    {
                      "resourceType": selected,
                      "quantity": qty,
                      "pricePerUnit": price,
                    },
                  );
                },
                child: const Text(
                  "Wystaw",
                ),
              ),
            ],
          );
        },
      );
    },
  );
}

InputDecoration inputDecor() {
  return InputDecoration(
    filled: true,
    fillColor: Colors.black26,
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(
        12,
      ),
      borderSide: const BorderSide(
        color: UiColors.gold,
      ),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(
        12,
      ),
      borderSide: const BorderSide(
        color: UiColors.gold,
        width: 2,
      ),
    ),
  );
}
