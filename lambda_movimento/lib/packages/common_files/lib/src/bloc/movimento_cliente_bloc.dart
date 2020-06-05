import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:common_files/src/model/entities/configuracao/tipo_pagamento/tipo_pagamento.dart';
import 'package:common_files/src/model/entities/configuracao/tipo_pagamento/tipo_pagamentoDao.dart';
import 'package:common_files/src/model/entities/operacao/movimento_cliente/movimento_cliente.dart';
import 'package:common_files/src/model/entities/operacao/movimento_cliente/movimento_clienteDao.dart';
import 'package:common_files/src/utils/functions.dart';
import 'package:rxdart/rxdart.dart';

class MovimentoClienteBloc extends BlocBase {

  int _filtroSelecionado = 0;
  List _filtroMovimento = ["Todos", "Mês passado", "Esse mês", "Última semana"];
  BehaviorSubject<List> _filtroMovimentoController;
  Observable<List> get filtroMovimentoListOut => _filtroMovimentoController.stream;
  
  String _observacao = "";
  BehaviorSubject<String> _observacaoController;
  Observable<String> get transacaoOut => _observacaoController.stream;

  List<TipoPagamento> _tipoPagamentoList = [];
  BehaviorSubject<List<TipoPagamento>> _tipoPagamentoListController;
  Observable<List<TipoPagamento>> get tipoPagamentoListOut => _tipoPagamentoListController.stream;

  MovimentoCliente movimentoCliente;
  MovimentoClienteDAO _movimentoClienteDAO;
  List<MovimentoCliente> _movimentoClienteList = [];
  BehaviorSubject<MovimentoCliente> _movimentoClienteController;
  Observable<MovimentoCliente> get movimentoClienteOut => _movimentoClienteController.stream;
  BehaviorSubject<List<MovimentoCliente>> _movimentoClienteListController;
  Observable<List<MovimentoCliente>> get movimentoClienteListOut => _movimentoClienteListController.stream;

  MovimentoClienteBloc(){
    movimentoCliente = MovimentoCliente();
    _movimentoClienteDAO = MovimentoClienteDAO(movimentoCliente);
    _filtroMovimentoController = BehaviorSubject.seeded(_filtroMovimento);
    _observacaoController = BehaviorSubject.seeded(_observacao);
    _movimentoClienteController = BehaviorSubject.seeded(movimentoCliente);
    _movimentoClienteListController = BehaviorSubject.seeded(_movimentoClienteList);
    _tipoPagamentoListController = BehaviorSubject.seeded(_tipoPagamentoList);
  }

  getMovimentoCliente({bool filterBasico, DateTime dataInicial}) async {
    MovimentoCliente movimentoCliente = MovimentoCliente();
    MovimentoClienteDAO movimentoClienteDAO = MovimentoClienteDAO(movimentoCliente);
    List<MovimentoCliente> movimentoClienteList = [];
    movimentoClienteDAO.filterIdCliente = 1;
    movimentoClienteDAO.filterDataInicial = dataInicial;
    movimentoClienteDAO.filterBasico = filterBasico;
    movimentoClienteList = await movimentoClienteDAO.getAll();
    if (movimentoClienteList.length > 0) {
      print("Saldo anterior: " + (movimentoClienteList[0].saldo  - movimentoClienteList[0].valor).toString());
      for (var i = 0; i < movimentoClienteList.length; i++) {
        print(ourDate(movimentoClienteList[i].data) + "---> " + movimentoClienteList[i].descricao + " = " + movimentoClienteList[i].valor.toString() + 
          "  -  Saldo: " + movimentoClienteList[i].saldo.toString());
        if (i == movimentoClienteList.length - 1) {
          print("Saldo atual: " + movimentoClienteList[i].saldo.toString());
        }
      }
    }
    _movimentoClienteList = movimentoClienteList;
    _movimentoClienteListController.add(_movimentoClienteList);
    _filtroMovimentoController.add(_filtroMovimento);
    movimentoCliente = null;
    movimentoClienteList = null;
  }

  addMovimentoCliente(int idTipoPagamento, double valor, bool ehCancelamento) async {
    MovimentoCliente movimentoCliente = MovimentoCliente();
    MovimentoClienteDAO movimentoClienteDAO = MovimentoClienteDAO(movimentoCliente);
    movimentoCliente.idPessoa = 1;
    movimentoCliente.idCliente = 1;
    movimentoCliente.idTipoPagamento = 1;//_tipoPagamentoList[indexTipoPagamento].id;
    movimentoCliente.data = DateTime.now();
    movimentoCliente.valor = ehCancelamento ? valor * -1 : valor;
    movimentoCliente.descricao = ehCancelamento ? "Pagamento cancelado" : "Pagamento";
    movimentoCliente.observacao = _observacao;
    movimentoCliente.saldo = movimentoCliente.valor + _movimentoClienteList[_movimentoClienteList.length - 1].saldo;
    movimentoCliente = await movimentoClienteDAO.insert();
    _movimentoClienteList.add(movimentoCliente);
    _movimentoClienteListController.add(_movimentoClienteList);
    movimentoCliente = null;
    movimentoClienteDAO = null;
  }

  getallTipoPagamentos() async {
    TipoPagamento tipoPagamento = TipoPagamento();
    TipoPagamentoDAO tipoPagamentoDAO =
        TipoPagamentoDAO(tipoPagamento: tipoPagamento);
    tipoPagamentoDAO.filterText = "";
    tipoPagamentoDAO.filterId = 0;
    _tipoPagamentoList = await tipoPagamentoDAO.getAll();
    _tipoPagamentoListController.add(_tipoPagamentoList);
  }

  setFiltroSelecionado(int value) => _filtroSelecionado = value;
  getFiltroSelecionado(){
    return _filtroSelecionado;
  }

  @override
  void dispose() {
    _filtroMovimentoController.close();
    _observacaoController.close();
    _tipoPagamentoListController.close();
    _movimentoClienteController.close();
    _movimentoClienteListController.close();
    _tipoPagamentoListController.close();
    super.dispose();
  }  

}