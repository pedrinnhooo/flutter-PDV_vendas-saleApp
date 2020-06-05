import 'dart:convert';

import 'package:common_files/common_files.dart';
import 'package:common_files/src/model/entities/configuracao/tutorial/tutorial.dart';

class TutorialDAO implements IEntityDAO {
  HasuraBloc _hasuraBloc;
  AppGlobalBloc _appGlobalBloc;
  final String tableName = "tutorial";
  int filterId = 0;
  String filterText = "";

  Tutorial _tutorial;
  List<Tutorial> _tutorialList;

  @override
  Dao dao;

  TutorialDAO(this._hasuraBloc, this._tutorial, this._appGlobalBloc) {
    dao = Dao();
    //dao.createDb();
  }

  @override
  IEntity fromMap(Map<String, dynamic> map) {
    try {
      this._tutorial.id = map['id'];
      this._tutorial.idPessoaGrupo = map['id_pessoa_grupo'];
      this._tutorial.idPessoa = map['id_pessoa'];
      this._tutorial.passo = map['passo'];
      this._tutorial.ehConcluido = map['ehconcluido'];
      this._tutorial.modulo = map['modulo'];
      this._tutorial.ehVisualizado = map['ehvisualizado'];
      this._tutorial.dataCadastro = DateTime.parse(map['data_cadastro']);
      this._tutorial.dataAtualizacao = DateTime.parse(map['data_atualizacao']);
    } catch(error, stacktrace) {
      _appGlobalBloc.logger.e(error.toString(), '<tutorialDao> fromMap');
      log(_hasuraBloc, _appGlobalBloc,
        nomeArquivo: "tutorialDao",
        nomeFuncao: "fromMap",
        error: error.toString(),
        stacktrace: stacktrace.toString()
      );
    }
    return this._tutorial;
  }

  @override
  Future<List> getAll({bool preLoad = false}) async {
    String where;
    try {
      where = "id_pessoa_grupo = ${_appGlobalBloc.loja.idPessoaGrupo} ";
      List<dynamic> args = [];

      if (filterText != "") {
        where = where + "and (modulo = '$filterText')";
      }

      List list = await dao.getList(this, where, args);
      _tutorialList = List.generate(list.length, (i) {
        return Tutorial(
          id: list[i]['id'],
          idPessoaGrupo: list[i]['id_pessoa_grupo'],
          idPessoa: list[i]['id_pessoa'],
          passo: list[i]['passo'],
          ehConcluido: list[i]['ehconcluido'],
          modulo: list[i]['modulo'],
          ehVisualizado: list[i]['ehvisualizado'],
          dataCadastro: list[i]['data_cadastro'] != null ? DateTime.parse(list[i]['data_cadastro']) : null,
          dataAtualizacao: list[i]['data_atualizacao'] != null ? DateTime.parse(list[i]['data_atualizacao']) : null,
        );
      });
    } catch(error, stacktrace) {
      _appGlobalBloc.logger.e(error.toString(), '<tutorialDao> getAll');
      log(_hasuraBloc, _appGlobalBloc,
        nomeArquivo: "tutorialDao",
        nomeFuncao: "getAll",
        error: error.toString(),
        stacktrace: stacktrace.toString(),
        query: where
      );
    }
    return _tutorialList;
  }

  Future<List> getAllFromServer({bool id=false, bool idPessoaGrupo=false,
    bool idPessoa=false, bool passo=false, bool ehConcluido=false, bool modulo=false, bool ehVisualizado=false, bool dataCadastro=false, bool dataAtualizacao=false, 
    DateTime filtroDataAtualizacao}) async {
    String query;
    try {
      query = """ 
        {
          tutorial(where: {
            data_atualizacao: {${filtroDataAtualizacao != null ? '_gt:  '+'"${filtroDataAtualizacao.toIso8601String()}"' : ''}}}, 
            order_by: {data_atualizacao: asc}) {
              ${id ? "id" : ""}
              ${idPessoaGrupo ? "id_pessoa_grupo" : ""}
              ${idPessoa ? "id_pessoa" : ""}
              ${passo ? "passo" : ""}
              ${ehConcluido ? "ehconcluido" : ""}
              ${modulo ? "modulo" : ""}
              ${ehVisualizado ? "ehvisualizado" : ""}
              ${dataCadastro ? "data_cadastro" : ""}
              ${dataAtualizacao ? "data_atualizacao" : ""}
          }
        }
      """;

      var data = await _hasuraBloc.hasuraConnect.query(query);
      _tutorialList = [];

      for(var i = 0; i < data['data']['tutorial'].length; i++){
        _tutorialList.add(
          Tutorial(
            id: data['data']['tutorial'][i]['id'],
            idPessoaGrupo: data['data']['tutorial'][i]['id_pessoa_grupo'],
            idPessoa: data['data']['tutorial'][i]['id_pessoa'],
            passo: data['data']['tutorial'][i]['passo'],
            ehConcluido: data['data']['tutorial'][i]['ehconcluido'],
            modulo: data['data']['tutorial'][i]['modulo'],
            ehVisualizado: data['data']['tutorial'][i]['ehvisualizado'],
            dataCadastro: data['data']['tutorial'][i]['data_cadastro'] != null ? DateTime.parse(data['data']['categoria'][i]['data_cadastro']) : null,
            dataAtualizacao: data['data']['tutorial'][i]['data_atualizacao'] != null ? DateTime.parse(data['data']['categoria'][i]['data_atualizacao']) : null
          )       
        );
      }
    } catch(error, stacktrace) {
      _appGlobalBloc.logger.e(error.toString(), '<tutorialDao> getAllFromServer');
      log(_hasuraBloc, _appGlobalBloc,
        nomeArquivo: "tutorialDao",
        nomeFuncao: "getAllFromServer",
        error: error.toString(),
        stacktrace: stacktrace.toString(),
        query: query
      );
    }
    return _tutorialList;
  }
  
  @override
  Future<IEntity> getById(int id) async {
    try {
      return await dao.getById(this, id);
    } catch(error, stacktrace) {
      _appGlobalBloc.logger.e(error.toString(), '<tutorialDao> getById');
      log(_hasuraBloc, _appGlobalBloc,
        nomeArquivo: "tutorialDao",
        nomeFuncao: "getById",
        error: error.toString(),
        stacktrace: stacktrace.toString(),
        query: "id: $id"
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
     return _tutorial;
  }

  Future<DateTime> getUltimaSincronizacao() async {
    try {
      List<Map> data = await dao.getRawQuery("select max(data_atualizacao) as data_atualizacao from tutorial where id_pessoa_grupo = ${_appGlobalBloc.loja.idPessoaGrupo} ");
      return data[0]['data_atualizacao'] != null ? DateTime.tryParse(data[0]['data_atualizacao']) : DateTime.parse("2019-01-01T00:00:01.000000");
    } catch(error, stacktrace) {
      _appGlobalBloc.logger.e(error.toString(), '<tutorialDao> getUltimaSincronizacao');
      log(_hasuraBloc, _appGlobalBloc,
        nomeArquivo: "tutorialDao",
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
      this._tutorial.idPessoaGrupo = _appGlobalBloc.loja.idPessoaGrupo;
      this._tutorial.idPessoa = _appGlobalBloc.loja.idPessoa;
      this._tutorial.id = await dao.insert(this);
    } catch(error, stacktrace) {
      _appGlobalBloc.logger.e(error.toString(), '<tutorialDao> insert');
      log(_hasuraBloc, _appGlobalBloc,
        nomeArquivo: "tutorialDao",
        nomeFuncao: "insert",
        error: error.toString(),
        stacktrace: stacktrace.toString(),
        object: this.toString()
      );
    }
    return this._tutorial;
  }

  Future<IEntity> saveOnServer() async {
    String _query;
    try {
      _query = """  mutation saveTutorial {
        update_sincronizacao(where: {}, _set: {data_atualizacao: "now()"}) {
          returning {
            data_atualizacao
          }
        }

        insert_tutorial(objects: {
      """;      

      if ((_tutorial.id != null) && (_tutorial.id > 0)) {
        _query = _query + "id: ${_tutorial.id},";
      }    

      _query = _query + """
          passo: ${_tutorial.passo}, 
          ehconcluido: ${_tutorial.ehConcluido}, 
          modulo: "${_tutorial.modulo}", 
          ehvisualizado: ${_tutorial.ehVisualizado}, 
          data_atualizacao: "now()"},
          on_conflict: {
            constraint: tutorial_pkey, 
            update_columns: [
              passo,
              passo_venda_cor,
              modulo,
              ehvisualizado,
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
      _tutorial.id = data["data"]["tutorial"]["returning"][0]["id"];
      return _tutorial;
    } catch(error, stacktrace) {
      _appGlobalBloc.logger.e(error.toString(), '<tutorialDao> saveOnServer');
      log(_hasuraBloc, _appGlobalBloc,
        nomeArquivo: "tutorialDao",
        nomeFuncao: "saveOnServer",
        error: error.toString(),
        stacktrace: stacktrace.toString(),
        query: _query,
        object: _tutorial.toString()
      );
      return null;
    }
  }

  @override
  Future<IEntity> delete(int id) async {
    return _tutorial;
  }  

  @override
  Map<String, dynamic> toMap() {
    try {
      return {
        'id': this._tutorial.id,
        'id_pessoa_grupo': this._tutorial.idPessoaGrupo,
        'id_pessoa': this._tutorial.idPessoa,
        'passo': this._tutorial.passo,
        'ehconcluido': this._tutorial.ehConcluido,
        'modulo': this._tutorial.modulo,
        'ehvisualizado': this._tutorial.ehVisualizado,
        'data_cadastro': this._tutorial.dataCadastro.toString(),
        'data_atualizacao': this._tutorial.dataAtualizacao.toString(),
      };
    } catch(error, stacktrace) {
      _appGlobalBloc.logger.e(error.toString(), '<tutorialDao> toMap');
      log(_hasuraBloc, _appGlobalBloc,
        nomeArquivo: "tutorialDao",
        nomeFuncao: "toMap",
        error: error.toString(),
        stacktrace: stacktrace.toString(),
        object: this.toString(),
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
