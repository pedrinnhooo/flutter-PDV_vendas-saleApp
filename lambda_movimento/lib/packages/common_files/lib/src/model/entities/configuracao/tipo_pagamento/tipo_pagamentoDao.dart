import 'package:common_files/src/bloc/hasura_bloc.dart';
import 'package:common_files/src/model/dao/dao.dart';
import 'package:common_files/src/model/entities/configuracao/tipo_pagamento/tipo_pagamento.dart';
import 'package:common_files/src/model/entities/interfaces.dart';

class TipoPagamentoDAO implements IEntityDAO {
  HasuraBloc _hasuraBloc;
  final String tableName = "tipo_pagamento";
  int filterId;
  String filterText;

  TipoPagamento _tipoPagamento;
  List<TipoPagamento> tipoPagamentoList;

  @override
  Dao dao;

  TipoPagamentoDAO({TipoPagamento tipoPagamento}) {
    dao = Dao();
    _tipoPagamento = tipoPagamento;
  }

  @override
  IEntity fromMap(Map<String, dynamic> map) {
    this._tipoPagamento.id = map['id'];
    this._tipoPagamento.idPessoaGrupo = map['id_pessoa_grupo'];
    this._tipoPagamento.nome = map['nome'];
    this._tipoPagamento.icone = map['icone'];
    this._tipoPagamento.ehDinheiro = map['ehdinheiro'];
    this._tipoPagamento.ehFiado = map['ehfiado'];
    this._tipoPagamento.ehDeletado = map['ehdeletado'];
    this._tipoPagamento.dataCadastro = map['data_cadastro'];
    this._tipoPagamento.dataAtualizacao = map['data_atualizacao'];
    return this._tipoPagamento;
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
    tipoPagamentoList = List.generate(list.length, (i) {
      return TipoPagamento(
        id: list[i]['id'],
        idPessoaGrupo: list[i]['id_pessoa_grupo'],
        nome: list[i]['nome'],
        icone: list[i]['icone'],
        ehDinheiro: list[i]['ehdinheiro'],
        ehFiado: list[i]['ehfiado'],
        ehDeletado: list[i]['ehdeletado'],
        dataCadastro: list[i]['data_cadastro'],
        dataAtualizacao: list[i]['data_atualizacao'],
      );
    });

    return tipoPagamentoList;
  }

  @override
  Future<IEntity> getById(int id) async {
    _tipoPagamento = await dao.getById(this, id);
    return _tipoPagamento;
  }

  @override
  Future<IEntity> insert() async {
    this._tipoPagamento.id = await dao.insert(this);
    return this._tipoPagamento;
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'id': _tipoPagamento.id,
      'id_pessoa_grupo': _tipoPagamento.idPessoaGrupo,
      'nome': _tipoPagamento.nome,
      'icone': _tipoPagamento.icone,
      'ehdinheiro': _tipoPagamento.ehDinheiro,
      'ehfiado': _tipoPagamento.ehFiado,
      'ehdeletado': _tipoPagamento.ehDeletado,
      'data_cadastro': _tipoPagamento.dataCadastro,
      'data_atualizacao': _tipoPagamento.dataAtualizacao,
    };
  }

  getByIdFromServer(int id) async {
    String query = """ 
      {
        tipo_pagamento(where: {id: {_eq: $id}}) {
          id
          id_pessoa_grupo
          nome
          icone
          ehdeletado
          data_cadastro
          data_atualizacao
        }
      }
    """;

    var data = await _hasuraBloc.hasuraConnect.query(query);
    _tipoPagamento = TipoPagamento(
      id: data['data']['tipo_pagamento'][0]['id'],
      idPessoaGrupo: data['data']['tipo_pagamento'][0]['id_pessoa_grupo'],
      nome: data['data']['tipo_pagamento'][0]['nome'],
      icone: data['data']['tipo_pagamento'][0]['icone'],
      ehDeletado: data['data']['tipo_pagamento'][0]['ehdeletado'],
      dataCadastro: DateTime.parse(data['data']['tipo_pagamento'][0]['data_cadastro']),
      dataAtualizacao: DateTime.parse(data['data']['tipo_pagamento'][0]['data_atualizacao']),
    );
    return _tipoPagamento;
  }

  Future<IEntity> saveOnServer() async {
     String _query = """mutation saveTipoPagamento {
        insert_tipo_pagamento(objects: {""";

    if ((_tipoPagamento.id != null) && (_tipoPagamento.id > 0)) {
      _query = _query + "id: ${_tipoPagamento.id},";
    }

    _query = _query + """
            nome: "${_tipoPagamento.nome}",
            icone: "${_tipoPagamento.icone}",
            ehdeletado: ${_tipoPagamento.ehDeletado},
            data_cadastro: "${_tipoPagamento.dataCadastro}",
            data_atualizacao: "${_tipoPagamento.dataAtualizacao}"
          }, on_conflict: {
            constraint: tipo_pagamento_pkey,
            update_columns: [
              nome, 
              icone,
              ehdeletado,
              data_atualizacao
            ]
          }
        ) {
          returning {
            id
          }
        }
      }
    """;

    try {
      var data = await _hasuraBloc.hasuraConnect.mutation(_query);
      _tipoPagamento.id = data["data"]["insert_tipo_pagamento"]["returning"][0]["id"];
      return _tipoPagamento;
    } catch (error) {
      return null;
    }  
  }

  Future<List<TipoPagamento>> getAllFromServer({bool id=false, bool idPessoaGrupo=false, bool icone=false,
    bool ehDeletado=false, bool dataCadastro=false, bool dataAtualizacao=false, String filtroNome=""}) async {
    String query = """{
      tipo_pagamento(
        order_by: {id: asc}, 
        where: {nome: {${filtroNome != "" ? '_ilike:  '+'"$filtroNome%"' : ''}}},
      ) {
          ${id ? "id" : ""}
          ${idPessoaGrupo ? "id_pessoa_grupo" : ""}
          nome
          ${icone ? "icone" : ""}
          ${ehDeletado ? "ehdeletado" : ""}
          ${dataCadastro ? "data_cadastro" : ""}
          ${dataAtualizacao ? "data_atualizacao" : ""}
        }
      }
    """;
    
    var data = await _hasuraBloc.hasuraConnect.query(query);
    tipoPagamentoList = [];

    for(var i = 0; i < data['data']['tipo_pagamento'].length; i++){
      tipoPagamentoList.add(
        TipoPagamento(
          id: data['data']['tipo_pagamento'][i]['id'],
          idPessoaGrupo: data['data']['tipo_pagamento'][i]['id_pessoa_grupo'],
          nome: data['data']['tipo_pagamento'][i]['nome'],
          icone: data['data']['tipo_pagamento'][i]['icone'],
          ehDeletado: data['data']['tipo_pagamento'][i]['ehdeletado'],
          dataCadastro: data['data']['tipo_pagamento'][i]['data_cadastro'],
          dataAtualizacao: data['data']['tipo_pagamento'][i]['data_atualizacao']
        )       
      );
    }
    return tipoPagamentoList;
  }
}
