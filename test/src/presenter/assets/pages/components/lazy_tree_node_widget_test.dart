import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tractian/src/domain/entity/tree_node_entity.dart';
import 'package:tractian/src/domain/enum/node_type_enum.dart';
import 'package:tractian/src/domain/enum/sensor_type_enum.dart';
import 'package:tractian/src/domain/enum/status_enum.dart';
import 'package:tractian/src/presenter/assets/pages/components/energy_and_alert_widget.dart';
import 'package:tractian/src/presenter/assets/pages/components/icon_widget.dart';
import 'package:tractian/src/presenter/assets/pages/components/lazy_tree_node_widget.dart';

void main() {
  TreeNodeEntity createNode({
    required String id,
    required String name,
    required NodeTypeEnum type,
    List<TreeNodeEntity> children = const [],
    SensorTypeEnum? sensorType,
    StatusEnum? status,
    bool isExpanded = false,
  }) {
    final result = TreeNodeEntity(
      id: id,
      name: name,
      type: type,
      sensorType: sensorType,
      status: status,
      isExpanded: isExpanded,
    );

    result.children.addAll(children);

    return result;
  }

  group('LazyTreeNode Tests', () {
    testWidgets('should render ExpansionTile when node has children', (
      WidgetTester tester,
    ) async {
      // Arrange
      final node = createNode(
        id: '1',
        name: 'Parent Node',
        type: NodeTypeEnum.location,
        children: [
          createNode(id: '2', name: 'Child Node', type: NodeTypeEnum.asset),
        ],
      );

      // Act
      await tester.pumpWidget(
        MaterialApp(home: Scaffold(body: LazyTreeNode(node: node))),
      );

      // Assert
      expect(find.byType(ExpansionTile), findsOneWidget);
      expect(find.text('Parent Node'), findsOneWidget);
      expect(find.byType(IconWidget), findsOneWidget);
      expect(find.byIcon(Icons.keyboard_arrow_down_outlined), findsOneWidget);
      expect(find.byType(ListTile), findsOneWidget);
    });

    testWidgets('should expand and show children when tapped', (
      WidgetTester tester,
    ) async {
      // Arrange
      final node = createNode(
        id: '1',
        name: 'Parent Node',
        type: NodeTypeEnum.location,
        children: [
          createNode(id: '2', name: 'Child Node', type: NodeTypeEnum.asset),
        ],
      );

      await tester.pumpWidget(
        MaterialApp(home: Scaffold(body: LazyTreeNode(node: node))),
      );

      // Act
      await tester.tap(find.byType(ExpansionTile));
      await tester.pumpAndSettle();

      // Assert
      expect(find.byIcon(Icons.keyboard_arrow_up_outlined), findsOneWidget);
      expect(find.text('Child Node'), findsOneWidget);
      expect(find.byType(LazyTreeNode), findsNWidgets(2));
    });

    testWidgets('should render ListTile when node has no children', (
      WidgetTester tester,
    ) async {
      // Arrange
      final node = createNode(
        id: '1',
        name: 'Leaf Node',
        type: NodeTypeEnum.component,
        sensorType: SensorTypeEnum.energy,
        status: StatusEnum.alert,
      );

      // Act
      await tester.pumpWidget(
        MaterialApp(home: Scaffold(body: LazyTreeNode(node: node))),
      );

      // Assert
      expect(find.byType(ListTile), findsOneWidget);
      expect(find.text('Leaf Node'), findsOneWidget);
      expect(find.byType(IconWidget), findsOneWidget);
      expect(find.byType(EnergyAndAlertWidget), findsOneWidget);
      expect(find.byIcon(Icons.bolt), findsOneWidget); // Energy icon
      expect(
        find.byIcon(Icons.fiber_manual_record),
        findsOneWidget,
      ); // Alert icon
      expect(find.byType(ExpansionTile), findsNothing);
    });

    testWidgets(
      'should not show EnergyAndAlertWidget when no sensor or status',
      (WidgetTester tester) async {
        // Arrange
        final node = createNode(
          id: '1',
          name: 'Leaf Node',
          type: NodeTypeEnum.asset,
        );

        // Act
        await tester.pumpWidget(
          MaterialApp(home: Scaffold(body: LazyTreeNode(node: node))),
        );

        // Assert
        expect(find.byType(ListTile), findsOneWidget);
        expect(find.text('Leaf Node'), findsOneWidget);
        expect(find.byType(IconWidget), findsOneWidget);
        expect(find.byType(EnergyAndAlertWidget), findsOneWidget);
        expect(find.byIcon(Icons.bolt), findsNothing);
        expect(find.byIcon(Icons.fiber_manual_record), findsNothing);
      },
    );

    testWidgets('should maintain expanded state', (WidgetTester tester) async {
      // Arrange
      final node = createNode(
        id: '1',
        name: 'Parent Node',
        type: NodeTypeEnum.location,
        isExpanded: true,
        children: [
          createNode(id: '2', name: 'Child Node', type: NodeTypeEnum.asset),
        ],
      );

      // Act
      await tester.pumpWidget(
        MaterialApp(home: Scaffold(body: LazyTreeNode(node: node))),
      );

      // Assert
      expect(find.byIcon(Icons.keyboard_arrow_up_outlined), findsOneWidget);
      expect(find.text('Child Node'), findsOneWidget);
    });

    testWidgets('should use correct padding and theme', (
      WidgetTester tester,
    ) async {
      // Arrange
      final node = createNode(
        id: '1',
        name: 'Parent Node',
        type: NodeTypeEnum.location,
        children: [
          createNode(id: '2', name: 'Child Node', type: NodeTypeEnum.asset),
        ],
      );

      // Act
      await tester.pumpWidget(
        MaterialApp(home: Scaffold(body: LazyTreeNode(node: node))),
      );

      // Assert
      final expansionTile = tester.widget<ExpansionTile>(
        find.byType(ExpansionTile),
      );
      expect(expansionTile.tilePadding, EdgeInsets.zero);
      expect(expansionTile.childrenPadding, const EdgeInsets.only(left: 8));
      expect(expansionTile.dense, true);
    });
  });
}
