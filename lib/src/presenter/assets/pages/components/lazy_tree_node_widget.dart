import 'package:flutter/material.dart';

import '../../../../domain/entity/tree_node_entity.dart';
import '../../../../domain/enum/sensor_type_enum.dart';
import '../../../../domain/enum/status_enum.dart';
import 'energy_and_alert_widget.dart';
import 'icon_widget.dart';

class LazyTreeNode extends StatefulWidget {
  final TreeNodeEntity node;

  const LazyTreeNode({super.key, required this.node});

  @override
  State<LazyTreeNode> createState() => _LazyTreeNodeState();
}

class _LazyTreeNodeState extends State<LazyTreeNode> {
  @override
  Widget build(BuildContext context) {
    final hasChildren = widget.node.children.isNotEmpty;

    if (hasChildren) {
      final isExpanded = widget.node.isExpanded;

      return Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          key: Key(widget.node.id),
          showTrailingIcon: false,
          childrenPadding: EdgeInsets.only(left: 8),
          tilePadding: EdgeInsets.zero,
          dense: true,
          initiallyExpanded: isExpanded,
          title: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                isExpanded
                    ? Icons.keyboard_arrow_up_outlined
                    : Icons.keyboard_arrow_down_outlined,
              ),
              IconWidget(nodeType: widget.node.type),
              const SizedBox(width: 8),
              Text(widget.node.name),
            ],
          ),
          children: [
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: widget.node.children.length,
              itemBuilder: (context, index) {
                return LazyTreeNode(node: widget.node.children[index]);
              },
            ),
          ],
          onExpansionChanged: (expanded) {
            setState(() {
              widget.node.isExpanded = expanded;
            });
          },
        ),
      );
    }

    return ListTile(
      key: Key(widget.node.id),
      dense: true,
      leading: IconWidget(nodeType: widget.node.type),
      horizontalTitleGap: 0,
      title: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(widget.node.name),
          EnergyAndAlertWidget(
            isEnergy: widget.node.sensorType == SensorTypeEnum.energy,
            hasAlert: widget.node.status == StatusEnum.alert,
          ),
        ],
      ),
    );
  }
}
