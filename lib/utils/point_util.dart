import 'dart:ui';

import 'package:arcgis_maps/arcgis_maps.dart';

/// 点工具类
class PointUtil {
  //直接使用WGS84经纬度创建ArcGISPoint
  static ArcGISPoint WGS84Point({lat, lng}) {
    return ArcGISPoint(
        x: lng, y: lat, spatialReference: SpatialReference.wgs84);
  }

  static Future<ArcGISPoint?> screenToWGS84(
      {required ArcGISMapViewController mapController,
      required Offset screenPoint}) async {
    final mapPoint = mapController.screenToLocation(screen: screenPoint);
    if (mapPoint != null) {
      // 将 Web 墨卡托坐标转换为 WGS84 经纬度坐标
      return GeometryEngine.project(
        mapPoint,
        outputSpatialReference: SpatialReference.wgs84,
      ) as ArcGISPoint;
    }
    return null;
  }
}
