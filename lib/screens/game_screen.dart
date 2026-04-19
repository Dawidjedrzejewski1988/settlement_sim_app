import 'dart:math' as math;
import 'package:flutter/material.dart';

import '../api/game_hub_service.dart';
import '../api/session_service.dart';
import '../data/building_definitions.dart';
import '../models/available_buildings.dart';
import '../models/building.dart';
import '../models/settlement.dart';

class GameScreen extends StatefulWidget {
  final String token;
  final String sessionId;

  const GameScreen({
    super.key,
    required this.token,
    required this.sessionId,
  });

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  final service = SessionService();
  final hub = GameHubService();

  final TransformationController _transformationController =
      TransformationController();

  Settlement? settlement;
  bool isLoading = true;
  List<Building> buildings = [];
  List<AvailableBuilding> availableBuildings = [];

  // Duże kafelki do wygodnego budowania
  final double tileWidth = 256.0;
  final double tileHeight = 128.0;

  // Duże płótno, żeby zmieścić siatkę 50x50
  final double mapSize = 16000.0;
  final int mapLimit = 50;

  late double startX;
  late double startY;

  // Mapa terenu: 0 - Trawa, 1 - Ścieżka/Ziemia, 2 - Woda
  late List<List<int>> terrainMap;

  @override
  void initState() {
    super.initState();

    startX = mapSize / 2;
    startY = 800.0;

    _transformationController.value = Matrix4.identity()
      ..translate(-startX + 400.0, -startY + 100.0)
      ..scale(0.55);

    // Generujemy teren od razu przy starcie
    _generateTerrain();

    initRealtime();
    loadBuildings();
    loadAvailableBuildings();
    loadSettlementFallback();

    Future.delayed(const Duration(seconds: 5), () {
      if (mounted && isLoading) {
        setState(() => isLoading = false);
      }
    });
  }

  // Funkcja generująca rzekę i piaszczyste ścieżki
  void _generateTerrain() {
    terrainMap = List.generate(mapLimit, (_) => List.filled(mapLimit, 0));

    for (int x = 0; x < mapLimit; x++) {
      for (int y = 0; y < mapLimit; y++) {
        // Rzeka (diagonalnie)
        if ((x - y).abs() <= 2) {
          terrainMap[x][y] = 2; // 2 = Woda
        }
        // Generowanie nieregularnych ścieżek z użyciem funkcji trygonometrycznych
        else if ((math.sin(x * 0.4) + math.cos(y * 0.4)) > 1.2) {
          terrainMap[x][y] = 1; // 1 = Ziemia / Piasek
        } else {
          terrainMap[x][y] = 0; // 0 = Trawa
        }
      }
    }
  }

  @override
  void dispose() {
    hub.disconnect();
    _transformationController.dispose();
    super.dispose();
  }

  Future<void> initRealtime() async {
    try {
      await hub.connect(widget.token);
      await hub.joinSession(widget.sessionId);

      hub.onTickUpdate((data) {
        if (!mounted) return;

        try {
          if (data is Map<String, dynamic>) {
            if (data['mySettlement'] != null) {
              settlement = Settlement.fromJson(data['mySettlement']);
            }
          }

          setState(() {
            isLoading = false;
          });

          loadBuildings();
        } catch (e) {
          debugPrint("TickUpdate parse error: $e");
        }
      });

      hub.onSettlementUpdated((data) {
        if (!mounted) return;

        try {
          setState(() {
            settlement = Settlement.fromJson(data);
          });
        } catch (e) {
          debugPrint("SettlementUpdated parse error: $e");
        }
      });

      hub.onBuildingsUpdated((_) {
        if (!mounted) return;
        loadBuildings();
      });
    } catch (e) {
      debugPrint("Realtime init error: $e");
      loadSettlementFallback();
    }
  }

  Future<void> loadSettlementFallback() async {
    try {
      final data = await service.getSettlement();

      if (mounted) {
        setState(() {
          settlement = data;
          isLoading = false;
        });
      }
    } catch (e) {
      debugPrint("Settlement fallback error: $e");
    }
  }

  Future<void> loadBuildings() async {
    try {
      final data = await service.getBuildings();

      if (mounted) {
        setState(() {
          buildings = List.from(data);
        });
      }
    } catch (e) {
      debugPrint("Load buildings error: $e");
    }
  }

  Future<void> loadAvailableBuildings() async {
    try {
      final data = await service.getAvailableBuildings();

      if (mounted) {
        setState(() {
          availableBuildings = List.from(data);
        });
      }
    } catch (e) {
      debugPrint("Load available buildings error: $e");
    }
  }

  void _handleMapTap(TapUpDetails details) {
    final Offset localPoint = details.localPosition;

    final double relX = localPoint.dx - startX;
    final double relY = localPoint.dy - startY;

    final double twHalf = tileWidth / 2;
    final double thHalf = tileHeight / 2;

    final int gridX = ((relX / twHalf + relY / thHalf) / 2).floor();
    final int gridY = ((relY / thHalf - relX / twHalf) / 2).floor();

    // Blokada poza mapą 50x50
    if (gridX < 0 || gridX >= mapLimit || gridY < 0 || gridY >= mapLimit) {
      return;
    }

    // Blokada budowania na wodzie
    if (terrainMap[gridX][gridY] == 2) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Nie możesz budować na wodzie! 💧"),
          backgroundColor: Colors.blue,
        ),
      );
      return;
    }

    final occupied = buildings.any(
      (b) => b.tileX == gridX && b.tileY == gridY,
    );

    if (occupied) {
      final b =
          buildings.firstWhere((b) => b.tileX == gridX && b.tileY == gridY);
      _showActionMenu(b);
      return;
    }

    _showBuildMenuAt(gridX, gridY);
  }

  Future<void> buildAt(String type, int x, int y) async {
    try {
      await service.buildBuilding(type, x, y);

      if (!mounted) return;

      Navigator.pop(context);

      await loadBuildings();
      await loadSettlementFallback();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Zbudowano ${_getName(type)} na [$x, $y]"),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Błąd budowy: $e"), backgroundColor: Colors.red),
      );
    }
  }

  List<Widget> _buildCity() {
    final List<Building> sorted = List.from(buildings);

    // Y-Sorting (Z-index w 2D izometrycznym)
    sorted.sort(
      (a, b) => (a.tileX + a.tileY).compareTo(b.tileX + b.tileY),
    );

    return sorted.map((b) {
      final double px = startX + (b.tileX - b.tileY) * (tileWidth / 2);
      final double py = startY + (b.tileX + b.tileY) * (tileHeight / 2);

      // Wysokość widgetu
      final double widgetHeight = 360.0;

      return Positioned(
        left: px - (tileWidth / 2),
        // Podstawa obrazka przylega do dolnego rogu kafelka
        top: py + tileHeight - widgetHeight,
        child: GestureDetector(
          onTap: () => _showActionMenu(b),
          child: _buildingWidget(b, widgetHeight),
        ),
      );
    }).toList();
  }

  Widget _buildingWidget(Building b, double widgetHeight) {
    final def = buildingDefinitions.firstWhere(
      (d) => d.type == b.type,
      orElse: () => buildingDefinitions.first,
    );

    return SizedBox(
      width: tileWidth,
      height: widgetHeight,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          // Lekki cień / zaznaczenie fundamentu
          Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()
              ..scale(1.0, 0.5)
              ..rotateZ(math.pi / 4),
            child: Container(
              width: tileWidth * 0.65,
              height: tileWidth * 0.65,
              decoration: BoxDecoration(
                color: Colors.brown[500]?.withOpacity(0.3),
                border: Border.all(color: Colors.brown[900]!, width: 2),
              ),
            ),
          ),

          // Grafika Budynku
          Positioned(
            bottom: 20,
            child: Image.asset(
              def.assetPath,
              width: tileWidth,
              fit: BoxFit.contain,
              errorBuilder: (_, __, ___) => const Icon(
                Icons.error,
                color: Colors.red,
                size: 50,
              ),
            ),
          ),

          // Etykieta Poziomu
          Positioned(
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.black87,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.amber, width: 1.5),
              ),
              child: Text(
                "Lvl ${b.level}",
                style: const TextStyle(
                  color: Colors.amber,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: CircularProgressIndicator(color: Colors.amber),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          InteractiveViewer(
            transformationController: _transformationController,
            constrained: false,
            minScale: 0.1,
            maxScale: 2.5,
            boundaryMargin: const EdgeInsets.all(3000),
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTapUp: _handleMapTap,
              child: Container(
                width: mapSize,
                height: mapSize,
                color: Colors.transparent,
                child: CustomPaint(
                  painter: GridPainter(
                    startX,
                    startY,
                    tileWidth,
                    tileHeight,
                    mapLimit,
                    terrainMap, // Przekazujemy wygenerowaną mapę terenu
                  ),
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: _buildCity(),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: 40,
            left: 0,
            right: 0,
            child: Center(child: _buildResourcesBar()),
          ),
        ],
      ),
    );
  }

  Widget _buildResourcesBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.8),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.amber, width: 1.5),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _stat("👥", "${settlement?.population ?? 0}", Colors.blue),
            _stat("😊", "${(settlement?.morale ?? 0).toInt()}", Colors.green),
            _stat("💰", "${(settlement?.gold ?? 0).toInt()}", Colors.amber),
            _stat(
              "🧠",
              "${(settlement?.knowledge ?? 0).toInt()}",
              Colors.purple,
            ),
            ...?settlement?.resources.map((r) {
              final cfg = _resConfig(r.code);
              return _stat(
                cfg['icon'] as String,
                "${r.amount.toInt()}",
                cfg['color'] as Color,
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _stat(String icon, String value, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: Row(
        children: [
          Text(icon),
          const SizedBox(width: 4),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  void _showBuildMenuAt(int x, int y) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              "Zbuduj na polu [$x, $y] 🏗️",
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: availableBuildings.length,
                itemBuilder: (context, i) {
                  final ab = availableBuildings[i];

                  final def = buildingDefinitions.firstWhere(
                    (d) => d.type == ab.type,
                    orElse: () => buildingDefinitions.first,
                  );

                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    child: ListTile(
                      leading: Image.asset(
                        def.assetPath,
                        width: 40,
                        height: 40,
                        errorBuilder: (_, __, ___) =>
                            const Icon(Icons.home_work),
                      ),
                      title: Text(_getName(ab.type)),
                      subtitle: Text(
                        ab.canBuild
                            ? "Można budować"
                            : "Braki: ${ab.reason ?? 'Nieznany powód'}",
                      ),
                      trailing: ElevatedButton(
                        onPressed:
                            ab.canBuild ? () => buildAt(ab.type, x, y) : null,
                        child: const Text("Buduj"),
                      ),
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

  void _showActionMenu(Building b) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.blueGrey[900],
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          border: Border.all(color: Colors.amber, width: 2),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              _getName(b.type),
              style: const TextStyle(
                color: Colors.amber,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Wrap(
              alignment: WrapAlignment.center,
              spacing: 24,
              children: [
                _actionIconButton(Icons.person_add, "Pracownik +", () async {
                  await service.updateWorkers(b.id, b.workers + 1);
                  if (!mounted) return;
                  Navigator.pop(context);
                  await loadBuildings();
                }),
                _actionIconButton(Icons.upgrade, "Ulepsz", () async {
                  await service.upgradeBuilding(b.id);
                  if (!mounted) return;
                  Navigator.pop(context);
                  await loadBuildings();
                }),
                _actionIconButton(Icons.delete_forever, "Zburz", () async {
                  await service.deleteBuilding(b.id);
                  if (!mounted) return;
                  Navigator.pop(context);
                  await loadBuildings();
                }),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _actionIconButton(
    IconData icon,
    String label,
    Future<void> Function() tap,
  ) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          onPressed: () async => await tap(),
          icon: Icon(icon, color: Colors.amber, size: 35),
        ),
        Text(
          label,
          style: const TextStyle(color: Colors.white, fontSize: 10),
        ),
      ],
    );
  }

  String _getName(String t) {
    final def = buildingDefinitions.firstWhere(
      (d) => d.type == t,
      orElse: () => buildingDefinitions.first,
    );
    return def.name;
  }

  Map<String, dynamic> _resConfig(String c) {
    return {
          "WOOD": {"icon": "🪵", "color": Colors.brown},
          "STONE": {"icon": "🪨", "color": Colors.grey},
          "GOLD": {"icon": "💰", "color": Colors.amber},
          "WHEAT": {"icon": "🌾", "color": Colors.yellow},
          "FOOD": {"icon": "🍞", "color": Colors.orange},
          "KNOWLEDGE": {"icon": "🧠", "color": Colors.purple},
        }[c.toUpperCase()] ??
        {"icon": "📦", "color": Colors.white};
  }
}

class GridPainter extends CustomPainter {
  final double startX;
  final double startY;
  final double tw;
  final double th;
  final int limit;
  final List<List<int>> terrainMap;

  GridPainter(
      this.startX, this.startY, this.tw, this.th, this.limit, this.terrainMap);

  @override
  void paint(Canvas canvas, Size size) {
    final paintGrass = Paint()..color = const Color(0xFF4CAF50); // Trawa
    final paintDirt = Paint()
      ..color = const Color(0xFF8D6E63); // Ścieżka (brązowa)
    final paintWater = Paint()
      ..color = const Color(0xFF42A5F5); // Rzeka (niebieska)

    final linePaint = Paint()
      ..color = Colors.white.withOpacity(0.1)
      ..strokeWidth = 1;

    // Rysujemy każdy romb z osobna, nadając mu kolor zależny od wygenerowanej mapy
    for (int x = 0; x < limit; x++) {
      for (int y = 0; y < limit; y++) {
        double px = startX + (x - y) * (tw / 2);
        double py = startY + (x + y) * (th / 2);

        Path tilePath = Path()
          ..moveTo(px, py)
          ..lineTo(px + tw / 2, py + th / 2)
          ..lineTo(px, py + th)
          ..lineTo(px - tw / 2, py + th / 2)
          ..close();

        Paint currentPaint;
        if (terrainMap[x][y] == 2) {
          currentPaint = paintWater;
        } else if (terrainMap[x][y] == 1) {
          currentPaint = paintDirt;
        } else {
          currentPaint = paintGrass;
        }

        canvas.drawPath(tilePath, currentPaint);
        canvas.drawPath(tilePath, linePaint);
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
