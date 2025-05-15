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
  Future<bool> isLayerExists(String layerId) async {
    final controller = await mapController.future;
    List<String> layerIds = (await controller.getLayerIds()).cast<String>();
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
    // 当坐标点大于2个时，添加多边形
    if (coordinates.length > 2) {
      //闭合多边形
      coordinates.add(coordinates[0]);
    }
    // 检查数据源是否存在
    final drawLandPolygonSourceExists = await isSourceExists(
      "draw-land-polygon-source",
    );
    final drawLandPolygonLayerExists = await isLayerExists(
      "draw-land-polygon-layer",
    );
    final drawLandPointLayerExists = await isLayerExists(
      "draw-land-point-layer",
    );
    print(
      drawLandPolygonSourceExists
          ? "draw-land-polygon-source存在"
          : "draw-land-polygon-source不存在",
    );
    print(
      drawLandPolygonLayerExists
          ? "draw-land-polygon-layer存在"
          : "draw-land-polygon-layer不存在",
    );
    print(
      drawLandPointLayerExists
          ? "draw-land-point-layer存在"
          : "draw-land-point-layer不存在",
    );
    // 如果存在，则更新数据源，否则添加数据源
    if (drawLandPolygonSourceExists) {
      controller.setGeoJsonSource("draw-land-polygon-source", {
        "type": "FeatureCollection",
        "features": [
          coordinates.length >= 3
              ? {
                  "type": "Feature",
                  "geometry": {
                    "type": "Polygon",
                    "coordinates": [coordinates],
                  },
                }
              : null,
          {
            "type": "Feature",
            "geometry": {
              "type": "MultiPoint",
              "coordinates": [
                ...(drawPolygonPoints
                    .map((e) => [e.longitude, e.latitude])
                    .toList()),
              ],
            },
          },
        ].where((f) => f != null).toList(),
      });
      print("更新数据源");
    } else {
      // 添加画地数据源

      try {
        await controller.addSource(
          "draw-land-polygon-source",
          GeojsonSourceProperties(
            data: {
              "type": "FeatureCollection",
              // "properties": {},
              "features": [
                // {
                //   "type": "Feature",
                //   "geometry": {
                //     "type": "Polygon",
                //     "coordinates": [coordinates],
                //   },
                // },
                {
                  "type": "Feature",
                  "geometry": {
                    "type": "MultiPoint",
                    "coordinates": drawPolygonPoints
                        .map((e) => [e.longitude, e.latitude])
                        .toList(),
                  },
                },
              ],
            },
          ),
        );
        print("添加画地数据源");
      } catch (e) {
        print(e);
      }
    }
    //如果画地图层存在，则删除
    if (drawLandPolygonLayerExists) {
      await controller.removeLayer("draw-land-polygon-layer");
      print("删除画地图图层");
    }
    await controller.addLayer(
      "draw-land-polygon-source",
      "draw-land-polygon-layer",
      FillLayerProperties(
        fillColor: "#808080",
        fillOutlineColor: "#ffffff",
        fillOpacity: 0.5,
      ),
    );
    //如果画地点图层不存在，则添加
    if (drawLandPointLayerExists) {
      await controller.removeLayer("draw-land-point-layer");
      // print("添加画地点图层");
    }
    await controller.addLayer(
      "draw-land-polygon-source",
      "draw-land-point-layer",
      CircleLayerProperties(
        circleColor: "#FFA500", // 橘黄色
        circleRadius: 6, // 点的大小
        circleStrokeWidth: 2, // 边框宽度
        circleStrokeColor: "#FFFFFF", // 白色边框
      ),
      // belowLayerId: null, // 确保点图层在最顶层
    );
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
          controller.setGeoJsonSource("draw-land-polygon-source", {
            "type": "Feature",
            "properties": {},
            "geometry": {
              "type": "Polygon",
              "coordinates": [coordinates],
            },
          });
        } else {
          await controller.removeLayer("draw-land-polygon-layer");
        }
      }
      update(["maplibremap"]);
    }
  }

  void onFinishDrawPolygon() {}

  void addSourceTest() async {
    final controller = await mapController.future;
    await controller.addSource(
      "my-TestSource",
      GeojsonSourceProperties(
        data: {
          "type": "Feature",
          "properties": {},
          "geometry": {
            "type": "LineString",
            "coordinates": [
              [86.00426167774084, 44.34094461041972],
              [86.00517720325354, 44.337967341789394],
              [86.00693672884825, 44.33682141116668],
              [86.01185767847899, 44.336698631557404],
            ],
          },
        },
      ),
    );
    print("添加测试数据源");

    await controller.addLayer(
      "my-TestSource",
      "myTestLayer",
      LineLayerProperties(
        lineColor: "#000",
        lineWidth: 10,
        // lineOpacity: lineDisplay ? 1 : 0,
      ),
    );
    print("添加测试层");
  }

  void sourceExistsTest() async {
    bool result = await isSourceExists("my-TestSource");
    print(result ? "source存在" : "source不存在");
    bool result2 = await isLayerExists("myTestLayer");
    print(result2 ? "layer存在" : "layer不存在");
  }
}
