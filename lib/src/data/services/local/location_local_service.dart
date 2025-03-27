import 'package:sqflite/sqflite.dart';

import '../../../core/database/database_helper.dart';
import '../../models/location_model.dart';

class LocationLocalService {
  final DatabaseHelper _databaseHelper;

  const LocationLocalService(this._databaseHelper);

  Future<Database> get _database => _databaseHelper.database;

  /// Saves a list of locations to the database for a specific company.
  Future<void> saveLocations(
    String companyId,
    List<LocationModel> locations,
  ) async {
    final db = await _database;

    await _databaseHelper.saveBatch(
      db,
      'locations',
      locations.map((l) => l.toMap()).toList(),
    );
  }

  /// Returns all locations for a company based on [companyId].
  Future<List<LocationModel>> getLocationsByCompany(String companyId) async {
    final db = await _database;

    return _databaseHelper.getByField(
      db,
      'locations',
      'companyId',
      companyId,
      (map) => LocationModel.fromMap(map),
    );
  }

  /// Filters locations based on criteria such as company and name.
  Future<List<LocationModel>> filterLocations({
    required String companyId,
    String query = '',
  }) async {
    final db = await _database;
    final whereClause =
        query.isNotEmpty ? 'companyId = ? AND name LIKE ?' : 'companyId = ?';
    final whereArgs = query.isNotEmpty ? [companyId, '%$query%'] : [companyId];

    final filteredLocations = await _databaseHelper.queryList(
      db,
      'locations',
      whereClause,
      whereArgs,
      (map) => LocationModel.fromMap(map),
    );

    if (filteredLocations.isEmpty) {
      return filteredLocations;
    }

    final results = await Future.wait([
      _getAllParentLocations(filteredLocations, db),
      _getAllChildLocations(filteredLocations, db),
    ]);

    return {...filteredLocations, ...results[0], ...results[1]}.toList();
  }

  /// Recursively returns all parent locations.
  Future<Set<LocationModel>> _getAllParentLocations(
    List<LocationModel> locations,
    Database db,
  ) async {
    Set<LocationModel> allParents = {};
    Set<String> parentIds =
        locations
            .where((loc) => loc.parentId != null)
            .map((loc) => loc.parentId!)
            .toSet();

    while (parentIds.isNotEmpty) {
      final parents = await _databaseHelper.fetchBulk<LocationModel>(
        db: db,
        table: 'locations',
        field: 'id',
        ids: parentIds,
        fromMap: LocationModel.fromMap,
      );

      allParents.addAll(parents);

      parentIds = parents
          .where((p) => p.parentId != null)
          .map((p) => p.parentId!)
          .toSet()
          .difference(allParents.map((p) => p.id).toSet());
    }

    return allParents;
  }

  /// Recursively returns all child locations.
  Future<Set<LocationModel>> _getAllChildLocations(
    List<LocationModel> locations,
    Database db,
  ) async {
    Set<LocationModel> allChildren = {};
    Set<String> locationIds = locations.map((loc) => loc.id).toSet();

    while (locationIds.isNotEmpty) {
      final children = await _databaseHelper.fetchBulk<LocationModel>(
        db: db,
        table: 'locations',
        field: 'parentId',
        ids: locationIds,
        fromMap: LocationModel.fromMap,
      );

      allChildren.addAll(children);

      locationIds = children
          .map((c) => c.id)
          .toSet()
          .difference(allChildren.map((c) => c.id).toSet());
    }

    return allChildren;
  }
}
