import 'package:common_files/common_files.dart';

class Categoria implements IEntity {
  int _id;
  int _idPessoaGrupo;
  String _nome;
  int _ehDeletado;
  int _ehServico;
  DateTime _dataCadastro;
  DateTime _dataAtualizacao;

  Categoria(
      {int id,
      int idPessoaGrupo,
      String nome,
      int ehDeletado = 0,
      int ehServico = 0,
      DateTime dataCadastro,
      DateTime dataAtualizacao}) {
    this._id = id;
    this._idPessoaGrupo = idPessoaGrupo;
    this._nome = nome;
    this._ehDeletado = ehDeletado;
    this._ehServico = ehServico;
    this._dataCadastro = dataCadastro;
    this._dataAtualizacao = dataAtualizacao;
  }

  int get id => _id;
  set id(int id) => _id = id;
  int get idPessoaGrupo => _idPessoaGrupo;
  set idPessoaGrupo(int idPessoaGrupo) => _idPessoaGrupo = idPessoaGrupo;
  String get nome => _nome;
  set nome(String nome) => _nome = nome;
  int get ehDeletado => _ehDeletado;
  set ehDeletado(int ehDeletado) => _ehDeletado = ehDeletado;
  int get ehServico => _ehServico;
  set ehServico(int ehServico) => _ehServico = ehServico;
  DateTime get dataCadastro => _dataCadastro;
  set dataCadastro(DateTime dataCadastro) => _dataCadastro = dataCadastro;
  DateTime get dataAtualizacao => _dataAtualizacao;
  set dataAtualizacao(DateTime dataAtualizacao) =>
      _dataAtualizacao = dataAtualizacao;

  String toString() {
    return '''
      id: ${_id.toString()},    
      idPessoaGrupo: ${_idPessoaGrupo.toString()},  
      nome: $_nome, 
      ehdeletado: ${_ehDeletado.toString()}, 
      ehservico: ${_ehServico.toString()},
      dataCadastro: ${_dataCadastro.toString()}, 
      dataAtualizacao: ${_dataAtualizacao.toString()}
    ''';  
  }

  Categoria.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _idPessoaGrupo = json['id_pessoa_grupo'];
    _nome = json['nome'];
    _ehDeletado = json['ehdeletado'];
    _ehServico = json['ehservico'];
    _dataCadastro = DateTime.parse(json['data_cadastro']);
    _dataAtualizacao = DateTime.parse(json['data_atualizacao']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this._id;
    data['id_pessoa_grupo'] = this._idPessoaGrupo;
    data['nome'] = this._nome;
    data['ehdeletado'] = this._ehDeletado;
    data['ehservico'] = this._ehServico;
    data['data_cadastro'] = this._dataCadastro;
    data['data_atualizacao'] = this._dataAtualizacao;
    return data;
  }

  static List<Categoria> fromJsonList(List list){
    if(list == null) return null;
    return list
      .map((item) => Categoria.fromJson(item))
      .toList();
  }  
}
