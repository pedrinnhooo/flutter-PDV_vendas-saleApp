import 'dart:convert';

import 'package:common_files/common_files.dart';

class ConfiguracaoPessoaDAO implements IEntityDAO {
  HasuraBloc _hasuraBloc;
  AppGlobalBloc _appGlobalBloc;
  final String tableName = "configuracao_pessoa";
  int filterId = 0;

  ConfiguracaoPessoa _configuracaoPessoa;
  List<ConfiguracaoPessoa> _configuracaoPessoaList;

  @override
  Dao dao;

  ConfiguracaoPessoaDAO(this._hasuraBloc, this._configuracaoPessoa, this._appGlobalBloc) {
    dao = Dao();
  }

  @override
  IEntity fromMap(Map<String, dynamic> map) {
    try {
      this._configuracaoPessoa.id = map['id'];
      this._configuracaoPessoa.idPessoa = map['id_pessoa'];
      this._configuracaoPessoa.textoCabecalho = map['texto_cabecalho'];
      this._configuracaoPessoa.textoRodape = map['texto_rodape'];
      this._configuracaoPessoa.dataCadastro = DateTime.parse(map['data_cadastro']);
      this._configuracaoPessoa.dataAtualizacao = DateTime.parse(map['data_atualizacao']);
    } catch(error, stacktrace) {
      _appGlobalBloc.logger.e(error.toString(), '<configuracao_pessoaDao> fromMap');
      log(_hasuraBloc, _appGlobalBloc,
        nomeArquivo: "configuracao_pessoaDao",
        nomeFuncao: "fromMap",
        error: error.toString(),
        stacktrace: stacktrace.toString()
      );
    }   
    return this._configuracaoPessoa;
  }

  @override
  Future<List> getAll({bool preLoad = false}) async {
    String where;
    try {
      where = "id_pessoa = ${_appGlobalBloc.loja.idPessoa} ";
      List<dynamic> args = [];

      List list = await dao.getList(this, where, args);
      _configuracaoPessoaList = List.generate(list.length, (i) {
        return ConfiguracaoPessoa(
          id: list[i]['id'],
          idPessoa: list[i]['id_pessoa'],
          textoCabecalho: list[i]['texto_cabecalho'],
          textoRodape: list[i]['text_rodape'],
          dataCadastro: list[i]['data_cadastro'] != null ? DateTime.parse(list[i]['data_cadastro']) : null,
          dataAtualizacao: list[i]['data_atualizacao'] != null ? DateTime.parse(list[i]['data_atualizacao']) : null,
        );
      });
    } catch(error, stacktrace) {
      _appGlobalBloc.logger.e(error.toString(), '<configuracao_pessoaDao> getAll');
      log(_hasuraBloc, _appGlobalBloc,
        nomeArquivo: "configuracao_pessoaDao",
        nomeFuncao: "getAll",
        error: error.toString(),
        stacktrace: stacktrace.toString(),
        query: where
      );
    }   
    return _configuracaoPessoaList;
  }

  Future<List> getAllFromServer({bool preLoad=false, bool id=false, bool idPessoa=false,
    bool textoCabecalho=false, bool textoRodape=false, bool dataCadastro=false, bool dataAtualizacao=false, 
    DateTime filtroDataAtualizacao}) async {
    String query;
    try {
      query = """ 
        {
          configuracao_pessoa(where: {
            data_atualizacao: {${filtroDataAtualizacao != null ? '_gt:  '+'"${filtroDataAtualizacao.toIso8601String()}"' : ''}}}, 
            order_by: {data_atualizacao: asc}) {
              ${id ? "id" : ""}
              ${idPessoa ? "id_pessoa" : ""}
              ${textoCabecalho ? "texto_cabecalho" : ""}
              ${textoRodape ? "texto_rodape" : ""}
              ${dataCadastro ? "data_cadastro" : ""}
              ${dataAtualizacao ? "data_atualizacao" : ""}
          }
        }
      """;

      print("<ConfiguracaoPessoaDAO> query: $query");
      var data = await _hasuraBloc.hasuraConnect.query(query);
      print("<ConfiguracaoPessoaDAO> data: ${data.toString()}");
      _configuracaoPessoaList = [];

      for(var i = 0; i < data['data']['configuracao_pessoa'].length; i++){
        _configuracaoPessoaList.add(
          ConfiguracaoPessoa(
            id: data['data']['configuracao_pessoa'][i]['id'],
            idPessoa: data['data']['configuracao_pessoa'][i]['id_pessoa'],
            textoCabecalho: data['data']['configuracao_pessoa'][i]['texto_cabecalho'],
            textoRodape: data['data']['configuracao_pessoa'][i]['texto_rodape'],
            dataCadastro: data['data']['configuracao_pessoa'][i]['data_cadastro'] != null ? DateTime.parse(data['data']['configuracao_pessoa'][i]['data_cadastro']) : null,
            dataAtualizacao: data['data']['configuracao_pessoa'][i]['data_atualizacao'] != null ? DateTime.parse(data['data']['configuracao_pessoa'][i]['data_atualizacao']) : null
          )       
        );
      }
    } catch(error, stacktrace) {
      _appGlobalBloc.logger.e(error.toString(), '<configuracao_pessoaDao> getAllFromServer');
      log(_hasuraBloc, _appGlobalBloc,
        nomeArquivo: "configuracao_pessoaDao",
        nomeFuncao: "getAllFromServer",
        error: error.toString(),
        stacktrace: stacktrace.toString(),
        query: query
      );
      _configuracaoPessoaList = null;
    }   
    return _configuracaoPessoaList;
  }
  
  @override
  Future<IEntity> getById(int id) async {
    try {
      return await dao.getById(this, id);
    } catch(error, stacktrace) {
      _appGlobalBloc.logger.e(error.toString(), '<configuracao_pessoaDao> getById');
      log(_hasuraBloc, _appGlobalBloc,
        nomeArquivo: "configuracao_pessoaDao",
        nomeFuncao: "getById",
        error: error.toString(),
        stacktrace: stacktrace.toString(),
        query: "id: ${id.toString()}"
      );
      return null;
    }   
  }

  Future<IEntity> getByIdFromServer(int id) async {
    // String query = """ 
    //   {
    //     categoria(where: {id: {_eq: $id}}) {
    //       id
    //       id_pessoa
    //       nome
    //       ehdeletado
    //       data_cadastro
    //       data_atualizacao
    //     }
    //   }
    // """;

    // var data = await _hasuraBloc.hasuraConnect.query(query);
    // Categoria _categoria = Categoria(
    //   id: data['data']['categoria'][0]['id'],
    //   idPessoa: data['data']['categoria'][0]['id_pessoa'],
    //   nome: data['data']['categoria'][0]['nome'],
    //   ehDeletado: data['data']['categoria'][0]['ehdeletado'],
    //   dataCadastro: DateTime.parse(data['data']['categoria'][0]['data_cadastro']),
    //   dataAtualizacao: DateTime.parse(data['data']['categoria'][0]['data_atualizacao'])
    // );
     return _configuracaoPessoa;
  }

  Future<DateTime> getUltimaSincronizacao() async {
    try {
      String query = "select max(data_atualizacao) as data_atualizacao from configuracao_pessoa where id_pessoa = ${_appGlobalBloc.loja.id}";
      List<Map> data = await dao.getRawQuery(query);
      return data[0]['data_atualizacao'] != null ? DateTime.tryParse(data[0]['data_atualizacao']) : DateTime.parse("2019-01-01T00:00:01.000000");
    } catch(error, stacktrace) {
      _appGlobalBloc.logger.e(error.toString(), '<configuracao_pessoaDao> getUltimaSincronizacao');
      log(_hasuraBloc, _appGlobalBloc,
        nomeArquivo: "configuracao_pessoaDao",
        nomeFuncao: "getUltimaSincronizacao",
        error: error.toString(),
        stacktrace: stacktrace.toString()
      );
      return DateTime.now();
    }   
  }

  @override
  Future<IEntity> insert() async {
    try {
      this._configuracaoPessoa.id = await dao.insert(this);
      return this._configuracaoPessoa;
    } catch(error, stacktrace) {
      _appGlobalBloc.logger.e(error.toString(), '<configuracao_pessoaDao> insert');
      log(_hasuraBloc, _appGlobalBloc,
        nomeArquivo: "configuracao_pessoaDao",
        nomeFuncao: "insert",
        error: error.toString(),
        stacktrace: stacktrace.toString(),
        object: this._configuracaoPessoa.toString()
      );
      return null;
    }   
  }

  Future<IEntity> saveOnServer() async {
    String _query;
    try {
      _query = """  mutation saveConfiguracaoPessoa {
        update_sincronizacao(where: {}, _set: {data_atualizacao: "now()"}) {
          returning {
            data_atualizacao
          }
        }

        insert_configuracao_pessoa(objects: {
      """;      

      if ((_configuracaoPessoa.id != null) && (_configuracaoPessoa.id > 0)) {
        _query = _query + "id: ${_configuracaoPessoa.id},";
      }    

      _query = _query + """
          texto_cabecalho: ${_configuracaoPessoa.textoCabecalho}, 
          texto_rodape: ${_configuracaoPessoa.textoRodape}, 
          data_atualizacao: "now()"},
          on_conflict: {
            constraint: categoria_pkey, 
            update_columns: [
              texto_cabecalho,
              texto_rodape,
              data_atualizacao
            ]
          }) {
          returning {
            id
          }
        }
      }  
      """; 

      var data = await _hasuraBloc.hasuraConnect.mutation(_query);
      _configuracaoPessoa.id = data["data"]["configuracao_pessoa"]["returning"][0]["id"];
      return _configuracaoPessoa;
    } catch(error, stacktrace) {
      _appGlobalBloc.logger.e(error.toString(), '<configuracao_pessoaDao> saveOnServer');
      log(_hasuraBloc, _appGlobalBloc,
        nomeArquivo: "configuracao_pessoaDao",
        nomeFuncao: "saveOnServer",
        error: error.toString(),
        stacktrace: stacktrace.toString(),
        query: _query,
        object: _configuracaoPessoa.toString()
      );
      return null;
    }   
  }

  @override
  Future<IEntity> delete(int id) async {
    return _configuracaoPessoa;
  }  

  @override
  Map<String, dynamic> toMap() {
    try {
      return {
        'id': this._configuracaoPessoa.id,
        'id_pessoa': this._configuracaoPessoa.idPessoa,
        'texto_cabecalho': this._configuracaoPessoa.textoCabecalho,
        'texto_rodape': this._configuracaoPessoa.textoRodape,
        'data_cadastro': this._configuracaoPessoa.dataCadastro.toString(),
        'data_atualizacao': this._configuracaoPessoa.dataAtualizacao.toString(),
      };
    } catch(error, stacktrace) {
      _appGlobalBloc.logger.e(error.toString(), '<configuracao_pessoaDao> toMap');
      log(_hasuraBloc, _appGlobalBloc,
        nomeArquivo: "configuracao_pessoaDao",
        nomeFuncao: "toMap",
        error: error.toString(),
        stacktrace: stacktrace.toString()
      );
      return null;
    }   
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
