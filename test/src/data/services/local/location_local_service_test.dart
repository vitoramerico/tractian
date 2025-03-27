import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:sqflite/sqflite.dart';
import 'package:tractian/src/core/database/database_helper.dart';
import 'package:tractian/src/data/models/config_model.dart';
import 'package:tractian/src/data/services/local/config_local_service.dart';

import 'location_local_service_test.mocks.dart';

@GenerateMocks([DatabaseHelper, Database])
void main() {
  late ConfigLocalService configLocalService;
  late MockDatabaseHelper mockDatabaseHelper;
  late MockDatabase mockDatabase;

  setUp(() {
    mockDatabaseHelper = MockDatabaseHelper();
    mockDatabase = MockDatabase();
    configLocalService = ConfigLocalService(mockDatabaseHelper);

    when(mockDatabaseHelper.database).thenAnswer((_) async => mockDatabase);
  });

  group('ConfigLocalService Tests', () {
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
        await configLocalService.updateConfig(config);

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

    group('needSyncCompanies', () {
      test('should return true when lastSync is null', () async {
        // Arrange
        when(
          mockDatabase.query('config', where: 'id = ?', whereArgs: [1]),
        ).thenAnswer(
          (_) async => [
            {'id': 1},
          ],
        );

        // Act
        final result = await configLocalService.needSyncCompanies();

        // Assert
        expect(result, true);
      });

      test('should return true when sync interval exceeded', () async {
        // Arrange
        final pastTime =
            DateTime.now()
                .subtract(const Duration(minutes: 31))
                .millisecondsSinceEpoch;
        when(
          mockDatabase.query('config', where: 'id = ?', whereArgs: [1]),
        ).thenAnswer(
          (_) async => [
            {'id': 1, 'lastSyncCompanies': pastTime},
          ],
        );

        // Act
        final result = await configLocalService.needSyncCompanies();

        // Assert
        expect(result, true);
      });

      test('should return false when within sync interval', () async {
        // Arrange
        final recentTime =
            DateTime.now()
                .subtract(const Duration(minutes: 5))
                .millisecondsSinceEpoch;
        when(
          mockDatabase.query('config', where: 'id = ?', whereArgs: [1]),
        ).thenAnswer(
          (_) async => [
            {'id': 1, 'lastSyncCompanies': recentTime},
          ],
        );

        // Act
        final result = await configLocalService.needSyncCompanies();

        // Assert
        expect(result, false);
      });
    });

    group('updateLastSyncCompanies', () {
      test('should update last sync companies timestamp', () async {
        // Arrange
        when(
          mockDatabase.query('config', where: 'id = ?', whereArgs: [1]),
        ).thenAnswer(
          (_) async => [
            {'id': 1},
          ],
        );
        when(
          mockDatabase.insert(
            'config',
            any,
            conflictAlgorithm: ConflictAlgorithm.replace,
          ),
        ).thenAnswer((_) async => 1);

        // Act
        await configLocalService.updateLastSyncCompanies();

        // Assert
        verify(
          mockDatabase.insert(
            'config',
            argThat(isA<Map<String, dynamic>>()),
            conflictAlgorithm: ConflictAlgorithm.replace,
          ),
        ).called(1);
      });
    });
  });
}
