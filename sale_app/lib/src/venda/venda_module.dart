
import 'package:common_files/common_files.dart';
import 'package:fluggy/src/app_module.dart';
import 'package:fluggy/src/pages/cadastro/cliente/cliente_module.dart';
import 'package:fluggy/src/pages/configuracao/vendedor/vendedor_module.dart';
import 'package:fluggy/src/venda/consulta_venda/consulta_venda_bloc.dart';
import 'package:fluggy/src/venda/grade/venda_grade_bloc.dart';
import 'package:fluggy/src/venda/carrinho/quantidade_item/quantidade_item_bloc.dart';
import 'package:fluggy/src/venda/carrinho/valor_item/valor_item_bloc.dart';
import 'package:fluggy/src/venda/carrinho/desconto_item/desconto_item_bloc.dart';
import 'package:fluggy/src/venda/pagamento/pagamento_desconto/pagamento_desconto_bloc.dart';
import 'package:fluggy/src/venda/pagamento/pagamento_valor/pagamento_valor_bloc.dart';
import 'package:fluggy/src/venda/recibo/recibo_bloc.dart';
import 'package:fluggy/src/venda/pagamento/pagamento_bloc.dart';
import 'package:fluggy/src/venda/carrinho/carrinho_bloc.dart';
import 'package:fluggy/src/venda/variante/venda_variante_bloc.dart';
import 'package:fluggy/src/venda/venda_bloc.dart';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:fluggy/src/venda/venda_page.dart';

class VendaModule extends ModuleWidget {
  @override
  List<Bloc> get blocs => [
        Bloc((i) => MovimentoCaixaBloc(AppModule.to.getBloc<HasuraBloc>(), AppModule.to.getBloc<AppGlobalBloc>())),
        //Bloc((i) => ConsultaMovimentoClienteBloc()),
        Bloc((i) => ConsultaEstoqueBloc(AppModule.to.getBloc<HasuraBloc>(), AppModule.to.getBloc<AppGlobalBloc>())),
        Bloc((i) => ConsultaVendaBloc(AppModule.to.getBloc<AppGlobalBloc>(), AppModule.to.getBloc<HasuraBloc>())),
        Bloc((i) => QuantidadeItemBloc()),
        Bloc((i) => ValorItemBloc()),
        Bloc((i) => DescontoItemBloc()),
        Bloc((i) => QuantidadeItemBloc()),
        Bloc((i) => PagamentoDescontoBloc()),
        Bloc((i) => PagamentoValorBloc()),
        Bloc((i) => VendaVarianteBloc()),
        Bloc((i) => VendaGradeBloc()),
        Bloc((i) => ReciboBloc()),
        Bloc((i) => PagamentoBloc()),
        Bloc((i) => CarrinhoBloc()),
        Bloc((i) => VendaBloc()),
        Bloc((i) => IntegracaoBloc(AppModule.to.getBloc<HasuraBloc>(), AppModule.to.getBloc<AppGlobalBloc>())),
        Bloc((i) => CategoriaBloc(AppModule.to.getBloc<HasuraBloc>(), AppModule.to.getBloc<AppGlobalBloc>())),
      ];

  @override
  List<Dependency> get dependencies => [
    Dependency((i) => ClienteModule()),
    Dependency((i) => VendedorModule())
  ];

  @override
  Widget get view => VendaPage();

  static Inject get to => Inject<VendaModule>.of();
}
