import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import 'constants/game_constants.dart';
import 'utils/iso_utils.dart';
import '../api/services.dart';
import '../api/models.dart';

import 'components/build_preview_component.dart';
import 'components/building_component.dart';
import 'components/preview_tile.dart';
import 'components/map_component.dart';

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

  @override
  late final World world;
  late final CameraComponent cam;

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

    final map = await MapSystem.load(
      apiUrl: GameConstants.apiUrl,
      token: token,
    );

    mapW = map["width"] ?? 60;
    mapH = map["height"] ?? 60;

    world.add(
      MapComponent(
        mapW: mapW,
        mapH: mapH,
      ),
    );

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

  Future<void> refreshBuildings() async {
    final List<Building> newData = await buildingService.getBuildings();

    final existing = {
      for (var c in world.children.whereType<BuildingComponent>())
        c.data["id"]: c
    };

    buildingsData = newData;

    for (final b in newData) {
      final id = b.id;

      if (existing.containsKey(id)) {
        existing[id]!.data.clear();
        existing[id]!.data.addAll(b.toJson());
      } else {
        final pos = IsoUtils.tileToWorld(
          b.tileX,
          b.tileY,
        );

        final def = BuildingDefinitions.get(b.type);

        world.add(
          BuildingComponent(
            data: b.toJson(),
            position: Vector2(
              pos.x + 64 + def.offsetX,
              pos.y + 64 + def.offsetY,
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
    for (final b in buildingsData) {
      final bx = b.tileX;
      final by = b.tileY;

      final def = BuildingDefinitions.get(b.type);

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

    preview.visible = state;

    if (!state) {
      buildPreview.setOpacity(0);
    } else if (selectedBuildType != null) {
      buildPreview.setOpacity(0.55);
    }
  }
}
