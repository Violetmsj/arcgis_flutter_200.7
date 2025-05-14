import 'dart:math';

import 'package:arcgis_flutter_newest/common/widgets/index.dart';
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

  Widget _buildMapView() {
    return LayoutBuilder(
      builder: (context, constraints) {
        controller.mapCenter = Point(
          constraints.maxWidth / 2,
          constraints.maxHeight / 2,
        );
        return MapLibreMap(
          onMapCreated: controller.onMapCreated,
          initialCameraPosition: controller.initialCameraPosition,
          onStyleLoadedCallback: controller.onStyleLoaded,
          // 使用空样式，我们将手动添加栅格图层
          styleString: '{"version": 8,"sources": {},"layers": []}',
          rotateGesturesEnabled: false,
        );
      },
    );
  }

  // 画地功能按钮
  Widget _buildDrawButtonsView() {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 20, // 距离底部20像素
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ElevatedButton(
            onPressed: controller.toggleDrawingMode,
            child: Text(controller.isDrawingMode ? "结束画地" : "开始画地"),
          ),
          if (controller.isDrawingMode) ...[
            ElevatedButton(
              onPressed: controller.onDrawPolygonPoint,
              child: Text("打点"),
            ),
            ElevatedButton(
              onPressed: controller.onFinishDrawPolygon,
              child: Text("完成绘制"),
            ),
            ElevatedButton(
              onPressed: controller.onUndoLastPoint,
              child: Text("撤回"),
            ),
          ],
        ],
      ),
    );
  }

  // 主视图
  Widget _buildView() {
    return Stack(
      children: [
        // 地图组件
        _buildMapView(),
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

        if (controller.isDrawingMode) Center(child: CenterCrosser()),
        _buildDrawButtonsView(),
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
