import 'package:common_files/common_files.dart';

class MovimentoCaixaParcela implements IEntity {
  int _idApp ;
  int _id;
  int _idAppMovimentoCaixa;
  int _idMovimentoCaixa;
  int _idTipoPagamento;
  DateTime _data;
  String _descricao;
  double _valor;
  int _ehAbertura;
  int _ehReforco;
  int _ehRetirada;
  String _observacao;
  DateTime _dataCadastro;
  DateTime _dataAtualizacao;
  TipoPagamento _tipoPagamento;

  MovimentoCaixaParcela(
      {int idApp,
      int id,
      int idAppMovimentoCaixa,
      int idMovimentoCaixa,
      int idTipoPagamento,
      DateTime data,
      String descricao,
      double valor = 0,
      int ehAbertura = 0,
      int ehReforco = 0,
      int ehRetirada = 0,
      String observacao = "",
      DateTime dataCadastro,
      DateTime dataAtualizacao,
      TipoPagamento tipoPagamento}) {
    this._idApp = idApp;
    this._id = id;
    this._idAppMovimentoCaixa = idAppMovimentoCaixa;
    this._idMovimentoCaixa = idMovimentoCaixa;
    this._idTipoPagamento = idTipoPagamento;
    this._data = data;
    this._descricao = descricao;
    this._valor = valor;
    this._ehAbertura = ehAbertura;
    this._ehReforco = ehReforco;
    this._ehRetirada = ehRetirada;
    this._observacao = observacao;
    this._dataCadastro = dataCadastro == null ? DateTime.now() : dataCadastro;
    this._dataAtualizacao = dataAtualizacao == null ? DateTime.now() : dataAtualizacao;
    this._tipoPagamento = tipoPagamento == null ? TipoPagamento() : tipoPagamento;
}

  int get idApp => _idApp;
  set idApp(int idApp) => _idApp = idApp;
  int get id => _id;
  set id(int id) => _id = id;
  int get idAppMovimentoCaixa => _idAppMovimentoCaixa;
  set idAppMovimentoCaixa(int idAppMovimentoCaixa) =>
      _idAppMovimentoCaixa = idAppMovimentoCaixa;
  int get idMovimentoCaixa => _idMovimentoCaixa;
  set idMovimentoCaixa(int idMovimentoCaixa) =>
      _idMovimentoCaixa = idMovimentoCaixa;
  int get idTipoPagamento => _idTipoPagamento;
  set idTipoPagamento(int idTipoPagamento) =>
      _idTipoPagamento = idTipoPagamento;
  DateTime get data => _data;
  set data(DateTime data) => _data = data;
  String get descricao => _descricao;
  set descricao(String descricao) => _descricao = descricao;
  double get valor => _valor;
  set valor(double valor) => _valor = valor;
  int get ehAbertura => _ehAbertura;
  set ehAbertura(int ehAbertura) => _ehAbertura = ehAbertura;
  int get ehReforco => _ehReforco;
  set ehReforco(int ehReforco) => _ehReforco = ehReforco;
  int get ehRetirada => _ehRetirada;
  set ehRetirada(int ehRetirada) => _ehRetirada = ehRetirada;
  String get observacao => _observacao;
  set observacao(String observacao) => _observacao = observacao;
  DateTime get dataCadastro => _dataCadastro;
  set dataCadastro(DateTime dataCadastro) => _dataCadastro = dataCadastro;
  DateTime get dataAtualizacao => _dataAtualizacao;
  set dataAtualizacao(DateTime dataAtualizacao) =>
      _dataAtualizacao = dataAtualizacao;
  TipoPagamento get tipoPagamento => _tipoPagamento;
  set tipoPagamento(TipoPagamento tipoPagamento) =>
      _tipoPagamento = tipoPagamento;

  String toString() {
    return '''
      idApp: ${_idApp.toString()},    
      id: ${_id.toString()},    
      idAppMovimentoCaixa: ${_idAppMovimentoCaixa.toString()},  
      idMovimentoCaixa: ${_idMovimentoCaixa.toString()},  
      idTipoPagamento: ${_idTipoPagamento.toString()},  
      data: ${_data.toString()},  
      descricao: $_descricao, 
      valor: ${_valor.toString()}, 
      ehAbertura: ${_ehAbertura.toString()}, 
      ehReforco: ${_ehReforco.toString()}, 
      ehRetirada: ${_ehRetirada.toString()}, 
      observacao: $_observacao, 
      dataCadastro: ${_dataCadastro.toString()}, 
      dataAtualizacao: ${_dataAtualizacao.toString()}
    ''';  
  }

  MovimentoCaixaParcela.fromJson(Map<String, dynamic> json) {
    _idApp = json['id_app'];
    _id = json['id'];
    _idAppMovimentoCaixa = json['id_app_movimento_caixa'];
    _idMovimentoCaixa = json['id_movimento_caixa'];
    _idTipoPagamento = json['id_tipo_pagamento'];
    _data = DateTime.parse(json['data']);
    _descricao= json['descricao'];
    _valor = json['valor'];
    _ehAbertura = json['ehabertura'];
    _ehReforco = json['ehreforco'];
    _ehRetirada = json['ehretirada'];
    _observacao = json['observacao'];
    _dataCadastro = DateTime.parse(json['data_cadastro']);
    _dataAtualizacao = DateTime.parse(json['data_atualizacao']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id_app'] = this._idApp;
    data['id'] = this._id;
    data['id_app_movimento_caixa'] = this._idAppMovimentoCaixa;
    data['id_movimento_caixa'] = this._idMovimentoCaixa;
    data['id_tipo_pagamento'] = this._idTipoPagamento;
    data['data'] = this._data.toString();
    data['descricao'] = this._descricao;
    data['valor'] = this._valor.toDouble();
    data['ehabertura'] = this._ehAbertura;
    data['ehreforco'] = this._ehReforco;
    data['ehretirada'] = this._ehRetirada;
    data['observacao'] = this._observacao;
    data['data_cadastro'] = this._dataCadastro.toString();
    data['data_atualizacao'] = this._dataAtualizacao.toString();
    return data;
  }
}
