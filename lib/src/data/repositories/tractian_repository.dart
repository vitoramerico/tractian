import '../../core/http_connect/i_http_connect_interface.dart';
import '../../core/utils/constants/env.dart';
import '../../core/utils/result.dart';
import '../../domain/errors/tractian_error.dart';
import '../models/asset_model.dart';
import '../models/company_model.dart';
import '../models/config_model.dart';
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
  final IHttpConnect _httpConnect;

  const TractianRepository(
    this._tractianApiService,
    this._configLocalService,
    this._companyLocalService,
    this._locationLocalService,
    this._assetsLocalService,
    this._httpConnect,
  );

  @override
  Future<Result<List<CompanyModel>>> getCompanies() async {
    return _getData<CompanyModel>(
      ttl: AppEnv.companiesCacheTtlMinutes,
      lastSyncGetter: (config) => config.lastSyncCompaniesDateTime,
      apiCall: _tractianApiService.getCompanies,
      localCall: _companyLocalService.getCompanies,
      saveToLocal: _companyLocalService.saveCompanies,
      configKeySetter: (config, timestamp) {
        return config.copyWith(lastSyncCompanies: timestamp);
      },
    );
  }

  @override
  Future<Result<List<LocationModel>>> getLocationsByCompany({
    required String companyId,
  }) async {
    return _getData<LocationModel>(
      companyId: companyId,
      ttl: AppEnv.locationsCacheTtlMinutes,
      lastSyncGetter: (config) => config.lastSyncLocationsDateTime,
      apiCall: () => _tractianApiService.getLocationsByCompany(companyId),
      localCall: () => _locationLocalService.getLocationsByCompany(companyId),
      saveToLocal: (result) {
        return _locationLocalService.saveLocations(companyId, result);
      },
      configKeySetter: (config, timestamp) {
        return config.copyWith(lastSyncLocations: timestamp);
      },
    );
  }

  @override
  Future<Result<List<AssetModel>>> getAssetsByCompany({
    required String companyId,
  }) async {
    return _getData<AssetModel>(
      companyId: companyId,
      ttl: AppEnv.assetsCacheTtlMinutes,
      lastSyncGetter: (config) => config.lastSyncAssetsDateTime,
      apiCall: () => _tractianApiService.getAssetsByCompany(companyId),
      localCall: () => _assetsLocalService.getAssetsByCompany(companyId),
      saveToLocal: (result) {
        return _assetsLocalService.saveAssets(companyId, result);
      },
      configKeySetter: (config, timestamp) {
        return config.copyWith(lastSyncAssets: timestamp);
      },
    );
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

  Future<Result<List<T>>> _getData<T>({
    required int ttl,
    required DateTime? Function(ConfigModel config) lastSyncGetter,
    required Future<List<T>> Function() apiCall,
    required Future<List<T>?> Function() localCall,
    required Future<void> Function(List<T> result) saveToLocal,
    required ConfigModel Function(ConfigModel config, int timestamp)
    configKeySetter,
    String? companyId,
  }) async {
    try {
      var config = await _configLocalService.getConfig();
      final lastSync = lastSyncGetter(config);
      final needSync = await _checkNeedSync(lastSync, ttl);

      List<T>? result;

      if (!needSync) {
        result = await localCall();
      }

      if (result == null || result.isEmpty) {
        result = await apiCall();

        config = configKeySetter(config, DateTime.now().millisecondsSinceEpoch);

        await saveToLocal(result);
        await _configLocalService.updateConfig(config);
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

  Future<bool> _checkNeedSync(DateTime? lastSync, int ttl) async {
    if (lastSync == null) {
      return true;
    }

    if (DateTime.now().difference(lastSync).inMinutes < ttl) {
      return false;
    }

    final hasConnection = await _httpConnect.checkConnectivity();

    return hasConnection;
  }
}
