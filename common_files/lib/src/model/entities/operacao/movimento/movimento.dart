import 'package:common_files/common_files.dart';

class Movimento implements IEntity {
  int _idApp;
  int _id;
  int _idPessoa;
  int _idCliente;
  int _idVendedor;
  int _idTransacao;
  int _idTerminal;
  int _ehorcamento;
  int _ehcancelado;
  int _ehsincronizado;
  int _ehfinalizado;
  double _valorRestante;
  double _valorTroco;
  double _valorTotalBruto;
  double _valorTotalDesconto;
  double _valorTotalLiquido;
  double _valorTotalBrutoProduto;
  double _valorTotalBrutoServico;
  double _valorTotalDescontoItemProduto;
  double _valorTotalDescontoItemServico;
  double _valorTotalLiquidoProduto;
  double _valorTotalLiquidoServico;
  int _totalItens;
  double _totalQuantidade;
  String _observacao;
  DateTime _dataMovimento;
  DateTime _dataFechamento;
  DateTime _dataAtualizacao;
  List<MovimentoItem> _movimentoItem; 
  List<MovimentoParcela> _movimentoParcela;
  Transacao _transacao;
  Terminal _terminal;
  Pessoa _vendedor;
  Pessoa _cliente;

  Movimento(
      {int idApp, 
      int id,
      int idPessoa = 0,
      int idCliente,
      int idVendedor,
      int idTransacao = 0,
      int idTerminal = 0,
      int ehorcamento = 1,
      int ehcancelado = 0,
      int ehsincronizado = 0,
      int ehfinalizado = 0,
      double valorRestante = 0,
      double valorTroco = 0,
      double valorTotalBruto = 0,
      double valorTotalDesconto = 0,
      double valorTotalLiquido = 0,
      double valorTotalBrutoProduto = 0,
      double valorTotalBrutoServico = 0,
      double valorTotalDescontoItemProduto = 0,
      double valorTotalDescontoItemServico = 0,
      double valorTotalLiquidoProduto = 0,
      double valorTotalLiquidoServico = 0,
      int totalItens = 0,
      double totalQuantidade = 0,
      String observacao = "",
      DateTime dataMovimento,
      DateTime dataFechamento,
      DateTime dataAtualizacao,
      List<MovimentoItem> movimentoItem,
      List<MovimentoParcela> movimentoParcela,
      Transacao transacao,
      Terminal terminal,
      Pessoa vendedor,
      Pessoa cliente}) {
    this._idApp = idApp;
    this._id = id;
    this._idPessoa = idPessoa;
    this._idCliente = idCliente;
    this._idVendedor = idVendedor;
    this._idTransacao = idTransacao;
    this._idTerminal = idTerminal;
    this._ehorcamento = ehorcamento;
    this._ehcancelado = ehcancelado;
    this._ehsincronizado = ehsincronizado;
    this._ehfinalizado = ehfinalizado;
    this._valorRestante = valorRestante;
    this._valorTroco = valorTroco;
    this._valorTotalBruto = valorTotalBruto;
    this._valorTotalDesconto = valorTotalDesconto;
    this._valorTotalLiquido = valorTotalLiquido;
    this._valorTotalBrutoProduto = valorTotalBrutoProduto;
    this._valorTotalBrutoServico = valorTotalBrutoServico;
    this._valorTotalDescontoItemProduto = valorTotalDescontoItemProduto;
    this._valorTotalDescontoItemServico = valorTotalDescontoItemServico;
    this._valorTotalLiquidoProduto = valorTotalLiquidoProduto;
    this._valorTotalLiquidoServico = valorTotalLiquidoServico;
    this._totalItens = totalItens;
    this._totalQuantidade = totalQuantidade;
    this._observacao = observacao;
    this._dataMovimento = dataMovimento != null ? dataMovimento : DateTime.now();
    this._dataFechamento = dataFechamento != null ? dataFechamento : DateTime.now();
    this._dataAtualizacao = dataAtualizacao != null ? dataAtualizacao : DateTime.now();
    this._movimentoItem = movimentoItem == null ? [] : movimentoItem;
    this._movimentoParcela = movimentoParcela == null ? [] : movimentoParcela;
    this._transacao = transacao == null ? Transacao() : transacao;
    this._terminal = terminal == null ? Terminal() : terminal;
    this._vendedor = vendedor == null ? Pessoa() : vendedor;
    this._cliente = cliente == null ? Pessoa() : cliente;
  }

  int get idApp => _idApp;
  set idApp(int idApp) => _idApp = idApp;
  int get id => _id;
  set id(int id) => _id = id;
  int get idPessoa => _idPessoa;
  set idPessoa(int idPessoa) => _idPessoa = idPessoa;
  int get idCliente => _idCliente;
  set idCliente(int idCliente) => _idCliente = idCliente;
  int get idVendedor => _idVendedor;
  set idVendedor(int idVendedor) => _idVendedor = idVendedor;
  int get idTransacao => _idTransacao;
  set idTransacao(int idTransacao) => _idTransacao = idTransacao;
  int get idTerminal => _idTerminal;
  set idTerminal(int idTerminal) => _idTerminal = idTerminal;
  int get ehorcamento => _ehorcamento;
  set ehorcamento(int ehorcamento) => _ehorcamento = ehorcamento;
  int get ehcancelado => _ehcancelado;
  set ehcancelado(int ehcancelado) => _ehcancelado = ehcancelado;
  int get ehsincronizado => _ehsincronizado;
  set ehsincronizado(int ehsincronizado) => _ehsincronizado = ehsincronizado;
  int get ehfinalizado => _ehfinalizado;
  set ehfinalizado(int ehfinalizado) => _ehfinalizado = ehfinalizado;
  double get valorRestante => _valorRestante;
  set valorRestante(double valorRestante) => _valorRestante = valorRestante;
  double get valorTroco => _valorTroco;
  set valorTroco(double valorTroco) => _valorTroco = valorTroco;
  double get valorTotalBruto => _valorTotalBruto;
  set valorTotalBruto(double valorTotalBruto) =>
      _valorTotalBruto = valorTotalBruto;
  double get valorTotalDesconto => _valorTotalDesconto;
  set valorTotalDesconto(double valorTotalDesconto) =>
      _valorTotalDesconto = valorTotalDesconto;
  double get valorTotalLiquido => _valorTotalLiquido;
  set valorTotalLiquido(double valorTotalLiquido) =>
      _valorTotalLiquido = valorTotalLiquido;
  double get valorTotalBrutoProduto => _valorTotalBrutoProduto;
  set valorTotalBrutoProduto(double valorTotalBrutoProduto) =>
      _valorTotalBrutoProduto = valorTotalBrutoProduto;
  double get valorTotalBrutoServico => _valorTotalBrutoServico;
  set valorTotalBrutoServico(double valorTotalBrutoServico) =>
      _valorTotalBrutoServico = valorTotalBrutoServico;
  double get valorTotalDescontoItemProduto => _valorTotalDescontoItemProduto;
  set valorTotalDescontoItemProduto(double valorTotalDescontoItemProduto) =>
      _valorTotalDescontoItemProduto = valorTotalDescontoItemProduto;
  double get valorTotalDescontoItemServico  => _valorTotalDescontoItemServico ;
  set valorTotalDescontoItemServico(double valorTotalDescontoItemServico ) =>
      _valorTotalDescontoItemServico  = valorTotalDescontoItemServico ;
  double get valorTotalLiquidoProduto => _valorTotalLiquidoProduto;
  set valorTotalLiquidoProduto(double valorTotalLiquidoProduto) =>
      _valorTotalLiquidoProduto = valorTotalLiquidoProduto;
  double get valorTotalLiquidoServico => _valorTotalLiquidoServico;
  set valorTotalLiquidoServico(double valorTotalLiquidoServico) =>
      _valorTotalLiquidoServico = valorTotalLiquidoServico;
  int get totalItens => _totalItens;
  set totalItens(int totalItens) => _totalItens = totalItens;
  double get totalQuantidade => _totalQuantidade;
  set totalQuantidade(double totalQuantidade) =>
      _totalQuantidade = totalQuantidade;
  String get observacao => _observacao;
  set observacao (String observacao) => _observacao = observacao;
  DateTime get dataMovimento => _dataMovimento;
  set dataMovimento(DateTime dataMovimento) => _dataMovimento = dataMovimento;
  DateTime get dataFechamento => _dataFechamento;
  set dataFechamento(DateTime dataFechamento) =>
      _dataFechamento = dataFechamento;
  DateTime get dataAtualizacao => _dataAtualizacao;
  set dataAtualizacao(DateTime dataAtualizacao) =>
      _dataAtualizacao = dataAtualizacao;
  List<MovimentoItem> get movimentoItem => _movimentoItem;
  set movimentoItem(List<MovimentoItem> movimentoItem) =>
      _movimentoItem = movimentoItem;
  List<MovimentoParcela> get movimentoParcela => _movimentoParcela;
  set movimentoParcela(List<MovimentoParcela> movimentoParcela) =>
      _movimentoParcela = movimentoParcela;
  Transacao get transacao => _transacao;
  set transacao(Transacao transacao) => 
      _transacao = transacao;

  Terminal get terminal => _terminal;
  set terminal(Terminal _terminal) => _terminal = terminal;

  Pessoa get vendedor => _vendedor;
  set vendedor(Pessoa _vendedor) => _vendedor = vendedor;

  Pessoa get cliente => _cliente;
  set cliente(Pessoa _cliente) => _cliente = cliente;

  String toString() {
    return '''
      idApp: ${_idApp.toString()},    
      id: ${_id.toString()},    
      idPessoa: ${_idPessoa.toString()},  
      idCliente: ${_idCliente.toString()},  
      idVendedor: ${_idVendedor.toString()},  
      idTransacao: ${_idTransacao.toString()},  
      idTerminal: ${_idTerminal.toString()},  
      ehorcamento: ${_ehorcamento.toString()},  
      ehcancelado: ${_ehcancelado.toString()},  
      ehsincronizado: ${_ehsincronizado.toString()},  
      ehfinalizado: ${_ehfinalizado.toString()},  
      valorRestante: ${_valorRestante.toString()},  
      valorTroco: ${_valorTroco.toString()},  
      valorTotalBruto: ${_valorTotalBruto.toString()},  
      valorTotalDesconto: ${_valorTotalDesconto.toString()},  
      valorTotalLiquido: ${_valorTotalLiquido.toString()},  
      valorTotalBrutoProduto: ${_valorTotalBrutoProduto.toString()},  
      valorTotalBrutoServico: ${_valorTotalBrutoServico.toString()},  
      valorTotalLiquidoProduto: ${_valorTotalLiquidoProduto.toString()},  
      valorTotalLiquidoServico: ${_valorTotalLiquidoServico.toString()},  
      totalItens: ${_totalItens.toString()},  
      totalQuantidade: ${_totalQuantidade.toString()},  
      observacao: $_observacao, 
      dataMovimento: ${_dataMovimento.toString()}, 
      dataFechamento: ${_dataFechamento.toString()}, 
      dataAtualizacao: ${_dataAtualizacao.toString()}
    ''';  
  }

   Movimento.fromJson(Map<String, dynamic> json) {
    _idApp = json['id_app'];
    _id = json['id'];
    _idPessoa = json['id_pessoa'];
    _idCliente = json['id_cliente'];
    _idVendedor = json['id_vendedor'];
    _idTransacao = json['id_tansacao'];
    _idTerminal = json['id_terminal'];
    _ehorcamento = json['ehorcamento'];
    _ehcancelado = json['ehcancelado'];
    _ehsincronizado = json['ehsincronizado'];
    _ehfinalizado = json['ehfinalizado'];
    _valorTotalBruto = json['valor_total_bruto'];
    _valorTotalDesconto = json['valor_total_desconto'];
    _valorTotalLiquido = json['valor_total_liquido'];
    _valorTroco = json['valor_troco'];
    _valorTotalBrutoProduto = json['valor_total_bruto_produto'];
    _valorTotalBrutoServico = json['valor_total_bruto_servico'];
    _valorTotalDescontoItemProduto = json['valor_total_desconto_item_produto'];
    _valorTotalDescontoItemServico = json['valor_total_desconto_item_servico'];
    _valorTotalLiquidoProduto = json['valor_total_liquido_produto'];
    _valorTotalLiquidoServico = json['valor_total_liquido_servico'];
    _totalItens = json['total_itens'];
    _totalQuantidade = json['total_quantidade'];
    _observacao = json['observacao'];
    _dataMovimento = DateTime.parse(json['data_movimento']);
    _dataFechamento = DateTime.parse(json['data_fechamento']);
    _dataAtualizacao = DateTime.parse(json['data_atualizacao']);
    if (json['movimento_item'] != null) {
      _movimentoItem = new List<MovimentoItem>();
      json['movimento_item'].forEach((v) {
        _movimentoItem.add(new MovimentoItem.fromJson(v));
      });
    }
    if (json['movimento_parcela'] != null) {
      _movimentoParcela = new List<MovimentoParcela>();
      json['movimento_parcela'].forEach((v) {
        _movimentoParcela.add(new MovimentoParcela.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id_app'] = this._idApp;
    data['id'] = this._id;
    data['id_pessoa'] = this._idPessoa;
    data['id_cliente'] = this._idCliente;
    data['id_vendedor'] = this._idVendedor;
    data['id_transacao'] = this._idTransacao;
    data['id_terminal'] = this._idTerminal;
    data['ehorcamento'] = this._ehorcamento;
    data['ehcancelado'] = this._ehcancelado;
    data['ehsincronizado'] = this._ehsincronizado;
    data['ehfinalizado'] = this._ehfinalizado;
    data['valor_total_bruto'] = this._valorTotalBruto;
    data['valor_total_desconto'] = this._valorTotalDesconto;
    data['valor_total_liquido'] = this._valorTotalLiquido;
    data['valor_troco'] = this._valorTroco;
    data['valor_total_bruto_produto'] = this._valorTotalBrutoProduto;
    data['valor_total_bruto_servico'] = this._valorTotalBrutoServico;
    data['valor_total_desconto_item_produto'] = this._valorTotalDescontoItemProduto;
    data['valor_total_desconto_item_servico'] = this._valorTotalDescontoItemServico;
    data['valor_total_liquido_produto'] = this._valorTotalLiquidoProduto;
    data['valor_total_liquido_servico'] = this._valorTotalLiquidoServico;
    data['total_itens'] = this._totalItens;
    data['observacao'] = this._observacao;
    data['total_quantidade'] = this._totalQuantidade;
    data['data_movimento'] = this._dataMovimento.toString();
    data['data_fechamento'] = this._dataFechamento.toString();
    data['data_atualizacao'] = this._dataAtualizacao.toString();
    if (this._movimentoItem != null) {
      data['movimento_item'] =
          this._movimentoItem.map((v) => v.toJson()).toList();
    }
    if (this._movimentoParcela != null) {
      data['movimento_parcela'] =
          this._movimentoParcela.map((v) => v.toJson()).toList();
    }
    return data;
  }

}
