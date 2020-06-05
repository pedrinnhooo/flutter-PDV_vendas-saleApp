import 'package:common_files/common_files.dart';

class PrecoTabelaDAO implements IEntityDAO {
  HasuraBloc _hasuraBloc;
  AppGlobalBloc _appGlobalBloc;
  final String tableName = "preco_tabela";
  int filterId = 0;
  String filterText = "";

  PrecoTabela _precoTabela;
  List<PrecoTabela> _precoTabelaList;

  @override
  Dao dao;

  PrecoTabelaDAO(this._hasuraBloc, this._appGlobalBloc, this._precoTabela) {
    dao = Dao();
  }

  @override
  IEntity fromMap(Map<String, dynamic> map) {
   try {
      _precoTabela.id = map['id'];
      _precoTabela.idPessoaGrupo = map['id_pessoa_grupo'];
      _precoTabela.nome = map['nome'];
      _precoTabela.dataCadastro = map['data_cadastro'];
      _precoTabela.dataAtualizacao = map['data_atualizacao'];
      return _precoTabela;
    } catch(error, stacktrace) {
      _appGlobalBloc.logger.e(error.toString(), '<preco_tabelaDao> fromMap');
      log(_hasuraBloc, _appGlobalBloc,
        nomeArquivo: "preco_tabelaDao",
        nomeFuncao: "fromMap",
        error: error.toString(),
        stacktrace: stacktrace.toString()
      );
      return null;
    }   
  }

  @override
  Future<List> getAll({bool preLoad = false}) async {
    String where = "";
    try {
      List<dynamic> args = [];
      if ((filterId > 0) || (filterText != "")) {
        where = "1 = 1 ";
        if (filterId > 0) {
          where = where + "and (id = " + filterText + ")";
        }
        if (filterText != "") {
          where = where + "and (nome like '%" + filterText + "%')";
        }
      }

      List list = await dao.getList(this, where, args);
      _precoTabelaList = List.generate(list.length, (i) {
        return PrecoTabela(
          id: list[i]['id'],
          idPessoaGrupo: list[i]['id_pessoa_grupo'],
          nome: list[i]['nome'],
          dataCadastro: DateTime.parse(list[i]['data_cadastro']),
          dataAtualizacao: DateTime.parse(list[i]['data_atualizacao']),
        );
      });
    } catch(error, stacktrace) {
      _appGlobalBloc.logger.e(error.toString(), '<preco_tabelaDao> getAll');
      log(_hasuraBloc, _appGlobalBloc,
        nomeArquivo: "preco_tabelaDao",
        nomeFuncao: "getAll",
        error: error.toString(),
        stacktrace: stacktrace.toString()
      );
      return null;
    }   

    return _precoTabelaList;
  }

  Future<List> getAllFromServer({bool preLoad=false, bool id=false, bool idPessoaGrupo=false,
    bool ehDeletado=false, bool dataCadastro=false, bool dataAtualizacao=false, String filtroNome=""}) async {
    String query;
    try {
      query = """ 
        {
          preco_tabela(where: {
            nome: {${filtroNome != "" ? '_ilike:  '+'"$filtroNome%"' : ''}}}, 
            order_by: {nome: asc}) {
              ${id ? "id" : ""}
              ${idPessoaGrupo ? "id_pessoa_grupo" : ""}
              nome
              ${ehDeletado ? "ehdeletado" : ""}
              ${dataCadastro ? "data_cadastro" : ""}
              ${dataAtualizacao ? "data_atualizacao" : ""}
          }
        }
      """;

      var data = await _hasuraBloc.hasuraConnect.query(query);
      _precoTabelaList = [];

        for(var i = 0; i < data['data']['preco_tabela'].length; i++){
          _precoTabelaList.add(
            PrecoTabela(
              id: data['data']['preco_tabela'][i]['id'],
              idPessoaGrupo: data['data']['preco_tabela'][i]['id_pessoa'],
              nome: data['data']['preco_tabela'][i]['nome'],
              ehDeletado: data['data']['preco_tabela'][i]['ehdeletado'],
              dataCadastro: data['data']['preco_tabela'][i]['data_cadastro'],
              dataAtualizacao: data['data']['preco_tabela'][i]['data_atualizacao']
            )       
          );
        }
    } catch(error, stacktrace) {
      _appGlobalBloc.logger.e(error.toString(), '<preco_tabelaDao> getAllFromServer');
      log(_hasuraBloc, _appGlobalBloc,
        nomeArquivo: "preco_tabelaDao",
        nomeFuncao: "getAllFomServer",
        error: error.toString(),
        stacktrace: stacktrace.toString(),
        query: query
      );
    }   
    return _precoTabelaList;
  }


  @override
  Future<IEntity> getById(int id) async {
    try {
      _precoTabela = await dao.getById(this, id);
      return _precoTabela;
    } catch(error, stacktrace) {
      _appGlobalBloc.logger.e(error.toString(), '<preco_tabelaDao> getById');
      log(_hasuraBloc, _appGlobalBloc,
        nomeArquivo: "preco_tabelaDao",
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
          preco_tabela(where: {id: {_eq: $id}}) {
            id
            id_pessoa_grupo
            nome
            ehdeletado
            data_cadastro
            data_atualizacao
          }
        }
      """;

      var data = await _hasuraBloc.hasuraConnect.query(query);
      PrecoTabela _precoTabela = PrecoTabela(
        id: data['data']['preco_tabela'][0]['id'],
        idPessoaGrupo: data['data']['preco_tabela'][0]['id_pessoa'],
        nome: data['data']['preco_tabela'][0]['nome'],
        ehDeletado: data['data']['preco_tabela'][0]['ehdeletado'],
        dataCadastro: DateTime.parse(data['data']['preco_tabela'][0]['data_cadastro']),
        dataAtualizacao: DateTime.parse(data['data']['preco_tabela'][0]['data_atualizacao'])
      );
      return _precoTabela;
    } catch(error, stacktrace) {
      _appGlobalBloc.logger.e(error.toString(), '<preco_tabelaDao> getByIdFromServer');
      log(_hasuraBloc, _appGlobalBloc,
        nomeArquivo: "preco_tabelaDao",
        nomeFuncao: "getByIdFromServer",
        error: error.toString(),
        stacktrace: stacktrace.toString(),
        query: query,
      );
      return null;
    }   
  }

  @override
  Future<IEntity> insert() async {
    try {
      _precoTabela.id = await dao.insert(this);
    } catch(error, stacktrace) {
      _appGlobalBloc.logger.e(error.toString(), '<preco_tabelaDao> insert');
      log(_hasuraBloc, _appGlobalBloc,
        nomeArquivo: "preco_tabelaDao",
        nomeFuncao: "insert",
        error: error.toString(),
        stacktrace: stacktrace.toString(),
        object: _precoTabela.toString()
      );
    }   
    return _precoTabela;
  }

  Future<IEntity> saveOnServer() async {
    String _query;
    try {
      _query = """ mutation savePrecoTabela {
          insert_preco_tabela(objects: {""";

      if ((_precoTabela.id != null) && (_precoTabela.id > 0)) {
        _query = _query + "id: ${_precoTabela.id},";
      }    

      _query = _query + """
          nome: "${_precoTabela.nome}", 
          ehdeletado: ${_precoTabela.ehDeletado}, 
          data_cadastro: "${_precoTabela.dataCadastro}",
          data_atualizacao: "${_precoTabela.dataAtualizacao}"},
          on_conflict: {
            constraint: preco_tabela_pkey, 
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
      _precoTabela.id = data["data"]["insert_preco_tabela"]["returning"][0]["id"];
      return _precoTabela;
    } catch(error, stacktrace) {
      _appGlobalBloc.logger.e(error.toString(), '<preco_tabelaDao> saveOnServer');
      log(_hasuraBloc, _appGlobalBloc,
        nomeArquivo: "preco_tabelaDao",
        nomeFuncao: "saveOnServer",
        error: error.toString(),
        stacktrace: stacktrace.toString(),
        query: _query,
        object: _precoTabela.toString()
      );
      return null;
    }   
  }

  @override
  Future<IEntity> delete(int id) async {
    return _precoTabela;
  }  

  @override
  Map<String, dynamic> toMap() {
    try {
      return {
        'id': _precoTabela.id,
        'id_pessoa_grupo': _precoTabela.idPessoaGrupo,
        'nome': _precoTabela.nome,
        'data_cadastro': _precoTabela.dataCadastro.toString(),
        'data_atualizacao': _precoTabela.dataAtualizacao.toString(),
      };
    } catch(error, stacktrace) {
      _appGlobalBloc.logger.e(error.toString(), '<preco_tabelaDao> toMap');
      log(_hasuraBloc, _appGlobalBloc,
        nomeArquivo: "preco_tabelaDao",
        nomeFuncao: "toMap",
        error: error.toString(),
        stacktrace: stacktrace.toString()
      );
      return null;
    }   
  }

  Future<PrecoTabela> getMinPrecoTabelaFromServer() async {
    String _query;
    try {
      _query = """
        query getMinPrecoTabela {
          preco_tabela(limit: 1, order_by: {id: asc}) {
            id
          }
        }
      """;

      var data = await _hasuraBloc.hasuraConnect.query(_query);
      _precoTabela.id = data['data']['preco_tabela'][0]['id'];
      return _precoTabela;
    } catch(error, stacktrace) {
      _appGlobalBloc.logger.e(error.toString(), '<preco_tabelaDao> getMinPrecoTabelaFromServer');
      log(_hasuraBloc, _appGlobalBloc,
        nomeArquivo: "preco_tabelaDao",
        nomeFuncao: "getMinPrecoTabelaFromServer",
        error: error.toString(),
        stacktrace: stacktrace.toString(),
        query: _query
      );
      return null;
    }   
  }

}  
