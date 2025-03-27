import 'package:flutter_test/flutter_test.dart';
import 'package:tractian/src/data/models/location_model.dart';

void main() {
  const tLocation = LocationModel(
    id: '1',
    name: 'Location 1',
    parentId: 'parent1',
    companyId: 'company1',
  );

  final tLocationMap = {
    'id': '1',
    'name': 'Location 1',
    'parentId': 'parent1',
    'companyId': 'company1',
  };

  group('LocationModel', () {
    test('should create a LocationModel from a map', () {
      // act
      final result = LocationModel.fromMap(tLocationMap);
      // assert
      expect(result, tLocation);
    });

    test('should create a map from a LocationModel', () {
      // act
      final result = tLocation.toMap();
      // assert
      expect(result, tLocationMap);
    });

    test(
      'should return true when comparing two LocationModels with the same id',
      () {
        // arrange
        const tLocation2 = LocationModel(
          id: '1',
          name: 'Location 2',
          parentId: 'parent2',
          companyId: 'company2',
        );
        // act
        final result = tLocation == tLocation2;
        // assert
        expect(result, true);
      },
    );

    test(
      'should return false when comparing two LocationModels with different ids',
      () {
        // arrange
        const tLocation2 = LocationModel(
          id: '2',
          name: 'Location 2',
          parentId: 'parent2',
          companyId: 'company2',
        );
        // act
        final result = tLocation == tLocation2;
        // assert
        expect(result, false);
      },
    );

    test('should return the correct hashCode', () {
      // act
      final result = tLocation.hashCode;
      // assert
      expect(result, tLocation.id.hashCode);
    });

    test('should create a LocationModel from a json string', () {
      // arrange
      final tLocationJson =
          '{"id": "1", "name": "Location 1", "parentId": "parent1", "companyId": "company1"}';
      // act
      final result = LocationModel.fromJson(tLocationJson);
      // assert
      expect(result, tLocation);
    });

    test('should create a json string from a LocationModel', () {
      // act
      final result = tLocation.toJson();
      // assert
      expect(
        result,
        '{"id":"1","name":"Location 1","parentId":"parent1","companyId":"company1"}',
      );
    });
  });
}
