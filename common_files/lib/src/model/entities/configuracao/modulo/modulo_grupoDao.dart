import 'dart:convert';
import 'package:common_files/common_files.dart';
import 'package:sqflite/sqflite.dart';

class ModuloGrupoDAO implements IEntityDAO {
  HasuraBloc _hasuraBloc;
  AppGlobalBloc _appGlobalBloc;
  final String tableName = "modulo_grupo";
  int filterId = 0;
  String filterText = "";
  FilterEhAtivo filterEhAtivo = FilterEhAtivo.ativos;
  bool loadModuloGrupoItem = false;

  ModuloGrupo moduloGrupo;
  List<ModuloGrupo> moduloGrupoList = [];

  @override
  Dao dao;

  ModuloGrupoDAO(this._hasuraBloc, this._appGlobalBloc, this.moduloGrupo) {
    dao = Dao();
    //dao.createDb();
  }

  @override
  IEntity fromMap(Map<String, dynamic> map) {
    try {
      this.moduloGrupo.id = map['id'];
      this.moduloGrupo.nome = map['nome'];
      this.moduloGrupo.valor = map['valor'];
      this.moduloGrupo.ehAtivo = map['ehativo'];
      this.moduloGrupo.dataCadastro = DateTime.parse(map['data_cadastro']);
      this.moduloGrupo.dataAtualizacao = DateTime.parse(map['data_atualizacao']);
    } catch(error, stacktrace) {
      _appGlobalBloc.logger.e(error.toString(), '<modulo_grupoDao> fromMap');
      log(_hasuraBloc, _appGlobalBloc,
        nomeArquivo: "modulo_grupoDao",
        nomeFuncao: "fromMap",
        error: error.toString(),
        stacktrace: stacktrace.toString(),
      );
    }   
    return this.moduloGrupo;
  }

  @override
  Future<List> getAll({bool preLoad = false, List<int> filtroIds}) async {
    String where;
    try {
      where = "1 = 1";
      List<dynamic> args = [];

      if (filterText != "") {
        where = where + " and (nome like '%" + filterText + "%')";
      }

      if (filterEhAtivo != FilterEhAtivo.todos) {
        where = where + " and ehativo = ${filterEhAtivo == FilterEhAtivo.ativos ? 1 : 0}";
      }

      if(filterId > 0){
        where += " and (id = $filterId)";
      }

      if(filtroIds != null && filtroIds.length > 0){
        where += " and id in ${filtroIds.toString().replaceAll("[", "(").replaceAll("]", ")")}";
      }

      List list = await dao.getList(this, where, args);
      moduloGrupoList = List.generate(list.length, (i) {
        return ModuloGrupo(
          id: list[i]['id'],
          nome: list[i]['nome'],
          valor: list[i]['valor'],
          ehAtivo: list[i]['ehativo'],
          dataCadastro: DateTime.parse(list[i]['data_cadastro']),
          dataAtualizacao: DateTime.parse(list[i]['data_atualizacao']),
        );
      });

      if (preLoad) {
        for (var _moduloGrupo in moduloGrupoList) {
          if (loadModuloGrupoItem) {
            ModuloGrupoItem moduloGrupoItem = ModuloGrupoItem();
            ModuloGrupoItemDAO moduloGrupoItemDAO = ModuloGrupoItemDAO(_hasuraBloc, _appGlobalBloc, moduloGrupoItem);
            moduloGrupoItemDAO.filterIdModuloGrupo = _moduloGrupo.id;
            _moduloGrupo.moduloGrupoItem = await moduloGrupoItemDAO.getAll();
          }
        }  
      }
    } catch(error, stacktrace) {
      _appGlobalBloc.logger.e(error.toString(), '<modulo_grupoDao> getAll');
      log(_hasuraBloc, _appGlobalBloc,
        nomeArquivo: "modulo_grupoDao",
        nomeFuncao: "getAll",
        error: error.toString(),
        stacktrace: stacktrace.toString(),
        query: where
      );
    }   
    return moduloGrupoList;
  }

  Future<List> getAllFromServer({bool preLoad=false, bool completo=false, bool id=false, bool valor=false, bool ehAtivo=false, 
                                 bool dataCadastro=false, bool dataAtualizacao=false, String filtroNome="",
                                 DateTime filtroDataAtualizacao, List<int> filtroIds}) async {
    String query;
    try {
      String queryItens;
      if (preLoad) {
        queryItens = """
          modulo_grupo_items {
            id
            id_modulo
            id_modulo_grupo
            data_cadastro
            data_atualizacao
          }
        """;
      }
          
      query = """ 
        {
          modulo_grupo(where: {
            id: {${filtroIds != null ? '_in: ' + filtroIds.toString() : ''}}, 
            ehativo: {${filterEhAtivo != FilterEhAtivo.todos ? filterEhAtivo == FilterEhAtivo.naoAtivos ? "_eq: 0" : "_eq: 1" : ""}}
            nome: {${filtroNome != "" ? '_ilike:  ''"$filtroNome%"' : ''}}, 
            data_atualizacao: {${filtroDataAtualizacao != null ? '_gt:  '+'"${filtroDataAtualizacao.toIso8601String()}"' : ''}}}, 
            order_by: {${filtroDataAtualizacao == null ? 'nome: asc' : 'data_atualizacao: asc'}}) {
              ${completo || id ? "id" : ""}
              nome
              ${completo || valor ? "valor" : ""}
              ${completo || ehAtivo ? "ehativo" : ""}
              ${completo || dataCadastro ? "data_cadastro" : ""}
              ${completo || dataAtualizacao ? "data_atualizacao" : ""}
              ${preLoad ? queryItens : ""}
          }
        }
      """;

      var data = await _hasuraBloc.hasuraConnect.query(query);
      moduloGrupoList = [];
      var moduloGrupoItemList = new List<ModuloGrupoItem>();
      
      for(var i = 0; i < data['data']['modulo_grupo'].length; i++){
        if (data['data']['modulo_grupo'][i]['modulo_grupo_items'] != null) {
          data['data']['modulo_grupo'][i]['modulo_grupo_items'].forEach((v) {
            moduloGrupoItemList.add(new ModuloGrupoItem.fromJson(v));
          });
        }
        moduloGrupoList.add(
          ModuloGrupo(
            id: data['data']['modulo_grupo'][i]['id'],
            nome: data['data']['modulo_grupo'][i]['nome'],
            valor: data['data']['modulo_grupo'][i]['valor'] != null ? data['data']['modulo_grupo'][i]['valor'].toDouble() : null,
            ehAtivo: data['data']['modulo_grupo'][i]['ehativo'],
            dataCadastro: data['data']['modulo_grupo'][i]['data_cadastro'] != null ? DateTime.parse(data['data']['modulo_grupo'][i]['data_cadastro']) : null,
            dataAtualizacao: data['data']['modulo_grupo'][i]['data_atualizacao'] != null ? DateTime.parse(data['data']['modulo_grupo'][i]['data_atualizacao']) : null,
            moduloGrupoItem: moduloGrupoItemList
          )       
        );
      }
    } catch(error, stacktrace) {
      _appGlobalBloc.logger.e(error.toString(), '<modulo_grupoDao> getAllFromServer');
      log(_hasuraBloc, _appGlobalBloc,
        nomeArquivo: "modulo_grupoDao",
        nomeFuncao: "getAllFromServer",
        error: error.toString(),
        stacktrace: stacktrace.toString(),
        query: query
      );
    }   
    return moduloGrupoList;
  }

  @override
  Future<IEntity> getById(int id) async {
    try {
      return await dao.getById(this, id);
    } catch(error, stacktrace) {
      _appGlobalBloc.logger.e(error.toString(), '<modulo_grupoDao> getById');
      log(_hasuraBloc, _appGlobalBloc,
        nomeArquivo: "modulo_grupoDao",
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
          modulo_grupo(where: {id: {_eq: $id}}) {
            id
            nome
            valor
            ehativo
            data_cadastro
            data_atualizacao
          }
        }
      """;

      var data = await _hasuraBloc.hasuraConnect.query(query);
      ModuloGrupo _modulo = ModuloGrupo(
        id: data['data']['modulo_grupo'][0]['id'],
        nome: data['data']['modulo_grupo'][0]['nome'],
        valor: data['data']['modulo_grupo'][0]['valor'],
        ehAtivo: data['data']['modulo_grupo'][0]['ehativo'],
        dataCadastro: DateTime.parse(data['data']['modulo_grupo'][0]['data_cadastro']),
        dataAtualizacao: DateTime.parse(data['data']['modulo_grupo'][0]['data_atualizacao']),
      );
      return _modulo;
    } catch(error, stacktrace) {
      _appGlobalBloc.logger.e(error.toString(), '<modulo_grupoDao> getByIdFromServer');
      log(_hasuraBloc, _appGlobalBloc,
        nomeArquivo: "modulo_grupoDao",
        nomeFuncao: "getByIdFromServer",
        error: error.toString(),
        stacktrace: stacktrace.toString(),
        query: query
      );
      return null;
    }   
  }

  @override
  Future<IEntity> insert() async {
    try {
      Database db = await dao.getDatabase();
      await db.transaction((txn) async {
        var batch = txn.batch();
        moduloGrupo.id = await txn.insert(tableName, this.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
        for (ModuloGrupoItem _moduloGrupoItem in moduloGrupo.moduloGrupoItem) {
          batch.insert('modulo_grupo_item', _moduloGrupoItem.toJson(), conflictAlgorithm: ConflictAlgorithm.replace);
        }
        var result = await batch.commit();
      });  
    } catch(error, stacktrace) {
      _appGlobalBloc.logger.e(error.toString(), '<modulo_grupoDao> insert');
      log(_hasuraBloc, _appGlobalBloc,
        nomeArquivo: "modulo_grupoDao",
        nomeFuncao: "insert",
        error: error.toString(),
        stacktrace: stacktrace.toString(),
        object: this.moduloGrupo.toString()
      );
    }   
    return this.moduloGrupo;    
  }

  Future<IEntity> saveOnServer() async {
    String _query;
    try {
      _query = """ mutation saveModuloGrupo {
          insert_modulo_grupo(objects: {""";

      if ((moduloGrupo.id != null) && (moduloGrupo.id > 0)) {
        _query = _query + "id: ${moduloGrupo.id},";
      }    

      _query = _query + """
          nome: "${moduloGrupo.nome}", 
          valor: "${moduloGrupo.valor}", 
          ehativo: ${moduloGrupo.ehAtivo}, 
          data_cadastro: "${moduloGrupo.dataCadastro}",
          data_atualizacao: "${moduloGrupo.dataAtualizacao}"},
          on_conflict: {
            constraint: modulo_pkey, 
            update_columns: [
              nome, 
              valor,
              ehativo,
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
      moduloGrupo.id = data["data"]["insert_modulo_grupo"]["returning"][0]["id"];
      return moduloGrupo;
    } catch(error, stacktrace) {
      _appGlobalBloc.logger.e(error.toString(), '<modulo_grupoDao> saveOnServer');
      log(_hasuraBloc, _appGlobalBloc,
        nomeArquivo: "modulo_grupoDao",
        nomeFuncao: "saveOnServer",
        error: error.toString(),
        stacktrace: stacktrace.toString(),
        query: _query,
        object: moduloGrupo.toString()
      );
      return null;
    }   
  }

  Future<DateTime> getUltimaSincronizacao() async {
    try {
      List<Map> data = await dao.getRawQuery("select max(data_atualizacao) as data_atualizacao from modulo_grupo");
      return data[0]['data_atualizacao'] != null ? DateTime.tryParse(data[0]['data_atualizacao']) : DateTime.parse("2019-01-01T00:00:01.000000");
    } catch(error, stacktrace) {
      _appGlobalBloc.logger.e(error.toString(), '<modulo_grupoDao> getUltimaSincronizacao');
      log(_hasuraBloc, _appGlobalBloc,
        nomeArquivo: "modulo_grupoDao",
        nomeFuncao: "getUltimaSincronizacao",
        error: error.toString(),
        stacktrace: stacktrace.toString(),
      );
      return DateTime.now();
    }   
  }
 
  @override
  Future<IEntity> delete(int id) async {
    return this.moduloGrupo;
  }   

  @override
  Map<String, dynamic> toMap() {
    try {
      return {
        'id': this.moduloGrupo.id,
        'nome': this.moduloGrupo.nome,
        'valor': this.moduloGrupo.valor,
        'ehativo': this.moduloGrupo.ehAtivo,
        'data_cadastro': this.moduloGrupo.dataCadastro.toString(),
        'data_atualizacao': this.moduloGrupo.dataAtualizacao.toString(),
      };
    } catch(error, stacktrace) {
      _appGlobalBloc.logger.e(error.toString(), '<modulo_grupoDao> toMap');
      log(_hasuraBloc, _appGlobalBloc,
        nomeArquivo: "modulo_grupoDao",
        nomeFuncao: "toMap",
        error: error.toString(),
        stacktrace: stacktrace.toString(),
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