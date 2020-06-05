import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:common_files/common_files.dart';
import 'package:fluggy/src/app_module.dart';
import 'package:fluggy/src/pages/operacao/login_cadastro/login_cadastro_page.dart';
import 'package:flutter/material.dart';

class LoginCadastroModule extends ModuleWidget {
  @override
  List<Bloc> get blocs => [
    Bloc((i) => LoginCadastroBloc(AppModule.to.getBloc<AppGlobalBloc>())),
  ];

  @override
  List<Dependency> get dependencies => [];

  @override
  Widget get view => LoginCadastroPage();

  static Inject get to => Inject<LoginCadastroModule>.of();
}
