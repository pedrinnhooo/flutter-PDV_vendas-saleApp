import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:common_files/common_files.dart';
import 'package:common_files/src/bloc/movimento_caixa_bloc.dart';
import 'package:common_files/src/model/entities/cadastro/categoria/categoria.dart';
import 'package:common_files/src/model/entities/cadastro/categoria/categoriaDao.dart';
import 'package:common_files/src/model/entities/cadastro/produto/produto.dart';
import 'package:common_files/src/model/entities/cadastro/produto/produtoDao.dart';
import 'package:common_files/src/model/entities/configuracao/tipo_pagamento/tipo_pagamento.dart';
import 'package:common_files/src/model/entities/configuracao/transacao/transacao.dart';
import 'package:common_files/src/model/entities/operacao/movimento/movimento.dart';
import 'package:common_files/src/model/entities/operacao/movimento/movimentoDao.dart';
import 'package:common_files/src/model/entities/operacao/movimento/movimento_item.dart';
import 'package:common_files/src/model/entities/operacao/movimento/movimento_parcela.dart';
import 'package:common_files/src/model/entities/operacao/movimento_caixa/movimento_caixa.dart';
import 'package:rxdart/rxdart.dart';
import 'package:rxdart/subjects.dart';

class SharedVendaBloc extends BlocBase {
  HasuraBloc _hasuraBloc;
  MovimentoCaixaBloc _movimentoCaixaBloc;
  String _filterText = "";
  int _filterCategoria = 0;
  int _sequencial = 0;

  Transacao _transacao;
  List<Transacao> _transacaoList = [];
  BehaviorSubject<Transacao> _transacaoController;
  Observable<Transacao> get transacaoOut => _transacaoController.stream;
  BehaviorSubject<List<Transacao>> _transacaoListController;
  Observable<List<Transacao>> get transacaoListOut =>
      _transacaoListController.stream;
  

  List<String> _gradeItensList = [];
  BehaviorSubject _gradeController;
  Observable get gradeListOut => _gradeController.stream;

  int _counter = 0;
  BehaviorSubject _counterController;
  Observable get currentPageOut => _counterController.stream;

  int gridListView = 1;
  BehaviorSubject _gridListViewController;
  Observable get gridListViewOut => _gridListViewController.stream;

  List<Produto> _produtoList = [];
  BehaviorSubject<List<Produto>> _produtoListController;
  Observable<List<Produto>> get produtoListOut => _produtoListController.stream;

  List<TipoPagamento> _tipoPagamentoList = [];
  BehaviorSubject<List<TipoPagamento>> _tipoPagamentoListController;
  Observable<List<TipoPagamento>> get tipoPagamentoListOut =>
      _tipoPagamentoListController.stream;

  Categoria categoria;
  CategoriaDAO categoriaDAO;
  List<Categoria> categoriaList = [];
  BehaviorSubject<List<Categoria>> _categoriaListController;
  Observable<List<Categoria>> get categoriaListOut =>
      _categoriaListController.stream;

  Movimento _movimento;
  MovimentoDAO _movimentoDAO;
  List<Movimento> _movimentoList = [];
  List<Movimento> _pedidoList = [];

  BehaviorSubject<Movimento> _movimentoController;
  Observable<Movimento> get movimentoOut => _movimentoController.stream;
  BehaviorSubject<List<Movimento>> _movimentoListController;
  Observable<List<Movimento>> get movimentoListOut =>
      _movimentoListController.stream;
  BehaviorSubject<List<Movimento>> _pedidoListController;
  Observable<List<Movimento>> get pedidoListOut => _pedidoListController.stream;

  Movimento get movimento => _movimento;
  set movimento(Movimento value) => _movimento = value;

  List<Movimento> get movimentoList => _movimentoList;
  set movimentoList(List<Movimento> value) => _movimentoList = value;

  MovimentoCaixa _movimentoCaixa;

  SharedVendaBloc(this._hasuraBloc, this._movimentoCaixaBloc) {
    _transacao = Transacao();
    categoria = Categoria();
    categoriaDAO = CategoriaDAO(_hasuraBloc, categoria: categoria);
    _movimento = Movimento();
    _movimentoDAO = MovimentoDAO(_hasuraBloc, _movimento);
    _movimentoController = BehaviorSubject.seeded(_movimento);
    _produtoListController = BehaviorSubject.seeded(_produtoList);
    _categoriaListController = BehaviorSubject.seeded(categoriaList);
    _movimentoListController = BehaviorSubject.seeded(_movimentoList);
    _pedidoListController = BehaviorSubject.seeded(_pedidoList);
    _counterController = BehaviorSubject.seeded(_counter);
    _gridListViewController = BehaviorSubject.seeded(gridListView);
    _gradeController = BehaviorSubject.seeded(_gradeItensList);
    _tipoPagamentoListController = BehaviorSubject.seeded(_tipoPagamentoList);
    _transacaoController = BehaviorSubject.seeded(_transacao);
    _transacaoListController = BehaviorSubject.seeded(_transacaoList);
  }

  setFilterText(String text) {
    _filterText = text;
  }

  setFilterCategoria(int value) {
    _filterCategoria = value;
  }

  getFilterCategoria() {
    _categoriaListController.add(categoriaList);
    return _filterCategoria;
  }

  setCurrentPage(int value) {
    _counter = value;
    _counterController.add(_counter);
  }

  setCurrentView(){
    gridListView = gridListView == 1 ? 0 : 1;
    _produtoListController.add(_produtoList);
    _gridListViewController.add(gridListView);
  }

  getAllTransacao() async {
    Transacao transacao = Transacao();
    TransacaoDAO transacaoDAO = TransacaoDAO(_hasuraBloc, transacao);
    _transacaoList = await transacaoDAO.getAll();
    _transacaoListController.add(_transacaoList);
  }

  getTransacao(int id) async {
    TransacaoDAO transacaoDAO = TransacaoDAO(_hasuraBloc, _transacao);
    _transacao = await transacaoDAO.getById(id);
    _transacaoController.add(_transacao);
  }

  setMovimentoTransacao(Transacao transacao) async {
    _movimento.idTransacao = transacao.id;
    _movimento.transacao = transacao;
    _movimentoController.add(_movimento);
  }
  
  getallProduto() async {
    Produto produto = Produto();
    ProdutoDAO produtoDAO = ProdutoDAO(_hasuraBloc, produto);
    produtoDAO.loadCategoria = true;
    produtoDAO.loadGrade = true;
    produtoDAO.loadProdutoImagem = true;
    produtoDAO.loadProdutoVariante = true;
    produtoDAO.loadPrecoTabela = true;
    produtoDAO.loadProdutoEstoque = false;
    produtoDAO.filterCategoria = _filterCategoria;
    produtoDAO.filterText = _filterText;
    produtoDAO.filterPrecoTabela = _movimento.transacao.idPrecoTabela != null ? _movimento.transacao.idPrecoTabela : 1;
    _produtoList = await produtoDAO.getAll(preLoad: true);
    if (_movimento.transacao.descontoPercentual > 0) {
      _produtoList.forEach((prod) => prod.precoTabelaItem.preco = prod.precoTabelaItem.preco - (prod.precoTabelaItem.preco * 
        (_movimento.transacao.descontoPercentual / 100)));
    }
    _produtoListController.add(_produtoList);
  }

  getallCategoria({String filter_text = ""}) async {
    categoriaDAO.filterText = filter_text;
    categoriaList = await categoriaDAO.getAll();
    _categoriaListController.add(categoriaList);
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

  getallMovimento({bool ehorcamento = false}) {
    //TODO
  }

  getProdutoGrade({int index}) {
    _gradeItensList.clear();
    if ((_produtoList[index].grade.t1 != "") &&
        (_produtoList[index].grade.t1 != null)) {
      _gradeItensList.add(_produtoList[index].grade.t1);
    }
    if ((_produtoList[index].grade.t2 != "") &&
        (_produtoList[index].grade.t2 != null)) {
      _gradeItensList.add(_produtoList[index].grade.t2);
    }
    if ((_produtoList[index].grade.t3 != "") &&
        (_produtoList[index].grade.t3 != null)) {
      _gradeItensList.add(_produtoList[index].grade.t3);
    }
    if ((_produtoList[index].grade.t4 != "") &&
        (_produtoList[index].grade.t4 != null)) {
      _gradeItensList.add(_produtoList[index].grade.t4);
    }
    if ((_produtoList[index].grade.t5 != "") &&
        (_produtoList[index].grade.t5 != null)) {
      _gradeItensList.add(_produtoList[index].grade.t5);
    }
    if ((_produtoList[index].grade.t6 != "") &&
        (_produtoList[index].grade.t6 != null)) {
      _gradeItensList.add(_produtoList[index].grade.t6);
    }
    if ((_produtoList[index].grade.t7 != "") &&
        (_produtoList[index].grade.t7 != null)) {
      _gradeItensList.add(_produtoList[index].grade.t7);
    }
    if ((_produtoList[index].grade.t8 != "") &&
        (_produtoList[index].grade.t8 != null)) {
      _gradeItensList.add(_produtoList[index].grade.t8);
    }
    if ((_produtoList[index].grade.t9 != "") &&
        (_produtoList[index].grade.t9 != null)) {
      _gradeItensList.add(_produtoList[index].grade.t9);
    }
    if ((_produtoList[index].grade.t10 != "") &&
        (_produtoList[index].grade.t10 != null)) {
      _gradeItensList.add(_produtoList[index].grade.t10);
    }
    if ((_produtoList[index].grade.t11 != "") &&
        (_produtoList[index].grade.t11 != null)) {
      _gradeItensList.add(_produtoList[index].grade.t11);
    }
    if ((_produtoList[index].grade.t12 != "") &&
        (_produtoList[index].grade.t12 != null)) {
      _gradeItensList.add(_produtoList[index].grade.t12);
    }
    if ((_produtoList[index].grade.t13 != "") &&
        (_produtoList[index].grade.t13 != null)) {
      _gradeItensList.add(_produtoList[index].grade.t13);
    }
    if ((_produtoList[index].grade.t14 != "") &&
        (_produtoList[index].grade.t14 != null)) {
      _gradeItensList.add(_produtoList[index].grade.t14);
    }
    if ((_produtoList[index].grade.t15 != "") &&
        (_produtoList[index].grade.t15 != null)) {
      _gradeItensList.add(_produtoList[index].grade.t15);
    }
    _gradeController.add(_gradeItensList);
  }

  addMovimentoItem(int idProduto, int gradePosicao, int idVariante, double precoVendido) async {
    /*if ((_movimentoCaixaBloc.movimentoCaixa.dataAbertura != null) && 
        ourDate(_movimentoCaixaBloc.movimentoCaixa.dataAbertura) == ourDate(DateTime.now())) {
      if (_movimentoCaixaBloc.movimentoCaixa.dataFechamento != null) {
        print("*** Caixa fechado ***");
        return;
        // *************************
        // Mostrar tela de caixa fechado e nao deixar mais vender ...
        // *************************
      }
    } else {
      bool temCaixaAbertoAnterior = await _movimentoCaixaBloc.temCaixaAbertoAnterior();
      if (temCaixaAbertoAnterior) {
        print("*** Caixa dia anterior aberto ***");
        return;
      }
      print("*** Abrindo caixa ***");
      _movimentoCaixaBloc.doAberturaCaixa(100.00);
      return;
      // *************************
      // Forcar abertura de caixa ...
      // *************************
    }*/
    
    var novo = movimento.movimentoItem.singleWhere(
        (movItem) => ((movItem.idProduto == idProduto) &&
            (movItem.idVariante == idVariante) && (movItem.gradePosicao == gradePosicao) &&
             movItem.precoVendido == precoVendido && 
            (movItem.quantidade > 0)),
        orElse: () => null);
    if (novo == null) {
      _sequencial++;
      MovimentoItem novo = MovimentoItem();
      ProdutoDAO produtoDao = ProdutoDAO(_hasuraBloc, novo.produto);
      produtoDao.filterPrecoTabela = _movimento.transacao.idPrecoTabela;
      novo.produto = await produtoDao.getById(idProduto);
      novo.idProduto = novo.produto.id;
      novo.idVariante = idVariante;
      novo.gradePosicao = gradePosicao;
      novo.quantidade = movimento.transacao.tipoEstoque == 0 ? 1 : -1;
      novo.precoCusto = novo.produto.precoCusto;
      novo.precoTabela = novo.produto.precoTabelaItem.preco;
      //if (movimento.transacao.descontoPercetual == 0) {
      novo.precoVendido = novo.precoTabela;
      novo.totalDesconto = 0;
      novo.totalBruto  = novo.precoTabela * novo.quantidade;
      novo.totalLiquido = novo.totalBruto;
      // } else {
      //   novo.precoVendido = novo.precoTabela - (novo.precoTabela * (movimento.transacao.descontoPercetual / 100));
      //   novo.totalDesconto = novo.precoTabela * (movimento.transacao.descontoPercetual / 100);
      //   novo.totalBruto  = novo.precoTabela * novo.quantidade;
      //   novo.totalLiquido = novo.precoVendido * novo.quantidade;
      // }
      novo.sequencial = _sequencial;
      if (movimento.transacao.tipoEstoque == 0) {
        movimento.totalItens++;
        movimento.totalQuantidade++;
      } else {
        movimento.totalItens--;
        movimento.totalQuantidade--;
      }
      movimento.valorTotalBruto += novo.totalLiquido;
      movimento.valorRestante = movimento.valorTotalBruto;
      movimento.valorTotalLiquido += novo.totalLiquido;
      movimento.movimentoItem.add(novo);
      produtoDao = null;
    } else {
      movimento.valorTotalBruto -= novo.totalLiquido;
      movimento.valorTotalLiquido -= novo.totalLiquido;
      novo.quantidade++;
      novo.totalBruto = novo.precoTabela * novo.quantidade;
      novo.totalLiquido = novo.precoVendido * novo.quantidade;
      movimento.valorTotalBruto += novo.totalLiquido;
      movimento.valorTotalLiquido += novo.totalLiquido;
      movimento.valorRestante = movimento.valorTotalBruto;
      movimento.totalQuantidade ++;
    }
    movimento.valorTotalDesconto = 0;
    movimento.movimentoParcela.clear();
    _counterController.add(_counter);
    _movimentoController.add(movimento);
    novo = null;
  }

  addMovimentoItemTroca(int idProduto, int gradePosicao, int idVariante) async {
    _sequencial--;
    MovimentoItem novo = MovimentoItem();
    ProdutoDAO produtoDao = ProdutoDAO(_hasuraBloc, novo.produto);
    novo.produto = await produtoDao.getById(idProduto);
    novo.idProduto = novo.produto.id;
    novo.idVariante = idVariante;
    novo.gradePosicao = gradePosicao;
    novo.quantidade = -1;
    novo.precoCusto = novo.produto.precoCusto;
    novo.precoTabela = novo.produto.precoTabelaItem.preco;
    novo.precoVendido = novo.produto.precoTabelaItem.preco;
    novo.totalLiquido = novo.precoVendido * novo.quantidade;
    novo.sequencial = _sequencial;
    movimento.totalItens--;
    movimento.totalQuantidade--;
    movimento.valorTotalBruto += novo.totalLiquido;
    movimento.valorRestante = movimento.valorTotalBruto;
    movimento.valorTotalLiquido += novo.totalLiquido;
    movimento.movimentoItem.add(novo);
    produtoDao = null;
    movimento.valorTotalDesconto = 0;
    movimento.movimentoParcela.clear();
    _counterController.add(_counter);
    _movimentoController.add(movimento);
    novo = null;
  }

  removeMovimentoItem(int index) async {
    _movimento.movimentoItem[index].ehdeletado = 1;
    _movimento.valorTotalBruto -= _movimento.movimentoItem[index].totalLiquido;
    _movimento.valorTotalLiquido -= _movimento.movimentoItem[index].totalLiquido;
    _movimento.totalItens --;
    _movimento.totalQuantidade -= _movimento.movimentoItem[index].quantidade;
    _movimento.valorRestante = _movimento.valorTotalBruto;
    _movimento.movimentoParcela.clear();
    _counterController.add(_counter);
    _movimentoController.add(_movimento);
    var item = movimento.movimentoItem.firstWhere(
      (movItem) => (movItem.ehdeletado == 0),              
      orElse: () => null);
    if (item == null) {
      resetBloc();
      // PageController pageController = VendaModule.to.bloc<VendaBloc>().pageController;
      // pageController.jumpToPage(0);      
    }
  }

  cancelMovimento(int index) async {
    _pedidoList[index].ehcancelado = 1;
    _pedidoList.removeAt(index);
    _pedidoListController.add(_pedidoList);
  }

  setQuantidadeMovimentoItem(int index, double quantidade){
    _movimento.valorTotalBruto -= _movimento.movimentoItem[index].precoVendido * _movimento.movimentoItem[index].quantidade;
    _movimento.valorTotalLiquido -= _movimento.movimentoItem[index].totalLiquido;
    _movimento.totalQuantidade -= _movimento.movimentoItem[index].quantidade;
    _movimento.movimentoItem[index].quantidade = quantidade;
    _movimento.movimentoItem[index].totalLiquido = _movimento.movimentoItem[index].precoVendido * quantidade;
    _movimento.totalQuantidade += _movimento.movimentoItem[index].quantidade;
    _movimento.valorTotalLiquido += _movimento.movimentoItem[index].totalLiquido;
    _movimento.valorTotalBruto += _movimento.movimentoItem[index].precoVendido * _movimento.movimentoItem[index].quantidade;
    _movimento.valorRestante = _movimento.valorTotalBruto;
    movimento.movimentoParcela.clear();
    _movimentoController.add(_movimento);
  }

  setValorMovimentoItem(int index, double value){
    _movimento.valorTotalBruto -= _movimento.movimentoItem[index].precoVendido * _movimento.movimentoItem[index].quantidade;
    _movimento.valorTotalLiquido -= _movimento.movimentoItem[index].totalLiquido;
    _movimento.movimentoItem[index].precoVendido = value;
    _movimento.movimentoItem[index].totalLiquido = _movimento.movimentoItem[index].precoVendido * _movimento.movimentoItem[index].quantidade;
    _movimento.valorTotalLiquido += _movimento.movimentoItem[index].totalLiquido;
    _movimento.valorTotalBruto += _movimento.movimentoItem[index].precoVendido * _movimento.movimentoItem[index].quantidade;
    _movimento.valorRestante = _movimento.valorTotalBruto;
    movimento.movimentoParcela.clear();
    _movimentoController.add(_movimento);
  }

  addMovimentoParcela(TipoPagamento tipoPagamento, double valor) {
    MovimentoParcela movimentoParcela = MovimentoParcela();
    movimentoParcela.idTipoPagamento = tipoPagamento.id;
    movimentoParcela.valor = valor;
    movimentoParcela.tipoPagamento = tipoPagamento;
    _movimento.movimentoParcela.add(movimentoParcela);
    _movimentoController.add(movimento);
    _movimento.valorTroco =
        valor > _movimento.valorRestante ? valor - _movimento.valorRestante : 0;
    _movimento.valorRestante =
        valor > _movimento.valorRestante ? 0 : _movimento.valorRestante - valor;
    movimentoParcela = null;
  }

  removeMovimentoParcela(int index) {
    _movimento.valorRestante = (_movimento.valorRestante + (_movimento.movimentoParcela[index].valor - _movimento.valorTroco));
    _movimento.valorTroco = (_movimento.valorRestante > 0) ? 0 : _movimento.valorTroco;
    _movimento.movimentoParcela.removeAt(index);
    _movimentoController.add(_movimento);
  }

  addDescontoMovimento({int percent, double value}) {
    if (value > 0) {
      _movimento.valorTotalDesconto = (value);
      _movimento.valorTotalLiquido = _movimento.valorTotalLiquido - _movimento.valorTotalDesconto;
      _movimento.valorRestante = _movimento.valorTotalLiquido;
    } else if (percent > 0) {
      _movimento.valorTotalDesconto = ((percent / 100) * _movimento.valorTotalBruto);
      _movimento.valorTotalLiquido = _movimento.valorTotalLiquido - _movimento.valorTotalDesconto;
      _movimento.valorRestante = _movimento.valorTotalLiquido;
    }
    // if (value > 0) {
    //   _movimento.valorTotalDesconto = (value);
    //   _movimento.valorRestante = _movimento.valorTotalLiquido - _movimento.valorTotalDesconto;
    // } else if (percent > 0) {
    //   _movimento.valorTotalDesconto = ((percent / 100) * _movimento.valorTotalBruto);
    //   _movimento.valorRestante = (_movimento.valorTotalLiquido - _movimento.valorTotalDesconto);
    // }
    _movimentoController.add(_movimento);
  }

  removeDescontoMovimento(){
    movimento.valorTotalDesconto = 0;
    movimento.valorRestante = movimento.valorTotalLiquido;
    movimento.valorTroco = 0;
    movimento.movimentoParcela.clear();
    _movimentoController.add(movimento);
  }

  addDescontoMovimentoItem({int index, int percent, double value}) {
    //_movimento.valorTotalBruto -= _movimento.movimentoItem[index].totalBruto;
    _movimento.valorTotalLiquido -= _movimento.movimentoItem[index].totalLiquido;
    _movimento.movimentoItem[index].totalDesconto = (value > 0) ?
      value :
      ((percent / 100) * _movimento.movimentoItem[index].precoVendido) * _movimento.movimentoItem[index].quantidade;
    _movimento.movimentoItem[index].precoVendido -= (_movimento.movimentoItem[index].totalDesconto / _movimento.movimentoItem[index].quantidade);
    _movimento.movimentoItem[index].totalLiquido = _movimento.movimentoItem[index].precoVendido * _movimento.movimentoItem[index].quantidade;
    _movimento.valorTotalDescontoItem += _movimento.movimentoItem[index].totalDesconto;
    //_movimento.valorTotalBruto += _movimento.movimentoItem[index].totalBruto;
    _movimento.valorTotalLiquido += _movimento.movimentoItem[index].totalLiquido;
    _movimento.valorRestante = _movimento.valorTotalLiquido;
    _movimentoListController.add(_movimentoList);
    _movimentoController.add(_movimento);
  }

  Future saveVenda(int ehorcamento) async {
    _movimentoDAO = null;
    _movimento.ehorcamento = ehorcamento;
    _movimento.ehsincronizado = 0;
    _movimentoDAO = MovimentoDAO(_hasuraBloc, _movimento);
    await _movimentoDAO.insert();
    await getAllPedido();
    await resetBloc();
    doSync();
  }

  getPedido(int index) {
    _movimento = _pedidoList[index];
    _movimento.valorRestante = _pedidoList[index].valorTotalLiquido;
    _counterController.add(_counter);
    _pedidoListController.add(_pedidoList);
    _movimentoController.add(_movimento);
  }

  getAllPedido() async {
    _movimentoDAO.filterEhOrcamento = true;
    _movimentoDAO.loadMovimentoItem = true;
    _movimentoDAO.filterEhCancelado = FilterEhCancelado.naoCancelados;
    _movimentoDAO.loadProduto = true;
    _pedidoList = await _movimentoDAO.getAll(preLoad: true);
    _pedidoListController.add(_pedidoList);
  }

  cancelPedido(int index) async {
    _pedidoList[index].ehcancelado = 1;
    MovimentoDAO movimentoDAO = MovimentoDAO(_hasuraBloc, _pedidoList[index]);
    await movimentoDAO.insert();
    await getAllPedido();
  }

  doSync(){
 
  }

  resetBloc() async {
    _movimento = null;
    _movimentoDAO = null;
    _movimento = Movimento();
    _movimentoDAO = MovimentoDAO(_hasuraBloc, _movimento);
    _filterText = "";
    _filterCategoria = 0;
    await getallProduto();
    await getAllPedido();
    _movimentoController.add(_movimento);
  }

  zuma() async {
    await _movimentoDAO.delete(0);
    await _movimentoCaixaBloc.deleteAll();
  }

  @override
  void dispose() {
    _produtoListController.close();
    _categoriaListController.close();
    _movimentoController.close();
    _movimentoListController.close();
    _pedidoListController.close();
    _counterController.close();
    _gradeController.close();
    _tipoPagamentoListController.close();
    _gridListViewController.close();
    super.dispose();
  }
}
