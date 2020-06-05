import 'dart:async';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:rxdart/rxdart.dart';
import 'package:common_files/common_files.dart';

class FaqCategoriaBloc extends BlocBase {
  HasuraBloc _hasuraBloc;
  AppGlobalBloc _appGlobalBloc;
  String filtroNome="";
  bool ehServico;
  FaqCategoria faqCategoria;
  FaqCategoriaDAO faqCategoriaDAO;
  List<FaqCategoria> faqCategoriaList = [];
  BehaviorSubject<FaqCategoria> faqCategoriaController;
  Stream<FaqCategoria> get faqCategoriaOut => faqCategoriaController.stream;
  BehaviorSubject<List<FaqCategoria>> faqCategoriaListController;
  Stream<List<FaqCategoria>> get faqCategoriaListOut => faqCategoriaListController.stream;
  int offset = 0;
  bool formInvalido = false;
  bool nomeInvalido = false;
  BehaviorSubject<bool> nomeInvalidoController;
  Stream<bool> get nomeInvalidoOut => nomeInvalidoController.stream;

  FaqCategoriaBloc(this._hasuraBloc, this._appGlobalBloc) {
    faqCategoria = FaqCategoria();
    faqCategoriaDAO = FaqCategoriaDAO(_hasuraBloc, _appGlobalBloc, faqCategoria: faqCategoria);
    faqCategoriaController = BehaviorSubject.seeded(faqCategoria);
    faqCategoriaListController = BehaviorSubject.seeded(faqCategoriaList);
    nomeInvalidoController = BehaviorSubject.seeded(nomeInvalido); 
  }

  getAllFaqCategoria() async {
    FaqCategoria _faqCategoria = FaqCategoria();
    FaqCategoriaDAO _faqCategoriaDAO = FaqCategoriaDAO(_hasuraBloc, _appGlobalBloc, faqCategoria: _faqCategoria);
    faqCategoriaList = offset == 0 ? [] : faqCategoriaList; 
    faqCategoriaList += await _faqCategoriaDAO.getAllFromServer(id: true, filtroNome: filtroNome, offset: offset, faq: true);
    faqCategoriaListController.add(faqCategoriaList);
    offset += queryLimit;
    return faqCategoriaList;
  }
  
  getFaqCategoriaById(int id) async {
    FaqCategoria _faqCategoria = FaqCategoria();
    FaqCategoriaDAO _faqCategoriaDAO = FaqCategoriaDAO(_hasuraBloc, _appGlobalBloc, faqCategoria: _faqCategoria);
    faqCategoria = await _faqCategoriaDAO.getByIdFromServer(id);
    faqCategoriaController.add(faqCategoria);
  }

  validaNome() {
    nomeInvalido = faqCategoria.nome == "" ? true : false;
    formInvalido = nomeInvalido;
    nomeInvalidoController.add(nomeInvalido);
  }

  limpaValidacoes(){
    nomeInvalido = false;
    nomeInvalidoController.add(nomeInvalido);
  }

  resetBloc() async  {
    faqCategoria = FaqCategoria();
    faqCategoriaController.add(faqCategoria);
  }

  @override
  void dispose() {
    faqCategoriaController.close();
    faqCategoriaListController.close();
    nomeInvalidoController.close();
    super.dispose();
  }
}
