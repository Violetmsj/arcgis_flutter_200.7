import 'dart:math';

import 'package:arcgis_flutter_newest/config/graphics_style_config.dart';
import 'package:arcgis_flutter_newest/config/tianditu_config.dart';
import 'package:arcgis_flutter_newest/utils/graphics_manager.dart';
import 'package:arcgis_flutter_newest/utils/image_overlay_manager.dart';
import 'package:arcgis_flutter_newest/utils/point_util.dart';
import 'package:arcgis_flutter_newest/widget/center_crosser.dart';
import 'package:arcgis_maps/arcgis_maps.dart';
import 'package:flutter/material.dart';

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  final _mapViewController = ArcGISMapView.createController();
  late FeatureCollectionLayer _featureCollectionLayer; // 保存要素图层
  late Offset mapCenterOffset; // 地图中心屏幕坐标
  onMapTap(Offset details) async {
    // 将屏幕坐标转换为地图坐标
    final mapPoint = await PointUtil.screenToWGS84(
      mapController: _mapViewController,
      screenPoint: details,
    );
    if (mapPoint != null) {
      // print('点击位置的地理坐标：');
      // print('经度：${mapPoint.x}');
      // print('纬度：${mapPoint.y}');
      final identifyResult = await _mapViewController.identifyLayer(
        _featureCollectionLayer, // 替换为你的要素图层变量
        screenPoint: details,
        tolerance: 22, // 点击容差（像素）
      );
      var attributes;

      if (identifyResult.sublayerResults.isNotEmpty) {
        attributes =
            identifyResult.sublayerResults.first.geoElements.first.attributes;
      }
      if (attributes != null) {
        if (!mounted) return;
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('地块信息'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('地块编号: ${attributes["id"]}'),
                  Text('地块名称: ${attributes["name"]}'),
                  Text('地块面积: ${attributes["areaComp"]}'),
                  Text('地块地点: ${attributes["location"]}'),
                  Text('地块类型: ${attributes["soliType"]}'),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('关闭'),
                ),
              ],
            );
          },
        );
      }

      print(identifyResult);
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
      _featureCollectionLayer = await _addFeatureLayer();
      map.operationalLayers.add(_featureCollectionLayer);
      // 添加加载完成检查

      // 隐藏地图右下角的版权信息
      _mapViewController.isAttributionTextVisible = false;
      _mapViewController.arcGISMap = map;
      // 使用图形管理器添加图形
      final graphicsManager = GraphicsManager();
      graphicsManager.addAllGraphics();
      _mapViewController.graphicsOverlays.add(graphicsManager.overlay);
      _mapViewController.graphicsOverlays.add(drawPolygongraphicsOverlay);
      _mapViewController.imageOverlays.add(imageOverlay);
      _mapViewController.setViewpoint(
        Viewpoint.withLatLongScale(
          // lat: 44.341538, lng: 86.008825 点
          // 图片经纬度
          // latitude: 44.856219,
          // longitude: 85.452456,
          // latitude: 44.341538,
          // longitude: 86.008825,
          // [85.265665, 45.089596],, featurelayer
          latitude: 45.089596,
          longitude: 85.265665,
          scale: levelToScale(15),
        ),
      );
    } catch (e) {
      print('地图初始化错误: $e');
    }
  }

  Future<FeatureCollectionLayer> _addFeatureLayer() async {
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
    // 创建要素集合
    final featureCollection = FeatureCollection();
    // 将要素表添加到要素集合中
    featureCollection.tables.add(featureTable);

    final featureCollectionLayer = FeatureCollectionLayer.withFeatureCollection(
      featureCollection,
    );

    // 创建多边形几何
    final polygonPoints = <ArcGISPoint>[];
    final latLotList = [
      [85.265665, 45.089596],
      [85.264357, 45.08952],
      [85.262812, 45.089982],
      [85.261599, 45.089808],
      [85.261589, 45.088868],
      [85.259325, 45.088846],
      [85.257211, 45.088944],
      [85.257286, 45.092815],
      [85.264367, 45.092663],
      [85.265032, 45.091163],
      [85.265269, 45.090876],
      [85.265665, 45.089596],
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
        'id': 'DNwHaco86QmoggkJxKpsCa',
        'name': '测试地块2',
        'areaComp': 355.49,
        'location': '塔城地区 新疆维吾尔自治区塔城地区沙湾市兵团一二一团',
        'soliType': '荒漠风沙土',
      },
      geometry: polygon.toGeometry(),
    );
    // 添加要素到表中
    await featureTable.addFeature(feature);

    // 设置要素图层的渲染器
    final symbol = SimpleFillSymbol(
      style: SimpleFillSymbolStyle.solid,
      color: Colors.pink.withOpacity(0.3),
      outline: SimpleLineSymbol(
        style: SimpleLineSymbolStyle.solid,
        color: Colors.black,
        width: 2,
      ),
    );
    final renderer = SimpleRenderer(symbol: symbol);
    // 将渲染器设置到要素表上，而不是图层
    featureTable.renderer = renderer;
    // featureCollectionLayer.renderer = renderer;
    await featureTable.load();
    print('要素数量：${featureTable.numberOfFeatures}'); // 验证要素加载
    if (featureTable.loadStatus == LoadStatus.loaded) {
      print('要素加载成功');
    }
    // featureCollectionLayer.featureCollection.tables.add(featureTable);
    // featureCollectionLayer.;
    return featureCollectionLayer;
  }

  // 跳转按钮组件
  Widget _buildJumpButton({
    required String title,
    required Map<String, double> latLng,
  }) {
    return ElevatedButton(
      onPressed: () {
        _mapViewController.setViewpoint(
          Viewpoint.withLatLongScale(
            latitude: latLng['lat']!,
            longitude: latLng['lng']!,
            scale: levelToScale(15),
          ),
        );
      },
      child: Text(title),
    );
  }

  // 地图跳转按钮
  Widget _buildJumpButtonsView() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildJumpButton(
          title: "贴图点",
          latLng: {"lat": 44.856219, "lng": 85.452456},
        ),
        _buildJumpButton(
          title: "FeatureLayer",
          latLng: {"lat": 45.089596, "lng": 85.265665},
        ),
        _buildJumpButton(
          title: "graphics",
          latLng: {"lat": 44.341538, "lng": 86.008825},
        ),
      ],
    );
  }

  Widget _buildMapView() {
    return LayoutBuilder(
      builder: (context, constraints) {
        mapCenterOffset = Offset(
          constraints.maxWidth / 2,
          constraints.maxHeight / 2,
        );
        return ArcGISMapView(
          controllerProvider: () => _mapViewController,
          onMapViewReady: onMapViewReady,
          onTap: onMapTap,
        );
      },
    );
  }

  var drawPolygonPoints = <ArcGISPoint>[]; //绘制多边形的坐标数组
  var drawPolygongraphicsOverlay = GraphicsOverlay();
  var drawPolygonBuilder = PolygonBuilder(
    spatialReference: SpatialReference.wgs84,
  );

  // 绘制多边形打点
  onStartDrawPolygon() async {
    final drawPolygonPoint = await PointUtil.screenToWGS84(
      mapController: _mapViewController,
      screenPoint: mapCenterOffset,
    );

    if (drawPolygonPoint == null) {
      return;
    }
    drawPolygonPoints.add(drawPolygonPoint);
    drawPolygonBuilder.addPoint(drawPolygonPoint);
    Polygon polygon = drawPolygonBuilder.toGeometry() as Polygon;
    var graphic = Graphic(
      geometry: polygon,
      symbol: GraphicsStyleConfig.defaultPolygonSymbol,
    );
    // 清除之前的图形
    drawPolygongraphicsOverlay.graphics.clear();

    // 1. 添加新的图形
    drawPolygongraphicsOverlay.graphics.add(graphic);
    // 2. 为每个点添加点标记
    for (var point in drawPolygonPoints) {
      var pointGraphic = Graphic(
        geometry: point,
        symbol: GraphicsStyleConfig.drawPolygonPointSymbol,
      );
      drawPolygongraphicsOverlay.graphics.add(pointGraphic);
    }
  }

  // 撤回上一步画地的点
  onUndoLastPoint() {
    if (drawPolygonPoints.isEmpty) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Text("没有可撤回的点"),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('确定'),
              ),
            ],
          );
        },
      );
      return;
    }
    drawPolygonPoints.removeLast();
    // 创建新的PolygonBuilder并添加剩余的点
    var newPolygonBuilder = PolygonBuilder(
      spatialReference: SpatialReference.wgs84,
    );
    for (var point in drawPolygonPoints) {
      newPolygonBuilder.addPoint(point);
    }

    // 替换原有的几何图形
    drawPolygonBuilder.replaceGeometry(newPolygonBuilder.toGeometry());
    Polygon polygon = drawPolygonBuilder.toGeometry() as Polygon;
    var graphic = Graphic(
      geometry: polygon,
      symbol: GraphicsStyleConfig.defaultPolygonSymbol,
    );
    // 清除之前的图形
    drawPolygongraphicsOverlay.graphics.clear();
    //  添加新的图形
    drawPolygongraphicsOverlay.graphics.add(graphic);
    // 2. 为每个点添加点标记
    for (var point in drawPolygonPoints) {
      var pointGraphic = Graphic(
        geometry: point,
        symbol: GraphicsStyleConfig.drawPolygonPointSymbol,
      );
      drawPolygongraphicsOverlay.graphics.add(pointGraphic);
    }
  }

  // 完成绘制
  onFinishDrawPolygon() {
    if (drawPolygonPoints.length < 3) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Text("至少需要三个点才能构成一个多边形"),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('确定'),
              ),
            ],
          );
        },
      );
    }
    print(drawPolygonPoints);
    // 发送网络请求,成功后清除图形
    // 清空点位数组和 PolygonBuilder
    drawPolygonPoints.clear();
    drawPolygonBuilder = PolygonBuilder(
      spatialReference: SpatialReference.wgs84,
    ); // 重置 PolygonBuilder
    // 清除之前的图形
    drawPolygongraphicsOverlay.graphics.clear();
  }

  // 地图跳转按钮
  Widget _buildDrawButtonsView() {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 20, // 距离底部20像素
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ElevatedButton(onPressed: onStartDrawPolygon, child: Text("打点")),
          ElevatedButton(onPressed: onFinishDrawPolygon, child: Text("完成绘制")),
          ElevatedButton(onPressed: onUndoLastPoint, child: Text("撤回(返回上一步)")),
        ],
      ),
    );
  }

  // 主视图
  Widget _buildView() {
    return Stack(
      children: <Widget>[
        // 地图
        _buildMapView(),
        _buildJumpButtonsView(),
        CenterCrosser(),
        _buildDrawButtonsView(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("地图页"), backgroundColor: Colors.blue),
      body: _buildView(),
    );
  }
}
