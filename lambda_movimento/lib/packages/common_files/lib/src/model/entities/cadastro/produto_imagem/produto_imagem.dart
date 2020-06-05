import 'package:common_files/src/model/entities/interfaces.dart';

class ProdutoImagem extends IEntity {
  int _id;
  int _idProduto;
  String _imagem;
  DateTime _dataCadastro;
  DateTime _dataAtualizacao;

  ProdutoImagem(
      {int id,
      int idProduto,
      String imagem,
      DateTime dataCadastro,
      DateTime dataAtualizacao}) {
    this._id = id;
    this._idProduto = idProduto;
    this._imagem = imagem;
    this._dataCadastro = dataCadastro;
    this._dataAtualizacao = dataAtualizacao;
  }

  int get id => _id;
  set id(int id) => _id = id;
  int get idProduto => _idProduto;
  set idProduto(int idProduto) => _idProduto = idProduto;
  String get imagem => _imagem;
  set imagem(String imagem) => _imagem = imagem;
  DateTime get dataCadastro => _dataCadastro;
  set dataCadastro(DateTime dataCadastro) => _dataCadastro = dataCadastro;
  DateTime get dataAtualizacao => _dataAtualizacao;
  set dataAtualizacao(DateTime dataAtualizacao) =>
      _dataAtualizacao = dataAtualizacao;

  ProdutoImagem.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _idProduto = json['id_produto'];
    _imagem = json['imagem'];
    _dataCadastro = json['data_cadastro'];
    _dataAtualizacao = json['data_atualizacao'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this._id;
    data['id_produto'] = this._idProduto;
    data['imagem'] = this._imagem;
    data['data_cadastro'] = this._dataCadastro;
    data['data_atualizacao'] = this._dataAtualizacao;
    return data;
  }
}
