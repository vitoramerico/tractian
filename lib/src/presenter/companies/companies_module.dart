import 'package:flutter_modular/flutter_modular.dart';

import '../../../main.dart';
import '../../data/repositories/i_tractian_repository.dart.dart';
import '../../data/repositories/tractian_repository.dart';
import '../../data/services/local/assets_local_service.dart';
import '../../data/services/local/company_local_service.dart';
import '../../data/services/local/config_local_service.dart';
import '../../data/services/local/location_local_service.dart';
import '../../data/services/remote/tractian_api_service.dart';
import '../../domain/usecases/get_companies.dart';
import 'pages/companies_page.dart';
import 'view_models/companies_view_model.dart';

class CompaniesModule extends Module {
  @override
  List<Module> get imports => [AppModule()];

  @override
  void binds(i) {
    i.addLazySingleton(ConfigLocalService.new);
    i.addLazySingleton(CompanyLocalService.new);
    i.addLazySingleton(LocationLocalService.new);
    i.addLazySingleton(AssetsLocalService.new);
    i.addLazySingleton(TractianApiService.new);
    i.addLazySingleton<ITractianRepository>(TractianRepository.new);
    i.addLazySingleton(GetCompanies.new);
    i.addLazySingleton(CompaniesViewModel.new);
  }

  @override
  void routes(r) {
    r.child(Modular.initialRoute, child: (context) => const CompaniesPage());
  }
}
