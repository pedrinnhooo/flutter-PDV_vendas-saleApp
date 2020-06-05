import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:common_files/common_files.dart';
import 'package:flutter/material.dart';
import 'package:fluggy/src/app_module.dart';
import 'package:fluggy/src/pages/cadastro/cliente/list/cliente_list_page.dart';

class ClienteModule extends ModuleWidget {
  @override
  List<Bloc> get blocs => [
        Bloc((i) => ClienteBloc(AppModule.to.getBloc<HasuraBloc>(), AppModule.to.getBloc<SharedVendaBloc>(), AppModule.to.getBloc<AppGlobalBloc>())),
      ];

  @override
  List<Dependency> get dependencies => [];

  @override
  Widget get view => ClienteListPage();

  static Inject get to => Inject<ClienteModule>.of();
}
