import 'dart:async';

import 'package:get/get.dart';
import 'package:maplibre_gl/maplibre_gl.dart';

mixin MapStateMixin on GetxController {
  bool mapInitialized = false;
  bool lineDisplay = true;
  final Completer<MapLibreMapController> _controller = Completer();
  Completer<MapLibreMapController> get mapController => _controller;
  CameraPosition get initialCameraPosition => CameraPosition(
    // target: LatLng(45.089596, 85.265665),
    // target: LatLng(44.341538, 86.008825),
    // target: LatLng(44.856219, 85.452456), //贴图点
    target: LatLng(44.34094461041972, 86.00426167774084), //折线
    zoom: 14,
  );

  void onMapCreated(MapLibreMapController controller) {
    _controller.complete(controller);
  }
}
