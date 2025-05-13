# ArcGIS & Maplibre Flutter 学习项目

这是一个用于学习和实践地图开发的 Flutter 项目，集成了 ArcGIS Flutter SDK 和 Maplibre GL 两个地图库，用于探索不同地图服务的功能实现。

## 项目功能

### ArcGIS 地图功能
- 天地图服务加载与显示
- 要素图层（FeatureLayer）管理
- 图形覆盖物（Graphics）绘制与管理
- 地图坐标转换工具
- 图像叠加层管理

### Maplibre 地图功能
- 矢量瓦片地图加载
- 图像叠加层

## 项目结构

```
lib/
├── config/                 # 配置文件
│   ├── graphics_style_config.dart    # 图形样式配置
│   └── tianditu_config.dart          # 天地图配置
├── data/                  # 数据文件
│   ├── feature_layer_data.dart       # 要素图层数据
│   └── graphics_data.dart            # 图形数据
├── utils/                 # 工具类
│   ├── graphics_manager.dart         # 图形管理
│   ├── image_overlay_manager.dart    # 图像叠加层管理
│   └── point_util.dart               # 坐标工具
├── widget/                # 自定义组件
│   └── center_crosser.dart           # 中心十字组件
├── arcgis_map.dart        # ArcGIS 地图页面
├── maplibre_map.dart      # Maplibre 地图页面
└── main.dart             # 应用入口
```

## 技术栈

- Flutter SDK
- ArcGIS Maps SDK for Flutter
- Maplibre GL Native for Flutter
- Maps Toolkit（用于地图计算）

## 开发环境配置

1. 确保已安装 Flutter 开发环境
2. 克隆项目到本地
3. 运行以下命令安装依赖：
   ```bash
   flutter pub get
   ```
4. 运行项目：
   ```bash
   flutter run
   ```

## 注意事项

- 使用 ArcGIS 功能需要配置相应的 API Key
- 天地图服务需要配置天地图密钥
- Maplibre 矢量瓦片服务需要配置相应的地图服务地址

## 参考资源

- [ArcGIS Maps SDK for Flutter 文档](https://developers.arcgis.com/flutter/)
- [Maplibre GL Native 文档](https://maplibre.org/maplibre-gl-native/docs/)
- [Flutter 官方文档](https://flutter.dev/docs)
