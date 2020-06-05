import 'package:common_files/common_files.dart';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:fluggy/src/pages/cadastro/cliente/cliente_module.dart';
import 'package:fluggy/src/pages/configuracao/vendedor/vendedor_module.dart';
import 'package:fluggy/src/pages/operacao/login/login_bloc.dart';
import 'package:flutter/material.dart';
import 'package:fluggy/src/app_widget.dart';
import 'package:fluggy/src/app_bloc.dart';

class AppModule extends ModuleWidget {
  @override
  List<Bloc> get blocs => [
        Bloc((i) => AppBloc()),
        Bloc((i) => HasuraBloc()),
        Bloc((i) => AppGlobalBloc(AppModule.to.getBloc<HasuraBloc>())),
        Bloc((i) => MovimentoCaixaBloc(AppModule.to.getBloc<HasuraBloc>(), AppModule.to.getBloc<AppGlobalBloc>())),
        Bloc((i) => SharedVendaBloc(AppModule.to.getBloc<AppGlobalBloc>(), AppModule.to.getBloc<HasuraBloc>(), AppModule.to.getBloc<MovimentoCaixaBloc>())),
        Bloc((i) => SincronizacaoBloc(AppModule.to.getBloc<HasuraBloc>(), AppModule.to.getBloc<SharedVendaBloc>(), AppModule.to.getBloc<AppGlobalBloc>())),
        Bloc((i) => LoginBloc()),
        Bloc((i) => CategoriaBloc(AppModule.to.getBloc<HasuraBloc>(), AppModule.to.getBloc<AppGlobalBloc>())),
        Bloc((i) => ServicoBloc(AppModule.to.getBloc<HasuraBloc>(), AppModule.to.getBloc<AppGlobalBloc>(), AppModule.to.getBloc<ConsultaEstoqueBloc>())),
        Bloc((i) => MovimentoClienteBloc(AppModule.to.getBloc<HasuraBloc>(), AppModule.to.getBloc<AppGlobalBloc>())),
        Bloc((i) => ConsultaEstoqueBloc(AppModule.to.getBloc<HasuraBloc>(), AppModule.to.getBloc<AppGlobalBloc>())),
      ];

  @override
  List<Dependency> get dependencies => [
    Dependency((i) => ClienteModule()),
    Dependency((i) => VendedorModule())
  ];

  @override
  Widget get view => AppWidget();

  static Inject get to => Inject<AppModule>.of();
}
