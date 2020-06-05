import 'package:common_files/common_files.dart';

class Modulo implements IEntity {
  int _id;
  String _nome;
  int _ehAtivo;
  DateTime _dataCadastro;
  DateTime _dataAtualizacao;

  Modulo(
      {int id,
      String nome = "",
      int ehAtivo = 0,
      DateTime dataCadastro,
      DateTime dataAtualizacao}) {
    this._id = id;
    this._nome = nome;
    this._ehAtivo = ehAtivo;
    this._dataCadastro = dataCadastro;
    this._dataAtualizacao = dataAtualizacao;
  }

  int get id => _id;
  set id(int id) => _id = id;
  String get nome => _nome;
  set nome(String nome) => _nome = nome;
  int get ehAtivo => _ehAtivo;
  set ehAtivo(int ehAtivo) => _ehAtivo = ehAtivo;
  DateTime get dataCadastro => _dataCadastro;
  set dataCadastro(DateTime dataCadastro) => _dataCadastro = dataCadastro;
  DateTime get dataAtualizacao => _dataAtualizacao;
  set dataAtualizacao(DateTime dataAtualizacao) =>
      _dataAtualizacao = dataAtualizacao;

  String toString() {
    return '''
      id: ${_id.toString()},    
      nome: $_nome, 
      ehAtivo: ${_ehAtivo.toString()}, 
      dataCadastro: ${_dataCadastro.toString()}, 
      dataAtualizacao: ${_dataAtualizacao.toString()}
    ''';  
  }

  Modulo.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _nome = json['nome'];
    _ehAtivo = json['ehativo'];
    _dataCadastro = DateTime.parse(json['data_cadastro']);
    _dataAtualizacao = DateTime.parse(json['data_atualizacao']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this._id;
    data['nome'] = this._nome;
    data['ehativo'] = this._ehAtivo;
    data['data_cadastro'] = this._dataCadastro;
    data['data_atualizacao'] = this._dataAtualizacao;
    return data;
  }

  static List<Modulo> fromJsonList(List list){
    if(list == null) return null;
    return list
      .map((item) => Modulo.fromJson(item))
      .toList();
  }  

}