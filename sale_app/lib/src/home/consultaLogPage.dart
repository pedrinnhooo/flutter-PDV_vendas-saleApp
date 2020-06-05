import 'package:common_files/common_files.dart';
import 'package:fluggy/src/app_module.dart';
import 'package:flutter/material.dart';
import 'package:logger_flutter/logger_flutter.dart';

class ConsultaLogPage extends StatefulWidget {
  ConsultaLogPage({Key key}) : super(key: key);

  @override
  _ConsultaLogPageState createState() => _ConsultaLogPageState();
}

class _ConsultaLogPageState extends State<ConsultaLogPage> {
  List<LogErro> logList = [];
  GlobalKey<ScaffoldState> _scaffoldKey;
  AppGlobalBloc appGlobalBloc;
  HasuraBloc hasuraBloc;

  @override
  void initState() {
    appGlobalBloc = AppModule.to.getBloc<AppGlobalBloc>();
    hasuraBloc = AppModule.to.getBloc<HasuraBloc>();
    _scaffoldKey  = GlobalKey<ScaffoldState>();
    getAllLog();
    super.initState();
  }

  Future<List<LogErro>> getAllLog() async {
    LogErro logErro = LogErro();
    LogErroDAO logErroDAO = LogErroDAO(hasuraBloc, appGlobalBloc, logErro);
    logErroDAO.filterEhSincronizado = FilterEhSincronizado.todos;
    logList = await logErroDAO.getAll();
    return logList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        title: Text("Consulta LogErro"),
        leading:  StreamBuilder(
          stream: appGlobalBloc.configuracaoGeralOut,
          builder: (context, snapshot) {
            if (!snapshot.hasData){
              return CircularProgressIndicator();
            }
            ConfiguracaoGeral configuracaoGeral = snapshot.data;
            return WillPopScope(
              onWillPop: () {
                if (configuracaoGeral.ehMenuClassico == 1) {
                  _scaffoldKey.currentState.openDrawer();
                } else { 
                  Navigator.pop(context);
                }
                return Future.value(false);
              },
              child: IconButton(
                icon: Icon(configuracaoGeral.ehMenuClassico == 1 ? 
                Icons.menu : Icons.arrow_back,color: Theme.of(context).primaryIconTheme.color),
                onPressed: () {
                  if (configuracaoGeral.ehMenuClassico == 1) {
                    _scaffoldKey.currentState.openDrawer();
                  } else { 
                    Navigator.pop(context);
                  }
                }
              ),
            );
          }
        ),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Expanded(
              child: 
              FutureBuilder<List<LogErro>>(
                future: getAllLog(),
                builder: (context, snapshot) {
                  if(snapshot.connectionState == ConnectionState.done && snapshot.hasData){
                    List<LogErro> _logErroList = snapshot.data;
                    return 
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: _logErroList.length,
                      //appGlobalBloc.logErroList.length,
                      itemBuilder: (context, index){
                        return ExpansionTile(
                          backgroundColor: Colors.grey[600],
                          title: Text("IdApp: ${appGlobalBloc.logErroList[index].idApp} | Arquivo: ${appGlobalBloc.logErroList[index].nomeArquivo}", style: Theme.of(context).textTheme.body1,),
                          subtitle: Text("Nome função: ${appGlobalBloc.logErroList[index].nomeFuncao}", style: Theme.of(context).textTheme.body2,),
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(left: 20),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Text("Mensagem: ${appGlobalBloc.logErroList[index].mensagemErro}"),
                                ],
                              ),
                            ),
                          ],
                        );
                      }
                    );
                  } else {
                    return CircularProgressIndicator();
                  }
                }
              ),
            )
          ],
        ),
      ),
    );
  }
}