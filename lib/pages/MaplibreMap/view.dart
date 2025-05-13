import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:maplibre_gl/maplibre_gl.dart';

import 'index.dart';

class MaplibreMapPage extends GetView<MaplibreMapPageController> {
  const MaplibreMapPage({super.key});

  // 主视图
  Widget _buildView() {
    return Stack(
      children: [
        // 地图组件
        MapLibreMap(
          onMapCreated: controller.onMapCreated,
          initialCameraPosition: controller.initialCameraPosition,
          onStyleLoadedCallback: controller.onStyleLoaded,
          // 使用空样式，我们将手动添加栅格图层
          styleString: '{"version": 8,"sources": {},"layers": []}',
          rotateGesturesEnabled: false,
        ),
        // 加载指示器
        if (!controller.mapInitialized)
          const Center(child: CircularProgressIndicator()),
      ],
    );
  }

  Widget _buildResetButton() {
    return FloatingActionButton(
      onPressed: controller.resetCamera,
      child: const Icon(Icons.refresh),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MaplibreMapPageController>(
      init: MaplibreMapPageController(),
      id: "maplibremap",
      builder: (_) {
        return Scaffold(
          appBar: AppBar(title: const Text("maplibremap")),
          body: _buildView(),
          floatingActionButton:
              controller.mapInitialized ? _buildResetButton() : null,
        );
      },
    );
  }
}
