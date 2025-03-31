import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:sqflite/sqflite.dart';
import 'package:tractian/src/core/database/database_helper.dart';
import 'package:tractian/src/data/models/asset_model.dart';
import 'package:tractian/src/data/services/local/assets_local_service.dart';

import 'assets_local_service_test.mocks.dart';

@GenerateMocks([DatabaseHelper, Database])
void main() {
  late AssetsLocalService service;
  late MockDatabaseHelper mockDatabaseHelper;
  late MockDatabase mockDatabase;

  const tCompanyId = '123';

  final tAssets = [
    AssetModel(
      id: '1',
      name: 'Asset 1',
      parentId: null,
      locationId: null,
      sensorType: null,
      sensorId: null,
      status: null,
      gatewayId: null,
      companyId: tCompanyId,
    ),
    AssetModel(
      id: '2',
      name: 'Asset 2',
      parentId: null,
      locationId: null,
      sensorType: null,
      sensorId: null,
      status: null,
      gatewayId: null,
      companyId: tCompanyId,
    ),
  ];

  setUp(() {
    mockDatabaseHelper = MockDatabaseHelper();
    service = AssetsLocalService(mockDatabaseHelper);
    mockDatabase = MockDatabase();
  });

  group('saveAssets', () {
    test('should call saveBatch with correct parameters', () async {
      // arrange
      when(mockDatabaseHelper.database).thenAnswer((_) async => mockDatabase);
      when(
        mockDatabaseHelper.saveBatch(mockDatabase, 'assets', any),
      ).thenAnswer((_) async {});
      // act
      await service.saveAssets(tCompanyId, tAssets);
      // assert
      verify(
        mockDatabaseHelper.saveBatch(
          mockDatabase,
          'assets',
          tAssets.map((a) => a.toMap()).toList(),
        ),
      );
    });
  });

  group('getAssetsByCompany', () {
    test('should return assets for a company', () async {
      // arrange
      when(mockDatabaseHelper.database).thenAnswer((_) async => mockDatabase);
      when(
        mockDatabaseHelper.getByField(
          mockDatabase,
          'assets',
          'companyId',
          tCompanyId,
          any,
        ),
      ).thenAnswer((_) async => tAssets);
      // act
      await service.getAssetsByCompany(tCompanyId);
      // assert
      verify(
        mockDatabaseHelper.getByField(
          mockDatabase,
          'assets',
          'companyId',
          tCompanyId,
          any,
        ),
      );
    });
  });

  group('filterAssets', () {
    test('should call _basicQuery when no locationIds are provided', () async {
      // arrange
      when(mockDatabaseHelper.database).thenAnswer((_) async => mockDatabase);
      when(
        mockDatabase.query(
          any,
          where: anyNamed('where'),
          whereArgs: anyNamed('whereArgs'),
        ),
      ).thenAnswer((_) async => tAssets.map((a) => a.toMap()).toList());

      when(
        mockDatabaseHelper.fetchBulk<AssetModel>(
          db: anyNamed('db'),
          table: anyNamed('table'),
          field: anyNamed('field'),
          ids: anyNamed('ids'),
          fromMap: anyNamed('fromMap'),
        ),
      ).thenAnswer((_) async => <AssetModel>{});

      // act
      final result = await service.filterAssets(companyId: tCompanyId);

      // assert
      expect(result, equals(tAssets));
      verify(
        mockDatabase.query(
          'assets',
          where: anyNamed('where'),
          whereArgs: anyNamed('whereArgs'),
        ),
      ).called(1);
    });
  });
}
