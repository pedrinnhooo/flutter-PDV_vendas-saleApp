import 'package:common_files/src/bloc/hasura_bloc.dart';
import 'package:common_files/src/model/dao/dao.dart';
import 'package:common_files/src/model/entities/configuracao/transacao/transacao.dart';
import 'package:common_files/src/model/entities/configuracao/transacao/transacaoDao.dart';
import 'package:common_files/src/model/entities/interfaces.dart';
import 'package:common_files/src/model/entities/operacao/movimento/movimento.dart';
import 'package:common_files/src/model/entities/operacao/movimento/movimento_item.dart';
import 'package:common_files/src/model/entities/operacao/movimento/movimento_itemDao.dart';
import 'package:common_files/src/model/entities/operacao/movimento/movimento_parcela.dart';
import 'package:common_files/src/model/entities/operacao/movimento/movimento_parcelaDao.dart';
import 'package:common_files/src/model/entities/operacao/movimento_cliente/movimento_cliente.dart';
import 'package:common_files/src/model/entities/operacao/movimento_cliente/movimento_clienteDao.dart';
import 'package:common_files/src/utils/constants.dart';
import 'package:common_files/src/utils/functions.dart';

class MovimentoDAO implements IEntityDAO {
  HasuraBloc _hasuraBloc;
  final String tableName = "movimento";
  String filterText;
  bool filterEhOrcamento = false;
  FilterEhCancelado filterEhCancelado = FilterEhCancelado.todos;
  bool filterData = false;
  DateTime filterDataInicial = DateTime.now();
  DateTime filterDataFinal = DateTime.now();
  FilterEhSincronizado filterEhSincronizado = FilterEhSincronizado.todos;
  bool loadMovimentoItem = false;
  bool loadMovimentoParcela = false;
  bool loadProduto = false;
  bool loadTipoPagamento = false;
  bool loadTransacao = false;
  int filterPrecoTabela = 1;

    
  Movimento movimento;
  MovimentoItem movimentoItem;
  MovimentoParcela movimentoParcela;
  List<Movimento> movimentoList;

  @override
  Dao dao;

  MovimentoDAO(this._hasuraBloc, this.movimento) {
    dao = Dao();
    if (movimento == null) {
      movimento = Movimento();
    }
  }

  @override
  IEntity fromMap(Map<String, dynamic> map) {}

  @override
  Future<List> getAll({bool preLoad=false}) async {
    String where = "1 = 1 ";
    //where = filterEhCancelado ? where + "and ehcancelado = 1 " : where + "and ehcancelado = 0 "; 
    where = filterEhOrcamento ? where + "and ehorcamento = 1 " : where; 
    if (filterEhCancelado != FilterEhCancelado.todos) {
      where = filterEhCancelado == FilterEhCancelado.cancelados ? where + "and ehcancelado = 1 " : 
        where + "and ((ehcancelado = 0) or (ehcancelado ISNULL)) "; 
    }   
    if (filterEhSincronizado != FilterEhSincronizado.todos) {
      where = filterEhSincronizado == FilterEhSincronizado.sincronizados ? where + "and ehsincronizado = 1 " : 
        where + "and ((ehsincronizado = 0) or (ehsincronizado ISNULL)) "; 
    }
    where = filterData ? 
      where + """and date(data_movimento) between '${ourDate(filterDataInicial)}' and '${ourDate(filterDataFinal)}' """ : 
      where;
    

    List<dynamic> args = [];

    List list = await dao.getList(this, where, args);
    movimentoList = List.generate(list.length, (i) {
      return Movimento(
               idApp: list[i]['id_app'],
               id: list[i]['id'],
               idPessoa: list[i]['id_pessoa'],
               idCliente: list[i]['id_cliente'],
               idVendedor: list[i]['id_vendedor'],
               idTransacao: list[i]['id_transacao'],
               idTerminal: list[i]['id_terminal'],
               ehorcamento: list[i]['ehorcamento'],
               ehcancelado: list[i]['ehcancelado'],
               ehsincronizado: list[i]['ehsincronizado'],
               ehfinalizado: list[i]['ehfinalizado'],
               valorTotalBruto: list[i]['valor_total_bruto'],
               valorTotalDesconto: list[i]['valor_total_desconto'],
               valorTotalLiquido: list[i]['valor_total_liquido'],
               valorTotalDescontoItem: list[i]['valor_total_desconto_item'],
               totalItens: list[i]['total_itens'],
               totalQuantidade: list[i]['total_quantidade'],
               dataMovimento: DateTime.parse(list[i]['data_movimento']),
               dataFechamento: DateTime.parse(list[i]['data_fechamento']),
               dataAtualizacao: DateTime.parse(list[i]['data_atualizacao']),
      );
    });

    if (preLoad) {
      for (Movimento movimento in movimentoList){
        movimentoItem = MovimentoItem();
        MovimentoItemDAO movimentoItemDAO = MovimentoItemDAO(_hasuraBloc, movimentoItem);
        if (loadMovimentoItem) {
          movimentoItemDAO.filterMovimento = movimento.idApp;
          movimentoItemDAO.loadProduto = this.loadProduto;         
          List<MovimentoItem> movimentoItemList = await movimentoItemDAO.getAll(preLoad: true);
          movimento.movimentoItem = movimentoItemList;
        }
        movimentoItemDAO = null;

        movimentoParcela = MovimentoParcela();
        MovimentoParcelaDAO movimentoParcelaDAO = MovimentoParcelaDAO(movimentoParcela);
        if (loadMovimentoParcela) {
          movimentoParcelaDAO.filterMovimento = movimento.idApp;
          movimentoParcelaDAO.loadTipoPagamento = this.loadTipoPagamento;         
          List<MovimentoParcela> movimentoParcelaList = await movimentoParcelaDAO.getAll(preLoad: true);
          movimento.movimentoParcela = movimentoParcelaList;
        }
        movimentoParcelaDAO = null;

        if (loadTransacao) {
          Transacao transacao = Transacao();
          TransacaoDAO transacaoDAO = TransacaoDAO(_hasuraBloc, transacao);
          movimento.transacao = await transacaoDAO.getById(movimento.idTransacao);
        }
      }
    }  
    return movimentoList;  
  }

  @override
  Future<IEntity> getById(int id) async {
    movimento = await dao.getById(this, id);
    return movimento;
  }

  @override
  Future<IEntity> insert() async {
    this.movimento.idApp = await dao.insert(this);
      for (MovimentoItem movimentoItem in movimento.movimentoItem){
        movimentoItem.idMovimentoApp = this.movimento.idApp;
        MovimentoItemDAO movimentoItemDAO = MovimentoItemDAO(_hasuraBloc, movimentoItem);
        await movimentoItemDAO.insert();
        movimentoItemDAO = null;
      }
      for (MovimentoParcela movimentoParcela in movimento.movimentoParcela){
        movimentoParcela.idMovimentoApp = this.movimento.idApp;
        MovimentoParcelaDAO movimentoParcelaDAO = MovimentoParcelaDAO(movimentoParcela);
        await movimentoParcelaDAO.insert();
        if (movimentoParcela.tipoPagamento.ehFiado == 1) {
          MovimentoCliente movimentoCliente = MovimentoCliente();
          MovimentoClienteDAO movimentoClienteDAO = MovimentoClienteDAO(movimentoCliente);
          movimentoCliente.idAppMovimento = this.movimento.idApp;
          movimentoCliente.idPessoa = this.movimento.idPessoa;
          movimentoCliente.idCliente = 1;//this.movimento.idCliente;
          movimentoCliente.idTipoPagamento = movimentoParcela.idTipoPagamento;
          movimentoCliente.data = DateTime.now();
          movimentoCliente.valor = movimentoParcela.valor * -1;
          movimentoCliente.descricao = "Venda";
          double novoSaldo = await movimentoClienteDAO.getSaldoAtual(movimentoCliente.idCliente);
          novoSaldo += movimentoCliente.valor;
          movimentoCliente.saldo = novoSaldo;
          movimentoCliente = await movimentoClienteDAO.insert();
          movimentoClienteDAO = null;
        }
        movimentoParcelaDAO = null;
      }
    return this.movimento;
  }

  @override
  Future<IEntity> delete(int id) async {
    await dao.delete(this, id);
    MovimentoItemDAO movimentoItemDAO = MovimentoItemDAO(_hasuraBloc, movimentoItem);
    await dao.delete(movimentoItemDAO, id);
    MovimentoParcelaDAO movimentoParcelaDAO = MovimentoParcelaDAO(movimentoParcela);
    await dao.delete(movimentoParcelaDAO, id);
    return this.movimento;
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'id_app': this.movimento.idApp,
      'id': this.movimento.id,
      'id_pessoa': this.movimento.idPessoa,
      'id_cliente': this.movimento.idCliente,
      'id_vendedor': this.movimento.idVendedor,
      'id_transacao': this.movimento.idTransacao,
      'id_terminal': this.movimento.idTerminal,
      'ehorcamento': this.movimento.ehorcamento,
      'ehcancelado': this.movimento.ehcancelado,
      'ehsincronizado': this.movimento.ehsincronizado,
      'ehfinalizado': this.movimento.ehfinalizado,
      'valor_total_bruto': this.movimento.valorTotalBruto,
      'valor_total_desconto': this.movimento.valorTotalDesconto,
      'valor_total_liquido': this.movimento.valorTotalLiquido,
      'valor_total_desconto_item': this.movimento.valorTotalDescontoItem,
      'total_itens': this.movimento.totalItens,
      'total_quantidade': this.movimento.totalQuantidade,
      'data_movimento': this.movimento.dataMovimento.toString(),
      'data_fechamento': this.movimento.dataFechamento.toString(),
      'data_atualizacao': this.movimento.dataAtualizacao.toString()
    };
  }

  Future<List<Map<dynamic, dynamic>>> getRawQuery(String query) async {
    List<Map<dynamic, dynamic>> result = [];
    result = await dao.getRawQuery(query);
    return result;  
  }

}
