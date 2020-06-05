import 'package:common_files/src/model/dao/dao.dart';
import 'package:common_files/src/model/entities/interfaces.dart';
import 'package:common_files/src/model/entities/operacao/movimento_caixa/movimento_caixa_parcela.dart';

class MovimentoCaixaParcelaDAO implements IEntityDAO {
  final String tableName = "movimento_caixa_parcela";
  int filterMovimentoCaixa = 0;
    
  MovimentoCaixaParcela movimentoCaixaParcela;
  List<MovimentoCaixaParcela> movimentoCaixaParcelaList;
  
  @override
  Dao dao;

  MovimentoCaixaParcelaDAO(this.movimentoCaixaParcela) {
    dao = Dao();
    movimentoCaixaParcela = movimentoCaixaParcela == null ? MovimentoCaixaParcela() : movimentoCaixaParcela;
  }  

  @override
  IEntity fromMap(Map<String, dynamic> map) {}

  @override
  Future<List> getAll({bool preLoad=false}) async {
    String where = "1 = 1 ";
    where = filterMovimentoCaixa > 0 ? where + " and id_app_movimento_caixa = $filterMovimentoCaixa" : where; 

    List<dynamic> args = [];

    List list = await dao.getList(this, where, args);
    movimentoCaixaParcelaList = List.generate(list.length, (i) {
      return MovimentoCaixaParcela(
        idApp: list[i]['id_app'],
        id: list[i]['id'],
        idAppMovimentoCaixa: list[i]['id_app_movimento_caixa'],
        idMovimentoCaixa: list[i]['id_movimento_caixa'],
        idTipoPagamento: list[i]['id_tipo_pagamento'],
        data: DateTime.parse(list[i]['data']),
        descricao: list[i]['descricao'],
        valor: list[i]['valor'],
        observacao: list[i]['observacao'],
        dataCadastro: DateTime.parse(list[i]['data_cadastro']),
        dataAtualizacao: DateTime.parse(list[i]['data_atualizacao']),
      );
    });
   
    return movimentoCaixaParcelaList;
  }

  @override
  Future<IEntity> getById(int id) async {
    movimentoCaixaParcela = await dao.getById(this, id);
    return movimentoCaixaParcela;
  }

  @override
  Future<IEntity> insert() async {
    this.movimentoCaixaParcela.idApp = await dao.insert(this);
    return this.movimentoCaixaParcela;
  }

  @override
  Future<IEntity> delete(int id) async {
    await dao.delete(this, id);
    return this.movimentoCaixaParcela;
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'id_app': this.movimentoCaixaParcela.idApp,
      'id': this.movimentoCaixaParcela.id,
      'id_movimento_caixa': this.movimentoCaixaParcela.idMovimentoCaixa,
      'id_app_movimento_caixa': this.movimentoCaixaParcela.idAppMovimentoCaixa,
      'id_tipo_pagamento': this.movimentoCaixaParcela.idTipoPagamento,
      'data': this.movimentoCaixaParcela.data.toString(),
      'descricao': this.movimentoCaixaParcela.descricao,
      'valor': this.movimentoCaixaParcela.valor,
      'observacao': this.movimentoCaixaParcela.observacao,
      'data_cadastro': this.movimentoCaixaParcela.dataCadastro.toString(),
      'data_atualizacao': this.movimentoCaixaParcela.dataAtualizacao.toString(),
    };
  }
}
