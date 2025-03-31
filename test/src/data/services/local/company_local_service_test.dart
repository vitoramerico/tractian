import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';

import 'package:mockito/mockito.dart';
import 'package:sqflite/sqflite.dart';
import 'package:tractian/src/core/database/database_helper.dart';
import 'package:tractian/src/data/models/company_model.dart';
import 'package:tractian/src/data/services/local/company_local_service.dart';

import 'company_local_service_test.mocks.dart';

@GenerateMocks([DatabaseHelper, Database])
void main() {
  late CompanyLocalService service;
  late MockDatabaseHelper mockDatabaseHelper;
  late MockDatabase mockDatabase;

  final tCompanies = [
    const CompanyModel(id: '1', name: 'Company 1'),
    const CompanyModel(id: '2', name: 'Company 2'),
  ];

  setUp(() {
    mockDatabaseHelper = MockDatabaseHelper();
    service = CompanyLocalService(mockDatabaseHelper);
    mockDatabase = MockDatabase();
  });

  group('saveCompanies', () {
    test(
      'should call databaseHelper.saveBatch with correct arguments',
      () async {
        // arrange
        when(mockDatabaseHelper.database).thenAnswer((_) async => mockDatabase);
        when(
          mockDatabaseHelper.saveBatch(mockDatabase, 'companies', any),
        ).thenAnswer((_) async {});
        // act
        await service.saveCompanies(tCompanies);
        // assert
        verify(
          mockDatabaseHelper.saveBatch(
            mockDatabase,
            'companies',
            tCompanies.map((c) => c.toMap()).toList(),
          ),
        );
      },
    );
  });

  group('getCompanies', () {
    test('should call databaseHelper.getAll with correct arguments', () async {
      // arrange
      when(mockDatabaseHelper.database).thenAnswer((_) async => mockDatabase);
      when(
        mockDatabaseHelper.getAll(mockDatabase, 'companies', any),
      ).thenAnswer((_) async => tCompanies);
      // act
      await service.getCompanies();
      // assert
      verify(mockDatabaseHelper.getAll(mockDatabase, 'companies', any));
    });
  });
}
