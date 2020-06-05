import '../../../../../common_files.dart';

class PrecoTabelaItem implements IEntity {
  int _id;
  int _idPrecoTabela;
  int _idProduto;
  double _preco;
  DateTime _dataCadastro;
  DateTime _dataAtualizacao;

  PrecoTabelaItem(
      {int id,
      int idPrecoTabela = 1,
      int idProduto,
      double preco,
      DateTime dataCadastro,
      DateTime dataAtualizacao}) {
    this._id = id;
    this._idPrecoTabela = idPrecoTabela;
    this._idProduto = idProduto;
    this._preco = preco;
    this._dataCadastro = dataCadastro == null ? DateTime.now() : dataCadastro;
    this._dataAtualizacao = dataAtualizacao == null ? DateTime.now() : dataAtualizacao;
  }

  int get id => _id;
  set id(int id) => _id = id;
  int get idPrecoTabela => _idPrecoTabela;
  set idPrecoTabela(int idPrecoTabela) => _idPrecoTabela = idPrecoTabela;
  int get idProduto => _idProduto;
  set idProduto(int idProduto) => _idProduto = idProduto;
  double get preco => _preco;
  set preco(double preco) => _preco = preco;
  DateTime get dataCadastro => _dataCadastro;
  set dataCadastro(DateTime dataCadastro) => _dataCadastro = dataCadastro;
  DateTime get dataAtualizacao => _dataAtualizacao;
  set dataAtualizacao(DateTime dataAtualizacao) =>
      _dataAtualizacao = dataAtualizacao;

  PrecoTabelaItem.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _idPrecoTabela = json['id_preco_tabela'];
    _idProduto = json['id_produto'];
    _preco = double.parse(json['preco'].toString());
    _dataCadastro = json['data_cadastro'] == null ? null : DateTime.parse(json['data_cadastro']);
    _dataAtualizacao = json['data_atualizacao'] == null ? null :  DateTime.parse(json['data_atualizacao']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this._id;
    data['id_preco_tabela'] = this._idPrecoTabela;
    data['id_produto'] = this._idProduto;
    data['preco'] = this._preco.toDouble();
    data['data_cadastro'] = this._dataCadastro.toString();
    data['data_atualizacao'] = this._dataAtualizacao.toString();
    return data;
  }
}
