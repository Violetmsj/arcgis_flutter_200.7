import 'package:arcgis_flutter_newest/arcgis_map.dart';
import 'package:arcgis_flutter_newest/maplibre_map.dart';

import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    const MaterialApp(
      // home: MainApp(),
      home: MaplibreMap(),
      // home: Placeholder(),
    ),
  );
}
