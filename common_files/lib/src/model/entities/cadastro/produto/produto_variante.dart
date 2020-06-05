import 'package:common_files/common_files.dart';

class ProdutoVariante implements IEntity {
  int _id;
  int _idProduto;
  int _idVariante;
  int _ehDeletado;
  DateTime _dataCadastro;
  DateTime _dataAtualizacao;
  Variante _variante;
  int _estoque;
  int _newEstoque;

  ProdutoVariante(
      {int id,
      int idProduto,
      int idVariante,
      int ehDeletado,
      DateTime dataCadastro,
      DateTime dataAtualizacao,
      Variante variante}) {
    this._id = id;
    this._idProduto = idProduto;
    this._idVariante = idVariante;
    this._ehDeletado = ehDeletado;
    this._dataCadastro = dataCadastro;
    this._dataAtualizacao = dataAtualizacao;
    this._variante = variante == null ? Variante() : variante;
    this._estoque = 0;
  }

  int get id => _id;
  set id(int id) => _id = id;
  int get idProduto => _idProduto;
  set idProduto(int idProduto) => _idProduto = idProduto;
  int get idVariante => _idVariante;
  set idVariante(int idVariante) => _idVariante = idVariante;
  int get ehDeletado => _ehDeletado;
  set ehDeletado(int ehDeletado) => _ehDeletado = ehDeletado;
  DateTime get dataCadastro => _dataCadastro;
  set dataCadastro(DateTime dataCadastro) => _dataCadastro = dataCadastro;
  DateTime get dataAtualizacao => _dataAtualizacao;
  set dataAtualizacao(DateTime dataAtualizacao) =>
      _dataAtualizacao = dataAtualizacao;
  Variante get variante => _variante;
  set variante(Variante variante) => _variante = variante;
  int get estoque => _estoque;
  set estoque(int estoque) => _estoque = estoque;
  int get newEstoque => _newEstoque;
  set newEstoque(int newEstoque) => _newEstoque = newEstoque;

  String toString() {
    return '''
      id: ${_id.toString()},    
      idProduto: ${_idProduto.toString()},  
      idVariante: ${_idVariante.toString()},  
      ehdeletado: ${_ehDeletado.toString()}, 
      dataCadastro: ${_dataCadastro.toString()}, 
      dataAtualizacao: ${_dataAtualizacao.toString()}
    ''';  
  }

  ProdutoVariante.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _idProduto = json['id_produto'];
    _idVariante = json['id_variante'];
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
    data['ehdeletado'] = this._ehDeletado;
    data['data_cadastro'] = this._dataCadastro.toString();
    data['data_atualizacao'] = this._dataAtualizacao.toString();
    if (!isSave) {
      data['variante'] = this._variante != null ? this._variante.toJson() : null;
    }  
    return data;
  }
}
