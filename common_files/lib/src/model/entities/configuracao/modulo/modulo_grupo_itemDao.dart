import 'dart:convert';
import 'package:common_files/common_files.dart';

class ModuloGrupoItemDAO implements IEntityDAO {
  HasuraBloc _hasuraBloc;
  AppGlobalBloc _appGlobalBloc;
  final String tableName = "modulo_grupo_item";
  int filterId = 0;
  int filterIdModuloGrupo = 0;

  ModuloGrupoItem moduloGrupoItem;
  List<ModuloGrupoItem> moduloGrupoItemList;

  @override
  Dao dao;

  ModuloGrupoItemDAO(this._hasuraBloc, this._appGlobalBloc, this.moduloGrupoItem) {
    dao = Dao();
    //dao.createDb();
  }

  @override
  IEntity fromMap(Map<String, dynamic> map) {
    try {
      this.moduloGrupoItem.id = map['id'];
      this.moduloGrupoItem.idModulo = map['id_modulo'];
      this.moduloGrupoItem.idModuloGrupo = map['id_modulo_grupo'];
      this.moduloGrupoItem.dataCadastro = DateTime.parse(map['data_cadastro']);
      this.moduloGrupoItem.dataAtualizacao = DateTime.parse(map['data_atualizacao']);
    } catch(error, stacktrace) {
      _appGlobalBloc.logger.e(error.toString(), '<modulo_grupo_itemDao> fromMap');
      log(_hasuraBloc, _appGlobalBloc,
        nomeArquivo: "modulo_grupo_itemDao",
        nomeFuncao: "fromMap",
        error: error.toString(),
        stacktrace: stacktrace.toString()
      );
    }   
    return this.moduloGrupoItem;
  }

  @override
  Future<List> getAll({bool preLoad = false}) async {
    String where;
    try {
      where = "";
      List<dynamic> args = [];
      where = "1 = 1 ";

      if (filterIdModuloGrupo > 0) {
        where = where + " and (id_modulo_grupo = $filterIdModuloGrupo)";
      }

      List list = await dao.getList(this, where, args);
      moduloGrupoItemList = List.generate(list.length, (i) {
        return ModuloGrupoItem(
          id: list[i]['id'],
          idModulo: list[i]['id_modulo'],
          idModuloGrupo: list[i]['id_modulo_grupo'],
          dataCadastro: DateTime.parse(list[i]['data_cadastro']),
          dataAtualizacao: DateTime.parse(list[i]['data_atualizacao']),
        );
      });
    } catch(error, stacktrace) {
      _appGlobalBloc.logger.e(error.toString(), '<modulo_grupo_itemDao> getAll');
      log(_hasuraBloc, _appGlobalBloc,
        nomeArquivo: "modulo_grupo_itemDao",
        nomeFuncao: "getAll",
        error: error.toString(),
        stacktrace: stacktrace.toString(),
        query: where
      );
    }   
    return moduloGrupoItemList;
  }

  Future<List> getAllFromServer({bool preLoad=false, bool completo=false, bool id=false, bool valor=false, bool ehAtivo=false, 
                                 bool dataCadastro=false, bool dataAtualizacao=false, String filtroNome="",
                                 DateTime filtroDataAtualizacao}) async {
    // String queryItens;
    // if (preLoad) {
    //   queryItens = """
    //     modulo_grupo_items {
    //       id
    //       id_modulo
    //       id_modulo_grupo
    //       data_cadastro
    //       data_atualizacao
    //     }
    //   """;
    // }
        
    // String query = """ 
    //   {
    //     modulo_grupo(where: {
    //       ehativo: {${filterEhAtivo != FilterEhAtivo.todos ? filterEhAtivo == FilterEhAtivo.naoAtivos ? "_eq: 0" : "_eq: 1" : ""}}
    //       nome: {${filtroNome != "" ? '_ilike:  ''"$filtroNome%"' : ''}}, 
    //       data_atualizacao: {${filtroDataAtualizacao != null ? '_gt:  '+'"${filtroDataAtualizacao.toIso8601String()}"' : ''}}}, 
    //       order_by: {${filtroDataAtualizacao == null ? 'nome: asc' : 'data_atualizacao: asc'}}) {
    //         ${completo || id ? "id" : ""}
    //         nome
    //         ${completo || valor ? "valor" : ""}
    //         ${completo || ehAtivo ? "ehativo" : ""}
    //         ${completo || dataCadastro ? "data_cadastro" : ""}
    //         ${completo || dataAtualizacao ? "data_atualizacao" : ""}
    //         ${preLoad ? queryItens : ""}
    //     }
    //   }
    // """;

    // var data = await _hasuraBloc.hasuraConnect.query(query);
    // moduloGrupoList = [];
    // var moduloGrupoItemList = new List<ModuloGrupoItem>();
    
    // for(var i = 0; i < data['data']['modulo_grupo'].length; i++){
    //   if (data['data']['modulo_grupo'][i]['modulo_grupo_items'] != null) {
    //     data['data']['modulo_grupo'][i]['modulo_grupo_items'].forEach((v) {
    //       moduloGrupoItemList.add(new ModuloGrupoItem.fromJson(v));
    //     });
    //   }
    //   moduloGrupoList.add(
    //     ModuloGrupo(
    //       id: data['data']['modulo_grupo'][i]['id'],
    //       nome: data['data']['modulo_grupo'][i]['nome'],
    //       valor: data['data']['modulo_grupo'][i]['valor'].toDouble(),
    //       ehAtivo: data['data']['modulo_grupo'][i]['ehativo'],
    //       dataCadastro: data['data']['modulo_grupo'][i]['data_cadastro'] != null ? DateTime.parse(data['data']['modulo_grupo'][i]['data_cadastro']) : null,
    //       dataAtualizacao: data['data']['modulo_grupo'][i]['data_atualizacao'] != null ? DateTime.parse(data['data']['modulo_grupo'][i]['data_atualizacao']) : null,
    //       moduloGrupoItem: moduloGrupoItemList
    //     )       
    //   );
    // }
    // return moduloGrupoList;
  }

  @override
  Future<IEntity> getById(int id) async {
    try {
      return await dao.getById(this, id);
    } catch(error, stacktrace) {
      _appGlobalBloc.logger.e(error.toString(), '<modulo_grupo_itemDao> getById');
      log(_hasuraBloc, _appGlobalBloc,
        nomeArquivo: "modulo_grupo_itemDao",
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
    //     modulo_grupo(where: {id: {_eq: $id}}) {
    //       id
    //       nome
    //       valor
    //       ehativo
    //       data_cadastro
    //       data_atualizacao
    //     }
    //   }
    // """;

    // var data = await _hasuraBloc.hasuraConnect.query(query);
    // ModuloGrupo _modulo = ModuloGrupo(
    //   id: data['data']['modulo_grupo'][0]['id'],
    //   nome: data['data']['modulo_grupo'][0]['nome'],
    //   valor: data['data']['modulo_grupo'][0]['valor'],
    //   ehAtivo: data['data']['modulo_grupo'][0]['ehativo'],
    //   dataCadastro: DateTime.parse(data['data']['modulo_grupo'][0]['data_cadastro']),
    //   dataAtualizacao: DateTime.parse(data['data']['modulo_grupo'][0]['data_atualizacao']),
    // );
    // return _modulo;
  }

  @override
  Future<IEntity> insert() async {
    //this.categoria.idPessoaGrupo = _appGlobalBloc.loja.idPessoaGrupo; 
    try {
      this.moduloGrupoItem.id = await dao.insert(this);
      return this.moduloGrupoItem;
    } catch(error, stacktrace) {
      _appGlobalBloc.logger.e(error.toString(), '<modulo_grupo_itemDao> insert');
      log(_hasuraBloc, _appGlobalBloc,
        nomeArquivo: "modulo_grupo_itemDao",
        nomeFuncao: "insert",
        error: error.toString(),
        stacktrace: stacktrace.toString(),
        object: this.moduloGrupoItem.toString()
      );
      return null;
    }   
  }

  Future<IEntity> saveOnServer() async {
    // String _query = """ mutation saveModuloGrupo {
    //     insert_modulo_grupo(objects: {""";

    // if ((moduloGrupo.id != null) && (moduloGrupo.id > 0)) {
    //   _query = _query + "id: ${moduloGrupo.id},";
    // }    

    // _query = _query + """
    //     nome: "${moduloGrupo.nome}", 
    //     valor: "${moduloGrupo.valor}", 
    //     ehativo: ${moduloGrupo.ehAtivo}, 
    //     data_cadastro: "${moduloGrupo.dataCadastro}",
    //     data_atualizacao: "${moduloGrupo.dataAtualizacao}"},
    //     on_conflict: {
    //       constraint: modulo_pkey, 
    //       update_columns: [
    //         nome, 
    //         valor,
    //         ehativo,
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
    //   moduloGrupo.id = data["data"]["insert_modulo_grupo"]["returning"][0]["id"];
    //   return moduloGrupo;
    // } catch (error) {
    //   return null;
    // }  
  }

  Future<DateTime> getUltimaSincronizacao() async {
    try {
      List<Map> data = await dao.getRawQuery("select max(data_atualizacao) as data_atualizacao from modulo_grupo_item");
      return data[0]['data_atualizacao'] != null ? DateTime.tryParse(data[0]['data_atualizacao']) : DateTime.parse("2019-01-01T00:00:01.000000");
    } catch(error, stacktrace) {
      _appGlobalBloc.logger.e(error.toString(), '<modulo_grupo_itemDao> getUltimaSincronizacao');
      log(_hasuraBloc, _appGlobalBloc,
        nomeArquivo: "modulo_grupo_itemDao",
        nomeFuncao: "getUltimaSincronizacao",
        error: error.toString(),
        stacktrace: stacktrace.toString()
      );
      DateTime.now();
    }   
  }
 
  @override
  Future<IEntity> delete(int id) async {
    return this.moduloGrupoItem;
  }   

  @override
  Map<String, dynamic> toMap() {
    try {
      return {
        'id': this.moduloGrupoItem.id,
        'id_modulo': this.moduloGrupoItem.idModulo,
        'id_modulo_grupo': this.moduloGrupoItem.idModuloGrupo,
        'data_cadastro': this.moduloGrupoItem.dataCadastro.toString(),
        'data_atualizacao': this.moduloGrupoItem.dataAtualizacao.toString(),
      };
    } catch(error, stacktrace) {
      _appGlobalBloc.logger.e(error.toString(), '<modulo_grupo_itemDao> toMap');
      log(_hasuraBloc, _appGlobalBloc,
        nomeArquivo: "modulo_grupo_itemDao",
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