import 'dart:async';

import 'package:arcgis_maps/arcgis_maps.dart';
import 'package:flutter/material.dart';
import 'package:maplibre_gl/maplibre_gl.dart';

class MaplibreMap extends StatefulWidget {
  const MaplibreMap({Key? key}) : super(key: key);

  @override
  _MaplibreMapState createState() => _MaplibreMapState();
}

class _MaplibreMapState extends State<MaplibreMap> {
  final Completer<MapLibreMapController> _controller = Completer();

  bool _mapInitialized = false;

  // 初始相机位置
  static const CameraPosition _initialCameraPosition = CameraPosition(
    target: LatLng(44.341538, 86.008825),
    zoom: 4.0,
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
      floatingActionButton:
          _mapInitialized
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
          fillOpacity: 0.5,
          fillOutlineColor: "#ff69b4",
        ),
        sourceLayer: "boundary",
      );
      await controller.addLayer(
        "boundary",
        "textlayerId",
        SymbolLayerProperties(
          textField: [Expressions.get, "name"],
          textFont: ['Open Sans Semibold'],
          textSize: 12,
          textOffset: [
            Expressions.literal,
            [0, 2],
          ],
          textAnchor: 'center',
          textHaloColor: Colors.white.toHexStringRGB(),
          textHaloWidth: 1,
          textAllowOverlap: true,
        ),
        sourceLayer: "boundary",
      );
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
  }
}
