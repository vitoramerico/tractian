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
  Future<ConfigModel> getConfig() async {
    final db = await _database;

    final result = await db.query('config', where: 'id = ?', whereArgs: [1]);

    if (result.isEmpty) return ConfigModel();

    return ConfigModel.fromMap(result.first);
  }
}
