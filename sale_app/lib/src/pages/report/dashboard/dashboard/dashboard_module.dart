import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:common_files/common_files.dart';
import 'package:fluggy/src/app_module.dart';
import 'package:fluggy/src/pages/report/dashboard/dashboard/dashboard_page.dart';
import 'package:flutter/material.dart';

class DashboardModule extends ModuleWidget {
  @override
  List<Bloc> get blocs => [
        Bloc((i) => DashboardBloc(AppModule.to.getBloc<HasuraBloc>(), AppModule.to.getBloc<AppGlobalBloc>())),
      ];

  @override
  List<Dependency> get dependencies => [];

  @override
  Widget get view => DashboardPage();

  static Inject get to => Inject<DashboardModule>.of();
}
