import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import '../core/constants/game_constants.dart';
import '../core/utils/iso_utils.dart';
import '../services/building_service.dart';

import 'components/build_preview_component.dart';
import 'components/building_component.dart';
import 'components/diamond_tile.dart';
import 'components/preview_tile.dart';
import 'components/terrain_tile_component.dart';

import 'systems/camera_system.dart';
import 'systems/map_system.dart';

import 'data/building_definitions.dart';

class SettlementGame extends FlameGame
    with
        TapCallbacks,
        DragCallbacks,
        MouseMovementDetector,
        ScrollDetector,
        ScaleCallbacks {
  final String token;
  final String settlementId;

  final Function(int x, int y)? onTileTap;
  final Function(Map data)? onBuildingTap;

  SettlementGame({
    required this.token,
    required this.settlementId,
    this.onTileTap,
    this.onBuildingTap,
  });

  final buildingService = BuildingService();

  int mapW = 60;
  int mapH = 60;

  double zoomLevel = 0.30;

  late final World world;
  late final CameraComponent cam;

  late PreviewTile preview;
  late BuildPreviewComponent buildPreview;

  String? selectedBuildType;

  List<dynamic> buildingsData = [];

  bool dragging = false;
  bool buildMode = false;

  BuildingVisualData get selectedDef {
    if (selectedBuildType == null) {
      return const BuildingVisualData(
        width: 1,
        height: 1,
        offsetX: 0,
        offsetY: 0,
        spriteW: 64,
        spriteH: 64,
      );
    }

    return BuildingDefinitions.get(selectedBuildType!);
  }

  @override
  Color backgroundColor() => const Color(0xFF7AAE4E);

  @override
  Future<void> onLoad() async {
    world = World();
    cam = CameraComponent(world: world);

    add(world);
    add(cam);

    final map = await MapSystem.load(GameConstants.apiUrl);

    mapW = map["width"] ?? 60;
    mapH = map["height"] ?? 60;

    await _drawGrid();

    preview = PreviewTile()..visible = false;
    world.add(preview);

    buildPreview = BuildPreviewComponent();
    buildPreview.setOpacity(0);
    world.add(buildPreview);

    await refreshBuildings();

    CameraSystem.center(
      cam: cam,
      mapW: mapW,
      mapH: mapH,
      tileW: GameConstants.tileW,
      tileH: GameConstants.tileH,
      zoom: zoomLevel,
    );

    cam.viewfinder.zoom = zoomLevel;

    toggleGrid(false);
  }

  Future<void> setSelectedBuildType(String? type) async {
    selectedBuildType = type;
    buildMode = type != null;

    toggleGrid(buildMode);

    if (type == null) {
      preview.visible = false;
      buildPreview.setOpacity(0);
      return;
    }

    await buildPreview.setType(type);
    buildPreview.setOpacity(0.55);
  }

  Future<void> _drawGrid() async {
    for (int y = 0; y < mapH; y++) {
      for (int x = 0; x < mapW; x++) {
        final pos = IsoUtils.tileToWorld(x, y);

        world.add(
          TerrainTileComponent(
            position: pos,
            tileX: x,
            tileY: y,
          ),
        );
        world.add(
          DiamondTile(
            position: pos,
          ),
        );
      }
    }
  }

  Future<void> refreshBuildings() async {
    final old = world.children.whereType<BuildingComponent>().toList();

    for (final b in old) {
      b.removeFromParent();
    }

    final response = await buildingService.getBuildings(
      token,
      settlementId,
    );

    buildingsData = response.data;

    for (final b in buildingsData) {
      final pos = IsoUtils.tileToWorld(
        b["tileX"],
        b["tileY"],
      );

      final def = BuildingDefinitions.get(
        b["type"],
      );

      world.add(
        BuildingComponent(
          data: b,
          position: Vector2(
            pos.x + 64 + def.offsetX,
            pos.y + 64 + def.offsetY,
          ),
          onTapBuilding: onBuildingTap,
        ),
      );
    }
  }

  bool isOccupied(
    int tx,
    int ty,
    int w,
    int h,
  ) {
    for (final b in buildingsData) {
      final bx = b["tileX"];
      final by = b["tileY"];

      final def = BuildingDefinitions.get(
        b["type"],
      );

      for (int y = 0; y < h; y++) {
        for (int x = 0; x < w; x++) {
          final cx = tx + x;
          final cy = ty + y;

          if (cx >= bx &&
              cx < bx + def.width &&
              cy >= by &&
              cy < by + def.height) {
            return true;
          }
        }
      }
    }

    return false;
  }

  void _updatePreview(Vector2 screen) {
    if (!buildMode || selectedBuildType == null) {
      preview.visible = false;
      buildPreview.setOpacity(0);
      return;
    }

    final worldX = (screen.x / zoomLevel) +
        cam.viewfinder.position.x -
        size.x / (2 * zoomLevel);

    final worldY = (screen.y / zoomLevel) +
        cam.viewfinder.position.y -
        size.y / (2 * zoomLevel);

    final tile = IsoUtils.worldToTile(worldX, worldY);

    final def = selectedDef;

    final tx = tile.x.toInt() - (def.width ~/ 2);
    final ty = tile.y.toInt() - (def.height ~/ 2);

    if (tx < 0 || ty < 0 || tx + def.width > mapW || ty + def.height > mapH) {
      preview.visible = false;
      buildPreview.setOpacity(0);
      return;
    }

    final occupied = isOccupied(
      tx,
      ty,
      def.width,
      def.height,
    );

    final pos = IsoUtils.tileToWorld(tx, ty);

    preview.position = pos;
    preview.tileX = tx;
    preview.tileY = ty;
    preview.widthTiles = def.width;
    preview.heightTiles = def.height;
    preview.canBuild = !occupied;
    preview.visible = true;

    buildPreview.position = Vector2(
      pos.x + 64 + def.offsetX,
      pos.y + 64 + def.offsetY,
    );

    buildPreview.setOpacity(
      occupied ? 0.28 : 0.55,
    );
  }

  @override
  void onMouseMove(PointerHoverInfo info) {
    if (!dragging) {
      _updatePreview(info.eventPosition.global);
    }
  }

  @override
  void onTapDown(TapDownEvent event) {
    if (!buildMode) return;
    if (!preview.visible) return;
    if (!preview.canBuild) return;

    onTileTap?.call(
      preview.tileX,
      preview.tileY,
    );
  }

  @override
  void onDragStart(DragStartEvent event) {
    super.onDragStart(event);
    dragging = true;
  }

  @override
  void onDragUpdate(DragUpdateEvent event) {
    CameraSystem.drag(
      cam,
      event.localDelta,
      zoomLevel,
    );
  }

  @override
  void onDragEnd(DragEndEvent event) {
    super.onDragEnd(event);
    dragging = false;
  }

  @override
  void onScroll(PointerScrollInfo info) {
    if (info.scrollDelta.global.y < 0) {
      zoomLevel += 0.05;
    } else {
      zoomLevel -= 0.05;
    }

    zoomLevel = zoomLevel.clamp(0.15, 2.5);
    cam.viewfinder.zoom = zoomLevel;
  }

  @override
  void onScaleUpdate(ScaleUpdateEvent event) {
    zoomLevel *= event.scale;
    zoomLevel = zoomLevel.clamp(0.15, 2.5);

    cam.viewfinder.zoom = zoomLevel;
  }

  void toggleGrid(bool state) {
    buildMode = state;

    final tiles = world.children.whereType<DiamondTile>();

    for (final t in tiles) {
      t.visibleGrid = state;
    }

    preview.visible = state;

    if (!state) {
      buildPreview.setOpacity(0);
    } else if (selectedBuildType != null) {
      buildPreview.setOpacity(0.55);
    }
  }
}
