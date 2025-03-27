import 'package:flutter_test/flutter_test.dart';
import 'package:tractian/src/domain/entity/filter_entity.dart';

void main() {
  group('FilterEntity', () {
    test(
      'should have required companyId and default values for optional parameters',
      () {
        const entity = FilterEntity(companyId: 'company123');
        expect(entity.companyId, equals('company123'));
        expect(entity.query, equals(''));
        expect(entity.sensorType, equals(''));
        expect(entity.status, equals(''));
      },
    );

    test('copyWith should update provided fields and retain others', () {
      const entity = FilterEntity(
        companyId: 'company123',
        query: 'oldQuery',
        sensorType: 'sensorA',
        status: 'active',
      );
      final newEntity = entity.copyWith(query: 'newQuery', status: 'inactive');
      expect(newEntity.companyId, equals('company123'));
      expect(newEntity.query, equals('newQuery'));
      expect(newEntity.sensorType, equals('sensorA'));
      expect(newEntity.status, equals('inactive'));
    });

    test('copyWith with no parameters should return an identical instance', () {
      const entity = FilterEntity(
        companyId: 'company456',
        query: 'query1',
        sensorType: 'sensorB',
        status: 'inactive',
      );
      final newEntity = entity.copyWith();
      expect(newEntity.companyId, equals('company456'));
      expect(newEntity.query, equals('query1'));
      expect(newEntity.sensorType, equals('sensorB'));
      expect(newEntity.status, equals('inactive'));
    });
  });
}
