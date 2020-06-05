import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:common_files/common_files.dart';
import 'package:fluggy/src/pages/report/list/sale/ticket/report_list_sale_ticket_page.dart';
import 'package:flutter/material.dart';
import 'package:fluggy/src/app_module.dart';

class ReportListSaleTicketModule extends ModuleWidget {
  @override
  List<Bloc> get blocs => [
        Bloc((i) => ReportListSaleTicketBloc(AppModule.to.getBloc<HasuraBloc>(), AppModule.to.getBloc<AppGlobalBloc>())),
      ];

  @override
  List<Dependency> get dependencies => [];

  @override
  Widget get view => ReportListSaleTicketPage();

  static Inject get to => Inject<ReportListSaleTicketModule>.of();
}
