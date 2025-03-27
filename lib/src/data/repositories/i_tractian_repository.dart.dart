import '../../core/utils/result.dart';
import '../models/asset_model.dart';
import '../models/company_model.dart';
import '../models/location_model.dart';

abstract interface class ITractianRepository {
  Future<Result<List<CompanyModel>>> getCompanies();
  Future<Result<List<LocationModel>>> getLocationsByCompany({
    required String companyId,
  });
  Future<Result<List<AssetModel>>> getAssetsByCompany({
    required String companyId,
  });
  Future<Result<List<LocationModel>>> filterLocations({
    required String companyId,
    required String query,
  });
  Future<Result<List<AssetModel>>> filterAssets({
    required String companyId,
    required List<String> lstLocationId,
    required String query,
    required String sensorType,
    required String status,
  });
}
