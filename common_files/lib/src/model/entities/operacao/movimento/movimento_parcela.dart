import 'package:common_files/common_files.dart';

class MovimentoParcela implements IEntity {
  int _idApp;
  int _id;
  int _idMovimentoApp;
  int _idMovimento;
  int _idTipoPagamento;
  double _valor = 0;
  DateTime _dataCadastro;
  DateTime _dataAtualizacao;
  TipoPagamento _tipoPagamento;

  MovimentoParcela(
      {int idApp,
      int id,
      int idMovimentoApp,
      int idMovimento,
      int idTipoPagamento,
      double valor,
      DateTime dataCadastro,
      DateTime dataAtualizacao,
      TipoPagamento tipoPagamento}) {
    this._idApp = idApp;
    this._id = id;
    this._idMovimentoApp = idMovimentoApp;
    this._idMovimento = idMovimento;
    this._idTipoPagamento = idTipoPagamento;
    this._valor = valor;
    this._dataCadastro = dataCadastro != null ? dataCadastro : DateTime.now();
    this._dataAtualizacao = dataAtualizacao != null ? dataAtualizacao : DateTime.now();
    this._tipoPagamento =
        tipoPagamento == null ? TipoPagamento() : tipoPagamento;
  }

  int get idApp => _idApp;
  set idApp(int idApp) => _idApp = idApp;
  int get id => _id;
  set id(int id) => _id = id;
  int get idMovimentoApp => _idMovimentoApp;
  set idMovimentoApp(int idMovimentoApp) => _idMovimentoApp = idMovimentoApp;
  int get idMovimento => _idMovimento;
  set idMovimento(int idMovimento) => _idMovimento = idMovimento;
  int get idTipoPagamento => _idTipoPagamento;
  set idTipoPagamento(int idTipoPagamento) =>
      _idTipoPagamento = idTipoPagamento;
  double get valor => _valor;
  set valor(double valor) => _valor = valor;
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
      idMovimentoApp: ${_idMovimentoApp.toString()},    
      idMovimento: ${_idMovimento.toString()},    
      idTipoPagamento: ${_idTipoPagamento.toString()},  
      valor: ${_valor.toString()},  
      dataCadastro: ${_dataCadastro.toString()}, 
      dataAtualizacao: ${_dataAtualizacao.toString()}
    ''';  
  }

  MovimentoParcela.fromJson(Map<String, dynamic> json) {
    _idApp = json['id_app'];
    _id = json['id'];
    _idMovimentoApp = json['id_movimento_app'];
    _idMovimento = json['id_movimento'];
    _idTipoPagamento = json['id_tipo_pagamento'];
    _valor = json['valor'].toDouble();
    _dataCadastro = DateTime.parse(json['data_cadastro']);
    _dataAtualizacao = DateTime.parse(json['data_atualizacao']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id_app'] = this._idApp;
    data['id'] = this._id;
    data['id_movimento_app'] = this._idMovimentoApp;
    data['id_movimento'] = this._idMovimento;
    data['id_tipo_pagamento'] = this._idTipoPagamento;
    data['valor'] = this._valor;
    data['data_cadastro'] = this._dataCadastro.toString();
    data['data_atualizacao'] = this._dataAtualizacao.toString();
    return data;
  }
}