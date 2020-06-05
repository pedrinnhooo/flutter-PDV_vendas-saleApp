import 'package:common_files/common_files.dart';
import 'package:fluggy/src/app_module.dart';
import 'package:fluggy/src/pages/cadastro/produto/produto_module.dart';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:fluggy/src/venda/consulta_estoque/consulta_estoque_page.dart';

class ConsultaEstoqueModule extends ModuleWidget {
  Produto produto;

  ConsultaEstoqueModule({this.produto});
  
  @override
  List<Bloc> get blocs => [
    Bloc((i) => ConsultaEstoqueBloc(AppModule.to.getBloc<HasuraBloc>(), AppModule.to.getBloc<AppGlobalBloc>(), produto: produto)),
    Bloc((i) => ProdutoBloc(AppModule.to.getBloc<HasuraBloc>(), AppModule.to.getBloc<AppGlobalBloc>(),AppModule.to.getBloc<ConsultaEstoqueBloc>())),
  ];

  @override
  List<Dependency> get dependencies => [
    Dependency((i) => ProdutoModule(edicaoEstoque: true)),
  ];

  @override
  Widget get view => ConsultaEstoquePage();

  static Inject get to => Inject<ConsultaEstoqueModule>.of();
}
