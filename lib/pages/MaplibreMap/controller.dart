import 'package:get/get.dart';

class MaplibreMapController extends GetxController {
  MaplibreMapController();

  _initData() {
    update(["maplibremap"]);
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
