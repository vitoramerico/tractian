import 'package:flutter_test/flutter_test.dart';
import 'package:tractian/src/data/models/location_model.dart';
import 'package:tractian/src/data/models/asset_model.dart';
import 'package:tractian/src/domain/usecases/build_tree_structure.dart';

void main() {
  group('BuildTreeStructure', () {
    test('should build tree with nested locations and assets', () async {
      final location1 = LocationModel(
        id: 'loc1',
        name: 'Location 1',
        parentId: null,
        companyId: 'comp1',
      );
      final location2 = LocationModel(
        id: 'loc2',
        name: 'Location 2',
        parentId: 'loc1',
        companyId: 'comp1',
      );
      final asset1 = AssetModel(
        id: 'asset1',
        name: 'Asset 1',
        parentId: null,
        locationId: 'loc2',
        sensorType: 'temp',
        sensorId: null,
        status: 'active',
        gatewayId: null,
        companyId: 'comp1',
      );

      final buildTree = BuildTreeStructure();

      final result = await buildTree.call(
        locations: [location1, location2],
        assets: [asset1],
      );

      final tree = result.getOrElse(() => []);

      expect(result.isOk, true);
      expect(tree.length, 1);
      expect(tree.first.id, 'loc1');
      expect(tree.first.children.length, 1);
      expect(tree.first.children.first.id, 'loc2');
      expect(tree.first.children.first.children.length, 1);
      expect(tree.first.children.first.children.first.id, 'asset1');
    });

    test('should remove empty locations', () async {
      final location1 = LocationModel(
        id: 'loc1',
        name: 'Location 1',
        parentId: null,
        companyId: 'comp1',
      );
      final buildTree = BuildTreeStructure();

      final result = await buildTree.call(locations: [location1], assets: []);

      final tree = result.getOrElse(() => []);

      expect(result.isOk, true);
      expect(tree.isEmpty, true);
    });
  });
}
