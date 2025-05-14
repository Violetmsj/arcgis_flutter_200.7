import 'dart:math';

import 'package:maplibre_gl/maplibre_gl.dart';

import 'map_state_mixin.dart';

mixin DrawPolygonMixin on MapStateMixin {
  // 地图中心屏幕坐标
  late Point mapCenter;
  // 画地开关
  bool isDrawingMode = false;
  // 切换画地模式
  void toggleDrawingMode() {
    isDrawingMode = !isDrawingMode;
    update(["maplibremap"]);
  }

  // 检查数据源是否存在
  Future<bool> isSourceExists(String sourceId) async {
    final controller = await mapController.future;
    List<String> sourceIds = await controller.getSourceIds();
    return sourceIds.contains(sourceId);
  }

  // 检查图层是否存在
  Future<bool> isLayerExists(layerId) async {
    final controller = await mapController.future;
    List layerIds = await controller.getLayerIds();
    return layerIds.contains(layerId);
  }

  //绘制多边形的坐标数组
  var drawPolygonPoints = <LatLng>[];
  void onDrawPolygonPoint() async {
    print("onDrawPolygonPoint");
    final controller = await mapController.future;
    var mapCenterLatlng = await controller.toLatLng(mapCenter);
    drawPolygonPoints.add(mapCenterLatlng);
    var coordinates =
        drawPolygonPoints.map((e) => [e.longitude, e.latitude]).toList();
    if (coordinates.length > 2) {
      //闭合多边形
      coordinates.add(coordinates[0]);
      // 检查数据源是否存在
      final drawLandSourceExists = await isSourceExists("draw-land-source");
      final drawLandlayerExists = await isLayerExists("draw-land-layer");
      // 如果存在，则更新数据源，否则添加数据源
      if (drawLandSourceExists) {
        controller.setGeoJsonSource("draw-land-source", {
          "type": "Feature",
          "properties": {},
          "geometry": {
            "type": "Polygon",
            "coordinates": [coordinates],
          },
        });
      } else {
        // 添加画地数据源
        await controller.addSource(
          "draw-land-source",
          GeojsonSourceProperties(
            data: {
              "type": "Feature",
              "properties": {},
              "geometry": {
                "type": "Polygon",
                "coordinates": [coordinates],
              },
            },
          ),
        );
      }
      //如果画地图层不存在，则添加
      if (!drawLandlayerExists) {
        await controller.addLayer(
          "draw-land-source",
          "draw-land-layer",
          FillLayerProperties(
            fillColor: "#808080",
            fillOutlineColor: "#ffffff",
            fillOpacity: 0.5,
          ),
        );
      }
    }
    print(mapCenterLatlng);
  }

  void onUndoLastPoint() async {
    final controller = await mapController.future;
    if (drawPolygonPoints.isNotEmpty) {
      drawPolygonPoints.removeLast();
      var coordinates =
          drawPolygonPoints.map((e) => [e.longitude, e.latitude]).toList();
      if (coordinates.isNotEmpty) {
        if (coordinates.length > 2) {
          coordinates.add(coordinates[0]);
          controller.setGeoJsonSource("draw-land-source", {
            "type": "Feature",
            "properties": {},
            "geometry": {
              "type": "Polygon",
              "coordinates": [coordinates],
            },
          });
        } else {
          await controller.removeLayer("draw-land-layer");
        }
      }
      update(["maplibremap"]);
    }
  }

  void onFinishDrawPolygon() {}
}
