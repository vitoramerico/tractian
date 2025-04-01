import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tractian/src/presenter/assets/pages/components/energy_and_alert_widget.dart';

void main() {
  group('EnergyAndAlertWidget Tests', () {
    testWidgets('should show energy icon when isEnergy is true', (
      WidgetTester tester,
    ) async {
      // Arrange
      const widget = EnergyAndAlertWidget(isEnergy: true, hasAlert: false);

      // Act
      await tester.pumpWidget(const MaterialApp(home: Scaffold(body: widget)));

      // Assert
      final energyIconFinder = find.byIcon(Icons.bolt);
      expect(energyIconFinder, findsOneWidget);

      final energyIcon = tester.widget<Icon>(energyIconFinder);
      expect(energyIcon.color, Color(0xff53c31b));
      expect(energyIcon.size, 16.0);

      expect(find.byIcon(Icons.fiber_manual_record), findsNothing);
    });

    testWidgets('should show alert icon when hasAlert is true', (
      WidgetTester tester,
    ) async {
      // Arrange
      const widget = EnergyAndAlertWidget(isEnergy: false, hasAlert: true);

      // Act
      await tester.pumpWidget(const MaterialApp(home: Scaffold(body: widget)));

      // Assert
      final alertIconFinder = find.byIcon(Icons.fiber_manual_record);
      expect(alertIconFinder, findsOneWidget);

      final alertIcon = tester.widget<Icon>(alertIconFinder);
      expect(alertIcon.color, Color(0xffee3833));
      expect(alertIcon.size, 16.0);

      expect(find.byIcon(Icons.bolt), findsNothing);
    });

    testWidgets('should show both icons when isEnergy and hasAlert are true', (
      WidgetTester tester,
    ) async {
      // Arrange
      const widget = EnergyAndAlertWidget(isEnergy: true, hasAlert: true);

      // Act
      await tester.pumpWidget(const MaterialApp(home: Scaffold(body: widget)));

      // Assert
      final energyIconFinder = find.byIcon(Icons.bolt);
      expect(energyIconFinder, findsOneWidget);

      final energyIcon = tester.widget<Icon>(energyIconFinder);
      expect(energyIcon.color, Color(0xff53c31b));
      expect(energyIcon.size, 16.0);

      final alertIconFinder = find.byIcon(Icons.fiber_manual_record);
      expect(alertIconFinder, findsOneWidget);

      final alertIcon = tester.widget<Icon>(alertIconFinder);
      expect(alertIcon.color, Color(0xffee3833));
      expect(alertIcon.size, 16.0);
    });

    testWidgets(
      'should show no icons when both isEnergy and hasAlert are false',
      (WidgetTester tester) async {
        // Arrange
        const widget = EnergyAndAlertWidget(isEnergy: false, hasAlert: false);

        // Act
        await tester.pumpWidget(
          const MaterialApp(home: Scaffold(body: widget)),
        );

        // Assert
        expect(find.byIcon(Icons.bolt), findsNothing);
        expect(find.byIcon(Icons.fiber_manual_record), findsNothing);
        expect(find.byType(Icon), findsNothing);
      },
    );

    testWidgets('should apply correct padding to icons', (
      WidgetTester tester,
    ) async {
      // Arrange
      const widget = EnergyAndAlertWidget(isEnergy: true, hasAlert: true);

      // Act
      await tester.pumpWidget(const MaterialApp(home: Scaffold(body: widget)));

      // Assert
      final paddingFinders = find.byType(Padding);
      expect(paddingFinders, findsNWidgets(2));

      final energyPadding = tester.widget<Padding>(paddingFinders.at(0));
      expect(energyPadding.padding, const EdgeInsets.only(left: 4));

      final alertPadding = tester.widget<Padding>(paddingFinders.at(1));
      expect(alertPadding.padding, const EdgeInsets.only(left: 4));
    });

    testWidgets('should align icons in row center', (
      WidgetTester tester,
    ) async {
      // Arrange
      const widget = EnergyAndAlertWidget(isEnergy: true, hasAlert: true);

      // Act
      await tester.pumpWidget(const MaterialApp(home: Scaffold(body: widget)));

      // Assert
      final rowFinder = find.byType(Row);
      expect(rowFinder, findsOneWidget);

      final row = tester.widget<Row>(rowFinder);
      expect(row.crossAxisAlignment, CrossAxisAlignment.center);
    });
  });
}
