import 'package:common_files/common_files.dart';

class MovimentoCaixaTotalTipoPagamento implements IEntity {
  int _id;
  int _idMovimentoCaixa;
  int _idTipoPagamento;
  double _vendaValorTotal;
  double _devolucaoValorTotal;
  double _aberturaValorTotal;
  double _reforcoValorTotal;
  double _retiradaValorTotal;
  TipoPagamento _tipoPagamento;

  MovimentoCaixaTotalTipoPagamento(
      {int id,
      int idMovimentoCaixa,
      int idTipoPagamento,
      double vendaValorTotal = 0,
      double devolucaoValorTotal = 0,
      double aberturaValorTotal = 0,
      double reforcoValorTotal = 0,
      double retiradaValorTotal = 0,
      TipoPagamento tipoPagamento}) {
    this._id = id;
    this._idMovimentoCaixa = idTipoPagamento;
    this._idTipoPagamento = idTipoPagamento;
    this._vendaValorTotal = vendaValorTotal;
    this._devolucaoValorTotal = devolucaoValorTotal;
    this._aberturaValorTotal = aberturaValorTotal;
    this._reforcoValorTotal = reforcoValorTotal;
    this._retiradaValorTotal = retiradaValorTotal;
    this._tipoPagamento = tipoPagamento != null ? tipoPagamento : TipoPagamento();
  }

  int get id => _id;
  set id(int id) => _id = id;
  int get idMovimentoCaixa => _idMovimentoCaixa;
  set idMovimentoCaixa(int idMovimentoCaixa) => _idMovimentoCaixa = idMovimentoCaixa;
  int get idTipoPagamento => _idTipoPagamento;
  set idTipoPagamento(int idTipoPagamento) => _idTipoPagamento = idTipoPagamento;
  double get vendaValorTotal => _vendaValorTotal;
  set vendaValorTotal(double vendaValorTotal) => _vendaValorTotal = vendaValorTotal;
  double get devolucaoValorTotal => _devolucaoValorTotal;
  set devolucaoValorTotal(double devolucaoValorTotal) => _devolucaoValorTotal = devolucaoValorTotal;
  double get aberturaValorTotal => _aberturaValorTotal;
  set aberturaValorTotal(double aberturaValorTotal) => _aberturaValorTotal = aberturaValorTotal;
  double get reforcoValorTotal => _reforcoValorTotal;
  set reforcoValorTotal(double reforcoValorTotal) => _reforcoValorTotal = reforcoValorTotal;
  double get retiradaValorTotal => _retiradaValorTotal;
  set retiradaValorTotal(double retiradaValorTotal) => _retiradaValorTotal = retiradaValorTotal;
  TipoPagamento get tipoPagamento => _tipoPagamento;
  set tipoPagamento(TipoPagamento tipoPagamento) => 
      _tipoPagamento = tipoPagamento;  

  String toString() {
    return '''
      id: ${_id.toString()},    
      idMovimentoCaixa: ${_idMovimentoCaixa.toString()},
      idTipoPagamento: ${_idMovimentoCaixa.toString()},
      vendaValorTotal: ${_vendaValorTotal.toString()},
      devolucaoValorTotal: ${_devolucaoValorTotal.toString()}, 
      aberturaValorTotal: ${_aberturaValorTotal.toString()}, 
      reforcoValorTotal: ${_reforcoValorTotal.toString()}, 
      retiradaValorTotal: ${_retiradaValorTotal.toString()}
    ''';  
  }

  MovimentoCaixaTotalTipoPagamento.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _idMovimentoCaixa = json['id_movimento_caixa'];
    _idTipoPagamento = json['id_tipo_pagamento'];
    _vendaValorTotal = json['venda_valor_total'];
    _devolucaoValorTotal = json['devolucao_valor_total'];
    _aberturaValorTotal = json['abertura_valor_total'];
    _reforcoValorTotal = json['reforco_valor_total'];
    _retiradaValorTotal = json['retirada_valor_total'];
    _tipoPagamento = json['tipo_pagamento'] != null
        ? new TipoPagamento.fromJson(json['tipo_pagamento'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this._id;
    data['id_movimento_caixa'] = this._idMovimentoCaixa;
    data['id_tipo_pagamento'] = this._idTipoPagamento;
    data['venda_valor_total'] = this._vendaValorTotal;
    data['devolucao_valor_total'] = this._devolucaoValorTotal;
    data['abertura_valor_total'] = this._aberturaValorTotal;
    data['reforco_valor_total'] = this._reforcoValorTotal;
    data['retirada_valor_total'] = this._retiradaValorTotal;
    if (this._tipoPagamento != null) {
      data['tipo_pagamento'] = this._tipoPagamento.toJson();
    }
    return data;
  }
}
