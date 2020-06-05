import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:common_files/common_files.dart';
import 'package:flutter/material.dart';
import 'package:fluggy/src/app_module.dart';
import 'package:fluggy/src/pages/faq/detail/faq_detail_page.dart';

class FaqCategoriaModule extends ModuleWidget {
  @override
  List<Bloc> get blocs => [
        Bloc((i) => FaqCategoriaBloc(AppModule.to.getBloc<HasuraBloc>(), AppModule.to.getBloc<AppGlobalBloc>())),
      ];

  @override
  List<Dependency> get dependencies => [];

  @override
  Widget get view => FaqCategoriaListPage();

  static Inject get to => Inject<FaqCategoriaModule>.of();
}
