import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tractian/src/domain/entity/filter_entity.dart';
import 'package:tractian/src/domain/enum/sensor_type_enum.dart';
import 'package:tractian/src/domain/enum/status_enum.dart';
import 'package:tractian/src/presenter/assets/pages/components/button_widget.dart';
import 'package:tractian/src/presenter/assets/pages/components/filter_buttons_widget.dart';
import 'package:tractian/src/presenter/assets/view_models/assets_view_model.dart';

import 'filter_buttons_widget_test.mocks.dart';

@GenerateMocks([AssetsViewModel])
void main() {
  late MockAssetsViewModel mockViewModel;

  setUp(() {
    mockViewModel = MockAssetsViewModel();
    // Configures a non-null initial filter
    when(mockViewModel.filter).thenReturn(FilterEntity(companyId: '1'));
  });

  group('FilterButtonsWidget Tests', () {
    testWidgets('should render two buttons initially unfilled', (
      WidgetTester tester,
    ) async {
      // Arrange
      final widget = FilterButtonsWidget(viewModel: mockViewModel);

      // Act
      await tester.pumpWidget(MaterialApp(home: Scaffold(body: widget)));

      // Assert
      expect(find.byType(ButtonWidget), findsNWidgets(2));
      expect(find.text('Sensor de Energia'), findsOneWidget);
      expect(find.text('Crítico'), findsOneWidget);
      expect(find.byIcon(Icons.bolt_outlined), findsOneWidget);
      expect(find.byIcon(Icons.error_outline), findsOneWidget);

      // Checks that both buttons are initially unfilled
      final buttons = tester.widgetList<ButtonWidget>(
        find.byType(ButtonWidget),
      );
      expect(buttons.elementAt(0).filled, false);
      expect(buttons.elementAt(1).filled, false);
    });

    testWidgets('should toggle energy filter and call setFilter', (
      WidgetTester tester,
    ) async {
      // Arrange
      final widget = FilterButtonsWidget(viewModel: mockViewModel);

      await tester.pumpWidget(MaterialApp(home: Scaffold(body: widget)));

      // Act
      await tester.tap(find.text('Sensor de Energia'));
      await tester.pump();

      // Assert
      final energyButton = tester.widget<ButtonWidget>(
        find.widgetWithText(ButtonWidget, 'Sensor de Energia'),
      );
      expect(energyButton.filled, true);
      verify(
        mockViewModel.setFilter(
          argThat(
            predicate<FilterEntity>(
              (filter) => filter.sensorType == SensorTypeEnum.energy.name,
            ),
          ),
        ),
      ).called(1);

      // Act: Tap again to deactivate
      await tester.tap(find.text('Sensor de Energia'));
      await tester.pump();

      // Assert
      final energyButtonAfter = tester.widget<ButtonWidget>(
        find.widgetWithText(ButtonWidget, 'Sensor de Energia'),
      );
      expect(energyButtonAfter.filled, false);
      verify(
        mockViewModel.setFilter(
          argThat(predicate<FilterEntity>((filter) => filter.sensorType == '')),
        ),
      ).called(1);
    });

    testWidgets('should toggle critical filter and call setFilter', (
      WidgetTester tester,
    ) async {
      // Arrange
      final widget = FilterButtonsWidget(viewModel: mockViewModel);

      await tester.pumpWidget(MaterialApp(home: Scaffold(body: widget)));

      // Act
      await tester.tap(find.text('Crítico'));
      await tester.pump();

      // Assert
      final criticalButton = tester.widget<ButtonWidget>(
        find.widgetWithText(ButtonWidget, 'Crítico'),
      );
      expect(criticalButton.filled, true);
      verify(
        mockViewModel.setFilter(
          argThat(
            predicate<FilterEntity>(
              (filter) => filter.status == StatusEnum.alert.name,
            ),
          ),
        ),
      ).called(1);

      // Act: Tap again to deactivate
      await tester.tap(find.text('Crítico'));
      await tester.pump();

      // Assert
      final criticalButtonAfter = tester.widget<ButtonWidget>(
        find.widgetWithText(ButtonWidget, 'Crítico'),
      );
      expect(criticalButtonAfter.filled, false);
      verify(
        mockViewModel.setFilter(
          argThat(predicate<FilterEntity>((filter) => filter.status == '')),
        ),
      ).called(1);
    });

    testWidgets('should maintain separate states for each button', (
      WidgetTester tester,
    ) async {
      // Arrange
      final widget = FilterButtonsWidget(viewModel: mockViewModel);

      await tester.pumpWidget(MaterialApp(home: Scaffold(body: widget)));

      // Act: Activates only the energy filter
      await tester.tap(find.text('Sensor de Energia'));
      await tester.pump();

      // Assert
      final energyButton = tester.widget<ButtonWidget>(
        find.widgetWithText(ButtonWidget, 'Sensor de Energia'),
      );
      final criticalButton = tester.widget<ButtonWidget>(
        find.widgetWithText(ButtonWidget, 'Crítico'),
      );
      expect(energyButton.filled, true);
      expect(criticalButton.filled, false);
    });
  });
}
