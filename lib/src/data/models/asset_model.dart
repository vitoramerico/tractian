class AssetModel {
  final String id;
  final String name;
  final String? parentId;
  final String? locationId;
  final String? sensorType;
  final String? sensorId;
  final String? status;
  final String? gatewayId;
  final String companyId;

  const AssetModel({
    required this.id,
    required this.name,
    required this.parentId,
    required this.locationId,
    required this.sensorType,
    required this.sensorId,
    required this.status,
    required this.gatewayId,
    required this.companyId,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AssetModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'parentId': parentId,
      'locationId': locationId,
      'sensorType': sensorType,
      'sensorId': sensorId,
      'status': status,
      'gatewayId': gatewayId,
      'companyId': companyId,
    };
  }

  factory AssetModel.fromMap(Map<String, dynamic> map) {
    return AssetModel(
      id: map['id'] as String,
      name: map['name'] as String,
      parentId: map['parentId'] != null ? map['parentId'] as String : null,
      locationId:
          map['locationId'] != null ? map['locationId'] as String : null,
      sensorType:
          map['sensorType'] != null ? map['sensorType'] as String : null,
      sensorId: map['sensorId'] != null ? map['sensorId'] as String : null,
      status: map['status'] != null ? map['status'] as String : null,
      gatewayId: map['gatewayId'] != null ? map['gatewayId'] as String : null,
      companyId: map['companyId'] as String,
    );
  }
}
