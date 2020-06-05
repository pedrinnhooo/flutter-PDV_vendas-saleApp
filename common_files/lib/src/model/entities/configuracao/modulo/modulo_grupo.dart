import 'package:common_files/common_files.dart';

class ModuloGrupo implements IEntity {
  int _id;
  String _nome;
  double _valor;
  int _ehAtivo;
  DateTime _dataCadastro;
  DateTime _dataAtualizacao;
  List<ModuloGrupoItem> _moduloGrupoItem;

  ModuloGrupo(
      {int id,
      String nome = "",
      double valor = 0,
      int ehAtivo = 0,
      DateTime dataCadastro,
      DateTime dataAtualizacao,
      List<ModuloGrupoItem> moduloGrupoItem}) {
    this._id = id;
    this._nome = nome;
    this._valor = valor;
    this._ehAtivo = ehAtivo;
    this._dataCadastro = dataCadastro;
    this._dataAtualizacao = dataAtualizacao;
    this._moduloGrupoItem = moduloGrupoItem == null ? [] : moduloGrupoItem;
  }

  int get id => _id;
  set id(int id) => _id = id;
  String get nome => _nome;
  set nome(String nome) => _nome = nome;
  double get valor => _valor;
  set valor(double valor) => _valor = valor;
  int get ehAtivo => _ehAtivo;
  set ehAtivo(int ehAtivo) => _ehAtivo = ehAtivo;
  DateTime get dataCadastro => _dataCadastro;
  set dataCadastro(DateTime dataCadastro) => _dataCadastro = dataCadastro;
  DateTime get dataAtualizacao => _dataAtualizacao;
  set dataAtualizacao(DateTime dataAtualizacao) =>
      _dataAtualizacao = dataAtualizacao;
  List<ModuloGrupoItem> get moduloGrupoItem => _moduloGrupoItem;
  set moduloGrupoItem(List<ModuloGrupoItem> moduloGrupoItem) => _moduloGrupoItem = moduloGrupoItem;

  String toString() {
    return '''
      id: ${_id.toString()},    
      nome: $_nome, 
      valor: ${_valor.toString()},    
      ehAtivo: ${_ehAtivo.toString()}, 
      dataCadastro: ${_dataCadastro.toString()}, 
      dataAtualizacao: ${_dataAtualizacao.toString()}
    ''';  
  }  

  ModuloGrupo.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _nome = json['nome'];
    _valor = json['valor'];
    _ehAtivo = json['ehativo'];
    _dataCadastro = DateTime.parse(json['data_cadastro']);
    _dataAtualizacao = DateTime.parse(json['data_atualizacao']);
    if (json['modulo_grupo_items'] != null) {
      _moduloGrupoItem = new List<ModuloGrupoItem>();
      json['modulo_grupo_items'].forEach((v) {
        _moduloGrupoItem.add(new ModuloGrupoItem.fromJson(v));
      });
    }    
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this._id;
    data['nome'] = this._nome;
    data['valor'] = this._valor;
    data['ehativo'] = this._ehAtivo;
    data['data_cadastro'] = this._dataCadastro;
    data['data_atualizacao'] = this._dataAtualizacao;
    if (this._moduloGrupoItem != null) {
      data['modulo_grupo_items'] =
        this._moduloGrupoItem.map((v) => v.toJson()).toList();
    }    
    return data;
  }

  static List<ModuloGrupo> fromJsonList(List list){
    if(list == null) return null;
    return list
      .map((item) => ModuloGrupo.fromJson(item))
      .toList();
  }  

}