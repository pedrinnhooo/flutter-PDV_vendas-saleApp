import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:fluggy/src/pages/cadastro/categoria/categoria_module.dart';
import 'package:fluggy/src/pages/cadastro/produto/produto_module.dart';
import 'package:fluggy/src/pages/cadastro/servico/list/servico_list_page.dart';
import 'package:flutter/material.dart';
import 'package:fluggy/src/app_module.dart';
import 'package:common_files/common_files.dart';

class ServicoModule extends ModuleWidget {
  @override
  List<Bloc> get blocs => [
        Bloc((i) => ServicoBloc(AppModule.to.getBloc<HasuraBloc>(), AppModule.to.getBloc<AppGlobalBloc>(), AppModule.to.getBloc<ConsultaEstoqueBloc>())),
      ];

  @override
  List<Dependency> get dependencies => [
    Dependency((i) => CategoriaModule()),
    Dependency((i) => ProdutoModule()),
  ];

  @override
  Widget get view => ServicoListPage();

  static Inject get to => Inject<ServicoModule>.of();
}
