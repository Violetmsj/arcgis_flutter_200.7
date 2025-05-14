import 'package:get/get.dart';
import 'package:maplibre_gl/maplibre_gl.dart';
import 'mixins/base_layer_mixin.dart';
import 'mixins/event_handler_mixin.dart';
import 'mixins/feature_layer_mixin.dart';
import 'mixins/map_state_mixin.dart';
import 'extensions/map_controller_extension.dart';

class MaplibreMapPageController extends GetxController
    with MapStateMixin, BaseLayerMixin, FeatureLayerMixin, EventHandlerMixin {
  void onStyleLoaded() async {
    final controller = await mapController.future;

    await addBaseLayers(controller);
    await addFeatureLayers(controller);
    setupEventHandlers(controller);

    mapInitialized = true;
    update(['maplibremap']);
  }

  void resetCamera() async {
    final controller = await mapController.future;
    await controller.moveCamera(
      CameraUpdate.newCameraPosition(initialCameraPosition),
    );

    lineDisplay = !lineDisplay;
    await controller.toggleLayerVisibility("line-layer", lineDisplay);
  }

  void updateCamera(CameraPosition cameraPosition) async {
    final controller = await mapController.future;
    await controller.moveCamera(
      CameraUpdate.newCameraPosition(cameraPosition),
      // duration: Duration(milliseconds: 3000),
    );
  }

  @override
  void onReady() {
    super.onReady();
    update(["maplibremap"]);
  }
}
