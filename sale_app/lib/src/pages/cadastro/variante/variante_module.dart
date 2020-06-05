import 'package:common_files/common_files.dart';
import 'package:fluggy/src/app_module.dart';
import 'package:fluggy/src/pages/cadastro/variante/list/variante_list_page.dart';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';

class VarianteModule extends ModuleWidget {
  @override
  List<Bloc> get blocs => [
        Bloc((i) => VarianteBloc(AppModule.to.getBloc<HasuraBloc>(), AppModule.to.getBloc<AppGlobalBloc>())),
      ];

  @override
  List<Dependency> get dependencies => [];

  @override
  Widget get view => VarianteListPage();

  static Inject get to => Inject<VarianteModule>.of();
}
