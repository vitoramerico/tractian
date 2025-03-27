import '../../data/models/company_model.dart';
import '../../core/utils/result.dart';
import '../../data/repositories/i_tractian_repository.dart.dart';

class GetCompanies {
  final ITractianRepository _tractianRepository;

  const GetCompanies(this._tractianRepository);

  Future<Result<List<CompanyModel>>> call() async {
    final result = await _tractianRepository.getCompanies();

    return result;
  }
}
