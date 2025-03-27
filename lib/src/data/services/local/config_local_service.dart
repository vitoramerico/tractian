import 'package:sqflite/sqflite.dart';

import '../../../core/database/database_helper.dart';
import '../../models/config_model.dart';

class ConfigLocalService {
  final DatabaseHelper _databaseHelper;

  const ConfigLocalService(this._databaseHelper);

  Future<Database> get _database => _databaseHelper.database;

  /// Updates the configurations in the database.
  Future<void> updateConfig(ConfigModel config) async {
    final db = await _database;

    await db.insert(
      'config',
      config.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /// Returns the configurations stored in the database.
  Future<ConfigModel> _getConfig() async {
    final db = await _database;

    final result = await db.query('config', where: 'id = ?', whereArgs: [1]);

    if (result.isEmpty) return ConfigModel();

    return ConfigModel.fromMap(result.first);
  }

  /// Checks if companies need to be synchronized.
  Future<bool> needSyncCompanies() async {
    final config = await _getConfig();
    final lastSync = config.lastSyncCompaniesDateTime;

    return _needSyncData(lastSync, 30);
  }

  /// Updates the last synchronization date for companies.
  Future<void> updateLastSyncCompanies() async {
    final config = await _getConfig();

    final currentTime = DateTime.now().millisecondsSinceEpoch;

    await updateConfig(config.copyWith(lastSyncCompanies: currentTime));
  }

  /// Checks if locations need to be synchronized.
  Future<bool> needSyncLocations() async {
    final config = await _getConfig();
    final lastSync = config.lastSyncLocationsDateTime;

    return _needSyncData(lastSync, 10);
  }

  /// Updates the last synchronization date for locations.
  Future<void> updateLastSyncLocations() async {
    final config = await _getConfig();

    final currentTime = DateTime.now().millisecondsSinceEpoch;

    await updateConfig(config.copyWith(lastSyncLocations: currentTime));
  }

  /// Checks if assets need to be synchronized.
  Future<bool> needSyncAssets() async {
    final config = await _getConfig();
    final lastSync = config.lastSyncAssetsDateTime;

    return _needSyncData(lastSync, 10);
  }

  /// Updates the last synchronization date for assets.
  Future<void> updateLastSyncAssets() async {
    final config = await _getConfig();

    final currentTime = DateTime.now().millisecondsSinceEpoch;

    await updateConfig(config.copyWith(lastSyncAssets: currentTime));
  }

  /// Checks if data needs to be synchronized based on the last sync and the interval.
  Future<bool> _needSyncData(
    DateTime? lastSync,
    int syncIntervalInMinutes,
  ) async {
    if (lastSync == null) {
      return true;
    }

    if (DateTime.now().difference(lastSync).inMinutes >=
        syncIntervalInMinutes) {
      return true;
    }

    return false;
  }
}
