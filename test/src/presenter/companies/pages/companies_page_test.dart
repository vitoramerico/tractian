import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tractian/src/core/utils/errors/base_error.dart';
import 'package:tractian/src/core/utils/result.dart';
import 'package:tractian/src/data/models/company_model.dart';
import 'package:tractian/src/domain/usecases/get_companies.dart';
import 'package:tractian/src/presenter/companies/companies_module.dart';
import 'package:tractian/src/presenter/companies/pages/companies_page.dart';
import 'package:tractian/src/presenter/companies/pages/components/item_widget.dart';
import 'package:tractian/src/presenter/companies/view_models/companies_view_model.dart';

import 'companies_page_test.mocks.dart';

@GenerateMocks([GetCompanies])
void main() {
  late MockGetCompanies mockGetCompanies;
  late CompaniesViewModel viewModel;

  setUp(() {
    provideDummy<Result<List<CompanyModel>>>(Result.ok([]));

    mockGetCompanies = MockGetCompanies();

    viewModel = CompaniesViewModel(mockGetCompanies);

    // Start Module
    Modular.bindModule(CompaniesModule());
    Modular.replaceInstance<CompaniesViewModel>(viewModel);
  });

  tearDown(() {
    Modular.dispose<CompaniesViewModel>();
  });

  Widget createWidgetUnderTest() {
    return MaterialApp(
      home: const CompaniesPage(),
      scaffoldMessengerKey: GlobalKey<ScaffoldMessengerState>(),
    );
  }

  group('CompaniesPage Tests', () {
    testWidgets('should show loading indicator when data is loading', (
      WidgetTester tester,
    ) async {
      // Arrange
      final companies = [CompanyModel(id: '1', name: 'Company 1')];
      when(mockGetCompanies()).thenAnswer((_) async => Result.ok(companies));

      // Act
      await tester.pumpWidget(createWidgetUnderTest());

      // Assert
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('should show empty message when no companies are found', (
      WidgetTester tester,
    ) async {
      // Arrange
      when(mockGetCompanies()).thenAnswer((_) async => Result.ok([]));

      // Act
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      // Assert
      expect(find.text('Nenhum registro encontrado'), findsOneWidget);
    });

    testWidgets('should show company list when data is available', (
      WidgetTester tester,
    ) async {
      // Arrange
      final companies = [
        CompanyModel(id: '1', name: 'Company 1'),
        CompanyModel(id: '2', name: 'Company 2'),
      ];
      when(mockGetCompanies()).thenAnswer((_) async => Result.ok(companies));

      // Act
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      // Assert
      expect(find.byType(ListView), findsOneWidget);
      expect(find.byType(ItemWidget), findsNWidgets(2));
    });

    testWidgets('should show error message when fetch fails', (
      WidgetTester tester,
    ) async {
      // Arrange

      when(mockGetCompanies()).thenAnswer(
        (_) async =>
            Result.error(BaseError(errorMessage: 'Erro ao carregar empresas')),
      );

      // Act
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      // Assert
      expect(find.byType(SnackBar), findsOneWidget);
      expect(find.text('Erro ao carregar empresas'), findsOneWidget);
    });
  });
}
