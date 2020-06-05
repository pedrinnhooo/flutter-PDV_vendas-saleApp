import 'dart:convert';
import 'package:common_files/common_files.dart';

class AplicativoDAO implements IEntityDAO {
  HasuraBloc _hasuraBloc;
  AppGlobalBloc _appGlobalBloc;
  final String tableName = "aplicativo";
  int filterId = 0;
  String filterText = "";

  Aplicativo aplicativo;
  List<Aplicativo> aplicativoList;

  @override
  Dao dao;

  AplicativoDAO(this._hasuraBloc, this._appGlobalBloc, {this.aplicativo}) {
    dao = Dao();
  }

  @override
  IEntity fromMap(Map<String, dynamic> map) {
    try {
      this.aplicativo.id = map['id'];
      this.aplicativo.nome = map['nome'];
      this.aplicativo.key = map['key'];
      this.aplicativo.dataCadastro = DateTime.parse(map['data_cadastro']);
      this.aplicativo.dataAtualizacao = DateTime.parse(map['data_atualizacao']);
    } catch(error, stacktrace) {
      _appGlobalBloc.logger.e(error.toString(), '<aplicativoDao> fromMap');
      log(_hasuraBloc, _appGlobalBloc,
        nomeArquivo: "aplicativoDao",
        nomeFuncao: "fromMap",
        error: error.toString(),
        stacktrace: stacktrace.toString()
      );
    }   
    return this.aplicativo;
  }

  @override
  Future<List> getAll({bool preLoad = false}) async {
    String where = "";
    try {
      List<dynamic> args = [];

      if (filterText != "") {
        where = where + "and (nome like '%" + filterText + "%')";
      }

      List list = await dao.getList(this, where, args);
      aplicativoList = List.generate(list.length, (i) {
        return Aplicativo(
          id: list[i]['id'],
          nome: list[i]['nome'],
          key: list[i]['key'],
          dataCadastro: list[i]['data_cadastro'] != null ? DateTime.parse(list[i]['data_cadastro']) : null,
          dataAtualizacao: list[i]['data_atualizacao'] != null ? DateTime.parse(list[i]['data_atualizacao']) : null,
        );
      });
    } catch(error, stacktrace) {
      _appGlobalBloc.logger.e(error.toString(), '<aplicativoDao> getAll');
      log(_hasuraBloc, _appGlobalBloc,
        nomeArquivo: "aplicativoDao",
        nomeFuncao: "getAll",
        error: error.toString(),
        stacktrace: stacktrace.toString(),
        query: where
      );
    }   
    return aplicativoList;
  }

  Future<List> getAllFromServer({bool preLoad=false, bool completo=false, bool id=false, bool key=false, 
      bool dataCadastro=false, bool dataAtualizacao=false, String filtroNome="", String filtroKey="",
      DateTime filtroDataAtualizacao}) async {
    String query;
    try {
      String queryAplicativoVersao = "";

      if (preLoad) {
        queryAplicativoVersao = """
          aplicativo_versaos(where: {
            ehativo: {_eq: 1}}, 
            order_by: {id: asc}
            ) {
              id
              versao
              ehativo
              data_limite
              data_cadastro
              data_atualizacao
          }
        """;
      }
      
      query = """ 
        {
          aplicativo(where: {
            nome: {${filtroNome != '' ? '_ilike:  '+'"$filtroNome%"' : ''}},
            key: {${filtroKey != '' ? '_eq:  '+'"$filtroKey"' : ''}},
            data_atualizacao: {${filtroDataAtualizacao != null ? '_gt:  '+'"${filtroDataAtualizacao.toIso8601String()}"' : ''}}}, 
            order_by: {${filtroDataAtualizacao == null ? 'nome: asc' : 'data_atualizacao: asc'}}) {
              ${completo || id ? "id" : ""}
              nome
              ${completo || key ? "key" : ""}
              ${completo || dataCadastro ? "data_cadastro" : ""}
              ${completo || dataAtualizacao ? "data_atualizacao" : ""}
              ${queryAplicativoVersao != '' ? queryAplicativoVersao : ''}
          }
        }
      """;

      var data = await _hasuraBloc.hasuraConnect.query(query);
      aplicativoList = [];

      var aplicativoVersaoList = new List<AplicativoVersao>();

      for(var i = 0; i < data['data']['aplicativo'].length; i++){
        if (data['data']['aplicativo'][i]['aplicativo_versaos'] != null) {
          data['data']['aplicativo'][i]['aplicativo_versaos'].forEach((v) {
            aplicativoVersaoList.add(new AplicativoVersao.fromJson(v));
          });
        }

        aplicativoList.add(
          Aplicativo(
            id: data['data']['aplicativo'][i]['id'],
            nome: data['data']['aplicativo'][i]['nome'],
            key: data['data']['aplicativo'][i]['key'],
            dataCadastro: data['data']['aplicativo'][i]['data_cadastro'] != null ? DateTime.parse(data['data']['aplicativo'][i]['data_cadastro']) : null,
            dataAtualizacao: data['data']['aplicativo'][i]['data_atualizacao'] != null ? DateTime.parse(data['data']['aplicativo'][i]['data_atualizacao']) : null,
            aplicativoVersao: aplicativoVersaoList
          )       
        );
      }
    } catch(error, stacktrace) {
      _appGlobalBloc.logger.e(error.toString(), '<aplicativoDao> getAllFromServer');
      log(_hasuraBloc, _appGlobalBloc,
        nomeArquivo: "aplicativoDao",
        nomeFuncao: "getAllFromServer",
        error: error.toString(),
        stacktrace: stacktrace.toString(),
        query: query
      );
    }   
    return aplicativoList;
  }
  
  @override
  Future<IEntity> getById(int id) async {
    try {
      return await dao.getById(this, id);
    } catch(error, stacktrace) {
      _appGlobalBloc.logger.e(error.toString(), '<aplicativoDao> getById');
      log(_hasuraBloc, _appGlobalBloc,
        nomeArquivo: "aplicativoDao",
        nomeFuncao: "getById",
        error: error.toString(),
        stacktrace: stacktrace.toString(),
        query: "id: ${id.toString()}"
      );
      return null;
    }   
  }

  Future<IEntity> getByIdFromServer(int id) async {
    String query;
    try {
      query = """ 
        {
          aplicativo(where: {id: {_eq: $id}}) {
            id
            nome
            key
            data_cadastro
            data_atualizacao
          }
        }
      """;

      var data = await _hasuraBloc.hasuraConnect.query(query);
      Aplicativo _aplicativo = Aplicativo(
        id: data['data']['aplicativo'][0]['id'],
        nome: data['data']['aplicativo'][0]['nome'],
        key: data['data']['aplicativo'][0]['key'],
        dataCadastro: DateTime.parse(data['data']['aplicativo'][0]['data_cadastro']),
        dataAtualizacao: DateTime.parse(data['data']['aplicativo'][0]['data_atualizacao'])
      );
      return _aplicativo;
    } catch(error, stacktrace) {
      _appGlobalBloc.logger.e(error.toString(), '<aplicativoDao> getByIdFromServer');
      log(_hasuraBloc, _appGlobalBloc,
        nomeArquivo: "aplicativoDao",
        nomeFuncao: "getByIdFromServer",
        error: error.toString(),
        stacktrace: stacktrace.toString(),
        query: query
      );
      return null;
    }   
  }

  Future<DateTime> getUltimaSincronizacao() async {
    try {
      List<Map> data = await dao.getRawQuery("select max(data_atualizacao) as data_atualizacao from aplicativo");
      return data[0]['data_atualizacao'] != null ? DateTime.tryParse(data[0]['data_atualizacao']) : DateTime.parse("2019-01-01T00:00:01.000000");
    } catch(error, stacktrace) {
      _appGlobalBloc.logger.e(error.toString(), '<aplicativoDao> getUltimaSincronizacao');
      log(_hasuraBloc, _appGlobalBloc,
        nomeArquivo: "aplicativoDao",
        nomeFuncao: "getUltimaSincronizacao",
        error: error.toString(),
        stacktrace: stacktrace.toString()
      );
      return DateTime.now();
    }   
  }

  @override
  Future<IEntity> insert() async {
    //this.categoria.idPessoaGrupo = _appGlobalBloc.loja.idPessoaGrupo; 
    try {
      this.aplicativo.id = await dao.insert(this);
      return this.aplicativo;
    } catch(error, stacktrace) {
      _appGlobalBloc.logger.e(error.toString(), '<aplicativoDao> insert');
      log(_hasuraBloc, _appGlobalBloc,
        nomeArquivo: "aplicativoDao",
        nomeFuncao: "insert",
        error: error.toString(),
        stacktrace: stacktrace.toString(),
        object: this.aplicativo.toString()
      );
      return null;
    }   
  }

  Future<IEntity> saveOnServer() async {
    // String _query = """  mutation saveCategoria {
    //   update_sincronizacao(where: {}, _set: {data_atualizacao: "now()"}) {
    //     returning {
    //       data_atualizacao
    //     }
    //   }

    //   insert_categoria(objects: {
    // """;      

    // if ((categoria.id != null) && (categoria.id > 0)) {
    //   _query = _query + "id: ${categoria.id},";
    // }    

    // _query = _query + """
    //     nome: "${categoria.nome}", 
    //     ehdeletado: ${categoria.ehDeletado}, 
    //     ehservico: ${categoria.ehServico},
    //     data_atualizacao: "now()"},
    //     on_conflict: {
    //       constraint: categoria_pkey, 
    //       update_columns: [
    //         nome, 
    //         ehdeletado,
    //         ehservico,
    //         data_atualizacao
    //       ]
    //     }) {
    //     returning {
    //       id
    //     }
    //   }
    // }  
    // """; 

    // try {
    //   var data = await _hasuraBloc.hasuraConnect.mutation(_query);
    //   categoria.id = data["data"]["insert_categoria"]["returning"][0]["id"];
    //   return categoria;
    // } catch (error) {
    //   return null;
    // }  
  }

  @override
  Future<IEntity> delete(int id) async {
    return this.aplicativo;
  }  

  @override
  Map<String, dynamic> toMap() {
    try {
      return {
        'id': this.aplicativo.id,
        'nome': this.aplicativo.nome,
        'key': this.aplicativo.key,
        'data_cadastro': this.aplicativo.dataCadastro.toString(),
        'data_atualizacao': this.aplicativo.dataAtualizacao.toString(),
      };
    } catch(error, stacktrace) {
      _appGlobalBloc.logger.e(error.toString(), '<aplicativoDao> toMap');
      log(_hasuraBloc, _appGlobalBloc,
        nomeArquivo: "aplicativoDao",
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
