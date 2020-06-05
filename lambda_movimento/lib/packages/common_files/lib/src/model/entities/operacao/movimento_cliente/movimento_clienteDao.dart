import 'package:common_files/src/model/dao/dao.dart';
import 'package:common_files/src/model/entities/interfaces.dart';
import 'package:common_files/src/model/entities/operacao/movimento_cliente/movimento_cliente.dart';
import 'package:common_files/src/utils/functions.dart';

class MovimentoClienteDAO implements IEntityDAO {
  final String tableName = "movimento_cliente";
  int filterMovimento = 0;
  int filterIdCliente = 0;
  DateTime filterDataInicial;
  bool filterBasico = true;
    
  MovimentoCliente movimentoCliente;
  List<MovimentoCliente> movimentoClienteList;
  
  @override
  Dao dao;

  MovimentoClienteDAO(this.movimentoCliente) {
    dao = Dao();
    movimentoCliente = movimentoCliente == null ? MovimentoCliente() : movimentoCliente;
  }  

  @override
  IEntity fromMap(Map<String, dynamic> map) {}

  @override
  Future<List> getAll({bool preLoad=false}) async {
    String where = "1 = 1 ";
    List<dynamic> args = [];
    List list = [];

    if (!filterBasico) {
      where = filterMovimento > 0 ? where + " and id_app_movimento = $filterMovimento" : where; 
      where = filterDataInicial != null ? where + " and date(data) >= '${ourDate(filterDataInicial)}'" : where; 
      where = filterIdCliente > 0 ? where + " and id_cliente = $filterIdCliente" : where; 
      list = await dao.getList(this, where, args);
    } else {
      String query = """
        select m.*
        from movimento_cliente m
        where m.id_cliente = $filterIdCliente
        order by m.id_app desc
        limit 10
      """;
      list = await dao.getRawQuery(query);
    }

    movimentoClienteList = List.generate(list.length, (i) {
      return MovimentoCliente(
        idApp: list[i]['id_app'],
        id: list[i]['id'],
        idPessoa: list[i]['id_pessoa'],
        idCliente: list[i]['id_cliente'],
        idAppMovimento: list[i]['id_app_movimento'],
        idMovimento: list[i]['id_movimento'],
        idTipoPagamento: list[i]['id_tipo_pagamento'],
        data: DateTime.parse(list[i]['data']),
        valor: list[i]['valor'],
        descricao: list[i]['descricao'],
        observacao: list[i]['observacao'],
        saldo: list[i]['saldo'],
        dataCadastro: DateTime.parse(list[i]['data_cadastro']),
        dataAtualizacao: DateTime.parse(list[i]['data_atualizacao']),
      );
    });
    
    movimentoClienteList.sort((a, b) => a.idApp.compareTo(b.idApp));
   
    return movimentoClienteList;
  }

  @override
  Future<IEntity> getById(int id) async {
    movimentoCliente = await dao.getById(this, id);
    return movimentoCliente;
  }

  @override
  Future<IEntity> insert() async {
    this.movimentoCliente.idApp = await dao.insert(this);
    return this.movimentoCliente;
  }

  @override
  Future<IEntity> delete(int id) async {
    await dao.delete(this, id);
    return this.movimentoCliente;
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'id_app': this.movimentoCliente.idApp,
      'id': this.movimentoCliente.id,
      'id_pessoa': this.movimentoCliente.idPessoa,
      'id_cliente': this.movimentoCliente.idCliente,
      'id_app_movimento': this.movimentoCliente.idAppMovimento,
      'id_movimento': this.movimentoCliente.idMovimento,
      'id_tipo_pagamento': this.movimentoCliente.idTipoPagamento,
      'data': this.movimentoCliente.data.toString(),
      'valor': this.movimentoCliente.valor,
      'descricao': this.movimentoCliente.descricao,
      'observacao': this.movimentoCliente.observacao,
      'saldo': this.movimentoCliente.saldo,
      'data_cadastro': this.movimentoCliente.dataCadastro.toString(),
      'data_atualizacao': this.movimentoCliente.dataAtualizacao.toString(),
    };
  }

  Future<double> getSaldoAtual(int idCliente) async {
    List<Map<dynamic, dynamic>> result = [];
    String query = """
      select m.saldo
      from movimento_cliente m
      where m.id_cliente = $idCliente
      order by m.id_app desc
      limit 1
    """;
    result = await dao.getRawQuery(query);
    return ((result.length > 0) && (result[0]["saldo"].toDouble() != null)) ? result[0]["saldo"].toDouble() : 0;  
  }

}
