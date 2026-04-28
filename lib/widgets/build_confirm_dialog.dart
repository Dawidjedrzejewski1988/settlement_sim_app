import 'package:flutter/material.dart';

Future<bool?> showBuildConfirmDialog({
  required BuildContext context,
  required Map data,
  required double wood,
  required double stone,
  required double money,
}) async {
  final cost = data["cost"] ?? [];

  double needWood = 0;
  double needStone = 0;

  for (final c in cost) {
    if (c["code"] == "Wood") {
      needWood = (c["amount"] as num).toDouble();
    }

    if (c["code"] == "Stone") {
      needStone = (c["amount"] as num).toDouble();
    }
  }

  final tier = data["tier"] ?? 1;
  final workers = data["maxWorkers"] ?? 0;
  final storage = data["storageCapacity"] ?? 0;
  final morale = data["moraleBonus"] ?? 0;
  final upkeep = data["maintenanceCost"] ?? 0;
  final production = data["productionPerHour"] ?? 0;

  final buildMoney = (data["buildCostMoney"] as num?)?.toDouble() ?? 0;

  final enoughWood = wood >= needWood;
  final enoughStone = stone >= needStone;
  final enoughMoney = money >= buildMoney;

  final canBuild = enoughWood && enoughStone && enoughMoney;

  return showDialog<bool>(
    context: context,
    barrierDismissible: true,
    barrierColor: Colors.black.withOpacity(0.45),
    builder: (_) {
      return Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.all(18),
        child: Container(
          width: 430,
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: const Color(0xFFD6A13A),
              width: 2,
            ),
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF6A3813),
                Color(0xFF3A1B08),
              ],
            ),
            boxShadow: const [
              BoxShadow(
                color: Colors.black54,
                blurRadius: 24,
                offset: Offset(0, 8),
              )
            ],
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                /// TITLE
                Text(
                  "${data["name"]}  T$tier",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFFFE3A2),
                  ),
                ),

                const SizedBox(height: 18),

                /// COST
                _sectionTitle("Koszt Budowy"),

                const SizedBox(height: 8),

                _costRow(
                  "🪵 Drewno",
                  needWood.toInt(),
                  enoughWood,
                ),

                _costRow(
                  "🪨 Kamień",
                  needStone.toInt(),
                  enoughStone,
                ),

                _costRow(
                  "💰 Monety",
                  buildMoney.toInt(),
                  enoughMoney,
                ),

                const SizedBox(height: 18),

                /// PARAMS
                _sectionTitle("Parametry"),

                const SizedBox(height: 8),

                if (workers > 0)
                  _statRow(
                    "👷 Max workers",
                    "$workers",
                  ),

                if (storage > 0)
                  _statRow(
                    "📦 Magazyn",
                    "+$storage",
                  ),

                if (morale > 0)
                  _statRow(
                    "😊 Morale",
                    "+$morale",
                  ),

                if (upkeep > 0)
                  _statRow(
                    "💰 Utrzymanie",
                    "$upkeep / h",
                  ),

                if (production > 0)
                  _statRow(
                    "⚙ Produkcja",
                    "$production / h",
                  ),

                const SizedBox(height: 18),

                Row(
                  children: [
                    Icon(
                      canBuild ? Icons.check_circle : Icons.cancel,
                      color: canBuild ? Colors.greenAccent : Colors.redAccent,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        canBuild
                            ? "Masz wystarczające zasoby"
                            : "Brakuje zasobów",
                        style: TextStyle(
                          color:
                              canBuild ? Colors.greenAccent : Colors.redAccent,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  ],
                ),

                const SizedBox(height: 24),

                Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () => Navigator.pop(
                          context,
                          false,
                        ),
                        child: Container(
                          height: 52,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            gradient: const LinearGradient(
                              colors: [
                                Color(0xFF9C2B1C),
                                Color(0xFF6E140D),
                              ],
                            ),
                          ),
                          child: const Center(
                            child: Text(
                              "Anuluj",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: InkWell(
                        onTap: canBuild
                            ? () => Navigator.pop(
                                  context,
                                  true,
                                )
                            : null,
                        child: Container(
                          height: 52,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            gradient: canBuild
                                ? const LinearGradient(
                                    colors: [
                                      Color(0xFF79C91E),
                                      Color(0xFF4B8D11),
                                    ],
                                  )
                                : const LinearGradient(
                                    colors: [
                                      Colors.grey,
                                      Colors.black38,
                                    ],
                                  ),
                          ),
                          child: const Center(
                            child: Text(
                              "Buduj",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 17,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      );
    },
  );
}

Widget _sectionTitle(String text) {
  return Align(
    alignment: Alignment.centerLeft,
    child: Text(
      text,
      style: const TextStyle(
        fontSize: 17,
        color: Color(0xFFFFD97B),
        fontWeight: FontWeight.bold,
      ),
    ),
  );
}

Widget _costRow(
  String name,
  int value,
  bool ok,
) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 3),
    child: Row(
      children: [
        Expanded(
          child: Text(
            name,
            style: const TextStyle(
              color: Colors.white,
            ),
          ),
        ),
        Text(
          "$value",
          style: TextStyle(
            color: ok ? Colors.greenAccent : Colors.redAccent,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    ),
  );
}

Widget _statRow(
  String name,
  String value,
) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 3),
    child: Row(
      children: [
        Expanded(
          child: Text(
            name,
            style: const TextStyle(
              color: Colors.white,
            ),
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            color: Colors.greenAccent,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    ),
  );
}
