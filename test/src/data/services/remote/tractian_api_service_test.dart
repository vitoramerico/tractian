import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tractian/src/core/http_connect/i_http_connect_interface.dart';
import 'package:tractian/src/data/services/remote/tractian_api_service.dart';

import 'tractian_api_service_test.mocks.dart';

class MockResponse {
  final dynamic data;

  MockResponse({required this.data});
}

@GenerateMocks([IHttpConnect])
void main() {
  late TractianApiService tractianApiService;
  late MockIHttpConnect mockHttpConnect;

  setUp(() {
    mockHttpConnect = MockIHttpConnect();
    tractianApiService = TractianApiService(mockHttpConnect);
  });

  group('TractianApiService Tests', () {
    group('getCompanies', () {
      test('should return a list of CompanyModel from API response', () async {
        // Arrange
        final mockResponse = [
          {'id': '1', 'name': 'Company 1'},
          {'id': '2', 'name': 'Company 2'},
        ];
        when(
          mockHttpConnect.get('/companies'),
        ).thenAnswer((_) async => MockResponse(data: mockResponse));

        // Act
        final result = await tractianApiService.getCompanies();

        // Assert
        expect(result.length, 2);
        expect(result[0].id, '1');
        expect(result[0].name, 'Company 1');
        expect(result[1].id, '2');
        expect(result[1].name, 'Company 2');
        verify(mockHttpConnect.get('/companies')).called(1);
      });

      test('should handle empty response', () async {
        // Arrange
        when(
          mockHttpConnect.get('/companies'),
        ).thenAnswer((_) async => MockResponse(data: []));

        // Act
        final result = await tractianApiService.getCompanies();

        // Assert
        expect(result, isEmpty);
        verify(mockHttpConnect.get('/companies')).called(1);
      });
    });

    group('getLocationsByCompany', () {
      test('should return a list of LocationModel with companyId', () async {
        // Arrange
        final companyId = 'comp1';
        final mockResponse = [
          {'id': 'loc1', 'name': 'Location 1'},
          {'id': 'loc2', 'name': 'Location 2'},
        ];
        when(
          mockHttpConnect.get('/companies/$companyId/locations'),
        ).thenAnswer((_) async => MockResponse(data: mockResponse));

        // Act
        final result = await tractianApiService.getLocationsByCompany(
          companyId,
        );

        // Assert
        expect(result.length, 2);
        expect(result[0].id, 'loc1');
        expect(result[0].name, 'Location 1');
        expect(result[0].companyId, companyId);
        expect(result[1].id, 'loc2');
        expect(result[1].name, 'Location 2');
        expect(result[1].companyId, companyId);
        verify(
          mockHttpConnect.get('/companies/$companyId/locations'),
        ).called(1);
      });

      test('should handle empty locations response', () async {
        // Arrange
        final companyId = 'comp1';
        when(
          mockHttpConnect.get('/companies/$companyId/locations'),
        ).thenAnswer((_) async => MockResponse(data: []));

        // Act
        final result = await tractianApiService.getLocationsByCompany(
          companyId,
        );

        // Assert
        expect(result, isEmpty);
        verify(
          mockHttpConnect.get('/companies/$companyId/locations'),
        ).called(1);
      });
    });

    group('getAssetsByCompany', () {
      test('should return a list of AssetModel with companyId', () async {
        // Arrange
        final companyId = 'comp1';
        final mockResponse = [
          {'id': 'asset1', 'name': 'Asset 1'},
          {'id': 'asset2', 'name': 'Asset 2'},
        ];
        when(
          mockHttpConnect.get('/companies/$companyId/assets'),
        ).thenAnswer((_) async => MockResponse(data: mockResponse));

        // Act
        final result = await tractianApiService.getAssetsByCompany(companyId);

        // Assert
        expect(result.length, 2);
        expect(result[0].id, 'asset1');
        expect(result[0].name, 'Asset 1');
        expect(result[0].companyId, companyId);
        expect(result[1].id, 'asset2');
        expect(result[1].name, 'Asset 2');
        expect(result[1].companyId, companyId);
        verify(mockHttpConnect.get('/companies/$companyId/assets')).called(1);
      });

      test('should handle empty assets response', () async {
        // Arrange
        final companyId = 'comp1';
        when(
          mockHttpConnect.get('/companies/$companyId/assets'),
        ).thenAnswer((_) async => MockResponse(data: []));

        // Act
        final result = await tractianApiService.getAssetsByCompany(companyId);

        // Assert
        expect(result, isEmpty);
        verify(mockHttpConnect.get('/companies/$companyId/assets')).called(1);
      });
    });
  });
}
