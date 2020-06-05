import 'package:common_files/common_files.dart';

class MovimentoEstoqueItem extends IEntity{
  int _id;
  int _idPessoa;
  int _idMovimentoEstoque;
  int _idProduto;
  int _idVariante;
  int _gradePosicao;
  TipoAtualizacaoEstoque _tipoAtualizacaoEstoque;
  double _quantidade;
  DateTime _dataCadastro;
  DateTime _dataAtualizacao;
  
  MovimentoEstoqueItem({int id, int idPessoa, int idMovimentoEstoque, int idProduto, 
           int idVariante, int gradePosicao, TipoAtualizacaoEstoque tipoAtualizacaoEstoque,
           double quantidade=0, DateTime dataCadastro, DateTime dataAtualizacao}){
    this._id = id;
    this._idPessoa = idPessoa;
    this._idMovimentoEstoque = idMovimentoEstoque;
    this._idProduto = idProduto;
    this._idVariante = idVariante;
    this._gradePosicao = gradePosicao;
    this._tipoAtualizacaoEstoque = tipoAtualizacaoEstoque;
    this._quantidade = quantidade;
    this._dataCadastro = dataCadastro;
    this._dataAtualizacao = dataAtualizacao;
  }

  int get id => _id;
  set id(int id) => _id = id;
  int get idPessoa => _idPessoa;
  set idPessoa(int idPessoa) => _idPessoa = idPessoa;
  int get idMovimentoEstoque => _idMovimentoEstoque;
  set idMovimentoEstoque(int idMovimentoEstoque) => _idMovimentoEstoque = idMovimentoEstoque;
  int get idProduto => _idProduto;
  set idProduto(int idProduto) => _idProduto = idProduto;
  int get idVariante => _idVariante;
  set idVariante(int idVariante) => _idVariante = idVariante;
  int get gradePosicao => _gradePosicao;
  set gradePosicao(int gradePosicao) => _gradePosicao = gradePosicao;
  TipoAtualizacaoEstoque get tipoAtualizacaoEstoque => _tipoAtualizacaoEstoque;
  set tipoAtualizacaoEstoque(TipoAtualizacaoEstoque tipoAtualizacaoEstoque) => _tipoAtualizacaoEstoque = tipoAtualizacaoEstoque;
  double get quantidade => _quantidade;
  set quantidade(double quantidade) => _quantidade = quantidade;
  DateTime get dataCadastro => _dataCadastro;
  set dataCadastro(DateTime dataCadastro) => _dataCadastro = dataCadastro;
  DateTime get dataAtualizacao => _dataAtualizacao;
  set dataAtualizacao(DateTime dataAtualizacao) => _dataAtualizacao = dataAtualizacao;

  String toString() {
    return '''
      id: ${_id.toString()},    
      idPessoa: ${_idPessoa.toString()},  
      idMovimentoEstoque: ${_idMovimentoEstoque.toString()},  
      idProduto: ${_idProduto.toString()},  
      idVariante: ${_idVariante.toString()},  
      gradePosicao: ${_gradePosicao.toString()},  
      tipoAtualizacaoEstoque: ${_tipoAtualizacaoEstoque.index.toString()},  
      quantidade: ${_quantidade.toString()},  
      dataCadastro: ${_dataCadastro.toString()}, 
      dataAtualizacao: ${_dataAtualizacao.toString()}
    ''';  
  }

  MovimentoEstoqueItem.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _idPessoa = json['id_pessoa'];
    _idMovimentoEstoque = json['id_movimento_estoque'];
    _idProduto = json['id_produto'];
    _idVariante = json['id_variante'];
    _gradePosicao = json['grade_posicao'];
    _tipoAtualizacaoEstoque = TipoAtualizacaoEstoque.values[json['tipo_atualizacao_estoque']];
    _quantidade = json['quantidade'].toDouble();
    _dataCadastro = DateTime.parse(json['data_cadastro']);
    _dataAtualizacao = DateTime.parse(json['data_atualizacao']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this._id;
    data['id_pessoa'] = this._idPessoa;
    data['id_movimento_estoque'] = this._idMovimentoEstoque;
    data['id_produto'] = this._idProduto;
    data['id_variante'] = this._idVariante;
    data['grade_posicao'] = this._gradePosicao;
    data['descricao'] = this._tipoAtualizacaoEstoque.index;
    data['tipo_atualizacao_estoque'] = this._quantidade;
    data['data_cadastro'] = this._dataCadastro.toString();
    data['data_atualizacao'] = this._dataAtualizacao.toString();
    return data;
  }
}