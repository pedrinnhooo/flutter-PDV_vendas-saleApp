import 'package:common_files/common_files.dart';

class ProdutoCodigoBarras implements IEntity {
  int _id;
  int _idProduto;
  int _idVariante;
  int _gradePosicao;
  String _codigoBarras;
  int _ehDeletado;
  DateTime _dataCadastro;
  DateTime _dataAtualizacao;
  Variante _variante;

  ProdutoCodigoBarras(
      {int id,
      int idProduto,
      int idVariante,
      int gradePosicao,
      String codigoBarras,
      int ehDeletado = 0,
      DateTime dataCadastro,
      DateTime dataAtualizacao,
      Variante variante}) {
    this._id = id;
    this._idProduto = idProduto;
    this._idVariante = idVariante;
    this._gradePosicao = gradePosicao;
    this._codigoBarras = codigoBarras;
    this._ehDeletado = ehDeletado;
    this._dataCadastro = dataCadastro;
    this._dataAtualizacao = dataAtualizacao;
    this._variante = variante == null ? Variante() : variante;
  }

  int get id => _id;
  set id(int id) => _id = id;
  int get idProduto => _idProduto;
  set idProduto(int idProduto) => _idProduto = idProduto;
  int get idVariante => _idVariante;
  set idVariante(int idVariante) => _idVariante = idVariante;
  int get gradePosicao => _gradePosicao;
  set gradePosicao(int gradePosicao) => _gradePosicao = gradePosicao;
  String get codigoBarras => _codigoBarras;
  set codigoBarras(String codigoBarras) => _codigoBarras = codigoBarras;
  int get ehDeletado => _ehDeletado;
  set ehDeletado(int ehDeletado) => _ehDeletado = ehDeletado;
  DateTime get dataCadastro => _dataCadastro;
  set dataCadastro(DateTime dataCadastro) => _dataCadastro = dataCadastro;
  DateTime get dataAtualizacao => _dataAtualizacao;
  set dataAtualizacao(DateTime dataAtualizacao) =>
      _dataAtualizacao = dataAtualizacao;
  Variante get variante => _variante;
  set variante(Variante variante) => _variante = variante;

  String toString() {
    return '''
      id: ${_id.toString()},    
      idProduto: ${_idProduto.toString()},  
      idVariante: ${_idVariante.toString()},  
      gradePosicao: ${_gradePosicao.toString()},  
      codigoBarras: $_codigoBarras,  
      ehDeletado: ${_ehDeletado.toString()}, 
      dataCadastro: ${_dataCadastro.toString()}, 
      dataAtualizacao: ${_dataAtualizacao.toString()}
    ''';  
  }

  ProdutoCodigoBarras.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _idProduto = json['id_produto'];
    _idVariante = json['id_variante'];
    _gradePosicao = json['grade_posicao'];
    _codigoBarras = json['codigo_barras'];
    _ehDeletado = json['ehdeletado'];
    _dataCadastro = DateTime.parse(json['data_cadastro']);
    _dataAtualizacao = DateTime.parse(json['data_atualizacao'].toString());
    _variante = json['variante'] != null
        ? new Variante.fromJson(json['variante'])
        : null;

  }

  Map<String, dynamic> toJson({bool isSave=false}) {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this._id;
    data['id_produto'] = this._idProduto;
    data['id_variante'] = this._idVariante;
    data['grade_posicao'] = this._gradePosicao;
    data['codigo_barras'] = this._codigoBarras;
    data['ehdeletado'] = this._ehDeletado;
    data['data_cadastro'] = this._dataCadastro.toString();
    data['data_atualizacao'] = this._dataAtualizacao.toString();
    if(this._variante != null){
      data['variante'] = this._variante.toJson();
    }
    return data;
  }
}
