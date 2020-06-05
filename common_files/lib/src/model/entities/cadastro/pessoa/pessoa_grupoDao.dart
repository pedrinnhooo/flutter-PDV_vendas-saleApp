import 'package:common_files/common_files.dart';

class PessoaGrupoDAO implements IEntityDAO {
  HasuraBloc _hasuraBloc;
  AppGlobalBloc _appGlobalBloc;
  final String tableName = "pessoa_grupo";
  int filterId;
  String filterText;

  PessoaGrupo pessoaGrupo;
  List<PessoaGrupo> pessoaGrupoList;

  @override
  Dao dao;

  PessoaGrupoDAO(this._hasuraBloc, this._appGlobalBloc, this.pessoaGrupo) {
    dao = Dao();
  }

  @override
  IEntity fromMap(Map<String, dynamic> map) {
    try {
      this.pessoaGrupo.id = map['id'];
      this.pessoaGrupo.idPessoa = map['id_pessoa'];
      this.pessoaGrupo.nome = map['nome'];
      this.pessoaGrupo.ehDeletado = map['ehdeletado'];
      this.pessoaGrupo.dataCadastro = map['data_cadastro'] != null ? DateTime.parse(map['data_cadastro']) : null;
      this.pessoaGrupo.dataAtualizacao = map['data_atualizacao'] != null ? DateTime.parse(map['data_atualizacao']) : null;
    } catch(error, stacktrace) {
      _appGlobalBloc.logger.e(error.toString(), '<pessoa_grupoDao> fromMap');
      log(_hasuraBloc, _appGlobalBloc,
        nomeArquivo: "pessoa_grupoDao",
        nomeFuncao: "fromMap",
        error: error.toString(),
        stacktrace: stacktrace.toString()
      );
    }   
    return this.pessoaGrupo;
  }

  @override
  Future<List> getAll({bool preLoad = false}) async {
    String where;
    try {
      where = " 1 = 1 and ehdeletado = 0 ";
      List<dynamic> args = [];
      if ((filterId > 0) || (filterText != "")) {
        if (filterId > 0) {
          where = where + "and (id = " + filterText + ")";
        }
        if (filterText != "") {
          where = where + "and (nome like '%" + filterText + "%')";
        }
      }

      List list = await dao.getList(this, where, args);
      pessoaGrupoList = List.generate(list.length, (i) {
        return PessoaGrupo(
          id: list[i]['id'],
          idPessoa: list[i]['id_pessoa'],
          nome: list[i]['nome'],
          ehDeletado: list[i]['ehdeletado'],
          dataCadastro: list[i]['data_cadastro'] != null ? DateTime.parse(list[i]['data_cadastro']) : null,
          dataAtualizacao: list[i]['data_atualizacao'] != null ? DateTime.parse(list[i]['data_atualizacao']) : null
        );
      });
    } catch(error, stacktrace) {
      _appGlobalBloc.logger.e(error.toString(), '<pessoa_grupoDao> getAll');
      log(_hasuraBloc, _appGlobalBloc,
        nomeArquivo: "pessoa_grupoDao",
        nomeFuncao: "getAll",
        error: error.toString(),
        stacktrace: stacktrace.toString(),
        query: where
      );
    }   
    return pessoaGrupoList;
  }

  Future<List> getAllFromServer({bool preLoad=false, bool completo=false, 
    bool id=false, bool idPessoa=false, bool ehDeletado=false, int offset = 0,
    bool dataCadastro=false, bool dataAtualizacao=false, String filtroNome="", 
    DateTime filtroDataAtualizacao, FilterEhDeletado filterEhDeletado=FilterEhDeletado.naoDeletados}) async {
    
    String query;
    try {
      query = """ 
        {
          pessoa_grupo(limit: $queryLimit, offset: $offset, where: {
            ehdeletado: {${filterEhDeletado != FilterEhDeletado.todos ? filterEhDeletado == FilterEhDeletado.naoDeletados ? "_eq: 0" : "_eq: 1" : ""}},
            nome: {${filtroNome != "" ? '_ilike:  '+'"filtroNome%"' : ''}},
            data_atualizacao: {${filtroDataAtualizacao != null ? '_gt:  '+'"${filtroDataAtualizacao.toIso8601String()}"' : ''}}}, 
            order_by: {${filtroDataAtualizacao == null ? 'fantasia_apelido: asc' : 'data_atualizacao: asc'}}) {
            ${id ? "id" : ""}
            ${idPessoa ? "id_pessoa" : ""}
            nome
            ${ehDeletado ? "ehdeletado" : ""}
            ${dataCadastro ? "data_cadastro" : ""}
            ${dataAtualizacao ? "data_atualizacao" : ""}
          }
        }        
      """;

      var data = await _hasuraBloc.hasuraConnect.query(query);
      pessoaGrupoList = [];

      for(var i = 0; i < data['data']['pessoa_grupo'].length; i++){
        pessoaGrupoList.add(
          PessoaGrupo(
            id: data['data']['pessoa_grupo'][i]['id'],
            idPessoa: data['data']['pessoa_grupo'][i]['id_pessoa'],
            nome: data['data']['pessoa_grupo'][i]['nome'],
            ehDeletado: data['data']['pessoa_grupo'][i]['ehdeletado'],
            dataCadastro: data['data']['pessoa_grupo'][i]['data_cadastro'] != null ? DateTime.parse(data['data']['pessoa_grupo'][i]['data_cadastro']) : null,
            dataAtualizacao: data['data']['pessoa_grupo'][i]['data_atualizacao'] != null ? DateTime.parse(data['data']['pessoa_grupo'][i]['data_atualizacao']) : null
          )       
        );
      }
    } catch(error, stacktrace) {
      _appGlobalBloc.logger.e(error.toString(), '<pessoa_grupoDao> getAllFromServer');
      log(_hasuraBloc, _appGlobalBloc,
        nomeArquivo: "pessoa_grupoDao",
        nomeFuncao: "getAllFromServer",
        error: error.toString(),
        stacktrace: stacktrace.toString(),
        query: query
      );
    }   
    return pessoaGrupoList;
  }

  @override
  Future<IEntity> getById(int id) async {
    try {
      pessoaGrupo = await dao.getById(this, id);
      return pessoaGrupo;
    } catch(error, stacktrace) {
      _appGlobalBloc.logger.e(error.toString(), '<pessoa_grupoDao> getById');
      log(_hasuraBloc, _appGlobalBloc,
        nomeArquivo: "pessoa_grupoDao",
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
          pessoa_grupo(where: {id: {_eq: $id}}) {
            id
            id_pessoa
            nome
            ehdeletado
            data_cadastro
            data_atualizacao
          }
        }
      """;

      var data = await _hasuraBloc.hasuraConnect.query(query);
      
      PessoaGrupo _pessoaGrupo = PessoaGrupo(
        id: data['data']['pessoa_grupo'][0]['id'],
        idPessoa: data['data']['pessoa_grupo'][0]['id_pessoa'],
        nome: data['data']['pessoa_grupo'][0]['nome'],
        ehDeletado: data['data']['pessoa_grupo'][0]['ehdeletado'],
        dataCadastro: DateTime.parse(data['data']['pessoa_grupo'][0]['data_cadastro']),
        dataAtualizacao: DateTime.parse(data['data']['pessoa_grupo'][0]['data_atualizacao']),
      );
      return _pessoaGrupo;
    } catch(error, stacktrace) {
      _appGlobalBloc.logger.e(error.toString(), '<pessoa_grupoDao> fromMap');
      log(_hasuraBloc, _appGlobalBloc,
        nomeArquivo: "pessoa_grupoDao",
        nomeFuncao: "fromMap",
        error: error.toString(),
        stacktrace: stacktrace.toString(),
        query: query
      );
      return null;
    }   
  }

  Future<DateTime> getUltimaSincronizacao() async {
    try {
      List<Map> data = await dao.getRawQuery("select max(data_atualizacao) as data_atualizacao from pessoa_grupo");
      return data[0]['data_atualizacao'] != null ? DateTime.tryParse(data[0]['data_atualizacao']) : DateTime.parse("2019-01-01T00:00:01.000000");
    } catch(error, stacktrace) {
      _appGlobalBloc.logger.e(error.toString(), '<pessoa_grupoDao> getUltimaSincronizacao');
      log(_hasuraBloc, _appGlobalBloc,
        nomeArquivo: "pessoa_grupoDao",
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
      this.pessoaGrupo.id = await dao.insert(this);
    } catch(error, stacktrace) {
      _appGlobalBloc.logger.e(error.toString(), '<pessoa_grupoDao> insert');
      log(_hasuraBloc, _appGlobalBloc,
        nomeArquivo: "pessoa_grupoDao",
        nomeFuncao: "insert",
        error: error.toString(),
        stacktrace: stacktrace.toString(),
        object: this.pessoaGrupo.toString()
      );
    }   
    return this.pessoaGrupo;
  }

  Future<IEntity> saveOnServer() async {
    String _query;
    try {
      _query = """ mutation savePessoaGrupo {
        update_sincronizacao(where: {}, _set: {data_atualizacao: "now()"}) {
          returning {
            data_atualizacao
          }
        }

        insert_pessoa_grupo(objects: {
      """;

      if ((pessoaGrupo.id != null) && (pessoaGrupo.id > 0)) {
        _query = _query + "id: ${pessoaGrupo.id},";
      }    

      _query = _query + """
          nome: "${pessoaGrupo.nome}", 
          ehdeletado: ${pessoaGrupo.ehDeletado}, 
          data_atualizacao: "now()"},
          on_conflict: {
            constraint: grade_pkey, 
            update_columns: [
              nome,
              ehdeletado,
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
      pessoaGrupo.id = data["data"]["insert_pessoa_rupo"]["returning"][0]["id"];
      return pessoaGrupo;
    } catch(error, stacktrace) {
      _appGlobalBloc.logger.e(error.toString(), '<pessoa_grupoDao> saveOnServer');
      log(_hasuraBloc, _appGlobalBloc,
        nomeArquivo: "pessoa_grupoDao",
        nomeFuncao: "saveOnServer",
        error: error.toString(),
        stacktrace: stacktrace.toString(),
        query: _query,
        object: pessoaGrupo.toString()
      );
      return null;
    }   
  }

  @override
  Future<IEntity> delete(int id) async {
    return pessoaGrupo;
  }  

  @override
  Map<String, dynamic> toMap() {
    try {
      return {
        'id': pessoaGrupo.id,
        'id_pessoa': pessoaGrupo.idPessoa,
        'nome': pessoaGrupo.nome,
        'ehdeletado': pessoaGrupo.ehDeletado,
        'data_cadastro': pessoaGrupo.dataCadastro.toString(),
        'data_atualizacao': pessoaGrupo.dataAtualizacao.toString(),
      };
    } catch(error, stacktrace) {
      _appGlobalBloc.logger.e(error.toString(), '<pessoa_grupoDao> toMap');
      log(_hasuraBloc, _appGlobalBloc,
        nomeArquivo: "pessoa_grupoDao",
        nomeFuncao: "toMap",
        error: error.toString(),
        stacktrace: stacktrace.toString()
      );
      return null;
    }   
  }
}
