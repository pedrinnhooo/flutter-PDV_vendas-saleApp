import 'package:common_files/common_files.dart';

class LogErro implements IEntity {
  int _id;
  int _idApp;
  int _idPessoaGrupo;
  int _idPessoa;
  String _nomeArquivo;
  String _nomeFuncao;
  String _error;
  String _stacktrace;
  String _object;
  String _query;
  int _ehsincronizado;
  DateTime _dataCadastro;
  DateTime _dataAtualizacao;

  LogErro(
      {int id,
      int idApp,
      int idPessoaGrupo,
      int idPessoa,
      String nomeArquivo,
      String nomeFuncao,
      String error,
      String stacktrace,
      String object,
      String query,
      int ehsincronizado = 0,
      DateTime dataCadastro,
      DateTime dataAtualizacao}) {
    this._id = id;
    this._idApp = idApp;
    this._idPessoaGrupo = idPessoaGrupo;
    this._idPessoa = idPessoa;
    this._nomeArquivo = nomeArquivo;
    this._nomeFuncao = nomeFuncao;
    this._error = error;
    this._stacktrace = stacktrace;
    this._object = object;
    this._query = query;
    this._ehsincronizado = ehsincronizado;
    this._dataCadastro = dataCadastro == null ? DateTime.now() : dataCadastro;
    this._dataAtualizacao = dataAtualizacao == null ? DateTime.now() : dataAtualizacao;
  }

  int get id => _id;
  set id(int id) => _id = id;
  int get idApp => _idApp;
  set idApp(int idApp) => _idApp = idApp;
  int get idPessoaGrupo => _idPessoaGrupo;
  set idPessoaGrupo(int idPessoaGrupo) => _idPessoaGrupo = idPessoaGrupo;
  int get idPessoa => _idPessoa;
  set idPessoa(int idPessoa) => _idPessoa = idPessoa;
  String get nomeArquivo => _nomeArquivo;
  set nomeArquivo(String nomeArquivo) => _nomeArquivo = nomeArquivo;
  String get nomeFuncao => _nomeFuncao;
  set nomeFuncao(String nomeFuncao) => _nomeFuncao = nomeFuncao;
  String get error => _error;
  set error(String error) => _error = error;
  String get stacktrace => _stacktrace;
  set stacktrace(String stacktrace) => _stacktrace = stacktrace;
  String get object => _object;
  set object(String object) => _object = object;
  String get query => _query;
  set query(String query) => _query = query;
  int get ehsincronizado => _ehsincronizado;
  set ehsincronizado(int ehsincronizado) => _ehsincronizado = ehsincronizado;
  DateTime get dataCadastro => _dataCadastro;
  set dataCadastro(DateTime dataCadastro) => _dataCadastro = dataCadastro;
  DateTime get dataAtualizacao => _dataAtualizacao;
  set dataAtualizacao(DateTime dataAtualizacao) =>
      _dataAtualizacao = dataAtualizacao;

  String toString() {
    return '''
      id: ${_id.toString()},    
      idApp: ${_idApp.toString()},    
      idPessoaGrupo: ${_idPessoaGrupo.toString()},  
      idPessoa: ${_idPessoa.toString()},  
      nome_arquivo: $_nomeArquivo, 
      nome_funcao: $_nomeFuncao, 
      error: $_error, 
      stacktrace: $_stacktrace, 
      object: $_object,
      query: $_query,
      ehsincronizado: $_ehsincronizado, 
      dataCadastro: ${_dataCadastro.toString()}, 
      dataAtualizacao: ${_dataAtualizacao.toString()}
    ''';  
  }

  LogErro.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _idApp = json['id_app'];
    _idPessoaGrupo = json['id_pessoa_grupo'];
    _idPessoa = json['id_pessoa'];
    _nomeArquivo = json['nome_arquivo'];
    _nomeFuncao = json['nome_funcao'];
    _error = json['error'];
    _stacktrace = json['stacktrace'];
    _object = json['object'];
    _query = json['query'];
    _ehsincronizado = json['ehsincronizado'];
    _dataCadastro = DateTime.parse(json['data_cadastro']);
    _dataAtualizacao = DateTime.parse(json['data_atualizacao']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this._id;
    data['id_app'] = this._idApp;
    data['id_pessoa_grupo'] = this._idPessoaGrupo;
    data['id_pessoa'] = this._idPessoa;
    data['nome_arquivo'] = this._nomeArquivo;
    data['nome_funcao'] = this._nomeFuncao;
    data['error'] = this._error;
    data['stacktrace'] = this._stacktrace;
    data['object'] = this._object;
    data['query'] = this._query;
    data['ehsincronizado'] = this._ehsincronizado;
    data['data_cadastro'] = this._dataCadastro;
    data['data_atualizacao'] = this._dataAtualizacao;
    return data;
  }

  static List<Categoria> fromJsonList(List list){
    if(list == null) return null;
    return list
      .map((item) => Categoria.fromJson(item))
      .toList();
  }  
}
