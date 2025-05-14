import 'package:arcgis_flutter_newest/pages/MaplibreMap/mixins/map_state_mixin.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:maplibre_gl/maplibre_gl.dart';

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
            Get.dialog(
              AlertDialog(
                title: const Text('地块信息'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('地块编号: ${properties["id"]}'),
                    Text('地块名称: ${properties["name"]}'),
                    Text('地块面积: ${properties["areaComp"]}'),
                    Text('地块地点: ${properties["location"]}'),
                    Text('地块类型: ${properties["soliType"]}'),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () => Get.back(),
                    child: const Text('关闭'),
                  ),
                ],
              ),
            );
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
