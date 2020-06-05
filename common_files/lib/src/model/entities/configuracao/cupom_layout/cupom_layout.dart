import 'package:common_files/common_files.dart';

class CupomLayout implements IEntity {
  int _id;
  String _nome;
  String _layout;
  int _tamanhoPapel;
  DateTime _dataCadastro;
  DateTime _dataAtualizacao;

  CupomLayout(
      {int id,
      String nome,
      String layout,
      int tamanhoPapel,
      DateTime dataCadastro,
      DateTime dataAtualizacao}) {
    this._id = id;
    this._nome = nome;
    this._layout = layout;
    this._tamanhoPapel = tamanhoPapel;
    this._dataCadastro = dataCadastro;
    this._dataAtualizacao = dataAtualizacao;
  }

  int get id => _id;
  set id(int id) => _id = id;
  String get nome => _nome;
  set nome(String nome) => _nome = nome;
  String get layout => _layout;
  set layout(String layout) => _layout = layout;
  int get tamanhoPapel => _tamanhoPapel;
  set tamanhoPapel(int tamanhoPapel) => _tamanhoPapel = tamanhoPapel;
  DateTime get dataCadastro => _dataCadastro;
  set dataCadastro(DateTime dataCadastro) => _dataCadastro = dataCadastro;
  DateTime get dataAtualizacao => _dataAtualizacao;
  set dataAtualizacao(DateTime dataAtualizacao) =>
      _dataAtualizacao = dataAtualizacao;

  String toString() {
    return '''
      id: ${_id.toString()},    
      nome: $_nome, 
      layout: $_layout, 
      tamanhoPapel: ${_tamanhoPapel.toString()}, 
      dataCadastro: ${_dataCadastro.toString()}, 
      dataAtualizacao: ${_dataAtualizacao.toString()}
    ''';  
  }      

  CupomLayout.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _nome = json['nome'];
    _layout = json['layout'];
    _tamanhoPapel = json['tamanho_papel'];
    _dataCadastro = DateTime.parse(json['data_cadastro']);
    _dataAtualizacao = DateTime.parse(json['data_atualizacao']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this._id;
    data['nome'] = this._nome;
    data['layout'] = this._layout;
    data['tamanho_papel'] = this._tamanhoPapel;
    data['data_cadastro'] = this._dataCadastro;
    data['data_atualizacao'] = this._dataAtualizacao;
    return data;
  }
}