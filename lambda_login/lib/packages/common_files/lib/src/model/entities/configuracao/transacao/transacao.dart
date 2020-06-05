import '../../../../../common_files.dart';

class Transacao implements IEntity {
  int _id;
  int _idPessoaGrupo;
  int _idPrecoTabela;
  String _nome;
  int _tipoEstoque; // 0 - Saida / 1 - Entrada
  int _temPagamento;
  int _temVendedor;
  int _temCliente;
  int _ehDeletado;
  double _descontoPercentual;
  DateTime _dataCadastro;
  DateTime _dataAtualizacao;
  PrecoTabela _precoTabela;

  Transacao(
      {int id,
      int idPessoaGrupo,
      int idPrecoTabela = 1,
      String nome,
      int tipoEstoque = 0,
      int temPagamento = 0,
      int temVendedor = 0,
      int temCliente = 0,
      int ehDeletado = 0,
      double descontoPercentual = 0,
      DateTime dataCadastro,
      DateTime dataAtualizacao,
      PrecoTabela precoTabela}) {
    this._id = id;
    this._idPessoaGrupo = idPessoaGrupo;
    this._idPrecoTabela = idPrecoTabela;
    this._nome = nome;
    this._tipoEstoque = tipoEstoque;
    this._temPagamento = temPagamento;
    this._temVendedor = temVendedor;
    this._temCliente = temCliente;
    this._ehDeletado = ehDeletado;
    this._descontoPercentual = descontoPercentual;
    this._dataCadastro = dataCadastro;
    this._dataAtualizacao = dataAtualizacao;
    this._precoTabela = precoTabela == null ? PrecoTabela() : precoTabela;
  }

  int get id => _id;
  set id(int id) => _id = id;
  int get idPessoaGrupo => _idPessoaGrupo;
  set idPessoaGrupo(int idPessoaGrupo) => _idPessoaGrupo = idPessoaGrupo;
  int get idPrecoTabela => _idPrecoTabela;
  set idPrecoTabela(int idPrecoTabela) => _idPrecoTabela = idPrecoTabela;
  String get nome => _nome;
  set nome(String nome) => _nome = nome;
  int get tipoEstoque => _tipoEstoque;
  set tipoEstoque(int tipoEstoque) => _tipoEstoque = tipoEstoque;
  int get temPagamento => _temPagamento;
  set temPagamento(int temPagamento) => _temPagamento = temPagamento;
  int get temVendedor => _temVendedor;
  set temVendedor(int temVendedor) => _temVendedor = temVendedor;
  int get temCliente => _temCliente;
  set temCliente(int temCliente) => _temCliente = temCliente;
  int get ehDeletado => _ehDeletado;
  set ehDeletado(int ehDeletado) => _ehDeletado = ehDeletado;
  double get descontoPercentual => _descontoPercentual;
  set descontoPercentual(double descontoPercentual) =>
      _descontoPercentual = descontoPercentual;
  DateTime get dataCadastro => _dataCadastro;
  set dataCadastro(DateTime dataCadastro) => _dataCadastro = dataCadastro;
  DateTime get dataAtualizacao => _dataAtualizacao;
  set dataAtualizacao(DateTime dataAtualizacao) =>
      _dataAtualizacao = dataAtualizacao;
  PrecoTabela get precoTabela => _precoTabela;
  set precoTabela(PrecoTabela precoTabela) => 
      _precoTabela = precoTabela;      

  Transacao.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _idPessoaGrupo = json['id_pessoa_grupo'];
    _idPrecoTabela = json['id_preco_tabela'];
    _nome = json['nome'];
    _tipoEstoque = json['tipo_estoque'];
    _temPagamento = json['tem_pagamento'];
    _temVendedor = json['tem_vendedor'];
    _temCliente = json['tem_cliente'];
    _ehDeletado = json['ehdeletado'];
    _descontoPercentual = json['desconto_percentual'];
    _dataCadastro = DateTime.parse(json['data_cadastro']);
    _dataAtualizacao = DateTime.parse(json['data_atualizacao']);
    if (json['preco_tabela'] != null) {
      _precoTabela = PrecoTabela.fromJson(json);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this._id;
    data['id_pessoa_grupo'] = this._idPessoaGrupo;
    data['id_preco_tabela'] = this._idPrecoTabela;
    data['nome'] = this._nome;
    data['tipo_estoque'] = this._tipoEstoque;
    data['tem_pagamento'] = this._temPagamento;
    data['tem_vendedor'] = this._temVendedor;
    data['tem_cliente'] = this._temCliente;
    data['ehdeletado'] = this._ehDeletado;
    data['desconto_percentual'] = this._descontoPercentual.toDouble();
    data['data_cadastro'] = this._dataCadastro.toString();
    data['data_atualizacao'] = this._dataAtualizacao.toString();
    return data;
  }
}