import 'package:common_files/common_files.dart';

class Aplicativo implements IEntity {
  int _id;
  String _nome;
  String _key;
  DateTime _dataCadastro;
  DateTime _dataAtualizacao;
  List<AplicativoVersao> _aplicativoVersao;

  Aplicativo(
      {int id,
      String nome,
      String key,
      DateTime dataCadastro,
      DateTime dataAtualizacao,
      List<AplicativoVersao> aplicativoVersao}) {
    this._id = id;
    this._nome = nome;
    this._key = key;
    this._dataCadastro = dataCadastro;
    this._dataAtualizacao = dataAtualizacao;
    this._aplicativoVersao = aplicativoVersao == null ? [] : aplicativoVersao;    
  }

  int get id => _id;
  set id(int id) => _id = id;
  String get nome => _nome;
  set nome(String nome) => _nome = nome;
  String get key => _key;
  set key(String key) => _key = key;
  DateTime get dataCadastro => _dataCadastro;
  set dataCadastro(DateTime dataCadastro) => _dataCadastro = dataCadastro;
  DateTime get dataAtualizacao => _dataAtualizacao;
  set dataAtualizacao(DateTime dataAtualizacao) =>
      _dataAtualizacao = dataAtualizacao;
  List<AplicativoVersao> get aplicativoVersao => _aplicativoVersao;
  set aplicativoVersao(List<AplicativoVersao> aplicativoVersao) => _aplicativoVersao = aplicativoVersao;      

  String toString() {
    return '''
      id: ${_id.toString()},    
      nome: $_nome, 
      key: $_key, 
      dataCadastro: ${_dataCadastro.toString()}, 
      dataAtualizacao: ${_dataAtualizacao.toString()}
    ''';  
  }

  Aplicativo.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _nome = json['nome'];
    _key = json['key'];
    _dataCadastro = DateTime.parse(json['data_cadastro']);
    _dataAtualizacao = DateTime.parse(json['data_atualizacao']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this._id;
    data['nome'] = this._nome;
    data['key'] = this._key;
    data['data_cadastro'] = this._dataCadastro;
    data['data_atualizacao'] = this._dataAtualizacao;
    return data;
  }

  static List<Aplicativo> fromJsonList(List list){
    if(list == null) return null;
    return list
      .map((item) => Aplicativo.fromJson(item))
      .toList();
  }  
}
