import 'dart:convert';
import 'package:common_files/common_files.dart';

class AplicativoVersaoDAO implements IEntityDAO {
  HasuraBloc _hasuraBloc;
  AppGlobalBloc _appGlobalBloc;
  final String tableName = "aplicativo_versao";
  int filterId = 0;
  String filterText = "";

  AplicativoVersao aplicativoVersao;
  List<AplicativoVersao> aplicativoVersaoList;

  @override
  Dao dao;

  AplicativoVersaoDAO(this._hasuraBloc, this._appGlobalBloc, {this.aplicativoVersao}) {
    dao = Dao();
  }

  @override
  IEntity fromMap(Map<String, dynamic> map) {
    try {
      this.aplicativoVersao.id = map['id'];
      this.aplicativoVersao.idAplicativo = map['id_aplicativo'];
      this.aplicativoVersao.versao = map['versao'];
      this.aplicativoVersao.ehAtivo = map['ehativo'];
      this.aplicativoVersao.dataLimite = DateTime.parse(map['data_limite']);
      this.aplicativoVersao.dataCadastro = DateTime.parse(map['data_cadastro']);
      this.aplicativoVersao.dataAtualizacao = DateTime.parse(map['data_atualizacao']);
    } catch(error, stacktrace) {
      _appGlobalBloc.logger.e(error.toString(), '<aplicativo_versaoDao> fromMap');
      log(_hasuraBloc, _appGlobalBloc,
        nomeArquivo: "aplicativo_versaoDao",
        nomeFuncao: "fromMap",
        error: error.toString(),
        stacktrace: stacktrace.toString()
      );
    }   
    return this.aplicativoVersao;
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
      aplicativoVersaoList = List.generate(list.length, (i) {
        return AplicativoVersao(
          id: list[i]['id'],
          idAplicativo: list[i]['id_aplicativo'],
          versao: list[i]['versao'],
          ehAtivo: list[i]['ehativo'],
          dataLimite: list[i]['data_limite'] != null ? DateTime.parse(list[i]['data_limite']) : null,
          dataCadastro: list[i]['data_cadastro'] != null ? DateTime.parse(list[i]['data_cadastro']) : null,
          dataAtualizacao: list[i]['data_atualizacao'] != null ? DateTime.parse(list[i]['data_atualizacao']) : null,
        );
      });
    } catch(error, stacktrace) {
      _appGlobalBloc.logger.e(error.toString(), '<aplicativo_versaoDao> getAll');
      log(_hasuraBloc, _appGlobalBloc,
        nomeArquivo: "aplicativo_versaoDao",
        nomeFuncao: "getAll",
        error: error.toString(),
        stacktrace: stacktrace.toString(),
        query: where
      );
    }   
    return aplicativoVersaoList;
  }

  Future<List> getAllFromServer({bool preLoad=false, bool completo=false, bool id=false, 
      bool idAplicativo=false, bool versao=false, bool ehAtivo=false, bool dataLimite=false,  
      bool dataCadastro=false, bool dataAtualizacao=false, int filtroIdAplicativo=0,
      DateTime filtroDataAtualizacao}) async {
  
    String query;
    try {
      query = """ 
        {
          aplicativo_versao(where: {
            id_aplicativo: {${filtroIdAplicativo > 0 ? '_eq: '+ filtroIdAplicativo.toString() : ''}},
            data_atualizacao: {${filtroDataAtualizacao != null ? '_gt:  '+'"${filtroDataAtualizacao.toIso8601String()}"' : ''}}}, 
            order_by: {${filtroDataAtualizacao == null ? 'id: asc' : 'data_atualizacao: asc'}}) {
              ${completo || id ? "id" : ""}
              ${completo || idAplicativo ? "id_aplicativo" : ""}
              ${completo || versao ? "versao" : ""}
              ${completo || ehAtivo ? "ehativo" : ""}
              ${completo || dataLimite ? "data_limite" : ""}
              ${completo || dataCadastro ? "data_cadastro" : ""}
              ${completo || dataAtualizacao ? "data_atualizacao" : ""}
          }
        }
      """;

      var data = await _hasuraBloc.hasuraConnect.query(query);
      aplicativoVersaoList = [];

      for(var i = 0; i < data['data']['aplicativo_versao'].length; i++){
        aplicativoVersaoList.add(
          AplicativoVersao(
            id: data['data']['aplicativo_versao'][i]['id'],
            idAplicativo: data['data']['aplicativo_versao'][i]['id_aplicativo'],
            versao: data['data']['aplicativo_versao'][i]['versao'],
            ehAtivo: data['data']['aplicativo_versao'][i]['ehativo'],
            dataLimite: data['data']['aplicativo_versao'][i]['data_limite'] != null ? DateTime.parse(data['data']['aplicativo_versao'][i]['data_limite']) : null,
            dataCadastro: data['data']['aplicativo_versao'][i]['data_cadastro'] != null ? DateTime.parse(data['data']['aplicativo_versao'][i]['data_cadastro']) : null,
            dataAtualizacao: data['data']['aplicativo_versao'][i]['data_atualizacao'] != null ? DateTime.parse(data['data']['aplicativo_versao'][i]['data_atualizacao']) : null,
          )       
        );
      }
    } catch(error, stacktrace) {
      _appGlobalBloc.logger.e(error.toString(), '<aplicativo_versaoDao> getAllFromServer');
      log(_hasuraBloc, _appGlobalBloc,
        nomeArquivo: "aplicativo_versaoDao",
        nomeFuncao: "getAllFromServer",
        error: error.toString(),
        stacktrace: stacktrace.toString(),
        query: query
      );
    }   
    return aplicativoVersaoList;
  }
  
  @override
  Future<IEntity> getById(int id) async {
    try {
      return await dao.getById(this, id);
    } catch(error, stacktrace) {
      _appGlobalBloc.logger.e(error.toString(), '<aplicativo_versaoDao> getById');
      log(_hasuraBloc, _appGlobalBloc,
        nomeArquivo: "aplicativo_versaoDao",
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
          aplicativo_versao(where: {id: {_eq: $id}}) {
            id
            id_aplicativo
            versao
            ehativo
            data_limite
            data_cadastro
            data_atualizacao
          }
        }
      """;

      var data = await _hasuraBloc.hasuraConnect.query(query);
      AplicativoVersao _aplicativoVersao = AplicativoVersao(
        id: data['data']['aplicativo_versao'][0]['id'],
        idAplicativo: data['data']['aplicativo_versao'][0]['id_aplicativo'],
        versao: data['data']['aplicativo_versao'][0]['versao'],
        ehAtivo: data['data']['aplicativo_versao'][0]['ehativo'],
        dataLimite: DateTime.parse(data['data']['aplicativo_versao'][0]['data_cadastro']),
        dataCadastro: DateTime.parse(data['data']['aplicativo_versao'][0]['data_cadastro']),
        dataAtualizacao: DateTime.parse(data['data']['aplicativo_versao'][0]['data_atualizacao'])
      );
      return _aplicativoVersao;
    } catch(error, stacktrace) {
      _appGlobalBloc.logger.e(error.toString(), '<aplicativo_versaoDao> getByIdFromServer');
      log(_hasuraBloc, _appGlobalBloc,
        nomeArquivo: "aplicativo_versaoDao",
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
      List<Map> data = await dao.getRawQuery("select max(data_atualizacao) as data_atualizacao from aplicativo_versao");
      return data[0]['data_atualizacao'] != null ? DateTime.tryParse(data[0]['data_atualizacao']) : DateTime.parse("2019-01-01T00:00:01.000000");
    } catch(error, stacktrace) {
      _appGlobalBloc.logger.e(error.toString(), '<aplicativo_versaoDao> getUltimaSincronizacao');
      log(_hasuraBloc, _appGlobalBloc,
        nomeArquivo: "aplicativo_versaoDao",
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
      this.aplicativoVersao.id = await dao.insert(this);
    } catch(error, stacktrace) {
      _appGlobalBloc.logger.e(error.toString(), '<aplicativo_versaoDao> insert');
      log(_hasuraBloc, _appGlobalBloc,
        nomeArquivo: "aplicativo_versaoDao",
        nomeFuncao: "insert",
        error: error.toString(),
        stacktrace: stacktrace.toString(),
        object: this.aplicativoVersao.toString()
      );
    }   
    return this.aplicativoVersao;
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
    return this.aplicativoVersao;
  }  

  @override
  Map<String, dynamic> toMap() {
    try {
      return {
        'id': this.aplicativoVersao.id,
        'id_aplicativo': this.aplicativoVersao.idAplicativo,
        'versao': this.aplicativoVersao.versao,
        'ehativo': this.aplicativoVersao.ehAtivo,
        'data_limite': this.aplicativoVersao.dataLimite.toString(),
        'data_cadastro': this.aplicativoVersao.dataCadastro.toString(),
        'data_atualizacao': this.aplicativoVersao.dataAtualizacao.toString(),
      };
    } catch(error, stacktrace) {
      _appGlobalBloc.logger.e(error.toString(), '<aplicativo_versaoDao> toMap');
      log(_hasuraBloc, _appGlobalBloc,
        nomeArquivo: "aplicativo_versaoDao",
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
