import 'package:sqflite/sqflite.dart';

import '../../../core/database/database_helper.dart';
import '../../models/asset_model.dart';

class AssetsLocalService {
  final DatabaseHelper _databaseHelper;

  const AssetsLocalService(this._databaseHelper);

  Future<Database> get _database => _databaseHelper.database;

  /// Saves a list of assets in the database for a specific company.
  Future<void> saveAssets(String companyId, List<AssetModel> assets) async {
    final db = await _database;
    await _databaseHelper.saveBatch(
      db,
      'assets',
      assets.map((a) => a.toMap()).toList(),
    );
  }

  /// Returns all assets of a company based on [companyId].
  Future<List<AssetModel>> getAssetsByCompany(String companyId) async {
    final db = await _database;
    return _databaseHelper.getByField(
      db,
      'assets',
      'companyId',
      companyId,
      (map) => AssetModel.fromMap(map),
    );
  }

  /// Filters assets based on criteria such as location, sensor type, status, and hierarchy.
  Future<List<AssetModel>> filterAssets({
    required String companyId,
    List<String> lstLocationId = const [],
    String query = '',
    String sensorType = '',
    String status = '',
  }) async {
    final db = await _database;

    final conditions = <String>['companyId = ?'];
    final args = <dynamic>[companyId];

    if (query.isNotEmpty) {
      conditions.add('name LIKE ?');
      args.add('$query%');
    }

    if (sensorType.isNotEmpty) {
      conditions.add('sensorType = ?');
      args.add(sensorType);
    }

    if (status.isNotEmpty) {
      conditions.add('status = ?');
      args.add(status);
    }

    final whereClause = conditions.join(' AND ');
    List<AssetModel> filteredAssets = [];

    if (sensorType.isEmpty && status.isEmpty && lstLocationId.isNotEmpty) {
      filteredAssets = await _queryWithLocationBatches(
        db,
        whereClause,
        args,
        lstLocationId,
      );
    } else {
      filteredAssets = await _basicQuery(db, whereClause, args);
    }

    if (filteredAssets.isEmpty) {
      return filteredAssets;
    }

    final results = await Future.wait([
      _getAllParent(filteredAssets, db),
      _getAllChild(filteredAssets, db),
    ]);

    return {...filteredAssets, ...results[0], ...results[1]}.toList();
  }

  /// Performs a basic query in the database based on conditions.
  Future<List<AssetModel>> _basicQuery(
    Database db,
    String whereClause,
    List<dynamic> args,
  ) async {
    final result = await db.query(
      'assets',
      where: whereClause,
      whereArgs: args,
    );

    return result.map((map) => AssetModel.fromMap(map)).toList();
  }

  /// Performs batch queries for assets based on locations.
  Future<List<AssetModel>> _queryWithLocationBatches(
    Database db,
    String baseWhereClause,
    List<dynamic> baseArgs,
    List<String> locationIds,
  ) async {
    final results = <AssetModel>[];
    const batchSize = 900;

    for (int i = 0; i < locationIds.length; i += batchSize) {
      final batch = locationIds.sublist(
        i,
        i + batchSize > locationIds.length ? locationIds.length : i + batchSize,
      );

      final batchPlaceholders = List.filled(batch.length, '?').join(', ');
      final batchClause =
          '($baseWhereClause) OR (locationId IN ($batchPlaceholders))';
      final batchArgs = [...baseArgs, ...batch];

      final result = await db.query(
        'assets',
        where: batchClause,
        whereArgs: batchArgs,
      );

      results.addAll(result.map((map) => AssetModel.fromMap(map)));
    }

    return results.toSet().toList();
  }

  /// Recursively returns all parent locations.
  Future<Set<AssetModel>> _getAllParent(
    List<AssetModel> assets,
    Database db,
  ) async {
    Set<AssetModel> allParents = {};
    Set<String> parentIds =
        assets
            .where((asset) => asset.parentId != null)
            .map((asset) => asset.parentId!)
            .toSet();

    while (parentIds.isNotEmpty) {
      final parents = await _databaseHelper.fetchBulk<AssetModel>(
        db: db,
        table: 'assets',
        field: 'id',
        ids: parentIds,
        fromMap: AssetModel.fromMap,
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
  Future<Set<AssetModel>> _getAllChild(
    List<AssetModel> assets,
    Database db,
  ) async {
    Set<AssetModel> allChildren = {};
    Set<String> assetIds = assets.map((loc) => loc.id).toSet();

    while (assetIds.isNotEmpty) {
      final children = await _databaseHelper.fetchBulk<AssetModel>(
        db: db,
        table: 'assets',
        field: 'parentId',
        ids: assetIds,
        fromMap: AssetModel.fromMap,
      );

      allChildren.addAll(children);

      assetIds = children
          .map((c) => c.id)
          .toSet()
          .difference(allChildren.map((c) => c.id).toSet());
    }

    return allChildren;
  }
}
