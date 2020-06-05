import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:fluggy/src/venda/carrinho/desconto_item/desconto_item_bloc.dart';
import 'package:fluggy/src/venda/carrinho/desconto_item/desconto_item_page.dart';

class DescontoItemModule extends ModuleWidget {
  int index;
  DescontoItemModule({index}){
    this.index = index;
  }
  @override
  List<Bloc> get blocs => [
        Bloc((i) => DescontoItemBloc()),
      ];

  @override
  List<Dependency> get dependencies => [];

  @override
  Widget get view => DescontoItemPage(index: index);

  static Inject get to => Inject<DescontoItemModule>.of();
}
