import '../../core/utils/result.dart';
import '../../data/models/location_model.dart';
import '../../data/repositories/i_tractian_repository.dart.dart';

class GetLocationsByCompany {
  final ITractianRepository _tractianRepository;

  const GetLocationsByCompany(this._tractianRepository);

  Future<Result<List<LocationModel>>> call({required String companyId}) async {
    final result = await _tractianRepository.getLocationsByCompany(
      companyId: companyId,
    );

    return result;
  }
}
