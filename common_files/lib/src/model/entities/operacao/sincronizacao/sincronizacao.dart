class Sincronizacao {
  int _id;
  int _idPessoaGrupo;
  String _tabela;
  DateTime _dataAtualizacao;

  Sincronizacao(
    {int id,
     int idPessoaGrupo,
     String tabela,
     DateTime dataAtualizacao}) {
    this._id = id;
    this._idPessoaGrupo = idPessoaGrupo;
    this._tabela = tabela;
    this._dataAtualizacao = dataAtualizacao;
  }

  int get id => _id;
  set id(int id) => _id = id;
  int get idPessoaGrupo => _idPessoaGrupo;
  set idPessoaGrupo(int idPessoaGrupo) => _idPessoaGrupo = idPessoaGrupo;
  String get tabela => _tabela;
  set tabela(String tabela) => _tabela = tabela;
  DateTime get dataAtualizacao => _dataAtualizacao;
  set dataAtualizacao(DateTime dataAtualizacao) => _dataAtualizacao = dataAtualizacao;

  Sincronizacao.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _idPessoaGrupo = json['id_pessoa_grupo'];
    _tabela = json['tabela'];
    _dataAtualizacao = DateTime.parse(json['data_atualizacao']);
  }  

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this._id;
    data['id_pessoa_grupo'] = this._idPessoaGrupo;
    data['tabela'] = this._tabela;
    data['data_atualizacao'] = this._dataAtualizacao.toString();
    return data;
  }

}