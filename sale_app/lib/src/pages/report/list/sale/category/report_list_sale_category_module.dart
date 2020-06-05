import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:common_files/common_files.dart';
import 'package:fluggy/src/pages/report/list/sale/category/report_list_sale_category_page.dart';
import 'package:flutter/material.dart';
import 'package:fluggy/src/app_module.dart';

class ReportListSaleCategoryModule extends ModuleWidget {
  @override
  List<Bloc> get blocs => [
        Bloc((i) => ReportListSaleCategoryBloc(AppModule.to.getBloc<HasuraBloc>(), AppModule.to.getBloc<AppGlobalBloc>())),
      ];

  @override
  List<Dependency> get dependencies => [];

  @override
  Widget get view => ReportListSaleCategoryPage();

  static Inject get to => Inject<ReportListSaleCategoryModule>.of();
}
