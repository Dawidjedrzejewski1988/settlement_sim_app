import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import 'constants/game_constants.dart';
import 'utils/iso_utils.dart';

import '../api/models.dart';
import '../api/services.dart';

import 'components/build_preview_component.dart';
import 'components/building_component.dart';
import 'components/grid_component.dart';
import 'components/map_component.dart';
import 'components/preview_tile.dart';

import 'data/building_definitions.dart';

import 'systems/camera_system.dart';
import 'systems/map_system.dart';
import 'systems/terrain_mask.dart';

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

  int mapW = 30;
  int mapH = 30;

  double zoomLevel = 0.65;

  @override
  late final World world;

  late final CameraComponent cam;

  late GridComponent grid;

  late PreviewTile preview;

  late BuildPreviewComponent buildPreview;

  String? selectedBuildType;

  List<Building> buildingsData = [];

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

    return BuildingDefinitions.get(
      selectedBuildType!,
    );
  }

  @override
  Color backgroundColor() {
    return const Color(0xFF1B1B1B);
  }

  @override
  Future<void> onLoad() async {
    world = World();

    cam = CameraComponent(
      world: world,
    );

    add(world);

    add(cam);

    final map = await MapSystem.load(
      apiUrl: GameConstants.apiUrl,
      token: token,
    );

    mapW = map["width"] ?? 30;
    mapH = map["height"] ?? 30;

    await TerrainMask.load();

    world.add(
      MapComponent(),
    );

    grid = GridComponent(
      mapW: mapW,
      mapH: mapH,
    );

    world.add(grid);

    preview = PreviewTile()..visible = false;

    world.add(preview);

    buildPreview = BuildPreviewComponent();

    buildPreview.setOpacity(0);

    world.add(buildPreview);

    await refreshBuildings();

    CameraSystem.center(
      cam: cam,
      zoom: zoomLevel,
    );

    toggleGrid(false);
  }

  Future<void> setSelectedBuildType(
    String? type,
  ) async {
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

  Future<void> refreshBuildings() async {
    final List<Building> newData = await buildingService.getBuildings();

    final existing = {
      for (var c in world.children.whereType<BuildingComponent>())
        c.data["id"]: c,
    };

    buildingsData = newData;

    for (final b in newData) {
      final id = b.id;

      if (existing.containsKey(id)) {
        existing[id]!.data.clear();

        existing[id]!.data.addAll(
              b.toJson(),
            );
      } else {
        final pos = IsoUtils.tileToWorld(
          b.tileX,
          b.tileY,
        );

        pos.y += GridComponent.gridOffsetY;

        final def = BuildingDefinitions.get(
          b.type,
        );

        world.add(
          BuildingComponent(
            data: b.toJson(),
            position: Vector2(
              pos.x + def.offsetX,
              pos.y + GameConstants.tileH + def.offsetY,
            ),
            onTapBuilding: onBuildingTap,
          ),
        );
      }
    }

    final newIds = newData.map((e) => e.id).toSet();

    for (final c in existing.values) {
      if (!newIds.contains(c.data["id"])) {
        c.removeFromParent();
      }
    }
  }

  bool isOccupied(
    int tx,
    int ty,
    int w,
    int h,
  ) {
    for (int y = 0; y < h; y++) {
      for (int x = 0; x < w; x++) {
        final cx = tx + x;

        final cy = ty + y;

        final world = IsoUtils.tileToWorld(
          cx,
          cy,
        );

        if (!TerrainMask.canBuildAtPixel(
          world.x.toInt(),
          world.y.toInt(),
        )) {
          return true;
        }
      }
    }

    for (final b in buildingsData) {
      final buildingDef = BuildingDefinitions.get(
        b.type,
      );

      for (int y = 0; y < buildingDef.height; y++) {
        for (int x = 0; x < buildingDef.width; x++) {
          final bx = b.tileX + x;

          final by = b.tileY + y;

          for (int yy = 0; yy < h; yy++) {
            for (int xx = 0; xx < w; xx++) {
              final cx = tx + xx;

              final cy = ty + yy;

              if (cx == bx && cy == by) {
                return true;
              }
            }
          }
        }
      }
    }

    return false;
  }

  void _updatePreview(
    Vector2 screen,
  ) {
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

    final tile = IsoUtils.worldToTile(
      worldX,
      worldY - GridComponent.gridOffsetY,
    );

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

    final pos = IsoUtils.tileToWorld(
      tx,
      ty,
    );

    pos.y += GridComponent.gridOffsetY;

    preview.position = Vector2(
      pos.x + ((def.width - 1) * GameConstants.tileW / 2),
      pos.y,
    );

    preview.tileX = tx;

    preview.tileY = ty;

    preview.widthTiles = def.width;

    preview.heightTiles = def.height;

    preview.canBuild = !occupied;

    preview.visible = true;

    buildPreview.position = Vector2(
      pos.x + (GameConstants.tileW / 2) + def.offsetX,
      pos.y + GameConstants.tileH + def.offsetY,
    );

    buildPreview.setOpacity(
      occupied ? 0.28 : 0.55,
    );
  }

  @override
  void onMouseMove(
    PointerHoverInfo info,
  ) {
    if (!dragging) {
      _updatePreview(
        info.eventPosition.global,
      );
    }
  }

  @override
  void onTapDown(
    TapDownEvent event,
  ) {
    if (!buildMode) return;

    if (!preview.visible) return;

    if (!preview.canBuild) return;

    onTileTap?.call(
      preview.tileX,
      preview.tileY,
    );
  }

  @override
  void onDragStart(
    DragStartEvent event,
  ) {
    super.onDragStart(event);

    dragging = true;
  }

  @override
  void onDragUpdate(
    DragUpdateEvent event,
  ) {
    CameraSystem.drag(
      cam: cam,
      delta: event.localDelta,
      zoom: zoomLevel,
    );
  }

  @override
  void onDragEnd(
    DragEndEvent event,
  ) {
    super.onDragEnd(event);

    dragging = false;
  }

  @override
  void onScroll(
    PointerScrollInfo info,
  ) {
    if (info.scrollDelta.global.y < 0) {
      zoomLevel += 0.05;
    } else {
      zoomLevel -= 0.05;
    }

    zoomLevel = zoomLevel.clamp(
      0.4,
      1.5,
    );

    cam.viewfinder.zoom = zoomLevel;
  }

  @override
  void onScaleUpdate(
    ScaleUpdateEvent event,
  ) {
    zoomLevel *= event.scale;

    zoomLevel = zoomLevel.clamp(
      0.4,
      1.5,
    );

    cam.viewfinder.zoom = zoomLevel;
  }

  void toggleGrid(
    bool state,
  ) {
    buildMode = state;

    grid.visibleGrid = state;

    preview.visible = state;

    if (!state) {
      buildPreview.setOpacity(
        0,
      );
    } else if (selectedBuildType != null) {
      buildPreview.setOpacity(
        0.55,
      );
    }
  }
}
