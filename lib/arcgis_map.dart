import 'dart:math';

import 'package:arcgis_flutter_newest/config/tianditu_config.dart';
import 'package:arcgis_flutter_newest/utils/graphics_manager.dart';
import 'package:arcgis_flutter_newest/utils/image_overlay_manager.dart';
import 'package:arcgis_flutter_newest/utils/point_util.dart';
import 'package:arcgis_maps/arcgis_maps.dart';
import 'package:flutter/material.dart';

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  final _mapViewController = ArcGISMapView.createController();

  onMapTap(Offset details) async {
    // 将屏幕坐标转换为地图坐标
    final mapPoint = await PointUtil.screenToWGS84(
      mapController: _mapViewController,
      screenPoint: details,
    );
    if (mapPoint != null) {
      print('点击位置的地理坐标：');
      print('经度：${mapPoint.x}');
      print('纬度：${mapPoint.y}');
    } else {
      print('坐标转换失败，可能是地图未完全加载');
    }
  }

  /// 将地图层级转换为比例尺
  double levelToScale(int level) {
    if (level < 0 || level > 18) {
      throw ArgumentError('层级必须在0-18之间');
    }
    // 使用与 TileInfo 中相同的基准比例尺
    return 591657527.591555 / pow(2, level);
  }

  final _imageOverlayManager = ImageOverlayManager();
  Future<void> onMapViewReady() async {
    try {
      final map = ArcGISMap(spatialReference: SpatialReference.webMercator);
      // 创建天地图矢量底图图层
      final imgLayer = TianDiTuConfig.createImgLayer();
      // 创建天地图注记图层
      final annotationLayer = TianDiTuConfig.createAnnotationLayer();
      // 创建Envelope部分
      final envelopeWGS84 = Envelope.fromXY(
        xMin: 85.452456,
        yMin: 44.849842,
        xMax: 85.458053,
        yMax: 44.856219,
        spatialReference: SpatialReference.wgs84,
      );
      // 使用管理器创建ImageOverlay
      final imageOverlay = await _imageOverlayManager.createImageOverlay(
        imagePath: 'assets/image/test_image.png',
        extent: envelopeWGS84,
      );
      // 将图层添加到地图中
      map.operationalLayers.addAll([imgLayer, annotationLayer]);

      // 隐藏地图右下角的版权信息
      _mapViewController.isAttributionTextVisible = false;
      _mapViewController.arcGISMap = map;
      // 使用图形管理器添加图形
      final graphicsManager = GraphicsManager();
      graphicsManager.addAllGraphics();
      _mapViewController.graphicsOverlays.add(graphicsManager.overlay);

      _mapViewController.imageOverlays.add(imageOverlay);
      _mapViewController.setViewpoint(
        Viewpoint.withLatLongScale(
          latitude: 44.856219,
          longitude: 85.452456,
          scale: levelToScale(15),
        ),
      );
    } catch (e) {
      print('地图初始化错误: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("地图页"), backgroundColor: Colors.blue),
      body: Column(
        children: [
          Expanded(
            child: ArcGISMapView(
              controllerProvider: () => _mapViewController,
              onMapViewReady: onMapViewReady,
              onTap: onMapTap,
            ),
          ),
        ],
      ),
    );
  }
}
