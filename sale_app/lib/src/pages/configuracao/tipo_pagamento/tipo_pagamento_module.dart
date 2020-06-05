import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:common_files/common_files.dart';
import 'package:fluggy/src/app_module.dart';
import 'package:flutter/material.dart';
import 'package:fluggy/src/pages/configuracao/tipo_pagamento/list/tipo_pagamento_list_page.dart';

class TipoPagamentoModule extends ModuleWidget {
  @override
  List<Bloc> get blocs => [
     Bloc((i) => TipoPagamentoBloc(AppModule.to.getBloc<HasuraBloc>(), AppModule.to.getBloc<AppGlobalBloc>())),
  ];

  @override
  List<Dependency> get dependencies => [];

  @override
  Widget get view => TipoPagamentoListPage();

  static Inject get to => Inject<TipoPagamentoModule>.of();
}
