import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:common_files/common_files.dart';
import 'package:flutter/material.dart';
import 'package:fluggy/src/app_module.dart';
import 'package:fluggy/src/pages/cadastro/categoria/list/categoria_list_page.dart';

class CategoriaModule extends ModuleWidget {
  @override
  List<Bloc> get blocs => [
        Bloc((i) => CategoriaBloc(AppModule.to.getBloc<HasuraBloc>(), AppModule.to.getBloc<AppGlobalBloc>())),
      ];

  @override
  List<Dependency> get dependencies => [];

  @override
  Widget get view => CategoriaListPage();

  static Inject get to => Inject<CategoriaModule>.of();
}
