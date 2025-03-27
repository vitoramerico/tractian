import 'package:flutter_modular/flutter_modular.dart';

import '../../../main.dart';
import '../../data/repositories/i_tractian_repository.dart.dart';
import '../../data/repositories/tractian_repository.dart';
import '../../data/services/local/assets_local_service.dart';
import '../../data/services/local/company_local_service.dart';
import '../../data/services/local/config_local_service.dart';
import '../../data/services/local/location_local_service.dart';
import '../../data/services/remote/tractian_api_service.dart';
import '../../domain/usecases/build_tree_structure.dart';
import '../../domain/usecases/get_assets_by_company.dart';
import '../../domain/usecases/get_filtered_assets.dart';
import '../../domain/usecases/get_filtered_locations.dart';
import '../../domain/usecases/get_locations_by_company.dart';
import 'pages/assets_page.dart';
import 'view_models/assets_view_model.dart';

class AssetsModule extends Module {
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
    i.addLazySingleton(BuildTreeStructure.new);
    i.addLazySingleton(GetAssetsByCompany.new);
    i.addLazySingleton(GetFilteredLocations.new);
    i.addLazySingleton(GetFilteredAssets.new);
    i.addLazySingleton(GetLocationsByCompany.new);
    i.addLazySingleton(AssetsViewModel.new);
  }

  @override
  void routes(r) {
    r.child(
      Modular.initialRoute,
      child: (context) => AssetsPage(companyId: r.args.data),
    );
  }
}
