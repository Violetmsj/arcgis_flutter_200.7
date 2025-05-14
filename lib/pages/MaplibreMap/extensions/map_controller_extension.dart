import 'package:maplibre_gl/maplibre_gl.dart';

extension MapControllerExtension on MapLibreMapController {
  Future<void> toggleLayerVisibility(String layerId, bool visible) async {
    await setLayerProperties(
      layerId,
      LineLayerProperties(visibility: visible ? "visible" : "none"),
    );
  }

  Future<void> updateLayerStyle(
    String layerId,
    LineLayerProperties style,
  ) async {
    await setLayerProperties(layerId, style);
  }
}
