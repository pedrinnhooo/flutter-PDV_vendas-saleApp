import 'package:fluggy/src/home/home_bloc.dart';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:fluggy/src/home/menu_page.dart';

class HomeModule extends ModuleWidget {

  @override
  List<Bloc> get blocs => [
        Bloc((i) => HomeBloc()),
      ];

  @override
  List<Dependency> get dependencies => [];

  @override
  Widget get view => MenuPage();

  static Inject get to => Inject<HomeModule>.of();
}
