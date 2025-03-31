import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:sqflite/sqflite.dart';
import 'package:tractian/src/core/database/database_helper.dart';
import 'package:tractian/src/data/models/config_model.dart';
import 'package:tractian/src/data/services/local/config_local_service.dart';

import 'config_local_service_test.mocks.dart';

@GenerateMocks([DatabaseHelper, Database])
void main() {
  late ConfigLocalService service;
  late MockDatabaseHelper mockDatabaseHelper;
  late MockDatabase mockDatabase;

  setUp(() {
    mockDatabaseHelper = MockDatabaseHelper();
    mockDatabase = MockDatabase();
    service = ConfigLocalService(mockDatabaseHelper);

    when(mockDatabaseHelper.database).thenAnswer((_) async => mockDatabase);
  });

  group('updateConfig', () {
    test('should update config in database', () async {
      // Arrange
      final config = ConfigModel(
        lastSyncCompanies: 1678886400000,
        lastSyncLocations: 1678800000000,
        lastSyncAssets: 1678713600000,
      );
      when(
        mockDatabase.insert(
          'config',
          config.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        ),
      ).thenAnswer((_) async => 1);

      // Act
      await service.updateConfig(config);

      // Assert
      verify(
        mockDatabase.insert(
          'config',
          config.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        ),
      ).called(1);
    });
  });

  group('getConfig', () {
    test('should return default config when no config found', () async {
      // Arrange
      when(
        mockDatabase.query('config', where: 'id = ?', whereArgs: [1]),
      ).thenAnswer((_) async => []);

      // Act
      final config = await service.getConfig();

      // Assert
      expect(config.id, equals(1));
      expect(config.lastSyncCompanies, equals(null));
      expect(config.lastSyncLocations, equals(null));
      expect(config.lastSyncAssets, equals(null));
    });

    test('should return ConfigModel from database query result', () async {
      // Arrange
      final configMap = {
        'id': 1,
        'lastSyncCompanies': 1678886400000,
        'lastSyncLocations': 1678800000000,
        'lastSyncAssets': 1678713600000,
      };
      when(
        mockDatabase.query('config', where: 'id = ?', whereArgs: [1]),
      ).thenAnswer((_) async => [configMap]);

      // Act
      final config = await service.getConfig();

      // Assert
      expect(config.lastSyncCompanies, equals(1678886400000));
      expect(config.lastSyncLocations, equals(1678800000000));
      expect(config.lastSyncAssets, equals(1678713600000));
    });
  });
}
