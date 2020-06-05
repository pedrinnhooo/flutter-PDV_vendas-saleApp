import 'package:common_files/common_files.dart';

class Variante implements IEntity {
  int _id;
  int _idPessoaGrupo;
  String _nome;
  String _nomeAvatar;
  int _temImagem;
  String _iconecor;
  int _ehDeletado;
  DateTime _dataCadastro;
  DateTime _dataAtualizacao;

  Variante(
      {int id,
      int idPessoaGrupo,
      String nome,
      String nomeAvatar,
      int temImagem = 0,
      String iconecor = "0XFF808080",
      int ehDeletado = 0,
      DateTime dataCadastro,
      DateTime dataAtualizacao}) {
    this._id = id;
    this._idPessoaGrupo = idPessoaGrupo;
    this._nome = nome;
    this._nomeAvatar = nomeAvatar;
    this._temImagem = temImagem;
    this._iconecor = iconecor;
    this._ehDeletado = ehDeletado;
    this._dataCadastro = dataCadastro;
    this._dataAtualizacao = dataAtualizacao;
  }

  int get id => _id;
  set id(int id) => _id = id;
  int get idPessoaGrupo => _idPessoaGrupo;
  set idPessoaGrupo(int idPessoaGrupo) => _idPessoaGrupo = idPessoaGrupo;
  String get nome => _nome;
  set nome(String nome) => _nome = nome;
  String get nomeAvatar => _nomeAvatar;
  set nomeAvatar(String nomeAvatar) => _nomeAvatar = nomeAvatar;
  int get temImagem => _temImagem;
  set temImagem(int temImagem) => _temImagem = temImagem;
  String get iconecor => _iconecor;
  set iconecor(String iconecor) => _iconecor = iconecor;
  int get ehDeletado => _ehDeletado;
  set ehDeletado(int ehDeletado) => _ehDeletado = ehDeletado;
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
      nomeAvatar: $_nomeAvatar, 
      temImagem: ${_temImagem.toString()}, 
      iconecor: $_iconecor, 
      ehDeletado: ${_ehDeletado.toString()}, 
      dataCadastro: ${_dataCadastro.toString()}, 
      dataAtualizacao: ${_dataAtualizacao.toString()}
    ''';  
  }

  Variante.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _idPessoaGrupo = json['id_pessoa_grupo'];
    _nome = json['nome'];
    _nomeAvatar = json['nome_avatar']; 
    _temImagem = json['tem_imagem'];
    _iconecor = json['iconecor'];
    _ehDeletado = json['ehdeletado'];
    _dataCadastro = json['data_cadastro'] != null ? DateTime.parse(json['data_cadastro']) : null;
    _dataAtualizacao = json['data_atualizacao'] != null ? DateTime.parse(json['data_atualizacao']) : null;
  }	  

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this._id;
    data['idPessoaGrupo'] = this._idPessoaGrupo;
    data['nome'] = this._nome;
    data['nomeAvatar'] = this._nomeAvatar;
    data['temImagem'] = this._temImagem;
    data['iconecor'] = this._iconecor;
    data['ehDeletado'] = this._ehDeletado;
    data['dataCadastro'] = this._dataCadastro.toString();
    data['dataAtualizacao'] = this._dataAtualizacao.toString();
    return data;
  }
}
