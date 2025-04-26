import 'dart:math';
import 'package:arcgis_maps/arcgis_maps.dart';

class TianDiTuConfig {
  static const String apiKey = "2e4da3804eb62318a09cd95a01f8b17d";

  /// 影像底图图层模板
  static const String imgTemplate =
      "http://t1.tianditu.gov.cn/img_w/wmts?SERVICE=WMTS&REQUEST=GetTile&VERSION=1.0.0&LAYER=img&STYLE=default&TILEMATRIXSET=w&FORMAT=tiles&TILEMATRIX={level}&TILEROW={row}&TILECOL={col}&tk=$apiKey";

  /// 注记图层模板
  static const String ciaTemplate =
      "http://t1.tianditu.gov.cn/cia_w/wmts?SERVICE=WMTS&REQUEST=GetTile&VERSION=1.0.0&LAYER=cia&STYLE=default&TILEMATRIXSET=w&FORMAT=tiles&TILEMATRIX={level}&TILEROW={row}&TILECOL={col}&tk=$apiKey";

  /// 获取天地图瓦片信息配置
  static TileInfo get tileInfo => TileInfo(
      dpi: 96,
      format: TileImageFormat.png,
      levelsOfDetail: List.generate(
          19,
          (index) => LevelOfDetail(
              level: index,
              scale: 591657527.591555 / pow(2, index),
              resolution: 156543.03392804097 / pow(2, index))),
      origin: ArcGISPoint(
          x: -20037508.3427892,
          y: 20037508.3427892,
          spatialReference: SpatialReference.webMercator),
      spatialReference: SpatialReference.webMercator,
      tileHeight: 256,
      tileWidth: 256);

  /// 创建影像底图图层
  static WebTiledLayer createImgLayer() {
    return WebTiledLayer(template: imgTemplate, tileInfo: tileInfo);
  }

  /// 创建注记图层
  static WebTiledLayer createAnnotationLayer() {
    return WebTiledLayer(template: ciaTemplate);
  }
}
