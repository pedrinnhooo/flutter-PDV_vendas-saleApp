import '../../../../../common_files.dart';

class ProdutoVariante implements IEntity {
  int _id;
  int _idProduto;
  int _idVariante;
  int _ehDeletado;
  DateTime _dataCadastro;
  DateTime _dataAtualizacao;
  Variante _variante;

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

  ProdutoVariante.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _idProduto = json['id_produto'];
    _idVariante = json['id_variante'];
    _ehDeletado = json['ehdeletado'];
    _dataCadastro = json['data_cadastro'] == null ? null : DateTime.parse(json['data_cadastro']);
    _dataAtualizacao = json['data_atualizacao'] == null ? null :  DateTime.parse(json['data_atualizacao']);
    _variante = json['variante'] != null
        ? new Variante.fromJson(json['variante'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this._id;
    data['idProduto'] = this._idProduto;
    data['idVariante'] = this._idVariante;
    data['ehDeletado'] = this._ehDeletado;
    data['dataCadastro'] = this._dataCadastro;
    data['dataAtualizacao'] = this._dataAtualizacao;
    data['variante'] = this._variante != null ? this._variante.toJson() : null;
    return data;
  }
}
