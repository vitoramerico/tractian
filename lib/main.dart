import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:tractian/src/core/database/database_helper.dart';

import 'src/core/http_connect/dio_http_connect.dart';
import 'src/core/http_connect/i_http_connect_interface.dart';
import 'src/core/ui/scroll_behavior.dart';
import 'src/core/ui/themes/theme.dart';
import 'src/presenter/companies/companies_module.dart';

void main() async {
  //Initialize Environment Variables
  await Future.wait([dotenv.load()]);

  return runApp(ModularApp(module: AppModule(), child: const AppWidget()));
}

class AppWidget extends StatelessWidget {
  const AppWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: Modular.routerConfig,
      scrollBehavior: AppCustomScrollBehavior(),
      theme: AppTheme.theme,
    );
  }
}

class AppModule extends Module {
  @override
  void exportedBinds(Injector i) {
    i.addLazySingleton(DatabaseHelper.new);
    i.addLazySingleton<IHttpConnect>(DioHttpConnect.new);
  }

  @override
  void routes(r) {
    r.module('/', module: CompaniesModule());
  }
}
