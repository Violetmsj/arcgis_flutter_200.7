import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FeaturePolygonDialog extends StatelessWidget {
  final Map<String, dynamic> properties;

  const FeaturePolygonDialog({Key? key, required this.properties})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('地块信息'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('地块编号: ${properties["id"]}'),
          Text('地块名称: ${properties["name"]}'),
          Text('地块面积: ${properties["areaComp"]}'),
          Text('地块地点: ${properties["location"]}'),
          Text('地块类型: ${properties["soliType"]}'),
        ],
      ),
      actions: [
        TextButton(onPressed: () => Get.back(), child: const Text('关闭')),
      ],
    );
  }
}
