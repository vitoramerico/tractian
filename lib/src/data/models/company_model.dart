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
}
