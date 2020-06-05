import 'package:common_files/src/model/dao/dao.dart';
import 'package:common_files/src/model/entities/configuracao/tipo_pagamento/tipo_pagamento.dart';
import 'package:common_files/src/model/entities/interfaces.dart';
import 'package:common_files/src/model/entities/operacao/movimento/movimento_parcela.dart';

class MovimentoParcelaDAO implements IEntityDAO {
  final String tableName = "movimento_parcela";
  String filterText;
  int filterMovimento;
  bool loadTipoPagamento = false;
    
  MovimentoParcela movimentoParcela;
  TipoPagamento tipoPagamento;
  List<MovimentoParcela> movimentoParcelaList;

  @override
  Dao dao;

  MovimentoParcelaDAO(this.movimentoParcela) {
    dao = Dao();
    movimentoParcela = movimentoParcela == null ? MovimentoParcela() : movimentoParcela;
    tipoPagamento = tipoPagamento == null ? TipoPagamento() : tipoPagamento;
  }  

  @override
  IEntity fromMap(Map<String, dynamic> map) {}

  @override
  Future<List> getAll({bool preLoad=false}) async {
    String where = "1 = 1";
    where = filterMovimento > 0 ? where + " and id_movimento_app = $filterMovimento" : where; 

    List<dynamic> args = [];

    List list = await dao.getList(this, where, args);
    movimentoParcelaList = List.generate(list.length, (i) {
      return MovimentoParcela(
               idApp: list[i]['id_app'],
               id: list[i]['id'],
               idMovimentoApp: list[i]['id_movimento_app'],
               idMovimento: list[i]['id_movimento'],
               idTipoPagamento: list[i]['id_tipo_pagamento'],
               valor: list[i]['valor'],
               dataCadastro: DateTime.parse(list[i]['data_cadastro']),
               dataAtualizacao: DateTime.parse(list[i]['data_atualizacao']),
      );
    });
   
    if (preLoad) {
      for (var movimentoParcela in movimentoParcelaList){
        /*this.tipoPagamento = TipoPagamento();
        ProdutoDAO produtoDAO = ProdutoDAO(this.produto);

        movimentoItem.produto = loadProduto ? await produtoDAO.getById(movimentoItem.idProduto) : movimentoItem.produto;

        produtoDAO = null;*/
      }
    }  
    return movimentoParcelaList;  
  }

  @override
  Future<IEntity> getById(int id) async {
    movimentoParcela = await dao.getById(this, id);
    return movimentoParcela;
  }

  @override
  Future<IEntity> insert() async {
    this.movimentoParcela.idApp = await dao.insert(this);
    return this.movimentoParcela;
  }

  @override
  Future<IEntity> delete(int id) async {
    await dao.delete(this, id);
    return this.movimentoParcela;
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'id_app': this.movimentoParcela.idApp,
      'id': this.movimentoParcela.id,
      'id_movimento_app': this.movimentoParcela.idMovimentoApp,
      'id_movimento': this.movimentoParcela.idMovimento,
      'id_tipo_pagamento': this.movimentoParcela.idTipoPagamento,
      'valor': this.movimentoParcela.valor,
      'data_cadastro': this.movimentoParcela.dataCadastro.toString(),
      'data_atualizacao': this.movimentoParcela.dataAtualizacao.toString()
    };
  }
}
