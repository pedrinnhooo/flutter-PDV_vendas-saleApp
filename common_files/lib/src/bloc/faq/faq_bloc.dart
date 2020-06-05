import 'dart:async';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:rxdart/rxdart.dart';
import 'package:common_files/common_files.dart';

class FaqBloc extends BlocBase {
  HasuraBloc _hasuraBloc;
  AppGlobalBloc _appGlobalBloc;
  String filtroPergunta="";
  bool ehServico;
  FaqQuestionario faqQuestionario;
  FaqDAO faqDAO;
  List<FaqQuestionario> faqList = [];
  BehaviorSubject<FaqQuestionario> faqController;
  Stream<FaqQuestionario> get faqOut => faqController.stream;
  BehaviorSubject<List<FaqQuestionario>> faqListController;
  Stream<List<FaqQuestionario>> get faqListOut => faqListController.stream;
  int offset = 0;
  bool formInvalido = false;
  bool perguntaInvalido = false;
  BehaviorSubject<bool> perguntaInvalidoController;
  Stream<bool> get nomeInvalidoOut => perguntaInvalidoController.stream;

  FaqBloc(this._hasuraBloc, this._appGlobalBloc) {
    faqQuestionario = FaqQuestionario();
    faqDAO = FaqDAO(_hasuraBloc,  faqQuestionario);
    faqController = BehaviorSubject.seeded(faqQuestionario);
    faqListController = BehaviorSubject.seeded(faqList);
    perguntaInvalidoController = BehaviorSubject.seeded(perguntaInvalido); 
  }

  getAllFaq() async {
    FaqQuestionario _faqQuestionario = FaqQuestionario();
    FaqDAO _faqDAO = FaqDAO(_hasuraBloc, _faqQuestionario);
    faqList = offset == 0 ? [] : faqList; 
    faqList += await _faqDAO.getAllFromServer(id: true, offset: offset);
    faqListController.add(faqList);
    offset += queryLimit;
    return faqList;
  }
  
  getFaqById(int id) async {
    FaqQuestionario _faqQuestionario = FaqQuestionario();
    FaqDAO _faqDAO = FaqDAO(_hasuraBloc, _faqQuestionario);
    faqQuestionario = await _faqDAO.getByIdFromServer(id);
    faqController.add(faqQuestionario);
  }

  validaNome() {
    perguntaInvalido = faqQuestionario.pergunta == "" ? true : false;
    formInvalido = perguntaInvalido;
    perguntaInvalidoController.add(perguntaInvalido);
  }

  limpaValidacoes(){
    perguntaInvalido = false;
    perguntaInvalidoController.add(perguntaInvalido);
  }

  resetBloc() async  {
    faqQuestionario = FaqQuestionario();
    faqController.add(faqQuestionario);
  }

  @override
  void dispose() {
    faqController.close();
    faqListController.close();
    perguntaInvalidoController.close();
    super.dispose();
  }
}
