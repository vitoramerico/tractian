import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper extends _DatabaseHelperMethods {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  Future<Database> get database async {
    _database ??= await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'tractian.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async => await _createTables(db),
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < newVersion) {
          await _dropTables(db);
          await _createTables(db);
        }
      },
    );
  }

  Future<void> _dropTables(Database db) async {
    final tables = ['config', 'companies', 'locations', 'assets'];
    for (final table in tables) {
      await db.execute('DROP TABLE IF EXISTS $table');
    }
  }

  Future<void> _createTables(Database db) async {
    await db.transaction((txn) async {
      await _createTableConfig(txn);
      await _createTableCompanies(txn);
      await _createTableLocations(txn);
      await _createTableAssets(txn);
      await _createIndexes(txn);
    });
  }

  Future<void> _createTableConfig(Transaction db) async {
    await db.execute('''
      CREATE TABLE config(
        id INTEGER PRIMARY KEY,
        lastSyncLocations INTEGER,
        lastSyncAssets INTEGER,
        lastSyncCompanies INTEGER
      )
    ''');
  }

  Future<void> _createTableCompanies(Transaction db) async {
    await db.execute('''
      CREATE TABLE companies(
        id TEXT PRIMARY KEY,
        name TEXT
      )
    ''');
  }

  Future<void> _createTableLocations(Transaction db) async {
    await db.execute('''
      CREATE TABLE locations(
        id TEXT PRIMARY KEY,
        name TEXT,
        parentId TEXT,
        companyId TEXT
      )
    ''');
  }

  Future<void> _createTableAssets(Transaction db) async {
    await db.execute('''
      CREATE TABLE assets(
        id TEXT PRIMARY KEY,
        name TEXT,
        parentId TEXT,
        locationId TEXT,
        sensorType TEXT,
        sensorId TEXT,
        status TEXT,
        gatewayId TEXT,
        companyId TEXT
      )
    ''');
  }

  Future<void> _createIndexes(Transaction db) async {
    final indexQueries = [
      'CREATE INDEX IF NOT EXISTS idx_locations_parentId ON locations (parentId)',
      'CREATE INDEX IF NOT EXISTS idx_locations_companyId ON locations (companyId)',
      'CREATE INDEX IF NOT EXISTS idx_assets_name ON assets (name)',
      'CREATE INDEX IF NOT EXISTS idx_assets_parentId ON assets (parentId)',
      'CREATE INDEX IF NOT EXISTS idx_assets_companyId ON assets (companyId)',
      'CREATE INDEX IF NOT EXISTS idx_assets_status ON assets (status)',
      'CREATE INDEX IF NOT EXISTS idx_assets_sensorType ON assets (sensorType)',
    ];

    for (final query in indexQueries) {
      await db.execute(query);
    }
  }
}

class _DatabaseHelperMethods {
  Future<void> saveBatch(
    Database db,
    String table,
    List<Map<String, dynamic>> data,
  ) async {
    await db.transaction((txn) async {
      final batch = txn.batch();
      for (final item in data) {
        batch.insert(table, item, conflictAlgorithm: ConflictAlgorithm.replace);
      }
      await batch.commit(noResult: true);
    });
  }

  Future<List<T>> getAll<T>(
    Database db,
    String table,
    T Function(Map<String, dynamic>) fromMap,
  ) async {
    final result = await db.query(table);

    return result.map(fromMap).toList();
  }

  Future<List<T>> getByField<T>(
    Database db,
    String table,
    String field,
    String value,
    T Function(Map<String, dynamic>) fromMap,
  ) async {
    final result = await db.query(
      table,
      where: '$field = ?',
      whereArgs: [value],
    );
    return result.map(fromMap).toList();
  }

  Future<List<T>> queryList<T>(
    Database db,
    String table,
    String where,
    List<dynamic> whereArgs,
    T Function(Map<String, dynamic>) fromMap,
  ) async {
    final result = await db.query(table, where: where, whereArgs: whereArgs);
    return result.map(fromMap).toList();
  }

  Future<Set<T>> fetchBulk<T>({
    required Database db,
    required String table,
    required String field,
    required Set<String> ids,
    required T Function(Map<String, dynamic>) fromMap,
  }) async {
    if (ids.isEmpty) return {};

    const batchSize = 900;
    final idList = ids.toList();
    Set<T> results = {};

    for (int i = 0; i < idList.length; i += batchSize) {
      final batch = idList.sublist(
        i,
        (i + batchSize > idList.length) ? idList.length : (i + batchSize),
      );

      final queryResult = await db.query(
        table,
        where: '$field IN (${List.filled(batch.length, '?').join(', ')})',
        whereArgs: batch,
      );

      results.addAll(queryResult.map((map) => fromMap(map)).toSet());
    }

    return results;
  }
}
