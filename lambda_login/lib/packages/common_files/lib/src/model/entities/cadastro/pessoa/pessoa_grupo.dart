
class PessoaGrupo {
  int _id;
  String _nome;
  DateTime _dataCadastro;
  DateTime _dataAtualizacao;

  PessoaGrupo(
      {int id,
      String nome="",
      DateTime dataCadastro,
      DateTime dataAtualizacao}) {
    this._id = id;
    this._nome = nome;
    this._dataCadastro = dataCadastro == null ? DateTime.now() : dataCadastro;
    this._dataAtualizacao = dataAtualizacao == null ? DateTime.now() : dataAtualizacao;
  }

  int get id => _id;
  set id(int id) => _id = id;
  String get nome => nome;
  set nome(String nome) => _nome = nome;
  DateTime get dataCadastro => _dataCadastro;
  set dataCadastro(DateTime dataCadastro) => _dataCadastro = dataCadastro;
  DateTime get dataAtualizacao => _dataAtualizacao;
  set dataAtualizacao(DateTime dataAtualizacao) =>
      _dataAtualizacao = dataAtualizacao;

  PessoaGrupo.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _nome = json['nome'];
    _dataCadastro = DateTime.parse(json['data_cadastro']);
    _dataAtualizacao = DateTime.parse(json['data_atualizacao']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this._id;
    data['nome'] = this._nome;
    data['data_cadastro'] = this._dataCadastro.toString();
    data['data_atualizacao'] = this._dataAtualizacao.toString();
    return data;
  }
}