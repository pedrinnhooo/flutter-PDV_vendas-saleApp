import 'package:common_files/common_files.dart';

class Tutorial implements IEntity{
  int _id;
  int _idPessoaGrupo;
  int _idPessoa;
  int _passo;
  int _ehConcluido;
  int _ehVisualizado;
  String _modulo;
  DateTime _dataCadastro;
  DateTime _dataAtualizacao;

  Tutorial({
    int id,
    int idPessoaGrupo,
    int idPessoa,
    int passo,
    int ehConcluido = 0,
    int ehVisualizado = 0,
    String modulo,
    DateTime dataCadastro,
    DateTime dataAtualizacao,
  }) {
    this._id = id;
    this._idPessoaGrupo = idPessoaGrupo;
    this._idPessoa = idPessoa;
    this._passo = passo;
    this._ehConcluido = ehConcluido;
    this._ehVisualizado = ehVisualizado;
    this._modulo = modulo;
    this._dataCadastro = dataCadastro == null ? DateTime.now() : dataCadastro;
    this._dataAtualizacao = dataAtualizacao == null ? DateTime.now() : dataAtualizacao;
  }

  int get id => _id;
  set id(int id) => _id = id;
  int get idPessoaGrupo => _idPessoaGrupo;
  set idPessoaGrupo(int idPessoaGrupo) => _idPessoaGrupo = idPessoaGrupo;
  int get idPessoa => _idPessoa;
  set idPessoa(int idPessoa) => _idPessoa = idPessoa;
  int get passo => _passo;
  set passo(int passo) => _passo = passo;
  int get ehConcluido => _ehConcluido;
  set ehConcluido(int ehConcluido) => _ehConcluido = ehConcluido;
  int get ehVisualizado => _ehVisualizado;
  set ehVisualizado(int ehVisualizado) => _ehVisualizado = ehVisualizado;
  String get modulo => _modulo;
  set modulo(String modulo) => _modulo = modulo;
  DateTime get dataCadastro => _dataCadastro;
  set dataCadastro(DateTime dataCadastro) => _dataCadastro = dataCadastro;
  DateTime get dataAtualizacao => _dataAtualizacao;
  set dataAtualizacao(DateTime dataAtualizacao) => _dataAtualizacao = dataAtualizacao;

  String toString() {
    return '''
      id: ${_id.toString()},    
      idPessoaGrupo: ${_idPessoaGrupo.toString()},  
      idPessoa: ${_idPessoa.toString()},  
      passo: ${_passo.toString()},  
      ehConcluido: ${_ehConcluido.toString()},  
      ehVisualizado: ${_ehVisualizado.toString()},  
      modulo: $_modulo, 
      dataCadastro: ${_dataCadastro.toString()}, 
      dataAtualizacao: ${_dataAtualizacao.toString()}
    ''';  
  }  

  Tutorial.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _idPessoaGrupo = json['id_pessoa_grupo'];
    _idPessoa = json['id_pessoa'];
    _passo = json['passo'];
    _ehConcluido = json['ehconcluido'];
    _modulo = json['modulo'];
    _ehVisualizado = json['ehvisualizado '];
    _dataCadastro = DateTime.parse(json['data_cadastro']);
    _dataAtualizacao = DateTime.parse(json['data_atualizacao']);
  }

}  