import 'package:common_files/src/bloc/hasura_bloc.dart';
import 'package:common_files/src/model/dao/dao.dart';
import 'package:common_files/src/model/entities/cadastro/preco_tabela/preco_tabela.dart';
import 'package:common_files/src/model/entities/configuracao/transacao/transacao.dart';
import 'package:common_files/src/model/entities/interfaces.dart';

class TransacaoDAO implements IEntityDAO {
  HasuraBloc _hasuraBloc;
  final String tableName = "transacao";
  int filterId = 0;
  String filterText = "";
  int filterEhDeletado = 0;

  Transacao _transacao;
  List<Transacao> _transacaoList;

  @override
  Dao dao;

  TransacaoDAO(this._hasuraBloc, Transacao transacao) {
    dao = Dao();
    _transacao = transacao != null ? transacao : Transacao();
    _transacaoList = [];
  }

  @override
  IEntity fromMap(Map<String, dynamic> map) {
    _transacao.id = map['id'];
    _transacao.idPessoaGrupo = map['id_pessoa_grupo'];
    _transacao.idPrecoTabela = map['id_preco_tabela'];
    _transacao.nome = map['nome'];
    _transacao.tipoEstoque = map['tipo_estoque'];
    _transacao.temPagamento = map['tem_pagamento'];
    _transacao.temVendedor = map['tem_vendedor'];
    _transacao.temCliente = map['tem_cliente'];
    _transacao.descontoPercentual = map['desconto_percentual'];
    _transacao.ehDeletado = map['ehdeletado'];
    _transacao.dataCadastro = map['data_cadastro'];
    _transacao.dataAtualizacao = map['data_atualizacao'];
    return _transacao;
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
    _transacaoList = List.generate(list.length, (i) {
      return Transacao(
        id: list[i]['id'],
        idPessoaGrupo: list[i]['id_pessoa_grupo'],
        idPrecoTabela: list[i]['id_preco_tabela'],
        nome: list[i]['nome'],
        tipoEstoque: list[i]['tipo_estoque'],
        temPagamento: list[i]['tem_pagamento'],
        temVendedor: list[i]['tem_vendedor'],
        temCliente: list[i]['tem_cliente'],
        descontoPercentual: list[i]['desconto_percentual'],
        ehDeletado: list[i]['ehdeletado'],
        dataCadastro: DateTime.parse(list[i]['data_cadastro']),
        dataAtualizacao: DateTime.parse(list[i]['data_atualizacao']),
      );
    });

    return _transacaoList;
  }

  Future<List> getAllFromServer({bool preLoad=false, bool id=false, bool idPessoaGrupo=false,
    bool tipoEstoque=false, bool temPagamento=false, bool temVendedor=false, bool temCliente=false,
    bool descontoPercentual=false, bool idPrecoTabela=false,
    bool ehDeletado=false, bool dataCadastro=false, bool dataAtualizacao=false, String filtroNome=""}) async {
    String query = """ 
      {
        transacao(where: {
          ehdeletado: {_eq: $filterEhDeletado},
          nome: {${filtroNome != "" ? '_ilike:  '+'"$filtroNome%"' : ''}}}, 
          order_by: {nome: asc}) {
            ${id ? "id" : ""}
            ${idPessoaGrupo ? "id_pessoa_grupo" : ""}
            nome
            ${tipoEstoque ? "tipo_estoque" : ""}
            ${temPagamento ? "tem_pagamento" : ""}
            ${temVendedor ? "tem_vendedor" : ""}
            ${temCliente ? "tem_cliente" : ""}
            ${descontoPercentual ? "desconto_percentual" : ""}
            ${idPrecoTabela ? "id_preco_tabela" : ""}
            ${ehDeletado ? "ehdeletado" : ""}
            ${dataCadastro ? "data_cadastro" : ""}
            ${dataAtualizacao ? "data_atualizacao" : ""}
        }
      }
    """;

    var data = await _hasuraBloc.hasuraConnect.query(query);
    _transacaoList = [];

      for(var i = 0; i < data['data']['transacao'].length; i++){
        _transacaoList.add(
          Transacao(
            id: data['data']['transacao'][i]['id'],
            idPessoaGrupo: data['data']['transacao'][i]['id_pessoa'],
            nome: data['data']['transacao'][i]['nome'],
            tipoEstoque: data['data']['transacao'][i]['tipo_estoque'],
            temPagamento: data['data']['transacao'][i]['tem_pagamento'],
            temVendedor: data['data']['transacao'][i]['tem_vendedor'],
            temCliente: data['data']['transacao'][i]['tem_cliente'],
            descontoPercentual: data['data']['transacao'][i]['desconto_percentual'],
            idPrecoTabela: data['data']['transacao'][i]['id_preco_tabela'],
            ehDeletado: data['data']['transacao'][i]['ehdeletado'],
            dataCadastro: data['data']['transacao'][i]['data_cadastro'],
            dataAtualizacao: data['data']['transacao'][i]['data_atualizacao']
          )       
        );
      }
      return _transacaoList;
  }

  @override
  Future<IEntity> getById(int id) async {
    _transacao = await dao.getById(this, id);
    return _transacao;
  }

  Future<IEntity> getByIdFromServer(int id) async {
    String query = """ 
      {
        transacao(where: {id: {_eq: $id}}) {
          id
          id_pessoa_grupo
          nome
          tipo_estoque
          tem_pagamento
          tem_vendedor
          tem_cliente
          desconto_percentual
          id_preco_tabela
          ehdeletado
          data_cadastro
          data_atualizacao
          preco_tabela {
            id
            nome
          }
        }
      }
    """;

    var data = await _hasuraBloc.hasuraConnect.query(query);
    Transacao transacao = Transacao(
      id: data['data']['transacao'][0]['id'],
      idPessoaGrupo: data['data']['transacao'][0]['id_pessoa'],
      nome: data['data']['transacao'][0]['nome'],
      tipoEstoque: data['data']['transacao'][0]['tipo_estoque'],
      temPagamento: data['data']['transacao'][0]['tem_pagamento'],
      temVendedor: data['data']['transacao'][0]['tem_vendedor'],
      temCliente: data['data']['transacao'][0]['tem_cliente'],
      descontoPercentual: data['data']['transacao'][0]['desconto_percentual'].toDouble(),
      idPrecoTabela: data['data']['transacao'][0]['id_preco_tabela'],
      ehDeletado: data['data']['transacao'][0]['ehdeletado'],
      dataCadastro: DateTime.parse(data['data']['transacao'][0]['data_cadastro']),
      dataAtualizacao: DateTime.parse(data['data']['transacao'][0]['data_atualizacao']),
      precoTabela: PrecoTabela(
        id: data['data']['transacao'][0]['preco_tabela']['id'],
        nome: data['data']['transacao'][0]['preco_tabela']['nome'],
      )
    );
    return transacao;
  }
  
  @override
  Future<IEntity> insert() async {
    _transacao.id = await dao.insert(this);
    return _transacao;
  }

  Future<IEntity> saveOnServer() async {
    String _query = """ mutation saveTransacao {
        insert_transacao(objects: {""";

    if ((_transacao.id != null) && (_transacao.id > 0)) {
      _query = _query + "id: ${_transacao.id},";
    }    

    _query = _query + """
        nome: "${_transacao.nome}", 
        tipo_estoque: "${_transacao.tipoEstoque}", 
        tem_pagamento: "${_transacao.temPagamento}", 
        tem_vendedor: "${_transacao.temVendedor}", 
        tem_cliente: "${_transacao.temCliente}", 
        desconto_percentual: "${_transacao.descontoPercentual}", 
        id_preco_tabela: "${_transacao.idPrecoTabela}", 
        ehdeletado: ${_transacao.ehDeletado}, 
        data_cadastro: "${_transacao.dataCadastro}",
        data_atualizacao: "${_transacao.dataAtualizacao}"},
        on_conflict: {
          constraint: transacao_pkey, 
          update_columns: [
            nome, 
            tipo_estoque,
            tem_pagamento,
            tem_vendedor,
            tem_cliente,
            desconto_percentual,
            id_preco_tabela,
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
      _transacao.id = data["data"]["insert_transacao"]["returning"][0]["id"];
      return _transacao;
    } catch (error) {
      return null;
    }  
  }  

  @override
  Map<String, dynamic> toMap() {
    return {
      'id': _transacao.id,
      'id_pessoa_grupo': _transacao.idPessoaGrupo,
      'id_preco_tabela': _transacao.idPrecoTabela,
      'nome': _transacao.nome,
      'tipo_estoque': _transacao.tipoEstoque,
      'tem_pagamento': _transacao.temPagamento,
      'tem_vendedor': _transacao.temVendedor,
      'tem_cliente': _transacao.temCliente,
      'desconto_percentual': _transacao.descontoPercentual.toDouble(),
      'ehdeletado': _transacao.ehDeletado,
      'data_cadastro': _transacao.dataCadastro,
      'data_atualizacao': _transacao.dataAtualizacao
    };
  }
}
