import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:maplibre_gl/maplibre_gl.dart';

import 'index.dart';

class MaplibreMapPage extends GetView<MaplibreMapPageController> {
  const MaplibreMapPage({super.key});

  Widget _buildCameraJumpButton({
    required String title,
    required CameraPosition cameraPosition,
  }) {
    return ElevatedButton(
      onPressed: () {
        controller.updateCamera(cameraPosition);
      },
      child: Text(title),
    );
  }

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
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildCameraJumpButton(
              title: "贴图点",
              cameraPosition: CameraPosition(
                target: LatLng(44.856219, 85.452456), //贴图点
                zoom: 14,
              ),
            ),
            _buildCameraJumpButton(
              title: "要素多边形",
              cameraPosition: CameraPosition(
                target: LatLng(45.08959, 85.265665),
                zoom: 14,
              ),
            ),
            _buildCameraJumpButton(
              title: "普通图形",
              cameraPosition: CameraPosition(
                target: LatLng(44.341538, 86.008825),
                zoom: 14,
              ),
            ),
          ],
        ),
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
