import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:fluggy/src/venda/pagamento/pagamento_desconto/pagamento_desconto_bloc.dart';
import 'package:fluggy/src/venda/pagamento/pagamento_desconto/pagamento_desconto_page.dart';

class PagamentoDescontoModule extends ModuleWidget {
  @override
  List<Bloc> get blocs => [
        Bloc((i) => PagamentoDescontoBloc()),
      ];

  @override
  List<Dependency> get dependencies => [];

  @override
  Widget get view => PagamentoDescontoPage();

  static Inject get to => Inject<PagamentoDescontoModule>.of();
}
