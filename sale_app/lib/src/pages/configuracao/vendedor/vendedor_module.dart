import 'package:common_files/common_files.dart';
import 'package:fluggy/src/app_module.dart';
import 'package:fluggy/src/pages/configuracao/vendedor/list/vendedor_list_page.dart';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';

class VendedorModule extends ModuleWidget {
  @override
  List<Bloc> get blocs => [
        Bloc((i) => VendedorBloc(AppModule.to.getBloc<HasuraBloc>(), AppModule.to.getBloc<SharedVendaBloc>(), AppModule.to.getBloc<AppGlobalBloc>())),
      ];

  @override
  List<Dependency> get dependencies => [];

  @override
  Widget get view => VendedorListPage();

  static Inject get to => Inject<VendedorModule>.of();
}
