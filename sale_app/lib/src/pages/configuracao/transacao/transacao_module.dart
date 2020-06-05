import 'package:common_files/common_files.dart';
import 'package:fluggy/src/app_module.dart';
import 'package:fluggy/src/pages/cadastro/preco_tabela/preco_tabela_module.dart';
import 'package:fluggy/src/pages/configuracao/transacao/list/transacao_list_page.dart';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';

class TransacaoModule extends ModuleWidget {
  @override
  List<Bloc> get blocs => [
        Bloc((i) => TransacaoBloc(AppModule.to.getBloc<HasuraBloc>(), AppModule.to.getBloc<AppGlobalBloc>())),
      ];

  @override
  List<Dependency> get dependencies => [
    Dependency((i) => PrecoTabelaModule()),
  ];

  @override
  Widget get view => TransacaoListPage();

  static Inject get to => Inject<TransacaoModule>.of();
}
