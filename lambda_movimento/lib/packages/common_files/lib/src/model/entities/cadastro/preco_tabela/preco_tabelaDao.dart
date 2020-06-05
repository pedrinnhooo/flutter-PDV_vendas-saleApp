import 'package:common_files/src/bloc/hasura_bloc.dart';
import 'package:common_files/src/model/dao/dao.dart';
import 'package:common_files/src/model/entities/cadastro/preco_tabela/preco_tabela.dart';
import 'package:common_files/src/model/entities/interfaces.dart';

class PrecoTabelaDAO implements IEntityDAO {
  HasuraBloc _hasuraBloc;
  final String tableName = "preco_tabela";
  int filterId = 0;
  String filterText = "";

  PrecoTabela _precoTabela;
  List<PrecoTabela> _precoTabelaList;

  @override
  Dao dao;

  PrecoTabelaDAO(this._hasuraBloc, this._precoTabela) {
    dao = Dao();
  }

  @override
  IEntity fromMap(Map<String, dynamic> map) {
    _precoTabela.id = map['id'];
    _precoTabela.idPessoaGrupo = map['id_pessoa_grupo'];
    _precoTabela.nome = map['nome'];
    _precoTabela.dataCadastro = map['data_cadastro'];
    _precoTabela.dataAtualizacao = map['data_atualizacao'];
    return _precoTabela;
  }

  @override
  Future<List> getAll({bool preLoad = false}) async {
    String where = "";
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

    return _precoTabelaList;
  }

  Future<List> getAllFromServer({bool preLoad=false, bool id=false, bool idPessoaGrupo=false,
    bool ehDeletado=false, bool dataCadastro=false, bool dataAtualizacao=false, String filtroNome=""}) async {
    String query = """ 
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
    return _precoTabelaList;
  }


  @override
  Future<IEntity> getById(int id) async {
    _precoTabela = await dao.getById(this, id);
    return _precoTabela;
  }

  Future<IEntity> getByIdFromServer(int id) async {
    String query = """ 
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
  }

  @override
  Future<IEntity> insert() async {
    _precoTabela.id = await dao.insert(this);
    return _precoTabela;
  }

  Future<IEntity> saveOnServer() async {
    String _query = """ mutation savePrecoTabela {
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

    try {
      var data = await _hasuraBloc.hasuraConnect.mutation(_query);
      _precoTabela.id = data["data"]["insert_preco_tabela"]["returning"][0]["id"];
      return _precoTabela;
    } catch (error) {
      return null;
    }  
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'id': _precoTabela.id,
      'id_pessoa_grupo': _precoTabela.idPessoaGrupo,
      'nome': _precoTabela.nome,
      'data_cadastro': _precoTabela.dataCadastro.toString(),
      'data_atualizacao': _precoTabela.dataAtualizacao.toString(),
    };
  }

  Future<PrecoTabela> getMinPrecoTabelaFromServer() async {
    String _query = """
      query getMinPrecoTabela {
        preco_tabela(limit: 1, order_by: {id: asc}) {
          id
        }
      }
    """;

    try {
      var data = await _hasuraBloc.hasuraConnect.query(_query);
      _precoTabela.id = data['data']['preco_tabela'][0]['id'];
      return _precoTabela;
    } catch (e) {
      return null;
    }
  }  
}
