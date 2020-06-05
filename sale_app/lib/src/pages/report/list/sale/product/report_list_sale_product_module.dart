import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:common_files/common_files.dart';
import 'package:fluggy/src/pages/report/list/sale/product/report_list_sale_product_page.dart';
import 'package:flutter/material.dart';
import 'package:fluggy/src/app_module.dart';

class ReportListSaleProductModule extends ModuleWidget {
  @override
  List<Bloc> get blocs => [
        Bloc((i) => ReportListSaleProductBloc(AppModule.to.getBloc<HasuraBloc>(), AppModule.to.getBloc<AppGlobalBloc>())),
      ];

  @override
  List<Dependency> get dependencies => [];

  @override
  Widget get view => ReportListSaleProductPage();

  static Inject get to => Inject<ReportListSaleProductModule>.of();
}
