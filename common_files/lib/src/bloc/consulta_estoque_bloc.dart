import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:common_files/common_files.dart';
import 'package:flutter/cupertino.dart';
import 'package:rxdart/rxdart.dart';
import 'package:rxdart/subjects.dart';

class ConsultaEstoqueBloc extends BlocBase {
  HasuraBloc _hasuraBloc;
  PageController pageController = PageController(keepPage: true);
  AppGlobalBloc appGlobalBloc;
  Produto produto;
  int tamanho;
  List<String> varianteList = [];
  Estoque estoque;
  List<Estoque> estoqueList = [];
  BehaviorSubject<List<Estoque>> _estoqueListController;
  Stream<List<Estoque>> get estoqueListControllerOut => _estoqueListController.stream;
  List<Estoque> movimentoEstoqueList;
  
  ProdutoVariante produtoVarianteSelecionado = ProdutoVariante();
  BehaviorSubject<ProdutoVariante> _produtoVarianteSelecionadoController;
  Stream<ProdutoVariante> get produtoVarianteSelecionadoControllerOut => _produtoVarianteSelecionadoController.stream;

  int _estoqueTotal;
  BehaviorSubject _estoqueTotalController;
  Stream get estoqueTotalOut => _estoqueTotalController.stream;

  int oldEstoque=0;
  BehaviorSubject<int> _oldEstoqueController;
  Stream<int> get oldEstoqueControllerOut => _oldEstoqueController.stream;

  int newEstoque;
  BehaviorSubject<int> _newEstoqueController;
  Stream<int> get newEstoqueControllerOut => _newEstoqueController.stream;

  int estoqueDigitado=0;
  BehaviorSubject<int> _estoqueDigitadoController;
  Stream<int> get estoqueDigitadoControllerOut => _estoqueDigitadoController.stream;

  List<String> gradeTamanhosList = [];
  BehaviorSubject<List<String>> _gradeTamanhosListController;
  Stream<List<String>> get gradeTamanhosListControllerOut => _gradeTamanhosListController.stream;

  List<EstoqueGradeMovimento> estoqueGradeList;
  BehaviorSubject<List<EstoqueGradeMovimento>> _estoqueGradeController;
  Stream<List<EstoqueGradeMovimento>> get estoqueGradeOut => _estoqueGradeController.stream;

  List<Map<String, int>> _estoqueVarianteTotal;
  BehaviorSubject _estoqueVarianteController;
  Stream get estoqueVarianteOut => _estoqueVarianteController.stream;

  int pageCounter;
  BehaviorSubject _pageCounterController;
  Stream get pageCounterOut => _pageCounterController.stream;

  BehaviorSubject<Produto> produtoController;
  Stream<Produto> get produtoControllerOut => produtoController.stream;

  List<dynamic> produtoTamanhoSelecionado = [];
  BehaviorSubject<List<dynamic>> _produtoTamanhoSelecionadoController;
  Stream<List<dynamic>> get produtoTamanhoSelecionadoControllerOut => _produtoTamanhoSelecionadoController.stream;

  TipoAtualizacaoEstoque tipoAtualizacaoEstoque;
  BehaviorSubject<TipoAtualizacaoEstoque> _tipoAtualizacaoEstoqueController;
  Stream<TipoAtualizacaoEstoque> get tipoAtualizacaoEstoqueControllerOut => _tipoAtualizacaoEstoqueController.stream;
  String txtTipoAtualizacaoEstoque;
  BehaviorSubject<String> _txtTipoAtualizacaoEstoqueController;
  Stream<String> get txtTipoAtualizacaoEstoqueControllerOut => _txtTipoAtualizacaoEstoqueController.stream;

  String txtDigitado;
  BehaviorSubject<String> _txtDigitadoController;
  Stream<String> get txtDigitadoControllerOut => _txtDigitadoController.stream;

  String labelVarianteTamanho="";
  BehaviorSubject<String> _labelVarianteTamanhoController;
  Stream<String> get labelVarianteTamanhoControllerOut => _labelVarianteTamanhoController.stream;

  List<EstoqueHistorico> _estoqueHistoricoList = [];
  BehaviorSubject<List<EstoqueHistorico>> _estoqueHistoricoListController;
  Stream<List<EstoqueHistorico>> get estoqueHistoricoListControllerOut => _estoqueHistoricoListController.stream;

  ConsultaEstoqueBloc(this._hasuraBloc, this.appGlobalBloc, {Produto produto}){
    this.produto = produto;
    _estoqueListController = BehaviorSubject.seeded(estoqueList);
    _estoqueTotalController = BehaviorSubject.seeded(_estoqueTotal);
    _estoqueGradeController = BehaviorSubject.seeded(estoqueGradeList);
    _gradeTamanhosListController = BehaviorSubject.seeded(gradeTamanhosList);
    _estoqueVarianteController = BehaviorSubject.seeded(_estoqueVarianteTotal);
    _pageCounterController = BehaviorSubject.seeded(pageCounter);
    produtoController = BehaviorSubject.seeded(produto);
    _produtoVarianteSelecionadoController = BehaviorSubject.seeded(produtoVarianteSelecionado);
    _produtoTamanhoSelecionadoController = BehaviorSubject.seeded(produtoTamanhoSelecionado);
    _oldEstoqueController = BehaviorSubject.seeded(oldEstoque);
    _newEstoqueController = BehaviorSubject.seeded(newEstoque);
    _estoqueDigitadoController = BehaviorSubject.seeded(estoqueDigitado);
    tipoAtualizacaoEstoque = TipoAtualizacaoEstoque.somar;
    txtTipoAtualizacaoEstoque = "Somar";
    _tipoAtualizacaoEstoqueController = BehaviorSubject.seeded(tipoAtualizacaoEstoque);
    _txtTipoAtualizacaoEstoqueController = BehaviorSubject.seeded(txtTipoAtualizacaoEstoque);
    _txtDigitadoController = BehaviorSubject.seeded(txtDigitado);
    _labelVarianteTamanhoController = BehaviorSubject.seeded(labelVarianteTamanho);
    _estoqueHistoricoListController = BehaviorSubject.seeded(_estoqueHistoricoList);
  }

  getAllEstoque() async {
    Estoque _estoque = Estoque();
    EstoqueDAO _estoqueDAO = EstoqueDAO(_hasuraBloc, appGlobalBloc, estoque: _estoque);
    estoqueList = await _estoqueDAO.getAllFromServer(idProduto: produto.id);
    _estoqueListController.add(estoqueList);
    movimentoEstoqueList = [];
  }
  
  consultaEstoqueTotal({bool ehEdicaoEstoque = false}) async {
    _estoqueTotal = 0;
    for (var i = 0; i < estoqueList.length; i++) {
      _estoqueTotal+= estoqueList[i].estoqueTotal.toInt();
    }
    if(ehEdicaoEstoque){
      setOldEstoque();
    }
    _estoqueTotalController.add(_estoqueTotal);
  }

  consultaGrade({int idVariante, bool ehEdicaoEstoque = false}) async {
    gradeTamanhosList = [];
    estoqueGradeList = [];
    List<Estoque> _estoqueList = [];
    List<Estoque> _movimentoEstoqueList = [];

    _estoqueList = estoqueList.where(
      (estoque) => estoque.idVariante == idVariante).toList();

    _movimentoEstoqueList = movimentoEstoqueList.where(
      (estoque) => estoque.idVariante == idVariante).toList();

    EstoqueGradeMovimento _estoqueGradeMovimento;
    
    gradeTamanhosList.add(produto.grade.t1);
    if ((produto.grade.t1 != null) && (produto.grade.t1 != "")) {
      _estoqueGradeMovimento = EstoqueGradeMovimento();
      _estoqueGradeMovimento.estoqueAtual = _estoqueList.length > 0 ? _estoqueList[0].et1.toInt() : 0;
      _estoqueGradeMovimento.estoqueNovo = (_movimentoEstoqueList.length > 0) && (_movimentoEstoqueList[0].et1 != null)  ? 
        await getNewEstoque(_estoqueGradeMovimento.estoqueAtual, _movimentoEstoqueList[0].et1.toInt()) : null;
      estoqueGradeList.add(_estoqueGradeMovimento);
    }  
    gradeTamanhosList.add(produto.grade.t2);
    if ((produto.grade.t2 != null) && (produto.grade.t2 != "")) {
      _estoqueGradeMovimento = EstoqueGradeMovimento();
      _estoqueGradeMovimento.estoqueAtual = _estoqueList.length > 0 ? _estoqueList[0].et2.toInt() : 0;
      _estoqueGradeMovimento.estoqueNovo = (_movimentoEstoqueList.length > 0) && (_movimentoEstoqueList[0].et2 != null)  ? 
        await getNewEstoque(_estoqueGradeMovimento.estoqueAtual, _movimentoEstoqueList[0].et2.toInt()) : null;
      estoqueGradeList.add(_estoqueGradeMovimento);
    }  
    gradeTamanhosList.add(produto.grade.t3);
    if ((produto.grade.t3 != null) && (produto.grade.t3 != "")) {
      _estoqueGradeMovimento = EstoqueGradeMovimento();
      _estoqueGradeMovimento.estoqueAtual = _estoqueList.length > 0 ? _estoqueList[0].et3.toInt() : 0;
      _estoqueGradeMovimento.estoqueNovo = (_movimentoEstoqueList.length > 0) && (_movimentoEstoqueList[0].et3 != null)  ? 
        await getNewEstoque(_estoqueGradeMovimento.estoqueAtual, _movimentoEstoqueList[0].et3.toInt()) : null;
      estoqueGradeList.add(_estoqueGradeMovimento);
    }  
    gradeTamanhosList.add(produto.grade.t4);
    if ((produto.grade.t4 != null) && (produto.grade.t4 != "")) {
      _estoqueGradeMovimento = EstoqueGradeMovimento();
      _estoqueGradeMovimento.estoqueAtual = _estoqueList.length > 0 ? _estoqueList[0].et4.toInt() : 0;
      _estoqueGradeMovimento.estoqueNovo = (_movimentoEstoqueList.length > 0) && (_movimentoEstoqueList[0].et4 != null)  ? 
        await getNewEstoque(_estoqueGradeMovimento.estoqueAtual, _movimentoEstoqueList[0].et4.toInt()) : null;
      estoqueGradeList.add(_estoqueGradeMovimento);
    }  
    gradeTamanhosList.add(produto.grade.t5);
    if ((produto.grade.t5 != null) && (produto.grade.t5 != "")) {
      _estoqueGradeMovimento = EstoqueGradeMovimento();
      _estoqueGradeMovimento.estoqueAtual = _estoqueList.length > 0 ? _estoqueList[0].et5.toInt() : 0;
      _estoqueGradeMovimento.estoqueNovo = (_movimentoEstoqueList.length > 0) && (_movimentoEstoqueList[0].et5 != null)  ? 
        await getNewEstoque(_estoqueGradeMovimento.estoqueAtual, _movimentoEstoqueList[0].et5.toInt()) : null;
      estoqueGradeList.add(_estoqueGradeMovimento);
    }  
    gradeTamanhosList.add(produto.grade.t6);
    if ((produto.grade.t6 != null) && (produto.grade.t6 != "")) {
      _estoqueGradeMovimento = EstoqueGradeMovimento();
      _estoqueGradeMovimento.estoqueAtual = _estoqueList.length > 0 ? _estoqueList[0].et6.toInt() : 0;
      _estoqueGradeMovimento.estoqueNovo = (_movimentoEstoqueList.length > 0) && (_movimentoEstoqueList[0].et6 != null)  ? 
        await getNewEstoque(_estoqueGradeMovimento.estoqueAtual, _movimentoEstoqueList[0].et6.toInt()) : null;
      estoqueGradeList.add(_estoqueGradeMovimento);
    }  
    gradeTamanhosList.add(produto.grade.t7);
    if ((produto.grade.t7 != null) && (produto.grade.t7 != "")) {
      _estoqueGradeMovimento = EstoqueGradeMovimento();
      _estoqueGradeMovimento.estoqueAtual = _estoqueList.length > 0 ? _estoqueList[0].et7.toInt() : 0;
      _estoqueGradeMovimento.estoqueNovo = (_movimentoEstoqueList.length > 0) && (_movimentoEstoqueList[0].et7 != null)  ? 
        await getNewEstoque(_estoqueGradeMovimento.estoqueAtual, _movimentoEstoqueList[0].et7.toInt()) : null;
      estoqueGradeList.add(_estoqueGradeMovimento);
    }  
    gradeTamanhosList.add(produto.grade.t8);
    if ((produto.grade.t8 != null) && (produto.grade.t8 != "")) {
      _estoqueGradeMovimento = EstoqueGradeMovimento();
      _estoqueGradeMovimento.estoqueAtual = _estoqueList.length > 0 ? _estoqueList[0].et8.toInt() : 0;
      _estoqueGradeMovimento.estoqueNovo = (_movimentoEstoqueList.length > 0) && (_movimentoEstoqueList[0].et8 != null)  ? 
        await getNewEstoque(_estoqueGradeMovimento.estoqueAtual, _movimentoEstoqueList[0].et8.toInt()) : null;
      estoqueGradeList.add(_estoqueGradeMovimento);
    }  
    gradeTamanhosList.add(produto.grade.t9);
    if ((produto.grade.t9 != null) && (produto.grade.t9 != "")) {
      _estoqueGradeMovimento = EstoqueGradeMovimento();
      _estoqueGradeMovimento.estoqueAtual = _estoqueList.length > 0 ? _estoqueList[0].et9.toInt() : 0;
      _estoqueGradeMovimento.estoqueNovo = (_movimentoEstoqueList.length > 0) && (_movimentoEstoqueList[0].et9 != null)  ? 
        await getNewEstoque(_estoqueGradeMovimento.estoqueAtual, _movimentoEstoqueList[0].et9.toInt()) : null;
      estoqueGradeList.add(_estoqueGradeMovimento);
    }  
    gradeTamanhosList.add(produto.grade.t10);
    if ((produto.grade.t10 != null) && (produto.grade.t10 != "")) {
      _estoqueGradeMovimento = EstoqueGradeMovimento();
      _estoqueGradeMovimento.estoqueAtual = _estoqueList.length > 0 ? _estoqueList[0].et10.toInt() : 0;
      _estoqueGradeMovimento.estoqueNovo = (_movimentoEstoqueList.length > 0) && (_movimentoEstoqueList[0].et10 != null)  ? 
        await getNewEstoque(_estoqueGradeMovimento.estoqueAtual, _movimentoEstoqueList[0].et10.toInt()) : null;
      estoqueGradeList.add(_estoqueGradeMovimento);
    }  
    gradeTamanhosList.add(produto.grade.t11);
    if ((produto.grade.t11 != null) && (produto.grade.t11 != "")) {
      _estoqueGradeMovimento = EstoqueGradeMovimento();
      _estoqueGradeMovimento.estoqueAtual = _estoqueList.length > 0 ? _estoqueList[0].et11.toInt() : 0;
      _estoqueGradeMovimento.estoqueNovo = (_movimentoEstoqueList.length > 0) && (_movimentoEstoqueList[0].et11 != null)  ? 
        await getNewEstoque(_estoqueGradeMovimento.estoqueAtual, _movimentoEstoqueList[0].et11.toInt()) : null;
      estoqueGradeList.add(_estoqueGradeMovimento);
    }  
    gradeTamanhosList.add(produto.grade.t12);
    if ((produto.grade.t12 != null) && (produto.grade.t12 != "")) {
      _estoqueGradeMovimento = EstoqueGradeMovimento();
      _estoqueGradeMovimento.estoqueAtual = _estoqueList.length > 0 ? _estoqueList[0].et12.toInt() : 0;
      _estoqueGradeMovimento.estoqueNovo = (_movimentoEstoqueList.length > 0) && (_movimentoEstoqueList[0].et12 != null)  ? 
        await getNewEstoque(_estoqueGradeMovimento.estoqueAtual, _movimentoEstoqueList[0].et12.toInt()) : null;
      estoqueGradeList.add(_estoqueGradeMovimento);
    }  
    gradeTamanhosList.add(produto.grade.t13);
    if ((produto.grade.t13 != null) && (produto.grade.t13 != "")) {
      _estoqueGradeMovimento = EstoqueGradeMovimento();
      _estoqueGradeMovimento.estoqueAtual = _estoqueList.length > 0 ? _estoqueList[0].et13.toInt() : 0;
      _estoqueGradeMovimento.estoqueNovo = (_movimentoEstoqueList.length > 0) && (_movimentoEstoqueList[0].et13 != null)  ? 
        await getNewEstoque(_estoqueGradeMovimento.estoqueAtual, _movimentoEstoqueList[0].et13.toInt()) : null;
      estoqueGradeList.add(_estoqueGradeMovimento);
    }  
    gradeTamanhosList.add(produto.grade.t14);
    if ((produto.grade.t14 != null) && (produto.grade.t14 != "")) {
      _estoqueGradeMovimento = EstoqueGradeMovimento();
      _estoqueGradeMovimento.estoqueAtual = _estoqueList.length > 0 ? _estoqueList[0].et14.toInt() : 0;
      _estoqueGradeMovimento.estoqueNovo = (_movimentoEstoqueList.length > 0) && (_movimentoEstoqueList[0].et14 != null)  ? 
        await getNewEstoque(_estoqueGradeMovimento.estoqueAtual, _movimentoEstoqueList[0].et14.toInt()) : null;
      estoqueGradeList.add(_estoqueGradeMovimento);
    }  
    gradeTamanhosList.add(produto.grade.t15);
    if ((produto.grade.t15 != null) && (produto.grade.t15 != "")) {
      _estoqueGradeMovimento = EstoqueGradeMovimento();
      _estoqueGradeMovimento.estoqueAtual = _estoqueList.length > 0 ? _estoqueList[0].et15.toInt() : 0;
      _estoqueGradeMovimento.estoqueNovo = (_movimentoEstoqueList.length > 0) && (_movimentoEstoqueList[0].et15 != null)  ? 
        await getNewEstoque(_estoqueGradeMovimento.estoqueAtual, _movimentoEstoqueList[0].et15.toInt()) : null;
      estoqueGradeList.add(_estoqueGradeMovimento);
    } 
    if(ehEdicaoEstoque){
      await getMovimentoEstoque(); 
    }
     _estoqueGradeController.add(estoqueGradeList);
     _gradeTamanhosListController.add(gradeTamanhosList);
  }

  consultaVariante() async {
    for (var i = 0; i < produto.produtoVariante.length; i++) {
      var estoqueVariante = estoqueList.firstWhere(
        (_estoqueVariante) => (_estoqueVariante.idVariante == produto.produtoVariante[i].idVariante),
        orElse: () => null);
      produto.produtoVariante[i].estoque = estoqueVariante != null ? estoqueVariante.estoqueTotal.toInt() : 0;
    }
    produtoController.add(produto);
  }

  consultaVarianteByGrade(int index) async {
    Estoque _estoque;
    varianteList = [];
    produto.produtoVariante.forEach((produtoVariante){
      try {
        _estoque = estoqueList.firstWhere((estoque) => estoque.idVariante == produtoVariante.idVariante && produto.grade.toJson()['t$index'] == gradeTamanhosList[tamanho-1]);
        varianteList.add(_estoque.toJson()['et$index'].toStringAsFixed(0).toString());
      } catch (e) {
        varianteList.add("0");
      }
    });
  }

  setProdutoVarianteSelecionado(int index) async {
    produtoVarianteSelecionado = produto.produtoVariante[index];
    labelVarianteTamanho = produtoVarianteSelecionado.variante.nome;
    _produtoVarianteSelecionadoController.add(produtoVarianteSelecionado);
    _labelVarianteTamanhoController.add(labelVarianteTamanho);
  }

  setProdutoTamanhoSelecionado(int index, String tamanho) async {
    produtoTamanhoSelecionado = [];
    produtoTamanhoSelecionado.add(index);
    produtoTamanhoSelecionado.add(tamanho);
    labelVarianteTamanho = labelVarianteTamanho != "" ? labelVarianteTamanho + " - " + tamanho : tamanho;
    _produtoTamanhoSelecionadoController.add(produtoTamanhoSelecionado);
    _labelVarianteTamanhoController.add(labelVarianteTamanho);
  }

  setOldEstoque() async {
    Estoque _estoque;
    if (produto.produtoVariante.length > 0) {
      _estoque = estoqueList.firstWhere(
        (_estoqueVariante) => (_estoqueVariante.idVariante == produtoVarianteSelecionado.idVariante),
        orElse: () => Estoque());
    } else {
      _estoque = estoqueList[0];
    }
    oldEstoque = produto.grade != null ?
      produtoTamanhoSelecionado[0] == 0 ?
      _estoque.et1 != null ? _estoque.et1.toInt() : 0 : 
      produtoTamanhoSelecionado[0] == 1 ?
      _estoque.et2 != null ? _estoque.et2.toInt() : 0 : 
      produtoTamanhoSelecionado[0] == 2 ?
      _estoque.et3 != null ? _estoque.et3.toInt() : 0 : 
      produtoTamanhoSelecionado[0] == 3 ?
      _estoque.et4 != null ? _estoque.et4.toInt() : 0 : 
      produtoTamanhoSelecionado[0] == 4 ?
      _estoque.et5 != null ? _estoque.et5.toInt() : 0 : 
      produtoTamanhoSelecionado[0] == 5 ?
      _estoque.et6 != null ? _estoque.et6.toInt() : 0 : 
      produtoTamanhoSelecionado[0] == 6 ?
      _estoque.et7 != null ? _estoque.et7.toInt() : 0 : 
      produtoTamanhoSelecionado[0] == 7 ?
      _estoque.et8 != null ? _estoque.et8.toInt() : 0 : 
      produtoTamanhoSelecionado[0] == 8 ?
      _estoque.et9 != null ? _estoque.et9.toInt() : 0 : 
      produtoTamanhoSelecionado[0] == 9 ?
      _estoque.et10 != null ? _estoque.et10.toInt() : 0 : 
      produtoTamanhoSelecionado[0] == 10 ?
      _estoque.et11 != null ? _estoque.et11.toInt() : 0 : 
      produtoTamanhoSelecionado[0] == 11 ?
      _estoque.et12 != null ? _estoque.et12.toInt() : 0 : 
      produtoTamanhoSelecionado[0] == 12 ?
      _estoque.et13 != null ? _estoque.et3.toInt() : 0 : 
      produtoTamanhoSelecionado[0] == 13 ?
      _estoque.et14 != null ? _estoque.et14.toInt() : 0 : 
      produtoTamanhoSelecionado[0] == 14 ?
      _estoque.et15 != null ? _estoque.et15.toInt() : 0 : 
      _estoque.estoqueTotal != null ? _estoque.estoqueTotal.toInt() : 0 : 
      _estoque.estoqueTotal != null ? _estoque.estoqueTotal.toInt() : 0;
    _oldEstoqueController.add(oldEstoque);
    newEstoque = oldEstoque;
    _newEstoqueController.add(newEstoque);
  }

  setEstoqueDigitado(int value) async {
    estoqueDigitado = value;
    _estoqueDigitadoController.add(estoqueDigitado);
  }
  
  setMovimentoEstoque(int value) async {
    if (((tipoAtualizacaoEstoque == TipoAtualizacaoEstoque.somar) || (tipoAtualizacaoEstoque == TipoAtualizacaoEstoque.subtrair)) &&
        value == 0) {
      return;
    }
    if (produto.produtoVariante.length > 0) {
      int _index = produto.produtoVariante.indexWhere((search) => search.idVariante == produtoVarianteSelecionado.idVariante);
      produto.produtoVariante[_index].newEstoque = 0;
      if (movimentoEstoqueList.length > 0) {
        var _estoqueVariante = movimentoEstoqueList.firstWhere(
          (search) => (search.idVariante == produtoVarianteSelecionado.idVariante),
          orElse: () => Estoque());
        if (produto.grade != null) {
          await setMovimentoEstoqueGrade(_estoqueVariante, estoqueDigitado);
        } else {
          _estoqueVariante.estoqueTotal = estoqueDigitado.toDouble();
          produto.produtoVariante[_index].newEstoque = newEstoque;
        }
        if (_estoqueVariante.idProduto == null || _estoqueVariante.idProduto == 0) {
          _estoqueVariante.idProduto = produto.id;
          _estoqueVariante.idVariante = produtoVarianteSelecionado.idVariante;
          movimentoEstoqueList.add(_estoqueVariante);
        }
      } else {
        Estoque _estoqueVariante = Estoque();
        _estoqueVariante.idProduto = produto.id;
        _estoqueVariante.idVariante = produtoVarianteSelecionado.idVariante;
        if (produto.grade != null) {
          await setMovimentoEstoqueGrade(_estoqueVariante, estoqueDigitado);
        } else {
          _estoqueVariante.estoqueTotal = estoqueDigitado.toDouble();
          produto.produtoVariante[_index].newEstoque = newEstoque;
        }
        movimentoEstoqueList.add(_estoqueVariante);
      }
      produtoController.add(produto);
    } else {
      if (movimentoEstoqueList.length > 0) {
        if (produto.grade != null) {
          await setMovimentoEstoqueGrade(movimentoEstoqueList[0], estoqueDigitado);
        } else {
          movimentoEstoqueList[0].estoqueTotal = estoqueDigitado.toDouble();
        }
      } else {
        Estoque _estoque = Estoque();
        _estoque.idProduto = produto.id;
        if (produto.grade != null) {
          await setMovimentoEstoqueGrade(movimentoEstoqueList[0], estoqueDigitado);
        } else {
          _estoque.estoqueTotal = estoqueDigitado.toDouble();
        }
        movimentoEstoqueList.add(_estoque);
      }
    }
  }

  getMovimentoEstoque() async {
    if (movimentoEstoqueList.length > 0) {
      if (produto.produtoVariante.length > 0) {
        var _estoqueDigitado = movimentoEstoqueList.firstWhere(
          (search) => (search.idVariante == produtoVarianteSelecionado.idVariante),
          orElse: () => Estoque());
        if (produto.grade != null) {
          estoqueDigitado = await getMovimentoEstoqueGrade(_estoqueDigitado);
        } else {
          estoqueDigitado = _estoqueDigitado.estoqueTotal.toInt();
        }
      } else {
        if (produto.grade != null) {
          estoqueDigitado = await getMovimentoEstoqueGrade(movimentoEstoqueList[0]);
        } else {
          estoqueDigitado = movimentoEstoqueList[0].estoqueTotal.toInt();
        }
      }
    } else {
      estoqueDigitado = 0;
    }
    setNewEstoque(estoqueDigitado);
    txtDigitado = estoqueDigitado.toString();
    _estoqueDigitadoController.add(estoqueDigitado);
  }

  setNewEstoque(int value) async {
    newEstoque = tipoAtualizacaoEstoque == TipoAtualizacaoEstoque.somar ?
      oldEstoque + value :
      tipoAtualizacaoEstoque == TipoAtualizacaoEstoque.sobrepor ?
      value : 
      tipoAtualizacaoEstoque == TipoAtualizacaoEstoque.subtrair ?
      oldEstoque - value : newEstoque;
    _newEstoqueController.add(newEstoque);
  }  

  Future<int> getNewEstoque(int initialValue, int value) async {
    return tipoAtualizacaoEstoque == TipoAtualizacaoEstoque.somar ?
      initialValue + value :
      tipoAtualizacaoEstoque == TipoAtualizacaoEstoque.sobrepor ?
      value : 
      tipoAtualizacaoEstoque == TipoAtualizacaoEstoque.subtrair ?
      initialValue - value : newEstoque;
  }  

  setMovimentoEstoqueGrade(var estoqueDigitadoGrade, int value) async {
    switch (produtoTamanhoSelecionado[0]) {
      case 0: {
        estoqueDigitadoGrade.et1 = value.toDouble();
        estoqueGradeList[0].estoqueNovo = newEstoque;
      }
      break;
      case 1: {
        estoqueDigitadoGrade.et2 = value.toDouble();
        estoqueGradeList[1].estoqueNovo = newEstoque;
      }
      break;
      case 2: {
        estoqueDigitadoGrade.et3 = value.toDouble();
        estoqueGradeList[2].estoqueNovo = newEstoque;
      }
      break;
      case 3: {
        estoqueDigitadoGrade.et4 = value.toDouble();
        estoqueGradeList[3].estoqueNovo = newEstoque;
      }
      break;
      case 4: {
        estoqueDigitadoGrade.et5 = value.toDouble();
        estoqueGradeList[4].estoqueNovo = newEstoque;
      }
      break;
      case 5: {
        estoqueDigitadoGrade.et6 = value.toDouble();
        estoqueGradeList[5].estoqueNovo = newEstoque;
      }
      break;
      case 6: {
        estoqueDigitadoGrade.et7 = value.toDouble();
        estoqueGradeList[6].estoqueNovo = newEstoque;
      }
      break;
      case 7: {
        estoqueDigitadoGrade.et8 = value.toDouble();
        estoqueGradeList[7].estoqueNovo = newEstoque;
      }
      break;
      case 8: {
        estoqueDigitadoGrade.et9 = value.toDouble();
        estoqueGradeList[8].estoqueNovo = newEstoque;
      }
      break;
      case 9: {
        estoqueDigitadoGrade.et10 = value.toDouble();
        estoqueGradeList[9].estoqueNovo = newEstoque;
      }
      break;
      case 10: {
        estoqueDigitadoGrade.et11 = value.toDouble();
        estoqueGradeList[10].estoqueNovo = newEstoque;
      }
      break;
      case 11: {
        estoqueDigitadoGrade.et12 = value.toDouble();
        estoqueGradeList[11].estoqueNovo = newEstoque;
      }
      break;
      case 12: {
        estoqueDigitadoGrade.et13 = value.toDouble();
        estoqueGradeList[12].estoqueNovo = newEstoque;
      }
      break;
      case 13: {
        estoqueDigitadoGrade.et14 = value.toDouble();
        estoqueGradeList[13].estoqueNovo = newEstoque;
      }
      break;
      case 14: {
        estoqueDigitadoGrade.et15 = value.toDouble();
        estoqueGradeList[14].estoqueNovo = newEstoque;
      }
      break;
      default:
    }
    if (produto.produtoVariante.length > 0) {
      int _index = produto.produtoVariante.indexWhere((search) => search.idVariante == produtoVarianteSelecionado.idVariante);
      produto.produtoVariante[_index].newEstoque = 0;
      for (var i = 0; i < estoqueGradeList.length; i++) {
        produto.produtoVariante[_index].newEstoque = estoqueGradeList[i].estoqueNovo != null ?
        produto.produtoVariante[_index].newEstoque += estoqueGradeList[i].estoqueNovo : 
        produto.produtoVariante[_index].newEstoque += estoqueGradeList[i].estoqueAtual;
      }
    }
    _estoqueGradeController.add(estoqueGradeList);
  }

  Future<int>getMovimentoEstoqueGrade(Estoque value) async {
    int _estoque;
    switch (produtoTamanhoSelecionado[0]) {
      case 0: _estoque = value.et1 != null ? value.et1.toInt() : 0;
        break;
      case 1: _estoque = value.et2 != null ? value.et2.toInt() : 0;
        break;
      case 2: _estoque = value.et3 != null ? value.et3.toInt() : 0;
        break;
      case 3: _estoque = value.et4 != null ? value.et4.toInt() : 0;
        break;
      case 4: _estoque = value.et5 != null ? value.et5.toInt() : 0;
        break;
      case 5: _estoque = value.et6 != null ? value.et6.toInt() : 0;
        break;
      case 6: _estoque = value.et7 != null ? value.et7.toInt() : 0;
        break;
      case 7: _estoque = value.et8 != null ? value.et8.toInt() : 0;
        break;
      case 8: _estoque = value.et9 != null ? value.et9.toInt() : 0;
        break;
      case 9: _estoque = value.et10 != null ? value.et10.toInt() : 0;
        break;
      case 10: _estoque = value.et11 != null ? value.et11.toInt() : 0;
        break;
      case 11: _estoque = value.et12 != null ? value.et12.toInt() : 0;
        break;
      case 12: _estoque = value.et13 != null ? value.et13.toInt() : 0;
        break;
      case 13: _estoque = value.et14 != null ? value.et14.toInt() : 0;
        break;
      case 14: _estoque = value.et15 != null ? value.et15.toInt() : 0;
        break;
      default: _estoque = 0;
    }
    return _estoque;
  }

  setTipoAtualizacaoEstoque(TipoAtualizacaoEstoque value) async {
    tipoAtualizacaoEstoque = value;
    txtTipoAtualizacaoEstoque = tipoAtualizacaoEstoque == TipoAtualizacaoEstoque.somar ?
      "Somar" : tipoAtualizacaoEstoque == TipoAtualizacaoEstoque.sobrepor ?
      "Sobrepor" : "Subtrair";
    _tipoAtualizacaoEstoqueController.add(tipoAtualizacaoEstoque);
    _txtTipoAtualizacaoEstoqueController.add(txtTipoAtualizacaoEstoque);
  }

  notificaContador(){
    _pageCounterController.add(pageCounter);
  }

  updateProdutoStream() async {
    produtoController.add(produto);
  }

  getEstoqueHistorico() async {
    Estoque _estoque = Estoque();
    EstoqueDAO _estoqueDAO = EstoqueDAO(_hasuraBloc, appGlobalBloc, estoque: _estoque);
    _estoqueHistoricoList = await _estoqueDAO.getEstoqueHistoricoFromServer(produto: produto);
    _estoqueHistoricoList.sort((a,b) {
      var adate = a.dataMovimento; //before -> var adate = a.expiry;
      var bdate = b.dataMovimento; //before -> var bdate = b.expiry;
      return adate.compareTo(bdate); //to get the order other way just switch `adate & bdate`
      });    
    _estoqueHistoricoListController.add(_estoqueHistoricoList);
  }

  resetBloc() async {
    _estoqueTotal = 0;
    _estoqueTotalController.add(_estoqueTotal);
    estoqueList = [];
    _estoqueListController.add(estoqueList);
    estoqueGradeList = [];
    _estoqueGradeController.add(estoqueGradeList);
    gradeTamanhosList = [];
    _gradeTamanhosListController.add(gradeTamanhosList);
    _estoqueVarianteTotal = [];
    _estoqueVarianteController.add(_estoqueVarianteTotal);
    produtoVarianteSelecionado = ProdutoVariante();
    _produtoVarianteSelecionadoController.add(produtoVarianteSelecionado);
    produtoTamanhoSelecionado = [];
    _produtoTamanhoSelecionadoController.add(produtoTamanhoSelecionado);
    produto = Produto();
    produtoController.add(produto);
    movimentoEstoqueList = [];

    tipoAtualizacaoEstoque = TipoAtualizacaoEstoque.somar;
    _tipoAtualizacaoEstoqueController = BehaviorSubject.seeded(tipoAtualizacaoEstoque);
    txtTipoAtualizacaoEstoque = "Somar";
    _txtTipoAtualizacaoEstoqueController = BehaviorSubject.seeded(txtTipoAtualizacaoEstoque);
    estoqueDigitado = 0;
    _estoqueDigitadoController.add(estoqueDigitado);
    oldEstoque = 0;
    _oldEstoqueController.add(oldEstoque);
    newEstoque = 0;
    _newEstoqueController.add(newEstoque);
    txtDigitado = "";
    _txtDigitadoController.add(txtDigitado);
    labelVarianteTamanho = "";
    _labelVarianteTamanhoController.add(labelVarianteTamanho);

  }
  
  @override
  void dispose() {
    super.dispose();
    _estoqueListController.close();
    _estoqueTotalController.close();
    _estoqueGradeController.close();
    _gradeTamanhosListController.close();
    _estoqueVarianteController.close();
    _pageCounterController.close();
    produtoController.close();
    _produtoVarianteSelecionadoController.close();
    _produtoTamanhoSelecionadoController.close();
    _oldEstoqueController.close();
    _newEstoqueController.close();
    _estoqueDigitadoController.close();
    _tipoAtualizacaoEstoqueController.close();
    _txtTipoAtualizacaoEstoqueController.close();
    _txtDigitadoController.close();
    _labelVarianteTamanhoController.close();
    _estoqueHistoricoListController.close();
  }
}
