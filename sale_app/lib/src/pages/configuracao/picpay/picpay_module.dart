import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:fluggy/src/pages/configuracao/picpay/detail/picpay_detail_page.dart';
import 'package:flutter/material.dart';

class PicpayModule extends ModuleWidget {
  @override
  List<Bloc> get blocs => [
        //Bloc((i) => IntegracaoBloc(AppModule.to.getBloc<HasuraBloc>(), AppModule.to.getBloc<AppGlobalBloc>())),
      ];
      

  @override
  List<Dependency> get dependencies => [];

  @override
  Widget get view => PicpayDetailPage();

  static Inject get to => Inject<PicpayModule>.of();
}