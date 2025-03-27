import 'package:flutter_test/flutter_test.dart';
import 'package:tractian/src/data/models/company_model.dart';

void main() {
  const tCompany = CompanyModel(id: '1', name: 'Tractian');
  final tCompanyMap = {'id': '1', 'name': 'Tractian'};

  group('CompanyModel', () {
    test('should create a CompanyModel from a map', () {
      // act
      final result = CompanyModel.fromMap(tCompanyMap);
      // assert
      expect(result, tCompany);
    });

    test('should create a map from a CompanyModel', () {
      // act
      final result = tCompany.toMap();
      // assert
      expect(result, tCompanyMap);
    });
  });
}
