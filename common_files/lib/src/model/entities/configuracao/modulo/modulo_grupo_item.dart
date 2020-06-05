import 'package:common_files/common_files.dart';

class ModuloGrupoItem implements IEntity {
  int _id;
  int _idModuloGrupo;
  int _idModulo;
  DateTime _dataCadastro;
  DateTime _dataAtualizacao;

  ModuloGrupoItem(
      {int id,
      int idModuloGrupo,
      int idModulo,
      DateTime dataCadastro,
      DateTime dataAtualizacao}) {
    this._id = id;
    this._idModuloGrupo = idModuloGrupo;
    this._idModulo = idModulo;
    this._dataCadastro = dataCadastro;
    this._dataAtualizacao = dataAtualizacao;
  }

  int get id => _id;
  set id(int id) => _id = id;
  int get idModuloGrupo => _idModuloGrupo;
  set idModuloGrupo(int idModuloGrupo) => _idModuloGrupo = idModuloGrupo;
  int get idModulo => _idModulo;
  set idModulo(int idModulo) => _idModulo = idModulo;
  DateTime get dataCadastro => _dataCadastro;
  set dataCadastro(DateTime dataCadastro) => _dataCadastro = dataCadastro;
  DateTime get dataAtualizacao => _dataAtualizacao;
  set dataAtualizacao(DateTime dataAtualizacao) =>
      _dataAtualizacao = dataAtualizacao;

  String toString() {
    return '''
      id: ${_id.toString()},    
      idModuloGrupo: ${_idModuloGrupo.toString()},  
      idModulo: ${_idModulo.toString()},  
      dataCadastro: ${_dataCadastro.toString()}, 
      dataAtualizacao: ${_dataAtualizacao.toString()}
    ''';  
  }      

  ModuloGrupoItem.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _idModuloGrupo = json['id_modulo_grupo'];
    _idModulo = json['id_modulo'];
    _dataCadastro = DateTime.parse(json['data_cadastro']);
    _dataAtualizacao = DateTime.parse(json['data_atualizacao']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this._id;
    data['id_modulo_grupo'] = this._idModuloGrupo;
    data['id_modulo'] = this._idModulo;
    data['data_cadastro'] = this._dataCadastro.toString();
    data['data_atualizacao'] = this._dataAtualizacao.toString();
    return data;
  }

  static List<ModuloGrupoItem> fromJsonList(List list){
    if (list == null) return null;
    return list
      .map((item) => ModuloGrupoItem.fromJson(item))
      .toList();
  }  

}