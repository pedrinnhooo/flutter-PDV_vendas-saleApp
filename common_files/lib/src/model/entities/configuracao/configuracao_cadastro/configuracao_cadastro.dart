import 'package:common_files/common_files.dart';

class ConfiguracaoCadastro implements IEntity{
  int _id;
  int _idPessoaGrupo;
  int _ehProdutoAutoInc;
  DateTime _dataCadastro;
  DateTime _dataAtualizacao;

  ConfiguracaoCadastro({
    int id,
    int idPessoaGrupo,
    int ehProdutoAutoInc=0,
    DateTime dataCadastro,
    DateTime dataAtualizacao,
  }) {
    this._id = id;
    this._idPessoaGrupo = idPessoaGrupo;
    this._ehProdutoAutoInc = ehProdutoAutoInc;
    this._dataCadastro = dataCadastro == null ? DateTime.now() : dataCadastro;
    this._dataAtualizacao = dataAtualizacao == null ? DateTime.now() : dataAtualizacao;
  }

  int get id => _id;
  set id(int id) => _id = id;
  int get idPessoaGrupo => _idPessoaGrupo;
  set idPessoaGrupo(int idPessoaGrupo) => _idPessoaGrupo = idPessoaGrupo;
  int get ehProdutoAutoInc => _ehProdutoAutoInc;
  set ehProdutoAutoInc(int ehProdutoAutoInc) => _ehProdutoAutoInc = ehProdutoAutoInc;
  DateTime get dataCadastro => _dataCadastro;
  set dataCadastro(DateTime dataCadastro) => _dataCadastro = dataCadastro;
  DateTime get dataAtualizacao => _dataAtualizacao;
  set dataAtualizacao(DateTime dataAtualizacao) => _dataAtualizacao = dataAtualizacao;

  String toString() {
    return '''
      id: ${_id.toString()},    
      idPessoaGrupo: ${_idPessoaGrupo.toString()},  
      ehProdutoAutoInc: ${_ehProdutoAutoInc.toString()},  
      dataCadastro: ${_dataCadastro.toString()}, 
      dataAtualizacao: ${_dataAtualizacao.toString()}
    ''';  
  }

  ConfiguracaoCadastro.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _idPessoaGrupo = json['id_pessoa_grupo'];
    _ehProdutoAutoInc = json['eh_produto_autoinc'];
    _dataCadastro = DateTime.parse(json['data_cadastro']);
    _dataAtualizacao = DateTime.parse(json['data_atualizacao']);
  }

}  