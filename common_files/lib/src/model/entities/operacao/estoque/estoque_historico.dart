import 'package:common_files/common_files.dart';

class EstoqueHistorico extends IEntity{
  int _id;
  int _idPessoa;
  int _idMovimento;
  DateTime _dataMovimento;
  int _idProduto;
  int _idVariante;
  int _gradePosicao;
  String _descricao;
  double _quantidade;
  double _estoqueNovo;
  DateTime _dataCadastro;
  DateTime _dataAtualizacao;
  String _gradeDescricao;
  Produto _produto;
  Variante _variante;
  
  EstoqueHistorico({int id, int idPessoa, int idMovimento, DateTime dataMovimento, int idProduto, 
           int idVariante, int gradePosicao, String descricao, double quantidade=0, double estoqueNovo=0,
           DateTime dataCadastro, DateTime dataAtualizacao, String gradeDescricao, 
           Produto produto, Variante variante}){
    this._id = id;
    this._idPessoa = idPessoa;
    this._idMovimento = idMovimento;
    this._dataMovimento = dataMovimento;
    this._idProduto = idProduto;
    this._idVariante = idVariante;
    this._gradePosicao = gradePosicao;
    this._descricao = descricao;
    this._quantidade = quantidade;
    this._estoqueNovo = estoqueNovo;
    this._dataCadastro = dataCadastro;
    this._dataAtualizacao = dataAtualizacao;
    this._gradeDescricao = gradeDescricao;
    this._produto = produto;
    this._variante = variante;
  }

  int get id => _id;
  set id(int id) => _id = id;
  int get idPessoa => _idPessoa;
  set idPessoa(int idPessoa) => _idPessoa = idPessoa;
  int get idMovimento => _idMovimento;
  set idMovimento(int idMovimento) => _idMovimento = idMovimento;
  DateTime get dataMovimento => _dataMovimento;
  set dataMovimento(DateTime dataMovimento) => _dataMovimento = dataMovimento;
  int get idProduto => _idProduto;
  set idProduto(int idProduto) => _idProduto = idProduto;
  int get idVariante => _idVariante;
  set idVariante(int idVariante) => _idVariante = idVariante;
  int get gradePosicao => _gradePosicao;
  set gradePosicao(int gradePosicao) => _gradePosicao = gradePosicao;
  String get descricao => _descricao;
  set descricao(String descricao) => _descricao = descricao;
  double get quantidade => _quantidade;
  set quantidade(double quantidade) => _quantidade = quantidade;
  double get estoqueNovo => _estoqueNovo;
  set estoqueNovo(double estoqueNovo) => _estoqueNovo = estoqueNovo;
  DateTime get dataCadastro => _dataCadastro;
  set dataCadastro(DateTime dataCadastro) => _dataCadastro = dataCadastro;
  DateTime get dataAtualizacao => _dataAtualizacao;
  set dataAtualizacao(DateTime dataAtualizacao) => _dataAtualizacao = dataAtualizacao;
  String get gradeDescricao => _gradeDescricao;
  set gradeDescricao(String gradeDescricao) => _gradeDescricao = gradeDescricao;
  Produto get produto => _produto;
  set produto(Produto produto) => _produto = produto;
  Variante get variante => _variante;
  set variante(Variante variante) => _variante = variante;

  String toString() {
    return '''
      id: ${_id.toString()},    
      idPessoa: ${_idPessoa.toString()},  
      idMovimento: ${_idMovimento.toString()},  
      dataMovimento: ${_dataMovimento.toString()},  
      idProduto: ${_idProduto.toString()},  
      idVariante: ${_idVariante.toString()},  
      gradePosicao: ${_gradePosicao.toString()},  
      descricao: $_descricao, 
      quantidade: ${_quantidade.toString()}, 
      estoqueNovo: ${_estoqueNovo.toString()}, 
      gradeDescricao: $_gradeDescricao, 
      dataCadastro: ${_dataCadastro.toString()}, 
      dataAtualizacao: ${_dataAtualizacao.toString()}
    ''';  
  }

  EstoqueHistorico.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _idPessoa = json['id_pessoa'];
    _idMovimento = json['id_movimento'];
    _dataMovimento = json['data_movimento'];
    _idProduto = json['id_produto'];
    _idVariante = json['id_variante'];
    _gradePosicao = json['grade_posicao'];
    _descricao = json['descricao'];
    _quantidade = json['quantidade'].toDouble();
    _estoqueNovo = json['estoque_novo'].toDouble();
    _dataCadastro = DateTime.parse(json['data_cadastro']);
    _dataAtualizacao = DateTime.parse(json['data_atualizacao']);
    //_produto = Produto.fromJson(json['produto']);
    _variante = Variante.fromJson(json['variante']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this._id;
    data['id_pessoa'] = this._idPessoa;
    data['id_movimento'] = this._idMovimento;
    data['data_movimento'] = this._dataMovimento;
    data['id_produto'] = this._idProduto;
    data['id_variante'] = this._idVariante;
    data['grade_posicao'] = this._gradePosicao;
    data['descricao'] = this._descricao;
    data['quantidade'] = this._quantidade;
    data['estoque_novo'] = this._estoqueNovo;
    data['data_cadastro'] = this._dataCadastro.toString();
    data['data_atualizacao'] = this._dataAtualizacao.toString();
    return data;
  }
}