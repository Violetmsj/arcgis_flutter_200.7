import 'package:arcgis_maps/arcgis_maps.dart';
import 'package:flutter/material.dart';

class GraphicsStyleConfig {
  /// 点图形样式
  static SimpleMarkerSymbol get defaultPointSymbol => SimpleMarkerSymbol(
    style: SimpleMarkerSymbolStyle.circle,
    color: Colors.blue,
    size: 12,
  );

  /// 线图形样式
  static SimpleLineSymbol get defaultLineSymbol => SimpleLineSymbol(
    style: SimpleLineSymbolStyle.solid,
    color: Colors.blue,
    width: 2,
  );

  /// 面图形样式
  static SimpleFillSymbol get defaultPolygonSymbol => SimpleFillSymbol(
    style: SimpleFillSymbolStyle.solid,
    color: Colors.transparent,
    outline: defaultLineSymbol,
  );
  // 画地时点样式
  static SimpleMarkerSymbol get drawPolygonPointSymbol => SimpleMarkerSymbol(
    style: SimpleMarkerSymbolStyle.circle,
    color: Colors.red,
    size: 12,
  );
}
