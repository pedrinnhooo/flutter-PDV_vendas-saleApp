import 'dart:async';
import 'dart:isolate';
import 'package:common_files/common_files.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SincronizacaoLambda {
  HasuraBloc _hasuraBloc;
  SharedVendaBloc _vendaBloc;
  AppGlobalBloc _appGlobalBloc;
  DateTime _ultSincronizacao = DateTime.parse("2019-09-13T20:54:31.951813");
  String _ultSincronizacaoCategoria = "2019-09-13T20:54:31.951813";
  String _ultSincronizacaoProduto = "2019-09-13T20:54:31.951813";
  Isolate _isolate;
  bool running = false;
  static int _counterZ = 60;
  String notification = "";
  ReceivePort _receivePort;
  SharedPreferences sharedPreferences;

  SincronizacaoLambda(this._hasuraBloc, this._vendaBloc, this._appGlobalBloc) {
    init();
  }

  init() async {
    sharedPreferences = await SharedPreferences.getInstance();    
  }
  
  int get counterZ => _counterZ;
  set counterZ(int counterZ) => _counterZ = counterZ;

  void start() async {
    print('Started !!');
    running = true;
    _receivePort = ReceivePort();
    _isolate = await Isolate.spawn(_checkTimer, _receivePort.sendPort);
    _receivePort.listen(_handleMessage, onDone:() {
        print("done!");
    });
    //notifyListeners();      
  }

  static int getcounter(){
    return SincronizacaoLambda._counterZ;
  }

  static void incCouter(){
    _counterZ++;
  }

  static void setCouter(int value){
    _counterZ = value;
  }

  static void _checkTimer(SendPort sendPort, {bool stopThread = false}) async {
    _counterZ = 120;
    var timer = Timer.periodic(new Duration(seconds: 1), (Timer t) {
      incCouter();
      if (getcounter() >= 120) {
        String msg = 'EXECUTA SYNC';      
        print('SEND: ' + msg);
        sendPort.send(msg);
        setCouter(0);
      }
    });
  }

  _handleMessage(dynamic data) async {
    print('RECEIVED: ' + data);
    await syncMovimento();
    await syncLogErro();
    //notification = data;
    //notifyListeners();      
  }

  stop() async {
    if (_isolate != null) {
       running = false; 
       notification = '';   
      _receivePort.close();
      _isolate.kill(priority: Isolate.immediate);
      _isolate = null;        
      //notifyListeners();      
    }
  }

  syncMovimento() async {
    try {
      Movimento movimento = Movimento();
      List<Movimento> movimentoList;
      MovimentoDAO movimentoDAO = MovimentoDAO(_hasuraBloc, _appGlobalBloc, movimento);
      movimentoDAO.filterEhSincronizado = FilterEhSincronizado.naoSincronizados;
      movimentoDAO.loadMovimentoItem = true;
      movimentoDAO.loadMovimentoParcela = true;
      movimentoList = await movimentoDAO.getAll(preLoad: true);
          
      for (Movimento mov in movimentoList) {  
        try {
          movimentoDAO.movimento = mov;
          movimentoDAO.movimento.ehsincronizado = 1;
          movimentoDAO.movimento = await movimentoDAO.saveOnServer();
          if (movimentoDAO.movimento.id != null && movimentoDAO.movimento.id > 0) {
            if (movimentoDAO.movimento.ehorcamento == 0) {
              bool result = await movimentoDAO.finalizaMovimento();
              if (result){
                movimentoDAO.movimento.ehfinalizado = 1;
              } else {
                movimentoDAO.movimento.ehsincronizado = 0;
              }
            }
            await movimentoDAO.insert();
          }
        } catch(error, stacktrace) {
          print("<syncMovimento> Exception: ${error.toString()}");
          await log(_hasuraBloc, _appGlobalBloc,
            nomeArquivo: "sincronizacao_lambda",
            nomeFuncao: "syncMovimento 1st Try",
            error: error.toString(),
            stacktrace: stacktrace.toString()
          );
        }   


        // String resource = mov.ehcancelado == 0 ? "grava-venda" : "cancela-venda";
        // mov.ehsincronizado = 1;
        // try {
        //   print(mov.toJson());
        //   print("lambdaEndpoint: "+lambdaEndpoint) ;
        //   var dio = Dio();
        //   var token = sharedPreferences.getString('token');     

        //   dio.options.headers = {"Authorization" : token, "accept": "/", "cache-control": "no-cache"};
        //   Response response = await dio.post(
        //     lambdaEndpoint + resource, 
        //     data: mov.toJson(),
        //   );
        //   print(response.data['id']);
        //   mov.id = response.data["id"];
        //   mov.ehfinalizado = response.data["ehfinalizado"];
        //     for (var i = 0; i < mov.movimentoItem.length; i++) {
        //       mov.movimentoItem[i].id = response.data["movimento_item"][i]["id"];
        //       mov.movimentoItem[i].idMovimento = mov.id;
        //     }
        //     for (var i = 0; i < mov.movimentoParcela.length; i++) {
        //       mov.movimentoParcela[i].id = response.data["movimento_parcela"][i]["id"];
        //       mov.movimentoParcela[i].idMovimento = mov.id;
        //     }
        //     MovimentoDAO movDao = MovimentoDAO(_hasuraBloc, _appGlobalBloc, mov);
        //     await movDao.insert();
        //     movDao = null;
          

      }
      await _vendaBloc.getAllPedido();
    } catch(error, stacktrace) {
      print(error);
      await log(_hasuraBloc, _appGlobalBloc,
        nomeArquivo: "sincronizacao_lambda",
        nomeFuncao: "syncMovimento 2nd Try",
        error: error.toString(),
        stacktrace: stacktrace.toString()
      );
    }   
  }

  syncLogErro() async {
    try {
      LogErro logErro = LogErro();
      List<LogErro> logErroList;
      LogErroDAO logErroDAO = LogErroDAO(_hasuraBloc, _appGlobalBloc, logErro);
      logErroDAO.filterEhSincronizado = FilterEhSincronizado.naoSincronizados;
      logErroList = await logErroDAO.getAll(preLoad: true);
          
      for (LogErro lErro in logErroList) {  
        try {
          logErroDAO.logErro = lErro;
          logErroDAO.logErro.ehsincronizado = 1;
          logErroDAO.logErro = await logErroDAO.saveOnServer();
          if (logErroDAO.logErro.id != null && logErroDAO.logErro.id > 0) {
            await logErroDAO.insert();
          }
        } catch(error, stacktrace) {
          print(error);
          await log(_hasuraBloc, _appGlobalBloc,
            nomeArquivo: "sincronizacao_lambda",
            nomeFuncao: "syncLogErro 1st Try",
            error: error.toString(),
            stacktrace: stacktrace.toString()
          );
        }   
      }
    } catch(error, stacktrace) {
      print(error);
      await log(_hasuraBloc, _appGlobalBloc,
        nomeArquivo: "sincronizacao_lambda",
        nomeFuncao: "syncLogErro 2nd Try",
        error: error.toString(),
        stacktrace: stacktrace.toString()
      );
    }   
  }

  void doSync() {
    setCouter(60);
  }

  @override
  void dispose() {
    stop();
  }
}
