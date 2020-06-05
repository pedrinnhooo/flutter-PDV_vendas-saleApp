import '../../../../../common_files.dart';

class Contato implements IEntity {
  int _id;
  int _idPessoa;
  String _nome;
  String _telefone1;
  String _telefone2;
  String _email;
  int _ehPrincipal;
  int _ehDeletado;
  DateTime _dataCadastro;
  DateTime _dataAtualizacao;

  Contato(
      {int id,
      int idPessoa,
      String nome="",
      String telefone1="",
      String telefone2="",
      String email="",
      int ehPrincipal = 0,
      int ehDeletado = 0,
      DateTime dataCadastro,
      DateTime dataAtualizacao}) {
    this._id = id;
    this._idPessoa = idPessoa;
    this._nome = nome;
    this._telefone1 = telefone1;
    this._telefone2 = telefone2;
    this._email = email;
    this._ehPrincipal = ehPrincipal;
    this._ehDeletado = ehDeletado;
    this._dataCadastro = dataCadastro == null ? DateTime.now() : dataCadastro;
    this._dataAtualizacao = dataAtualizacao == null ? DateTime.now() : dataAtualizacao;
  }

  int get id => _id;
  set id(int id) => _id = id;
  int get idPessoa => _idPessoa;
  set idPessoa(int idPessoa) => _idPessoa = idPessoa;
  String get nome => _nome;
  set nome(String nome) => _nome = nome;
  String get telefone1 => _telefone1;
  set telefone1(String telefone1) => _telefone1 = telefone1;
  String get telefone2 => _telefone2;
  set telefone2(String telefone2) => _telefone2 = telefone2;
  String get email => _email;
  set email(String email) => _email = email;
  int get ehPrincipal => _ehPrincipal;
  set ehPrincipal(int ehPrincipal) => _ehPrincipal = ehPrincipal;
  int get ehDeletado => _ehDeletado;
  set ehDeletado(int ehDeletado) => _ehDeletado = ehDeletado;
  DateTime get dataCadastro => _dataCadastro;
  set dataCadastro(DateTime dataCadastro) => _dataCadastro = dataCadastro;
  DateTime get dataAtualizacao => _dataAtualizacao;
  set dataAtualizacao(DateTime dataAtualizacao) =>
      _dataAtualizacao = dataAtualizacao;

  Contato.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _idPessoa = json['id_pessoa'];
    _nome = json['nome'];
    _telefone1 = json['telefone1'];
    _telefone2 = json['telefone2'];
    _email = json['email'];
    _ehPrincipal = json['ehprincipal'];
    _ehDeletado = json['ehdeletado'];
    _dataCadastro = DateTime.parse(json['data_cadastro']);
    _dataAtualizacao = DateTime.parse(json['data_atualizacao']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this._id;
    data['id_pessoa'] = this._idPessoa;
    data['nome'] = this._nome;
    data['telefone1'] = this._telefone1;
    data['telefone2'] = this._telefone2;
    data['email'] = this._email;
    data['ehprincipal'] = this._ehPrincipal;
    data['ehdeletado'] = this._ehDeletado;
    data['data_cadastro'] = this._dataCadastro.toString();
    data['data_atualizacao'] = this._dataAtualizacao.toString();
    return data;
  }
}
