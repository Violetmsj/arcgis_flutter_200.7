import 'dart:ffi';
import 'dart:typed_data';

import 'package:arcgis_flutter_newest/pages/MaplibreMap/mixins/map_state_mixin.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:maplibre_gl/maplibre_gl.dart';

mixin FeatureLayerMixin on MapStateMixin {
  Future<void> addFeatureLayers(MapLibreMapController controller) async {
    await _addImageSource(controller);
    await _addImageLayer(controller);
    await _addLineSource(controller);
    await _addLineLayer(controller);
    await _addPolygonSource(controller);
    await _addPolygonLayer(controller);
  }

  Future<void> _addImageSource(MapLibreMapController controller) async {
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
  }

  // 添加图片图层
  Future<void> _addImageLayer(MapLibreMapController controller) async {
    await controller.addImageLayer(
      'image-layer-id',
      'image-source-id',
      // minzoom: 10,
      // maxzoom: 20,
    );
  }

  Future<void> _addLineSource(MapLibreMapController controller) async {
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
  }

  // 添加line图层
  Future<void> _addLineLayer(MapLibreMapController controller) async {
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
  }

  // 添加面数据源
  Future<void> _addPolygonSource(MapLibreMapController controller) async {
    await controller.addSource(
      "polygon-source",
      const GeojsonSourceProperties(
        data: {
          "type": "Feature",
          "properties": {
            "id": "DNwHaco86QmoggkJxKpsCa",
            "name": "测试地块2",
            "areaComp": 355.49,
            "location": "塔城地区 新疆维吾尔自治区塔城地区沙湾市兵团一二一团",
            "soliType": "荒漠风沙土",
          },
          "geometry": {
            "type": "Polygon",
            "coordinates": [
              [
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
              ],
            ],
          },
        },
      ),
    );
  }

  // 添加要素多边形图层
  Future<void> _addPolygonLayer(MapLibreMapController controller) async {
    await controller.addLayer(
      "polygon-source",
      "polygon-layer",
      FillLayerProperties(
        fillOutlineColor: "#000",
        fillOpacity: 0.5,
        fillColor: "#ff69b4",
      ),
    );
  }

  // ... 其他私有方法
}
