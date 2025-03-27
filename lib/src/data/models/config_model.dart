class ConfigModel {
  final int id = 1;
  final int? lastSyncCompanies;
  final int? lastSyncLocations;
  final int? lastSyncAssets;

  DateTime? get lastSyncCompaniesDateTime => _intToDateTime(lastSyncCompanies);
  DateTime? get lastSyncLocationsDateTime => _intToDateTime(lastSyncLocations);
  DateTime? get lastSyncAssetsDateTime => _intToDateTime(lastSyncAssets);

  const ConfigModel({
    this.lastSyncLocations,
    this.lastSyncAssets,
    this.lastSyncCompanies,
  });

  DateTime? _intToDateTime(int? timestamp) =>
      timestamp != null ? DateTime.fromMillisecondsSinceEpoch(timestamp) : null;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'lastSyncLocations': lastSyncLocations,
      'lastSyncAssets': lastSyncAssets,
      'lastSyncCompanies': lastSyncCompanies,
    };
  }

  factory ConfigModel.fromMap(Map<String, dynamic> map) {
    return ConfigModel(
      lastSyncLocations:
          map['lastSyncLocations'] != null
              ? map['lastSyncLocations'] as int
              : null,
      lastSyncAssets:
          map['lastSyncAssets'] != null ? map['lastSyncAssets'] as int : null,
      lastSyncCompanies:
          map['lastSyncCompanies'] != null
              ? map['lastSyncCompanies'] as int
              : null,
    );
  }

  ConfigModel copyWith({
    int? lastSyncCompanies,
    int? lastSyncLocations,
    int? lastSyncAssets,
  }) {
    return ConfigModel(
      lastSyncCompanies: lastSyncCompanies ?? this.lastSyncCompanies,
      lastSyncLocations: lastSyncLocations ?? this.lastSyncLocations,
      lastSyncAssets: lastSyncAssets ?? this.lastSyncAssets,
    );
  }
}
