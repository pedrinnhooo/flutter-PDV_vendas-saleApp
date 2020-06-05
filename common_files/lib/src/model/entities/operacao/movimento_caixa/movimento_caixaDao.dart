import 'package:common_files/common_files.dart';

class MovimentoCaixaDAO implements IEntityDAO {
  HasuraBloc _hasuraBloc;
  AppGlobalBloc _appGlobalBloc;
  final String tableName = "movimento_caixa";
  int filterId = 0;
  DateTime filterDataAbertura;
  DateTime filterDataFechamento;
  bool filterDataFechamentoAsNull = false;
  bool loadMovimentoCaixaParcela = false;
    
  MovimentoCaixa movimentoCaixa;
  List<MovimentoCaixa> movimentoCaixaList;
  
  @override
  Dao dao;

  MovimentoCaixaDAO(this._hasuraBloc, this.movimentoCaixa, this._appGlobalBloc) {
    dao = Dao();
    movimentoCaixa = movimentoCaixa == null ? MovimentoCaixa() : movimentoCaixa;
  }  

  @override
  IEntity fromMap(Map<String, dynamic> map) {}

  @override
  Future<List> getAll({bool preLoad=false}) async {
    String where = "1 = 1 ";
    where = filterId > 0 ? where + " and id_app = $filterId" : where; 
    where = filterDataAbertura != null ? where + " and date(data_abertura) = '${ourDate(filterDataAbertura)}'" : where;
    where = ((filterDataFechamento != null) && (!filterDataFechamentoAsNull)) ? where + " and date(data_fechamento) = '${ourDate(filterDataFechamento)}'" : where;
    where = filterDataFechamentoAsNull ? where + " and date(data_fechamento) ISNULL" : where;

    List<dynamic> args = [];

    List list = await dao.getList(this, where, args);
    movimentoCaixaList = List.generate(list.length, (i) {
      return MovimentoCaixa(
        idApp: list[i]['id_app'],
        id: list[i]['id'],
        idTerminal: list[i]['id_terminal'],
        dataAbertura: DateTime.parse(list[i]['data_abertura']),
        dataFechamento: list[i]['data_fechamento'] != null ? DateTime.parse(list[i]['data_fechamento']) : null,
        valorAbertura: list[i]['valor_abertura'],
        vendaTotalValorBruto: list[i]['venda_total_valor_bruto'],
        vendaTotalValorDesconto: list[i]['venda_total_valor_desconto'],
        vendaTotalValorAcrescimo: list[i]['venda_total_valor_acrescimo'],
        vendaTotalValorLiquido: list[i]['venda_total_valor_liquido'],
        vendaTotalValorCancelado: list[i]['venda_total_valor_cancelado'],
        vendaTotalValorDescontoItem: list[i]['venda_total_valor_desconto_item'],
        vendaTotalQuantidade: list[i]['venda_total_quantidade'],
        vendaTotalQuantidadeCancelada: list[i]['venda_total_quantidade_cancelada'],
        vendaTotalItem: list[i]['venda_total_item'],
        vendaTotalBoletoFechado: list[i]['venda_total_boleto_fechado'],
        vendaTotalBoletoPedido: list[i]['venda_total_boleto_pedido'],
        vendaTotalBoletoCancelado: list[i]['venda_total_boleto_cancelado'],
        devolucaoTotalValorBruto: list[i]['devolucao_total_valor_bruto'],
        devolucaoTotalValorDesconto: list[i]['devolucao_total_valor_desconto'],
        devolucaoTotalValorAcrescimo: list[i]['devolucao_total_valor_acrescimo'],
        devolucaoTotalValorLiquido: list[i]['devolucao_total_valor_liquido'],
        devolucaoTotalValorCancelado: list[i]['devolucao_total_valor_cancelado'],
        devolucaoTotalQuantidade: list[i]['devolucao_total_quantidade'],
        devolucaoTotalQuantidadeCancelada: list[i]['devolucao_total_quantidade_cancelada'],
        devolucaoTotalItem: list[i]['devolucao_total_item'],
        devolucaoTotalBoletoFechado: list[i]['devolucao_total_boleto_fechado'],
        devolucaoTotalBoletoCancelado: list[i]['devolucao_total_boleto_cancelado'],
        saidaTotalValorBruto: list[i]['saida_total_valor_bruto'],
        saidaTotalValorDesconto: list[i]['saida_total_valor_desconto'],
        saidaTotalValorAcrescimo: list[i]['saida_total_valor_acrescimo'],
        saidaTotalValorLiquido: list[i]['saida_total_valor_liquido'],
        saidaTotalValorCancelado: list[i]['saida_total_valor_cancelado'],
        saidaTotalQuantidade: list[i]['saida_total_quantidade'],
        saidaTotalQuantidadeCancelada: list[i]['saida_total_quantidade_cancelada'],
        saidaTotalItem: list[i]['saida_total_item'],
        saidaTotalBoletoFechado: list[i]['saida_total_boleto_fechado'],
        saidaTotalBoletoCancelado: list[i]['saida_total_boleto_cancelado'],
        entradaTotalValorBruto: list[i]['entrada_total_valor_bruto'],
        entradaTotalValorDesconto: list[i]['entrada_total_valor_desconto'],
        entradaTotalValorAcrescimo: list[i]['entrada_total_valor_acrescimo'],
        entradaTotalValorLiquido: list[i]['entrada_total_valor_liquido'],
        entradaTotalValorCancelado: list[i]['entrada_total_valor_cancelado'],
        entradaTotalQuantidade: list[i]['entrada_total_quantidade'],
        entradaTotalQuantidadeCancelada: list[i]['entrada_total_quantidade_cancelada'],
        entradaTotalItem: list[i]['entrada_total_item'],
        entradaTotalBoletoFechado: list[i]['entrada_total_boleto_fechado'],
        entradaTotalBoletoCancelado: list[i]['entrada_total_boleto_cancelado'],
        dataAtualizacao: DateTime.parse(list[i]['data_atualizacao']),
      );
    });

    if (preLoad) {
      for (MovimentoCaixa movimentoCaixa in movimentoCaixaList){
        MovimentoCaixaParcela movimentoCaixaParcela = MovimentoCaixaParcela();
        MovimentoCaixaParcelaDAO movimentoCaixaParcelaDAO = MovimentoCaixaParcelaDAO(_hasuraBloc, movimentoCaixaParcela, _appGlobalBloc);
        if (loadMovimentoCaixaParcela) {
          movimentoCaixaParcelaDAO.filterMovimentoCaixa = movimentoCaixa.idApp;
          movimentoCaixaParcelaDAO.loadTipoPagamento = true;
          List<MovimentoCaixaParcela> movimentoCaixaParcelaList = await movimentoCaixaParcelaDAO.getAll(preLoad: true);
          movimentoCaixa.movimentoCaixaParcela = movimentoCaixaParcelaList;
        }
        movimentoCaixaParcelaDAO = null;
      }
    }  
    return movimentoCaixaList;
  }

  @override
  Future<IEntity> getById(int id) async {
    movimentoCaixa = await dao.getById(this, id);
    return movimentoCaixa;
  }

  @override
  Future<IEntity> insert() async {
    this.movimentoCaixa.idApp = await dao.insert(this);
    return this.movimentoCaixa;
  }

  @override
  Future<IEntity> delete(int id) async {
    await dao.delete(this, id);
    return this.movimentoCaixa;
  }

  @override
  Map<String, dynamic> toMap() {
    return {
    'id_app': this.movimentoCaixa.idApp,
    'id': this.movimentoCaixa.id,
    'id_terminal': this.movimentoCaixa.idTerminal,
    'data_abertura': this.movimentoCaixa.dataAbertura.toString(),
    'data_fechamento': this.movimentoCaixa.dataFechamento != null ? this.movimentoCaixa.dataFechamento.toString() : null,
    'valor_abertura': this.movimentoCaixa.valorAbertura,
    'venda_total_valor_bruto': this.movimentoCaixa.vendaTotalValorBruto,
    'venda_total_valor_desconto': this.movimentoCaixa.vendaTotalValorDesconto,
    'venda_total_valor_acrescimo': this.movimentoCaixa.vendaTotalValorAcrescimo,
    'venda_total_valor_liquido': this.movimentoCaixa.vendaTotalValorLiquido,
    'venda_total_valor_cancelado': this.movimentoCaixa.vendaTotalValorCancelado,
    'venda_total_valor_desconto_item': this.movimentoCaixa.vendaTotalValorDescontoItem,
    'venda_total_quantidade': this.movimentoCaixa.vendaTotalQuantidade,
    'venda_total_quantidade_cancelada': this.movimentoCaixa.vendaTotalQuantidadeCancelada,
    'venda_total_item': this.movimentoCaixa.vendaTotalItem,
    'venda_total_boleto_fechado': this.movimentoCaixa.vendaTotalBoletoFechado,
    'venda_total_boleto_pedido': this.movimentoCaixa.vendaTotalBoletoPedido,
    'venda_total_boleto_cancelado': this.movimentoCaixa.vendaTotalBoletoCancelado,
    'devolucao_total_valor_bruto': this.movimentoCaixa.devolucaoTotalValorBruto,
    'devolucao_total_valor_desconto': this.movimentoCaixa.devolucaoTotalValorDesconto,
    'devolucao_total_valor_acrescimo': this.movimentoCaixa.devolucaoTotalValorAcrescimo,
    'devolucao_total_valor_liquido': this.movimentoCaixa.devolucaoTotalValorLiquido,
    'devolucao_total_valor_cancelado': this.movimentoCaixa.devolucaoTotalValorCancelado,
    'devolucao_total_quantidade': this.movimentoCaixa.devolucaoTotalQuantidade,
    'devolucao_total_quantidade_cancelada': this.movimentoCaixa.devolucaoTotalQuantidadeCancelada,
    'devolucao_total_item': this.movimentoCaixa.devolucaoTotalItem,
    'devolucao_total_boleto_fechado': this.movimentoCaixa.devolucaoTotalBoletoFechado,
    'devolucao_total_boleto_cancelado': this.movimentoCaixa.devolucaoTotalBoletoCancelado,
    'saida_total_valor_bruto': this.movimentoCaixa.saidaTotalValorBruto,
    'saida_total_valor_desconto': this.movimentoCaixa.saidaTotalValorDesconto,
    'saida_total_valor_acrescimo': this.movimentoCaixa.saidaTotalValorAcrescimo,
    'saida_total_valor_liquido': this.movimentoCaixa.saidaTotalValorLiquido,
    'saida_total_valor_cancelado': this.movimentoCaixa.saidaTotalValorCancelado,
    'saida_total_quantidade': this.movimentoCaixa.saidaTotalQuantidade,
    'saida_total_quantidade_cancelada': this.movimentoCaixa.saidaTotalQuantidadeCancelada,
    'saida_total_item': this.movimentoCaixa.saidaTotalItem,
    'saida_total_boleto_fechado': this.movimentoCaixa.saidaTotalBoletoFechado,
    'saida_total_boleto_cancelado': this.movimentoCaixa.saidaTotalBoletoCancelado,
    'entrada_total_valor_bruto': this.movimentoCaixa.entradaTotalValorBruto,
    'entrada_total_valor_desconto': this.movimentoCaixa.entradaTotalValorDesconto,
    'entrada_total_valor_acrescimo': this.movimentoCaixa.entradaTotalValorAcrescimo,
    'entrada_total_valor_liquido': this.movimentoCaixa.entradaTotalValorLiquido,
    'entrada_total_valor_cancelado': this.movimentoCaixa.entradaTotalValorCancelado,
    'entrada_total_quantidade': this.movimentoCaixa.entradaTotalQuantidade,
    'entrada_total_quantidade_cancelada': this.movimentoCaixa.entradaTotalQuantidadeCancelada,
    'entrada_total_item': this.movimentoCaixa.entradaTotalItem,
    'entrada_total_boleto_fechado': this.movimentoCaixa.entradaTotalBoletoFechado,
    'entrada_total_boleto_cancelado': this.movimentoCaixa.entradaTotalBoletoCancelado,
    'data_atualizacao': this.movimentoCaixa.dataAtualizacao.toString(),
    };
  }

  Future<List<Map<dynamic, dynamic>>> getVendaTotal(DateTime data) async {
    List<Map<dynamic, dynamic>> result = [];
    String query = "";
    query = """
      select  
        1 as sequencia, 'venda' as tipo_movimento,
        sum(m.valor_total_bruto) as valor_total_bruto,
        sum(m.valor_total_desconto) as valor_total_desconto,
        sum(m.valor_total_liquido) as valor_total_liquido,
        sum(m.valor_total_desconto_item) as valor_total_desconto_item,
        sum(m.total_itens) as total_itens,
        sum(m.total_quantidade) as total_quantidade,   
     	  count(m.id_app) as total_boleto
        from movimento m
        where 1 = 1 
        and date(m.data_movimento) = '${ourDate(data)}'
        and m.ehorcamento = 0
        and m.ehcancelado = 0
      
      union
      
      select
        2 as sequencia, 'pedido' as tipo_movimento,
        sum(m.valor_total_bruto) as valor_total_bruto,
        sum(m.valor_total_desconto) as valor_total_desconto,
        sum(m.valor_total_liquido) as valor_total_liquido,
        sum(m.valor_total_desconto_item) as valor_total_desconto_item,
        sum(m.total_itens) as total_itens,
        sum(m.total_quantidade) as total_quantidade,   
     	  count(m.id_app) as total_boleto
        from movimento m
        where 1 = 1 
        and date(m.data_movimento) = '${ourDate(data)}'
        and m.ehorcamento = 1
        and m.ehcancelado = 0	  
      
      union
      
      select
        3 as sequencia, 'venda cancelada' as tipo_movimento,
        sum(m.valor_total_bruto) as valor_total_bruto,
        sum(m.valor_total_desconto) as valor_total_desconto,
        sum(m.valor_total_liquido) as valor_total_liquido,
        sum(m.valor_total_desconto_item) as valor_total_desconto_item,
        sum(m.total_itens) as total_itens,
        sum(m.total_quantidade) as total_quantidade,   
     	  count(m.id_app) as total_boleto
        from movimento m
        where 1 = 1 
        and date(m.data_movimento) = '${ourDate(data)}'
        and m.ehorcamento = 0
        and m.ehcancelado = 1	  	  

      order by 1  
    """;
    result = await dao.getRawQuery(query);
    
    return result;  
  }

  Future<List<Map<dynamic, dynamic>>> getRawQuery(String query) async {
    List<Map<dynamic, dynamic>> result = [];
    result = await dao.getRawQuery(query);
    return result;  
  }

}

