import '../../interfaces.dart';

class MovimentoCaixa implements IEntity {
  int _idApp;
  int _id;
  int _idTerminal;
  DateTime _dataAbertura;
  DateTime _dataFechamento;
  double _valorAbertura;
  double _vendaTotalValorBruto;
  double _vendaTotalValorDesconto;
  double _vendaTotalValorAcrescimo;
  double _vendaTotalValorLiquido;
  double _vendaTotalValorCancelado;
  double _vendaTotalValorDescontoItem;
  double _vendaTotalQuantidade;
  double _vendaTotalQuantidadeCancelada;
  int _vendaTotalItem;
  int _vendaTotalBoletoFechado;
  int _vendaTotalBoletoPedido;
  int _vendaTotalBoletoCancelado;
  double _devolucaoTotalValorBruto;
  double _devolucaoTotalValorDesconto;
  double _devolucaoTotalValorAcrescimo;
  double _devolucaoTotalValorLiquido;
  double _devolucaoTotalValorCancelado;
  double _devolucaoTotalQuantidade;
  double _devolucaoTotalQuantidadeCancelada;
  int _devolucaoTotalItem;
  int _devolucaoTotalBoletoFechado;
  int _devolucaoTotalBoletoCancelado;
  double _saidaTotalValorBruto;
  double _saidaTotalValorDesconto;
  double _saidaTotalValorAcrescimo;
  double _saidaTotalValorLiquido;
  double _saidaTotalValorCancelado;
  double _saidaTotalQuantidade;
  double _saidaTotalQuantidadeCancelada;
  int _saidaTotalItem;
  int _saidaTotalBoletoFechado;
  int _saidaTotalBoletoCancelado;
  double _entradaTotalValorBruto;
  double _entradaTotalValorDesconto;
  double _entradaTotalValorAcrescimo;
  double _entradaTotalValorLiquido;
  double _entradaTotalValorCancelado;
  double _entradaTotalQuantidade;
  double _entradaTotalQuantidadeCancelada;
  int _entradaTotalItem;
  int _entradaTotalBoletoFechado;
  int _entradaTotalBoletoCancelado;
  DateTime _dataAtualizacao;

  MovimentoCaixa(
      {int idApp,
      int id,
      int idTerminal,
      DateTime dataAbertura,
      DateTime dataFechamento,
      double valorAbertura,
      double vendaTotalValorBruto,
      double vendaTotalValorDesconto,
      double vendaTotalValorAcrescimo,
      double vendaTotalValorLiquido,
      double vendaTotalValorCancelado,
      double vendaTotalValorDescontoItem,
      double vendaTotalQuantidade,
      double vendaTotalQuantidadeCancelada,
      int vendaTotalItem,
      int vendaTotalBoletoFechado,
      int vendaTotalBoletoPedido,
      int vendaTotalBoletoCancelado,
      double devolucaoTotalValorBruto,
      double devolucaoTotalValorDesconto,
      double devolucaoTotalValorAcrescimo,
      double devolucaoTotalValorLiquido,
      double devolucaoTotalValorCancelado,
      double devolucaoTotalQuantidade,
      double devolucaoTotalQuantidadeCancelada,
      int devolucaoTotalItem,
      int devolucaoTotalBoletoFechado,
      int devolucaoTotalBoletoCancelado,
      double saidaTotalValorBruto,
      double saidaTotalValorDesconto,
      double saidaTotalValorAcrescimo,
      double saidaTotalValorLiquido,
      double saidaTotalValorCancelado,
      double saidaTotalQuantidade,
      double saidaTotalQuantidadeCancelada,
      int saidaTotalItem,
      int saidaTotalBoletoFechado,
      int saidaTotalBoletoCancelado,
      double entradaTotalValorBruto,
      double entradaTotalValorDesconto,
      double entradaTotalValorAcrescimo,
      double entradaTotalValorLiquido,
      double entradaTotalValorCancelado,
      double entradaTotalQuantidade,
      double entradaTotalQuantidadeCancelada,
      int entradaTotalItem,
      int entradaTotalBoletoFechado,
      int entradaTotalBoletoCancelado,
      DateTime dataAtualizacao}) {
    this._idApp = idApp;
    this._id = id;
    this._idTerminal = idTerminal;
    this._dataAbertura = dataAbertura;
    this._dataFechamento = dataFechamento;
    this._valorAbertura = valorAbertura;
    this._vendaTotalValorBruto = vendaTotalValorBruto;
    this._vendaTotalValorDesconto = vendaTotalValorDesconto;
    this._vendaTotalValorAcrescimo = vendaTotalValorAcrescimo;
    this._vendaTotalValorLiquido = vendaTotalValorLiquido;
    this._vendaTotalValorCancelado = vendaTotalValorCancelado;
    this._vendaTotalValorDescontoItem = vendaTotalValorDescontoItem;
    this._vendaTotalQuantidade = vendaTotalQuantidade;
    this._vendaTotalQuantidadeCancelada = vendaTotalQuantidadeCancelada;
    this._vendaTotalItem = vendaTotalItem;
    this._vendaTotalBoletoFechado = vendaTotalBoletoFechado;
    this._vendaTotalBoletoPedido = vendaTotalBoletoPedido;
    this._vendaTotalBoletoCancelado = vendaTotalBoletoCancelado;
    this._devolucaoTotalValorBruto = devolucaoTotalValorBruto;
    this._devolucaoTotalValorDesconto = devolucaoTotalValorDesconto;
    this._devolucaoTotalValorAcrescimo = devolucaoTotalValorAcrescimo;
    this._devolucaoTotalValorLiquido = devolucaoTotalValorLiquido;
    this._devolucaoTotalValorCancelado = devolucaoTotalValorCancelado;
    this._devolucaoTotalQuantidade = devolucaoTotalQuantidade;
    this._devolucaoTotalQuantidadeCancelada = devolucaoTotalQuantidadeCancelada;
    this._devolucaoTotalItem = devolucaoTotalItem;
    this._devolucaoTotalBoletoFechado = devolucaoTotalBoletoFechado;
    this._devolucaoTotalBoletoCancelado = devolucaoTotalBoletoCancelado;
    this._saidaTotalValorBruto = saidaTotalValorBruto;
    this._saidaTotalValorDesconto = saidaTotalValorDesconto;
    this._saidaTotalValorAcrescimo = saidaTotalValorAcrescimo;
    this._saidaTotalValorLiquido = saidaTotalValorLiquido;
    this._saidaTotalValorCancelado = saidaTotalValorCancelado;
    this._saidaTotalQuantidade = saidaTotalQuantidade;
    this._saidaTotalQuantidadeCancelada = saidaTotalQuantidadeCancelada;
    this._saidaTotalItem = saidaTotalItem;
    this._saidaTotalBoletoFechado = saidaTotalBoletoFechado;
    this._saidaTotalBoletoCancelado = saidaTotalBoletoCancelado;
    this._entradaTotalValorBruto = entradaTotalValorBruto;
    this._entradaTotalValorDesconto = entradaTotalValorDesconto;
    this._entradaTotalValorAcrescimo = entradaTotalValorAcrescimo;
    this._entradaTotalValorLiquido = entradaTotalValorLiquido;
    this._entradaTotalValorCancelado = entradaTotalValorCancelado;
    this._entradaTotalQuantidade = entradaTotalQuantidade;
    this._entradaTotalQuantidadeCancelada = entradaTotalQuantidadeCancelada;
    this._entradaTotalItem = entradaTotalItem;
    this._entradaTotalBoletoFechado = entradaTotalBoletoFechado;
    this._entradaTotalBoletoCancelado = entradaTotalBoletoCancelado;
    this._dataAtualizacao = dataAtualizacao == null ? DateTime.now(): dataAtualizacao;
  }

  int get idApp => _idApp;
  set idApp(int idApp) => _idApp = idApp;
  int get id => _id;
  set id(int id) => _id = id;
  int get idTerminal => _idTerminal;
  set idTerminal(int idTerminal) => _idTerminal = idTerminal;
  DateTime get dataAbertura => _dataAbertura;
  set dataAbertura(DateTime dataAbertura) => _dataAbertura = dataAbertura;
  DateTime get dataFechamento => _dataFechamento;
  set dataFechamento(DateTime dataFechamento) => _dataFechamento = dataFechamento;
  double get valorAbertura => _valorAbertura;
  set valorAbertura(double valorAbertura) => _valorAbertura = valorAbertura;
  double get vendaTotalValorBruto => _vendaTotalValorBruto;
  set vendaTotalValorBruto(double vendaTotalValorBruto) =>
      _vendaTotalValorBruto = vendaTotalValorBruto;
  double get vendaTotalValorDesconto => _vendaTotalValorDesconto;
  set vendaTotalValorDesconto(double vendaTotalValorDesconto) =>
      _vendaTotalValorDesconto = vendaTotalValorDesconto;
  double get vendaTotalValorAcrescimo => _vendaTotalValorAcrescimo;
  set vendaTotalValorAcrescimo(double vendaTotalValorAcrescimo) =>
      _vendaTotalValorAcrescimo = vendaTotalValorAcrescimo;
  double get vendaTotalValorLiquido => _vendaTotalValorLiquido;
  set vendaTotalValorLiquido(double vendaTotalValorLiquido) =>
      _vendaTotalValorLiquido = vendaTotalValorLiquido;
  double get vendaTotalValorCancelado => _vendaTotalValorCancelado;
  set vendaTotalValorCancelado(double vendaTotalValorCancelado) =>
      _vendaTotalValorCancelado = vendaTotalValorCancelado;
  double get vendaTotalValorDescontoItem => _vendaTotalValorDescontoItem;
  set vendaTotalValorDescontoItem(double vendaTotalValorDescontoItem) =>
      _vendaTotalValorDescontoItem = vendaTotalValorDescontoItem;
  double get vendaTotalQuantidade => _vendaTotalQuantidade;
  set vendaTotalQuantidade(double vendaTotalQuantidade) =>
      _vendaTotalQuantidade = vendaTotalQuantidade;
  double get vendaTotalQuantidadeCancelada => _vendaTotalQuantidadeCancelada;
  set vendaTotalQuantidadeCancelada(double vendaTotalQuantidadeCancelada) =>
      _vendaTotalQuantidadeCancelada = vendaTotalQuantidadeCancelada;
  int get vendaTotalItem => _vendaTotalItem;
  set vendaTotalItem(int vendaTotalItem) => _vendaTotalItem = vendaTotalItem;
  int get vendaTotalBoletoFechado => _vendaTotalBoletoFechado;
  set vendaTotalBoletoFechado(int vendaTotalBoletoFechado) =>
      _vendaTotalBoletoFechado = vendaTotalBoletoFechado;
  int get vendaTotalBoletoPedido => _vendaTotalBoletoPedido;
  set vendaTotalBoletoPedido(int vendaTotalBoletoPedido) =>
      _vendaTotalBoletoPedido = vendaTotalBoletoPedido;
  int get vendaTotalBoletoCancelado => _vendaTotalBoletoCancelado;
  set vendaTotalBoletoCancelado(int vendaTotalBoletoCancelado) =>
      _vendaTotalBoletoCancelado = vendaTotalBoletoCancelado;
  double get devolucaoTotalValorBruto => _devolucaoTotalValorBruto;
  set devolucaoTotalValorBruto(double devolucaoTotalValorBruto) =>
      _devolucaoTotalValorBruto = devolucaoTotalValorBruto;
  double get devolucaoTotalValorDesconto => _devolucaoTotalValorDesconto;
  set devolucaoTotalValorDesconto(double devolucaoTotalValorDesconto) =>
      _devolucaoTotalValorDesconto = devolucaoTotalValorDesconto;
  double get devolucaoTotalValorAcrescimo => _devolucaoTotalValorAcrescimo;
  set devolucaoTotalValorAcrescimo(double devolucaoTotalValorAcrescimo) =>
      _devolucaoTotalValorAcrescimo = devolucaoTotalValorAcrescimo;
  double get devolucaoTotalValorLiquido => _devolucaoTotalValorLiquido;
  set devolucaoTotalValorLiquido(double devolucaoTotalValorLiquido) =>
      _devolucaoTotalValorLiquido = devolucaoTotalValorLiquido;
  double get devolucaoTotalValorCancelado => _devolucaoTotalValorCancelado;
  set devolucaoTotalValorCancelado(double devolucaoTotalValorCancelado) =>
      _devolucaoTotalValorCancelado = devolucaoTotalValorCancelado;
  double get devolucaoTotalQuantidade => _devolucaoTotalQuantidade;
  set devolucaoTotalQuantidade(double devolucaoTotalQuantidade) =>
      _devolucaoTotalQuantidade = devolucaoTotalQuantidade;
  double get devolucaoTotalQuantidadeCancelada =>
      _devolucaoTotalQuantidadeCancelada;
  set devolucaoTotalQuantidadeCancelada(
          double devolucaoTotalQuantidadeCancelada) =>
      _devolucaoTotalQuantidadeCancelada = devolucaoTotalQuantidadeCancelada;
  int get devolucaoTotalItem => _devolucaoTotalItem;
  set devolucaoTotalItem(int devolucaoTotalItem) =>
      _devolucaoTotalItem = devolucaoTotalItem;
  int get devolucaoTotalBoletoFechado => _devolucaoTotalBoletoFechado;
  set devolucaoTotalBoletoFechado(int devolucaoTotalBoletoFechado) =>
      _devolucaoTotalBoletoFechado = devolucaoTotalBoletoFechado;
  int get devolucaoTotalBoletoCancelado => _devolucaoTotalBoletoCancelado;
  set devolucaoTotalBoletoCancelado(int devolucaoTotalBoletoCancelado) =>
      _devolucaoTotalBoletoCancelado = devolucaoTotalBoletoCancelado;
  double get saidaTotalValorBruto => _saidaTotalValorBruto;
  set saidaTotalValorBruto(double saidaTotalValorBruto) =>
      _saidaTotalValorBruto = saidaTotalValorBruto;
  double get saidaTotalValorDesconto => _saidaTotalValorDesconto;
  set saidaTotalValorDesconto(double saidaTotalValorDesconto) =>
      _saidaTotalValorDesconto = saidaTotalValorDesconto;
  double get saidaTotalValorAcrescimo => _saidaTotalValorAcrescimo;
  set saidaTotalValorAcrescimo(double saidaTotalValorAcrescimo) =>
      _saidaTotalValorAcrescimo = saidaTotalValorAcrescimo;
  double get saidaTotalValorLiquido => _saidaTotalValorLiquido;
  set saidaTotalValorLiquido(double saidaTotalValorLiquido) =>
      _saidaTotalValorLiquido = saidaTotalValorLiquido;
  double get saidaTotalValorCancelado => _saidaTotalValorCancelado;
  set saidaTotalValorCancelado(double saidaTotalValorCancelado) =>
      _saidaTotalValorCancelado = saidaTotalValorCancelado;
  double get saidaTotalQuantidade => _saidaTotalQuantidade;
  set saidaTotalQuantidade(double saidaTotalQuantidade) =>
      _saidaTotalQuantidade = saidaTotalQuantidade;
  double get saidaTotalQuantidadeCancelada => _saidaTotalQuantidadeCancelada;
  set saidaTotalQuantidadeCancelada(double saidaTotalQuantidadeCancelada) =>
      _saidaTotalQuantidadeCancelada = saidaTotalQuantidadeCancelada;
  int get saidaTotalItem => _saidaTotalItem;
  set saidaTotalItem(int saidaTotalItem) => _saidaTotalItem = saidaTotalItem;
  int get saidaTotalBoletoFechado => _saidaTotalBoletoFechado;
  set saidaTotalBoletoFechado(int saidaTotalBoletoFechado) =>
      _saidaTotalBoletoFechado = saidaTotalBoletoFechado;
  int get saidaTotalBoletoCancelado => _saidaTotalBoletoCancelado;
  set saidaTotalBoletoCancelado(int saidaTotalBoletoCancelado) =>
      _saidaTotalBoletoCancelado = saidaTotalBoletoCancelado;
  double get entradaTotalValorBruto => _entradaTotalValorBruto;
  set entradaTotalValorBruto(double entradaTotalValorBruto) =>
      _entradaTotalValorBruto = entradaTotalValorBruto;
  double get entradaTotalValorDesconto => _entradaTotalValorDesconto;
  set entradaTotalValorDesconto(double entradaTotalValorDesconto) =>
      _entradaTotalValorDesconto = entradaTotalValorDesconto;
  double get entradaTotalValorAcrescimo => _entradaTotalValorAcrescimo;
  set entradaTotalValorAcrescimo(double entradaTotalValorAcrescimo) =>
      _entradaTotalValorAcrescimo = entradaTotalValorAcrescimo;
  double get entradaTotalValorLiquido => _entradaTotalValorLiquido;
  set entradaTotalValorLiquido(double entradaTotalValorLiquido) =>
      _entradaTotalValorLiquido = entradaTotalValorLiquido;
  double get entradaTotalValorCancelado => _entradaTotalValorCancelado;
  set entradaTotalValorCancelado(double entradaTotalValorCancelado) =>
      _entradaTotalValorCancelado = entradaTotalValorCancelado;
  double get entradaTotalQuantidade => _entradaTotalQuantidade;
  set entradaTotalQuantidade(double entradaTotalQuantidade) =>
      _entradaTotalQuantidade = entradaTotalQuantidade;
  double get entradaTotalQuantidadeCancelada => _entradaTotalQuantidadeCancelada;
  set entradaTotalQuantidadeCancelada(double entradaTotalQuantidadeCancelada) =>
      _entradaTotalQuantidadeCancelada = entradaTotalQuantidadeCancelada;
  int get entradaTotalItem => _entradaTotalItem;
  set entradaTotalItem(int entradaTotalItem) =>
      _entradaTotalItem = entradaTotalItem;
  int get entradaTotalBoletoFechado => _entradaTotalBoletoFechado;
  set entradaTotalBoletoFechado(int entradaTotalBoletoFechado) =>
      _entradaTotalBoletoFechado = entradaTotalBoletoFechado;
  int get entradaTotalBoletoCancelado => _entradaTotalBoletoCancelado;
  set entradaTotalBoletoCancelado(int entradaTotalBoletoCancelado) =>
      _entradaTotalBoletoCancelado = entradaTotalBoletoCancelado;
  DateTime get dataAtualizacao => _dataAtualizacao;
  set dataAtualizacao(DateTime dataAtualizacao) =>
      _dataAtualizacao = dataAtualizacao;

  MovimentoCaixa.fromJson(Map<String, dynamic> json) {
    _idApp = json['id_app'];
    _id = json['id'];
    _idTerminal = json['id_terminal'];
    _dataAbertura = DateTime.parse(json['data_abertura']);
    _dataFechamento = DateTime.parse(json['data_fechamento']);
    _valorAbertura = json['valor_abertura'];
    _vendaTotalValorBruto = json['venda_total_valor_bruto'];
    _vendaTotalValorDesconto = json['venda_total_valor_desconto'];
    _vendaTotalValorAcrescimo = json['venda_total_valor_acrescimo'];
    _vendaTotalValorLiquido = json['venda_total_valor_liquido'];
    _vendaTotalValorCancelado = json['venda_total_valor_cancelado'];
    _vendaTotalValorDescontoItem = json['venda_total_valor_desconto_item'];
    _vendaTotalQuantidade = json['venda_total_quantidade'];
    _vendaTotalQuantidadeCancelada = json['venda_total_quantidade_cancelada'];
    _vendaTotalItem = json['venda_total_item'];
    _vendaTotalBoletoFechado = json['venda_total_boleto_fechado'];
    _vendaTotalBoletoPedido = json['venda_total_boleto_pedido'];
    _vendaTotalBoletoCancelado = json['venda_total_boleto_cancelado'];
    _devolucaoTotalValorBruto = json['devolucao_total_valor_bruto'];
    _devolucaoTotalValorDesconto = json['devolucao_total_valor_desconto'];
    _devolucaoTotalValorAcrescimo = json['devolucao_total_valor_acrescimo'];
    _devolucaoTotalValorLiquido = json['devolucao_total_valor_liquido'];
    _devolucaoTotalValorCancelado = json['devolucao_total_valor_cancelado'];
    _devolucaoTotalQuantidade = json['devolucao_total_quantidade'];
    _devolucaoTotalQuantidadeCancelada = json['devolucao_total_quantidade_cancelada'];
    _devolucaoTotalItem = json['devolucao_total_item'];
    _devolucaoTotalBoletoFechado = json['devolucao_total_boleto_fechado'];
    _devolucaoTotalBoletoCancelado = json['devolucao_total_boleto_cancelado'];
    _saidaTotalValorBruto = json['saida_total_valor_bruto'];
    _saidaTotalValorDesconto = json['saida_total_valor_desconto'];
    _saidaTotalValorAcrescimo = json['saida_total_valor_acrescimo'];
    _saidaTotalValorLiquido = json['saida_total_valor_liquido'];
    _saidaTotalValorCancelado = json['saida_total_valor_cancelado'];
    _saidaTotalQuantidade = json['saida_total_quantidade'];
    _saidaTotalQuantidadeCancelada = json['saida_total_quantidade_cancelada'];
    _saidaTotalItem = json['saida_total_item'];
    _saidaTotalBoletoFechado = json['saida_total_boleto_fechado'];
    _saidaTotalBoletoCancelado = json['saida_total_boleto_cancelado'];
    _entradaTotalValorBruto = json['entrada_total_valor_bruto'];
    _entradaTotalValorDesconto = json['entrada_total_valor_desconto'];
    _entradaTotalValorAcrescimo = json['entrada_total_valor_acrescimo'];
    _entradaTotalValorLiquido = json['entrada_total_valor_liquido'];
    _entradaTotalValorCancelado = json['entrada_total_valor_cancelado'];
    _entradaTotalQuantidade = json['entrada_total_quantidade'];
    _entradaTotalQuantidadeCancelada = json['entrada_total_quantidade_cancelada'];
    _entradaTotalItem = json['entrada_total_item'];
    _entradaTotalBoletoFechado = json['entrada_total_boleto_fechado'];
    _entradaTotalBoletoCancelado = json['entrada_total_boleto_cancelado'];
    _dataAtualizacao = DateTime.parse(json['data_atualizacao']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id_app'] = this._idApp;
    data['id'] = this._id;
    data['id_terminal'] = this._idTerminal;
    data['data_abertura'] = this._dataAbertura.toString();
    data['data_fechamento'] = this._dataFechamento.toString();
    data['valor_abertura'] = this._valorAbertura.toDouble();
    data['venda_total_valor_bruto'] = this._vendaTotalValorBruto.toDouble();
    data['venda_total_valor_desconto'] = this._vendaTotalValorDesconto.toDouble();
    data['venda_total_valor_acrescimo'] = this._vendaTotalValorAcrescimo.toDouble();
    data['venda_total_valor_liquido'] = this._vendaTotalValorLiquido.toDouble();
    data['venda_total_valor_cancelado'] = this._vendaTotalValorCancelado.toDouble();
    data['venda_total_valor_desconto_item'] = this._vendaTotalValorDescontoItem.toDouble();
    data['venda_total_quantidade'] = this._vendaTotalQuantidade.toDouble();
    data['venda_total_quantidade_cancelada'] = this._vendaTotalQuantidadeCancelada.toDouble();
    data['venda_total_item'] = this._vendaTotalItem;
    data['venda_total_boleto_fechado'] = this._vendaTotalBoletoFechado;
    data['venda_total_boleto_pedido'] = this._vendaTotalBoletoPedido;
    data['venda_total_boleto_cancelado'] = this._vendaTotalBoletoCancelado;
    data['devolucao_total_valor_bruto'] = this._devolucaoTotalValorBruto.toDouble();
    data['devolucao_total_valor_desconto'] = this._devolucaoTotalValorDesconto.toDouble();
    data['devolucao_total_valor_acrescimo'] = this._devolucaoTotalValorAcrescimo.toDouble();
    data['devolucao_total_valor_liquido'] = this._devolucaoTotalValorLiquido.toDouble();
    data['devolucao_total_valor_cancelado'] = this._devolucaoTotalValorCancelado.toDouble();
    data['devolucao_total_quantidade'] = this._devolucaoTotalQuantidade.toDouble();
    data['devolucao_total_quantidade_cancelada'] = this._devolucaoTotalQuantidadeCancelada.toDouble();
    data['devolucao_total_item'] = this._devolucaoTotalItem;
    data['devolucao_total_boleto_fechado'] = this._devolucaoTotalBoletoFechado;
    data['devolucao_total_boleto_cancelado'] = this._devolucaoTotalBoletoCancelado;
    data['saida_total_valor_bruto'] = this._saidaTotalValorBruto.toDouble();
    data['saida_total_valor_desconto'] = this._saidaTotalValorDesconto.toDouble();
    data['saida_total_valor_acrescimo'] = this._saidaTotalValorAcrescimo.toDouble();
    data['saida_total_valor_liquido'] = this._saidaTotalValorLiquido.toDouble();
    data['saida_total_valor_cancelado'] = this._saidaTotalValorCancelado.toDouble();
    data['saida_total_quantidade'] = this._saidaTotalQuantidade.toDouble();
    data['saida_total_quantidade_cancelada'] = this._saidaTotalQuantidadeCancelada.toDouble();
    data['saida_total_item'] = this._saidaTotalItem;
    data['saida_total_boleto_fechado'] = this._saidaTotalBoletoFechado;
    data['saida_total_boleto_cancelado'] = this._saidaTotalBoletoCancelado;
    data['entrada_total_valor_bruto'] = this._entradaTotalValorBruto.toDouble();
    data['entrada_total_valor_desconto'] = this._entradaTotalValorDesconto.toDouble();
    data['entrada_total_valor_acrescimo'] = this._entradaTotalValorAcrescimo.toDouble();
    data['entrada_total_valor_liquido'] = this._entradaTotalValorLiquido.toDouble();
    data['entrada_total_valor_cancelado'] = this._entradaTotalValorCancelado.toDouble();
    data['entrada_total_quantidade'] = this._entradaTotalQuantidade.toDouble();
    data['entrada_total_quantidade_cancelada'] = this._entradaTotalQuantidadeCancelada.toDouble();
    data['entrada_total_item'] = this._entradaTotalItem;
    data['entrada_total_boleto_fechado'] = this._entradaTotalBoletoFechado;
    data['entrada_total_boleto_cancelado'] = this._entradaTotalBoletoCancelado;
    data['data_atualizacao'] = this._dataAtualizacao.toString();
    return data;
  }
}
