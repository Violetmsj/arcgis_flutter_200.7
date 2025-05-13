import 'package:arcgis_flutter_newest/widget/center_crosser.dart';
import 'package:arcgis_maps/arcgis_maps.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'index.dart';

class ArcgisMapPage extends GetView<ArcgisMapController> {
  const ArcgisMapPage({super.key});
  Widget _buildMapView() {
    return LayoutBuilder(
      builder: (context, constraints) {
        controller.mapCenterOffset = Offset(
          constraints.maxWidth / 2,
          constraints.maxHeight / 2,
        );
        return ArcGISMapView(
          controllerProvider: () => controller.mapViewController,
          onMapViewReady: controller.onMapViewReady,
          onTap: controller.onMapTap,
        );
      },
    );
  }

  // 跳转按钮组件
  Widget _buildJumpButton({
    required String title,
    required Map<String, double> latLng,
  }) {
    return ElevatedButton(
      onPressed: () {
        controller.mapViewController.setViewpoint(
          Viewpoint.withLatLongScale(
            latitude: latLng['lat']!,
            longitude: latLng['lng']!,
            scale: controller.levelToScale(15),
          ),
        );
      },
      child: Text(title),
    );
  }

  // 地图跳转按钮
  Widget _buildJumpButtonsView() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildJumpButton(
          title: "贴图点",
          latLng: {"lat": 44.856219, "lng": 85.452456},
        ),
        _buildJumpButton(
          title: "FeatureLayer",
          latLng: {"lat": 45.089596, "lng": 85.265665},
        ),
        _buildJumpButton(
          title: "graphics",
          latLng: {"lat": 44.341538, "lng": 86.008825},
        ),
      ],
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
              onPressed: controller.onStartDrawPolygon,
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
      children: <Widget>[
        // 地图
        _buildMapView(),
        _buildJumpButtonsView(),
        CenterCrosser(),
        _buildDrawButtonsView(),
        if (controller.isDrawingMode) _buildDrawLandArea(),
      ],
    );
  }

  Widget _buildDrawLandArea() {
    return Positioned(
      left: 150,
      right: 150,
      top: 100, // 距离顶部100像素
      child: Container(
        // 这里可以设置Container的样式
        width: 300, // 设置宽度
        height: 50, // 设置高度
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.6),
          borderRadius: BorderRadius.circular(10), // 设置10像素的圆角
        ),

        child: Center(
          child: Text(
            "${controller.drawPolygonArea.toStringAsFixed(2)}亩",
            style: TextStyle(color: Colors.white, fontSize: 15),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ArcgisMapController>(
      init: ArcgisMapController(),
      id: "arcgismap",
      builder: (_) {
        return Scaffold(
          appBar: AppBar(title: const Text("arcgismap")),
          body: _buildView(),
        );
      },
    );
  }
}
