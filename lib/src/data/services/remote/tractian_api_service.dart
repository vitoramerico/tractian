import '../../../core/http_connect/i_http_connect_interface.dart';
import '../../models/asset_model.dart';
import '../../models/company_model.dart';
import '../../models/location_model.dart';

class TractianApiService {
  final IHttpConnect _httpConnect;

  const TractianApiService(this._httpConnect);

  Future<List<CompanyModel>> getCompanies() async {
    final response = await _httpConnect.get('/companies');

    List<dynamic> data = response.data;

    return data.map((v) => CompanyModel.fromMap(v)).toList();
  }

  Future<List<LocationModel>> getLocationsByCompany(String companyId) async {
    final response = await _httpConnect.get('/companies/$companyId/locations');

    List<dynamic> data = response.data;

    return data.map((v) {
      v['companyId'] = companyId;
      return LocationModel.fromMap(v);
    }).toList();
  }

  Future<List<AssetModel>> getAssetsByCompany(String companyId) async {
    final response = await _httpConnect.get('/companies/$companyId/assets');

    List<dynamic> data = response.data;

    return data.map((v) {
      v['companyId'] = companyId;
      return AssetModel.fromMap(v);
    }).toList();
  }
}
