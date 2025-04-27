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
      var polygonFeatureLayer = await _addFeatureLayer();
      // map.operationalLayers.add(polygonFeatureLayer);
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
          // lat: 44.341538, lng: 86.008825 点
          // 图片经纬度
          // latitude: 44.856219,
          // longitude: 85.452456,
          latitude: 44.341538,
          longitude: 86.008825,
          scale: levelToScale(15),
        ),
      );
    } catch (e) {
      print('地图初始化错误: $e');
    }
  }

  Future<FeatureLayer> _addFeatureLayer() async {
    // 定义字段
    final fields = [
      Field.text(name: 'id', alias: '地块编号', length: 20),
      Field.text(name: 'name', alias: '地块名称', length: 20),
      Field.double(name: 'areaComp', alias: '地块面积'),
      Field.text(name: 'location', alias: '地块地点', length: 100),
      Field.date(name: 'latLot', alias: '地块边界'),
      Field.text(name: 'soliType', alias: '地块类型', length: 20),
    ];
    // 创建要素集合表
    final featureTable = FeatureCollectionTable(
      fields: fields,
      geometryType: GeometryType.polygon,
      spatialReference: SpatialReference.wgs84,
    );
    // 设置表的字段
    featureTable.fields.addAll(fields);

    // 创建要素图层
    final featureLayer = FeatureLayer.withFeatureTable(featureTable);
    // 创建多边形几何
    final polygonPoints = <ArcGISPoint>[];
    final latLotList = [
      [85.452483, 44.856212],
      [85.452456, 44.856219],
      [85.458053, 44.856152],
      [85.458042, 44.849842],
      [85.45257, 44.850045],
      [85.452483, 44.856212],
    ];

    for (var latLot in latLotList) {
      var point = PointUtil.WGS84Point(lat: latLot[1], lng: latLot[0]);
      polygonPoints.add(point);
    }

    final polygon = PolygonBuilder(spatialReference: SpatialReference.wgs84);
    for (var point in polygonPoints) {
      polygon.addPoint(point);
    }
    // 创建要素
    final feature = featureTable.createFeature(
      attributes: {
        'id': 'h8WkShXTiULvVmccHZNn4i',
        'name': '测试地块1',
        'areaComp': 454.07,
        'location': '塔城地区 新疆维吾尔自治区塔城地区沙湾市兵团一二一团S20五克高速',
        'soliType': '盐化灰漠土',
      },
      geometry: polygon.toGeometry(),
    );

    // 添加要素到表中
    await featureTable.addFeature(feature);

    // 设置要素图层的渲染器
    final symbol = SimpleFillSymbol(
      style: SimpleFillSymbolStyle.solid,
      color: Colors.blue.withOpacity(0.3),
      outline: SimpleLineSymbol(
        style: SimpleLineSymbolStyle.solid,
        color: Colors.blue,
        width: 2,
      ),
    );

    final renderer = SimpleRenderer(symbol: symbol);
    featureLayer.renderer = renderer;
    return featureLayer;
    // 添加图层到地图
    // _mapViewController.operationalLayers.add(featureLayer);

    // 缩放到要素范围
    // _mapViewController.setViewpointGeometry(polygon);
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
