class CompanyModel {
  final String id;
  final String name;

  const CompanyModel({required this.id, required this.name});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{'id': id, 'name': name};
  }

  factory CompanyModel.fromMap(Map<String, dynamic> map) {
    return CompanyModel(id: map['id'] as String, name: map['name'] as String);
  }

  @override
  bool operator ==(covariant CompanyModel other) {
    if (identical(this, other)) return true;

    return other.id == id;
  }

  @override
  int get hashCode => id.hashCode ^ name.hashCode;
}
