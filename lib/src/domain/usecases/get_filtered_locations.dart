import '../../core/utils/result.dart';
import '../../data/models/location_model.dart';
import '../../data/repositories/i_tractian_repository.dart.dart';

class GetFilteredLocations {
  final ITractianRepository _tractianRepository;

  const GetFilteredLocations(this._tractianRepository);

  Future<Result<List<LocationModel>>> call({
    required String companyId,
    required String query,
  }) async {
    return await _tractianRepository.filterLocations(
      companyId: companyId,
      query: query,
    );
  }
}
