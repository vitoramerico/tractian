import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tractian/src/domain/enum/node_type_enum.dart';
import 'package:tractian/src/presenter/assets/pages/components/icon_widget.dart';

void main() {
  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
  });

  group('IconWidget Tests', () {
    testWidgets('should show location icon when nodeType is location', (
      WidgetTester tester,
    ) async {
      // Arrange
      const widget = IconWidget(nodeType: NodeTypeEnum.location);

      // Act
      await tester.pumpWidget(const MaterialApp(home: Scaffold(body: widget)));

      // Assert
      final imageFinder = find.byType(Image);
      expect(imageFinder, findsOneWidget);

      final image = tester.widget<Image>(imageFinder);
      expect(image.image, isA<AssetImage>());
      expect(
        (image.image as AssetImage).assetName,
        'assets/icons/location.png',
      );
      expect(image.width, 16.0);
      expect(image.height, 16.0);

      expect(find.byType(Container), findsNothing);
    });

    testWidgets('should show asset icon when nodeType is asset', (
      WidgetTester tester,
    ) async {
      // Arrange
      const widget = IconWidget(nodeType: NodeTypeEnum.asset);

      // Act
      await tester.pumpWidget(const MaterialApp(home: Scaffold(body: widget)));

      // Assert
      final imageFinder = find.byType(Image);
      expect(imageFinder, findsOneWidget);

      final image = tester.widget<Image>(imageFinder);
      expect(image.image, isA<AssetImage>());
      expect((image.image as AssetImage).assetName, 'assets/icons/asset.png');
      expect(image.width, 16.0);
      expect(image.height, 16.0);

      expect(find.byType(Container), findsNothing);
    });

    testWidgets('should show component icon when nodeType is component', (
      WidgetTester tester,
    ) async {
      // Arrange
      const widget = IconWidget(nodeType: NodeTypeEnum.component);

      // Act
      await tester.pumpWidget(const MaterialApp(home: Scaffold(body: widget)));

      // Assert
      final imageFinder = find.byType(Image);
      expect(imageFinder, findsOneWidget);

      final image = tester.widget<Image>(imageFinder);
      expect(image.image, isA<AssetImage>());
      expect(
        (image.image as AssetImage).assetName,
        'assets/icons/component.png',
      );
      expect(image.width, 16.0);
      expect(image.height, 16.0);

      expect(find.byType(Container), findsNothing);
    });

    testWidgets('should show empty container for unknown nodeType', (
      WidgetTester tester,
    ) async {
      // Arrange
      final widget = IconWidget(nodeType: NodeTypeEnum.none);

      // Act
      await tester.pumpWidget(MaterialApp(home: Scaffold(body: widget)));

      // Assert
      expect(find.byType(Container), findsOneWidget);
      expect(find.byType(Image), findsNothing);
    });
  });
}
