import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:common_files/common_files.dart';
import 'package:flutter/material.dart';
import 'package:fluggy/src/app_module.dart';
import 'package:fluggy/src/venda/transacao/venda_transacao_bloc.dart';
import 'package:fluggy/src/venda/transacao/venda_transacao_page.dart';

class VendaTransacaoModule extends ModuleWidget {
  @override
  List<Bloc> get blocs => [
        Bloc((i) => VendaTransacaoBloc(AppModule.to.getBloc<HasuraBloc>(), AppModule.to.getBloc<AppGlobalBloc>())),
      ];

  @override
  List<Dependency> get dependencies => [];

  @override
  Widget get view => VendaTransacaoPage();

  static Inject get to => Inject<VendaTransacaoModule>.of();
}
