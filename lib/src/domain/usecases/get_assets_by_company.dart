import '../../core/utils/result.dart';
import '../../data/models/asset_model.dart';
import '../../data/repositories/i_tractian_repository.dart.dart';

class GetAssetsByCompany {
  final ITractianRepository _tractianRepository;

  const GetAssetsByCompany(this._tractianRepository);

  Future<Result<List<AssetModel>>> call({required String companyId}) async {
    final result = await _tractianRepository.getAssetsByCompany(
      companyId: companyId,
    );

    return result;
  }
}
