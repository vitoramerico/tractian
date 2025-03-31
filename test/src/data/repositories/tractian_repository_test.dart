import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tractian/src/core/http_connect/i_http_connect_interface.dart';
import 'package:tractian/src/core/utils/result.dart';
import 'package:tractian/src/data/models/asset_model.dart';
import 'package:tractian/src/data/models/company_model.dart';
import 'package:tractian/src/data/models/config_model.dart';
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
  IHttpConnect,
])
void main() {
  late TractianRepository repository;
  late MockTractianApiService mockTractianApiService;
  late MockConfigLocalService mockConfigLocalService;
  late MockCompanyLocalService mockCompanyLocalService;
  late MockLocationLocalService mockLocationLocalService;
  late MockAssetsLocalService mockAssetsLocalService;
  late MockIHttpConnect mockIHttpConnect;

  setUp(() async {
    //Initialize Environment Variables
    await dotenv.load();

    provideDummy<Result<List<AssetModel>>>(Result.ok([]));

    mockTractianApiService = MockTractianApiService();
    mockConfigLocalService = MockConfigLocalService();
    mockCompanyLocalService = MockCompanyLocalService();
    mockLocationLocalService = MockLocationLocalService();
    mockAssetsLocalService = MockAssetsLocalService();
    mockIHttpConnect = MockIHttpConnect();

    repository = TractianRepository(
      mockTractianApiService,
      mockConfigLocalService,
      mockCompanyLocalService,
      mockLocationLocalService,
      mockAssetsLocalService,
      mockIHttpConnect,
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
          mockConfigLocalService.getConfig(),
        ).thenAnswer((_) async => ConfigModel());
        when(
          mockTractianApiService.getCompanies(),
        ).thenAnswer((_) async => tCompanies);
        when(
          mockCompanyLocalService.saveCompanies(tCompanies),
        ).thenAnswer((_) async {});
        when(mockConfigLocalService.updateConfig(any)).thenAnswer((_) async {});
        // act
        final result = await repository.getCompanies();
        // assert
        expect(result.getOrElse(() => []), tCompanies);
        verify(mockTractianApiService.getCompanies());
        verify(mockCompanyLocalService.saveCompanies(tCompanies));
        verify(mockConfigLocalService.updateConfig(any));
      },
    );

    test(
      'should return local data when local data is available and not outdated',
      () async {
        // arrange
        final mockTime = DateTime.now().millisecondsSinceEpoch;

        when(
          mockIHttpConnect.checkConnectivity(),
        ).thenAnswer((_) async => true);
        when(
          mockConfigLocalService.getConfig(),
        ).thenAnswer((_) async => ConfigModel(lastSyncCompanies: mockTime));
        when(
          mockCompanyLocalService.getCompanies(),
        ).thenAnswer((_) async => tCompanies);
        // act
        final result = await repository.getCompanies();
        // assert
        expect(result.getOrElse(() => []), tCompanies);
        verify(mockCompanyLocalService.getCompanies());
        verifyNever(mockTractianApiService.getCompanies());
        verifyNever(mockConfigLocalService.updateConfig(any));
        verifyNever(mockCompanyLocalService.saveCompanies(any));
      },
    );

    test(
      'should return local data when there is no connection and local data is available',
      () async {
        // arrange
        final mockTime =
            DateTime.now()
                .subtract(const Duration(hours: 1))
                .millisecondsSinceEpoch;

        when(
          mockIHttpConnect.checkConnectivity(),
        ).thenAnswer((_) async => false);
        when(
          mockConfigLocalService.getConfig(),
        ).thenAnswer((_) async => ConfigModel(lastSyncCompanies: mockTime));
        when(
          mockCompanyLocalService.getCompanies(),
        ).thenAnswer((_) async => tCompanies);
        // act
        final result = await repository.getCompanies();
        // assert
        expect(result.getOrElse(() => []), tCompanies);
        verify(mockCompanyLocalService.getCompanies());
        verifyNever(mockTractianApiService.getCompanies());
        verifyNever(mockConfigLocalService.updateConfig(any));
        verifyNever(mockCompanyLocalService.saveCompanies(any));
      },
    );

    test(
      'should return api data when has connection and local data is outdated',
      () async {
        // arrange
        when(
          mockIHttpConnect.checkConnectivity(),
        ).thenAnswer((_) async => true);
        when(
          mockConfigLocalService.getConfig(),
        ).thenAnswer((_) async => ConfigModel());
        when(
          mockTractianApiService.getCompanies(),
        ).thenAnswer((_) async => tCompanies);
        // act
        final result = await repository.getCompanies();
        // assert
        expect(result.getOrElse(() => []), tCompanies);
        verify(mockTractianApiService.getCompanies());
        verify(mockConfigLocalService.updateConfig(any));
        verify(mockCompanyLocalService.saveCompanies(any));
        verifyNever(mockCompanyLocalService.getCompanies());
      },
    );

    test(
      'should return api data when has connection and local data is outdated',
      () async {
        // arrange
        when(
          mockIHttpConnect.checkConnectivity(),
        ).thenAnswer((_) async => true);
        when(
          mockConfigLocalService.getConfig(),
        ).thenAnswer((_) async => ConfigModel());
        when(
          mockTractianApiService.getCompanies(),
        ).thenAnswer((_) async => tCompanies);
        // act
        final result = await repository.getCompanies();
        // assert
        expect(result.getOrElse(() => []), tCompanies);
        verify(mockTractianApiService.getCompanies());
        verify(mockConfigLocalService.updateConfig(any));
        verify(mockCompanyLocalService.saveCompanies(any));
        verifyNever(mockCompanyLocalService.getCompanies());
      },
    );

    test(
      'should return a TractianDataError when the API service throws an exception',
      () async {
        // arrange
        when(
          mockConfigLocalService.getConfig(),
        ).thenAnswer((_) async => ConfigModel());
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
          mockConfigLocalService.getConfig(),
        ).thenAnswer((_) async => ConfigModel());
        when(
          mockTractianApiService.getLocationsByCompany(tCompanyId),
        ).thenAnswer((_) async => tLocations);
        when(
          mockLocationLocalService.saveLocations(tCompanyId, tLocations),
        ).thenAnswer((_) async {});
        when(mockConfigLocalService.updateConfig(any)).thenAnswer((_) async {});
        // act
        final result = await repository.getLocationsByCompany(
          companyId: tCompanyId,
        );
        // assert
        expect(result.getOrElse(() => []), tLocations);
        verify(mockTractianApiService.getLocationsByCompany(tCompanyId));
        verify(mockLocationLocalService.saveLocations(tCompanyId, tLocations));
        verify(mockConfigLocalService.updateConfig(any));
      },
    );

    test(
      'should return local data when local data is available and up-to-date',
      () async {
        // arrange
        final currentTime = DateTime.now().millisecondsSinceEpoch;
        when(
          mockConfigLocalService.getConfig(),
        ).thenAnswer((_) async => ConfigModel(lastSyncLocations: currentTime));
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
        verifyNever(mockConfigLocalService.updateConfig(any));
        verifyNever(mockLocationLocalService.saveLocations(any, any));
      },
    );

    test(
      'should return TractianDataError when API service throws an exception',
      () async {
        // arrange
        when(
          mockConfigLocalService.getConfig(),
        ).thenAnswer((_) async => ConfigModel());
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
          mockConfigLocalService.getConfig(),
        ).thenAnswer((_) async => ConfigModel());
        when(
          mockTractianApiService.getAssetsByCompany(tCompanyId),
        ).thenAnswer((_) async => tAssets);
        when(
          mockAssetsLocalService.saveAssets(tCompanyId, tAssets),
        ).thenAnswer((_) async {});
        when(mockConfigLocalService.updateConfig(any)).thenAnswer((_) async {});
        // act
        final result = await repository.getAssetsByCompany(
          companyId: tCompanyId,
        );
        // assert
        expect(result.getOrElse(() => []), tAssets);
        verify(mockTractianApiService.getAssetsByCompany(tCompanyId));
        verify(mockAssetsLocalService.saveAssets(tCompanyId, tAssets));
        verify(mockConfigLocalService.updateConfig(any));
      },
    );

    test(
      'should return local data when local data is available and up-to-date',
      () async {
        // arrange
        final currentTime = DateTime.now().millisecondsSinceEpoch;
        when(
          mockConfigLocalService.getConfig(),
        ).thenAnswer((_) async => ConfigModel(lastSyncAssets: currentTime));
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
      'should return TractianDataError when API service throws an exception',
      () async {
        // arrange
        when(
          mockConfigLocalService.getConfig(),
        ).thenAnswer((_) async => ConfigModel());
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
