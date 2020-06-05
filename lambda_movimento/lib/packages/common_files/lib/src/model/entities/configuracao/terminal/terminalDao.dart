import 'dart:convert';

import 'package:common_files/src/bloc/hasura_bloc.dart';
import 'package:common_files/src/model/dao/dao.dart';
import 'package:common_files/src/model/entities/configuracao/terminal/terminal.dart';
import 'package:common_files/src/model/entities/configuracao/transacao/transacao.dart';
import 'package:common_files/src/model/entities/interfaces.dart';
import 'package:common_files/src/utils/constants.dart';

class TerminalDAO implements IEntityDAO {
  HasuraBloc _hasuraBloc;
  final String tableName = "terminal";
  int filterId = 0;
  String filterText = "";
  FilterEhDeletado filterEhDeletado = FilterEhDeletado.naoDeletados;

  Terminal terminal;
  List<Terminal> terminalList;

  @override
  Dao dao;

  TerminalDAO(this._hasuraBloc, {this.terminal}) {
    dao = Dao();
    //dao.createDb();
  }

  @override
  IEntity fromMap(Map<String, dynamic> map) {
    this.terminal.id = map['id'];
    this.terminal.idPessoa = map['id_pessoa'];
    this.terminal.idTransacao = map['id_transacao'];
    this.terminal.nome = map['nome'];
    this.terminal.ehDeletado = map['ehdeletado'];
    this.terminal.dataCadastro = DateTime.parse(map['data_cadastro']);
    this.terminal.dataAtualizacao = DateTime.parse(map['data_atualizacao']);
    return this.terminal;
  }

  @override
  Future<List> getAll({bool preLoad = false}) async {
    String where = "";
    List<dynamic> args = [];

    if (filterText != "") {
      where = "1 = 1 ";
      where = where + "and (nome like '%" + filterText + "%')";
    }

    List list = await dao.getList(this, where, args);
    terminalList = List.generate(list.length, (i) {
      return Terminal(
        id: list[i]['id'],
        idPessoa: list[i]['id_pessoa'],
        idTransacao: list[i]['id_transacao'],
        nome: list[i]['nome'],
        ehDeletado: list[i]['ehdeletado'],
        dataCadastro: DateTime.parse(list[i]['data_cadastro']),
        dataAtualizacao: DateTime.parse(list[i]['data_atualizacao']),
      );
    });
    return terminalList;
  }

  Future<List> getAllFromServer({bool preLoad=false, bool id=false, bool idPessoa=false, bool idTransacao=false,
    bool ehDeletado=false, bool dataCadastro=false, bool dataAtualizacao=false, String filtroNome=""}) async {
    String query = """ 
      {
        terminal(where: {
          ehdeletado: {${filterEhDeletado != FilterEhDeletado.todos ? filterEhDeletado == FilterEhDeletado.naoDeletados ? "_eq: 0" : "_eq: 1" : ""}}
          nome: {${filtroNome != "" ? '_ilike:  '+'"$filtroNome%"' : ''}}}, 
          order_by: {nome: asc}) {
            ${id ? "id" : ""}
            ${idPessoa ? "id_pessoa" : ""}
            ${idTransacao ? "id_transacao" : ""}
            nome
            ${ehDeletado ? "ehdeletado" : ""}
            ${dataCadastro ? "data_cadastro" : ""}
            ${dataAtualizacao ? "data_atualizacao" : ""}
        }
      }
    """;

    var data = await _hasuraBloc.hasuraConnect.query(query);
    terminalList = [];

      for(var i = 0; i < data['data']['terminal'].length; i++){
        terminalList.add(
          Terminal(
            id: data['data']['terminal'][i]['id'],
            idPessoa: data['data']['terminal'][i]['id_pessoa'],
            idTransacao: data['data']['terminal'][i]['id_transacao'],
            nome: data['data']['terminal'][i]['nome'],
            ehDeletado: data['data']['terminal'][i]['ehdeletado'],
            dataCadastro: data['data']['terminal'][i]['data_cadastro'],
            dataAtualizacao: data['data']['terminal'][i]['data_atualizacao']
          )       
        );
      }
      return terminalList;
    }
  
  @override
  Future<IEntity> getById(int id) async {
    return await dao.getById(this, id);
  }

  Future<IEntity> getByIdFromServer(int id) async {
    String query = """ 
      {
        terminal(where: {id: {_eq: $id}}) {
          id
          id_pessoa
          id_transacao
          nome
          ehdeletado
          data_cadastro
          data_atualizacao
          transacao {
            id
            nome
          }
        }
      }
    """;

    var data = await _hasuraBloc.hasuraConnect.query(query);
    Terminal _terminal = Terminal(
      id: data['data']['terminal'][0]['id'],
      idPessoa: data['data']['terminal'][0]['id_pessoa'],
      idTransacao: data['data']['terminal'][0]['id_transacao'],
      nome: data['data']['terminal'][0]['nome'],
      ehDeletado: data['data']['terminal'][0]['ehdeletado'],
      dataCadastro: DateTime.parse(data['data']['terminal'][0]['data_cadastro']),
      dataAtualizacao: DateTime.parse(data['data']['terminal'][0]['data_atualizacao']),
      transacao: Transacao(
        id: data['data']['terminal'][0]['transacao']['id'],
        nome: data['data']['terminal'][0]['transacao']['nome'],
      )
    );
    return _terminal;
  }


  @override
  Future<IEntity> insert() async {
    this.terminal.id = await dao.insert(this);
    return this.terminal;
  }

  Future<IEntity> saveOnServer() async {
    String _query = """ mutation saveTerminal {
        insert_terminal(objects: {""";

    if ((terminal.id != null) && (terminal.id > 0)) {
      _query = _query + "id: ${terminal.id},";
    }    

    _query = _query + """
        id_transacao: "${terminal.idTransacao}", 
        nome: "${terminal.nome}", 
        ehdeletado: ${terminal.ehDeletado}, 
        data_cadastro: "${terminal.dataCadastro}",
        data_atualizacao: "${terminal.dataAtualizacao}"},
        on_conflict: {
          constraint: terminal_pkey, 
          update_columns: [
            id_transacao,
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
      terminal.id = data["data"]["insert_terminal"]["returning"][0]["id"];
      return terminal;
    } catch (error) {
      return null;
    }  
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'id': this.terminal.id,
      'id_pessoa': this.terminal.idPessoa,
      'id_transacao': this.terminal.idTransacao,
      'nome': this.terminal.nome,
      'ehdeletado': this.terminal.ehDeletado,
      'data_cadastro': this.terminal.dataCadastro.toString(),
      'data_atualizacao': this.terminal.dataAtualizacao.toString(),
    };
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
