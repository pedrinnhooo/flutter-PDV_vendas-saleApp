import 'package:common_files/common_files.dart';

class MovimentoCliente implements IEntity {
  int _idApp;
  int _id;
  int _idPessoa;
  int _idCliente;
  int _idAppMovimento;
  int _idMovimento;
  int _idTipoPagamento;
  DateTime _data;
  double _valor;
  String _descricao;
  String _observacao;
  double _saldo;
  DateTime _dataCadastro;
  DateTime _dataAtualizacao;

  MovimentoCliente(
      {int idApp,
      int id,
      int idPessoa,
      int idCliente,
      int idAppMovimento,
      int idMovimento,
      int idTipoPagamento,
      DateTime data,
      double valor,
      String descricao,
      String observacao,
      double saldo,
      DateTime dataCadastro,
      DateTime dataAtualizacao}) {
    this._idApp = idApp;
    this._id = id;
    this._idPessoa = idPessoa;
    this._idCliente = idCliente;
    this._idAppMovimento = idAppMovimento;
    this._idMovimento = idMovimento;
    this._idTipoPagamento = idTipoPagamento;
    this._data = data;
    this._valor = valor;
    this._descricao = descricao;
    this._observacao = observacao;
    this._saldo = saldo;
    this._dataCadastro = dataCadastro == null ? DateTime.now() : dataCadastro;
    this._dataAtualizacao = dataAtualizacao == null ? DateTime.now() : dataAtualizacao;
  }

  int get idApp => _idApp;
  set idApp(int idApp) => _idApp = idApp;
  int get id => _id;
  set id(int id) => _id = id;
  int get idPessoa => _idPessoa;
  set idPessoa(int idPessoa) =>
      _idPessoa = idPessoa;
  int get idCliente => _idCliente;
  set idCliente(int idCliente) =>
      _idCliente = idCliente;
  int get idAppMovimento => _idAppMovimento;
  set idAppMovimento(int idAppMovimento) => _idAppMovimento = idAppMovimento;
  int get idMovimento => _idMovimento;
  set idMovimento(int idMovimento) => _idMovimento = idMovimento;
  int get idTipoPagamento => _idTipoPagamento;
  set idTipoPagamento(int idTipoPagamento) =>
      _idTipoPagamento = idTipoPagamento;
  DateTime get data => _data;
  set data(DateTime data) => _data = data;
  double get valor => _valor;
  set valor(double valor) => _valor = valor;
  String get descricao => _descricao;
  set descricao(String descricao) => _descricao = descricao;
  String get observacao => _observacao;
  set observacao(String observacao) => _observacao = observacao;
  double get saldo => _saldo;
  set saldo(double saldo) => _saldo = saldo;
  DateTime get dataCadastro => _dataCadastro;
  set dataCadastro(DateTime dataCadastro) => _dataCadastro = dataCadastro;
  DateTime get dataAtualizacao => _dataAtualizacao;
  set dataAtualizacao(DateTime dataAtualizacao) =>
      _dataAtualizacao = dataAtualizacao;

  String toString() {
    return '''
      idApp: ${_idApp.toString()},    
      id: ${_id.toString()},    
      idPessoa: ${_idPessoa.toString()},  
      idCliente: ${_idCliente.toString()},  
      idAppMovimento: ${_idAppMovimento.toString()},  
      idMovimento: ${_idMovimento.toString()},  
      idTipoPagamento: ${_idTipoPagamento.toString()},  
      data: ${_data.toString()},  
      valor: ${_valor.toString()},  
      descricao: $_descricao, 
      observacao: $_observacao, 
      saldo: ${_saldo.toString()}, 
      dataCadastro: ${_dataCadastro.toString()}, 
      dataAtualizacao: ${_dataAtualizacao.toString()}
    ''';  
  }

  MovimentoCliente.fromJson(Map<String, dynamic> json) {
    _idApp = json['id_app'];
    _id = json['id'];
    _idPessoa = json['id_pessoa'];
    _idCliente = json['id_cliente'];
    _idAppMovimento = json['id_app_movimento'];
    _idMovimento = json['id_movimento'];
    _idTipoPagamento = json['id_tipo_pagamento'];
    _data = DateTime.parse(json['data']);
    _valor = json['valor'];
    _descricao = json['descricao'];
    _observacao = json['observacao'];
    _saldo = json['saldo'];
    _dataCadastro = DateTime.parse(json['data_cadastro']);
    _dataAtualizacao = DateTime.parse(json['data_atualizacao']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id_app'] = this._idApp;
    data['id'] = this._id;
    data['id_pessoa'] = this._idPessoa;
    data['id_cliente'] = this._idCliente;
    data['id_app_movimento'] = this._idAppMovimento;
    data['id_movimento'] = this._idMovimento;
    data['id_tipo_pagamento'] = this._idTipoPagamento;
    data['data'] = this._data.toString();
    data['valor'] = this._valor.toDouble();
    data['descricao'] = this._descricao;
    data['observacao'] = this._observacao;
    data['saldo'] = this._saldo.toDouble();
    data['data_cadastro'] = this._dataCadastro.toString();
    data['data_atualizacao'] = this._dataAtualizacao.toString();
    return data;
  }
}