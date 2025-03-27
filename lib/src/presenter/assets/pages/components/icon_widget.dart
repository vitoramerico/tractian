import 'package:flutter/material.dart';

import '../../../../domain/enum/node_type_enum.dart';

class IconWidget extends StatelessWidget {
  final NodeTypeEnum nodeType;

  const IconWidget({super.key, required this.nodeType});

  @override
  Widget build(BuildContext context) {
    if (nodeType == NodeTypeEnum.location) {
      return _BuildIconWidget('location.png');
    } else if (nodeType == NodeTypeEnum.asset) {
      return _BuildIconWidget('asset.png');
    } else if (nodeType == NodeTypeEnum.component) {
      return _BuildIconWidget('component.png');
    }

    return Container();
  }
}

class _BuildIconWidget extends StatelessWidget {
  final String iconName;

  const _BuildIconWidget(this.iconName);

  @override
  Widget build(BuildContext context) {
    return Image.asset('assets/icons/$iconName', width: 16, height: 16);
  }
}
