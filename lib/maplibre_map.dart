import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:maplibre_gl/maplibre_gl.dart';

class MaplibreMap extends StatefulWidget {
  const MaplibreMap({Key? key}) : super(key: key);

  @override
  _MaplibreMapState createState() => _MaplibreMapState();
}

class _MaplibreMapState extends State<MaplibreMap> {
  final Completer<MapLibreMapController> _controller = Completer();

  bool _mapInitialized = false;
  bool lineDisplay = true;

  // 初始相机位置
  static const CameraPosition _initialCameraPosition = CameraPosition(
    // target: LatLng(44.341538, 86.008825),
    // target: LatLng(44.856219, 85.452456), //贴图点
    target: LatLng(44.34094461041972, 86.00426167774084), //折线
    zoom: 14,
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('矢量瓦片示例')),
      body: Stack(
        children: [
          // 地图组件
          MapLibreMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition: _initialCameraPosition,
            onStyleLoadedCallback: _onStyleLoaded,
            // 使用空样式，我们将手动添加栅格图层
            styleString: '{"version": 8,"sources": {},"layers": []}',
          ),
          // 加载指示器
          if (!_mapInitialized)
            const Center(child: CircularProgressIndicator()),
        ],
      ),
      // 添加一个按钮来重置地图视角
      floatingActionButton: _mapInitialized
          ? FloatingActionButton(
              onPressed: _resetCamera,
              child: const Icon(Icons.refresh),
            )
          : null,
    );
  }

  // 地图创建完成回调
  void _onMapCreated(MapLibreMapController controller) {
    _controller.complete(controller);
  }

  // 样式加载完成回调
  void _onStyleLoaded() async {
    final controller = await _controller.future;
    // 添加底图数据源
    await controller.addSource(
      "raster_source",
      const RasterSourceProperties(
        tiles: [
          "https://t1.tianditu.gov.cn/img_w/wmts?SERVICE=WMTS&REQUEST=GetTile&VERSION=1.0.0&LAYER=img&STYLE=default&TILEMATRIXSET=w&FORMAT=tiles&TILEMATRIX={z}&TILEROW={y}&TILECOL={x}&tk=2e4da3804eb62318a09cd95a01f8b17d",
        ],
        tileSize: 256,
        scheme: "xyz", // 添加这个配置
        minzoom: 0, // 添加最小缩放级别
        maxzoom: 18, // 添加最大缩放级别
      ),
    );
    // 添加标注数据源
    await controller.addSource(
      "annoation_source",
      const RasterSourceProperties(
        tiles: [
          "https://t0.tianditu.gov.cn/cia_w/wmts?SERVICE=WMTS&REQUEST=GetTile&VERSION=1.0.0&LAYER=cia&STYLE=default&TILEMATRIXSET=w&FORMAT=tiles&TILEMATRIX={z}&TILEROW={y}&TILECOL={x}&tk=2e4da3804eb62318a09cd95a01f8b17d",
        ],
        tileSize: 256,
        scheme: "xyz", // 添加这个配置
        minzoom: 0, // 添加最小缩放级别
        maxzoom: 18, // 添加最大缩放级别
      ),
    );
    // 添加矢量图层数据源
    await controller.addSource(
      "boundary",
      const VectorSourceProperties(
        tiles: [
          "http://192.168.31.31:8080/jtytapi/web/boundary/tiles/{z}/{x}/{y}/?year=2025&token=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoiYWNjZXNzIiwiZXhwIjoxNzQ3NzA2NDM1LCJpYXQiOjE3NDY4NDI0MzUsImp0aSI6Ijc2YjY1YjZkNzVmMzQ1NzE5YzIxZTRiMWFiY2NiYmYxIiwidXNlcl9pZCI6IlM0eUJ5MmJuWGhFeEc3dmNFTVA5SGsiLCJ1c2VybmFtZSI6Ilx1OWE2Y1x1NGUxNlx1Njc3MCIsInVzZXIiOiJtc2oxMzY0OTk5NTIyOSIsImNsaWVudF90eXBlIjoid2ViIn0.6mvtw5SX0Oe7vxkTsCQCzgpofg_iE1uo22Z4HjpE2vM&parent=3138&qualified=",
        ],
        // tileSize: 512,
        scheme: "xyz", // 添加这个配置
        minzoom: 0, // 添加最小缩放级别
        maxzoom: 18, // 添加最大缩放级别
      ),
    );

    // 添加栅格图层
    await controller.addRasterLayer(
      "raster_source",
      "raster_layer",
      const RasterLayerProperties(rasterOpacity: 1, rasterFadeDuration: 300),
    );

    // 添加标注图层
    await controller.addRasterLayer(
      "annoation_source",
      "annoation_layer",
      const RasterLayerProperties(rasterOpacity: 1, rasterFadeDuration: 300),
    );
    // // 添加矢量图层
    try {
      await controller.addLayer(
        "boundary",
        "layerId",
        const FillLayerProperties(
          fillColor: "#ff69b4",
          fillOpacity: 0,
          fillOutlineColor: "#ff69b4",
        ),
        sourceLayer: "boundary",
      );
      // await controller.addLayer(
      //   "boundary",
      //   "textlayerId",
      //   SymbolLayerProperties(
      //     textField: [Expressions.get, "name"],
      //     textFont: ['Open Sans Semibold'],
      //     textSize: 12,
      //     textOffset: [
      //       Expressions.literal,
      //       [0, 2],
      //     ],
      //     textAnchor: 'center',
      //     textHaloColor: Colors.white.toHexStringRGB(),
      //     textHaloWidth: 1,
      //     textAllowOverlap: true,
      //   ),
      //   sourceLayer: "boundary",
      // );
    } catch (e) {
      print(e);
    }
    controller.onFeatureTapped.add((id, point, latLng, layerId) async {
      // 只处理特定图层的点击事件
      if (layerId == "layerId") {
        List features = await controller.queryRenderedFeatures(
          point,
          [layerId],
          ["all"],
        );
        print("点击了边界图层上的要素，ID: $id，坐标: $latLng");
        print(features);
        // 在这里处理点击事件
      }
    });

    // 从资源文件加载
    ByteData imageFile = await rootBundle.load('assets/image/test_image.png');
    Uint8List imageBytes = imageFile.buffer.asUint8List();
    LatLngQuad latLngQuad = LatLngQuad(
      topLeft: LatLng(44.856219, 85.452456), // (yMax, xMin)
      topRight: LatLng(44.856219, 85.458053), // (yMax, xMax)
      bottomRight: LatLng(44.849842, 85.458053), // (yMin, xMax)
      bottomLeft: LatLng(44.849842, 85.452456), // (yMin, xMin)
    );
    // 添加图片源
    await controller.addImageSource(
      'image-source-id',
      imageBytes, // Uint8List类型的图片数据
      latLngQuad, // 图片的四个角坐标
    );
    // 添加图片图层
    await controller.addImageLayer(
      'image-layer-id',
      'image-source-id',
      // minzoom: 10,
      // maxzoom: 20,
    );

    try {
      // 添加线数据源
      await controller.addSource(
        "line-source",
        const GeojsonSourceProperties(
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

      // 添加线图层
      await controller.addLayer(
        "line-source",
        "line-layer",
        LineLayerProperties(
          lineColor: "#ffffff",
          lineWidth: 5,
          // lineOpacity: lineDisplay ? 1 : 0,
        ),
      );
      print('折线添加成功');
    } catch (e) {
      print('添加折线时出错: $e');
    }
    // 更新状态，隐藏加载指示器
    setState(() {
      _mapInitialized = true;
    });
  }

  // 重置相机位置
  void _resetCamera() async {
    final controller = await _controller.future;
    controller.animateCamera(
      CameraUpdate.newCameraPosition(_initialCameraPosition),
    );

    lineDisplay = !lineDisplay;
    // 更新图层属性
    await controller.setLayerProperties(
      "line-layer",
      LineLayerProperties(
        lineColor: "#ffffff",
        lineWidth: 5,
        // lineOpacity: lineDisplay ? 1 : 0,
        visibility: lineDisplay ? "visible" : "none",
      ),
    );
  }
}
