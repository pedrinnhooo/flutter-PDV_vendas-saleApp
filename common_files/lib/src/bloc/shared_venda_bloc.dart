import 'dart:math';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:common_files/common_files.dart';
import 'package:common_files/src/model/entities/cadastro/Integracao/picpay/picpay.dart';
import 'package:esc_pos_printer/esc_pos_printer.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:rxdart/rxdart.dart';
import 'package:rxdart/subjects.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'package:uuid/uuid_util.dart';

class SharedVendaBloc extends BlocBase {
  AppGlobalBloc appGlobalBloc;
  HasuraBloc _hasuraBloc;
  MovimentoCaixaBloc _movimentoCaixaBloc;
  bool ehServico;
  String filterText = "";
  String picpayQrCode = "";
  int filterCategoria = 0;
  int _sequencial = 0;
  int offset = 0;
  bool filterOnServer;
  String nomeVendedor = "";
  String nomeCliente = "";
  StatusCaixa statusCaixa;
  int filterCategoriaServico;

  BehaviorSubject<String> _filterTextController;
  Stream<String> get filterTextOut => _filterTextController.stream;
  
  Transacao _transacao;
  List<Transacao> transacaoList = [];
  BehaviorSubject<Transacao> _transacaoController;
  Stream<Transacao> get transacaoOut => _transacaoController.stream;
  BehaviorSubject<List<Transacao>> _transacaoListController;
  Stream<List<Transacao>> get transacaoListOut =>
      _transacaoListController.stream;
  

  List<String> _gradeItensList = [];
  BehaviorSubject _gradeController;
  Stream get gradeListOut => _gradeController.stream;

  int _counter = 0;
  BehaviorSubject _counterController;
  Stream get currentPageOut => _counterController.stream;

  TipoApresentacaoProduto tipoApresentacaoProduto = TipoApresentacaoProduto.grid;
  BehaviorSubject<TipoApresentacaoProduto> _gridListViewController;
  Stream<TipoApresentacaoProduto> get gridListViewOut => _gridListViewController.stream;

  Produto produto;
  List<Produto> _produtoList = [];
  BehaviorSubject<List<Produto>> _produtoListController;
  Stream<List<Produto>> get produtoListOut => _produtoListController.stream;

  Tutorial tutorial;
  TutorialDAO tutorialDAO;
  List<Tutorial> tutorialList = [];

  FilterTemServico filterTemServico = FilterTemServico.naoServico;
  BehaviorSubject<FilterTemServico> _servicoListViewController;
  Stream<FilterTemServico> get servicoListViewOut => _servicoListViewController.stream;

  List<TipoPagamento> tipoPagamentoList = [];
  BehaviorSubject<List<TipoPagamento>> _tipoPagamentoListController;
  Stream<List<TipoPagamento>> get tipoPagamentoListOut =>
      _tipoPagamentoListController.stream;

  Categoria categoria;
  CategoriaDAO categoriaDAO;
  List<Categoria> categoriaList = [];
  BehaviorSubject<List<Categoria>> _categoriaListController;
  Stream<List<Categoria>> get categoriaListOut =>
      _categoriaListController.stream;

  ConfiguracaoGeral configuracaoGeral;
  ConfiguracaoGeralDAO configuracaoGeralDAO;
  List<ConfiguracaoGeral> configuracaoGeralList = [];
  BehaviorSubject<List<ConfiguracaoGeral>> _configuracaoGeralListController;
  Stream<List<ConfiguracaoGeral>> get configuracaoGeralListOut =>
      _configuracaoGeralListController.stream;


  Movimento _movimento;
  MovimentoDAO _movimentoDAO;
  List<Movimento> _movimentoList = [];
  List<Movimento> _pedidoList = [];

  BehaviorSubject<Movimento> _movimentoController;
  Stream<Movimento> get movimentoOut => _movimentoController.stream;
  BehaviorSubject<List<Movimento>> _movimentoListController;
  Stream<List<Movimento>> get movimentoListOut =>
      _movimentoListController.stream;
  BehaviorSubject<List<Movimento>> _pedidoListController;
  Stream<List<Movimento>> get pedidoListOut => _pedidoListController.stream;

  Movimento get movimento => _movimento;
  set movimento(Movimento value) => _movimento = value;

  List<Movimento> get movimentoList => _movimentoList;
  set movimentoList(List<Movimento> value) => _movimentoList = value;

  MovimentoCaixa _movimentoCaixa;

  StatusSincronizacao statusSincronizacaoHasura;
  BehaviorSubject<StatusSincronizacao> _statusSincronizacaoHasuraController;
  Stream<StatusSincronizacao> get statusSincronizacaoHasuraOut => _statusSincronizacaoHasuraController.stream;

  SharedVendaBloc(this.appGlobalBloc, this._hasuraBloc, this._movimentoCaixaBloc) {
    _transacao = Transacao();
    categoria = Categoria();
    categoriaDAO = CategoriaDAO(_hasuraBloc, appGlobalBloc, categoria: categoria);
    _movimento = Movimento();
    _movimentoDAO = MovimentoDAO(_hasuraBloc, appGlobalBloc, _movimento);
    _movimentoController = BehaviorSubject.seeded(_movimento);
    _produtoListController = BehaviorSubject.seeded(_produtoList);
    _categoriaListController = BehaviorSubject.seeded(categoriaList);
    _movimentoListController = BehaviorSubject.seeded(_movimentoList);
    _pedidoListController = BehaviorSubject.seeded(_pedidoList);
    _counterController = BehaviorSubject.seeded(_counter);
    _gridListViewController = BehaviorSubject.seeded(tipoApresentacaoProduto);
    _servicoListViewController = BehaviorSubject.seeded(filterTemServico);
    _gradeController = BehaviorSubject.seeded(_gradeItensList);
    _tipoPagamentoListController = BehaviorSubject.seeded(tipoPagamentoList);
    _transacaoController = BehaviorSubject.seeded(_transacao);
    _transacaoListController = BehaviorSubject.seeded(transacaoList);
    _statusSincronizacaoHasuraController = BehaviorSubject.seeded(statusSincronizacaoHasura);
    _configuracaoGeralListController = BehaviorSubject.seeded(configuracaoGeralList);
    _filterTextController = BehaviorSubject.seeded(filterText);
    filterOnServer = true;
    //_movimentoCaixaBloc.getMovimentoCaixa(DateTime.now());
    //initMovimento();
  }

  initBloc() async {
    await getEhServicoVendaDefault();
    await getAllTransacao();
    await initMovimento();
    await getAllPedido();
    await getallCategoria();
    await getallProduto();
    await getCurrentView();
    await verificaCaixaAberto();
  }

  setFilterText(String text) {
    filterText = text;
    _filterTextController.add(filterText);
  }

  setFilterCategoria(int value) {
    filterCategoria = value;
  }

  getFilterCategoria() {
    _categoriaListController.add(categoriaList);
    return filterCategoria;
  }

  setCurrentPage(int value) {
    _counter = value;
    _counterController.add(_counter);
  }
   
  setServicoView() async {
    // filterTemServico = filterTemServico == FilterTemServico.naoServico ? FilterTemServico.ehServico : FilterTemServico.naoServico;
    // await getallProduto();
    // await getallCategoria();
    // _servicoListViewController.add(filterTemServico);
  }

  getEhServicoVendaDefault() async {
    try {
      ConfiguracaoGeral configuracaoGeral = ConfiguracaoGeral();
      ConfiguracaoGeralDAO configuracaoGeralDAO = ConfiguracaoGeralDAO(_hasuraBloc, configuracaoGeral, appGlobalBloc);
      configuracaoGeralList = await configuracaoGeralDAO.getAll();
      _configuracaoGeralListController.add(configuracaoGeralList);
      if (configuracaoGeralList.length > 0) {
        filterTemServico = configuracaoGeralList.first.ehServicoDefault == 1 ? FilterTemServico.ehServico : FilterTemServico.naoServico;
        _servicoListViewController.add(filterTemServico);
      }
    } catch(error, stacktrace) {
      appGlobalBloc.logger.e(error.toString(), '<shared_venda_bloc> getEhServicoVendaDefault');
      await log(_hasuraBloc, appGlobalBloc,
        nomeArquivo: "shared_venda_bloc",
        nomeFuncao: "getEhServicoVendaDefault",
        error: error.toString(),
        stacktrace: stacktrace.toString()
      );
    }   
  }

  setDatePedido(int index, DateTime selectedDate) async{
    _movimento.movimentoItem[index].prazoEntrega = selectedDate;
    _movimentoController.add(_movimento);
  }

  setObservacaoMovimento(String observacao){
    _movimento.observacao = observacao;
    _movimentoController.add(_movimento);
  }

  setObservacaoPedido(int index, String observacao) async{
    _movimento.movimentoItem[index].observacao = observacao;
    _movimentoController.add(_movimento);
  }

  setObservacaoInternaPedido(int index, String observacaoInterna) async{
    _movimento.movimentoItem[index].observacaoInterna = observacaoInterna;
    _movimentoController.add(_movimento);
  }

  setGarantiaPedido(int index, String garantia) async{
    _movimento.movimentoItem[index].garantia = garantia;
    _movimentoController.add(_movimento);
  }

  setCurrentView() async {
    try {
      tipoApresentacaoProduto = tipoApresentacaoProduto == TipoApresentacaoProduto.grid ? TipoApresentacaoProduto.list : TipoApresentacaoProduto.grid;
      SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
      await sharedPreferences.setInt("grid", tipoApresentacaoProduto.index);
      _produtoListController.add(_produtoList);
      _gridListViewController.add(tipoApresentacaoProduto);
    } catch(error, stacktrace) {
      appGlobalBloc.logger.e(error.toString(), '<shared_venda_bloc> setCurrentView');
      await log(_hasuraBloc, appGlobalBloc,
        nomeArquivo: "shared_venda_bloc",
        nomeFuncao: "setCurrentView",
        error: error.toString(),
        stacktrace: stacktrace.toString()
      );
    }   
  }

   getCurrentView() async{
    try {
      SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
      tipoApresentacaoProduto = await sharedPreferences.getInt("grid") == 1 ? TipoApresentacaoProduto.list : TipoApresentacaoProduto.grid;
      _produtoListController.add(_produtoList);
      _gridListViewController.add(tipoApresentacaoProduto);    
    } catch(error, stacktrace) {
      appGlobalBloc.logger.e(error.toString(), '<shared_venda_bloc> getCurrentView');
      await log(_hasuraBloc, appGlobalBloc,
        nomeArquivo: "shared_venda_bloc",
        nomeFuncao: "getCurrentView",
        error: error.toString(),
        stacktrace: stacktrace.toString()
      );
    }   
  }

  getAllTransacao() async {
    try {
      Transacao transacao = Transacao();
      TransacaoDAO transacaoDAO = TransacaoDAO(_hasuraBloc, transacao, appGlobalBloc);
      transacaoList = await transacaoDAO.getAll();
      _transacaoListController.add(transacaoList);
    } catch(error, stacktrace) {
      appGlobalBloc.logger.e(error.toString(), '<shared_venda_bloc> getAllTransacao');
      await log(_hasuraBloc, appGlobalBloc,
        nomeArquivo: "shared_venda_bloc",
        nomeFuncao: "getAllTransacao",
        error: error.toString(),
        stacktrace: stacktrace.toString()
      );
    }   
  }

  getTransacao(int id) async {
    try {
      TransacaoDAO transacaoDAO = TransacaoDAO(_hasuraBloc, _transacao, appGlobalBloc);
      _transacao = await transacaoDAO.getById(id);
      _transacaoController.add(_transacao);
    } catch(error, stacktrace) {
      appGlobalBloc.logger.e(error.toString(), '<shared_venda_bloc> getTransacao');
      await log(_hasuraBloc, appGlobalBloc,
        nomeArquivo: "shared_venda_bloc",
        nomeFuncao: "getTransacao",
        error: error.toString(),
        stacktrace: stacktrace.toString()
      );
    }   
  }

  initMovimento() async {
    try{
      _movimento = Movimento();
      _movimentoDAO = MovimentoDAO(_hasuraBloc, appGlobalBloc, _movimento);
      _movimento.idPessoa = appGlobalBloc.loja.id;
      _movimento.idTerminal = appGlobalBloc.terminal.id;
      print(":::::::::::::::: IDTRANSACAO ${appGlobalBloc.terminal.idTransacao.toString()} ::::::::::::::");
      _movimento.idTransacao = appGlobalBloc.terminal.idTransacao;
      await getTransacao(_movimento.idTransacao);
      _movimento.transacao = _transacao; 
      _movimento.idTransacao = _transacao.id;
      //await setMovimentoTransacao(transacaoList.first);
      _movimentoController.add(_movimento);
    } catch(error, stacktrace) {
      appGlobalBloc.logger.e(error.toString(), '<shared_venda_bloc> initMovimento');
      await log(_hasuraBloc, appGlobalBloc,
        nomeArquivo: "shared_venda_bloc",
        nomeFuncao: "initMovimento",
        error: error.toString(),
        stacktrace: stacktrace.toString()
      );
    }
  }

  setMovimentoTransacao(Transacao transacao) async {
    try {
    _movimento.idTransacao = transacao.id;
    _movimento.transacao = transacao;
    _movimentoController.add(_movimento);
    } catch(error, stacktrace) {
      appGlobalBloc.logger.e(error.toString(), '<shared_venda_bloc> setMovimentoTransacao');
      await log(_hasuraBloc, appGlobalBloc,
        nomeArquivo: "shared_venda_bloc",
        nomeFuncao: "setMovimentoTransacao",
        error: error.toString(),
        stacktrace: stacktrace.toString()
      );
    }   
  }
  
  getallProduto() async {
    try {
      Produto _produto = Produto();
      ProdutoDAO produtoDAO = ProdutoDAO(_hasuraBloc, appGlobalBloc, _produto);
      produtoDAO.loadCategoria = true;
      produtoDAO.loadGrade = true;
      produtoDAO.loadProdutoImagem = true;
      produtoDAO.loadProdutoVariante = true;
      produtoDAO.loadPrecoTabela = true;
      produtoDAO.loadProdutoEstoque = false;
      produtoDAO.filterCategoria = filterCategoria;
      produtoDAO.filterTemServico = filterTemServico;
      produtoDAO.filterText = filterText;
      print(":::::::::::::::: MOVIMENTO idPrecoTabela:  ${_movimento.transacao.idPrecoTabela.toString()} ::::::::::::::");
      print(":::::::::::::::: APP GLOBAL BLOC - IDTRANSACAO ${appGlobalBloc.terminal.idTransacao.toString()} ::::::::::::::");
      if (_movimento.transacao.idPrecoTabela == null) {
        _movimento.idTransacao = appGlobalBloc.terminal.idTransacao;
        await getTransacao(_movimento.idTransacao);
        _movimento.transacao = _transacao;
      }
      produtoDAO.filterPrecoTabela = _movimento.transacao.idPrecoTabela;
      // a!= null ? _movimento.transacao.idPrecoTabela : 1;
      _produtoList = offset == 0 ? [] : _produtoList;
      _produtoList += await produtoDAO.getAll(preLoad: true, offset: offset);
      if (_movimento.transacao.descontoPercentual > 0) {
        _produtoList.forEach((prod) => prod.precoTabelaItem.first.preco = prod.precoTabelaItem.first.preco - (prod.precoTabelaItem.first.preco * 
        (_movimento.transacao.descontoPercentual / 100)));
      }
      _produtoListController.add(_produtoList);
      offset += queryLimit;
    } catch(error, stacktrace) {
      appGlobalBloc.logger.e(error.toString(), '<shared_venda_bloc> getAllProduto');
      await log(_hasuraBloc, appGlobalBloc,
        nomeArquivo: "shared_venda_bloc",
        nomeFuncao: "getAllProduto",
        error: error.toString(),
        stacktrace: stacktrace.toString()
      );
    }   
  }

  Future<bool>getProdutoByCodigoBarras() async {
    try {
      produto = null;
      ProdutoCodigoBarras produtoCodigoBarras = ProdutoCodigoBarras();
      ProdutoCodigoBarrasDAO produtoCodigoBarrasDAO = ProdutoCodigoBarrasDAO(_hasuraBloc, appGlobalBloc, produtoCodigoBarras: produtoCodigoBarras);
      List<ProdutoCodigoBarras> produtoCodigoBarrasList = [];
      produtoCodigoBarrasDAO.filterText = filterText;
      produtoCodigoBarrasList = await produtoCodigoBarrasDAO.getAll();
      if (produtoCodigoBarrasList.length > 0) {
        Produto _produto = Produto();
        ProdutoDAO produtoDAO = ProdutoDAO(_hasuraBloc, appGlobalBloc, _produto);
        produtoDAO.filterPrecoTabela = _movimento.transacao.idPrecoTabela;
        _produto = await produtoDAO.getById(produtoCodigoBarrasList[0].idProduto);
        if ((_produto != null) && ((_produto.idGrade != null) && (_produto.idGrade > 0)) || (_produto.produtoVariante.length > 0)) {
          produto = _produto;
          filterText = "";
          return true;
        }
        await addMovimentoItem(_produto.id, 0, 0, _produto.precoTabelaItem[0].preco);
        filterText = "";
        return true;
      } else {
        filterText = "";
        return true;      
      }
    } catch(error, stacktrace) {
      appGlobalBloc.logger.e(error.toString(), '<shared_venda_bloc> getProdutoByCodigoBarras');
      await log(_hasuraBloc, appGlobalBloc,
        nomeArquivo: "shared_venda_bloc",
        nomeFuncao: "getProdutoByCodigoBarras",
        error: error.toString(),
        stacktrace: stacktrace.toString()
      );
      return false;
    }   
  }

  getallCategoria({String filter_text = ""}) async {
    try {
      categoriaDAO.filterCategoriaServico = filterTemServico == FilterTemServico.ehServico ? 1 : 0;
      categoriaDAO.filterText = filter_text;
      categoriaList = await categoriaDAO.getAll();
      _categoriaListController.add(categoriaList);
    } catch(error, stacktrace) {
      appGlobalBloc.logger.e(error.toString(), '<shared_venda_bloc> getAllCategoria');
      await log(_hasuraBloc, appGlobalBloc,
        nomeArquivo: "shared_venda_bloc",
        nomeFuncao: "getAllCategoria",
        error: error.toString(),
        stacktrace: stacktrace.toString()
      );
    }   
  }

  getallTipoPagamentos() async {
    try {
      TipoPagamento tipoPagamento = TipoPagamento();
      TipoPagamentoDAO tipoPagamentoDAO =
          TipoPagamentoDAO(_hasuraBloc, appGlobalBloc, tipoPagamento: tipoPagamento);
      tipoPagamentoDAO.filterText = "";
      tipoPagamentoDAO.filterId = 0;
      tipoPagamentoList = await tipoPagamentoDAO.getAll();
      _tipoPagamentoListController.add(tipoPagamentoList);
    } catch(error, stacktrace) {
      appGlobalBloc.logger.e(error.toString(), '<shared_venda_bloc> getallTipoPagamentos');
      await log(_hasuraBloc, appGlobalBloc,
        nomeArquivo: "shared_venda_bloc",
        nomeFuncao: "getallTipoPagamentos",
        error: error.toString(),
        stacktrace: stacktrace.toString()
      );
    }   
  }

  getallMovimento({bool ehorcamento = false}) {
    //TODO
  }

  getProdutoGrade({int index}) async {
    _gradeItensList.clear();
    Produto _produto = Produto();
    _produto = produto != null ? produto : _produtoList[index];
    if ((_produto.grade.t1 != "") &&
        (_produto.grade.t1 != null)) {
      _gradeItensList.add(_produto.grade.t1);
    }
    if ((_produto.grade.t2 != "") &&
        (_produto.grade.t2 != null)) {
      _gradeItensList.add(_produto.grade.t2);
    }
    if ((_produto.grade.t3 != "") &&
        (_produto.grade.t3 != null)) {
      _gradeItensList.add(_produto.grade.t3);
    }
    if ((_produto.grade.t4 != "") &&
        (_produto.grade.t4 != null)) {
      _gradeItensList.add(_produto.grade.t4);
    }
    if ((_produto.grade.t5 != "") &&
        (_produto.grade.t5 != null)) {
      _gradeItensList.add(_produto.grade.t5);
    }
    if ((_produto.grade.t6 != "") &&
        (_produto.grade.t6 != null)) {
      _gradeItensList.add(_produto.grade.t6);
    }
    if ((_produto.grade.t7 != "") &&
        (_produto.grade.t7 != null)) {
      _gradeItensList.add(_produto.grade.t7);
    }
    if ((_produto.grade.t8 != "") &&
        (_produto.grade.t8 != null)) {
      _gradeItensList.add(_produto.grade.t8);
    }
    if ((_produto.grade.t9 != "") &&
        (_produto.grade.t9 != null)) {
      _gradeItensList.add(_produto.grade.t9);
    }
    if ((_produto.grade.t10 != "") &&
        (_produto.grade.t10 != null)) {
      _gradeItensList.add(_produto.grade.t10);
    }
    if ((_produto.grade.t11 != "") &&
        (_produto.grade.t11 != null)) {
      _gradeItensList.add(_produto.grade.t11);
    }
    if ((_produto.grade.t12 != "") &&
        (_produto.grade.t12 != null)) {
      _gradeItensList.add(_produto.grade.t12);
    }
    if ((_produto.grade.t13 != "") &&
        (_produto.grade.t13 != null)) {
      _gradeItensList.add(_produto.grade.t13);
    }
    if ((_produto.grade.t14 != "") &&
        (_produto.grade.t14 != null)) {
      _gradeItensList.add(_produto.grade.t14);
    }
    if ((_produto.grade.t15 != "") &&
        (_produto.grade.t15 != null)) {
      _gradeItensList.add(_produto.grade.t15);
    }
    _gradeController.add(_gradeItensList);
  }

  getAllTutorial({String filterText}) async {
    try {
      Tutorial _tutorial = Tutorial();
      TutorialDAO _tutorialDAO = TutorialDAO(_hasuraBloc, _tutorial, appGlobalBloc);
      _tutorialDAO.filterText = filterText;
      tutorialList = await _tutorialDAO.getAll();
    } catch(error, stacktrace) {
      appGlobalBloc.logger.e(error.toString(), '<shared_venda_bloc> getAllTutorial');
      await log(_hasuraBloc, appGlobalBloc,
        nomeArquivo: "shared_venda_bloc",
        nomeFuncao: "getAllTutorial",
        error: error.toString(),
        stacktrace: stacktrace.toString()
      );
    }   
  }

  getTutorialByModulo(String filterText) async {
    try {
      Tutorial _tutorial = Tutorial();
      TutorialDAO _tutorialDAO = TutorialDAO(_hasuraBloc, _tutorial, appGlobalBloc);
      _tutorialDAO.filterText = filterText;
      tutorialList = await _tutorialDAO.getAll();
      tutorial = (tutorialList != null && tutorialList.length > 0) && tutorialList[0].ehConcluido == 1 ? null : Tutorial(passo: 0);
    } catch(error, stacktrace) {
      appGlobalBloc.logger.e(error.toString(), '<shared_venda_bloc> getTutorialByModulo');
      await log(_hasuraBloc, appGlobalBloc,
        nomeArquivo: "shared_venda_bloc",
        nomeFuncao: "getTutorialByModulo",
        error: error.toString(),
        stacktrace: stacktrace.toString()
      );
    }   
  }

  verificaCaixaAberto() async{
    try {
      await _movimentoCaixaBloc.getMovimentoCaixa(DateTime.now());
      if ((_movimentoCaixaBloc.movimentoCaixa.dataAbertura != null) && 
          ourDate(_movimentoCaixaBloc.movimentoCaixa.dataAbertura) == ourDate(DateTime.now())) {
        if (_movimentoCaixaBloc.movimentoCaixa.dataFechamento != null) {
          print("*** Caixa fechado ***");
          statusCaixa = StatusCaixa.fechado;
          // *************************
          // Mostrar tela de caixa fechado e nao deixar mais vender ...
          // *************************
        }
        statusCaixa = StatusCaixa.aberto;
      } else {
        bool temCaixaAbertoAnterior = await _movimentoCaixaBloc.temCaixaAbertoAnterior();
        if (temCaixaAbertoAnterior) {
          print("*** Caixa dia anterior aberto ***");
          statusCaixa = StatusCaixa.caixaDoDiaAnteriorAberto;
        }
        print("*** Necessita abertura ***");
        statusCaixa = StatusCaixa.necessitaAbertura;
        // *************************
        // Forcar abertura de caixa ...
        // *************************
      }
    } catch(error, stacktrace) {
      appGlobalBloc.logger.e(error.toString(), '<shared_venda_bloc> verificaCaixaAberto');
      await log(_hasuraBloc, appGlobalBloc,
        nomeArquivo: "shared_venda_bloc",
        nomeFuncao: "verificaCaixaAberto",
        error: error.toString(),
        stacktrace: stacktrace.toString()
      );
    }   
  }

  addMovimentoItem(int idProduto, int gradePosicao, int idVariante, double precoVendido) async {
    try {
      var novo = movimento.movimentoItem.singleWhere(
          (movItem) => ((movItem.idProduto == idProduto) &&
              (movItem.idVariante == idVariante) && (movItem.gradePosicao == gradePosicao) &&
              (movItem.precoVendido == precoVendido) && (movItem.ehdeletado == 0) &&
              (movItem.quantidade > 0)),
          orElse: () => null);
      if (novo == null) {
        _sequencial++;
        MovimentoItem novo = MovimentoItem();
        ProdutoDAO produtoDao = ProdutoDAO(_hasuraBloc, appGlobalBloc, novo.produto);
        produtoDao.filterPrecoTabela = _movimento.transacao.idPrecoTabela;
        novo.produto = await produtoDao.getById(idProduto);
        novo.idProduto = novo.produto.id;
        novo.idVariante = idVariante;
        novo.gradePosicao = gradePosicao;
        novo.quantidade = movimento.transacao.tipoEstoque == 0 ? 1 : -1;
        novo.precoCusto = novo.produto.precoCusto;
        novo.precoTabela = novo.produto.precoTabelaItem.first.preco;
        novo.ehservico = novo.produto.ehservico;
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
        movimento.valorTotalLiquido += novo.totalLiquido;
        movimento.valorRestante = movimento.valorTotalBruto;
        if (novo.ehservico == 1) {
          movimento.valorTotalBrutoServico += novo.totalLiquido;
          movimento.valorTotalLiquidoServico += novo.totalLiquido;
        } else {
          movimento.valorTotalBrutoProduto += novo.totalLiquido;
          movimento.valorTotalLiquidoProduto += novo.totalLiquido;
        }
        movimento.movimentoItem.add(novo);
        produtoDao = null;
      } else {
        movimento.valorTotalBruto -= novo.totalLiquido;
        movimento.valorTotalLiquido -= novo.totalLiquido;
        if (novo.ehservico == 1) {
          movimento.valorTotalBrutoServico -= novo.totalLiquido;
          movimento.valorTotalLiquidoServico -= novo.totalLiquido;
        } else {
          movimento.valorTotalBrutoProduto -= novo.totalLiquido;
          movimento.valorTotalLiquidoProduto -= novo.totalLiquido;
        }
        novo.quantidade++;
        novo.totalBruto = novo.precoTabela * novo.quantidade;
        novo.totalLiquido = novo.precoVendido * novo.quantidade;
        movimento.valorTotalBruto += novo.totalLiquido;
        movimento.valorTotalLiquido += novo.totalLiquido;
        movimento.valorRestante = movimento.valorTotalBruto;
         if (novo.ehservico == 1) {
          movimento.valorTotalBrutoServico += novo.totalLiquido;
          movimento.valorTotalLiquidoServico += novo.totalLiquido;
        } else {
          movimento.valorTotalBrutoProduto += novo.totalLiquido;
          movimento.valorTotalLiquidoProduto += novo.totalLiquido;
        }
       movimento.totalQuantidade ++;
      }
      movimento.valorTotalDesconto = 0;
      movimento.movimentoParcela.clear();
      _counterController.add(_counter);
      _movimentoController.add(movimento);
      novo = null;
    } catch(error, stacktrace) {
      appGlobalBloc.logger.e(error.toString(), '<shared_venda_bloc> addMovimentoItem');
      await log(_hasuraBloc, appGlobalBloc,
        nomeArquivo: "shared_venda_bloc",
        nomeFuncao: "addMovimentoItem",
        error: error.toString(),
        stacktrace: stacktrace.toString()
      );
    } 
  }

  addMovimentoItemTroca(int idProduto, int gradePosicao, int idVariante) async {
    try {
      _sequencial--;
      MovimentoItem novo = MovimentoItem();
      ProdutoDAO produtoDao = ProdutoDAO(_hasuraBloc, appGlobalBloc, novo.produto);
      produtoDao.filterPrecoTabela = _movimento.transacao.idPrecoTabela;
      novo.produto = await produtoDao.getById(idProduto);
      novo.idProduto = novo.produto.id;
      novo.idVariante = idVariante;
      novo.gradePosicao = gradePosicao;
      novo.quantidade = -1;
      novo.precoCusto = novo.produto.precoCusto;
      novo.precoTabela = novo.produto.precoTabelaItem.first.preco;
      novo.precoVendido = novo.produto.precoTabelaItem.first.preco;
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
    } catch(error, stacktrace) {
      appGlobalBloc.logger.e(error.toString(), '<shared_venda_bloc> addMovimentoItemTroca');
      await log(_hasuraBloc, appGlobalBloc,
        nomeArquivo: "shared_venda_bloc",
        nomeFuncao: "addMovimentoItemTroca",
        error: error.toString(),
        stacktrace: stacktrace.toString()
      );
    }   
  }

  removeMovimentoItem(int index) async {
    try {
      _movimento.movimentoItem[index].ehdeletado = 1;
      _movimento.valorTotalBruto -= _movimento.movimentoItem[index].totalLiquido;
      _movimento.valorTotalLiquido -= _movimento.movimentoItem[index].totalLiquido;
      _movimento.valorRestante = _movimento.valorTotalLiquido;
      if (_movimento.movimentoItem[index].ehservico == 1) {
        _movimento.valorTotalBrutoServico -= _movimento.movimentoItem[index].totalLiquido;
        _movimento.valorTotalLiquidoServico -= _movimento.movimentoItem[index].totalLiquido;
      } else {
        _movimento.valorTotalBrutoProduto -= _movimento.movimentoItem[index].totalLiquido;
        _movimento.valorTotalLiquidoProduto -= _movimento.movimentoItem[index].totalLiquido;
      }
      print( _movimento.movimentoItem[index].totalLiquido);
      _movimento.totalItens --;
      _movimento.totalQuantidade -= _movimento.movimentoItem[index].quantidade;
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
    } catch(error, stacktrace) {
      appGlobalBloc.logger.e(error.toString(), '<shared_venda_bloc> removeMovimentoItem');
      await log(_hasuraBloc, appGlobalBloc,
        nomeArquivo: "shared_venda_bloc",
        nomeFuncao: "removeMovimentoItem",
        error: error.toString(),
        stacktrace: stacktrace.toString()
      );
    }   
  }

  cancelMovimento(int index) async {
    _pedidoList[index].ehcancelado = 1;
    _pedidoList.removeAt(index);
    _pedidoListController.add(_pedidoList);
  }

  setQuantidadeMovimentoItem(int index, double quantidade) async {
    try {
      _movimento.valorTotalBruto -= _movimento.movimentoItem[index].precoVendido * _movimento.movimentoItem[index].quantidade;
      _movimento.valorTotalLiquido -= _movimento.movimentoItem[index].totalLiquido;
      _movimento.totalQuantidade -= _movimento.movimentoItem[index].quantidade;
      if (_movimento.movimentoItem[index].ehservico == 1) {
        _movimento.valorTotalBrutoServico -= _movimento.movimentoItem[index].precoVendido * _movimento.movimentoItem[index].quantidade;
        _movimento.valorTotalLiquidoServico -= _movimento.movimentoItem[index].totalLiquido;
      } else {
        _movimento.valorTotalBrutoProduto -= _movimento.movimentoItem[index].precoVendido * _movimento.movimentoItem[index].quantidade;
        _movimento.valorTotalLiquidoProduto -= _movimento.movimentoItem[index].totalLiquido;
      }
      _movimento.movimentoItem[index].quantidade = quantidade;
      _movimento.movimentoItem[index].totalLiquido = _movimento.movimentoItem[index].precoVendido * quantidade;
      _movimento.totalQuantidade += _movimento.movimentoItem[index].quantidade;
      _movimento.valorTotalBruto += _movimento.movimentoItem[index].precoVendido * _movimento.movimentoItem[index].quantidade;
      _movimento.valorTotalLiquido += _movimento.movimentoItem[index].totalLiquido;
      _movimento.valorRestante = _movimento.valorTotalBruto;
      if (_movimento.movimentoItem[index].ehservico == 1) {
        _movimento.valorTotalBrutoServico += _movimento.movimentoItem[index].precoVendido * _movimento.movimentoItem[index].quantidade;
        _movimento.valorTotalLiquidoServico += _movimento.movimentoItem[index].totalLiquido;
      } else {
        _movimento.valorTotalBrutoProduto += _movimento.movimentoItem[index].precoVendido * _movimento.movimentoItem[index].quantidade;
        _movimento.valorTotalLiquidoProduto += _movimento.movimentoItem[index].totalLiquido;
      }
      _movimento.movimentoParcela.clear();
      _movimentoController.add(_movimento);
    } catch(error, stacktrace) {
      appGlobalBloc.logger.e(error.toString(), '<shared_venda_bloc> setQuantidadeMovimentoItem');
      await log(_hasuraBloc, appGlobalBloc,
        nomeArquivo: "shared_venda_bloc",
        nomeFuncao: "setQuantidadeMovimentoItem",
        error: error.toString(),
        stacktrace: stacktrace.toString()
      );
    }   
  }

  setValorMovimentoItem(int index, double value) async {
    try {
      _movimento.valorTotalBruto -= _movimento.movimentoItem[index].precoVendido * _movimento.movimentoItem[index].quantidade;
      _movimento.valorTotalLiquido -= _movimento.movimentoItem[index].totalLiquido;
      if (_movimento.movimentoItem[index].ehservico == 1) {
        _movimento.valorTotalBrutoServico -= _movimento.movimentoItem[index].precoVendido * _movimento.movimentoItem[index].quantidade;
        _movimento.valorTotalLiquidoServico -= _movimento.movimentoItem[index].totalLiquido;
      } else {
        _movimento.valorTotalBrutoProduto -= _movimento.movimentoItem[index].precoVendido * _movimento.movimentoItem[index].quantidade;
        _movimento.valorTotalLiquidoProduto -= _movimento.movimentoItem[index].totalLiquido;
      }
      _movimento.movimentoItem[index].precoVendido = value;
      _movimento.movimentoItem[index].totalLiquido = _movimento.movimentoItem[index].precoVendido * _movimento.movimentoItem[index].quantidade;
      _movimento.valorTotalBruto += _movimento.movimentoItem[index].precoVendido * _movimento.movimentoItem[index].quantidade;
      _movimento.valorTotalLiquido += _movimento.movimentoItem[index].totalLiquido;
      _movimento.valorRestante = _movimento.valorTotalBruto;
      if (_movimento.movimentoItem[index].ehservico == 1) {
        _movimento.valorTotalBrutoServico += _movimento.movimentoItem[index].precoVendido * _movimento.movimentoItem[index].quantidade;
        _movimento.valorTotalLiquidoServico += _movimento.movimentoItem[index].totalLiquido;
      } else {
        _movimento.valorTotalBrutoProduto += _movimento.movimentoItem[index].precoVendido * _movimento.movimentoItem[index].quantidade;
        _movimento.valorTotalLiquidoProduto += _movimento.movimentoItem[index].totalLiquido;
      }
      _movimento.movimentoParcela.clear();
      _movimentoController.add(_movimento);
    } catch(error, stacktrace) {
      appGlobalBloc.logger.e(error.toString(), '<shared_venda_bloc> setValorMovimentoItem');
      await log(_hasuraBloc, appGlobalBloc,
        nomeArquivo: "shared_venda_bloc",
        nomeFuncao: "setValorMovimentoItem",
        error: error.toString(),
        stacktrace: stacktrace.toString()
      );
    }   
  }

  addMovimentoParcela(TipoPagamento tipoPagamento, double valor) async {
    try {
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
    } catch(error, stacktrace) {
      appGlobalBloc.logger.e(error.toString(), '<shared_venda_bloc> addMovimentoParcela');
      await log(_hasuraBloc, appGlobalBloc,
        nomeArquivo: "shared_venda_bloc",
        nomeFuncao: "addMovimentoParcela",
        error: error.toString(),
        stacktrace: stacktrace.toString()
      );
    }   
  }

  removeMovimentoParcela(int index) async {
    try {
      _movimento.valorRestante = (_movimento.valorRestante + (_movimento.movimentoParcela[index].valor - _movimento.valorTroco));
      _movimento.valorTroco = (_movimento.valorRestante > 0) ? 0 : _movimento.valorTroco;
      _movimento.movimentoParcela.removeAt(index);
      _movimentoController.add(_movimento);
    } catch(error, stacktrace) {
      appGlobalBloc.logger.e(error.toString(), '<shared_venda_bloc> removeMovimentoParcela');
      await log(_hasuraBloc, appGlobalBloc,
        nomeArquivo: "shared_venda_bloc",
        nomeFuncao: "removeMovimentoParcela",
        error: error.toString(),
        stacktrace: stacktrace.toString()
      );
    }   
  }

  addDescontoMovimento({int percent, double value}) async {
    try {
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
    } catch(error, stacktrace) {
      appGlobalBloc.logger.e(error.toString(), '<shared_venda_bloc> addDescontoMovimento');
      await log(_hasuraBloc, appGlobalBloc,
        nomeArquivo: "shared_venda_bloc",
        nomeFuncao: "addDescontoMovimento",
        error: error.toString(),
        stacktrace: stacktrace.toString()
      );
    }   
  }

  removeDescontoMovimento() async {
    try { 
      movimento.valorTotalDesconto = 0;
      movimento.valorRestante = movimento.valorTotalLiquido;
      movimento.valorTroco = 0;
      movimento.movimentoParcela.clear();
      _movimentoController.add(movimento);
    } catch(error, stacktrace) {
      appGlobalBloc.logger.e(error.toString(), '<shared_venda_bloc> removeDescontoMovimento');
      await log(_hasuraBloc, appGlobalBloc,
        nomeArquivo: "shared_venda_bloc",
        nomeFuncao: "removeDescontoMovimento",
        error: error.toString(),
        stacktrace: stacktrace.toString()
      );
    }   
  }

  setVendedorMovimento(int _idVendedor, String _nomeVendedor){
    _movimento.idVendedor = _idVendedor;
    nomeVendedor = _nomeVendedor;
    _movimentoController.add(_movimento);
  }

  setClienteMovimento(int _idCliente, String _nomeCliente){
    _movimento.idCliente = _idCliente;
    nomeCliente = _nomeCliente;
    _movimentoController.add(_movimento);
  }

  addDescontoMovimentoItem({int index, int percent, double value}) async {
    try {
      //_movimento.valorTotalBruto -= _movimento.movimentoItem[index].totalBruto;
      _movimento.valorTotalLiquido -= _movimento.movimentoItem[index].totalLiquido;
      if (_movimento.movimentoItem[index].ehservico == 1) {
        _movimento.valorTotalLiquidoServico -= _movimento.movimentoItem[index].totalLiquido;
      } else {
        _movimento.valorTotalLiquidoProduto -= _movimento.movimentoItem[index].totalLiquido;
      }
      _movimento.movimentoItem[index].totalDesconto = (value > 0) ?
        value :
        ((percent / 100) * _movimento.movimentoItem[index].precoVendido) * _movimento.movimentoItem[index].quantidade;
      _movimento.movimentoItem[index].precoVendido -= (_movimento.movimentoItem[index].totalDesconto / _movimento.movimentoItem[index].quantidade);
      _movimento.movimentoItem[index].totalLiquido = _movimento.movimentoItem[index].precoVendido * _movimento.movimentoItem[index].quantidade;
      _movimento.valorTotalDescontoItemProduto += _movimento.movimentoItem[index].totalDesconto;
      //_movimento.valorTotalBruto += _movimento.movimentoItem[index].totalBruto;
      _movimento.valorTotalLiquido += _movimento.movimentoItem[index].totalLiquido;
      if (_movimento.movimentoItem[index].ehservico == 1) {
        _movimento.valorTotalLiquidoServico += _movimento.movimentoItem[index].totalLiquido;
      } else {
        _movimento.valorTotalLiquidoProduto += _movimento.movimentoItem[index].totalLiquido;
      }
      _movimento.valorRestante = _movimento.valorTotalLiquido;
      _movimentoListController.add(_movimentoList);
      _movimentoController.add(_movimento);
    } catch(error, stacktrace) {
      appGlobalBloc.logger.e(error.toString(), '<shared_venda_bloc> addDescontoMovimentoItem');
      await log(_hasuraBloc, appGlobalBloc,
        nomeArquivo: "shared_venda_bloc",
        nomeFuncao: "addDescontoMovimentoItem",
        error: error.toString(),
        stacktrace: stacktrace.toString()
      );
    }   
  }

  Future saveVenda(int ehorcamento) async {
    try {
      _movimentoDAO = null;
      _movimento.ehorcamento = ehorcamento;
      _movimento.ehsincronizado = 0;
      _movimentoDAO = MovimentoDAO(_hasuraBloc, appGlobalBloc, _movimento);
      await _movimentoDAO.insert();
      //await printRecibo();
      //await getAllPedido();
      await resetBloc();
      doSync();
    } catch(error, stacktrace) {
      appGlobalBloc.logger.e(error.toString(), '<shared_venda_bloc> saveVenda');
      await log(_hasuraBloc, appGlobalBloc,
        nomeArquivo: "shared_venda_bloc",
        nomeFuncao: "saveVenda",
        error: error.toString(),
        stacktrace: stacktrace.toString()
      );
    }   
  }

  Future printRecibo() async {
    try {
      CupomLayoutBloc cupomLayoutBloc = CupomLayoutBloc(_hasuraBloc, appGlobalBloc);
      TerminalDAO _terminalDao = TerminalDAO(_hasuraBloc, appGlobalBloc, terminal: appGlobalBloc.terminal);
      Terminal _terminal = await _terminalDao.getByIdFromServer(appGlobalBloc.terminal.id);
    
      PaperSize _paperSize;
      if(_terminal.terminalImpressora.first.cupomLayout.tamanhoPapel == 58){
        _paperSize = PaperSize.mm58;
      } else if(_terminal.terminalImpressora.first.cupomLayout.tamanhoPapel == 80){
        _paperSize = PaperSize.mm80;
      }
      
      final Ticket ticket = Ticket(_paperSize);
      List<String> lojaDetail = [];
      List<String> vendedorClienteList = [];
      List<String> produtoList = [];
      List<String> servicoList = [];
      MoneyMaskedTextController valorTotalBruto = MoneyMaskedTextController(initialValue: movimento.valorTotalBruto);
      MoneyMaskedTextController valorTotalDesconto = MoneyMaskedTextController(initialValue: movimento.valorTotalDesconto);
      MoneyMaskedTextController valorTotalLiquido = MoneyMaskedTextController(initialValue: movimento.valorTotalLiquido);
      MoneyMaskedTextController valorTotalTroco = MoneyMaskedTextController(initialValue: movimento.valorTroco);
      MoneyMaskedTextController precoTabelaItemPreco = MoneyMaskedTextController();
      MoneyMaskedTextController movimentoItemDesconto = MoneyMaskedTextController();
      MoneyMaskedTextController movimentoItemTotalLiquido = MoneyMaskedTextController();
      MoneyMaskedTextController movimentoParcelaValor = MoneyMaskedTextController();
      MoneyMaskedTextController subTotalProduto = MoneyMaskedTextController();
      MoneyMaskedTextController subTotalServico = MoneyMaskedTextController();

      lojaDetail = [
        "${appGlobalBloc.loja.razaoNome.toUpperCase()}",
        "${appGlobalBloc.loja.cnpjCpf.toUpperCase()}"      
        //"${appGlobalBloc.loja.endereco.first.logradouro.toUpperCase()}, ${appGlobalBloc.loja.endereco.first.numero}",
        //"${appGlobalBloc.loja.endereco.first.estado.toUpperCase()}"
      ];
      vendedorClienteList = [
        'VENDEDOR: ${nomeVendedor != "" ? nomeVendedor.toUpperCase() : "Não selecionado"}',
        'CLIENTE: ${nomeCliente != "" ? nomeCliente.toUpperCase() : "Não selecionado"}',
      ];
      
      //Inicio informações da loja
      lojaDetail.forEach((lojaDetail){
        ticket.text(lojaDetail,
          styles: PosStyles(
            align: PosTextAlign.center,
            fontType: PosFontType.fontB,
            height: PosTextSize.size2
          )
        );
      });
      //Fim informações da loja
      if (_terminal.terminalImpressora.length > 0) {

        PaperSize _paperSize;
        if(_terminal.terminalImpressora.first.cupomLayout.tamanhoPapel == 58){
          _paperSize = PaperSize.mm58;
        } else if(_terminal.terminalImpressora.first.cupomLayout.tamanhoPapel == 80){
          _paperSize = PaperSize.mm80;
        }
        
        final Ticket ticket = Ticket(_paperSize);
        List<String> lojaDetail = [];
        List<String> vendedorClienteList = [];
        List<String> produtoList = [];
        List<String> servicoList = [];
        MoneyMaskedTextController valorTotalBruto = MoneyMaskedTextController(initialValue: movimento.valorTotalBruto);
        MoneyMaskedTextController valorTotalDesconto = MoneyMaskedTextController(initialValue: movimento.valorTotalDesconto);
        MoneyMaskedTextController valorTotalLiquido = MoneyMaskedTextController(initialValue: movimento.valorTotalLiquido);
        MoneyMaskedTextController valorTotalTroco = MoneyMaskedTextController(initialValue: movimento.valorTroco);
        MoneyMaskedTextController precoTabelaItemPreco = MoneyMaskedTextController();
        MoneyMaskedTextController movimentoItemDesconto = MoneyMaskedTextController();
        MoneyMaskedTextController movimentoItemTotalLiquido = MoneyMaskedTextController();
        MoneyMaskedTextController movimentoParcelaValor = MoneyMaskedTextController();
        MoneyMaskedTextController subTotalProduto = MoneyMaskedTextController();
        MoneyMaskedTextController subTotalServico = MoneyMaskedTextController();

        lojaDetail = [
          "${appGlobalBloc.loja.razaoNome.toUpperCase()}",
          "${appGlobalBloc.loja.cnpjCpf.toUpperCase()}"      
          //"${appGlobalBloc.loja.endereco.first.logradouro.toUpperCase()}, ${appGlobalBloc.loja.endereco.first.numero}",
          //"${appGlobalBloc.loja.endereco.first.estado.toUpperCase()}"
        ];
        vendedorClienteList = [
          'VENDEDOR: ${nomeVendedor != "" ? nomeVendedor.toUpperCase() : "Não selecionado"}',
          'CLIENTE: ${nomeCliente != "" ? nomeCliente.toUpperCase() : "Não selecionado"}',
        ];
        
        //Inicio informações da loja
        lojaDetail.forEach((lojaDetail){
          ticket.text(lojaDetail,
            styles: PosStyles(
              align: PosTextAlign.center,
              fontType: PosFontType.fontB,
              height: PosTextSize.size2
            )
          );
        });
        //Fim informações da loja

        //Início texto cabecalho
        if(_terminal.terminalImpressora.first.textoCabecalho != null) {
          ticket.text(_terminal.terminalImpressora.first.textoCabecalho,
            styles: PosStyles(
              align: PosTextAlign.center,
              fontType: PosFontType.fontB, 
            )
          );
        }
        //Fim texto cabecalho
        
        //Inicio Vendedor e Cliente
        ticket.feed(1);
        if(vendedorClienteList.length > 0) {
          vendedorClienteList.forEach((vendedorCliente) {
            ticket.text(vendedorCliente,
              styles: PosStyles(
                fontType: PosFontType.fontB, 
              )
            );
          });
        }
        //Fim Vendedor e Cliente
        ticket.text("${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year} - ${DateTime.now().hour}:${DateTime.now().minute}",
          styles: PosStyles(
            align: PosTextAlign.left,
            fontType: PosFontType.fontB,
          )
        );

        ticket.text(_paperSize == PaperSize.mm80 
          ? "--------------------------------------------------------"
          : "------------------------------------------",
          styles: PosStyles(
            fontType: PosFontType.fontB
          )
        );

        //Inicio produtos
        List<String> cabecalhoList = [_paperSize == PaperSize.mm80 ? "CODIGO" : "COD", "DESCRICAO", "V.UNIT", "QTD", "V.TOTAL"];
        ticket.text(calculateSpacingOfTicket(cabecalhoList, _paperSize),
          styles: PosStyles(fontType: PosFontType.fontB, ),
        );
        
        ticket.text(_paperSize == PaperSize.mm80 
          ? "--------------------------------------------------------"
          : "------------------------------------------", 
          styles: PosStyles(
            fontType: PosFontType.fontB
          )
        );
        movimento.movimentoItem.forEach((movimentoItem){
          if(movimentoItem.ehdeletado == 0 && movimentoItem.produto.ehservico == 0){
            precoTabelaItemPreco.updateValue(movimentoItem.produto.precoTabelaItem.first.preco);
            movimentoItemDesconto.updateValue(movimentoItem.totalDesconto);
            movimentoItemTotalLiquido.updateValue(movimentoItem.totalLiquido);
            produtoList.add("${movimentoItem.produto.idAparente}"); 
            produtoList.add("${movimentoItem.produto.nome}");
            produtoList.add("${precoTabelaItemPreco.text}");
            produtoList.add("${movimentoItem.quantidade.toInt()}");
            produtoList.add("${movimentoItemTotalLiquido.text}");
            subTotalProduto.updateValue(subTotalProduto.numberValue + movimentoItem.totalLiquido);
            ticket.text(calculateSpacingOfTicket(produtoList, _paperSize),
              styles: PosStyles(
                fontType: PosFontType.fontB
              )
            );
            if(movimentoItem.totalDesconto > 0){
              ticket.text("-${movimentoItemDesconto.text}".padLeft(_paperSize == PaperSize.mm80 ? 56 : 42),
                styles: PosStyles(
                  fontType: PosFontType.fontB
                )
              );
            }
          }
          produtoList = [];
        });
        MovimentoItem _movimentoItemProduto = movimento.movimentoItem.firstWhere((test) => test.produto.ehservico == 0 && test.ehdeletado == 0, orElse: () => null);
        if(_movimentoItemProduto != null){
          ticket.text("SUBTOTAL PRODUTO(S)".padRight(_paperSize == PaperSize.mm80 ? 28 : 20) + "${subTotalProduto.text}".padLeft(_paperSize == PaperSize.mm80 ? 28 : 22),
            styles: PosStyles(
              fontType: PosFontType.fontB
            )
          );
        }
        //Fim produtos

        //Inicio serviço
        MovimentoItem movimentoItemServico = movimento.movimentoItem.firstWhere((test) => test.produto.ehservico == 1 && test.ehdeletado == 0, orElse: () => null);
        if(movimentoItemServico != null){
          if(_movimentoItemProduto != null){
            ticket.text("---------- SERVICO(S) ----------",
              styles: PosStyles(
                align: PosTextAlign.center,
                fontType: PosFontType.fontB
              )
            );
          }
          movimento.movimentoItem.forEach((movimentoItem){
            if(movimentoItem.ehdeletado == 0 && movimentoItem.produto.ehservico == 1){
              precoTabelaItemPreco.updateValue(movimentoItem.produto.precoTabelaItem.first.preco);
              movimentoItemDesconto.updateValue(movimentoItem.totalDesconto);
              movimentoItemTotalLiquido.updateValue(movimentoItem.totalLiquido);
              servicoList.add("${movimentoItem.produto.idAparente}");
              servicoList.add("${movimentoItem.produto.nome}");
              servicoList.add("${precoTabelaItemPreco.text}");
              servicoList.add("${movimentoItem.quantidade.toInt()}");
              servicoList.add("${movimentoItemTotalLiquido.text}");
              subTotalServico.updateValue(subTotalServico.numberValue + movimentoItem.totalLiquido);
              
              ticket.text(calculateSpacingOfTicket(servicoList , _paperSize),
                styles: PosStyles(
                  fontType: PosFontType.fontB
                )
              );
              if(movimentoItem.totalDesconto > 0){
                ticket.text("-${movimentoItemDesconto.text}".padLeft(_paperSize == PaperSize.mm80 ? 56 : 42),
                  styles: PosStyles(
                    fontType: PosFontType.fontB
                  )
                );
              }
            }
            servicoList = [];
          });
          ticket.text("SUBTOTAL SERVICO(S)".padRight(_paperSize == PaperSize.mm80 ? 28 : 20) + "${subTotalServico.text}".padLeft(_paperSize == PaperSize.mm80 ? 28 : 22),
            styles: PosStyles(
              fontType: PosFontType.fontB
            )
          );
        }
        //Fim serviço

        ticket.text(_paperSize == PaperSize.mm80 
          ? "--------------------------------------------------------"
          : "------------------------------------------", 
          styles: PosStyles(
            fontType: PosFontType.fontB
          )
        );
        
        //Inicio resumo
        ticket.text("TOTAL BRUTO".padRight(_paperSize == PaperSize.mm80 ? 28 : 20) + "${valorTotalBruto.text}".padLeft(_paperSize == PaperSize.mm80 ? 28 : 22), 
          styles: PosStyles(
            fontType: PosFontType.fontB
          )
        );
        // ticket.text("QUANTIDADE DE ITENS".padRight(_paperSize == PaperSize.mm80 ? 28 : 20) + "${movimento.movimentoItem.where((element) => element.ehdeletado == 0).length}".padLeft(_paperSize == PaperSize.mm80 ? 28 : 22), 
        //   styles: PosStyles(
        //     fontType: PosFontType.fontB
        //   )
        // );
        ticket.text("DESCONTO".padRight(_paperSize == PaperSize.mm80 ? 28 : 20) + "${valorTotalDesconto.text}".padLeft(_paperSize == PaperSize.mm80 ? 28 : 22), 
          styles: PosStyles(
            fontType: PosFontType.fontB
          )
        );
        ticket.text("TOTAL (R\$)".padRight(_paperSize == PaperSize.mm80 ? 28 : 18) + "${valorTotalLiquido.text}".padLeft(_paperSize == PaperSize.mm80 ? 28 : 14), 
          styles: PosStyles(
            fontType: PosFontType.fontA,
          )
        );
        //Fim resumo

        ticket.text(_paperSize == PaperSize.mm80 
          ? "--------------------------------------------------------"
          : "------------------------------------------", styles: PosStyles(
            fontType: PosFontType.fontB,
          )
        );

        
        //Inicio forma de pagamento
        if(movimento.ehorcamento == 0){
          ticket.text("FORMA(S) DE PAGAMENTO",
            styles: PosStyles(
              fontType: PosFontType.fontB,
            )
          );
          for(var i = 0; i < movimento.movimentoParcela.length; i++){
            movimentoParcelaValor.updateValue(movimento.movimentoParcela[i].valor);
            ticket.text("${movimento.movimentoParcela[i].tipoPagamento.nome.toUpperCase()}".padRight(_paperSize == PaperSize.mm80 ? 28 : 21) + "${movimentoParcelaValor.text}".padLeft(_paperSize == PaperSize.mm80 ? 28 : 21), 
              styles: PosStyles(
                fontType: PosFontType.fontB,
              )
            );
            if(i == movimento.movimentoParcela.length-1 && movimento.valorTroco > 0){
              ticket.text("TROCO".padRight(_paperSize == PaperSize.mm80 ? 28 : 21) + "${valorTotalTroco.text}".padLeft(_paperSize == PaperSize.mm80 ? 28 : 21), 
                styles: PosStyles(
                  fontType: PosFontType.fontB
                )
              );
            }
          }
        }
        //Fim forma de pagamento

        //Início texto rodape
        if(_terminal.terminalImpressora.first.textoRodape != null) {
          ticket.text(_terminal.terminalImpressora.first.textoRodape,
            styles: PosStyles(
              align: PosTextAlign.center,
              fontType: PosFontType.fontB, 
            )
          );
        }
        //Fim texto rodape

        ticket.cut();

        if(_terminal.terminalImpressora.first.ip != null){
          cupomLayoutBloc.printTicketRede(_terminal.terminalImpressora.first.ip, ticket);
        } else if(_terminal.terminalImpressora.first.macAddress != null){
          cupomLayoutBloc.printTicketBluetooth(
            _terminal.terminalImpressora.first.nome,
            _terminal.terminalImpressora.first.macAddress,
            ticket
          );
        }
      }
    } catch(error, stacktrace) {
      appGlobalBloc.logger.e(error.toString(), '<shared_venda_bloc> printRecibo');
      await log(_hasuraBloc, appGlobalBloc,
        nomeArquivo: "shared_venda_bloc",
        nomeFuncao: "printRecibo",
        error: error.toString(),
        stacktrace: stacktrace.toString()
      );
    }   
  }

  calculateSpacingOfTicket(List<String> stringList, PaperSize _paperSize) {
    String retorno = "";
    for(var i = 0; i < stringList.length; i++){
      if(i == 0){
        retorno += stringList[i].padRight(13) + " ";
      } else if(i == 1){
        retorno += stringList[i].padRight(19) + " ";
      } else if(i == 2){
        retorno += stringList[i].padLeft(_paperSize == PaperSize.mm80 ? 9 : 30) + " ";
      } else if(i == 3){
        retorno += stringList[i].padLeft(_paperSize == PaperSize.mm80 ? 4 : 8) + " ";
      } else if(i == 4){
        retorno += stringList[i].padLeft(_paperSize == PaperSize.mm80 ? 9 : 10);
      }
    }
    return retorno;
  }

  getPedido(int index) async {
    try {
      _movimento = _pedidoList[index];
      _movimento.valorRestante = _pedidoList[index].valorTotalLiquido;
      _counterController.add(_counter);
      _pedidoListController.add(_pedidoList);
      _movimentoController.add(_movimento);
    } catch(error, stacktrace) {
      appGlobalBloc.logger.e(error.toString(), '<shared_venda_bloc> getPedido');
      await log(_hasuraBloc, appGlobalBloc,
        nomeArquivo: "shared_venda_bloc",
        nomeFuncao: "getPedido",
        error: error.toString(),
        stacktrace: stacktrace.toString()
      );
    }   
  }

  getAllPedido() async {
    try {
      _movimentoDAO.filterEhOrcamento = true;
      _movimentoDAO.loadMovimentoItem = true;
      _movimentoDAO.filterEhCancelado = FilterEhCancelado.naoCancelados;
      _movimentoDAO.loadProduto = true;
      _movimentoDAO.loadTransacao = true;
      _pedidoList = await _movimentoDAO.getAll(preLoad: true);
      // for(var i=0; i < _pedidoList.length; i++){
      //   for(var j=0; j < _pedidoList[i].movimentoItem.length; j++){
      //     await addLocalBase64ImageToProdutoImagem(produto: _pedidoList[i].movimentoItem[j].produto);
      //   }
      // }
      _pedidoListController.add(_pedidoList);
    } catch(error, stacktrace) {
      appGlobalBloc.logger.e(error.toString(), '<shared_venda_bloc> getAllPedido');
      await log(_hasuraBloc, appGlobalBloc,
        nomeArquivo: "shared_venda_bloc",
        nomeFuncao: "getAllPedido",
        error: error.toString(),
        stacktrace: stacktrace.toString()
      );
    }   
  }

  cancelPedido(int index) async {
    try {
      _pedidoList[index].ehcancelado = 1;
      MovimentoDAO movimentoDAO = MovimentoDAO(_hasuraBloc, appGlobalBloc, _pedidoList[index]);
      await movimentoDAO.insert();
      await getAllPedido();
    } catch(error, stacktrace) {
      appGlobalBloc.logger.e(error.toString(), '<shared_venda_bloc> cancelPedido');
      await log(_hasuraBloc, appGlobalBloc,
        nomeArquivo: "shared_venda_bloc",
        nomeFuncao: "cancelPedido",
        error: error.toString(),
        stacktrace: stacktrace.toString()
      );
    }   
  }

  doSync(){
 
  }

  updateMovimentoStream(){
    _movimentoController.add(_movimento);
  }

  updateSincronizacaoHasuraStream(StatusSincronizacao statusSincronizacao) async {
    StatusSincronizacao _statusSincronizacaoHasura = statusSincronizacao;
    _statusSincronizacaoHasuraController.add(_statusSincronizacaoHasura);
  }

  getSaleById(int id) async {
    try {
      MovimentoDAO _movimentoDAO = MovimentoDAO(_hasuraBloc, appGlobalBloc, _movimento);
      movimento = await _movimentoDAO.getById(id);
      _movimentoController.add(movimento);
    } catch(error, stacktrace) {
      appGlobalBloc.logger.e(error.toString(), '<shared_venda_bloc> getSaleById');
      await log(_hasuraBloc, appGlobalBloc,
        nomeArquivo: "shared_venda_bloc",
        nomeFuncao: "getSaleById",
        error: error.toString(),
        stacktrace: stacktrace.toString()
      );
    }   
  }  

  resetBloc() async {
    _movimento = null;
    _movimentoDAO = null;
    filterText = "";
    filterCategoria = 0;
    nomeVendedor = "";
    nomeCliente = "";
    await initMovimento();
    await getallProduto();
    await getAllPedido();
  }

  zuma() async {
    await _movimentoDAO.delete(0);
    await _movimentoCaixaBloc.deleteAll();
  }

  mercadopagoOrdemdePagamento() async {
    Integracao integracao = Integracao();
    MercadopagoOrdemPagamento mercadopagoOrdemPagamento = MercadopagoOrdemPagamento(
      items: List<Items>()
    );
    mercadopagoOrdemPagamento.externalReference = "terminal159";
    mercadopagoOrdemPagamento.notificationUrl = "www.teste.com.br";
    movimento.movimentoItem.forEach((movimentoItem){
     mercadopagoOrdemPagamento.items.add(
       Items(
         title: movimentoItem.produto.nome,
         currencyId: 'BRL',
         quantity: movimentoItem.quantidade,
         unitPrice: movimentoItem.precoVendido
      ) 
     );
    });
    print(mercadopagoOrdemPagamento.items);
    mercadopagoOrdemPagamento.mercadopagoQrCode = appGlobalBloc.terminal.mercadopagoQrCode;
    mercadopagoOrdemPagamento.mercadopagoOrdemPagamentoPost("4221990933653784-031215-0f4a6528282e2a2fbe8301075ccf99bb-465147450","465147450","214");
  }

  
  picpayOrdemdePagamento() async {
    var uuid = new Uuid();
    uuid.v1();
    uuid.v1(options: {
      'nSecs': 5678
    });
    uuid.v4(); 
    uuid.v4(options: {'rng': UuidUtil.cryptoRNG});
    uuid.v5(Uuid.NAMESPACE_URL, 'www.google.com');
    Picpay picpay = Picpay();
    Buyer buyer = Buyer();
    Integracao integracao = Integracao();
    picpay.referenceId = uuid.v1().toString()+"(Código criptografado)";
    picpay.callbackUrl = "http://www.sualoja.com.br/callback";
    picpay.returnUrl =  "http://www.sualoja.com.br/cliente/pedido/102030";
    picpay.value = movimento.valorTotalLiquido;
    picpay.expiresAt = DateTime.now().add(Duration(minutes: 5));
    buyer.firstName = "Cliente";
    buyer.lastName = "Padrão";
    buyer.document = "000.000.000-00";
    buyer.email = "cliente@fluggy.com";
    buyer.phone = "+55 (11) 00000-0000";
    picpay.buyer = buyer;
    await picpay.picpayOrdemPagamentoPost("${appGlobalBloc.loja.integracao.where((test) => test.mercadopagoAcessToken == null || test.mercadopagoAcessToken == "").first}");
    return picpay.picpayQrCode;
  }

  setTutorialPasso(int passo) async {
    tutorial.passo = passo;
  }

  setTutorialVendaConcluida() async {
    try {
      tutorial.modulo = "Venda";
      tutorial.ehConcluido = 1;
      tutorial.dataAtualizacao = DateTime.now();
      TutorialDAO tutorialDAO = TutorialDAO(_hasuraBloc, tutorial, appGlobalBloc);
      tutorial = await tutorialDAO.insert();
      tutorial = null;
    } catch(error, stacktrace) {
      appGlobalBloc.logger.e(error.toString(), '<shared_venda_bloc> setTutorialVendaConcluido');
      await log(_hasuraBloc, appGlobalBloc,
        nomeArquivo: "shared_venda_bloc",
        nomeFuncao: "setTutorialVendaConcluido",
        error: error.toString(),
        stacktrace: stacktrace.toString()
      );
    }   
  }

  Future<bool> primeiraSincronizacaoFinalizada() async {
    try {
      ConfiguracaoGeral configuracaoGeral = ConfiguracaoGeral();
      ConfiguracaoGeralDAO configuracaoGeralDAO = ConfiguracaoGeralDAO(_hasuraBloc, configuracaoGeral, appGlobalBloc);
      List<ConfiguracaoGeral> configuracaoGeralList = await configuracaoGeralDAO.getAll();
      if(configuracaoGeralList.length > 0){
        return true;
      } else {
        return false;
      }
    } catch(error, stacktrace) {
      appGlobalBloc.logger.e(error.toString(), '<shared_venda_bloc> primeiraSincronizacaoFinalizada');
      await log(_hasuraBloc, appGlobalBloc,
        nomeArquivo: "shared_venda_bloc",
        nomeFuncao: "primeiraSincronizacaoFinalizada",
        error: error.toString(),
        stacktrace: stacktrace.toString()
      );
      return false;
    }   
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
    _servicoListViewController.close();
    _statusSincronizacaoHasuraController.close();
    _filterTextController.close();
    super.dispose();
  }
}
