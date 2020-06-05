import 'dart:convert';

import 'package:common_files/common_files.dart';

class ConfiguraoCadastroDAO implements IEntityDAO {
  HasuraBloc _hasuraBloc;
  AppGlobalBloc _appGlobalBloc;
  final String tableName = "configuracao_cadastro";
  int filterId = 0;
  String filterText = "";

  ConfiguracaoCadastro _configuracaoCadastro;
  List<ConfiguracaoCadastro> _configuracaoCadastroList;

  @override
  Dao dao;

  ConfiguraoCadastroDAO(this._hasuraBloc, this._configuracaoCadastro, this._appGlobalBloc) {
    dao = Dao();
    //dao.createDb();
  }

  @override
  IEntity fromMap(Map<String, dynamic> map) {
    try {
      this._configuracaoCadastro.id = map['id'];
      this._configuracaoCadastro.idPessoaGrupo = map['id_pessoa_grupo'];
      this._configuracaoCadastro.ehProdutoAutoInc = map['eh_produto_autoinc'];
      this._configuracaoCadastro.dataCadastro = DateTime.parse(map['data_cadastro']);
      this._configuracaoCadastro.dataAtualizacao = DateTime.parse(map['data_atualizacao']);
    } catch(error, stacktrace) {
      _appGlobalBloc.logger.e(error.toString(), '<configuracao_cadastroDao> fromMap');
      log(_hasuraBloc, _appGlobalBloc,
        nomeArquivo: "configuracao_cadastroDao",
        nomeFuncao: "fromMap",
        error: error.toString(),
        stacktrace: stacktrace.toString()
      );
    }   
    return this._configuracaoCadastro;
  }

  @override
  Future<List> getAll({bool preLoad = false}) async {
    String where;
    try {
      where = "id_pessoa_grupo = ${_appGlobalBloc.loja.idPessoaGrupo} ";
      List<dynamic> args = [];

      if (filterText != "") {
        where = where + "and (nome like '%" + filterText + "%') ";
      }

      List list = await dao.getList(this, where, args);
      _configuracaoCadastroList = List.generate(list.length, (i) {
        return ConfiguracaoCadastro(
          id: list[i]['id'],
          idPessoaGrupo: list[i]['id_pessoa_grupo'],
          ehProdutoAutoInc: list[i]['eh_produto_autoinc'],
          dataCadastro: list[i]['data_cadastro'] != null ? DateTime.parse(list[i]['data_cadastro']) : null,
          dataAtualizacao: list[i]['data_atualizacao'] != null ? DateTime.parse(list[i]['data_atualizacao']) : null,
        );
      });
    } catch(error, stacktrace) {
      _appGlobalBloc.logger.e(error.toString(), '<configuracao_cadastroDao> getAll');
      log(_hasuraBloc, _appGlobalBloc,
        nomeArquivo: "configuracao_cadastroDao",
        nomeFuncao: "getAll",
        error: error.toString(),
        stacktrace: stacktrace.toString(),
        query: where
      );
    }   
    return _configuracaoCadastroList;
  }

  Future<List> getAllFromServer({bool preLoad=false, bool id=false, bool idPessoaGrupo=false,
    bool ehProdutoAutoInc=false, bool dataCadastro=false, bool dataAtualizacao=false, 
    DateTime filtroDataAtualizacao}) async {
    String query;
    try {
      query = """ 
        {
          configuracao_cadastro(where: {
            data_atualizacao: {${filtroDataAtualizacao != null ? '_gt:  '+'"${filtroDataAtualizacao.toIso8601String()}"' : ''}}}, 
            order_by: {data_atualizacao: asc}) {
              ${id ? "id" : ""}
              ${idPessoaGrupo ? "id_pessoa_grupo" : ""}
              ${ehProdutoAutoInc ? "eh_produto_autoinc" : ""}
              ${dataCadastro ? "data_cadastro" : ""}
              ${dataAtualizacao ? "data_atualizacao" : ""}
          }
        }
      """;

      var data = await _hasuraBloc.hasuraConnect.query(query);
      _configuracaoCadastroList = [];

        for(var i = 0; i < data['data']['configuracao_cadastro'].length; i++){
          _configuracaoCadastroList.add(
            ConfiguracaoCadastro(
              id: data['data']['configuracao_cadastro'][i]['id'],
              idPessoaGrupo: data['data']['configuracao_cadastro'][i]['id_pessoa_grupo'],
              ehProdutoAutoInc: data['data']['configuracao_cadastro'][i]['eh_produto_autoinc'],
              dataCadastro: data['data']['configuracao_cadastro'][i]['data_cadastro'] != null ? DateTime.parse(data['data']['categoria'][i]['data_cadastro']) : null,
              dataAtualizacao: data['data']['configuracao_cadastro'][i]['data_atualizacao'] != null ? DateTime.parse(data['data']['categoria'][i]['data_atualizacao']) : null
            )       
          );
        }
    } catch(error, stacktrace) {
      _appGlobalBloc.logger.e(error.toString(), '<configuracao_cadastroDao> getAllFromServer');
      log(_hasuraBloc, _appGlobalBloc,
        nomeArquivo: "getAllFromServerDao",
        nomeFuncao: "fromMap",
        error: error.toString(),
        stacktrace: stacktrace.toString(),
        query: query
      );
    }   
    return _configuracaoCadastroList;
  }
  
  @override
  Future<IEntity> getById(int id) async {
    try {
      return await dao.getById(this, id);
    } catch(error, stacktrace) {
      _appGlobalBloc.logger.e(error.toString(), '<configuracao_cadastroDao> getAllFromServer');
      log(_hasuraBloc, _appGlobalBloc,
        nomeArquivo: "getAllFromServerDao",
        nomeFuncao: "fromMap",
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
    //       id_pessoa_grupo
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
    //   idPessoaGrupo: data['data']['categoria'][0]['id_pessoa_grupo'],
    //   nome: data['data']['categoria'][0]['nome'],
    //   ehDeletado: data['data']['categoria'][0]['ehdeletado'],
    //   dataCadastro: DateTime.parse(data['data']['categoria'][0]['data_cadastro']),
    //   dataAtualizacao: DateTime.parse(data['data']['categoria'][0]['data_atualizacao'])
    // );
     return _configuracaoCadastro;
  }

  Future<DateTime> getUltimaSincronizacao() async {
    try {
      List<Map> data = await dao.getRawQuery("select max(data_atualizacao) as data_atualizacao from configuracao_cadastro where id_pessoa_grupo = ${_appGlobalBloc.loja.idPessoaGrupo} ");
      return data[0]['data_atualizacao'] != null ? DateTime.tryParse(data[0]['data_atualizacao']) : DateTime.parse("2019-01-01T00:00:01.000000");
    } catch(error, stacktrace) {
      _appGlobalBloc.logger.e(error.toString(), '<configuracao_cadastroDao> getUltimaSincronizacao');
      log(_hasuraBloc, _appGlobalBloc,
        nomeArquivo: "configuracao_cadastroDao",
        nomeFuncao: "getUltimaSincronizacao",
        error: error.toString(),
        stacktrace: stacktrace.toString(),
      );
      return DateTime.now();
    }   
  }

  @override
  Future<IEntity> insert() async {
    try {
      this._configuracaoCadastro.id = await dao.insert(this);
    } catch(error, stacktrace) {
      _appGlobalBloc.logger.e(error.toString(), '<configuracao_cadastroDao> insert');
      log(_hasuraBloc, _appGlobalBloc,
        nomeArquivo: "configuracao_cadastroDao",
        nomeFuncao: "insert",
        error: error.toString(),
        stacktrace: stacktrace.toString(),
        object: this._configuracaoCadastro.toString()
      );
    }   
    return this._configuracaoCadastro;
  }

  Future<IEntity> saveOnServer() async {
    String _query;
    try {
      _query = """  mutation saveConfiguracaoCadastro {
        update_sincronizacao(where: {}, _set: {data_atualizacao: "now()"}) {
          returning {
            data_atualizacao
          }
        }

        insert_configuracao_cadastro(objects: {
      """;      

      if ((_configuracaoCadastro.id != null) && (_configuracaoCadastro.id > 0)) {
        _query = _query + "id: ${_configuracaoCadastro.id},";
      }    

      _query = _query + """
          eh_produto_autoinc: ${_configuracaoCadastro.ehProdutoAutoInc}, 
          data_atualizacao: "now()"},
          on_conflict: {
            constraint: categoria_pkey, 
            update_columns: [
              eh_produto_autoinc,
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
      _configuracaoCadastro.id = data["data"]["configuracao_cadastro"]["returning"][0]["id"];
      return _configuracaoCadastro;
    } catch(error, stacktrace) {
      _appGlobalBloc.logger.e(error.toString(), '<configuracao_cadastroDao> saveOnServer');
      log(_hasuraBloc, _appGlobalBloc,
        nomeArquivo: "configuracao_cadastroDao",
        nomeFuncao: "saveOnServer",
        error: error.toString(),
        stacktrace: stacktrace.toString(),
        query: _query,
        object: _configuracaoCadastro.toString()
      );
      return null;
    }   
  }

  @override
  Future<IEntity> delete(int id) async {
    return _configuracaoCadastro;
  }  

  @override
  Map<String, dynamic> toMap() {
    try {
      return {
        'id': this._configuracaoCadastro.id,
        'id_pessoa_grupo': this._configuracaoCadastro.idPessoaGrupo,
        'eh_produto_autoinc': this._configuracaoCadastro.ehProdutoAutoInc,
        'data_cadastro': this._configuracaoCadastro.dataCadastro.toString(),
        'data_atualizacao': this._configuracaoCadastro.dataAtualizacao.toString(),
      };
    } catch(error, stacktrace) {
      _appGlobalBloc.logger.e(error.toString(), '<configuracao_cadastroDao> toMap');
      log(_hasuraBloc, _appGlobalBloc,
        nomeArquivo: "configuracao_cadastroDao",
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
