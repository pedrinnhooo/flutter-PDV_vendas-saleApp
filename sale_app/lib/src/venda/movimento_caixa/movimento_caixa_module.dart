import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:common_files/common_files.dart';
import 'package:fluggy/src/app_module.dart';
import 'package:fluggy/src/venda/movimento_caixa/movimento_caixa_page.dart';
import 'package:flutter/material.dart';

class MovimentoCaixaModule extends ModuleWidget {
  @override
  List<Bloc> get blocs => [
    Bloc((i) => MovimentoCaixaBloc(AppModule.to.getBloc<HasuraBloc>(), AppModule.to.getBloc<AppGlobalBloc>()))
  ];

  @override
  List<Dependency> get dependencies => [];

  @override
  Widget get view => MovimentoCaixaPage();

  static Inject get to => Inject<MovimentoCaixaModule>.of();
}
