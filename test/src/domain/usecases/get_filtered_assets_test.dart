import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tractian/src/core/utils/errors/base_error.dart';
import 'package:tractian/src/core/utils/result.dart';
import 'package:tractian/src/data/models/asset_model.dart';
import 'package:tractian/src/data/repositories/i_tractian_repository.dart.dart';
import 'package:tractian/src/domain/usecases/get_filtered_assets.dart';

import 'get_filtered_assets_test.mocks.dart';

@GenerateMocks([ITractianRepository])
void main() {
  late GetFilteredAssets usecase;
  late MockITractianRepository mockTractianRepository;

  setUp(() {
    provideDummy<Result<List<AssetModel>>>(Result.ok([]));

    mockTractianRepository = MockITractianRepository();
    usecase = GetFilteredAssets(mockTractianRepository);
  });

  const tCompanyId = '123';
  final tLstLocationId = ['location1', 'location2'];
  const tQuery = 'test';
  const tSensorType = 'thermometer';
  const tStatus = 'running';

  final tAssets = [
    AssetModel(
      id: '1',
      name: 'Asset 1',
      parentId: null,
      locationId: 'location1',
      sensorType: 'thermometer',
      sensorId: null,
      status: 'running',
      gatewayId: null,
      companyId: tCompanyId,
    ),
    AssetModel(
      id: '2',
      name: 'Asset 2',
      parentId: null,
      locationId: 'location2',
      sensorType: 'thermometer',
      sensorId: null,
      status: 'running',
      gatewayId: null,
      companyId: tCompanyId,
    ),
  ];

  test('should get filtered assets from the repository', () async {
    // arrange
    when(
      mockTractianRepository.filterAssets(
        companyId: tCompanyId,
        lstLocationId: tLstLocationId,
        query: tQuery,
        sensorType: tSensorType,
        status: tStatus,
      ),
    ).thenAnswer((_) async => Result.ok(tAssets));
    // act
    final result = await usecase(
      companyId: tCompanyId,
      lstLocationId: tLstLocationId,
      query: tQuery,
      sensorType: tSensorType,
      status: tStatus,
    );
    // assert
    expect(result.isOk, true);
    expect(result.getOrElse(() => []), tAssets);
    verify(
      mockTractianRepository.filterAssets(
        companyId: tCompanyId,
        lstLocationId: tLstLocationId,
        query: tQuery,
        sensorType: tSensorType,
        status: tStatus,
      ),
    );
    verifyNoMoreInteractions(mockTractianRepository);
  });

  test('should return empty list when no assets are found', () async {
    // arrange
    when(
      mockTractianRepository.filterAssets(
        companyId: tCompanyId,
        lstLocationId: tLstLocationId,
        query: tQuery,
        sensorType: tSensorType,
        status: tStatus,
      ),
    ).thenAnswer((_) async => Result.ok([]));
    // act
    final result = await usecase(
      companyId: tCompanyId,
      lstLocationId: tLstLocationId,
      query: tQuery,
      sensorType: tSensorType,
      status: tStatus,
    );
    // assert
    expect(result.isOk, true);
    expect(result.getOrElse(() => tAssets), []);
    verify(
      mockTractianRepository.filterAssets(
        companyId: tCompanyId,
        lstLocationId: tLstLocationId,
        query: tQuery,
        sensorType: tSensorType,
        status: tStatus,
      ),
    );
    verifyNoMoreInteractions(mockTractianRepository);
  });

  test('should return an error if the repository call fails', () async {
    // arrange
    when(
      mockTractianRepository.filterAssets(
        companyId: tCompanyId,
        lstLocationId: tLstLocationId,
        query: tQuery,
        sensorType: tSensorType,
        status: tStatus,
      ),
    ).thenAnswer((_) async => Result.error(BaseError(errorMessage: 'error')));
    // act
    final result = await usecase(
      companyId: tCompanyId,
      lstLocationId: tLstLocationId,
      query: tQuery,
      sensorType: tSensorType,
      status: tStatus,
    );
    // assert
    expect(result.isError, true);
    expect(result, isA<Error<BaseError>>());
    verify(
      mockTractianRepository.filterAssets(
        companyId: tCompanyId,
        lstLocationId: tLstLocationId,
        query: tQuery,
        sensorType: tSensorType,
        status: tStatus,
      ),
    );
    verifyNoMoreInteractions(mockTractianRepository);
  });
}
