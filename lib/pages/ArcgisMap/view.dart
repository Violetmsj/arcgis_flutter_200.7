import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'index.dart';

class ArcgisMapPage extends GetView<ArcgisMapController> {
  const ArcgisMapPage({super.key});

  // 主视图
  Widget _buildView() {
    return const Center(child: Text("ArcgismapPage"));
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ArcgisMapController>(
      init: ArcgisMapController(),
      id: "arcgismap",
      builder: (_) {
        return Scaffold(
          appBar: AppBar(title: const Text("arcgismap")),
          body: SafeArea(child: _buildView()),
        );
      },
    );
  }
}
