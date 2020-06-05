import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:common_files/src/model/entities/configuracao/tipo_pagamento/tipo_pagamento.dart';
import 'package:common_files/src/model/entities/configuracao/tipo_pagamento/tipo_pagamentoDao.dart';
import 'package:dio/dio.dart';
import 'package:rxdart/rxdart.dart';
import 'package:xml/xml.dart' as xml;

class TipoPagamentoBloc extends BlocBase {
  bool nomeInvalido = false;
  bool formInvalido = false;
  int iconeSelecionado = 0;
  String filtroNome="";
  TipoPagamento tipoPagamento;
  List<String> iconList = [];
  List<TipoPagamento> tipoPagamentoList;
  BehaviorSubject<List<String>> iconListController;
  Observable<List<String>> get iconListOut => iconListController.stream;
  BehaviorSubject<bool> nomeInvalidoController;
  Observable<bool> get nomeInvalidoOut => nomeInvalidoController.stream;
  BehaviorSubject<TipoPagamento> tipoPagamentoController;
  Observable<TipoPagamento> get tipoPagamentoOut => tipoPagamentoController.stream;
  BehaviorSubject<List<TipoPagamento>> tipoPagamentoListController;
  Observable<List<TipoPagamento>> get tipoPagamentoListOut => tipoPagamentoListController.stream;
  BehaviorSubject<int> iconeSelecionadoController;
  Observable<int> get iconeSelecionadoOut => iconeSelecionadoController.stream;


  TipoPagamentoBloc(){
    iconListController = BehaviorSubject.seeded(iconList);
    nomeInvalidoController = BehaviorSubject.seeded(nomeInvalido);
    tipoPagamentoController = BehaviorSubject.seeded(tipoPagamento);
    tipoPagamentoListController = BehaviorSubject.seeded(tipoPagamentoList);
    iconeSelecionadoController = BehaviorSubject.seeded(iconeSelecionado);
  }

  getAllTipoPagamento() async {
    TipoPagamento _tipoPagamento = TipoPagamento();
    TipoPagamentoDAO tipoPagamentoDAO = TipoPagamentoDAO(tipoPagamento: _tipoPagamento);
    tipoPagamentoList = await tipoPagamentoDAO.getAllFromServer(id: true, filtroNome: filtroNome, icone: true);
    tipoPagamentoListController.add(tipoPagamentoList);
  }

  getTipoPagamentoById(int id) async {
    TipoPagamento _tipoPagamento = TipoPagamento();
    TipoPagamentoDAO _tipoPagamentoDAO = TipoPagamentoDAO(tipoPagamento: _tipoPagamento);
    tipoPagamento = await _tipoPagamentoDAO.getByIdFromServer(id);
    tipoPagamentoController.add(tipoPagamento);
  }

  newTipoPagamento() async {
    tipoPagamento = TipoPagamento();
    tipoPagamento.nome = "";
    tipoPagamentoController.add(tipoPagamento);
  }

  saveTipoPagamento() async  {
    tipoPagamento.dataCadastro = tipoPagamento.dataCadastro == null ? DateTime.now() : tipoPagamento.dataCadastro;
    tipoPagamento.dataAtualizacao = DateTime.now();
    TipoPagamentoDAO _tipoPagamentoDAO = TipoPagamentoDAO(tipoPagamento: tipoPagamento);
    tipoPagamento = await _tipoPagamentoDAO.saveOnServer();
    tipoPagamentoList.add(tipoPagamento);
    tipoPagamentoListController.add(tipoPagamentoList);
    await resetBloc();
  }

  deleteTipoPagamento() async {
    tipoPagamento.ehDeletado = 1; 
    tipoPagamento.dataAtualizacao = DateTime.now();
    TipoPagamentoDAO _tipoPagamentoDAO = TipoPagamentoDAO(tipoPagamento: tipoPagamento);
    tipoPagamento = await _tipoPagamentoDAO.saveOnServer();
    await resetBloc();
  }

  validaNome() {
    nomeInvalido = tipoPagamento.nome == "" ? true : false;
    formInvalido = nomeInvalido;
    nomeInvalidoController.add(nomeInvalido);
  }

  limpaValidacoes(){
    nomeInvalido = false;
    nomeInvalidoController.add(nomeInvalido);
  }

  getIconsFromS3() async {
    Dio dio = Dio();
    try {
      Response response = await dio.get('https://fluggy-images.s3-sa-east-1.amazonaws.com/?prefix=images/tipoPagamento/',
        options: Options(
          headers: {
            'Host': 'fluggy-images.s3-sa-east-1.amazonaws.com'
          }
        )
      );
      if(response.statusCode == 200){
        iconList = [];
        xml.parse(response.data).findAllElements('Key').forEach( (element) {
          if(element.toString().contains('.png')){
            iconList.add(element.toString().replaceAll("<Key>", "").replaceAll("</Key>", ""));
          }
        });
      }
      iconListController.add(iconList);
    } catch (e) {
      print(e);
    } 
  }

  setIconeSelecionado(int index){
    iconeSelecionado = index;
    iconeSelecionadoController.add(iconeSelecionado);
  }

  resetBloc() async  {
    tipoPagamento = TipoPagamento();
    tipoPagamentoController.add(tipoPagamento);
  }

  @override
  void dispose() {
    iconListController.close();
    nomeInvalidoController.close();
    tipoPagamentoController.close();
    tipoPagamentoListController.close();
    iconeSelecionadoController.close();
    super.dispose();
  }
}
