class FilterEntity {
  final String companyId;
  final String query;
  final String sensorType;
  final String status;

  const FilterEntity({
    required this.companyId,
    this.query = '',
    this.sensorType = '',
    this.status = '',
  });

  FilterEntity copyWith({
    String? companyId,
    String? query,
    String? sensorType,
    String? status,
  }) {
    return FilterEntity(
      companyId: companyId ?? this.companyId,
      query: query ?? this.query,
      sensorType: sensorType ?? this.sensorType,
      status: status ?? this.status,
    );
  }

  @override
  bool operator ==(covariant FilterEntity other) {
    if (identical(this, other)) return true;

    return other.companyId == companyId &&
        other.query == query &&
        other.sensorType == sensorType &&
        other.status == status;
  }

  @override
  int get hashCode {
    return companyId.hashCode ^
        query.hashCode ^
        sensorType.hashCode ^
        status.hashCode;
  }
}
