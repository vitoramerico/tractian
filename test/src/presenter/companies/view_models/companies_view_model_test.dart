import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tractian/src/core/utils/errors/base_error.dart';
import 'package:tractian/src/core/utils/result.dart';
import 'package:tractian/src/data/models/company_model.dart';
import 'package:tractian/src/domain/usecases/get_companies.dart';
import 'package:tractian/src/presenter/companies/view_models/companies_view_model.dart';

import 'companies_view_model_test.mocks.dart';

@GenerateMocks([GetCompanies])
void main() {
  late MockGetCompanies mockGetCompanies;
  late CompaniesViewModel viewModel;

  setUp(() {
    provideDummy<Result<List<CompanyModel>>>(Result.ok([]));

    mockGetCompanies = MockGetCompanies();

    viewModel = CompaniesViewModel(mockGetCompanies);
  });

  group('CompaniesViewModel getCompanies Command', () {
    test('getCompanies command returns list of companies on success', () async {
      final companies = [CompanyModel(id: '1', name: 'Company 1')];
      when(mockGetCompanies()).thenAnswer((_) async => Result.ok(companies));

      await viewModel.getCompanies.execute();

      expect(viewModel.getCompanies.error, false);
      expect(viewModel.lstCompany, equals(companies));
      verify(mockGetCompanies()).called(1);
    });

    test('getCompanies command returns error on failure', () async {
      when(mockGetCompanies()).thenAnswer(
        (_) async =>
            Result.error(BaseError(errorMessage: 'Error fetching companies')),
      );

      await viewModel.getCompanies.execute();

      expect(viewModel.getCompanies.error, true);
      expect(viewModel.lstCompany, isEmpty);
      verify(mockGetCompanies()).called(1);
    });
  });

  group('CompaniesViewModel State Modification', () {
    test('setLstCompany updates list and notifies listeners', () {
      final newCompanies = [CompanyModel(id: '1', name: 'Company 1')];
      viewModel.setLstCompany(newCompanies);

      expect(viewModel.lstCompany, equals(newCompanies));
    });
  });
}
