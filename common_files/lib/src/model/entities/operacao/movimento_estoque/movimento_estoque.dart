import 'package:common_files/common_files.dart';

class MovimentoEstoque extends IEntity{
  int _id;
  int _idPessoaGrupo;
  int _idPessoa;
  DateTime _dataMovimento;
  int _ehAtualizado;
  DateTime _dataCadastro;
  DateTime _dataAtualizacao;
  List<MovimentoEstoqueItem> _movimentoEstoqueItem;
  
  MovimentoEstoque({int id, int idPessoaGrupo, int idPessoa, DateTime dataMovimento, 
    int ehAtualizado, DateTime dataCadastro, DateTime dataAtualizacao,
    List<MovimentoEstoqueItem> movimentoEstoqueItem}){
    this._id = id;
    this._idPessoaGrupo = idPessoaGrupo;
    this._idPessoa = idPessoa;
    this._dataMovimento = dataMovimento;
    this._ehAtualizado = ehAtualizado;
    this._dataCadastro = dataCadastro;
    this._dataAtualizacao = dataAtualizacao;
    this._movimentoEstoqueItem = movimentoEstoqueItem == null ? [] : movimentoEstoqueItem;
  }

  int get id => _id;
  set id(int id) => _id = id;
  int get idPessoaGrupo => _idPessoaGrupo;
  set idPessoaGrupo(int idPessoaGrupo) => _idPessoaGrupo = idPessoaGrupo;
  int get idPessoa => _idPessoa;
  set idPessoa(int idPessoa) => _idPessoa = idPessoa;
  DateTime get dataMovimento => _dataMovimento;
  set dataMovimento(DateTime dataMovimento) => _dataMovimento = dataMovimento;
  int get ehAtualizado => _ehAtualizado;
  set ehAtualizado(int ehAtualizado) => _ehAtualizado = ehAtualizado;
  DateTime get dataCadastro => _dataCadastro;
  set dataCadastro(DateTime dataCadastro) => _dataCadastro = dataCadastro;
  DateTime get dataAtualizacao => _dataAtualizacao;
  set dataAtualizacao(DateTime dataAtualizacao) => _dataAtualizacao = dataAtualizacao;
  List<MovimentoEstoqueItem> get movimentoEstoqueItem => _movimentoEstoqueItem;
  set movimentoEstoqueItem(List<MovimentoEstoqueItem> movimentoEstoqueItem) =>
      _movimentoEstoqueItem = movimentoEstoqueItem;

  String toString() {
    return '''
      id: ${_id.toString()},    
      idPessoaGrupo: ${_idPessoaGrupo.toString()},  
      idPessoa: ${_idPessoa.toString()},  
      dataMovimento: ${_dataMovimento.toString()},  
      ehAtualizado: ${_ehAtualizado.toString()}, 
      dataCadastro: ${_dataCadastro.toString()}, 
      dataAtualizacao: ${_dataAtualizacao.toString()}
    ''';  
  }

  MovimentoEstoque.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _idPessoaGrupo = json['id_pessoa_grupo'];
    _idPessoa = json['id_pessoa'];
    _dataMovimento = json['data_movimento'];
    _ehAtualizado = json['ehatualizado'];
    _dataCadastro = DateTime.parse(json['data_cadastro']);
    _dataAtualizacao = DateTime.parse(json['data_atualizacao']);
    if (json['movimento_estoque_item'] != null) {
      _movimentoEstoqueItem = new List<MovimentoEstoqueItem>();
      json['movimento_estoque_item'].forEach((v) {
        _movimentoEstoqueItem.add(new MovimentoEstoqueItem.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this._id;
    data['id_pessoa_grupo'] = this._idPessoaGrupo;
    data['id_pessoa'] = this._idPessoa;
    data['data_movimento'] = this._dataMovimento;
    data['ehatualizado'] = this._ehAtualizado;
    data['data_cadastro'] = this._dataCadastro.toString();
    data['data_atualizacao'] = this._dataAtualizacao.toString();
    if (this._movimentoEstoqueItem != null) {
      data['movimento_estoque_item'] =
          this._movimentoEstoqueItem.map((v) => v.toJson()).toList();
    }
    return data;
  }
}