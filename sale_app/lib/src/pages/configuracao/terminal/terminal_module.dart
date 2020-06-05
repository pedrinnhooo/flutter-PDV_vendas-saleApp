import 'package:common_files/common_files.dart';
import 'package:fluggy/src/app_module.dart';
import 'package:fluggy/src/pages/configuracao/mercadopago/mercadopago_module.dart';
import 'package:fluggy/src/pages/configuracao/cupom_layout/cupom_layout_module.dart';
import 'package:fluggy/src/pages/configuracao/picpay/picpay_module.dart';
import 'package:fluggy/src/pages/configuracao/terminal/list/terminal_list_page.dart';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:fluggy/src/pages/configuracao/terminal_impressora/terminalL_impressora_module.dart';
import 'package:flutter/material.dart';
import 'package:fluggy/src/pages/configuracao/transacao/transacao_module.dart';

class TerminalModule extends ModuleWidget {
  @override
  List<Bloc> get blocs => [
    Bloc((i) => TerminalBloc(AppModule.to.getBloc<HasuraBloc>(), AppModule.to.getBloc<AppGlobalBloc>())),
    Bloc((i) => IntegracaoBloc(AppModule.to.getBloc<HasuraBloc>(), AppModule.to.getBloc<AppGlobalBloc>())),
    Bloc((i) => ImpressoraBloc(AppModule.to.getBloc<HasuraBloc>(), AppModule.to.getBloc<AppGlobalBloc>())),
    Bloc((i) => CupomLayoutBloc(AppModule.to.getBloc<HasuraBloc>(), AppModule.to.getBloc<AppGlobalBloc>()))
  ];

  @override
  List<Dependency> get dependencies => [
    Dependency((i) => TransacaoModule()),
    Dependency((i) => MercadopagoModule()),
    Dependency((i) => PicpayModule()),
    Dependency((i) => ImpressoraModule()),
    Dependency((i) => CupomLayoutModule()),
  ];

  @override
  Widget get view => TerminalListPage();

  static Inject get to => Inject<TerminalModule>.of();
}
