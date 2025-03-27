import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tractian/src/core/utils/errors/base_error.dart';
import 'package:tractian/src/core/utils/result.dart';
import 'package:tractian/src/data/models/location_model.dart';
import 'package:tractian/src/data/repositories/i_tractian_repository.dart.dart';
import 'package:tractian/src/domain/usecases/get_filtered_locations.dart';

import 'get_filtered_locations_test.mocks.dart';

@GenerateMocks([ITractianRepository])
void main() {
  late GetFilteredLocations usecase;
  late MockITractianRepository mockTractianRepository;

  setUp(() {
    provideDummy<Result<List<LocationModel>>>(Result.ok([]));

    mockTractianRepository = MockITractianRepository();
    usecase = GetFilteredLocations(mockTractianRepository);
  });

  const tCompanyId = '123';
  const tQuery = 'test';

  final tLocations = [
    LocationModel(
      id: '1',
      name: 'Location 1',
      companyId: tCompanyId,
      parentId: '',
    ),
    LocationModel(
      id: '2',
      name: 'Location 2',
      companyId: tCompanyId,
      parentId: '',
    ),
  ];

  test('should get filtered locations from the repository', () async {
    // arrange
    when(
      mockTractianRepository.filterLocations(
        companyId: tCompanyId,
        query: tQuery,
      ),
    ).thenAnswer((_) async => Result.ok(tLocations));
    // act
    final result = await usecase(companyId: tCompanyId, query: tQuery);
    // assert
    expect(result.isOk, true);
    expect(result.getOrElse(() => []), tLocations);
    verify(
      mockTractianRepository.filterLocations(
        companyId: tCompanyId,
        query: tQuery,
      ),
    );
    verifyNoMoreInteractions(mockTractianRepository);
  });

  test('should return empty list when no locations are found', () async {
    // arrange
    when(
      mockTractianRepository.filterLocations(
        companyId: tCompanyId,
        query: tQuery,
      ),
    ).thenAnswer((_) async => Result.ok([]));
    // act
    final result = await usecase(companyId: tCompanyId, query: tQuery);
    // assert
    expect(result.isOk, true);
    expect(result.getOrElse(() => tLocations), []);
    verify(
      mockTractianRepository.filterLocations(
        companyId: tCompanyId,
        query: tQuery,
      ),
    );
    verifyNoMoreInteractions(mockTractianRepository);
  });

  test('should return an error if the repository call fails', () async {
    // arrange
    when(
      mockTractianRepository.filterLocations(
        companyId: tCompanyId,
        query: tQuery,
      ),
    ).thenAnswer((_) async => Result.error(BaseError(errorMessage: 'error')));
    // act
    final result = await usecase(companyId: tCompanyId, query: tQuery);
    // assert
    expect(result.isError, true);
    expect(result, isA<Error<BaseError>>());
    verify(
      mockTractianRepository.filterLocations(
        companyId: tCompanyId,
        query: tQuery,
      ),
    );
    verifyNoMoreInteractions(mockTractianRepository);
  });
}
