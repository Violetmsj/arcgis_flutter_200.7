import 'package:arcgis_flutter_newest/config/graphics_style_config.dart';
import 'package:arcgis_flutter_newest/data/graphics_data.dart';
import 'package:arcgis_flutter_newest/utils/creat_graphics.dart';
import 'package:arcgis_maps/arcgis_maps.dart';

class GraphicsManager {
  final GraphicsOverlay _graphicsOverlay = GraphicsOverlay();

  GraphicsOverlay get overlay => _graphicsOverlay;

  /// 添加所有图形
  void addAllGraphics() {
    addPointGraphics();
    addPolylineGraphics();
    addPolygonGraphics();
  }

  /// 添加点图形
  void addPointGraphics() {
    final points = GraphicsData.pointData();
    for (var point in points) {
      final graphic = CreateGraphics.createPointGraphics(
        point,
        GraphicsStyleConfig.defaultPointSymbol,
      );
      _graphicsOverlay.graphics.add(graphic);
    }
  }

  /// 添加线图形
  void addPolylineGraphics() {
    final points = GraphicsData.polylineData();
    final graphic = CreateGraphics.createPolylineGraphics(
      points,
      GraphicsStyleConfig.defaultLineSymbol,
    );
    _graphicsOverlay.graphics.add(graphic);
  }

  /// 添加面图形
  void addPolygonGraphics() {
    final points = GraphicsData.polygoneData();
    final graphic = CreateGraphics.createPolygonGraphics(
      points,
      GraphicsStyleConfig.defaultPolygonSymbol,
    );
    _graphicsOverlay.graphics.add(graphic);
  }
}
