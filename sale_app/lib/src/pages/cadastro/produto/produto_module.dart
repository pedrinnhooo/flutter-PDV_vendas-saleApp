import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:fluggy/src/pages/cadastro/produto/detail/produto_detail_page.dart';
import 'package:fluggy/src/pages/cadastro/servico/servico_module.dart';
import 'package:flutter/material.dart';
import 'package:fluggy/src/app_module.dart';
import 'package:fluggy/src/pages/cadastro/categoria/categoria_module.dart';
import 'package:fluggy/src/pages/cadastro/grade/grade_module.dart';
import 'package:fluggy/src/pages/cadastro/produto/list/produto_list_page.dart';
import 'package:fluggy/src/pages/cadastro/variante/variante_module.dart';
import 'package:common_files/common_files.dart';

class ProdutoModule extends ModuleWidget {
  bool edicaoEstoque = false;
  Produto produto;

  ProdutoModule({this.edicaoEstoque=false, this.produto});

  @override
  List<Bloc> get blocs => [
        Bloc((i) => ProdutoBloc(AppModule.to.getBloc<HasuraBloc>(), 
                                AppModule.to.getBloc<AppGlobalBloc>(),
                                AppModule.to.getBloc<ConsultaEstoqueBloc>())),
      ];

  @override
  List<Dependency> get dependencies => [
    Dependency((i) => CategoriaModule()),
    Dependency((i) => VarianteModule()),
    Dependency((i) => GradeModule()),
    Dependency((i) => ServicoModule()),
  ];

  @override
  Widget get view => edicaoEstoque ? ProdutoDetailPage(produto: produto) : ProdutoListPage();

  static Inject get to => Inject<ProdutoModule>.of();
}
