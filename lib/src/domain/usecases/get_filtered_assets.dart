import '../../core/utils/result.dart';
import '../../data/models/asset_model.dart';
import '../../data/repositories/i_tractian_repository.dart.dart';

class GetFilteredAssets {
  final ITractianRepository _tractianRepository;

  const GetFilteredAssets(this._tractianRepository);

  Future<Result<List<AssetModel>>> call({
    required String companyId,
    required List<String> lstLocationId,
    required String query,
    required String sensorType,
    required String status,
  }) async {
    return await _tractianRepository.filterAssets(
      companyId: companyId,
      query: query,
      lstLocationId: lstLocationId,
      sensorType: sensorType,
      status: status,
    );
  }
}
