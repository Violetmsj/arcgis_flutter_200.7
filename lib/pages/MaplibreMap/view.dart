import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'index.dart';

class MaplibreMapPage extends GetView<MaplibreMapController> {
  const MaplibreMapPage({super.key});

  // 主视图
  Widget _buildView() {
    return const Center(child: Text("MaplibremapPage"));
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MaplibreMapController>(
      init: MaplibreMapController(),
      id: "maplibremap",
      builder: (_) {
        return Scaffold(
          appBar: AppBar(title: const Text("maplibremap")),
          body: SafeArea(child: _buildView()),
        );
      },
    );
  }
}
