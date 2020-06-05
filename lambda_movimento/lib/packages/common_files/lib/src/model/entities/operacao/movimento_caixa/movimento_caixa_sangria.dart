class MovimentoCaixaSangria {
  int _idTipoPagamento;
  String _nomeTipoPagamento;
  double _valor;

  MovimentoCaixaSangria(
      {int idTipoPagamento,
      String nomeTipoPagamento,
      double valor}) {
    this._idTipoPagamento = idTipoPagamento;
    this._nomeTipoPagamento = nomeTipoPagamento;
    this._valor = valor;
  }

  int get idTipoPagamento => _idTipoPagamento;
  set idTipoPagamento(int idTipoPagamento) => _idTipoPagamento = idTipoPagamento;
  String get nomeTipoPagamento => _nomeTipoPagamento;
  set nomeTipoPagamento(String nomeTipoPagamento) => _nomeTipoPagamento = nomeTipoPagamento;
  double get valor => _valor;
  set valor(double valor) => _valor = valor;
}
