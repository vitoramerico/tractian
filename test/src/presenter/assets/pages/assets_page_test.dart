import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tractian/src/core/utils/errors/base_error.dart';
import 'package:tractian/src/core/utils/result.dart';
import 'package:tractian/src/data/models/asset_model.dart';
import 'package:tractian/src/data/models/location_model.dart';
import 'package:tractian/src/domain/entity/filter_entity.dart';
import 'package:tractian/src/domain/entity/tree_node_entity.dart';
import 'package:tractian/src/domain/enum/node_type_enum.dart';
import 'package:tractian/src/domain/usecases/build_tree_structure.dart';
import 'package:tractian/src/domain/usecases/get_assets_by_company.dart';
import 'package:tractian/src/domain/usecases/get_filtered_assets.dart';
import 'package:tractian/src/domain/usecases/get_filtered_locations.dart';
import 'package:tractian/src/domain/usecases/get_locations_by_company.dart';
import 'package:tractian/src/presenter/assets/assets_module.dart';
import 'package:tractian/src/presenter/assets/pages/assets_page.dart';
import 'package:tractian/src/presenter/assets/pages/components/lazy_tree_node_widget.dart';
import 'package:tractian/src/presenter/assets/pages/components/search_widget.dart';
import 'package:tractian/src/presenter/assets/view_models/assets_view_model.dart';

import 'assets_page_test.mocks.dart';

@GenerateMocks([
  GetLocationsByCompany,
  GetAssetsByCompany,
  GetFilteredAssets,
  GetFilteredLocations,
  BuildTreeStructure,
])
void main() {
  late MockGetLocationsByCompany mockLocations;
  late MockGetAssetsByCompany mockAssets;
  late MockGetFilteredAssets mockFilteredAssets;
  late MockGetFilteredLocations mockFilteredLocations;
  late MockBuildTreeStructure mockBuildTree;
  late AssetsViewModel viewModel;

  setUp(() {
    provideDummy<Result<List<AssetModel>>>(Result.ok([]));
    provideDummy<Result<List<LocationModel>>>(Result.ok([]));
    provideDummy<Result<List<TreeNodeEntity>>>(Result.ok([]));

    mockLocations = MockGetLocationsByCompany();
    mockAssets = MockGetAssetsByCompany();
    mockFilteredAssets = MockGetFilteredAssets();
    mockFilteredLocations = MockGetFilteredLocations();
    mockBuildTree = MockBuildTreeStructure();

    viewModel = AssetsViewModel(
      mockLocations,
      mockAssets,
      mockFilteredAssets,
      mockFilteredLocations,
      mockBuildTree,
    );

    // Arrange
    when(
      mockLocations.call(companyId: anyNamed('companyId')),
    ).thenAnswer((_) async => Result.ok(<LocationModel>[]));
    when(
      mockAssets.call(companyId: anyNamed('companyId')),
    ).thenAnswer((_) async => Result.ok(<AssetModel>[]));
    when(
      mockBuildTree.call(
        locations: anyNamed('locations'),
        assets: anyNamed('assets'),
      ),
    ).thenAnswer((_) async => Result.ok(<TreeNodeEntity>[]));

    // Start Module
    Modular.bindModule(AssetsModule());
    Modular.replaceInstance<AssetsViewModel>(viewModel);
  });

  tearDown(() {
    Modular.dispose<AssetsViewModel>();
  });

  Widget createWidgetUnderTest() {
    return MaterialApp(
      home: AssetsPage(companyId: 'test_company'),
      scaffoldMessengerKey: GlobalKey<ScaffoldMessengerState>(),
    );
  }

  group('AssetsPage Tests', () {
    testWidgets('should show loading indicator when data is loading', (
      WidgetTester tester,
    ) async {
      // Act
      await tester.pumpWidget(createWidgetUnderTest());

      // Assert
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('should show empty message when no data is available', (
      WidgetTester tester,
    ) async {
      // Act
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      // Assert
      expect(find.text('Nenhum registro encontrado'), findsOneWidget);
    });

    testWidgets('should display list when data is available', (
      WidgetTester tester,
    ) async {
      // Arrange
      when(
        mockBuildTree.call(
          locations: anyNamed('locations'),
          assets: anyNamed('assets'),
        ),
      ).thenAnswer(
        (_) async => Result.ok(<TreeNodeEntity>[
          TreeNodeEntity(
            id: '1',
            name: 'Location 1',
            type: NodeTypeEnum.location,
          ),
        ]),
      );

      // Act
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      // Assert
      expect(find.byType(ListView), findsOneWidget);
      expect(find.byType(LazyTreeNode), findsWidgets);
    });

    testWidgets('should show error message when getLocationsByCompany fails', (
      WidgetTester tester,
    ) async {
      // Arrange
      when(mockLocations.call(companyId: anyNamed('companyId'))).thenAnswer(
        (_) async => Result.error(
          BaseError(errorMessage: 'Erro ao carregar localizações'),
        ),
      );

      // Act
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      // Assert
      expect(find.byType(SnackBar), findsOneWidget);
      expect(find.text('Erro ao carregar localizações'), findsOneWidget);
    });

    testWidgets('should call setFilter when search text changes', (
      WidgetTester tester,
    ) async {
      // Arrange
      when(
        mockFilteredAssets.call(
          companyId: anyNamed('companyId'),
          lstLocationId: anyNamed('lstLocationId'),
          query: anyNamed('query'),
          sensorType: anyNamed('sensorType'),
          status: anyNamed('status'),
        ),
      ).thenAnswer((_) async => Result.ok(<AssetModel>[]));
      when(
        mockFilteredLocations.call(
          companyId: anyNamed('companyId'),
          query: anyNamed('query'),
        ),
      ).thenAnswer((_) async => Result.ok(<LocationModel>[]));

      // Act
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.enterText(find.byType(SearchWidget), 'test search');
      await tester.pump();

      // Assert
      verify(
        viewModel.setFilter(
          FilterEntity(companyId: 'test_company', query: 'test search'),
        ),
      ).called(1);
    });
  });
}
