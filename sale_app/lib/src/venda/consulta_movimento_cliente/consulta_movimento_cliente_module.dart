import 'package:fluggy/src/venda/consulta_movimento_cliente/pagamento_movimento_cliente/pagamento_movimento_valor/pagamento_movimento_valor_bloc.dart';
import 'package:fluggy/src/venda/consulta_movimento_cliente/pagamento_movimento_cliente/pagamento_movimento_cliente_bloc.dart';
import 'package:fluggy/src/venda/consulta_movimento_cliente/consulta_movimento_cliente_detalhe/consulta_movimento_cliente_detalhe_bloc.dart';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:fluggy/src/venda/consulta_movimento_cliente/consulta_movimento_cliente_page.dart';

class ConsultaMovimentoClienteModule extends ModuleWidget {
  @override
  List<Bloc> get blocs => [
        Bloc((i) => PagamentoMovimentoValorBloc()),
        Bloc((i) => PagamentoMovimentoClienteBloc()),
        Bloc((i) => ConsultaMovimentoClienteDetalheBloc()),
      ];

  @override
  List<Dependency> get dependencies => [];

  @override
  Widget get view => ConsultaMovimentoClientePage();

  static Inject get to => Inject<ConsultaMovimentoClienteModule>.of();
}
