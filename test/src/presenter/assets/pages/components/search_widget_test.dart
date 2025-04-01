import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tractian/src/presenter/assets/pages/components/search_widget.dart';

class MockCallback extends Mock {
  void call(String text);
}

void main() {
  group('SearchWidget Tests', () {
    late MockCallback mockOnChanged;

    setUp(() {
      mockOnChanged = MockCallback();
    });

    testWidgets('should render TextField with search icon and hint', (
      WidgetTester tester,
    ) async {
      // Arrange
      final widget = SearchWidget(onChanged: (v) {});

      // Act
      await tester.pumpWidget(MaterialApp(home: Scaffold(body: widget)));

      // Assert
      expect(find.byType(TextField), findsOneWidget);
      expect(find.byIcon(Icons.search), findsOneWidget);
      expect(find.text('Buscar Ativo ou Local'), findsOneWidget);
      expect(find.byIcon(Icons.clear), findsNothing);
    });

    testWidgets('should call onChanged when text is entered', (
      WidgetTester tester,
    ) async {
      // Arrange
      final widget = SearchWidget(onChanged: mockOnChanged.call);

      await tester.pumpWidget(MaterialApp(home: Scaffold(body: widget)));

      // Act
      await tester.enterText(find.byType(TextField), 'test');
      await tester.pump();

      // Assert
      verify(mockOnChanged('test')).called(1);
      expect(find.byIcon(Icons.clear), findsOneWidget); // Clear button appears
    });

    testWidgets(
      'should clear text and call onChanged when clear button is pressed',
      (WidgetTester tester) async {
        // Arrange
        final widget = SearchWidget(onChanged: mockOnChanged.call);

        await tester.pumpWidget(MaterialApp(home: Scaffold(body: widget)));

        await tester.enterText(find.byType(TextField), 'test');
        await tester.pump();

        // Act
        await tester.tap(find.byIcon(Icons.clear));
        await tester.pump();

        // Assert
        verify(mockOnChanged('')).called(1);
        expect(find.text('test'), findsNothing);
        expect(
          find.byIcon(Icons.clear),
          findsNothing,
        ); // Clear button disappears
      },
    );

    testWidgets('should show clear button only when text is present', (
      WidgetTester tester,
    ) async {
      // Arrange
      final widget = SearchWidget(onChanged: mockOnChanged.call);

      await tester.pumpWidget(MaterialApp(home: Scaffold(body: widget)));

      // Initial Assert
      expect(find.byIcon(Icons.clear), findsNothing);

      // Act 1: Add text
      await tester.enterText(find.byType(TextField), 'test');
      await tester.pump();
      expect(find.byIcon(Icons.clear), findsOneWidget);

      // Act 2: Remove text
      await tester.enterText(find.byType(TextField), '');
      await tester.pump();
      expect(find.byIcon(Icons.clear), findsNothing);
    });
  });
}
