import '../enum/node_type_enum.dart';
import '../enum/sensor_type_enum.dart';
import '../enum/status_enum.dart';

class TreeNodeEntity {
  final String id;
  final String name;
  final NodeTypeEnum type;
  List<TreeNodeEntity> children = [];
  final SensorTypeEnum? sensorType;
  final StatusEnum? status;
  bool isExpanded;

  TreeNodeEntity({
    required this.id,
    required this.name,
    required this.type,
    this.isExpanded = false,
    this.sensorType,
    this.status,
  });
}
