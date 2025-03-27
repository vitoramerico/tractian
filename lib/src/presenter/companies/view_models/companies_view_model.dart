import 'package:flutter/widgets.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../../core/utils/constants/routes.dart';
import '../../../domain/usecases/get_companies.dart';

import '../../../core/utils/command.dart';
import '../../../core/utils/result.dart';
import '../../../data/models/company_model.dart';

class CompaniesViewModel extends ChangeNotifier {
  CompaniesViewModel(this._getCompanies) {
    getCompanies = Command0(_getAllCompanies);
  }

  final GetCompanies _getCompanies;

  late final Command0<List<CompanyModel>> getCompanies;

  List<CompanyModel> _lstCompany = [];
  List<CompanyModel> get lstCompany => _lstCompany;
  void setLstCompany(List<CompanyModel> value) {
    _lstCompany = value;
    notifyListeners();
  }

  Future<Result<List<CompanyModel>>> _getAllCompanies() async {
    final result = await _getCompanies();

    return result.fold(
      (values) => Result.ok(_lstCompany = values),
      (error) => Result.error(error),
    );
  }

  void openPageAssets(String companyId) {
    Modular.to.pushNamed(AppRoutes.assets, arguments: companyId);
  }
}
