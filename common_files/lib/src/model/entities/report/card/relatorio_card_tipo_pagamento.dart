import 'package:common_files/common_files.dart';

class RelatorioCardTipoPagamento extends IEntity {
  String _nome;
  double _valor;
  int _idTipoPagamento;

  RelatorioCardTipoPagamento({String nome, double valor, int idTipoPagamento}) {
    this._nome = nome;
    this._valor = valor;
    this._idTipoPagamento = idTipoPagamento;
  }

  String get nome => _nome;
  set nome(String nome) => _nome = nome;
  double get valor => _valor;
  set valor(double valor) => _valor = valor;
  int get idTipoPagamento => _idTipoPagamento;
  set idTipoPagamento(int idTipoPagamento) => _idTipoPagamento = idTipoPagamento;

  RelatorioCardTipoPagamento.fromJson(Map<String, dynamic> json) {
    _nome = json['nome'];
    _valor = json['valor'];
    _idTipoPagamento = json['id_tipo_pagamento'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['nome'] = this._nome;
    data['valor'] = this._valor;
    data['id_tipo_pagamento'] = this._idTipoPagamento;
    return data;
  }

  static List<RelatorioCardTipoPagamento> fromJsonList(List list){
    if(list == null) return null;
    return list
      .map((item) => RelatorioCardTipoPagamento.fromJson(item))
      .toList();
  }    

}