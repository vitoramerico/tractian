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

import 'package:tractian/src/presenter/assets/view_models/assets_view_model.dart';

import 'assets_view_model_test.mocks.dart';

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

  setUp(() async {
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
  });

  group('AssetsViewModel Initialization and Data Fetching', () {
    test(
      'init fetches locations, assets and builds tree structure successfully',
      () async {
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

        // Act
        await viewModel.init('company1');

        // Assert
        expect(viewModel.lstLocation, isEmpty);
        expect(viewModel.lstAssets, isEmpty);
        expect(viewModel.lstTreeNode, isEmpty);
      },
    );

    test('getLocationsByCompany command fetches locations correctly', () async {
      // Arrange
      when(
        mockLocations.call(companyId: anyNamed('companyId')),
      ).thenAnswer((_) async => Result.ok(<LocationModel>[]));

      // Act
      await viewModel.getLocationsByCompany.execute('company1');

      // Assert
      verify(mockLocations.call(companyId: 'company1')).called(1);
      expect(viewModel.lstLocation, isEmpty);
    });

    test('getAssetsByCompany command fetches assets correctly', () async {
      // Arrange
      when(
        mockAssets.call(companyId: anyNamed('companyId')),
      ).thenAnswer((_) async => Result.ok(<AssetModel>[]));

      // Act
      await viewModel.getAssetsByCompany.execute('company1');

      // Assert
      verify(mockAssets.call(companyId: 'company1')).called(1);
      expect(viewModel.lstAssets, isEmpty);
    });
  });

  group('AssetsViewModel Filtering and Tree Structure', () {
    test('onSearchChanged updates filter query after debounce', () async {
      // Arrange
      when(
        mockFilteredAssets.call(
          companyId: anyNamed('companyId'),
          query: anyNamed('query'),
          lstLocationId: anyNamed('lstLocationId'),
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
      when(
        mockBuildTree.call(
          locations: anyNamed('locations'),
          assets: anyNamed('assets'),
        ),
      ).thenAnswer((_) async => Result.ok(<TreeNodeEntity>[]));

      final initialFilter = FilterEntity(companyId: 'company1');
      viewModel.setFilter(initialFilter);

      // Act
      viewModel.onSearchChanged('new query');
      // Wait for debounce (500ms).
      await Future.delayed(Duration(milliseconds: 550));

      // Assert
      expect(viewModel.filter?.query, equals('new query'));
    });

    test(
      'getFilteredAssetsAndLocation command fetches filtered data',
      () async {
        // Arrange
        final filter = FilterEntity(companyId: 'company1', query: 'test');
        when(
          mockFilteredAssets.call(
            companyId: anyNamed('companyId'),
            query: anyNamed('query'),
            lstLocationId: anyNamed('lstLocationId'),
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
        when(
          mockBuildTree.call(
            locations: anyNamed('locations'),
            assets: anyNamed('assets'),
          ),
        ).thenAnswer((_) async => Result.ok(<TreeNodeEntity>[]));

        // Act
        await viewModel.getFilteredAssetsAndLocation.execute(filter);

        // Assert
        verify(
          mockBuildTree.call(
            locations: anyNamed('locations'),
            assets: anyNamed('assets'),
          ),
        ).called(1);
      },
    );

    test(
      'buildTreeStructure command rebuilds tree structure correctly',
      () async {
        // Arrange
        when(
          mockBuildTree.call(
            locations: anyNamed('locations'),
            assets: anyNamed('assets'),
          ),
        ).thenAnswer((_) async => Result.ok(<TreeNodeEntity>[]));

        // Act
        await viewModel.buildTreeStructure.execute();

        // Assert
        verify(
          mockBuildTree.call(
            locations: anyNamed('locations'),
            assets: anyNamed('assets'),
          ),
        ).called(1);
        expect(viewModel.lstTreeNode, isEmpty);
      },
    );
  });

  group('AssetsViewModel State Modification', () {
    test('setLstLocation updates list and notifies listeners', () {
      // Arrange
      final newLocations = [
        LocationModel(
          id: '1',
          name: 'Location 1',
          companyId: 'company1',
          parentId: '',
        ),
      ];

      // Act
      viewModel.setLstLocation(newLocations);

      // Assert
      expect(viewModel.lstLocation, equals(newLocations));
    });

    test('setLstAssets updates list and notifies listeners', () {
      // Arrange
      final newAssets = [
        AssetModel(
          id: '1',
          name: 'Asset 1',
          companyId: 'company1',
          locationId: 'location1',
          status: 'Running',
          parentId: '',
          sensorType: '',
          sensorId: '',
          gatewayId: '',
        ),
      ];

      // Act
      viewModel.setLstAssets(newAssets);

      // Assert
      expect(viewModel.lstAssets, equals(newAssets));
    });

    test('setLstTreeNode updates tree nodes and notifies listeners', () {
      // Arrange
      final newTreeNodes = [
        TreeNodeEntity(
          id: '1',
          name: 'TreeNode 1',
          type: NodeTypeEnum.location,
        ),
      ];

      // Act
      viewModel.setLstTreeNode(newTreeNodes);

      // Assert
      expect(viewModel.lstTreeNode, equals(newTreeNodes));
    });
  });

  group('Error Handling', () {
    test('init handles errors gracefully', () async {
      // Arrange
      when(mockLocations.call(companyId: anyNamed('companyId'))).thenAnswer(
        (_) async =>
            Result.error(BaseError(errorMessage: 'Error fetching locations')),
      );
      when(mockAssets.call(companyId: anyNamed('companyId'))).thenAnswer(
        (_) async =>
            Result.error(BaseError(errorMessage: 'Error fetching assets')),
      );
      when(
        mockBuildTree.call(
          locations: anyNamed('locations'),
          assets: anyNamed('assets'),
        ),
      ).thenAnswer(
        (_) async =>
            Result.error(BaseError(errorMessage: 'Error building tree')),
      );

      // Act
      await viewModel.init('company1');

      // Assert
      expect(viewModel.lstLocation, isEmpty);
      expect(viewModel.lstAssets, isEmpty);
      expect(viewModel.lstTreeNode, isEmpty);
      expect(viewModel.getAssetsByCompany.error, true);
      expect(viewModel.getLocationsByCompany.error, true);
    });
  });
}
