import 'package:get/get.dart';

import '../../pages/index.dart';
import 'index.dart';

class RoutePages {
  // 列表
  static List<GetPage> list = [
    GetPage(name: RouteNames.home, page: () => const HomePage()),
    GetPage(name: RouteNames.maplibreMap, page: () => const MaplibreMapPage()),
  ];
}
