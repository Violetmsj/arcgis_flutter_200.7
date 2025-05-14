import 'package:maplibre_gl/maplibre_gl.dart';

import 'map_state_mixin.dart';

mixin BaseLayerMixin on MapStateMixin {
  Future<void> addBaseLayers(MapLibreMapController controller) async {
    await _addRasterSource(controller);
    await _addAnnotationSource(controller);
    await _addBoundarySource(controller);

    await _addRasterLayers(controller);
    await _addAnnotationLayer(controller);
    await _addBoundaryLayer(controller);
  }

  // 添加底图数据源
  Future<void> _addRasterSource(MapLibreMapController controller) async {
    await controller.addSource(
      "raster_source",
      const RasterSourceProperties(
        tiles: [
          "https://t1.tianditu.gov.cn/img_w/wmts?SERVICE=WMTS&REQUEST=GetTile&VERSION=1.0.0&LAYER=img&STYLE=default&TILEMATRIXSET=w&FORMAT=tiles&TILEMATRIX={z}&TILEROW={y}&TILECOL={x}&tk=2e4da3804eb62318a09cd95a01f8b17d",
        ],
        tileSize: 256,
        scheme: "xyz",
        minzoom: 0,
        maxzoom: 18,
      ),
    );
  }

  // 添加底图标注数据源
  Future<void> _addAnnotationSource(MapLibreMapController controller) async {
    await controller.addSource(
      "annoation_source",
      const RasterSourceProperties(
        tiles: [
          "https://t0.tianditu.gov.cn/cia_w/wmts?SERVICE=WMTS&REQUEST=GetTile&VERSION=1.0.0&LAYER=cia&STYLE=default&TILEMATRIXSET=w&FORMAT=tiles&TILEMATRIX={z}&TILEROW={y}&TILECOL={x}&tk=2e4da3804eb62318a09cd95a01f8b17d",
        ],
        tileSize: 256,
        scheme: "xyz", // 添加这个配置
        minzoom: 0, // 添加最小缩放级别
        maxzoom: 18, // 添加最大缩放级别
      ),
    );
  }

  // 添加边界矢量瓦片数据源
  Future<void> _addBoundarySource(MapLibreMapController controller) async {
    await controller.addSource(
      "boundary",
      const VectorSourceProperties(
        tiles: [
          "http://192.168.31.31:8080/jtytapi/web/boundary/tiles/{z}/{x}/{y}/?year=2025&token=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoiYWNjZXNzIiwiZXhwIjoxNzQ3NzA2NDM1LCJpYXQiOjE3NDY4NDI0MzUsImp0aSI6Ijc2YjY1YjZkNzVmMzQ1NzE5YzIxZTRiMWFiY2NiYmYxIiwidXNlcl9pZCI6IlM0eUJ5MmJuWGhFeEc3dmNFTVA5SGsiLCJ1c2VybmFtZSI6Ilx1OWE2Y1x1NGUxNlx1Njc3MCIsInVzZXIiOiJtc2oxMzY0OTk5NTIyOSIsImNsaWVudF90eXBlIjoid2ViIn0.6mvtw5SX0Oe7vxkTsCQCzgpofg_iE1uo22Z4HjpE2vM&parent=3138&qualified=",
        ],
        // tileSize: 512,
        scheme: "xyz", // 添加这个配置
        minzoom: 0, // 添加最小缩放级别
        maxzoom: 18, // 添加最大缩放级别
      ),
    );
  }

  // 添加天地图栅格图层
  Future<void> _addRasterLayers(MapLibreMapController controller) async {
    await controller.addRasterLayer(
      "raster_source",
      "raster_layer",
      const RasterLayerProperties(rasterOpacity: 1, rasterFadeDuration: 300),
    );
  }

  // 添加标注图层
  Future<void> _addAnnotationLayer(MapLibreMapController controller) async {
    await controller.addRasterLayer(
      "annoation_source",
      "annoation_layer",
      const RasterLayerProperties(rasterOpacity: 1, rasterFadeDuration: 300),
    );
  }

  // 添加矢量图层
  Future<void> _addBoundaryLayer(MapLibreMapController controller) async {
    await controller.addLayer(
      "boundary",
      "layerId",
      const FillLayerProperties(
        fillColor: "#ff69b4",
        fillOpacity: 0,
        fillOutlineColor: "#ff69b4",
      ),
      sourceLayer: "boundary",
    );
  }

  // ... 其他私有方法
}
