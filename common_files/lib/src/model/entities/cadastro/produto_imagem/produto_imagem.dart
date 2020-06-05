import 'package:common_files/common_files.dart';

class ProdutoImagem extends IEntity {
  int _id;
  int _idProduto;
  String _imagem;
  int _ehDeletado;
  DateTime _dataCadastro;
  DateTime _dataAtualizacao;

  ProdutoImagem(
      {int id,
      int idProduto,
      String imagem,
      int ehDeletado = 0,
      DateTime dataCadastro,
      DateTime dataAtualizacao}) {
    this._id = id;
    this._idProduto = idProduto;
    this._imagem = imagem;
    this._ehDeletado = ehDeletado;
    this._dataCadastro = dataCadastro;
    this._dataAtualizacao = dataAtualizacao;
  }

  int get id => _id;
  set id(int id) => _id = id;
  int get idProduto => _idProduto;
  set idProduto(int idProduto) => _idProduto = idProduto;
  String get imagem => _imagem;
  set imagem(String imagem) => _imagem = imagem;
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
      idProduto: ${_idProduto.toString()},  
      imagem: $_imagem, 
      ehDeletado: ${_ehDeletado.toString()}, 
      dataCadastro: ${_dataCadastro.toString()}, 
      dataAtualizacao: ${_dataAtualizacao.toString()}
    ''';  
  }

  ProdutoImagem.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _idProduto = json['id_produto'];
    _imagem = json['imagem'];
    _ehDeletado = json['ehdeletado'];
    _dataCadastro = DateTime.parse(json['data_cadastro']);
    _dataAtualizacao = DateTime.parse(json['data_atualizacao']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this._id;
    data['id_produto'] = this._idProduto;
    data['imagem'] = this._imagem;
    data['ehdeletado'] = this._ehDeletado;
    data['data_cadastro'] = this._dataCadastro.toString();
    data['data_atualizacao'] = this._dataAtualizacao.toString();
    return data;
  }
}
