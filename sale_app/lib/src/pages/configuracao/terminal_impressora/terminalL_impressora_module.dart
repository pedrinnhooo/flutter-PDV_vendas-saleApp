import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:common_files/common_files.dart';
import 'package:fluggy/src/app_module.dart';
import 'package:fluggy/src/pages/configuracao/terminal_impressora/detail/terminal_impressora_detail.dart';
import 'package:flutter/material.dart';

class ImpressoraModule extends ModuleWidget {
  @override
  List<Bloc> get blocs => [
    Bloc((i) => ImpressoraBloc(AppModule.to.getBloc<HasuraBloc>(), AppModule.to.getBloc<AppGlobalBloc>())),
  ];

  @override
  List<Dependency> get dependencies => [];

  @override
  Widget get view => ImpressoraDetailPage();

  static Inject get to => Inject<ImpressoraModule>.of();
}