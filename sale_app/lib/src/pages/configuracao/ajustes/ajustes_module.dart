import 'package:common_files/common_files.dart';
import 'package:fluggy/src/app_module.dart';
import 'package:fluggy/src/pages/configuracao/ajustes/ajustes_page.dart';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';

class AjustesModule extends ModuleWidget {
  @override
  List<Bloc> get blocs => [
        Bloc((i) => ConfiguracaoGeralBloc(AppModule.to.getBloc<HasuraBloc>(), AppModule.to.getBloc<AppGlobalBloc>())),
      ];

  @override
  List<Dependency> get dependencies => [];

  @override
  Widget get view => AjustesPage();

  static Inject get to => Inject<AjustesModule>.of();
}
