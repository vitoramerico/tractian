import 'package:sqflite/sqflite.dart';

import '../../../core/database/database_helper.dart';
import '../../models/company_model.dart';

class CompanyLocalService {
  final DatabaseHelper _databaseHelper;

  const CompanyLocalService(this._databaseHelper);

  Future<Database> get _database => _databaseHelper.database;

  /// Saves a list of companies to the database.
  Future<void> saveCompanies(List<CompanyModel> companies) async {
    final db = await _database;

    await _databaseHelper.saveBatch(
      db,
      'companies',
      companies.map((c) => c.toMap()).toList(),
    );
  }

  /// Returns all companies stored in the database.
  Future<List<CompanyModel>> getCompanies() async {
    final db = await _database;

    return await _databaseHelper.getAll(
      db,
      'companies',
      (map) => CompanyModel.fromMap(map),
    );
  }
}
