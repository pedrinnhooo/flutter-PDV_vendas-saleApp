import 'package:common_files/common_files.dart';

class TipoPagamentoDAO implements IEntityDAO {
  HasuraBloc _hasuraBloc;
  AppGlobalBloc _appGlobalBloc;
  final String tableName = "tipo_pagamento";
  int filterId = 0;
  String filterText = "";
  bool filterEhDinheiro = false;

  TipoPagamento _tipoPagamento;
  List<TipoPagamento> tipoPagamentoList = [];

  @override
  Dao dao;

  TipoPagamentoDAO(this._hasuraBloc, this._appGlobalBloc, {TipoPagamento tipoPagamento}) {
    dao = Dao();
    _tipoPagamento = tipoPagamento;
  }

  @override
  IEntity fromMap(Map<String, dynamic> map) {
    try {
      this._tipoPagamento.id = map['id'];
      this._tipoPagamento.idPessoaGrupo = map['id_pessoa_grupo'];
      this._tipoPagamento.nome = map['nome'];
      this._tipoPagamento.icone = map['icone'];
      this._tipoPagamento.ehDinheiro = map['ehdinheiro'];
      this._tipoPagamento.ehFiado = map['ehfiado'];
      this._tipoPagamento.ehQrcode = map['ehqrcode'];
      this._tipoPagamento.ehDeletado = map['ehdeletado'];
      this._tipoPagamento.dataCadastro = DateTime.parse(map['data_cadastro']);
      this._tipoPagamento.dataAtualizacao = DateTime.parse(map['data_atualizacao']);
    } catch(error, stacktrace) {
      _appGlobalBloc.logger.e(error.toString(), '<tipo_pagamentoDao> fromMap');
      log(_hasuraBloc, _appGlobalBloc,
        nomeArquivo: "tipo_pagamentoDao",
        nomeFuncao: "fromMap",
        error: error.toString(),
        stacktrace: stacktrace.toString()
      );
    }
    return this._tipoPagamento;
  }

  @override
  Future<List> getAll({bool preLoad = false}) async {
    String where;
    try {
      where = "id_pessoa_grupo = ${_appGlobalBloc.loja.idPessoaGrupo} ";
      List<dynamic> args = [];
      if ((filterId > 0) || (filterText != "")) {
        if (filterId > 0) {
          where = where + "and (id = " + filterText + ") ";
        }
        if (filterText != "") {
          where = where + "and (nome like '%" + filterText + "%') ";
        }
      }

      where = filterEhDinheiro ? where + "and (ehdinheiro = 1) " : where;

      List list = await dao.getList(this, where, args);
      tipoPagamentoList = List.generate(list.length, (i) {
        return TipoPagamento(
          id: list[i]['id'],
          idPessoaGrupo: list[i]['id_pessoa_grupo'],
          nome: list[i]['nome'],
          icone: list[i]['icone'],
          ehDinheiro: list[i]['ehdinheiro'],
          ehFiado: list[i]['ehfiado'],
          ehQrcode: list[i]['ehqrcode'],
          ehDeletado: list[i]['ehdeletado'],
          dataCadastro: DateTime.parse(list[i]['data_cadastro']),
          dataAtualizacao: DateTime.parse(list[i]['data_atualizacao']),
        );
      });
    } catch(error, stacktrace) {
      _appGlobalBloc.logger.e(error.toString(), '<tipo_pagamentoDao> getAll');
      log(_hasuraBloc, _appGlobalBloc,
        nomeArquivo: "tipo_pagamentoDao",
        nomeFuncao: "getAll",
        error: error.toString(),
        stacktrace: stacktrace.toString(),
        query: where
      );
    }
    return tipoPagamentoList;
  }

  Future<List<TipoPagamento>> getAllFromServer({bool id=false, bool idPessoaGrupo=false, bool icone=false,
    bool ehDinheiro=false, bool ehFiado=false, bool ehQrcode=false, bool ehDeletado=false, int offset = 0,
    bool dataCadastro=false, bool dataAtualizacao=false, String filtroNome="",
    DateTime filtroDataAtualizacao, FilterEhDeletado filterEhDeletado=FilterEhDeletado.naoDeletados}) async {
    String query;
    try {
      query = """{
        tipo_pagamento(
          limit: $queryLimit, 
          offset: $offset,
          where: {
          ehdeletado: {${filterEhDeletado != FilterEhDeletado.todos ? filterEhDeletado == FilterEhDeletado.naoDeletados ? "_eq: 0" : "_eq: 1" : ""}},
          nome: {${filtroNome != "" ? '_ilike:  '+'"filtroNome%"' : ''}},
          data_atualizacao: {${filtroDataAtualizacao != null ? '_gt:  '+'"${filtroDataAtualizacao.toIso8601String()}"' : ''}}}, 
          order_by: {${filtroDataAtualizacao == null ? 'id: asc' : 'data_atualizacao: asc'}}) {
            ${id ? "id" : ""}
            ${idPessoaGrupo ? "id_pessoa_grupo" : ""}
            nome
            ${icone ? "icone" : ""}
            ${ehDinheiro ? "ehdinheiro" : ""}
            ${ehFiado ? "ehfiado" : ""}
            ${ehQrcode ? "ehqrcode" : ""}
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
            ehDinheiro: data['data']['tipo_pagamento'][i]['ehdinheiro'],
            ehFiado: data['data']['tipo_pagamento'][i]['ehfiado'],
            ehQrcode: data['data']['tipo_pagamento'][i]['ehqrcode'],
            ehDeletado: data['data']['tipo_pagamento'][i]['ehdeletado'],
            dataCadastro: data['data']['tipo_pagamento'][i]['data_cadastro'] != null ? DateTime.parse(data['data']['tipo_pagamento'][i]['data_cadastro']) : null,
            dataAtualizacao: data['data']['tipo_pagamento'][i]['data_atualizacao'] != null ? DateTime.parse(data['data']['tipo_pagamento'][i]['data_atualizacao']) : null
          )       
        );
      }
    } catch(error, stacktrace) {
      _appGlobalBloc.logger.e(error.toString(), '<tipo_pagamentoDao> getAllFromServer');
      log(_hasuraBloc, _appGlobalBloc,
        nomeArquivo: "tipo_pagamentoDao",
        nomeFuncao: "getAllFromServer",
        error: error.toString(),
        stacktrace: stacktrace.toString(),
        query: query
      );
    }
    return tipoPagamentoList;
  }

  @override
  Future<IEntity> getById(int id) async {
    try {
      _tipoPagamento = await dao.getById(this, id);
      return _tipoPagamento;
    } catch(error, stacktrace) {
      _appGlobalBloc.logger.e(error.toString(), '<tipo_pagamentoDao> getById');
      log(_hasuraBloc, _appGlobalBloc,
        nomeArquivo: "tipo_pagamentoDao",
        nomeFuncao: "getById",
        error: error.toString(),
        stacktrace: stacktrace.toString(),
        query: "id: $id"
      );
      return null;
    }
  }

  getByIdFromServer(int id) async {
    String query;
    try {
      query = """ 
        {
          tipo_pagamento(where: {id: {_eq: $id}}) {
            id
            id_pessoa_grupo
            nome
            icone
            ehdinheiro
            ehfiado
            ehqrcode
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
        ehDinheiro: data['data']['tipo_pagamento'][0]['ehdinheiro'],
        ehFiado: data['data']['tipo_pagamento'][0]['ehfiado'],
        ehQrcode: data['data']['tipo_pagamento'][0]['ehqrcode'],
        ehDeletado: data['data']['tipo_pagamento'][0]['ehdeletado'],
        dataCadastro: DateTime.parse(data['data']['tipo_pagamento'][0]['data_cadastro']),
        dataAtualizacao: DateTime.parse(data['data']['tipo_pagamento'][0]['data_atualizacao']),
      );
      return _tipoPagamento;
    } catch(error, stacktrace) {
      _appGlobalBloc.logger.e(error.toString(), '<tipo_pagamentoDao> getByIdFromServer');
      log(_hasuraBloc, _appGlobalBloc,
        nomeArquivo: "tipo_pagamentoDao",
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
      List<Map> data = await dao.getRawQuery("select max(data_atualizacao) as data_atualizacao from tipo_pagamento where id_pessoa_grupo = ${_appGlobalBloc.loja.idPessoaGrupo} ");
      return data[0]['data_atualizacao'] != null ? DateTime.tryParse(data[0]['data_atualizacao']) : DateTime.parse("2019-01-01T00:00:01.000000");
    } catch(error, stacktrace) {
      _appGlobalBloc.logger.e(error.toString(), '<tipo_pagamentoDao> getUltimaSincronizacao');
      log(_hasuraBloc, _appGlobalBloc,
        nomeArquivo: "tipo_pagamentoDao",
        nomeFuncao: "getUltimaSincronizacao",
        error: error.toString(),
        stacktrace: stacktrace.toString(),
      );
      return DateTime.now();
    }
  }

  @override
  Future<IEntity> insert() async {
    try {
      this._tipoPagamento.id = await dao.insert(this);
    } catch(error, stacktrace) {
      _appGlobalBloc.logger.e(error.toString(), '<tipo_pagamentoDao> insert');
      log(_hasuraBloc, _appGlobalBloc,
        nomeArquivo: "tipo_pagamentoDao",
        nomeFuncao: "insert",
        error: error.toString(),
        stacktrace: stacktrace.toString(),
        object: _tipoPagamento.toString()
      );
    }
    return this._tipoPagamento;
  }

  Future<IEntity> saveOnServer() async {
    String _query;
    try {
      _query = """mutation saveTipoPagamento {
        update_sincronizacao(where: {}, _set: {data_atualizacao: "now()"}) {
          returning {
            data_atualizacao
          }
        }

        insert_tipo_pagamento(objects: {
      """;

      if ((_tipoPagamento.id != null) && (_tipoPagamento.id > 0)) {
        _query = _query + "id: ${_tipoPagamento.id},";
      }

      _query = _query + """
              nome: "${_tipoPagamento.nome}",
              icone: "${_tipoPagamento.icone}",
              ehdinheiro: ${_tipoPagamento.ehDinheiro},
              ehfiado: ${_tipoPagamento.ehFiado},
              ehqrcode: ${_tipoPagamento.ehQrcode},
              ehdeletado: ${_tipoPagamento.ehDeletado},
              data_atualizacao: "now()"
            }, on_conflict: {
              constraint: tipo_pagamento_pkey,
              update_columns: [
                nome, 
                icone,
                ehdinheiro,
                ehfiado,
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

      var data = await _hasuraBloc.hasuraConnect.mutation(_query);
      _tipoPagamento.id = data["data"]["insert_tipo_pagamento"]["returning"][0]["id"];
      return _tipoPagamento;
    } catch(error, stacktrace) {
      _appGlobalBloc.logger.e(error.toString(), '<tipo_pagamentoDao> saveOnServer');
      log(_hasuraBloc, _appGlobalBloc,
        nomeArquivo: "tipo_pagamentoDao",
        nomeFuncao: "saveOnServer",
        error: error.toString(),
        stacktrace: stacktrace.toString(),
        query: _query,
        object: _tipoPagamento.toString()
      );
    }
  }

  @override
  Future<IEntity> delete(int id) async {
    return _tipoPagamento;
  }
    
  @override
  Map<String, dynamic> toMap() {
    try {
      return {
        'id': _tipoPagamento.id,
        'id_pessoa_grupo': _tipoPagamento.idPessoaGrupo,
        'nome': _tipoPagamento.nome,
        'icone': _tipoPagamento.icone,
        'ehdinheiro': _tipoPagamento.ehDinheiro,
        'ehfiado': _tipoPagamento.ehFiado,
        'ehqrcode': _tipoPagamento.ehQrcode,
        'ehdeletado': _tipoPagamento.ehDeletado,
        'data_cadastro': _tipoPagamento.dataCadastro.toString(),
        'data_atualizacao': _tipoPagamento.dataAtualizacao.toString(),
      };
    } catch(error, stacktrace) {
      _appGlobalBloc.logger.e(error.toString(), '<tipo_pagamentoDao> toMap');
      log(_hasuraBloc, _appGlobalBloc,
        nomeArquivo: "tipo_pagamentoDao",
        nomeFuncao: "toMap",
        error: error.toString(),
        stacktrace: stacktrace.toString()
      );
      return null;
    }
  }

}
