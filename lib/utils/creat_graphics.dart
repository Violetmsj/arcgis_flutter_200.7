import 'package:arcgis_maps/arcgis_maps.dart';
import 'package:flutter/material.dart';

class CreateGraphics {
  static createPointGraphics(
      ArcGISPoint point, SimpleMarkerSymbol pointSymbol) {
    return Graphic(geometry: point, symbol: pointSymbol);
  }

  static createPolylineGraphics(
      List<ArcGISPoint> points, SimpleLineSymbol polylineSymbol) {
    var polylineBuilder =
        PolylineBuilder(spatialReference: SpatialReference.wgs84);
    for (var point in points) {
      polylineBuilder.addPoint(point);
    }
    Polyline polyline = polylineBuilder.toGeometry() as Polyline;
    return Graphic(geometry: polyline, symbol: polylineSymbol);
  }

  static createPolygonGraphics(
      List<ArcGISPoint> points, SimpleFillSymbol polygonSymbol) {
    var polygonBuilder =
        PolygonBuilder(spatialReference: SpatialReference.wgs84);
    for (var point in points) {
      polygonBuilder.addPoint(point);
    }
    Polygon polygon = polygonBuilder.toGeometry() as Polygon;
    return Graphic(geometry: polygon, symbol: polygonSymbol);
  }

  static Graphic createImageGraphics(
      List<ArcGISPoint> points, ArcGISImage image) {
    // 创建图片符号
    final pictureFillSymbol = PictureFillSymbol.withImage(
      image,
    );

    // 创建多边形几何体
    var polygonBuilder =
        PolygonBuilder(spatialReference: SpatialReference.wgs84);
    for (var point in points) {
      polygonBuilder.addPoint(point);
    }
    Polygon polygon = polygonBuilder.toGeometry() as Polygon;

    // 返回图形
    return Graphic(
      geometry: polygon,
      symbol: pictureFillSymbol,
    );
  }
}
