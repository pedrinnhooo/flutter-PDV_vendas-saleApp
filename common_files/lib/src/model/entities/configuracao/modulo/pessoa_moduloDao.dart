import 'dart:convert';
import 'package:common_files/common_files.dart';

class PessoaModuloDAO implements IEntityDAO {
  HasuraBloc _hasuraBloc;
  AppGlobalBloc _appGlobalBloc;
  final String tableName = "pessoa_modulo";
  int filterPessoa = 0;
  int filterModulo;
  String filterText = "";
  FilterEhAtivo filterEhAtivo = FilterEhAtivo.ativos;

  PessoaModulo pessoaModulo;
  List<PessoaModulo> pessoaModuloList = [];

  @override
  Dao dao;

  PessoaModuloDAO(this._hasuraBloc, this._appGlobalBloc, {this.pessoaModulo, this.pessoaModuloList}) {
    dao = Dao();
    if (pessoaModulo == null) {
      pessoaModulo = PessoaModulo();
    }
  }

  @override
  IEntity fromMap(Map<String, dynamic> map) {
    try {
      this.pessoaModulo.id = map['id'];
      this.pessoaModulo.idPessoa = map['id_pessoa'];
      this.pessoaModulo.idModuloGrupo = map['id_modulo_grupo'];
      this.pessoaModulo.valor = map['valor'];
      this.pessoaModulo.ehAtivo = map['ehativo'];
      this.pessoaModulo.ehDemonstracao = map['ehdemonstracao'];
      this.pessoaModulo.dataFinalDemonstracao = map['data_final_demonstracao'];
      this.pessoaModulo.dataCadastro = map['data_cadastro'];
      this.pessoaModulo.dataAtualizacao = map['data_atualizacao'];
    } catch(error, stacktrace) {
      _appGlobalBloc.logger.e(error.toString(), '<pessoa_moduloDao> fromMap');
      log(_hasuraBloc, _appGlobalBloc,
        nomeArquivo: "pessoa_moduloDao",
        nomeFuncao: "fromMap",
        error: error.toString(),
        stacktrace: stacktrace.toString()
      );
    }   
    return this.pessoaModulo;
  }

  @override
  Future<List> getAll({bool preLoad = false}) async {
    String where = "";
    try {
      List<dynamic> args = [];
      if (filterPessoa > 0) {
        where = where + "(id_pessoa = ?)";
        args.add(filterPessoa);
      }

      if(filterEhAtivo == FilterEhAtivo.ativos){
        where += " (ehativo = 1)";
      }

      List list = await dao.getList(this, where, args);
      pessoaModuloList = List.generate(list.length, (i) {
        return PessoaModulo(
          id: list[i]['id'],
          idPessoa: list[i]['id_pessoa'],
          idModuloGrupo: list[i]['id_modulo_grupo'],
          valor: list[i]['valor'],
          ehAtivo: list[i]['ehativo'],
          ehDemonstracao: list[i]['ehdemonstracao'],
          dataFinalDemonstracao: DateTime.parse(list[i]['data_final_demonstracao']),
          dataCadastro: DateTime.parse(list[i]['data_cadastro']),
          dataAtualizacao: DateTime.parse(list[i]['data_atualizacao']),
        );
      });
    } catch(error, stacktrace) {
      _appGlobalBloc.logger.e(error.toString(), '<pessoa_moduloDao> getAll');
      log(_hasuraBloc, _appGlobalBloc,
        nomeArquivo: "pessoa_moduloDao",
        nomeFuncao: "getAll",
        error: error.toString(),
        stacktrace: stacktrace.toString(),
        query: where
      );
    }   
    return pessoaModuloList;
  }

  Future<List> getAllFromServer({bool preLoad=false, bool completo=false, bool id=false, bool idPessoa=false, 
    bool idModuloGrupo=false, bool valor=false, bool ehAtivo=false, bool ehDemonstracao=false, bool dataFinalDemonstracao=false, 
    bool dataCadastro=false, bool dataAtualizacao=false, DateTime filtroDataAtualizacao}) async {
    String query;
    try {
      query = """ 
        {
          pessoa_modulo(where: {
            ehativo: {${filterEhAtivo != FilterEhAtivo.todos ? filterEhAtivo == FilterEhAtivo.naoAtivos ? "_eq: 0" : "_eq: 1" : ""}},
            data_atualizacao: {${filtroDataAtualizacao != null ? '_gt:  '+'"${filtroDataAtualizacao.toIso8601String()}"' : ''}}}, 
            order_by: {${filtroDataAtualizacao == null ? 'id: asc' : 'data_atualizacao: asc'}}) {
              ${completo || id ? "id" : ""}
              ${completo || idPessoa ? "id_pessoa" : ""}
              ${completo || idModuloGrupo ? "id_modulo_grupo" : ""}
              ${completo || valor ? "valor" : ""}
              ${completo || ehAtivo ? "ehativo" : ""}
              ${completo || ehDemonstracao ? "ehdemonstracao" : ""}
              ${completo || dataFinalDemonstracao ? "data_final_demonstracao" : ""}
              ${completo || dataCadastro ? "data_cadastro" : ""}
              ${completo || dataAtualizacao ? "data_atualizacao" : ""}
          }
        }
      """;

      var data = await _hasuraBloc.hasuraConnect.query(query);
      print("<PessoaModulo> getAllFromServer query: $query");
      pessoaModuloList = [];

      for(var i = 0; i < data['data']['pessoa_modulo'].length; i++){
        pessoaModuloList.add(
          PessoaModulo(
            id: data['data']['pessoa_modulo'][i]['id'],
            idPessoa: data['data']['pessoa_modulo'][i]['id_pessoa'],
            idModuloGrupo: data['data']['pessoa_modulo'][i]['id_modulo_grupo'],
            valor: data['data']['pessoa_modulo'][i]['valor'] != null ? data['data']['pessoa_modulo'][i]['valor'].toDouble() : null,
            ehAtivo: data['data']['pessoa_modulo'][i]['ehativo'],
            ehDemonstracao: data['data']['pessoa_modulo'][i]['ehdemonstracao'],
            dataFinalDemonstracao: data['data']['pessoa_modulo'][i]['data_final_demonstracao'] != null ? DateTime.parse(data['data']['pessoa_modulo'][i]['data_final_demonstracao']) : null,
            dataCadastro: data['data']['pessoa_modulo'][i]['data_cadastro'] != null ? DateTime.parse(data['data']['pessoa_modulo'][i]['data_cadastro']) : null,
            dataAtualizacao: data['data']['pessoa_modulo'][i]['data_atualizacao'] != null ? DateTime.parse(data['data']['pessoa_modulo'][i]['data_atualizacao']) : null
          )       
        );
      }
    } catch(error, stacktrace) {
      _appGlobalBloc.logger.e(error.toString(), '<pessoa_moduloDao> getAllFromServer');
      log(_hasuraBloc, _appGlobalBloc,
        nomeArquivo: "pessoa_moduloDao",
        nomeFuncao: "getAllFromServer",
        error: error.toString(),
        stacktrace: stacktrace.toString(),
        query: query
      );
    }   
    return pessoaModuloList;
  }


  @override
  Future<IEntity> getById(int id) async {
    try {
      pessoaModulo = await dao.getById(this, id);
      return pessoaModulo;
    } catch(error, stacktrace) {
      _appGlobalBloc.logger.e(error.toString(), '<pessoa_moduloDao> getById');
      log(_hasuraBloc, _appGlobalBloc,
        nomeArquivo: "pessoa_moduloDao",
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
          pessoa_modulo(where: {id: {_eq: $id}}) {
            id
            id_pessoa
            id_modulo_grupo
            valor
            ehativo
            ehdemonstracao
            data_final_demonstracao
            data_cadastro
            data_atualizacao
            modulo {
              id
              nome
            }
          }
        }
      """;

      var data = await _hasuraBloc.hasuraConnect.query(query);
      PessoaModulo _modulo = PessoaModulo(
        id: data['data']['pessoa_modulo'][0]['id'],
        idPessoa: data['data']['pessoa_modulo'][0]['id_pessoa'],
        idModuloGrupo: data['data']['pessoa_modulo'][0]['id_modulo_grupo'],
        valor: data['data']['pessoa_modulo'][0]['valor'],
        ehAtivo: data['data']['pessoa_modulo'][0]['ehativo'],
        ehDemonstracao: data['data']['pessoa_modulo'][0]['ehdemonstracao'],
        dataFinalDemonstracao: DateTime.parse(data['data']['pessoa_modulo'][0]['data_final_demonstracao']),
        dataCadastro: DateTime.parse(data['data']['pessoa_modulo'][0]['data_cadastro']),
        dataAtualizacao: DateTime.parse(data['data']['pessoa_modulo'][0]['data_atualizacao']),
        modulo: Modulo(
          id: data['data']['pessoa_modulo'][0]['modulo']['id'],
          nome: data['data']['pessoa_modulo'][0]['modulo']['nome'],
        )
      );
      return _modulo;
    } catch(error, stacktrace) {
      _appGlobalBloc.logger.e(error.toString(), '<pessoa_moduloDao> getByIdFromServer');
      log(_hasuraBloc, _appGlobalBloc,
        nomeArquivo: "pessoa_moduloDao",
        nomeFuncao: "getByIdFromServer",
        error: error.toString(),
        stacktrace: stacktrace.toString(),
        query: query
      );
    }   
  }

  @override
  Future<IEntity> insert() async {
    try {
      this.pessoaModulo.id = await dao.insert(this);
      return this.pessoaModulo;
    } catch(error, stacktrace) {
      _appGlobalBloc.logger.e(error.toString(), '<pessoa_moduloDao> insert');
      log(_hasuraBloc, _appGlobalBloc,
        nomeArquivo: "pessoa_moduloDao",
        nomeFuncao: "insert",
        error: error.toString(),
        stacktrace: stacktrace.toString(),
        object: pessoaModulo.toString()
      );
      return null;
    }   
  }

  Future<IEntity> saveOnServer() async {
    String _query;
    try {
      _query = """ mutation savePessoaModulo {
          insert_pessoa_modulo(objects: {""";

      if ((pessoaModulo.id != null) && (pessoaModulo.id > 0)) {
        _query = _query + "id: ${pessoaModulo.id},";
      }    

      _query = _query + """
          id_pessoa: "${pessoaModulo.idPessoa}", 
          id_modulo_grupo: "${pessoaModulo.idModuloGrupo}", 
          valor: "${pessoaModulo.valor}", 
          ehativo: ${pessoaModulo.ehAtivo}, 
          ehdemonstracao: ${pessoaModulo.ehDemonstracao}, 
          data_final_demonstracao: "${pessoaModulo.dataFinalDemonstracao}",
          data_cadastro: "${pessoaModulo.dataCadastro}",
          data_atualizacao: "${pessoaModulo.dataAtualizacao}"},
          on_conflict: {
            constraint: pessoa_modulo_pkey, 
            update_columns: [
              valor,
              ehativo,
              ehdemonstracao,
              data_final_demonstracao,
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
      pessoaModulo.id = data["data"]["insert_pessoa_modulo"]["returning"][0]["id"];
      return pessoaModulo;
    } catch(error, stacktrace) {
      _appGlobalBloc.logger.e(error.toString(), '<pessoa_moduloDao> saveOnServer');
      log(_hasuraBloc, _appGlobalBloc,
        nomeArquivo: "pessoa_moduloDao",
        nomeFuncao: "saveOnServer",
        error: error.toString(),
        stacktrace: stacktrace.toString(),
        query: _query,
        object: pessoaModulo.toString()
      );
      return null;
    }   
  }


  @override
  Map<String, dynamic> toMap() {
    try {
      return {
        'id': pessoaModulo.id,
        'id_pessoa': pessoaModulo.idPessoa,
        'id_modulo_grupo': pessoaModulo.idModuloGrupo,
        'valor': pessoaModulo.valor,
        'ehativo': pessoaModulo.ehAtivo,
        'ehdemonstracao': pessoaModulo.ehDemonstracao,
        'data_final_demonstracao': pessoaModulo.dataFinalDemonstracao.toString(),
        'data_cadastro': pessoaModulo.dataCadastro.toString(),
        'data_atualizacao': pessoaModulo.dataAtualizacao.toString(),
      };
    } catch(error, stacktrace) {
      _appGlobalBloc.logger.e(error.toString(), '<pessoa_moduloDao> toMap');
      log(_hasuraBloc, _appGlobalBloc,
        nomeArquivo: "pessoa_moduloDao",
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

  IEntity fromJson(Map<String, dynamic> json) {
    try {
      return PessoaModulo(
        id: this.pessoaModulo.id = json['id'],
        idPessoa: this.pessoaModulo.idPessoa = json['id_pessoa'],
        idModuloGrupo: this.pessoaModulo.idModuloGrupo = json['id_modulo_grupo'],
        valor: this.pessoaModulo.valor = json['valor'],
        ehAtivo: this.pessoaModulo.valor = json['ehativo'],
        ehDemonstracao: this.pessoaModulo.valor = json['ehdemonstracao'],
        dataFinalDemonstracao: this.pessoaModulo.dataCadastro = json['data_final_demonstracao'],
        dataCadastro: this.pessoaModulo.dataCadastro = json['data_cadastro'],
        dataAtualizacao: this.pessoaModulo.dataAtualizacao =
            json['data_atualizacao'],
      );
    } catch(error, stacktrace) {
      _appGlobalBloc.logger.e(error.toString(), '<pessoa_moduloDao> fromJson');
      log(_hasuraBloc, _appGlobalBloc,
        nomeArquivo: "pessoa_moduloDao",
        nomeFuncao: "fromJson",
        error: error.toString(),
        stacktrace: stacktrace.toString()
      );
      return null;
    }   
  }

  Future<DateTime> getUltimaSincronizacao() async {
    try {
      List<Map> data = await dao.getRawQuery("select max(data_atualizacao) as data_atualizacao from pessoa_modulo where id_pessoa = ${_appGlobalBloc.loja.id} ");
      return data[0]['data_atualizacao'] != null ? DateTime.tryParse(data[0]['data_atualizacao']) : DateTime.parse("2019-01-01T00:00:01.000000");
    } catch(error, stacktrace) {
      _appGlobalBloc.logger.e(error.toString(), '<pessoa_moduloDao> getUltimaSincronizacao');
      log(_hasuraBloc, _appGlobalBloc,
        nomeArquivo: "pessoa_moduloDao",
        nomeFuncao: "getUltimaSincronizacao",
        error: error.toString(),
        stacktrace: stacktrace.toString()
      );
      return DateTime.now();
    }   
  }

  @override
  Future<IEntity> delete(int id) async {
    return this.pessoaModulo;
  }   
 
  List prepareListToJson() {
    List jsonList = List();
    for (pessoaModulo in pessoaModuloList) {
      jsonList.add(toMap());
    }
    return jsonList;
  }

  List<IEntity> prepareListFromJson(List<dynamic> map) {
    try {
      List list = map;
      pessoaModuloList = List.generate(list.length, (i) {
        return PessoaModulo(
          id: list[i]['id'],
          idPessoa: list[i]['id_pessoa'],
          idModuloGrupo: list[i]['id_modulo_grupo'],
          valor: list[i]['valor'],
          ehAtivo: list[i]['ehativo'],
          ehDemonstracao: list[i]['ehdemonstracao'],
          dataFinalDemonstracao: list[i]['data_final_demonstracao'],
          dataCadastro: list[i]['data_cadastro'],
          dataAtualizacao: list[i]['data_atualizacao'],
        );
      });
    } catch(error, stacktrace) {
      _appGlobalBloc.logger.e(error.toString(), '<pessoa_moduloDao> prepareListFromJson');
      log(_hasuraBloc, _appGlobalBloc,
        nomeArquivo: "pessoa_moduloDao",
        nomeFuncao: "prepareListFromJson",
        error: error.toString(),
        stacktrace: stacktrace.toString(),
      );
    }   
    return pessoaModuloList;
  }
}