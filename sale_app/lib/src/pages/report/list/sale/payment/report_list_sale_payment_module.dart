import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:common_files/common_files.dart';
import 'package:fluggy/src/pages/report/list/sale/payment/report_list_sale_payment_page.dart';
import 'package:flutter/material.dart';
import 'package:fluggy/src/app_module.dart';

class ReportListSalePaymentModule extends ModuleWidget {
  @override
  List<Bloc> get blocs => [
        Bloc((i) => ReportListSalePaymentBloc(AppModule.to.getBloc<HasuraBloc>(), AppModule.to.getBloc<AppGlobalBloc>())),
      ];

  @override
  List<Dependency> get dependencies => [];

  @override
  Widget get view => ReportListSalePaymentPage();

  static Inject get to => Inject<ReportListSalePaymentModule>.of();
}
