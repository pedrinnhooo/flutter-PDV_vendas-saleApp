import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:common_files/common_files.dart';
import 'package:common_files/src/model/entities/util/periodo_relatorio.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:date_range_picker/date_range_picker.dart' as DateRagePicker;

class DashboardBloc extends BlocBase {
  HasuraBloc _hasuraBloc;
  AppGlobalBloc appGlobalBloc;

  RelatorioCardVendaTotal _relatorioCardVendaTotal;
  BehaviorSubject<RelatorioCardVendaTotal> _relatorioCardVendaTotalController;
  Stream<RelatorioCardVendaTotal> get relatorioCardVendaTotalControllerOut => _relatorioCardVendaTotalController.stream;

  RelatorioCardLucroTotal _relatorioCardLucroTotal;
  BehaviorSubject<RelatorioCardLucroTotal> _relatorioCardLucroTotalController;
  Stream<RelatorioCardLucroTotal> get relatorioCardLucroTotalControllerOut => _relatorioCardLucroTotalController.stream;

  double totalTipoPagamento=0;
  List<RelatorioCardTipoPagamento> _relatorioCardTipoPagamentoList;
  BehaviorSubject<List<RelatorioCardTipoPagamento>> _relatorioCardTipoPagamentoListController;
  Stream<List<RelatorioCardTipoPagamento>> get relatorioCardTipoPagamentoListControllerOut => _relatorioCardTipoPagamentoListController.stream;

  List<RelatorioCardTopProduto> _relatorioCardTopProdutoList;
  BehaviorSubject<List<RelatorioCardTopProduto>> _relatorioCardTopProdutoListController;
  Stream<List<RelatorioCardTopProduto>> get relatorioCardTopProdutoListControllerOut => _relatorioCardTopProdutoListController.stream;

  List<RelatorioCardTopCategoria> _relatorioCardTopCategoriaList;
  BehaviorSubject<List<RelatorioCardTopCategoria>> _relatorioCardTopCategoriaListController;
  Stream<List<RelatorioCardTopCategoria>> get relatorioCardTopCategoriaListControllerOut => _relatorioCardTopCategoriaListController.stream;

  List<RelatorioCardVendaGrafico> _relatorioCardVendaGraficoList = [];
  List<RelatorioCardVendaGrafico> _relatorioCardVendaGraficoAnteriorList = [];
  BehaviorSubject<List<RelatorioCardVendaGrafico>> _relatorioCardVendaGraficoListController;
  Stream<List<RelatorioCardVendaGrafico>> get relatorioCardVendaGraficoListControllerOut => _relatorioCardVendaGraficoListController.stream;

  String _relatorioCardVendaGraficoLabel;
  String _relatorioCardVendaGraficoValue;
  List<String> _relatorioCardVendaGraficoData;
  List<String> _relatorioCardVendaGraficoAnteriorData;
  BehaviorSubject<List<String>> _relatorioCardVendaGraficoDataController;
  Stream<List<String>> get relatorioCardVendaGraficoDataControllerOut => _relatorioCardVendaGraficoDataController.stream;
  BehaviorSubject<List<String>> _relatorioCardVendaGraficoAnteriorDataController;
  Stream<List<String>> get relatorioCardVendaGraficoAnteriorDataControllerOut => _relatorioCardVendaGraficoAnteriorDataController.stream;

  List<PeriodoRelatorioItem> periodoList = <PeriodoRelatorioItem>[
    PeriodoRelatorioItem("Hoje", Icon(Icons.today, color: Colors.white, size: 20,), PeriodoRelatorio.hoje),
    PeriodoRelatorioItem("Ontem", Icon(Icons.event, color: Colors.white, size: 20,), PeriodoRelatorio.ontem),
    PeriodoRelatorioItem("Semana atual", Icon(Icons.calendar_today, color: Colors.white, size: 20,), PeriodoRelatorio.semana_atual),
    PeriodoRelatorioItem("Semana anterior", Icon(Icons.calendar_today, color: Colors.white, size: 20,), PeriodoRelatorio.semana_anterior),
    PeriodoRelatorioItem("Mês atual", Icon(Icons.calendar_view_day, color: Colors.white, size: 20,), PeriodoRelatorio.mes_atual),
    PeriodoRelatorioItem("Mês anterior", Icon(Icons.calendar_view_day, color: Colors.white, size: 20,), PeriodoRelatorio.mes_anterior),
    PeriodoRelatorioItem("Ano atual", Icon(Icons.calendar_view_day, color: Colors.white, size: 20,), PeriodoRelatorio.ano_atual),
    PeriodoRelatorioItem("Ano anterior", Icon(Icons.calendar_view_day, color: Colors.white, size: 20,), PeriodoRelatorio.ano_anterior),
    PeriodoRelatorioItem("Selecionar", Icon(Icons.date_range, color: Colors.white, size: 20,), PeriodoRelatorio.selecione),
  ];

  PeriodoRelatorioItem periodoRelatorioSelecionado;
  BehaviorSubject<PeriodoRelatorioItem> _periodoRelatorioSelecionadoController;
  Stream<PeriodoRelatorioItem> get periodoRelatorioSelecionadoControllerOut => _periodoRelatorioSelecionadoController.stream;

  DateTime dataInicial;
  DateTime dataFinal;
  DateTime dataInicialAnterior;
  DateTime dataFinalAnterior;
  BehaviorSubject<DateTime> _dataInicialController;
  Stream<DateTime> get dataInicialControllerOut => _dataInicialController.stream;
  BehaviorSubject<DateTime> _dataFinalController;
  Stream<DateTime> get dataFinalControllerOut => _dataFinalController.stream;

  DashboardBloc(this._hasuraBloc, this.appGlobalBloc) {
    _relatorioCardVendaTotal = RelatorioCardVendaTotal();
    _relatorioCardLucroTotal = RelatorioCardLucroTotal();
    _relatorioCardTipoPagamentoList = [];
    _relatorioCardTopProdutoList = [];
    _relatorioCardTopCategoriaList = [];
    _relatorioCardVendaGraficoLabel;
    _relatorioCardVendaGraficoValue;
    _relatorioCardVendaGraficoData = [];
    periodoRelatorioSelecionado = periodoList[0];
    _relatorioCardVendaTotalController = BehaviorSubject.seeded(_relatorioCardVendaTotal);
    _relatorioCardLucroTotalController = BehaviorSubject.seeded(_relatorioCardLucroTotal);
    _relatorioCardTipoPagamentoListController = BehaviorSubject.seeded(_relatorioCardTipoPagamentoList);
    _relatorioCardTopProdutoListController = BehaviorSubject.seeded(_relatorioCardTopProdutoList);
    _relatorioCardTopCategoriaListController = BehaviorSubject.seeded(_relatorioCardTopCategoriaList);
    _relatorioCardVendaGraficoListController = BehaviorSubject.seeded(_relatorioCardVendaGraficoList);
    _relatorioCardVendaGraficoDataController = BehaviorSubject.seeded(_relatorioCardVendaGraficoData);
    _relatorioCardVendaGraficoAnteriorDataController = BehaviorSubject.seeded(_relatorioCardVendaGraficoAnteriorData);
    _periodoRelatorioSelecionadoController = BehaviorSubject.seeded(periodoRelatorioSelecionado);
    _dataInicialController = BehaviorSubject.seeded(dataInicial);
    _dataFinalController = BehaviorSubject.seeded(dataFinal);
    setPeriodoRelatorio(periodoRelatorioSelecionado);
  }

  getRelatorioData() async {
    await getRelatorioCardVendaTotal();
    await getRelatorioCardLucroTotal();
    await getRelatorioCardTipoPagamento();
    await getRelatorioCardTopProduto();
    await getRelatorioCardTopCategoria();
    await getRelatorioCardVendaGrafico();    
  }

  getRelatorioCardVendaTotal() async {
    RelatorioCardVendaTotalDAO _relatorioCardVendaTotalDAO = RelatorioCardVendaTotalDAO(_hasuraBloc);
    _relatorioCardVendaTotal = await _relatorioCardVendaTotalDAO.getReportFromServer(dataInicial: dataInicial, dataFinal: dataFinal);
    _relatorioCardVendaTotalController.add(_relatorioCardVendaTotal);
  }

  getRelatorioCardLucroTotal() async {
    RelatorioCardLucroTotalDAO _relatorioCardLucroTotalDAO = RelatorioCardLucroTotalDAO(_hasuraBloc);
    _relatorioCardLucroTotal = await _relatorioCardLucroTotalDAO.getReportFromServer(dataInicial: dataInicial, dataFinal: dataFinal);
    _relatorioCardLucroTotalController.add(_relatorioCardLucroTotal);
  }

  getRelatorioCardTipoPagamento() async {
    RelatorioCardTipoPagamentoDAO _relatorioCardTipoPagamentoDAO = RelatorioCardTipoPagamentoDAO(_hasuraBloc);
    _relatorioCardTipoPagamentoList = await _relatorioCardTipoPagamentoDAO.getReportFromServer(dataInicial: dataInicial, dataFinal: dataFinal);
    _relatorioCardTipoPagamentoList.forEach((f) => totalTipoPagamento+= f.valor);
    _relatorioCardTipoPagamentoListController.add(_relatorioCardTipoPagamentoList);
  }

  getRelatorioCardTopProduto() async {
    RelatorioCardTopProdutoDAO _relatorioCardTopProdutoDAO = RelatorioCardTopProdutoDAO(_hasuraBloc);
    _relatorioCardTopProdutoList = await _relatorioCardTopProdutoDAO.getReportFromServer(dataInicial: dataInicial, dataFinal: dataFinal);
    _relatorioCardTopProdutoListController.add(_relatorioCardTopProdutoList);
  }

  getRelatorioCardTopCategoria() async {
    RelatorioCardTopCategoriaDAO _relatorioCardTopCategoriaDAO = RelatorioCardTopCategoriaDAO(_hasuraBloc);
    _relatorioCardTopCategoriaList = await _relatorioCardTopCategoriaDAO.getReportFromServer(dataInicial: dataInicial, dataFinal: dataFinal);
    _relatorioCardTopCategoriaListController.add(_relatorioCardTopCategoriaList);
  }

  getRelatorioCardVendaGrafico() async {
    RelatorioCardVendaGraficoDAO _relatorioCardVendaGraficoDAO = RelatorioCardVendaGraficoDAO(_hasuraBloc);
    _relatorioCardVendaGraficoList = await _relatorioCardVendaGraficoDAO.getReportFromServer(tipoRelatorio: getTipoRelatorioStr(), dataInicial: dataInicial, dataFinal: dataFinal);
    _relatorioCardVendaGraficoListController.add(_relatorioCardVendaGraficoList);

   _relatorioCardVendaGraficoAnteriorList = await _relatorioCardVendaGraficoDAO.getReportFromServer(tipoRelatorio: getTipoRelatorioStr(), dataInicial: dataInicialAnterior, dataFinal: dataFinalAnterior);

    switch (periodoRelatorioSelecionado.periodoRelatorio) {
      case PeriodoRelatorio.hoje:
      case PeriodoRelatorio.ontem: {
        await getRelatorioCardVendaGraficoDia(_relatorioCardVendaGraficoList, false);
        await getRelatorioCardVendaGraficoDia(_relatorioCardVendaGraficoAnteriorList, true);
      }
        break;
      case PeriodoRelatorio.semana_atual: 
      case PeriodoRelatorio.semana_anterior: {
        await getRelatorioCardVendaGraficoSemana(_relatorioCardVendaGraficoList, false);
        await getRelatorioCardVendaGraficoSemana(_relatorioCardVendaGraficoAnteriorList, true);
      }
        break;
      case PeriodoRelatorio.mes_atual: 
      case PeriodoRelatorio.mes_anterior: {
        await getRelatorioCardVendaGraficoMes(_relatorioCardVendaGraficoList, false);
        await getRelatorioCardVendaGraficoMes(_relatorioCardVendaGraficoAnteriorList, true);
      }
        break;
      case PeriodoRelatorio.ano_atual: 
      case PeriodoRelatorio.ano_anterior: {
        await getRelatorioCardVendaGraficoAno(_relatorioCardVendaGraficoList, false);
        await getRelatorioCardVendaGraficoAno(_relatorioCardVendaGraficoAnteriorList, true);
      }
        break;
      case PeriodoRelatorio.selecione: {
        var diff = dataFinal.difference(dataInicial);
        if (diff.inDays == 0) {
          await getRelatorioCardVendaGraficoDia(_relatorioCardVendaGraficoList, false);
        } else {
          if (dataInicial.month == dataFinal.month) {
            await getRelatorioCardVendaGraficoMes(_relatorioCardVendaGraficoList, false);  
          } else {
            await getRelatorioCardVendaGraficoAno(_relatorioCardVendaGraficoList, false);
          }
        } 
      }
        break;
      default:
    }
  }

  getRelatorioCardVendaGraficoDia(List<RelatorioCardVendaGrafico> value, bool ehPeriodoAnterior) async {
    _relatorioCardVendaGraficoLabel="";
    _relatorioCardVendaGraficoValue="";
    _relatorioCardVendaGraficoAnteriorData = [];
    for (var i = 0; i < value.length; i++) {
      if (i == 0) {
        _relatorioCardVendaGraficoLabel = quotedString(value[i].label);
        _relatorioCardVendaGraficoValue = value[i].valor.toStringAsFixed(2);
      } else {
        int y = value[i-1].indice+1;
        while (y < value[i].indice) {
          _relatorioCardVendaGraficoLabel += ",'${y.toString()}H'";
          _relatorioCardVendaGraficoValue += ",0";
          y++;
        } 
        _relatorioCardVendaGraficoLabel += ",'${value[i].label.toString()}'";
        _relatorioCardVendaGraficoValue += ",${value[i].valor.toStringAsFixed(2)}";
      }
    }
    if (!ehPeriodoAnterior) {
      _relatorioCardVendaGraficoData = [];
      _relatorioCardVendaGraficoData.add(_relatorioCardVendaGraficoLabel);
      _relatorioCardVendaGraficoData.add(_relatorioCardVendaGraficoValue);
      _relatorioCardVendaGraficoDataController.add(_relatorioCardVendaGraficoData);
    } else {
      _relatorioCardVendaGraficoAnteriorData.add(_relatorioCardVendaGraficoLabel);
      _relatorioCardVendaGraficoAnteriorData.add(_relatorioCardVendaGraficoValue);
      _relatorioCardVendaGraficoAnteriorDataController.add(_relatorioCardVendaGraficoAnteriorData);
    }  
    if (periodoRelatorioSelecionado.periodoRelatorio == PeriodoRelatorio.selecione) {
      _relatorioCardVendaGraficoAnteriorDataController.add(_relatorioCardVendaGraficoAnteriorData);
    }
    print("_relatorioCardVendaGraficoData: $_relatorioCardVendaGraficoData");
    print("_relatorioCardVendaGraficoAnteriorData: $_relatorioCardVendaGraficoAnteriorData");
  }

  getRelatorioCardVendaGraficoSemana(List<RelatorioCardVendaGrafico> value, bool ehPeriodoAnterior) async {
    _relatorioCardVendaGraficoLabel="";
    _relatorioCardVendaGraficoValue="";
    _relatorioCardVendaGraficoAnteriorData = [];
    double domingoValue;
    for (var i = 0; i < 7; i++) {
      var relatorioCardVendaGrafico = value.firstWhere(
        (test) => (i == test.indice),
        orElse: () => null);
      if (i == 0) {
        domingoValue = relatorioCardVendaGrafico != null ? relatorioCardVendaGrafico.valor : 0;  
      }
      _relatorioCardVendaGraficoLabel = relatorioCardVendaGrafico != null ? 
        _relatorioCardVendaGraficoLabel == "" ? i == 0 ? "" : quotedString(relatorioCardVendaGrafico.label) : i == 0 ? "" : _relatorioCardVendaGraficoLabel + "," + quotedString(relatorioCardVendaGrafico.label) :
        _relatorioCardVendaGraficoLabel == "" ? i == 0 ? "" : quotedString(await getWeekDayFromIndex(i)) : i == 0 ? "" : _relatorioCardVendaGraficoLabel +"," + quotedString(await getWeekDayFromIndex(i));
      _relatorioCardVendaGraficoValue = relatorioCardVendaGrafico != null ? 
        _relatorioCardVendaGraficoValue == "" ? i == 0 ? "" : relatorioCardVendaGrafico.valor.toStringAsFixed(2) : i == 0 ? "" : _relatorioCardVendaGraficoValue + "," + relatorioCardVendaGrafico.valor.toStringAsFixed(2) :
        _relatorioCardVendaGraficoValue == "" ? i == 0 ? "" : "0" : i == 0 ? "" : _relatorioCardVendaGraficoValue +",0";

      if (i == 6) {
        _relatorioCardVendaGraficoLabel = _relatorioCardVendaGraficoLabel == "" ? quotedString(await getWeekDayFromIndex(0)) : _relatorioCardVendaGraficoLabel + "," + quotedString(await getWeekDayFromIndex(0));
        _relatorioCardVendaGraficoValue = _relatorioCardVendaGraficoValue == "" ? domingoValue.toString() : _relatorioCardVendaGraficoValue + "," + domingoValue.toString();
      }
    }
    if (!ehPeriodoAnterior) {
      _relatorioCardVendaGraficoData = [];
      _relatorioCardVendaGraficoData.add(_relatorioCardVendaGraficoLabel);
      _relatorioCardVendaGraficoData.add(_relatorioCardVendaGraficoValue);
      _relatorioCardVendaGraficoDataController.add(_relatorioCardVendaGraficoData);
    } else {
      _relatorioCardVendaGraficoAnteriorData.add(_relatorioCardVendaGraficoLabel);
      _relatorioCardVendaGraficoAnteriorData.add(_relatorioCardVendaGraficoValue);
      _relatorioCardVendaGraficoAnteriorDataController.add(_relatorioCardVendaGraficoAnteriorData);
    }  
    if (periodoRelatorioSelecionado.periodoRelatorio == PeriodoRelatorio.selecione) {
      _relatorioCardVendaGraficoAnteriorDataController.add(_relatorioCardVendaGraficoAnteriorData);
    }
    print("_relatorioCardVendaGraficoData: $_relatorioCardVendaGraficoData");
    print("_relatorioCardVendaGraficoAnteriorData: $_relatorioCardVendaGraficoAnteriorData");
  }

  getRelatorioCardVendaGraficoMes(List<RelatorioCardVendaGrafico> value, bool ehPeriodoAnterior) async {
    _relatorioCardVendaGraficoLabel="";
    _relatorioCardVendaGraficoValue="";
    _relatorioCardVendaGraficoAnteriorData = [];
    DateTime _dataFinal = ehPeriodoAnterior ? dataFinalAnterior : dataFinal;
    for (var i = 1; i <= DateTime(_dataFinal.year,_dataFinal.month+1,0).day ; i++) {
      var relatorioCardVendaGrafico = value.firstWhere(
        (test) => (i == test.indice),
        orElse: () => null);
      _relatorioCardVendaGraficoLabel = relatorioCardVendaGrafico != null ? 
        _relatorioCardVendaGraficoLabel == "" ? quotedString(relatorioCardVendaGrafico.label) : _relatorioCardVendaGraficoLabel + "," + quotedString(relatorioCardVendaGrafico.label) :
        _relatorioCardVendaGraficoLabel == "" ? quotedString(i.toString()) : _relatorioCardVendaGraficoLabel +"," + quotedString(i.toString());
      _relatorioCardVendaGraficoValue = relatorioCardVendaGrafico != null ? 
        _relatorioCardVendaGraficoValue == "" ? relatorioCardVendaGrafico.valor.toStringAsFixed(2) : _relatorioCardVendaGraficoValue + "," + relatorioCardVendaGrafico.valor.toStringAsFixed(2) :
        _relatorioCardVendaGraficoValue == "" ? "0" : _relatorioCardVendaGraficoValue +",0";
    }
    if (!ehPeriodoAnterior) {
      _relatorioCardVendaGraficoData = [];
      _relatorioCardVendaGraficoData.add(_relatorioCardVendaGraficoLabel);
      _relatorioCardVendaGraficoData.add(_relatorioCardVendaGraficoValue);
      _relatorioCardVendaGraficoDataController.add(_relatorioCardVendaGraficoData);
    } else {
      _relatorioCardVendaGraficoAnteriorData.add(_relatorioCardVendaGraficoLabel);
      _relatorioCardVendaGraficoAnteriorData.add(_relatorioCardVendaGraficoValue);
      _relatorioCardVendaGraficoAnteriorDataController.add(_relatorioCardVendaGraficoAnteriorData);
    }  
    if (periodoRelatorioSelecionado.periodoRelatorio == PeriodoRelatorio.selecione) {
      _relatorioCardVendaGraficoAnteriorDataController.add(_relatorioCardVendaGraficoAnteriorData);
    }
    print("_relatorioCardVendaGraficoData: $_relatorioCardVendaGraficoData");
    print("_relatorioCardVendaGraficoAnteriorData: $_relatorioCardVendaGraficoAnteriorData");
  }

  getRelatorioCardVendaGraficoAno(List<RelatorioCardVendaGrafico> value, bool ehPeriodoAnterior) async {
    _relatorioCardVendaGraficoLabel="";
    _relatorioCardVendaGraficoValue="";
    _relatorioCardVendaGraficoAnteriorData = [];
    int lasMonth = periodoRelatorioSelecionado.periodoRelatorio == PeriodoRelatorio.selecione ?
      dataFinal.month : 12;
    for (var i = 1; i <= lasMonth; i++) {
      var relatorioCardVendaGrafico = value.firstWhere(
        (test) => (i == test.indice),
        orElse: () => null);
      _relatorioCardVendaGraficoLabel = relatorioCardVendaGrafico != null ? 
        _relatorioCardVendaGraficoLabel == "" ? quotedString(relatorioCardVendaGrafico.label) : _relatorioCardVendaGraficoLabel + "," + quotedString(relatorioCardVendaGrafico.label) :
        _relatorioCardVendaGraficoLabel == "" ? quotedString(await getMonthFromIndex(i)) : _relatorioCardVendaGraficoLabel +"," + quotedString(await getMonthFromIndex(i));
      _relatorioCardVendaGraficoValue = relatorioCardVendaGrafico != null ? 
        _relatorioCardVendaGraficoValue == "" ? relatorioCardVendaGrafico.valor.toStringAsFixed(2) : _relatorioCardVendaGraficoValue + "," + relatorioCardVendaGrafico.valor.toStringAsFixed(2) :
        _relatorioCardVendaGraficoValue == "" ? "0" : _relatorioCardVendaGraficoValue +",0";
    }
    if (!ehPeriodoAnterior) {
      _relatorioCardVendaGraficoData = [];
      _relatorioCardVendaGraficoData.add(_relatorioCardVendaGraficoLabel);
      _relatorioCardVendaGraficoData.add(_relatorioCardVendaGraficoValue);
      _relatorioCardVendaGraficoDataController.add(_relatorioCardVendaGraficoData);
    } else {
      _relatorioCardVendaGraficoAnteriorData.add(_relatorioCardVendaGraficoLabel);
      _relatorioCardVendaGraficoAnteriorData.add(_relatorioCardVendaGraficoValue);
      _relatorioCardVendaGraficoAnteriorDataController.add(_relatorioCardVendaGraficoAnteriorData);
    }
    if (periodoRelatorioSelecionado.periodoRelatorio == PeriodoRelatorio.selecione) {
      _relatorioCardVendaGraficoAnteriorDataController.add(_relatorioCardVendaGraficoAnteriorData);
    }
    print("_relatorioCardVendaGraficoData: $_relatorioCardVendaGraficoData");
    print("_relatorioCardVendaGraficoAnteriorData: $_relatorioCardVendaGraficoAnteriorData");
  }

  setPeriodoRelatorio(PeriodoRelatorioItem value, {BuildContext context}) async {
    periodoRelatorioSelecionado = value;
    switch (periodoRelatorioSelecionado.periodoRelatorio) {
      case PeriodoRelatorio.hoje: {
          dataInicial = DateTime.now();
          dataFinal = DateTime.now();
          dataInicialAnterior = DateTime.now().subtract(Duration(days: 1));
          dataFinalAnterior = DateTime.now().subtract(Duration(days: 1));
        }
        break;
      case PeriodoRelatorio.ontem: {
          dataInicial = DateTime.now().subtract(Duration(days: 1));
          dataFinal = DateTime.now().subtract(Duration(days: 1));
          dataInicialAnterior = dataInicial.subtract(Duration(days: 1));
          dataFinalAnterior = dataFinal.subtract(Duration(days: 1));
        }
        break;
      case PeriodoRelatorio.semana_atual: {
          dataInicial = DateTime.now().subtract(Duration(days: DateTime.now().weekday - 1));
          dataFinal = DateTime.now().add(Duration(days: 7 - DateTime.now().weekday));
          dataInicialAnterior = dataInicial.subtract(Duration(days: 7));
          dataFinalAnterior = dataFinal.subtract(Duration(days: 7));
        }  
        break;
      case PeriodoRelatorio.semana_anterior: {
          int _decrement = DateTime.now().weekday - 1;
          int _increment = 7 - DateTime.now().weekday;
          dataInicial = DateTime.now().subtract(Duration(days: _decrement + 7));
          dataFinal = DateTime.now().add(Duration(days: _increment - 7));
          dataInicialAnterior = dataInicial.subtract(Duration(days: 7));
          dataFinalAnterior = dataFinal.subtract(Duration(days: 7));
        }
        break;
      case PeriodoRelatorio.mes_atual: {
          dataInicial = DateTime(DateTime.now().year, DateTime.now().month, 1);
          dataFinal = DateTime(DateTime.now().year, DateTime.now().month + 1, 0);
          dataInicialAnterior = DateTime(dataInicial.year, DateTime.now().month - 1, dataInicial.day);
          dataFinalAnterior = DateTime(dataFinal.year, dataFinal.month, 0);
        }
        break;
      case PeriodoRelatorio.mes_anterior: {
          if (DateTime.now().month == 1) {
            dataInicial = DateTime(DateTime.now().year - 1, DateTime.now().month - 1, 1);
            dataFinal = DateTime(DateTime.now().year - 1, DateTime.now().month, 0);
            dataInicialAnterior = DateTime(dataInicial.year, DateTime.now().month - 1, dataInicial.day);
            dataFinalAnterior = DateTime(dataFinal.year, dataFinal.month, 0);
          } else {
            dataInicial = DateTime(DateTime.now().year, DateTime.now().month - 1, 1);
            dataFinal = DateTime(DateTime.now().year, DateTime.now().month, 0);
            if (dataInicial.month == 1) {
              dataInicialAnterior = DateTime(dataInicial.year - 1, DateTime.now().month - 1, dataInicial.day);
              dataFinalAnterior = DateTime(dataFinal.year - 1, DateTime.now().month - 1, dataFinal.day);
            } else {
              dataInicialAnterior = DateTime(dataInicial.year, DateTime.now().month - 1, dataInicial.day);
              dataFinalAnterior = DateTime(dataFinal.year, DateTime.now().month - 1, dataFinal.day);
            }
          }  
        }
        break;
      case PeriodoRelatorio.ano_atual: {
          dataInicial = DateTime(DateTime.now().year, 1, 1);
          dataFinal = DateTime(DateTime.now().year, 12, 31);
          dataInicialAnterior = DateTime(dataInicial.year - 1, 1, 1);
          dataFinalAnterior = DateTime(dataFinal.year - 1, 12, 31);
        }
        break;
      case PeriodoRelatorio.ano_anterior: {
          dataInicial = DateTime(DateTime.now().year - 1, 1, 1);
          dataFinal = DateTime(DateTime.now().year - 1, 12, 31);
          dataInicialAnterior = DateTime(dataInicial.year - 1, 1, 1);
          dataInicialAnterior = DateTime(dataFinal.year - 1, 12, 31);
        }
        break;
      case PeriodoRelatorio.selecione: {
          List<DateTime> dateList = await DateRagePicker.showDatePicker(
            context: context, 
            firstDate: DateTime(DateTime.now().year-1,1, 1), 
            initialFirstDate: DateTime.now(), 
            initialLastDate: DateTime.now(), 
            lastDate: DateTime(DateTime.now().year,12, 31)
          );
          if (dateList != null) {
            dataInicial = dateList[0];
            dataFinal = dateList[1];
            dataInicialAnterior = null;
            dataFinalAnterior = null;
            print("dateList: $dateList");
          }  
        }
        break;
      default:
    }
    _dataInicialController.add(dataInicial);
    _dataFinalController.add(dataFinal);
    _periodoRelatorioSelecionadoController.add(periodoRelatorioSelecionado);
  }

  Future<String>getWeekDayFromIndex(int index) async {
    String weekDay;
    switch (index) {
      case 0: weekDay = "Domingo";
        break;
      case 1: weekDay = "Segunda";
        break;
      case 2: weekDay = "Terça";
        break;
      case 3: weekDay = "Quarta";
        break;
      case 4: weekDay = "Quinta";
        break;
      case 5: weekDay = "Sexta";
        break;
      case 6: weekDay = "Sábado";
        break;
      default:
    }
    return weekDay;
  }

  Future<String>getMonthFromIndex(int index) async {
    String month;
    switch (index) {
      case 1: month = "Janeiro";
        break;
      case 2: month = "Fevereiro";
        break;
      case 3: month = "Março";
        break;
      case 4: month = "Abril";
        break;
      case 5: month = "Maio";
        break;
      case 6: month = "Junho";
        break;
      case 7: month = "Julho";
        break;
      case 8: month = "Agosto";
        break;
      case 9: month = "Setembro";
        break;
      case 10: month = "Outubro";
        break;
      case 11: month = "Novembro";
        break;
      case 12: month = "Dezembro";
        break;
      default:
    }
    return month;
  }

  String getTipoRelatorioStr() {
    switch (periodoRelatorioSelecionado.periodoRelatorio) {
      case PeriodoRelatorio.hoje:
      case PeriodoRelatorio.ontem: return "dia";
        break;
      case PeriodoRelatorio.semana_atual: 
      case PeriodoRelatorio.semana_anterior: return "semana";
        break;
      case PeriodoRelatorio.mes_atual: 
      case PeriodoRelatorio.mes_anterior: return "mes";
        break;
      case PeriodoRelatorio.ano_atual: 
      case PeriodoRelatorio.ano_anterior: return "ano";
        break;
      case PeriodoRelatorio.selecione: {
        var diff = dataFinal.difference(dataInicial);
        return diff.inDays == 0 ? "dia" : dataInicial.month == dataFinal.month ? "mes" : "ano";
      }
        break;
      default:
    }
  }

  @override
  void dispose() {
    _relatorioCardVendaTotalController.close();
    _relatorioCardLucroTotalController.close();
    _relatorioCardTipoPagamentoListController.close();
    _relatorioCardTopProdutoListController.close();
    _relatorioCardTopCategoriaListController.close();
    _relatorioCardVendaGraficoListController.close();
    _relatorioCardVendaGraficoDataController.close();
    _relatorioCardVendaGraficoAnteriorDataController.close();
    _periodoRelatorioSelecionadoController.close();
    _dataInicialController.close();
    _dataFinalController.close();
    super.dispose();
  }
}
