import 'package:common_files/src/model/entities/interfaces.dart';

class MovimentoCaixaParcela implements IEntity {
  int _idApp;
  int _id;
  int _idAppMovimentoCaixa;
  int _idMovimentoCaixa;
  int _idTipoPagamento;
  DateTime _data;
  String _descricao;
  double _valor;
  String _observacao;
  DateTime _dataCadastro;
  DateTime _dataAtualizacao;

  MovimentoCaixaParcela(
      {int idApp,
      int id,
      int idAppMovimentoCaixa,
      int idMovimentoCaixa,
      int idTipoPagamento,
      DateTime data,
      String descricao,
      double valor,
      String observacao,
      DateTime dataCadastro,
      DateTime dataAtualizacao}) {
    this._idApp = idApp;
    this._id = id;
    this._idAppMovimentoCaixa = idAppMovimentoCaixa;
    this._idMovimentoCaixa = idMovimentoCaixa;
    this._idTipoPagamento = idTipoPagamento;
    this._data = data;
    this._descricao = descricao;
    this._valor = valor;
    this._observacao = observacao;
    this._dataCadastro = dataCadastro == null ? DateTime.now() : dataCadastro;
    this._dataAtualizacao = dataAtualizacao == null ? DateTime.now() : dataAtualizacao;
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
  String get observacao => _observacao;
  set observacao(String observacao) => _observacao = observacao;
  DateTime get dataCadastro => _dataCadastro;
  set dataCadastro(DateTime dataCadastro) => _dataCadastro = dataCadastro;
  DateTime get dataAtualizacao => _dataAtualizacao;
  set dataAtualizacao(DateTime dataAtualizacao) =>
      _dataAtualizacao = dataAtualizacao;

  MovimentoCaixaParcela.fromJson(Map<String, dynamic> json) {
    _idApp = json['id_app'];
    _id = json['id'];
    _idAppMovimentoCaixa = json['id_app_movimento_caixa'];
    _idMovimentoCaixa = json['id_movimento_caixa'];
    _idTipoPagamento = json['id_tipo_pagamento'];
    _data = DateTime.parse(json['data']);
    _descricao= json['descricao'];
    _valor = json['valor'];
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
    data['observacao'] = this._observacao;
    data['data_cadastro'] = this._dataCadastro.toString();
    data['data_atualizacao'] = this._dataAtualizacao.toString();
    return data;
  }
}
