class ModuloAcesso {
  bool _transacaoPrecoTabela;
  bool _gradeVariante;
  bool _fiscal;
  bool _tef;
  bool _desktop;

  ModuloAcesso(
      {bool transacaoPrecoTabela=false,
       bool gradeVariante=false,
       bool fiscal=false,
       bool tef=false,
       bool desktop=false}) {
    this._transacaoPrecoTabela = transacaoPrecoTabela;
    this._gradeVariante = gradeVariante;
    this._fiscal = fiscal;
    this._tef = tef;
    this._desktop = desktop;
  }

  @override
    String toString() {
        return """
          transacaoPrecoTabela: ${this._transacaoPrecoTabela},
          gradeVariante: ${this._gradeVariante},
          fiscal: ${this._fiscal},
          tef: ${this._tef},
          desktop: ${this._desktop},
        """;
    }

  bool get transacaoPrecoTabela => _transacaoPrecoTabela;
  set transacaoPrecoTabela(bool transacaoPrecoTabela) => _transacaoPrecoTabela = transacaoPrecoTabela;
  bool get gradeVariante => _gradeVariante;
  set gradeVariante(bool gradeVariante) => _gradeVariante = gradeVariante;
  bool get fiscal => _fiscal;
  set fiscal(bool fiscal) => _fiscal = fiscal;
  bool get tef => _tef;
  set tef(bool tef) => _tef = tef;
  bool get desktop => _desktop;
  set desktop(bool desktop) => _desktop = desktop;
}