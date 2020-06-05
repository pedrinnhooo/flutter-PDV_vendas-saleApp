import 'package:common_files/common_files.dart';
import 'package:fluggy/src/app_module.dart';
import 'package:fluggy/src/pages/cadastro/preco_tabela/list/preco_tabela_list_page.dart';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';

class PrecoTabelaModule extends ModuleWidget {
  @override
  List<Bloc> get blocs => [
        Bloc((i) => PrecoTabelaBloc(AppModule.to.getBloc<HasuraBloc>())),
      ];

  @override
  List<Dependency> get dependencies => [];

  @override
  Widget get view => PrecoTabelaListPage();

  static Inject get to => Inject<PrecoTabelaModule>.of();
}
