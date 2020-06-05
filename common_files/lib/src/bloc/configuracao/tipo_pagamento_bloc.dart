import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:common_files/common_files.dart';
import 'package:dio/dio.dart';
import 'package:rxdart/rxdart.dart';
import 'package:xml/xml.dart' as xml;

class TipoPagamentoBloc extends BlocBase {
  HasuraBloc _hasuraBloc;
  AppGlobalBloc appGlobalBloc;
  bool nomeInvalido = false;
  bool formInvalido = false;
  int iconeSelecionado = 0;
  int offset = 0;
  String filtroNome="";
  TipoPagamento tipoPagamento;
  List<String> iconList = [];
  List<TipoPagamento> tipoPagamentoList;
  BehaviorSubject<List<String>> iconListController;
  Stream<List<String>> get iconListOut => iconListController.stream;
  BehaviorSubject<bool> nomeInvalidoController;
  Stream<bool> get nomeInvalidoOut => nomeInvalidoController.stream;
  BehaviorSubject<TipoPagamento> tipoPagamentoController;
  Stream<TipoPagamento> get tipoPagamentoOut => tipoPagamentoController.stream;
  BehaviorSubject<List<TipoPagamento>> tipoPagamentoListController;
  Stream<List<TipoPagamento>> get tipoPagamentoListOut => tipoPagamentoListController.stream;
  BehaviorSubject<int> iconeSelecionadoController;
  Stream<int> get iconeSelecionadoOut => iconeSelecionadoController.stream;


  TipoPagamentoBloc(this._hasuraBloc, this.appGlobalBloc){
    iconListController = BehaviorSubject.seeded(iconList);
    nomeInvalidoController = BehaviorSubject.seeded(nomeInvalido);
    tipoPagamentoController = BehaviorSubject.seeded(tipoPagamento);
    tipoPagamentoListController = BehaviorSubject.seeded(tipoPagamentoList);
    iconeSelecionadoController = BehaviorSubject.seeded(iconeSelecionado);
  }

  getAllTipoPagamento() async {
    TipoPagamento _tipoPagamento = TipoPagamento();
    TipoPagamentoDAO tipoPagamentoDAO = TipoPagamentoDAO(_hasuraBloc, appGlobalBloc, tipoPagamento: _tipoPagamento);
    tipoPagamentoList = offset == 0 ? [] : tipoPagamentoList;
    tipoPagamentoList = await tipoPagamentoDAO.getAllFromServer(id: true, filtroNome: filtroNome, icone: true, offset: offset);
    tipoPagamentoListController.add(tipoPagamentoList);
    offset += queryLimit;
    return tipoPagamentoList;
  }

  getTipoPagamentoById(int id) async {
    TipoPagamento _tipoPagamento = TipoPagamento();
    TipoPagamentoDAO _tipoPagamentoDAO = TipoPagamentoDAO(_hasuraBloc, appGlobalBloc, tipoPagamento: _tipoPagamento);
    tipoPagamento = await _tipoPagamentoDAO.getByIdFromServer(id);
    tipoPagamentoController.add(tipoPagamento);
  }

  newTipoPagamento() async {
    tipoPagamento = TipoPagamento();
    tipoPagamento.nome = "";
    tipoPagamentoController.add(tipoPagamento);
  }

  saveTipoPagamento() async  {
    TipoPagamentoDAO _tipoPagamentoDAO = TipoPagamentoDAO(_hasuraBloc, appGlobalBloc, tipoPagamento: tipoPagamento);
    tipoPagamento = await _tipoPagamentoDAO.saveOnServer();
    // tipoPagamentoList.add(tipoPagamento);
    // tipoPagamentoListController.add(tipoPagamentoList);
    offset = 0;
    await getAllTipoPagamento();
    await resetBloc();
  }

  deleteTipoPagamento() async {
    tipoPagamento.ehDeletado = 1; 
    TipoPagamentoDAO _tipoPagamentoDAO = TipoPagamentoDAO(_hasuraBloc, appGlobalBloc, tipoPagamento: tipoPagamento);
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
