import 'package:arcgis_flutter_newest/pages/MaplibreMap/mixins/map_state_mixin.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:maplibre_gl/maplibre_gl.dart';

import '../widgets/feature_polygon_dialog.dart';

mixin EventHandlerMixin on MapStateMixin {
  void setupEventHandlers(MapLibreMapController controller) {
    _setupFeatureTapHandler(controller);
  }

  void _setupFeatureTapHandler(MapLibreMapController controller) {
    controller.onFeatureTapped.add((id, point, latLng, layerId) async {
      if (layerId == "polygon-layer") {
        if (layerId == "polygon-layer") {
          List features = await controller.queryRenderedFeatures(
            point,
            [layerId],
            ["all"],
          );
          if (features.isNotEmpty) {
            var properties = features.first['properties'];
            Get.dialog(FeaturePolygonDialog(properties: properties));
          }
          // 在这里处理点击事件
        }
      }
    });
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
  }
}
