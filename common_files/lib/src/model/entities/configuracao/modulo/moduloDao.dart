import 'dart:convert';

import 'package:common_files/common_files.dart';

class ModuloDAO implements IEntityDAO {
  HasuraBloc _hasuraBloc;
  AppGlobalBloc _appGlobalBloc;
  final String tableName = "modulo";
  int filterId = 0;
  String filterText = "";
  FilterEhAtivo filterEhAtivo = FilterEhAtivo.ativos;

  Modulo modulo;
  List<Modulo> moduloList;

  @override
  Dao dao;

  ModuloDAO(this._hasuraBloc, this._appGlobalBloc, this.modulo) {
    dao = Dao();
    //dao.createDb();
  }

  @override
  IEntity fromMap(Map<String, dynamic> map) {
    try {
      this.modulo.id = map['id'];
      this.modulo.nome = map['nome'];
      this.modulo.ehAtivo = map['ehativo'];
      this.modulo.dataCadastro = DateTime.parse(map['data_cadastro']);
      this.modulo.dataAtualizacao = DateTime.parse(map['data_atualizacao']);
    } catch(error, stacktrace) {
      _appGlobalBloc.logger.e(error.toString(), '<moduloDao> fromMap');
      log(_hasuraBloc, _appGlobalBloc,
        nomeArquivo: "moduloDao",
        nomeFuncao: "fromMap",
        error: error.toString(),
        stacktrace: stacktrace.toString()
      );
    }   
    return this.modulo;
  }

  @override
  Future<List> getAll({bool preLoad = false}) async {
    String where = "";
    try {
      List<dynamic> args = [];

      if (filterText != "") {
        where = "1 = 1 ";
        where = where + "and (nome like '%" + filterText + "%')";
      }

      List list = await dao.getList(this, where, args);
      moduloList = List.generate(list.length, (i) {
        return Modulo(
          id: list[i]['id'],
          nome: list[i]['nome'],
          ehAtivo: list[i]['ehativo'],
          dataCadastro: DateTime.parse(list[i]['data_cadastro']),
          dataAtualizacao: DateTime.parse(list[i]['data_atualizacao']),
        );
      });
    } catch(error, stacktrace) {
      _appGlobalBloc.logger.e(error.toString(), '<moduloDao> getAll');
      log(_hasuraBloc, _appGlobalBloc,
        nomeArquivo: "moduloDao",
        nomeFuncao: "getAll",
        error: error.toString(),
        stacktrace: stacktrace.toString(),
        query: where
      );
    }   
    return moduloList;
  }

  Future<List> getAllFromServer({bool preLoad=false, bool completo=false,  bool id=false, bool ehAtivo=false, 
                                 bool dataCadastro=false, bool dataAtualizacao=false, String filtroNome="",
                                 DateTime filtroDataAtualizacao}) async {
    String query;
    try {
      query = """ 
        {
          modulo(where: {
            ehativo: {${filterEhAtivo != FilterEhAtivo.todos ? filterEhAtivo == FilterEhAtivo.naoAtivos ? "_eq: 0" : "_eq: 1" : ""}}
            nome: {${filtroNome != "" ? '_ilike:  ''"$filtroNome%"' : ''}},
            data_atualizacao: {${filtroDataAtualizacao != null ? '_gt:  '+'"${filtroDataAtualizacao.toIso8601String()}"' : ''}}}, 
            order_by: {${filtroDataAtualizacao == null ? 'nome: asc' : 'data_atualizacao: asc'}}) {
              ${completo || id ? "id" : ""}
              nome
              ${completo || ehAtivo ? "ehativo" : ""}
              ${completo || dataCadastro ? "data_cadastro" : ""}
              ${completo || dataAtualizacao ? "data_atualizacao" : ""}
          }
        }
      """;

      var data = await _hasuraBloc.hasuraConnect.query(query);
      moduloList = [];

      for(var i = 0; i < data['data']['modulo'].length; i++){
        moduloList.add(
          Modulo(
            id: data['data']['modulo'][i]['id'],
            nome: data['data']['modulo'][i]['nome'],
            ehAtivo: data['data']['modulo'][i]['ehativo'],
            dataCadastro: data['data']['modulo'][i]['data_cadastro'] != null ? DateTime.parse(data['data']['modulo'][i]['data_cadastro']) : null,
            dataAtualizacao: data['data']['modulo'][i]['data_atualizacao'] != null ? DateTime.parse(data['data']['modulo'][i]['data_atualizacao']) : null
          )       
        );
      }
    } catch(error, stacktrace) {
      _appGlobalBloc.logger.e(error.toString(), '<moduloDao> getAllFromServer');
      log(_hasuraBloc, _appGlobalBloc,
        nomeArquivo: "moduloDao",
        nomeFuncao: "getAllFromServer",
        error: error.toString(),
        stacktrace: stacktrace.toString(),
        query: query
      );
    }   
    return moduloList;
  }
  
  @override
  Future<IEntity> getById(int id) async {
    try {
      return await dao.getById(this, id);
    } catch(error, stacktrace) {
      _appGlobalBloc.logger.e(error.toString(), '<moduloDao> getById');
      log(_hasuraBloc, _appGlobalBloc,
        nomeArquivo: "moduloDao",
        nomeFuncao: "getById",
        error: error.toString(),
        stacktrace: stacktrace.toString(),
        query: "id: $id"
      );
      return null;
    }   
  }

  Future<IEntity> getByIdFromServer(int id) async {
    String query;
    try {
      query = """ 
        {
          modulo(where: {id: {_eq: $id}}) {
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
      Modulo _modulo = Modulo(
        id: data['data']['modulo'][0]['id'],
        nome: data['data']['modulo'][0]['nome'],
        ehAtivo: data['data']['modulo'][0]['ehativo'],
        dataCadastro: DateTime.parse(data['data']['modulo'][0]['data_cadastro']),
        dataAtualizacao: DateTime.parse(data['data']['modulo'][0]['data_atualizacao']),
      );
      return _modulo;
    } catch(error, stacktrace) {
      _appGlobalBloc.logger.e(error.toString(), '<moduloDao> getByIdFromServer');
      log(_hasuraBloc, _appGlobalBloc,
        nomeArquivo: "moduloDao",
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
      this.modulo.id = await dao.insert(this);
      return this.modulo;
    } catch(error, stacktrace) {
      _appGlobalBloc.logger.e(error.toString(), '<moduloDao> insert');
      log(_hasuraBloc, _appGlobalBloc,
        nomeArquivo: "moduloDao",
        nomeFuncao: "insert",
        error: error.toString(),
        stacktrace: stacktrace.toString(),
        object: modulo.toString()
      );
      return null;
    }   
  }

  Future<IEntity> saveOnServer() async {
    String _query;
    try {
      _query = """ mutation saveModulo {
          insert_modulo(objects: {""";

      if ((modulo.id != null) && (modulo.id > 0)) {
        _query = _query + "id: ${modulo.id},";
      }    

      _query = _query + """
          nome: "${modulo.nome}", 
          ehativo: ${modulo.ehAtivo}, 
          data_cadastro: "${modulo.dataCadastro}",
          data_atualizacao: "${modulo.dataAtualizacao}"},
          on_conflict: {
            constraint: modulo_pkey, 
            update_columns: [
              nome, 
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
      modulo.id = data["data"]["insert_modulo"]["returning"][0]["id"];
      return modulo;
    } catch(error, stacktrace) {
      _appGlobalBloc.logger.e(error.toString(), '<moduloDao> saveOnServer');
      log(_hasuraBloc, _appGlobalBloc,
        nomeArquivo: "moduloDao",
        nomeFuncao: "saveOnServer",
        error: error.toString(),
        stacktrace: stacktrace.toString(),
        query: _query,
        object: modulo.toString()
      );
      return null;
    }   
  }

  Future<DateTime> getUltimaSincronizacao() async {
    try {
      List<Map> data = await dao.getRawQuery("select max(data_atualizacao) as data_atualizacao from modulo");
      return data[0]['data_atualizacao'] != null ? DateTime.tryParse(data[0]['data_atualizacao']) : DateTime.parse("2019-01-01T00:00:01.000000");
    } catch(error, stacktrace) {
      _appGlobalBloc.logger.e(error.toString(), '<moduloDao> getUltimaSincronizacao');
      log(_hasuraBloc, _appGlobalBloc,
        nomeArquivo: "moduloDao",
        nomeFuncao: "getUltimaSincronizacao",
        error: error.toString(),
        stacktrace: stacktrace.toString()
      );
      return DateTime.now();
    }   
  }

  @override
  Future<IEntity> delete(int id) async {
    return this.modulo;
  }   

  @override
  Map<String, dynamic> toMap() {
    try {
      return {
        'id': this.modulo.id,
        'nome': this.modulo.nome,
        'ehativo': this.modulo.ehAtivo,
        'data_cadastro': this.modulo.dataCadastro.toString(),
        'data_atualizacao': this.modulo.dataAtualizacao.toString(),
      };
    } catch(error, stacktrace) {
      _appGlobalBloc.logger.e(error.toString(), '<moduloDao> toMap');
      log(_hasuraBloc, _appGlobalBloc,
        nomeArquivo: "moduloDao",
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