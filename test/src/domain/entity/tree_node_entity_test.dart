import 'package:flutter_test/flutter_test.dart';
import 'package:tractian/src/domain/entity/tree_node_entity.dart';
import 'package:tractian/src/domain/enum/node_type_enum.dart';
import 'package:tractian/src/domain/enum/sensor_type_enum.dart';
import 'package:tractian/src/domain/enum/status_enum.dart';

void main() {
  group('TreeNodeEntity Tests', () {
    test('should initialize required fields with default values', () {
      final node = TreeNodeEntity(
        id: 'node1',
        name: 'Root Node',
        type: NodeTypeEnum.location,
      );
      expect(node.id, equals('node1'));
      expect(node.name, equals('Root Node'));
      expect(node.type, equals(NodeTypeEnum.location));
      expect(node.children, isEmpty);
      expect(node.isExpanded, isFalse);
      expect(node.sensorType, isNull);
      expect(node.status, isNull);
    });

    test('should initialize sensorType and status when provided', () {
      final node = TreeNodeEntity(
        id: 'node2',
        name: 'Sensor Node',
        type: NodeTypeEnum.location,
        sensorType: SensorTypeEnum.vibration,
        status: StatusEnum.operating,
      );
      expect(node.sensorType, equals(SensorTypeEnum.vibration));
      expect(node.status, equals(StatusEnum.operating));
    });

    test('should add children correctly', () {
      final child = TreeNodeEntity(
        id: 'child1',
        name: 'Child Node',
        type: NodeTypeEnum.component,
      );
      final parent = TreeNodeEntity(
        id: 'node3',
        name: 'Parent Node',
        type: NodeTypeEnum.asset,
      );
      parent.children.add(child);
      expect(parent.children, contains(child));
      expect(parent.children.first.name, equals('Child Node'));
    });

    test('should toggle isExpanded correctly', () {
      final node = TreeNodeEntity(
        id: 'node4',
        name: 'Expandable Node',
        type: NodeTypeEnum.location,
      );
      expect(node.isExpanded, isFalse);
      node.isExpanded = true;
      expect(node.isExpanded, isTrue);
    });
  });
}
