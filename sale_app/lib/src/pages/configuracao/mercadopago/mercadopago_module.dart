import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:fluggy/src/pages/configuracao/mercadopago/detail/mercadopago_detail_page.dart';
import 'package:flutter/material.dart';

class MercadopagoModule extends ModuleWidget {
  @override
  List<Bloc> get blocs => [
        //Bloc((i) => IntegracaoBloc(AppModule.to.getBloc<HasuraBloc>(), AppModule.to.getBloc<AppGlobalBloc>())),
      ];
      

  @override
  List<Dependency> get dependencies => [];

  @override
  Widget get view => MercadopagoDetailPage();

  static Inject get to => Inject<MercadopagoModule>.of();
}