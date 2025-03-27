import '../../core/utils/result.dart';
import '../../domain/errors/tractian_error.dart';
import '../models/asset_model.dart';
import '../models/company_model.dart';
import '../models/location_model.dart';
import '../services/local/assets_local_service.dart';
import '../services/local/company_local_service.dart';
import '../services/local/config_local_service.dart';
import '../services/local/location_local_service.dart';
import '../services/remote/tractian_api_service.dart';
import 'i_tractian_repository.dart.dart';

class TractianRepository implements ITractianRepository {
  final TractianApiService _tractianApiService;
  final ConfigLocalService _configLocalService;
  final CompanyLocalService _companyLocalService;
  final LocationLocalService _locationLocalService;
  final AssetsLocalService _assetsLocalService;

  const TractianRepository(
    this._tractianApiService,
    this._configLocalService,
    this._companyLocalService,
    this._locationLocalService,
    this._assetsLocalService,
  );

  @override
  Future<Result<List<CompanyModel>>> getCompanies() async {
    try {
      final needSync = await _configLocalService.needSyncCompanies();
      List<CompanyModel>? result;

      if (!needSync) {
        result = await _companyLocalService.getCompanies();
      }

      if (result == null || result.isEmpty) {
        result = await _tractianApiService.getCompanies();
        await _companyLocalService.saveCompanies(result);
        await _configLocalService.updateLastSyncCompanies();
      }

      return Result.ok(result);
    } catch (error, stackTrace) {
      return Result.error(
        TractianDataError(
          stackTrace: stackTrace,
          errorMessage: error.toString(),
        ),
      );
    }
  }

  @override
  Future<Result<List<LocationModel>>> getLocationsByCompany({
    required String companyId,
  }) async {
    try {
      final needSync = await _configLocalService.needSyncLocations();
      List<LocationModel>? result;

      if (!needSync) {
        result = await _locationLocalService.getLocationsByCompany(companyId);
      }

      if (result == null || result.isEmpty) {
        result = await _tractianApiService.getLocationsByCompany(companyId);
        await _locationLocalService.saveLocations(companyId, result);
        await _configLocalService.updateLastSyncLocations();
      }

      return Result.ok(result);
    } catch (error, stackTrace) {
      return Result.error(
        TractianDataError(
          stackTrace: stackTrace,
          errorMessage: error.toString(),
        ),
      );
    }
  }

  @override
  Future<Result<List<LocationModel>>> filterLocations({
    required String companyId,
    required String query,
  }) async {
    try {
      final result = await _locationLocalService.filterLocations(
        companyId: companyId,
        query: query,
      );

      return Result.ok(result);
    } catch (error, stackTrace) {
      return Result.error(
        TractianDataError(
          stackTrace: stackTrace,
          errorMessage: error.toString(),
        ),
      );
    }
  }

  @override
  Future<Result<List<AssetModel>>> getAssetsByCompany({
    required String companyId,
  }) async {
    try {
      final needSync = await _configLocalService.needSyncAssets();
      List<AssetModel>? result;

      if (!needSync) {
        result = await _assetsLocalService.getAssetsByCompany(companyId);
      }

      if (result == null || result.isEmpty) {
        result = await _tractianApiService.getAssetsByCompany(companyId);
        await _assetsLocalService.saveAssets(companyId, result);
        await _configLocalService.updateLastSyncAssets();
      }

      return Result.ok(result);
    } catch (error, stackTrace) {
      return Result.error(
        TractianDataError(
          stackTrace: stackTrace,
          errorMessage: error.toString(),
        ),
      );
    }
  }

  @override
  Future<Result<List<AssetModel>>> filterAssets({
    required String companyId,
    required List<String> lstLocationId,
    required String query,
    required String sensorType,
    required String status,
  }) async {
    try {
      final result = await _assetsLocalService.filterAssets(
        companyId: companyId,
        lstLocationId: lstLocationId,
        query: query,
        sensorType: sensorType,
        status: status,
      );

      return Result.ok(result);
    } catch (error, stackTrace) {
      return Result.error(
        TractianDataError(
          stackTrace: stackTrace,
          errorMessage: error.toString(),
        ),
      );
    }
  }
}
