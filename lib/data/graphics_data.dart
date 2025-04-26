import 'package:arcgis_flutter_newest/utils/point_util.dart';
import 'package:arcgis_maps/arcgis_maps.dart';

class GraphicsData {
  static List<ArcGISPoint> pointData() {
    // var pointUtil = PointUtil();
    return [PointUtil.WGS84Point(lat: 44.341538, lng: 86.008825)];
  }

  static List<ArcGISPoint> polylineData() {
    // var pointUtil = PointUtil();
    return [
      PointUtil.WGS84Point(lat: 44.34094461041972, lng: 86.00426167774084),
      PointUtil.WGS84Point(lat: 44.337967341789394, lng: 86.00517720325354),
      PointUtil.WGS84Point(lat: 44.33682141116668, lng: 86.00693672884825),
      PointUtil.WGS84Point(lat: 44.336698631557404, lng: 86.01185767847899),
    ];
  }

  static List<ArcGISPoint> polygoneData() {
    // var pointUtil = PointUtil();
    return [
      PointUtil.WGS84Point(lat: 44.34780914519289, lng: 86.01210086472511),
      PointUtil.WGS84Point(lat: 44.34782960460126, lng: 86.00606411793922),
      PointUtil.WGS84Point(lat: 44.344883376269514, lng: 86.00534886406899),
      PointUtil.WGS84Point(lat: 44.345384654738204, lng: 86.01160018671037),
    ];
  }

  // "{'x-max': 85.458053, 'y-max': 44.856219,
  // 'x-min': 85.452456, 'y-min': 44.849842}",
  static List<ArcGISPoint> imagePolygoneData() {
    return [
      PointUtil.WGS84Point(lat: 44.856219, lng: 85.452456), // 左上
      PointUtil.WGS84Point(lat: 44.856219, lng: 85.458053), // 右上
      PointUtil.WGS84Point(lat: 44.849842, lng: 85.458053), // 右下
      PointUtil.WGS84Point(lat: 44.849842, lng: 85.452456), // 左下
    ];
  }
}
