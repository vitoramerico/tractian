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
}
