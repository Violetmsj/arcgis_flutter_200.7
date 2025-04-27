import 'dart:convert';

class FeatureData {
  final String id;
  final String name;
  final double areaComp;
  final String location;
  final List<List<double>> latLot;
  final String soliType;

  FeatureData({
    required this.id,
    required this.name,
    required this.areaComp,
    required this.location,
    required this.latLot,
    required this.soliType,
  });

  factory FeatureData.fromJson(Map<String, dynamic> json) {
    List<List<double>> parseLatLot(String latLotStr) {
      final List<dynamic> parsed = jsonDecode(latLotStr);
      return parsed.map<List<double>>((item) {
        return (item as List).map<double>((e) => e.toDouble()).toList();
      }).toList();
    }

    return FeatureData(
      id: json['id'],
      name: json['name'],
      areaComp: json['areaComp'].toDouble(),
      location: json['location'],
      latLot: parseLatLot(json['lat_lot']),
      soliType: json['soliType'],
    );
  }
}

class FeatureResponse {
  final List<FeatureData> data;

  FeatureResponse({required this.data});
}

// 静态数据
final staticFeatureData = FeatureResponse(
  data: [
    FeatureData(
      id: "h8WkShXTiULvVmccHZNn4i",
      name: "测试地块1",
      areaComp: 454.07,
      location: "塔城地区 新疆维吾尔自治区塔城地区沙湾市兵团一二一团S20五克高速",
      latLot: [
        [85.452483, 44.856212],
        [85.452456, 44.856219],
        [85.458053, 44.856152],
        [85.458042, 44.849842],
        [85.45257, 44.850045],
        [85.452483, 44.856212],
      ],
      soliType: "盐化灰漠土",
    ),
    FeatureData(
      id: "DNwHaco86QmoggkJxKpsCa",
      name: "测试地块2",
      areaComp: 355.49,
      location: "塔城地区 新疆维吾尔自治区塔城地区沙湾市兵团一二一团",
      latLot: [
        [85.265665, 45.089596],
        [85.264357, 45.08952],
        [85.262812, 45.089982],
        [85.261599, 45.089808],
        [85.261589, 45.088868],
        [85.259325, 45.088846],
        [85.257211, 45.088944],
        [85.257286, 45.092815],
        [85.264367, 45.092663],
        [85.265032, 45.091163],
        [85.265269, 45.090876],
        [85.265665, 45.089596],
      ],
      soliType: "荒漠风沙土",
    ),
  ],
);
