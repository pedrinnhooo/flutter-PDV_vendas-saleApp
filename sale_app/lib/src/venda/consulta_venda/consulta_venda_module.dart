import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:common_files/common_files.dart';
import 'package:fluggy/src/app_module.dart';
import 'package:flutter/material.dart';
import 'package:fluggy/src/venda/consulta_venda/consulta_venda_bloc.dart';
import 'package:fluggy/src/venda/consulta_venda/consulta_venda_page.dart';

class ConsultaVendaModule extends ModuleWidget {
  @override
  List<Bloc> get blocs => [
    Bloc((i) => ConsultaVendaBloc(AppModule.to.getBloc<AppGlobalBloc>(), AppModule.to.getBloc<HasuraBloc>())),
  ];

  @override
  List<Dependency> get dependencies => [];

  @override
  Widget get view => ConsultaVendaPage();

  static Inject get to => Inject<ConsultaVendaModule>.of();
}
