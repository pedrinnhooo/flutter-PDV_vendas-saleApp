import 'package:common_files/common_files.dart';

class AplicativoVersao implements IEntity {
  int _id;
  int _idAplicativo;
  String _versao;
  int _ehAtivo;
  DateTime _dataLimite;
  DateTime _dataCadastro;
  DateTime _dataAtualizacao;

  AplicativoVersao(
      {int id,
       int idAplicativo,
       String versao,
       int ehAtivo,
       DateTime dataLimite,
       DateTime dataCadastro,
       DateTime dataAtualizacao}) {
    this._id = id;
    this._idAplicativo = idAplicativo;
    this._versao = versao;
    this._ehAtivo = ehAtivo;
    this._dataLimite = dataLimite;
    this._dataCadastro = dataCadastro;
    this._dataAtualizacao = dataAtualizacao;
  }

  int get id => _id;
  set id(int id) => _id = id;
  int get idAplicativo => _idAplicativo;
  set idAplicativo(int idAplicativo) => _idAplicativo = idAplicativo;
  String get versao => _versao;
  set versao(String versao) => _versao = versao;
  int get ehAtivo => _ehAtivo;
  set ehAtivo(int ehAtivo) => _ehAtivo = ehAtivo;
  DateTime get dataLimite => _dataLimite;
  set dataLimite(DateTime dataLimite) => _dataLimite = dataLimite;
  DateTime get dataCadastro => _dataCadastro;
  set dataCadastro(DateTime dataCadastro) => _dataCadastro = dataCadastro;
  DateTime get dataAtualizacao => _dataAtualizacao;
  set dataAtualizacao(DateTime dataAtualizacao) =>
      _dataAtualizacao = dataAtualizacao;

  String toString() {
    return '''
      id: ${_id.toString()},    
      idAplicativo: ${_idAplicativo.toString()},    
      versao: $_versao, 
      ehativo: ${_ehAtivo.toString()}, 
      dataLimite: ${_dataLimite.toString()}, 
      dataCadastro: ${_dataCadastro.toString()}, 
      dataAtualizacao: ${_dataAtualizacao.toString()}
    ''';  
  }

  AplicativoVersao.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _idAplicativo = json['id_aplicativo'];
    _versao = json['versao'];
    _ehAtivo = json['ehativo'];
    _dataLimite = DateTime.parse(json['data_limite']);
    _dataCadastro = DateTime.parse(json['data_cadastro']);
    _dataAtualizacao = DateTime.parse(json['data_atualizacao']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this._id;
    data['id_aplicativo'] = this._idAplicativo;
    data['versao'] = this._versao;
    data['ehativo'] = this._ehAtivo;
    data['data_limite'] = this._dataLimite;
    data['data_cadastro'] = this._dataCadastro;
    data['data_atualizacao'] = this._dataAtualizacao;
    return data;
  }

  static List<AplicativoVersao> fromJsonList(List list){
    if(list == null) return null;
    return list
      .map((item) => AplicativoVersao.fromJson(item))
      .toList();
  }  
}
