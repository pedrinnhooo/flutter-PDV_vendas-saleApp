import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:common_files/common_files.dart';
import 'package:fluggy/src/app_module.dart';
import 'package:fluggy/src/pages/configuracao/cupom_layout/list/cupom_layout_list.dart';
import 'package:flutter/material.dart';

class CupomLayoutModule extends ModuleWidget {
  @override
  List<Bloc> get blocs => [
    Bloc((i) => CupomLayoutBloc(AppModule.to.getBloc<HasuraBloc>(), AppModule.to.getBloc<AppGlobalBloc>()))
  ];

  @override
  List<Dependency> get dependencies => [];

  @override
  Widget get view => CupomLayoutList();

  static Inject get to => Inject<CupomLayoutModule>.of();
}
