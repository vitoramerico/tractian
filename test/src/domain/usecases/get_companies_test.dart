import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tractian/src/core/utils/errors/base_error.dart';
import 'package:tractian/src/core/utils/result.dart';
import 'package:tractian/src/data/models/company_model.dart';
import 'package:tractian/src/data/repositories/i_tractian_repository.dart.dart';
import 'package:tractian/src/domain/usecases/get_companies.dart';

import 'get_companies_test.mocks.dart';

@GenerateMocks([ITractianRepository])
void main() {
  late GetCompanies usecase;
  late MockITractianRepository mockTractianRepository;

  setUp(() {
    provideDummy<Result<List<CompanyModel>>>(Result.ok([]));
    mockTractianRepository = MockITractianRepository();
    usecase = GetCompanies(mockTractianRepository);
  });

  final tCompanies = [
    CompanyModel(id: '1', name: 'Company 1'),
    CompanyModel(id: '2', name: 'Company 2'),
  ];

  test('should get all companies from the repository', () async {
    // arrange
    when(
      mockTractianRepository.getCompanies(),
    ).thenAnswer((_) async => Result.ok(tCompanies));
    // act
    final result = await usecase();
    // assert
    expect(result.isOk, true);
    expect(result.getOrElse(() => []), tCompanies);
    verify(mockTractianRepository.getCompanies());
    verifyNoMoreInteractions(mockTractianRepository);
  });

  test('should return empty list when no companies are found', () async {
    // arrange
    when(
      mockTractianRepository.getCompanies(),
    ).thenAnswer((_) async => Result.ok([]));
    // act
    final result = await usecase();
    // assert
    expect(result.isOk, true);
    expect(result.getOrElse(() => tCompanies), []);
    verify(mockTractianRepository.getCompanies());
    verifyNoMoreInteractions(mockTractianRepository);
  });

  test('should return an error if the repository call fails', () async {
    // arrange
    when(
      mockTractianRepository.getCompanies(),
    ).thenAnswer((_) async => Result.error(BaseError(errorMessage: 'error')));
    // act
    final result = await usecase();
    // assert
    expect(result.isError, true);
    expect(result, isA<Error<BaseError>>());
    verify(mockTractianRepository.getCompanies());
    verifyNoMoreInteractions(mockTractianRepository);
  });
}
