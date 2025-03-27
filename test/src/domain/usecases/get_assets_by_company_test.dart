import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tractian/src/core/utils/errors/base_error.dart';
import 'package:tractian/src/core/utils/result.dart';
import 'package:tractian/src/data/models/asset_model.dart';
import 'package:tractian/src/data/repositories/i_tractian_repository.dart.dart';
import 'package:tractian/src/domain/usecases/get_assets_by_company.dart';

import 'get_assets_by_company_test.mocks.dart';

@GenerateMocks([ITractianRepository])
void main() {
  late GetAssetsByCompany usecase;
  late MockITractianRepository mockTractianRepository;

  setUp(() {
    provideDummy<Result<List<AssetModel>>>(Result.ok([]));

    mockTractianRepository = MockITractianRepository();
    usecase = GetAssetsByCompany(mockTractianRepository);
  });

  const tCompanyId = '123';

  final tAssets = [
    AssetModel(
      id: '1',
      name: 'Asset 1',
      parentId: null,
      locationId: null,
      sensorType: null,
      sensorId: null,
      status: null,
      gatewayId: null,
      companyId: tCompanyId,
    ),
    AssetModel(
      id: '2',
      name: 'Asset 2',
      parentId: null,
      locationId: null,
      sensorType: null,
      sensorId: null,
      status: null,
      gatewayId: null,
      companyId: tCompanyId,
    ),
  ];

  test('should get assets by company id from the repository', () async {
    // arrange
    when(
      mockTractianRepository.getAssetsByCompany(companyId: tCompanyId),
    ).thenAnswer((_) async => Result.ok(tAssets));

    // act
    final result = await usecase(companyId: tCompanyId);
    // assert
    expect(result.isOk, true);
    expect(result.getOrElse(() => []), tAssets);
    verify(mockTractianRepository.getAssetsByCompany(companyId: tCompanyId));
    verifyNoMoreInteractions(mockTractianRepository);
  });

  test('should return empty list when no assets are found', () async {
    // arrange
    when(
      mockTractianRepository.getAssetsByCompany(companyId: tCompanyId),
    ).thenAnswer((_) async => Result.ok([]));
    // act
    final result = await usecase(companyId: tCompanyId);
    // assert
    expect(result.isOk, true);
    expect(result.getOrElse(() => tAssets), []);
    verify(mockTractianRepository.getAssetsByCompany(companyId: tCompanyId));
    verifyNoMoreInteractions(mockTractianRepository);
  });

  test('should return an error if the repository call fails', () async {
    // arrange
    when(
      mockTractianRepository.getAssetsByCompany(companyId: tCompanyId),
    ).thenAnswer((_) async => Result.error(BaseError(errorMessage: 'error')));
    // act
    final result = await usecase(companyId: tCompanyId);
    // assert
    expect(result.isError, true);
    expect(result, isA<Error<BaseError>>());
    verify(mockTractianRepository.getAssetsByCompany(companyId: tCompanyId));
    verifyNoMoreInteractions(mockTractianRepository);
  });
}
