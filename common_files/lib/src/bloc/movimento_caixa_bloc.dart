import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:common_files/common_files.dart';
import 'package:rxdart/rxdart.dart';

class MovimentoCaixaBloc extends BlocBase {
  HasuraBloc _hasuraBloc;
  AppGlobalBloc appGlobalBloc;
  MovimentoCaixa movimentoCaixa;
  MovimentoCaixaDAO _movimentoCaixaDAO;

  List<MovimentoCaixaTotalTipoPagamento> _movimentoCaixaTotalTipoPagamentoList = [];
  BehaviorSubject<List<MovimentoCaixaTotalTipoPagamento>> _movimentoCaixaTotalTipoPagamentoListController;
  Stream<List<MovimentoCaixaTotalTipoPagamento>> get movimentoCaixaTotalTipoPagamentoListOut => _movimentoCaixaTotalTipoPagamentoListController.stream;

  double _valorRetiradaDisponivel = 0;
  BehaviorSubject<double> _valorRetiradaDisponivelController;
  Stream<double> get valorRetiradaDisponivelOut => _valorRetiradaDisponivelController.stream;

  List<MovimentoCaixaSangria> _movimentoCaixaSangriaList = [];
  BehaviorSubject<List<MovimentoCaixaSangria>> _movimentoCaixaSangriaListController;
  Stream<List<MovimentoCaixaSangria>> get movimentoCaixaSangriaListOut => _movimentoCaixaSangriaListController.stream;

  BehaviorSubject<MovimentoCaixa> _movimentoCaixaController;
  Stream<MovimentoCaixa> get movimentoCaixaOut => _movimentoCaixaController.stream;

  TipoPagamento tipoPagamentoDinheiro;

  MovimentoCaixaBloc(this._hasuraBloc, this.appGlobalBloc) {
    movimentoCaixa = MovimentoCaixa();
     tipoPagamentoDinheiro = TipoPagamento();
    _movimentoCaixaDAO = MovimentoCaixaDAO(_hasuraBloc, movimentoCaixa, appGlobalBloc);
    _movimentoCaixaController = BehaviorSubject.seeded(movimentoCaixa);
    _valorRetiradaDisponivelController = BehaviorSubject.seeded(_valorRetiradaDisponivel);
    _movimentoCaixaSangriaListController = BehaviorSubject.seeded(_movimentoCaixaSangriaList);
    _movimentoCaixaTotalTipoPagamentoListController = BehaviorSubject.seeded(_movimentoCaixaTotalTipoPagamentoList);
    //getTipoPagamentoDinheiro();
  }  

  initMovimentoCaixa(){
    movimentoCaixa = MovimentoCaixa();
    _movimentoCaixaDAO = MovimentoCaixaDAO(_hasuraBloc, movimentoCaixa, appGlobalBloc);
    _movimentoCaixaSangriaList = List<MovimentoCaixaSangria>();
    _movimentoCaixaTotalTipoPagamentoList = List<MovimentoCaixaTotalTipoPagamento>();
    _valorRetiradaDisponivel = 0;
    _movimentoCaixaController.add(movimentoCaixa);
    _movimentoCaixaSangriaListController.add(_movimentoCaixaSangriaList);
    _movimentoCaixaTotalTipoPagamentoListController.add(_movimentoCaixaTotalTipoPagamentoList);
  }

  getTipoPagamentoDinheiro() async {
    TipoPagamentoDAO tipoPagamentoDAO = TipoPagamentoDAO(_hasuraBloc, appGlobalBloc, tipoPagamento: tipoPagamentoDinheiro);
    tipoPagamentoDAO.filterEhDinheiro = true;
    List<TipoPagamento> tipoPagamentoList = [];
    tipoPagamentoList = await tipoPagamentoDAO.getAll();
    tipoPagamentoDinheiro = tipoPagamentoList.first;
  }

  getMovimentoDia() async {
    MovimentoCaixa _movimentoCaixa = MovimentoCaixa();
    MovimentoCaixaDAO movimentoCaixaDAO = MovimentoCaixaDAO(_hasuraBloc, _movimentoCaixa, appGlobalBloc);
    movimentoCaixaDAO.filterDataAbertura = DateTime.now();
    movimentoCaixaDAO.loadMovimentoCaixaParcela = true;
    List<MovimentoCaixa> movimentoCaixaList = await movimentoCaixaDAO.getAll(preLoad: true);
    if(movimentoCaixaList.length > 0){
      _movimentoCaixa = movimentoCaixaList.first;
      Movimento _movimento = Movimento();
      MovimentoDAO _movimentoDao = MovimentoDAO(_hasuraBloc, appGlobalBloc, _movimento);
      List<MovimentoCaixaTotalTipoPagamento> movimentoCaixaTotalTipoPagamentoList = [];
      _movimentoDao.filterData = true;
      _movimentoDao.loadTransacao = true;
      _movimentoDao.loadMovimentoParcela = true;
      _movimentoDao.loadTipoPagamento = true;
      List<Movimento> _movimentoList = await _movimentoDao.getAll(preLoad: true);
      for (var i = 0; i < _movimentoList.length; i++) {
        if ((_movimentoList[i].transacao.temPagamento == 1) && (_movimentoList[i].transacao.tipoEstoque == 0)) {
          _movimentoCaixa.vendaTotalBoletoFechado = _movimentoList[i].ehcancelado == 0 ? _movimentoCaixa.vendaTotalBoletoFechado + 1 : _movimentoCaixa.vendaTotalBoletoFechado;
          _movimentoCaixa.vendaTotalValorBruto = _movimentoList[i].ehcancelado == 0 ? _movimentoCaixa.vendaTotalValorBruto += _movimentoList[i].valorTotalBruto : _movimentoCaixa.vendaTotalValorBruto;  
          _movimentoCaixa.vendaTotalItem = _movimentoList[i].ehcancelado == 0 ? _movimentoCaixa.vendaTotalItem += _movimentoList[i].totalItens : _movimentoCaixa.vendaTotalItem; 
          _movimentoCaixa.vendaTotalQuantidade = _movimentoList[i].ehcancelado == 0 ? _movimentoCaixa.vendaTotalQuantidade += _movimentoList[i].totalQuantidade: _movimentoCaixa.vendaTotalQuantidade; 
          _movimentoCaixa.vendaTotalValorDesconto = _movimentoList[i].ehcancelado == 0 ? _movimentoCaixa.vendaTotalValorDesconto += _movimentoList[i].valorTotalDesconto : _movimentoCaixa.vendaTotalValorDesconto; 
          _movimentoCaixa.vendaTotalValorDescontoItem = _movimentoList[i].ehcancelado == 0 ? _movimentoCaixa.vendaTotalValorDescontoItem += _movimentoList[i].valorTotalDescontoItemProduto : _movimentoCaixa.vendaTotalValorDescontoItem;
          _movimentoCaixa.vendaTotalValorLiquido = _movimentoList[i].ehcancelado == 0 ? _movimentoCaixa.vendaTotalValorLiquido += _movimentoList[i].valorTotalLiquido : _movimentoCaixa.vendaTotalValorLiquido;  
          _movimentoCaixa.vendaTotalBoletoCancelado = _movimentoList[i].ehcancelado == 1 ? _movimentoCaixa.vendaTotalBoletoCancelado + 1 : _movimentoCaixa.vendaTotalBoletoCancelado;
          _movimentoCaixa.vendaTotalQuantidadeCancelada = _movimentoList[i].ehcancelado == 1 ? _movimentoCaixa.vendaTotalQuantidadeCancelada += _movimentoList[i].totalQuantidade : _movimentoCaixa.vendaTotalQuantidadeCancelada;
          _movimentoCaixa.vendaTotalValorCancelado = _movimentoList[i].ehcancelado == 1 ? _movimentoCaixa.vendaTotalValorCancelado += _movimentoList[i].valorTotalBruto : _movimentoCaixa.vendaTotalValorCancelado;
          if (_movimentoList[i].ehcancelado == 0) {
            for (var y = 0; y < _movimentoList[i].movimentoParcela.length; y++) {
              var novo = movimentoCaixaTotalTipoPagamentoList.singleWhere(
                  (movCaixaTotalTipoPagamento) => (movCaixaTotalTipoPagamento.idTipoPagamento == _movimentoList[i].movimentoParcela[y].idTipoPagamento),
                  orElse: () => null);
              if (novo == null) {
                MovimentoCaixaTotalTipoPagamento novo = MovimentoCaixaTotalTipoPagamento();
                novo.idMovimentoCaixa = _movimentoCaixa.id;
                novo.idTipoPagamento = _movimentoList[i].movimentoParcela[y].idTipoPagamento;
                novo.vendaValorTotal = _movimentoList[i].movimentoParcela[y].valor;
                novo.tipoPagamento = _movimentoList[i].movimentoParcela[y].tipoPagamento;
                movimentoCaixaTotalTipoPagamentoList.add(novo);
              } else {
                novo.vendaValorTotal += _movimentoList[i].movimentoParcela[y].valor;
              }
            }
          }
        }
        //Devolução
        if ((_movimentoList[i].transacao.temPagamento == 1) && (_movimentoList[i].transacao.tipoEstoque == 1)) {
          _movimentoCaixa.devolucaoTotalBoletoFechado = _movimentoList[i].ehcancelado == 0 ? _movimentoCaixa.devolucaoTotalBoletoFechado + 1 : _movimentoCaixa.devolucaoTotalBoletoFechado;
          _movimentoCaixa.devolucaoTotalValorBruto = _movimentoList[i].ehcancelado == 0 ? _movimentoCaixa.devolucaoTotalValorBruto += _movimentoList[i].valorTotalBruto : _movimentoCaixa.devolucaoTotalValorBruto;  
          _movimentoCaixa.devolucaoTotalItem = _movimentoList[i].ehcancelado == 0 ? _movimentoCaixa.devolucaoTotalItem += _movimentoList[i].totalItens : _movimentoCaixa.devolucaoTotalItem; 
          _movimentoCaixa.devolucaoTotalQuantidade = _movimentoList[i].ehcancelado == 0 ? _movimentoCaixa.devolucaoTotalQuantidade += _movimentoList[i].totalQuantidade : _movimentoCaixa.devolucaoTotalQuantidade; 
          _movimentoCaixa.devolucaoTotalValorDesconto = _movimentoList[i].ehcancelado == 0 ? _movimentoCaixa.devolucaoTotalValorDesconto += _movimentoList[i].valorTotalDesconto : _movimentoCaixa.devolucaoTotalValorDesconto; 
          _movimentoCaixa.devolucaoTotalValorLiquido = _movimentoList[i].ehcancelado == 0 ? _movimentoCaixa.devolucaoTotalValorLiquido += _movimentoList[i].valorTotalLiquido : _movimentoCaixa.devolucaoTotalValorLiquido;  
          _movimentoCaixa.devolucaoTotalBoletoCancelado = _movimentoList[i].ehcancelado == 1 ? _movimentoCaixa.devolucaoTotalBoletoCancelado + 1 : _movimentoCaixa.devolucaoTotalBoletoCancelado;
          _movimentoCaixa.devolucaoTotalQuantidadeCancelada = _movimentoList[i].ehcancelado == 1 ? _movimentoCaixa.devolucaoTotalQuantidadeCancelada += _movimentoList[i].totalQuantidade : _movimentoCaixa.devolucaoTotalQuantidadeCancelada;
          _movimentoCaixa.devolucaoTotalValorCancelado = _movimentoList[i].ehcancelado == 1 ? _movimentoCaixa.devolucaoTotalValorCancelado += _movimentoList[i].valorTotalBruto : _movimentoCaixa.devolucaoTotalValorCancelado;
        }
        //Saida
        if ((_movimentoList[i].transacao.temPagamento == 0) && (_movimentoList[i].transacao.tipoEstoque == 0)) {
          _movimentoCaixa.saidaTotalBoletoFechado = _movimentoList[i].ehcancelado == 0 ? _movimentoCaixa.saidaTotalBoletoFechado + 1 : _movimentoCaixa.saidaTotalBoletoFechado;
          _movimentoCaixa.saidaTotalValorBruto = _movimentoList[i].ehcancelado == 0 ? _movimentoCaixa.saidaTotalValorBruto += _movimentoList[i].valorTotalBruto : _movimentoCaixa.saidaTotalValorBruto;  
          _movimentoCaixa.saidaTotalItem = _movimentoList[i].ehcancelado == 0 ? _movimentoCaixa.saidaTotalItem += _movimentoList[i].totalItens : _movimentoCaixa.saidaTotalItem; 
          _movimentoCaixa.saidaTotalQuantidade = _movimentoList[i].ehcancelado == 0 ? _movimentoCaixa.saidaTotalQuantidade += _movimentoList[i].totalQuantidade : _movimentoCaixa.saidaTotalQuantidade; 
          _movimentoCaixa.saidaTotalValorLiquido = _movimentoList[i].ehcancelado == 0 ? _movimentoCaixa.saidaTotalValorLiquido += _movimentoList[i].valorTotalLiquido : _movimentoCaixa.saidaTotalValorLiquido;  
          _movimentoCaixa.saidaTotalBoletoCancelado = _movimentoList[i].ehcancelado == 1 ? _movimentoCaixa.saidaTotalBoletoCancelado + 1 : _movimentoCaixa.saidaTotalBoletoCancelado;
          _movimentoCaixa.saidaTotalQuantidadeCancelada = _movimentoList[i].ehcancelado == 1 ? _movimentoCaixa.saidaTotalQuantidadeCancelada += _movimentoList[i].totalQuantidade : _movimentoCaixa.saidaTotalQuantidadeCancelada;
          _movimentoCaixa.saidaTotalValorCancelado = _movimentoList[i].ehcancelado == 1 ? _movimentoCaixa.saidaTotalValorCancelado += _movimentoList[i].valorTotalBruto : _movimentoCaixa.saidaTotalValorCancelado;
        }
        //Entrada
        if ((_movimentoList[i].transacao.temPagamento == 0) && (_movimentoList[i].transacao.tipoEstoque == 1)) {
          _movimentoCaixa.entradaTotalBoletoFechado = _movimentoList[i].ehcancelado == 0 ? _movimentoCaixa.entradaTotalBoletoFechado + 1 : _movimentoCaixa.entradaTotalBoletoFechado;
          _movimentoCaixa.entradaTotalValorBruto = _movimentoList[i].ehcancelado == 0 ? _movimentoCaixa.entradaTotalValorBruto += _movimentoList[i].valorTotalBruto : _movimentoCaixa.entradaTotalValorBruto;  
          _movimentoCaixa.entradaTotalItem = _movimentoList[i].ehcancelado == 0 ? _movimentoCaixa.entradaTotalItem += _movimentoList[i].totalItens : _movimentoCaixa.entradaTotalItem; 
          _movimentoCaixa.entradaTotalQuantidade = _movimentoList[i].ehcancelado == 0 ? _movimentoCaixa.entradaTotalQuantidade += _movimentoList[i].totalQuantidade : _movimentoCaixa.entradaTotalQuantidade; 
          _movimentoCaixa.entradaTotalValorLiquido = _movimentoList[i].ehcancelado == 0 ? _movimentoCaixa.entradaTotalValorLiquido += _movimentoList[i].valorTotalLiquido : _movimentoCaixa.entradaTotalValorLiquido;  
          _movimentoCaixa.entradaTotalBoletoCancelado = _movimentoList[i].ehcancelado == 1 ? _movimentoCaixa.entradaTotalBoletoCancelado + 1 : _movimentoCaixa.entradaTotalBoletoCancelado;
          _movimentoCaixa.entradaTotalQuantidadeCancelada = _movimentoList[i].ehcancelado == 1 ? _movimentoCaixa.entradaTotalQuantidadeCancelada += _movimentoList[i].totalQuantidade : _movimentoCaixa.entradaTotalQuantidadeCancelada;
          _movimentoCaixa.entradaTotalValorCancelado = _movimentoList[i].ehcancelado == 1 ? _movimentoCaixa.entradaTotalValorCancelado += _movimentoList[i].valorTotalBruto : _movimentoCaixa.entradaTotalValorCancelado;
        }
      }

      if (_movimentoCaixa.movimentoCaixaParcela.length > 0) {
        for (var z = 0; z < _movimentoCaixa.movimentoCaixaParcela.length; z++) {
          var novo = movimentoCaixaTotalTipoPagamentoList.singleWhere(
              (movCaixaTotalTipoPagamento) => (movCaixaTotalTipoPagamento.idTipoPagamento == _movimentoCaixa.movimentoCaixaParcela[z].idTipoPagamento),
              orElse: () => null);
          if (novo == null) {
            MovimentoCaixaTotalTipoPagamento novo = MovimentoCaixaTotalTipoPagamento();
            novo.idMovimentoCaixa = _movimentoCaixa.id;
            novo.idTipoPagamento = _movimentoCaixa.movimentoCaixaParcela[z].idTipoPagamento;
            novo.aberturaValorTotal = _movimentoCaixa.movimentoCaixaParcela[z].ehAbertura == 1 ? _movimentoCaixa.movimentoCaixaParcela[z].valor : novo.aberturaValorTotal;
            novo.reforcoValorTotal = _movimentoCaixa.movimentoCaixaParcela[z].ehReforco == 1 ? _movimentoCaixa.movimentoCaixaParcela[z].valor : novo.reforcoValorTotal;
            novo.retiradaValorTotal = _movimentoCaixa.movimentoCaixaParcela[z].ehRetirada == 1 ? _movimentoCaixa.movimentoCaixaParcela[z].valor : novo.retiradaValorTotal;
            novo.tipoPagamento = _movimentoCaixa.movimentoCaixaParcela[z].tipoPagamento;
            movimentoCaixaTotalTipoPagamentoList.add(novo);
          } else {
            novo.aberturaValorTotal = _movimentoCaixa.movimentoCaixaParcela[z].ehAbertura == 1 ? novo.aberturaValorTotal + _movimentoCaixa.movimentoCaixaParcela[z].valor : novo.aberturaValorTotal;
            novo.reforcoValorTotal = _movimentoCaixa.movimentoCaixaParcela[z].ehReforco == 1 ? novo.reforcoValorTotal + _movimentoCaixa.movimentoCaixaParcela[z].valor : novo.reforcoValorTotal;
            novo.retiradaValorTotal = _movimentoCaixa.movimentoCaixaParcela[z].ehRetirada == 1 ? novo.retiradaValorTotal + _movimentoCaixa.movimentoCaixaParcela[z].valor : novo.retiradaValorTotal;
          }
        }
      } 
    
      _movimentoCaixaTotalTipoPagamentoList = movimentoCaixaTotalTipoPagamentoList;
      _movimentoCaixaTotalTipoPagamentoListController.add(_movimentoCaixaTotalTipoPagamentoList);
      movimentoCaixa = _movimentoCaixa;
      _movimentoCaixaController.add(movimentoCaixa);
    }
  }

  getMovimentoDiaTipoPagamento() async {
    List<MovimentoCaixaTotalTipoPagamento> movimentoCaixaTotalTipoPagamentoList = [];
  }
  
  getMovimentoCaixa(DateTime date) async {
    MovimentoCaixa _movimentoCaixa = MovimentoCaixa();
    MovimentoCaixaDAO movimentoCaixaDAO = MovimentoCaixaDAO(_hasuraBloc, _movimentoCaixa, appGlobalBloc);
    movimentoCaixaDAO.filterDataAbertura = date;
    List<dynamic> movimentoCaixaList = await movimentoCaixaDAO.getAll();
    if(movimentoCaixaList.length > 0){
      movimentoCaixa = movimentoCaixaList.first;
    }
    _movimentoCaixaController.add(movimentoCaixa);
  }

  Future<bool> temCaixaAbertoAnterior() async {
    MovimentoCaixa _movimentoCaixa = MovimentoCaixa();
    MovimentoCaixaDAO movimentoCaixaDAO = MovimentoCaixaDAO(_hasuraBloc, _movimentoCaixa, appGlobalBloc);
    movimentoCaixaDAO.filterDataAbertura = DateTime.now().subtract(Duration(days: 1));
    movimentoCaixaDAO.filterDataFechamentoAsNull = true;
    List<dynamic> movimentoCaixaList = await movimentoCaixaDAO.getAll();
    _movimentoCaixa = movimentoCaixaList.length > 0 ? movimentoCaixaList.first : null;
    _movimentoCaixaController.add(_movimentoCaixa);
    return _movimentoCaixa != null;
  }

  doAberturaCaixa(double valorAbertura) async {
    MovimentoCaixa _movimentoCaixa = MovimentoCaixa();
    MovimentoCaixaDAO movimentoCaixaDAO = MovimentoCaixaDAO(_hasuraBloc, _movimentoCaixa, appGlobalBloc);
    _movimentoCaixa.dataAbertura = DateTime.now();
    _movimentoCaixa.valorAbertura = valorAbertura;
    movimentoCaixa = await movimentoCaixaDAO.insert();


    MovimentoCaixaParcela movimentoCaixaParcela = MovimentoCaixaParcela();
    MovimentoCaixaParcelaDAO movimentoCaixaParcelaDAO = MovimentoCaixaParcelaDAO(_hasuraBloc, movimentoCaixaParcela, appGlobalBloc);
    movimentoCaixaParcela.idAppMovimentoCaixa = movimentoCaixa.idApp;
    movimentoCaixaParcela.valor = valorAbertura;
    movimentoCaixaParcela.data = DateTime.now();
    movimentoCaixaParcela.ehAbertura = 1;
    movimentoCaixaParcela.descricao = "Valor de abertura";
    await getTipoPagamentoDinheiro();
    movimentoCaixaParcela.idTipoPagamento = tipoPagamentoDinheiro.id;
    movimentoCaixaParcela = await movimentoCaixaParcelaDAO.insert();

    _movimentoCaixaController.add(movimentoCaixa);
  }

  doFechamentoCaixa(MovimentoCaixa value) async {
    List<Map<dynamic, dynamic>> result = [];
    MovimentoCaixaDAO movimentoCaixaDAO = MovimentoCaixaDAO(_hasuraBloc, value, appGlobalBloc);
    
    result = await movimentoCaixaDAO.getVendaTotal(value.dataAbertura);
    value.vendaTotalValorBruto = result[0]["valor_total_bruto"] == null ? 0 : result[0]["valor_total_bruto"];
    value.vendaTotalValorDesconto = result[0]["valor_total_desconto"] == null ? 0 : result[0]["valor_total_desconto"];
    value.vendaTotalValorLiquido = result[0]["valor_total_liquido"] == null ? 0 : result[0]["valor_total_liquido"];
    value.vendaTotalValorCancelado = result[2]["valor_total_liquido"] == null ? 0 : result[2]["valor_total_liquido"];
    value.vendaTotalValorDescontoItem = result[0]["valor_total_desconto_item"] == null ? 0 : result[0]["valor_total_desconto_item"];
    value.vendaTotalQuantidade = result[0]["total_quantidade"] == null ? 0 : result[0]["total_quantidade"];
    value.vendaTotalQuantidadeCancelada = result[2]["total_quantidade"] == null ? 0 : result[2]["total_quantidade"];
    value.vendaTotalItem = result[0]["total_itens"] == null ? 0 : result[0]["total_itens"];
    value.vendaTotalBoletoFechado = result[0]["total_boleto"] == null ? 0 : result[0]["total_boleto"];
    value.vendaTotalBoletoPedido = result[1]["total_boleto"] == null ? 0 : result[1]["total_boleto"];
    value.vendaTotalBoletoCancelado = result[2]["total_boleto"] == null ? 0 : result[2]["total_boleto"];
    value.dataFechamento = DateTime.now();

    value = await movimentoCaixaDAO.insert();
    //await getMovimentoCaixa(DateTime.now());
  }

  getValorDisponivelRetirada() async {
    _valorRetiradaDisponivel = await getMovimentoCaixaParcelaDinheiro();
    _valorRetiradaDisponivel += await getMovimentoParcelaDinheiro();
    print("Valor disponivel pra retirada: " + _valorRetiradaDisponivel.toString());
    _valorRetiradaDisponivelController.add(_valorRetiradaDisponivel);
  }

  getValorDisponivelSangria() async {
    await getMovimentoParcelaToSangria();
    List<MovimentoCaixaSangria> movimentoCaixaSangriaList = await getMovimentoCaixaParcelaToSangria();
    if (movimentoCaixaSangriaList.length > 0) {
      for (var i = 0; i < movimentoCaixaSangriaList.length; i++) {
        var novo = _movimentoCaixaSangriaList.firstWhere(
            (mov) => ((mov.idTipoPagamento == movimentoCaixaSangriaList[i].idTipoPagamento)),
            orElse: () => null);

        if (novo != null) {
          novo.valor += movimentoCaixaSangriaList[i].valor;
        } else {
          _movimentoCaixaSangriaList.add(movimentoCaixaSangriaList[i]);
        }
      }  
    }
    //_movimentoCaixaSangriaList = movimentoCaixaSangriaList;
      /*for (var movimentoCaixaSangria in _movimentoCaixaSangriaList) {
        var novo = movimentoCaixaSangriaList.firstWhere(
            (mov) => ((mov.idTipoPagamento == movimentoCaixaSangria.idTipoPagamento)),
            orElse: () => null);
        if (novo != null) {
          movimentoCaixaSangria.valor += novo.valor;
        } else {
          MovimentoCaixaSangria movimentoCaixaSangria = MovimentoCaixaSangria(); 
          movimentoCaixaSangria.idTipoPagamento = 1;
          movimentoCaixaSangria.nomeTipoPagamento = "Dinheiro";
          movimentoCaixaSangria.valor = await getMovimentoCaixaParcelaDinheiro();
          _movimentoCaixaSangriaList.add(movimentoCaixaSangria);
        }
        // if (movimentoCaixaSangria.idTipoPagamento == 1) {
        //   movimentoCaixaSangria.valor += await getMovimentoCaixaParcelaDinheiro();
        // }
        print("Valor ${movimentoCaixaSangria.nomeTipoPagamento} pra retirada: " + movimentoCaixaSangria.valor.roundToDouble().toString());
      }
      } else {
        MovimentoCaixaSangria movimentoCaixaSangria = MovimentoCaixaSangria(); 
        movimentoCaixaSangria.idTipoPagamento = 1;
        movimentoCaixaSangria.nomeTipoPagamento = "Dinheiro";
        movimentoCaixaSangria.valor = await getMovimentoCaixaParcelaDinheiro();
        _movimentoCaixaSangriaList.add(movimentoCaixaSangria);
        print("Valor ${movimentoCaixaSangria.nomeTipoPagamento} pra retirada: " + movimentoCaixaSangria.valor.roundToDouble().toString());
      }*/
    _movimentoCaixaSangriaList.sort((a, b) => a.idTipoPagamento.compareTo(b.idTipoPagamento));
    for (var i = 0; i < _movimentoCaixaSangriaList.length; i++) {
      print("Valor ${_movimentoCaixaSangriaList[i].nomeTipoPagamento} pra retirada: " + _movimentoCaixaSangriaList[i].valor.toStringAsFixed(2));
    }  
  
    _movimentoCaixaSangriaListController.add(_movimentoCaixaSangriaList);
  }

  Future<double> getMovimentoCaixaParcelaDinheiro() async {
    MovimentoCaixa _movimentoCaixa = MovimentoCaixa();
    MovimentoCaixaDAO movimentoCaixaDAO = MovimentoCaixaDAO(_hasuraBloc, _movimentoCaixa, appGlobalBloc);
    List<Map<dynamic, dynamic>> result = [];
    String query = """
      --select m.valor_abertura as valor
      --from movimento_caixa m
      --where date(m.data_abertura) = '${ourDate(DateTime.now())}'

      --union 

      select sum(mp.valor) as valor
      from movimento_caixa_parcela mp
      inner join movimento_caixa mc on mc.id_app = mp.id_app_movimento_caixa
      where date(mc.data_abertura) = '${ourDate(DateTime.now())}'
      and mp.id_tipo_pagamento = 1
    """;
    result = await movimentoCaixaDAO.getRawQuery(query);
    double _valor = result[0]["valor"] != null ? result[0]["valor"] : 0;
    _valor += result.length > 1 ? result[1]["valor"] : 0;
    return _valor;
  }

  Future<double> getMovimentoParcelaDinheiro() async {
    Movimento movimento = Movimento();
    MovimentoDAO movimentoDAO = MovimentoDAO(_hasuraBloc, appGlobalBloc, movimento);
    List<Map<dynamic, dynamic>> result = [];
    String query = """
      select sum(mp.valor) as valor
      from movimento m
      inner join movimento_parcela mp on m.id_app = mp.id_movimento_app
      where date(m.data_movimento) = '${ourDate(DateTime.now())}'
      and (m.ehorcamento = 0) and (m.ehcancelado = 0)
      and (mp.id_tipo_pagamento = 1)      
    """;
    result = await movimentoDAO.getRawQuery(query);
    double _valor;
    _valor = result[0]["valor"] != null ? result[0]["valor"] : 0;
    return _valor;
  }

  Future<List<MovimentoCaixaSangria>> getMovimentoCaixaParcelaToSangria() async {
    Movimento movimento = Movimento();
    MovimentoDAO movimentoDAO = MovimentoDAO(_hasuraBloc, appGlobalBloc, movimento);
    List<Map<dynamic, dynamic>> result = [];
    List<MovimentoCaixaSangria> movimentoCaixaSangriaList = [];
    String query = """
      select sum(mp.valor) as valor, mp.id_tipo_pagamento, t.nome
      from movimento_caixa m
      inner join movimento_caixa_parcela mp on m.id_app = mp.id_app_movimento_caixa
      inner join tipo_pagamento t on t.id = mp.id_tipo_pagamento
      where date(m.data_abertura) = '${ourDate(DateTime.now())}'
      group by mp.id_tipo_pagamento, t.nome
      order by 2
    """;
    result = await movimentoDAO.getRawQuery(query);
    
    for (var i = 0; i < result.length; i++) {
      MovimentoCaixaSangria movimentoCaixaSangria = MovimentoCaixaSangria();
      movimentoCaixaSangria.idTipoPagamento = result[i]["id_tipo_pagamento"];
      movimentoCaixaSangria.nomeTipoPagamento = result[i]["nome"];
      movimentoCaixaSangria.valor = result[i]["valor"] != null ? result[i]["valor"] : 0;
      movimentoCaixaSangriaList.add(movimentoCaixaSangria);
      movimentoCaixaSangria = null;
    }
    return movimentoCaixaSangriaList;
  }

  getMovimentoParcelaToSangria() async {
    Movimento movimento = Movimento();
    MovimentoDAO movimentoDAO = MovimentoDAO(_hasuraBloc, appGlobalBloc, movimento);
    List<Map<dynamic, dynamic>> result = [];
    _movimentoCaixaSangriaList = [];
    String query = """
      select sum(mp.valor) as valor, mp.id_tipo_pagamento, t.nome
      from movimento m
      inner join movimento_parcela mp on m.id_app = mp.id_movimento_app
      inner join tipo_pagamento t on t.id = mp.id_tipo_pagamento
      where date(m.data_movimento) = '${ourDate(DateTime.now())}'
      and (m.ehorcamento = 0) and (m.ehcancelado = 0)
      group by mp.id_tipo_pagamento, t.nome
      order by 2
    """;
    result = await movimentoDAO.getRawQuery(query);
    
    for (var i = 0; i < result.length; i++) {
      MovimentoCaixaSangria movimentoCaixaSangria = MovimentoCaixaSangria();
      movimentoCaixaSangria.idTipoPagamento = result[i]["id_tipo_pagamento"];
      movimentoCaixaSangria.nomeTipoPagamento = result[i]["nome"];
      movimentoCaixaSangria.valor = result[i]["valor"] != null ? result[i]["valor"] : 0;
      _movimentoCaixaSangriaList.add(movimentoCaixaSangria);
      movimentoCaixaSangria = null;
    }
  }

  doReforcoMovimentoCaixa(double valor) async {
    MovimentoCaixaParcela movimentoCaixaParcela = MovimentoCaixaParcela();
    MovimentoCaixaParcelaDAO movimentoCaixaParcelaDAO = MovimentoCaixaParcelaDAO(_hasuraBloc, movimentoCaixaParcela, appGlobalBloc);
    movimentoCaixaParcela.idAppMovimentoCaixa = movimentoCaixa.idApp;
    await getTipoPagamentoDinheiro();
    movimentoCaixaParcela.idTipoPagamento = tipoPagamentoDinheiro.id;
    movimentoCaixaParcela.ehReforco = 1;
    movimentoCaixaParcela.ehRetirada = 0;
    movimentoCaixaParcela.ehAbertura = 0;
    movimentoCaixaParcela.data = DateTime.now();
    movimentoCaixaParcela.descricao = "Reforço";
    movimentoCaixaParcela.valor = valor;
    movimentoCaixaParcela = await movimentoCaixaParcelaDAO.insert();
  }

  doRetiradaMovimentoCaixa(double valor) async {
    MovimentoCaixaParcela movimentoCaixaParcela = MovimentoCaixaParcela();
    MovimentoCaixaParcelaDAO movimentoCaixaParcelaDAO = MovimentoCaixaParcelaDAO(_hasuraBloc, movimentoCaixaParcela, appGlobalBloc);
    movimentoCaixaParcela.idAppMovimentoCaixa = movimentoCaixa.idApp;
    await getTipoPagamentoDinheiro();
    movimentoCaixaParcela.idTipoPagamento = tipoPagamentoDinheiro.id;
    movimentoCaixaParcela.ehReforco = 0;
    movimentoCaixaParcela.ehRetirada = 1;
    movimentoCaixaParcela.ehAbertura = 0;
    movimentoCaixaParcela.data = DateTime.now();
    movimentoCaixaParcela.descricao = "Retirada";
    movimentoCaixaParcela.valor = valor * -1;
    movimentoCaixaParcela = await movimentoCaixaParcelaDAO.insert();
  }


  doSangriaMovimentoCaixa() async {
    for (var i = 0; i < _movimentoCaixaSangriaList.length; i++) {
      MovimentoCaixaParcela movimentoCaixaParcela = MovimentoCaixaParcela();
      MovimentoCaixaParcelaDAO movimentoCaixaParcelaDAO = MovimentoCaixaParcelaDAO(_hasuraBloc, movimentoCaixaParcela, appGlobalBloc);
      movimentoCaixaParcela.idAppMovimentoCaixa = movimentoCaixa.idApp;
      movimentoCaixaParcela.idTipoPagamento = _movimentoCaixaSangriaList[i].idTipoPagamento;
      movimentoCaixaParcela.data = DateTime.now();
      movimentoCaixaParcela.descricao = "Sangria";
      movimentoCaixaParcela.valor =  _movimentoCaixaSangriaList[i].idTipoPagamento == 1 ? 
        (_movimentoCaixaSangriaList[i].valor - 10) * -1 : _movimentoCaixaSangriaList[i].valor * -1;
      movimentoCaixaParcela = await movimentoCaixaParcelaDAO.insert();
      movimentoCaixaParcela = null;
      movimentoCaixaParcelaDAO = null;
    }  
  }

  deleteAll() async{
    _movimentoCaixaDAO.delete(0);
    MovimentoCaixaParcela movimentoCaixaParcela = MovimentoCaixaParcela();
    MovimentoCaixaParcelaDAO movimentoCaixaParcelaDAO = MovimentoCaixaParcelaDAO(_hasuraBloc, movimentoCaixaParcela, appGlobalBloc);
    movimentoCaixaParcelaDAO.delete(0);
  }

  @override
  void dispose() {
    _movimentoCaixaController.close();
    _valorRetiradaDisponivelController.close();
    _movimentoCaixaSangriaListController.close();
    _movimentoCaixaTotalTipoPagamentoListController.close();
    super.dispose();
  }
}