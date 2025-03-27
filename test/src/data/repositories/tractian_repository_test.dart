import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tractian/src/core/utils/result.dart';
import 'package:tractian/src/data/models/asset_model.dart';
import 'package:tractian/src/data/models/company_model.dart';
import 'package:tractian/src/data/models/location_model.dart';
import 'package:tractian/src/data/repositories/tractian_repository.dart';
import 'package:tractian/src/data/services/local/assets_local_service.dart';
import 'package:tractian/src/data/services/local/company_local_service.dart';
import 'package:tractian/src/data/services/local/config_local_service.dart';
import 'package:tractian/src/data/services/local/location_local_service.dart';
import 'package:tractian/src/data/services/remote/tractian_api_service.dart';
import 'package:tractian/src/domain/errors/tractian_error.dart';

import 'tractian_repository_test.mocks.dart';

@GenerateMocks([
  TractianApiService,
  ConfigLocalService,
  CompanyLocalService,
  LocationLocalService,
  AssetsLocalService,
])
void main() {
  late TractianRepository repository;
  late MockTractianApiService mockTractianApiService;
  late MockConfigLocalService mockConfigLocalService;
  late MockCompanyLocalService mockCompanyLocalService;
  late MockLocationLocalService mockLocationLocalService;
  late MockAssetsLocalService mockAssetsLocalService;

  setUp(() {
    provideDummy<Result<List<AssetModel>>>(Result.ok([]));

    mockTractianApiService = MockTractianApiService();
    mockConfigLocalService = MockConfigLocalService();
    mockCompanyLocalService = MockCompanyLocalService();
    mockLocationLocalService = MockLocationLocalService();
    mockAssetsLocalService = MockAssetsLocalService();

    repository = TractianRepository(
      mockTractianApiService,
      mockConfigLocalService,
      mockCompanyLocalService,
      mockLocationLocalService,
      mockAssetsLocalService,
    );
  });

  group('getCompanies', () {
    final tCompanies = [
      const CompanyModel(id: '1', name: 'Company 1'),
      const CompanyModel(id: '2', name: 'Company 2'),
    ];

    test(
      'should return remote data when local data is not present or outdated',
      () async {
        // arrange
        when(
          mockConfigLocalService.needSyncCompanies(),
        ).thenAnswer((_) async => true);
        when(
          mockTractianApiService.getCompanies(),
        ).thenAnswer((_) async => tCompanies);
        when(
          mockCompanyLocalService.saveCompanies(tCompanies),
        ).thenAnswer((_) async {});
        when(
          mockConfigLocalService.updateLastSyncCompanies(),
        ).thenAnswer((_) async {});
        // act
        final result = await repository.getCompanies();
        // assert
        expect(result.getOrElse(() => []), tCompanies);
        verify(mockTractianApiService.getCompanies());
        verify(mockCompanyLocalService.saveCompanies(tCompanies));
        verify(mockConfigLocalService.updateLastSyncCompanies());
      },
    );

    test(
      'should return local data when local data is present and up-to-date',
      () async {
        // arrange
        when(
          mockConfigLocalService.needSyncCompanies(),
        ).thenAnswer((_) async => false);
        when(
          mockCompanyLocalService.getCompanies(),
        ).thenAnswer((_) async => tCompanies);
        // act
        final result = await repository.getCompanies();
        // assert
        expect(result.getOrElse(() => []), tCompanies);
        verify(mockCompanyLocalService.getCompanies());
        verifyNever(mockTractianApiService.getCompanies());
      },
    );

    test(
      'should return TractianDataError when api service throws an exception',
      () async {
        // arrange
        when(
          mockConfigLocalService.needSyncCompanies(),
        ).thenAnswer((_) async => true);
        when(mockTractianApiService.getCompanies()).thenThrow(Exception());
        // act
        final result = await repository.getCompanies();
        // assert
        expect(result.isError, true);
        expect(result, isA<Error<TractianDataError>>());
      },
    );
  });

  group('getLocationsByCompany', () {
    const tCompanyId = '123';
    final tLocations = [
      const LocationModel(
        id: '1',
        name: 'Location 1',
        parentId: null,
        companyId: tCompanyId,
      ),
      const LocationModel(
        id: '2',
        name: 'Location 2',
        parentId: null,
        companyId: tCompanyId,
      ),
    ];

    test(
      'should return remote data when local data is not present or outdated',
      () async {
        // arrange
        when(
          mockConfigLocalService.needSyncLocations(),
        ).thenAnswer((_) async => true);
        when(
          mockTractianApiService.getLocationsByCompany(tCompanyId),
        ).thenAnswer((_) async => tLocations);
        when(
          mockLocationLocalService.saveLocations(tCompanyId, tLocations),
        ).thenAnswer((_) async {});
        when(
          mockConfigLocalService.updateLastSyncLocations(),
        ).thenAnswer((_) async {});
        // act
        final result = await repository.getLocationsByCompany(
          companyId: tCompanyId,
        );
        // assert
        expect(result.getOrElse(() => []), tLocations);
        verify(mockTractianApiService.getLocationsByCompany(tCompanyId));
        verify(mockLocationLocalService.saveLocations(tCompanyId, tLocations));
        verify(mockConfigLocalService.updateLastSyncLocations());
      },
    );

    test(
      'should return local data when local data is present and up-to-date',
      () async {
        // arrange
        when(
          mockConfigLocalService.needSyncLocations(),
        ).thenAnswer((_) async => false);
        when(
          mockLocationLocalService.getLocationsByCompany(tCompanyId),
        ).thenAnswer((_) async => tLocations);
        // act
        final result = await repository.getLocationsByCompany(
          companyId: tCompanyId,
        );
        // assert
        expect(result.getOrElse(() => []), tLocations);
        verify(mockLocationLocalService.getLocationsByCompany(tCompanyId));
        verifyNever(mockTractianApiService.getLocationsByCompany(tCompanyId));
      },
    );

    test(
      'should return TractianDataError when api service throws an exception',
      () async {
        // arrange
        when(
          mockConfigLocalService.needSyncLocations(),
        ).thenAnswer((_) async => true);
        when(
          mockTractianApiService.getLocationsByCompany(tCompanyId),
        ).thenThrow(Exception());
        // act
        final result = await repository.getLocationsByCompany(
          companyId: tCompanyId,
        );
        // assert
        expect(result.isError, true);
        expect(result, isA<Error<TractianDataError>>());
      },
    );
  });

  group('filterLocations', () {
    const tCompanyId = '123';
    const tQuery = 'test';
    final tLocations = [
      const LocationModel(
        id: '1',
        name: 'Location 1',
        parentId: null,
        companyId: tCompanyId,
      ),
      const LocationModel(
        id: '2',
        name: 'Location 2',
        parentId: null,
        companyId: tCompanyId,
      ),
    ];

    test('should return filtered locations from local service', () async {
      // arrange
      when(
        mockLocationLocalService.filterLocations(
          companyId: tCompanyId,
          query: tQuery,
        ),
      ).thenAnswer((_) async => tLocations);
      // act
      final result = await repository.filterLocations(
        companyId: tCompanyId,
        query: tQuery,
      );
      // assert
      expect(result.getOrElse(() => []), tLocations);
      verify(
        mockLocationLocalService.filterLocations(
          companyId: tCompanyId,
          query: tQuery,
        ),
      );
    });

    test(
      'should return TractianDataError when local service throws an exception',
      () async {
        // arrange
        when(
          mockLocationLocalService.filterLocations(
            companyId: tCompanyId,
            query: tQuery,
          ),
        ).thenThrow(Exception());
        // act
        final result = await repository.filterLocations(
          companyId: tCompanyId,
          query: tQuery,
        );
        // assert
        expect(result.isError, true);
        expect(result, isA<Error<TractianDataError>>());
      },
    );
  });

  group('getAssetsByCompany', () {
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

    test(
      'should return remote data when local data is not present or outdated',
      () async {
        // arrange
        when(
          mockConfigLocalService.needSyncAssets(),
        ).thenAnswer((_) async => true);
        when(
          mockTractianApiService.getAssetsByCompany(tCompanyId),
        ).thenAnswer((_) async => tAssets);
        when(
          mockAssetsLocalService.saveAssets(tCompanyId, tAssets),
        ).thenAnswer((_) async {});
        when(
          mockConfigLocalService.updateLastSyncAssets(),
        ).thenAnswer((_) async {});
        // act
        final result = await repository.getAssetsByCompany(
          companyId: tCompanyId,
        );
        // assert
        expect(result.getOrElse(() => []), tAssets);
        verify(mockTractianApiService.getAssetsByCompany(tCompanyId));
        verify(mockAssetsLocalService.saveAssets(tCompanyId, tAssets));
        verify(mockConfigLocalService.updateLastSyncAssets());
      },
    );

    test(
      'should return local data when local data is present and up-to-date',
      () async {
        // arrange
        when(
          mockConfigLocalService.needSyncAssets(),
        ).thenAnswer((_) async => false);
        when(
          mockAssetsLocalService.getAssetsByCompany(tCompanyId),
        ).thenAnswer((_) async => tAssets);
        // act
        final result = await repository.getAssetsByCompany(
          companyId: tCompanyId,
        );
        // assert
        expect(result.getOrElse(() => []), tAssets);
        verify(mockAssetsLocalService.getAssetsByCompany(tCompanyId));
        verifyNever(mockTractianApiService.getAssetsByCompany(tCompanyId));
      },
    );

    test(
      'should return TractianDataError when api service throws an exception',
      () async {
        // arrange
        when(
          mockConfigLocalService.needSyncAssets(),
        ).thenAnswer((_) async => true);
        when(
          mockTractianApiService.getAssetsByCompany(tCompanyId),
        ).thenThrow(Exception());
        // act
        final result = await repository.getAssetsByCompany(
          companyId: tCompanyId,
        );
        // assert
        expect(result.isError, true);
        expect(result, isA<Error<TractianDataError>>());
      },
    );
  });

  group('filterAssets', () {
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

    test('should return filtered assets from local service', () async {
      // arrange
      when(
        mockAssetsLocalService.filterAssets(
          companyId: tCompanyId,
          lstLocationId: tLstLocationId,
          query: tQuery,
          sensorType: tSensorType,
          status: tStatus,
        ),
      ).thenAnswer((_) async => tAssets);
      // act
      final result = await repository.filterAssets(
        companyId: tCompanyId,
        lstLocationId: tLstLocationId,
        query: tQuery,
        sensorType: tSensorType,
        status: tStatus,
      );
      // assert
      expect(result.getOrElse(() => []), tAssets);
      verify(
        mockAssetsLocalService.filterAssets(
          companyId: tCompanyId,
          lstLocationId: tLstLocationId,
          query: tQuery,
          sensorType: tSensorType,
          status: tStatus,
        ),
      );
    });

    test(
      'should return TractianDataError when local service throws an exception',
      () async {
        // arrange
        when(
          mockAssetsLocalService.filterAssets(
            companyId: tCompanyId,
            lstLocationId: tLstLocationId,
            query: tQuery,
            sensorType: tSensorType,
            status: tStatus,
          ),
        ).thenThrow(Exception());
        // act
        final result = await repository.filterAssets(
          companyId: tCompanyId,
          lstLocationId: tLstLocationId,
          query: tQuery,
          sensorType: tSensorType,
          status: tStatus,
        );
        // assert
        expect(result.isError, true);
        expect(result, isA<Error<TractianDataError>>());
      },
    );
  });
}
