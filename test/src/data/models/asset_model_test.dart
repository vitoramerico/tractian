import 'package:flutter_test/flutter_test.dart';
import 'package:tractian/src/data/models/asset_model.dart';

void main() {
  const tAsset = AssetModel(
    id: '1',
    name: 'Asset 1',
    parentId: 'parent1',
    locationId: 'location1',
    sensorType: 'thermometer',
    sensorId: 'sensor1',
    status: 'running',
    gatewayId: 'gateway1',
    companyId: 'company1',
  );

  final tAssetMap = {
    'id': '1',
    'name': 'Asset 1',
    'parentId': 'parent1',
    'locationId': 'location1',
    'sensorType': 'thermometer',
    'sensorId': 'sensor1',
    'status': 'running',
    'gatewayId': 'gateway1',
    'companyId': 'company1',
  };

  group('AssetModel', () {
    test('should create an AssetModel from a map', () {
      // act
      final result = AssetModel.fromMap(tAssetMap);
      // assert
      expect(result, tAsset);
    });

    test('should create a map from an AssetModel', () {
      // act
      final result = tAsset.toMap();
      // assert
      expect(result, tAssetMap);
    });

    test(
      'should return true when comparing two AssetModels with the same id',
      () {
        // arrange
        const tAsset2 = AssetModel(
          id: '1',
          name: 'Asset 2',
          parentId: 'parent2',
          locationId: 'location2',
          sensorType: 'thermometer2',
          sensorId: 'sensor2',
          status: 'stopped',
          gatewayId: 'gateway2',
          companyId: 'company2',
        );
        // act
        final result = tAsset == tAsset2;
        // assert
        expect(result, true);
      },
    );

    test(
      'should return false when comparing two AssetModels with different ids',
      () {
        // arrange
        const tAsset2 = AssetModel(
          id: '2',
          name: 'Asset 2',
          parentId: 'parent2',
          locationId: 'location2',
          sensorType: 'thermometer2',
          sensorId: 'sensor2',
          status: 'stopped',
          gatewayId: 'gateway2',
          companyId: 'company2',
        );
        // act
        final result = tAsset == tAsset2;
        // assert
        expect(result, false);
      },
    );

    test('should return the correct hashCode', () {
      // act
      final result = tAsset.hashCode;
      // assert
      expect(result, tAsset.id.hashCode);
    });
  });
}
