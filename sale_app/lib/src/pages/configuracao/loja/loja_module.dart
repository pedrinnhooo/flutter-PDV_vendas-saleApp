import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:common_files/common_files.dart';
import 'package:flutter/material.dart';
import 'package:fluggy/src/app_module.dart';
import 'package:fluggy/src/pages/configuracao/loja/list/loja_list_page.dart';

class LojaModule extends ModuleWidget {
  @override
  List<Bloc> get blocs => [
        Bloc((i) => LojaBloc(AppModule.to.getBloc<HasuraBloc>(), AppModule.to.getBloc<SharedVendaBloc>(), AppModule.to.getBloc<AppGlobalBloc>())),
      ];

  @override
  List<Dependency> get dependencies => [];

  @override
  Widget get view => LojaListPage();

  static Inject get to => Inject<LojaModule>.of();
}
