import 'package:get/get.dart';

import '../../common/routers/names.dart';

class HomeController extends GetxController {
  HomeController();

  _initData() {
    update(["home"]);
  }

  // 添加导航方法
  void toArcgisMap() {
    Get.toNamed(RouteNames.arcgisMap);
  }

  void toMaplibreMap() {
    Get.toNamed(RouteNames.maplibreMap);
  }

  void onTap() {}

  // @override
  // void onInit() {
  //   super.onInit();
  // }

  @override
  void onReady() {
    super.onReady();
    _initData();
  }

  // @override
  // void onClose() {
  //   super.onClose();
  // }
}
