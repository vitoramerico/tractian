import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:sqflite/sqflite.dart';
import 'package:tractian/src/core/database/database_helper.dart';
import 'package:tractian/src/data/models/location_model.dart';
import 'package:tractian/src/data/services/local/location_local_service.dart';

import 'location_local_service_test.mocks.dart';

@GenerateMocks([DatabaseHelper, Database])
void main() {
  late LocationLocalService service;
  late MockDatabaseHelper mockDatabaseHelper;
  late MockDatabase mockDatabase;

  const tCompanyId = '123';

  final tLocation = [
    LocationModel(
      id: '1',
      name: 'Location 1',
      parentId: null,
      companyId: tCompanyId,
    ),
    LocationModel(
      id: '2',
      name: 'Location 2',
      parentId: '1',
      companyId: tCompanyId,
    ),
  ];

  setUp(() {
    mockDatabaseHelper = MockDatabaseHelper();
    mockDatabase = MockDatabase();
    service = LocationLocalService(mockDatabaseHelper);

    when(mockDatabaseHelper.database).thenAnswer((_) async => mockDatabase);
  });

  group('saveLocations', () {
    test('should call saveBatch with correct parameters', () async {
      // Stub saveBatch to return a Future.
      when(
        mockDatabaseHelper.saveBatch(any, any, any),
      ).thenAnswer((_) async {});

      await service.saveLocations(tCompanyId, tLocation);

      verify(
        mockDatabaseHelper.saveBatch(
          mockDatabase,
          'locations',
          tLocation.map((l) => l.toMap()).toList(),
        ),
      ).called(1);
    });
  });

  group('getLocationsByCompany', () {
    test('should return locations for a company', () async {
      // arrange
      when(mockDatabaseHelper.database).thenAnswer((_) async => mockDatabase);
      when(
        mockDatabaseHelper.getByField(
          mockDatabase,
          'locations',
          'companyId',
          tCompanyId,
          any,
        ),
      ).thenAnswer((_) async => tLocation);
      // act
      await service.getLocationsByCompany(tCompanyId);
      // assert
      verify(
        mockDatabaseHelper.getByField(
          mockDatabase,
          'locations',
          'companyId',
          tCompanyId,
          any,
        ),
      );
    });
  });

  group('filterLocations', () {
    test('should return empty list if query returns no locations', () async {
      // arrange
      when(
        mockDatabaseHelper.queryList<LocationModel>(
          mockDatabase,
          'locations',
          any,
          any,
          any,
        ),
      ).thenAnswer((_) async => []);

      // act
      final results = await service.filterLocations(
        companyId: tCompanyId,
        query: 'Test',
      );

      // assert
      expect(results, isEmpty);
    });

    test(
      'should return filtered locations with union of parents and children',
      () async {
        // arrange
        when(
          mockDatabaseHelper.queryList<LocationModel>(
            mockDatabase,
            'locations',
            any,
            any,
            any,
          ),
        ).thenAnswer((_) async => tLocation);

        when(
          mockDatabaseHelper.fetchBulk<LocationModel>(
            db: mockDatabase,
            table: 'locations',
            field: 'id',
            ids: anyNamed('ids'),
            fromMap: anyNamed('fromMap'),
          ),
        ).thenAnswer((_) async => {});

        when(
          mockDatabaseHelper.fetchBulk<LocationModel>(
            db: mockDatabase,
            table: 'locations',
            field: 'parentId',
            ids: anyNamed('ids'),
            fromMap: anyNamed('fromMap'),
          ),
        ).thenAnswer((_) async => {});

        // act
        final results = await service.filterLocations(
          companyId: tCompanyId,
          query: 'Loc',
        );

        // assert
        expect(results.length, 2);
        expect(results, equals(tLocation));
      },
    );
  });
}
