import 'package:arcgis_maps/arcgis_maps.dart';

class ImageOverlayManager {
  final List<ImageOverlay> _imageOverlays = [];

  List<ImageOverlay> get overlays => _imageOverlays;

  Future<ImageOverlay> createImageOverlay({
    required String imagePath,
    required Envelope extent,
  }) async {
    final image = await ArcGISImage.fromAsset(imagePath);

    // 确保坐标系是Web Mercator
    final webMercatorExtent =
        extent.spatialReference == SpatialReference.webMercator
            ? extent
            : GeometryEngine.project(
                  extent,
                  outputSpatialReference: SpatialReference.webMercator,
                )
                as Envelope;

    final imageFrame = ImageFrame.withImageEnvelope(
      image: image,
      extent: webMercatorExtent,
    );

    final imageOverlay =
        ImageOverlay(imageFrame: imageFrame)
          ..isVisible = true
          ..opacity = 1;

    _imageOverlays.add(imageOverlay);
    return imageOverlay;
  }

  void clear() {
    _imageOverlays.clear();
  }
}
