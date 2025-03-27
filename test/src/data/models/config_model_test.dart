import 'package:flutter_test/flutter_test.dart';
import 'package:tractian/src/data/models/config_model.dart';

void main() {
  group('ConfigModel', () {
    test('should create a ConfigModel from a map', () {
      // arrange
      final map = <String, dynamic>{
        'lastSyncLocations': 1678886400000,
        'lastSyncAssets': 1678800000000,
        'lastSyncCompanies': 1678713600000,
      };
      // act
      final result = ConfigModel.fromMap(map);
      // assert
      expect(result.lastSyncLocations, 1678886400000);
      expect(result.lastSyncAssets, 1678800000000);
      expect(result.lastSyncCompanies, 1678713600000);
    });

    test('should create a map from a ConfigModel', () {
      // arrange
      const configModel = ConfigModel(
        lastSyncLocations: 1678886400000,
        lastSyncAssets: 1678800000000,
        lastSyncCompanies: 1678713600000,
      );
      // act
      final result = configModel.toMap();
      // assert
      expect(result['lastSyncLocations'], 1678886400000);
      expect(result['lastSyncAssets'], 1678800000000);
      expect(result['lastSyncCompanies'], 1678713600000);
    });

    test('should return correct DateTime from timestamp', () {
      // arrange
      const configModel = ConfigModel(lastSyncCompanies: 1678713600000);
      // act
      final result = configModel.lastSyncCompaniesDateTime;
      // assert
      expect(result, DateTime.fromMillisecondsSinceEpoch(1678713600000));
    });

    test('should return null DateTime when timestamp is null', () {
      // arrange
      const configModel = ConfigModel();
      // act
      final result = configModel.lastSyncCompaniesDateTime;
      // assert
      expect(result, null);
    });

    test('should copy ConfigModel with new values', () {
      // arrange
      const configModel = ConfigModel(
        lastSyncCompanies: 1678713600000,
        lastSyncLocations: 1678800000000,
        lastSyncAssets: 1678886400000,
      );

      // act
      final newConfigModel = configModel.copyWith(
        lastSyncCompanies: 1678972800000,
        lastSyncLocations: 1679059200000,
        lastSyncAssets: 1679145600000,
      );

      // assert
      expect(newConfigModel.lastSyncCompanies, 1678972800000);
      expect(newConfigModel.lastSyncLocations, 1679059200000);
      expect(newConfigModel.lastSyncAssets, 1679145600000);
    });
  });
}
