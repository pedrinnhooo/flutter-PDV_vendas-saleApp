import 'dart:convert';
import 'package:common_files/common_files.dart';

class LogErroDAO implements IEntityDAO {
  HasuraBloc _hasuraBloc;
  AppGlobalBloc _appGlobalBloc;
  final String tableName = "log_erro";
  int filterId = 0;
  String filterText = "";
  FilterEhSincronizado filterEhSincronizado = FilterEhSincronizado.naoSincronizados;
  LogErro logErro;
  List<LogErro> logErroList;

  @override
  Dao dao;

  LogErroDAO(this._hasuraBloc, this._appGlobalBloc, this.logErro) {
    dao = Dao();
  }

  @override
  IEntity fromMap(Map<String, dynamic> map) {
    this.logErro.id = map['id'];
    this.logErro.idApp = map['id_app'];
    this.logErro.idPessoaGrupo = map['id_pessoa_grupo'];
    this.logErro.idPessoa = map['id_pessoa'];
    this.logErro.nomeArquivo = map['nome_arquivo'];
    this.logErro.nomeFuncao = map['nome_funcao'];
    this.logErro.error = map['error'];
    this.logErro.stacktrace = map['stacktrace'];
    this.logErro.object = map['object'];
    this.logErro.query = map['query'];
    this.logErro.ehsincronizado = map['ehsincronizado'];
    this.logErro.dataCadastro = DateTime.parse(map['data_cadastro']);
    this.logErro.dataAtualizacao = DateTime.parse(map['data_atualizacao']);
    return this.logErro;
  }

  @override
  Future<List> getAll({bool preLoad = false}) async {
    String where = "id_pessoa = ${_appGlobalBloc.loja.id} ";
    List<dynamic> args = [];

    if (filterEhSincronizado != FilterEhSincronizado.todos) {
      where = filterEhSincronizado == FilterEhSincronizado.sincronizados ? where + "and ehsincronizado = 1 " : 
        where + "and ((ehsincronizado = 0) or (ehsincronizado ISNULL)) "; 
    }

    List list = await dao.getList(this, where, args);
    logErroList = List.generate(list.length, (i) {
      return LogErro(
        id: list[i]['id'],
        idApp: list[i]['id_app'],
        idPessoaGrupo: list[i]['id_pessoa_grupo'],
        idPessoa: list[i]['id_pessoa'],
        nomeArquivo: list[i]['nome_arquivo'],
        nomeFuncao: list[i]['nome_funcao'],
        error: list[i]['error'],
        stacktrace: list[i]['stacktrace'],
        object: list[i]['object'],
        query: list[i]['query'],
        ehsincronizado: list[i]['ehsincronizado'],
        dataCadastro: list[i]['data_cadastro'] != null ? DateTime.parse(list[i]['data_cadastro']) : null,
        dataAtualizacao: list[i]['data_atualizacao'] != null ? DateTime.parse(list[i]['data_atualizacao']) : null,
      );
    });
    return logErroList;
  }

  Future<List> getAllFromServer({bool preLoad=false, bool id=false, bool idApp=false, bool idPessoaGrupo=false, bool idPessoa=false,
    bool nomeArquivo=false,  bool nomeFuncao=false, bool error=false, 
    bool stacktrace=false, bool object=false, bool query=false, bool ehsincronizado=false,
    bool dataCadastro=false, bool dataAtualizacao=false, String filtroNome="",
    DateTime filtroDataAtualizacao, int offset = 0}) async {
    String _query = """ 
      {
        log_erro(limit: $queryLimit, offset: $offset, where: {
          nome_arquivo: {${filtroNome != "" ? '_ilike:  '+'"$filtroNome%"' : ''}},
          data_atualizacao: {${filtroDataAtualizacao != null ? '_gt:  '+'"${filtroDataAtualizacao.toIso8601String()}"' : ''}}}, 
          order_by: {${filtroDataAtualizacao == null ? 'nome: asc' : 'data_atualizacao: asc'}}) {
            ${id ? "id" : ""}
            ${idApp ? "id_app" : ""}
            ${idPessoaGrupo ? "id_pessoa_grupo" : ""}
            ${idPessoa ? "id_pessoa" : ""}
            nome_arquivo
            ${nomeFuncao ? "nome_funcao" : ""}
            ${error ? "error" : ""}
            ${stacktrace ? "stacktrace" : ""}
            ${object ? "object" : ""}
            ${query ? "query" : ""}
            ${ehsincronizado ? "ehsincronizado" : ""}
            ${dataCadastro ? "data_cadastro" : ""}
            ${dataAtualizacao ? "data_atualizacao" : ""}
        }
      }
    """;

    var data = await _hasuraBloc.hasuraConnect.query(_query);
    logErroList = [];

    for(var i = 0; i < data['data']['log_erro'].length; i++){
      logErroList.add(
        LogErro(
          id: data['data']['log_erro'][i]['id'],
          idApp: data['data']['log_erro'][i]['id_app'],
          idPessoaGrupo: data['data']['log_erro'][i]['id_pessoa_grupo'],
          idPessoa: data['data']['log_erro'][i]['id_pessoa'],
          nomeArquivo: data['data']['log_erro'][i]['nome_arquivo'],
          nomeFuncao: data['data']['log_erro'][i]['nome_funcao'],
          error: data['data']['log_erro'][i]['error'],
          stacktrace: data['data']['log_erro'][i]['stacktrace'],
          object: data['data']['log_erro'][i]['object'],
          query: data['data']['log_erro'][i]['query'],
          ehsincronizado: data['data']['log_erro'][i]['ehsincronizado'],
          dataCadastro: data['data']['log_erro'][i]['data_cadastro'] != null ? DateTime.parse(data['data']['log_erro'][i]['data_cadastro']) : null,
          dataAtualizacao: data['data']['log_erro'][i]['data_atualizacao'] != null ? DateTime.parse(data['data']['log_erro'][i]['data_atualizacao']) : null
        )       
      );
    }
    return logErroList;
  }
  
  @override
  Future<IEntity> getById(int id) async {
    return await dao.getById(this, id);
  }

  Future<IEntity> getByIdFromServer(int id) async {
    String _query = """ 
      {
        log_erro(where: {id: {_eq: $id}}) {
          id
          id_app
          id_pessoa_grupo
          id_pessoa
          nome_arquivo
          nome_funcao
          error
          stacktrace
          object
          query
          ehsincronizado
          data_cadastro
          data_atualizacao
        }
      }
    """;

    var data = await _hasuraBloc.hasuraConnect.query(_query);
    LogErro _logErro = LogErro(
      id: data['data']['log_erro'][0]['id'],
      idApp: data['data']['log_erro'][0]['id_app'],
      idPessoaGrupo: data['data']['log_erro'][0]['id_pessoa_grupo'],
      idPessoa: data['data']['log_erro'][0]['id_pessoa'],
      nomeArquivo: data['data']['log_erro'][0]['nome_arquivo'],
      nomeFuncao: data['data']['log_erro'][0]['nome_funcao'],
      error: data['data']['log_erro'][0]['error'],
      stacktrace: data['data']['log_erro'][0]['stacktrace'],
      object: data['data']['log_erro'][0]['object'],
      query: data['data']['log_erro'][0]['query'],
      ehsincronizado: data['data']['log_erro'][0]['ehsincronizado'],
      dataCadastro: DateTime.parse(data['data']['log_erro'][0]['data_cadastro']),
      dataAtualizacao: DateTime.parse(data['data']['log_erro'][0]['data_atualizacao'])
    );
    return _logErro;
  }

  Future<DateTime> getUltimaSincronizacao() async {
    List<Map> data = await dao.getRawQuery("select max(data_atualizacao) as data_atualizacao from log_erro where id_pessoa = ${_appGlobalBloc.loja.id} ");
    return data[0]['data_atualizacao'] != null ? DateTime.tryParse(data[0]['data_atualizacao']) : DateTime.parse("2019-01-01T00:00:01.000000");
  }

  @override
  Future<IEntity> insert() async {
    this.logErro.idPessoaGrupo = _appGlobalBloc.loja.idPessoaGrupo; 
    this.logErro.idPessoa = _appGlobalBloc.loja.id; 
    this.logErro.idApp = await dao.insert(this);
    return this.logErro;
  }

  Future<IEntity> saveOnServer() async {
    String _query = """  mutation saveLogErro {
      insert_log_erro(objects: {
    """;      

    if ((logErro.id != null) && (logErro.id > 0)) {
      _query = _query + "id: ${logErro.id},";
    }    

    _query = _query + """
        id_app: ${logErro.idApp.toString()},
        nome_arquivo: "${logErro.nomeArquivo}", 
        nome_funcao: "${logErro.nomeFuncao}", 
        error: "${logErro.error}", 
        stacktrace: "${logErro.stacktrace}", 
        object: "${logErro.object}", 
        query: "${logErro.query}", 
        ehsincronizado: ${logErro.ehsincronizado}, 
        data_atualizacao: "now()"},
        on_conflict: {
          constraint: log_erro_pkey, 
          update_columns: [
            nome_arquivo, 
            nome_funcao,
            error,
            stacktrace,
            object,
            query,
            ehsincronizado,
            data_atualizacao
          ]
        }) {
        returning {
          id
        }
      }
    }  
    """; 

    print("<LogErroDAO> saveOnServer query = $_query");

    try {
      var data = await _hasuraBloc.hasuraConnect.mutation(_query);
      logErro.id = data["data"]["insert_log_erro"]["returning"][0]["id"];
      return logErro;
    } catch (error) {
      print("<LogErroDAO> Exception: $error");
      return null;
    }  
  }

  @override
  Future<IEntity> delete(int id) async {
    return this.logErro;
  }  

  @override
  Map<String, dynamic> toMap() {
    return {
      'id': this.logErro.id,
      'id_app': this.logErro.idApp,
      'id_pessoa_grupo': this.logErro.idPessoaGrupo,
      'id_pessoa': this.logErro.idPessoa,
      'nome_arquivo': this.logErro.nomeArquivo,
      'nome_funcao': this.logErro.nomeFuncao,
      'error': this.logErro.error,
      'stacktrace': this.logErro.stacktrace,
      'object': this.logErro.object,
      'query': this.logErro.query,
      'ehsincronizado': this.logErro.ehsincronizado,
      'data_cadastro': this.logErro.dataCadastro.toString(),
      'data_atualizacao': this.logErro.dataAtualizacao.toString(),
    };
  }

  String entityToJson() {
    final dyn = toMap();
    return json.encode(dyn);
  }

  IEntity entityFromJson(String str) {
    final jsonData = json.decode(str);
    return fromMap(jsonData);
  }
}
