import 'dart:convert';
import 'package:common_files/common_files.dart';

class CategoriaDAO implements IEntityDAO {
  HasuraBloc _hasuraBloc;
  AppGlobalBloc _appGlobalBloc;
  final String tableName = "categoria";
  int filterId = 0;
  String filterText = "";
  int filterCategoriaServico = 0;
  Categoria categoria;
  List<Categoria> categoriaList;

  @override
  Dao dao;

  CategoriaDAO(this._hasuraBloc, this._appGlobalBloc, {this.categoria}) {
    dao = Dao();
    //dao.createDb();
  }

  @override
  IEntity fromMap(Map<String, dynamic> map) {
    try {
      this.categoria.id = map['id'];
      this.categoria.idPessoaGrupo = map['id_pessoa_grupo'];
      this.categoria.nome = map['nome'];
      this.categoria.ehDeletado = map['ehdeletado'];
      this.categoria.ehServico = map['ehservico'];
      this.categoria.dataCadastro = DateTime.parse(map['data_cadastro']);
      this.categoria.dataAtualizacao = DateTime.parse(map['data_atualizacao']);
    } catch(error, stacktrace) {
      _appGlobalBloc.logger.e(error.toString(), '<categoriaDao> fromMap');
      log(_hasuraBloc, _appGlobalBloc,
        nomeArquivo: "categoriaDao",
        nomeFuncao: "fromMap",
        error: error.toString(),
        stacktrace: stacktrace.toString()
      );
    }   
    return this.categoria;
  }

  @override
  Future<List> getAll({bool preLoad = false}) async {
    String where;
    try {
      where = "id_pessoa_grupo = ${_appGlobalBloc.loja.idPessoaGrupo}";
      List<dynamic> args = [];

      if (filterText != "") {
        where = where + " and (nome like '%" + filterText + "%')";
      }

      if (filterCategoriaServico == 1) {
        where = where + " and (ehservico = 1)";
      }

      List list = await dao.getList(this, where, args);
      categoriaList = List.generate(list.length, (i) {
        return Categoria(
          id: list[i]['id'],
          idPessoaGrupo: list[i]['id_pessoa_grupo'],
          nome: list[i]['nome'],
          ehDeletado: list[i]['ehdeletado'],
          ehServico: list[i]['ehservico'],
          dataCadastro: list[i]['data_cadastro'] != null ? DateTime.parse(list[i]['data_cadastro']) : null,
          dataAtualizacao: list[i]['data_atualizacao'] != null ? DateTime.parse(list[i]['data_atualizacao']) : null,
        );
      });
    } catch(error, stacktrace) {
      _appGlobalBloc.logger.e(error.toString(), '<categoriaDao> getAll');
      log(_hasuraBloc, _appGlobalBloc,
        nomeArquivo: "categoriaDao",
        nomeFuncao: "getAll",
        error: error.toString(),
        stacktrace: stacktrace.toString(),
        query: where
      );
    }   
    return categoriaList;
  }

  Future<List> getAllFromServer({bool preLoad=false, bool id=false, bool idPessoaGrupo=false,
      bool ehDeletado=false, bool ehServico=false, bool dataCadastro=false, bool dataAtualizacao=false, String filtroNome="",
      DateTime filtroDataAtualizacao, FilterEhDeletado filterEhDeletado=FilterEhDeletado.naoDeletados, int offset = 0, FilterTemServico filterCategoriaServico=FilterTemServico.todos}) async {
    String query;
    try {
      query = """ 
        {
          categoria(limit: $queryLimit, offset: $offset, where: {
            nome: {${filtroNome != "" ? '_ilike:  '+'"$filtroNome%"' : ''}},
            ehservico : {${filterCategoriaServico != FilterTemServico.todos ? filterCategoriaServico == FilterTemServico.naoServico ? '_eq:  0' : '_eq:  1' : ''}},
            ehdeletado: {${filterEhDeletado != FilterEhDeletado.todos ? filterEhDeletado == FilterEhDeletado.naoDeletados ? '_eq:  0' : '_eq:  1' : ''}},
            data_atualizacao: {${filtroDataAtualizacao != null ? '_gt:  '+'"${filtroDataAtualizacao.toIso8601String()}"' : ''}}}, 
            order_by: {${filtroDataAtualizacao == null ? 'nome: asc' : 'data_atualizacao: asc'}}) {
              ${id ? "id" : ""}
              ${idPessoaGrupo ? "id_pessoa_grupo" : ""}
              nome
              ${ehDeletado ? "ehdeletado" : ""}
              ${ehServico ? "ehservico" : ""}
              ${dataCadastro ? "data_cadastro" : ""}
              ${dataAtualizacao ? "data_atualizacao" : ""}
          }
        }
      """;

      var data = await _hasuraBloc.hasuraConnect.query(query);
      categoriaList = [];

      for(var i = 0; i < data['data']['categoria'].length; i++){
        categoriaList.add(
          Categoria(
            id: data['data']['categoria'][i]['id'],
            idPessoaGrupo: data['data']['categoria'][i]['id_pessoa_grupo'],
            nome: data['data']['categoria'][i]['nome'],
            ehDeletado: data['data']['categoria'][i]['ehdeletado'],
            ehServico: data['data']['categoria'][i]['ehservico'],
            dataCadastro: data['data']['categoria'][i]['data_cadastro'] != null ? DateTime.parse(data['data']['categoria'][i]['data_cadastro']) : null,
            dataAtualizacao: data['data']['categoria'][i]['data_atualizacao'] != null ? DateTime.parse(data['data']['categoria'][i]['data_atualizacao']) : null
          )       
        );
      }
    } catch(error, stacktrace) {
      _appGlobalBloc.logger.e(error.toString(), '<categoriaDao> getAllFromServer');
      log(_hasuraBloc, _appGlobalBloc,
        nomeArquivo: "categoriaDao",
        nomeFuncao: "getAllFromServer",
        error: error.toString(),
        stacktrace: stacktrace.toString()
      );
    }   
    return categoriaList;
  }
  
  @override
  Future<IEntity> getById(int id) async {
    try {
      return await dao.getById(this, id);
    } catch(error, stacktrace) {
      _appGlobalBloc.logger.e(error.toString(), '<categoriaDao> getById');
      log(_hasuraBloc, _appGlobalBloc,
        nomeArquivo: "categoriaDao",
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
          categoria(where: {id: {_eq: $id}}) {
            id
            id_pessoa_grupo
            nome
            ehdeletado
            ehservico
            data_cadastro
            data_atualizacao
          }
        }
      """;

      var data = await _hasuraBloc.hasuraConnect.query(query);
      Categoria _categoria = Categoria(
        id: data['data']['categoria'][0]['id'],
        idPessoaGrupo: data['data']['categoria'][0]['id_pessoa_grupo'],
        nome: data['data']['categoria'][0]['nome'],
        ehDeletado: data['data']['categoria'][0]['ehdeletado'],
        ehServico: data['data']['categoria'][0]['ehservico'],
        dataCadastro: DateTime.parse(data['data']['categoria'][0]['data_cadastro']),
        dataAtualizacao: DateTime.parse(data['data']['categoria'][0]['data_atualizacao'])
      );
      return _categoria;
    } catch(error, stacktrace) {
      _appGlobalBloc.logger.e(error.toString(), '<categoriaDao> getByIdFromServer');
      log(_hasuraBloc, _appGlobalBloc,
        nomeArquivo: "categoriaDao",
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
      List<Map> data = await dao.getRawQuery("select max(data_atualizacao) as data_atualizacao from categoria where id_pessoa_grupo = ${_appGlobalBloc.loja.idPessoaGrupo} ");
      return data[0]['data_atualizacao'] != null ? DateTime.tryParse(data[0]['data_atualizacao']) : DateTime.parse("2019-01-01T00:00:01.000000");
    } catch(error, stacktrace) {
      _appGlobalBloc.logger.e(error.toString(), '<categoriaDao> getUltimaSincronizacao');
      log(_hasuraBloc, _appGlobalBloc,
        nomeArquivo: "categoriaDao",
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
      this.categoria.id = await dao.insert(this);
      return this.categoria;
    } catch(error, stacktrace) {
      _appGlobalBloc.logger.e(error.toString(), '<categoriaDao> insert');
      log(_hasuraBloc, _appGlobalBloc,
        nomeArquivo: "categoriaDao",
        nomeFuncao: "insert",
        error: error.toString(),
        stacktrace: stacktrace.toString(),
        object: this.categoria.toString()
      );
      return null;
    }   
  }

  Future<IEntity> saveOnServer() async {
    String _query;
    try {
      _query = """  mutation saveCategoria {
        update_sincronizacao(where: {}, _set: {data_atualizacao: "now()"}) {
          returning {
            data_atualizacao
          }
        }

        insert_categoria(objects: {
      """;      

      if ((categoria.id != null) && (categoria.id > 0)) {
        _query = _query + "id: ${categoria.id},";
      }    

      _query = _query + """
          nome: "${categoria.nome}", 
          ehdeletado: ${categoria.ehDeletado}, 
          ehservico: ${categoria.ehServico},
          data_atualizacao: "now()"},
          on_conflict: {
            constraint: categoria_pkey, 
            update_columns: [
              nome, 
              ehdeletado,
              ehservico,
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
      categoria.id = data["data"]["insert_categoria"]["returning"][0]["id"];
      return categoria;
    } catch(error, stacktrace) {
      _appGlobalBloc.logger.e(error.toString(), '<categoriaDao> saveOnServer');
      log(_hasuraBloc, _appGlobalBloc,
        nomeArquivo: "categoriaDao",
        nomeFuncao: "saveOnServer",
        error: error.toString(),
        stacktrace: stacktrace.toString(),
        query: _query,
        object: categoria.toString()
      );
      return null;
    }   
  }

  @override
  Future<IEntity> delete(int id) async {
    return this.categoria;
  }  

  @override
  Map<String, dynamic> toMap() {
    try {
      return {
        'id': this.categoria.id,
        'id_pessoa_grupo': this.categoria.idPessoaGrupo,
        'nome': this.categoria.nome,
        'ehdeletado': this.categoria.ehDeletado,
        'ehservico': this.categoria.ehServico,
        'data_cadastro': this.categoria.dataCadastro.toString(),
        'data_atualizacao': this.categoria.dataAtualizacao.toString(),
      };
    } catch(error, stacktrace) {
      _appGlobalBloc.logger.e(error.toString(), '<categoriaDao> toMap');
      log(_hasuraBloc, _appGlobalBloc,
        nomeArquivo: "categoriaDao",
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
