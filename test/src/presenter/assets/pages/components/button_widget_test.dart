import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tractian/src/core/ui/themes/colors.dart';
import 'package:tractian/src/presenter/assets/pages/components/button_widget.dart';

class MockCallback extends Mock {
  void call();
}

void main() {
  group('ButtonWidget Tests', () {
    testWidgets('should display filled button correctly', (
      WidgetTester tester,
    ) async {
      // Arrange
      const testText = 'Test Button';
      const testIcon = Icons.star;
      final mockCallback = MockCallback();

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ButtonWidget(
              filled: true,
              onPressed: mockCallback.call,
              text: testText,
              iconData: testIcon,
              height: 48,
              width: 200,
            ),
          ),
        ),
      );

      // Assert
      final buttonFinder = find.byType(OutlinedButton);
      expect(buttonFinder, findsOneWidget);

      final textFinder = find.text(testText);
      expect(textFinder, findsOneWidget);

      final iconFinder = find.byIcon(testIcon);
      expect(iconFinder, findsOneWidget);

      // Checks filled style
      final buttonWidget = tester.widget<OutlinedButton>(buttonFinder);
      expect(
        buttonWidget.style?.backgroundColor?.resolve({}),
        AppColors.brandBlueLight,
      );
      expect(
        buttonWidget.style?.side?.resolve({})?.color,
        AppColors.brandBlueLight,
      );

      // Checks icon and text color
      final textWidget = tester.widget<Text>(textFinder);
      expect(textWidget.style?.color, Colors.white);

      final iconWidget = tester.widget<Icon>(iconFinder);
      expect(iconWidget.color, Colors.white);
    });

    testWidgets('should display outlined button correctly', (
      WidgetTester tester,
    ) async {
      // Arrange
      const testText = 'Test Button';
      const testIcon = Icons.star;

      // Act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ButtonWidget(
              filled: false,
              text: testText,
              iconData: testIcon,
            ),
          ),
        ),
      );

      // Assert
      final buttonFinder = find.byType(OutlinedButton);
      expect(buttonFinder, findsOneWidget);

      final textFinder = find.text(testText);
      expect(textFinder, findsOneWidget);

      final iconFinder = find.byIcon(testIcon);
      expect(iconFinder, findsOneWidget);

      // Checks non-filled style
      final buttonWidget = tester.widget<OutlinedButton>(buttonFinder);
      expect(buttonWidget.style?.backgroundColor?.resolve({}), Colors.white);
      expect(buttonWidget.style?.side?.resolve({})?.color, Color(0xFFD8DFE6));

      // Checks icon and text color
      final textWidget = tester.widget<Text>(textFinder);
      expect(textWidget.style?.color, Color(0xFF77818C));
    });

    testWidgets('should call onPressed when button is tapped', (
      WidgetTester tester,
    ) async {
      // Arrange
      final mockCallback = MockCallback();
      const testText = 'Test Button';
      const testIcon = Icons.star;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ButtonWidget(
              filled: true,
              onPressed: mockCallback.call,
              text: testText,
              iconData: testIcon,
            ),
          ),
        ),
      );

      // Act
      await tester.tap(find.byType(OutlinedButton));
      await tester.pump();

      // Assert
      verify(mockCallback()).called(1);
    });

    testWidgets('should not crash when onPressed is null', (
      WidgetTester tester,
    ) async {
      // Arrange
      const testText = 'Test Button';
      const testIcon = Icons.star;

      // Act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ButtonWidget(
              filled: true,
              onPressed: null,
              text: testText,
              iconData: testIcon,
            ),
          ),
        ),
      );

      await tester.tap(find.byType(OutlinedButton));
      await tester.pump();

      // Assert
      expect(find.byType(OutlinedButton), findsOneWidget);
    });

    testWidgets('should apply custom height and width', (
      WidgetTester tester,
    ) async {
      // Arrange
      const testText = 'Test Button';
      const testIcon = Icons.star;
      const testHeight = 60.0;
      const testWidth = 300.0;

      // Act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ButtonWidget(
              filled: true,
              text: testText,
              iconData: testIcon,
              height: testHeight,
              width: testWidth,
            ),
          ),
        ),
      );

      // Assert
      final intrinsicWidthFinder = find.byType(IntrinsicWidth);
      final intrinsicWidth = tester.widget<IntrinsicWidth>(
        intrinsicWidthFinder,
      );
      expect(intrinsicWidth.stepHeight, testHeight);
      expect(intrinsicWidth.stepWidth, testWidth);
    });
  });
}
