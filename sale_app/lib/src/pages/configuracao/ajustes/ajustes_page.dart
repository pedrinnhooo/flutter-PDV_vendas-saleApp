
import 'package:common_files/common_files.dart';
import 'package:fluggy/generated/locale_base.dart';
import 'package:fluggy/src/app_module.dart';
import 'package:fluggy/src/pages/configuracao/ajustes/ajustes_module.dart';
import 'package:fluggy/src/pages/configuracao/terminal/terminal_module.dart';
import 'package:fluggy/src/pages/configuracao/tipo_pagamento/tipo_pagamento_module.dart';
import 'package:fluggy/src/pages/configuracao/transacao/transacao_module.dart';
import 'package:fluggy/src/pages/widgets/Drawer/drawer.dart';
import 'package:flutter/material.dart';

class AjustesPage extends StatefulWidget {
  @override
  _AjustesPageState createState() => _AjustesPageState();
}

class _AjustesPageState extends State<AjustesPage> {
  ConfiguracaoGeralBloc configuracaoGeralBloc;
  // AppGlobalBloc appGlobalBloc;
  HasuraBloc hasuraBloc;
  GlobalKey<ScaffoldState> _scaffoldKey;
  
  @override
  void initState() {
    configuracaoGeralBloc = AjustesModule.to.getBloc<ConfiguracaoGeralBloc>();
    // appGlobalBloc = AppModule.to.getBloc<AppGlobalBloc>();
    hasuraBloc = AppModule.to.getBloc<HasuraBloc>();
    _scaffoldKey  = GlobalKey<ScaffoldState>();
    init();
    super.initState();
  }

  void init() async {
    await configuracaoGeralBloc.getAllConfiguracaoGeral();
  }  

  @override
  Widget build(BuildContext context) {

    final locale = Localizations.of<LocaleBase>(context, LocaleBase);
 
    Widget body = Expanded(
      child: Container(
        padding: EdgeInsets.only(left: 10, right: 10, bottom: 20), 
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Theme.of(context).accentColor,
          ),
          child: Column(
            children: <Widget>[
              Expanded(
                child: SingleChildScrollView(
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: StreamBuilder<ConfiguracaoGeral>(
                          initialData: ConfiguracaoGeral(), 
                          stream: configuracaoGeralBloc.configuracaoGeralOut,
                          builder: (context, snapshot) {
                            if (!snapshot.hasData){
                              return CircularProgressIndicator();
                            }
                            ConfiguracaoGeral configuracaoGeral = snapshot.data;
                            return Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 5),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[ 
                                  Visibility(
                                    visible: false,
                                    child: ListTile(
                                      title: Row(
                                        children: <Widget>[
                                          Padding(
                                            padding: const EdgeInsets.only(right: 10.0),
                                            child: Image.asset(
                                              'assets/transacaoIcon.png',
                                              fit: BoxFit.contain,
                                              height: 25,
                                            ),
                                          ),
                                          Text("Transação"),
                                        ],
                                      ),
                                      onTap: () {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            settings:  RouteSettings(name: '/ListaTransacao'),
                                            builder: (BuildContext context) => TransacaoModule(),
                                          )
                                        );
                                      },
                                    ),
                                  ),
                                  Visibility(visible: false, child: Divider(height: 2, color: Colors.white60,)),
                                  Visibility(
                                    visible: false,
                                    child: ListTile(
                                      title: Row(
                                        children: <Widget>[
                                          Padding(
                                            padding: const EdgeInsets.only(right: 10.0),
                                            child: Image.asset(
                                              'assets/tipoPagamentoIcon.png',
                                              fit: BoxFit.contain,
                                              height: 25,
                                            ),
                                          ),
                                          Text("Tipo de Pagamento"),
                                        ],
                                      ),
                                      onTap: () {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            settings:  RouteSettings(name: '/ConfiguracaoTipoPagamento'),
                                            builder: (BuildContext context) => TipoPagamentoModule(),
                                          )
                                        );
                                      },
                                    ),
                                  ),
                                  Visibility(visible: false, child: Divider(height: 2, color: Colors.white60,)),
                                  ListTile(
                                    title:  Row(
                                      children: <Widget>[
                                        Padding(
                                          padding: const EdgeInsets.only(right: 10.0),
                                          child: Image.asset(
                                            'assets/userIcon.png',
                                            fit: BoxFit.contain,
                                            height: 25,
                                          ),
                                        ),
                                        Text("Usuário"),
                                      ],
                                    ),
                                    onTap: () {
                                      
                                    },
                                  ),
                                  Divider(height: 2, color: Colors.white60,),
                                  ListTile(
                                    title:  Row(
                                      children: <Widget>[
                                        Padding(
                                          padding: const EdgeInsets.only(right: 10.0),
                                          child: Image.asset(
                                            'assets/userIcon.png',
                                            fit: BoxFit.contain,
                                            height: 25,
                                          ),
                                        ),
                                        Text("Terminal"),
                                      ],
                                    ),
                                    onTap: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          settings:  RouteSettings(name: '/ConfiguracaoTerminal'),
                                          builder: (BuildContext context) => TerminalModule()
                                        )
                                      );
                                    },
                                  ),
                                  Visibility(visible: false, child: Divider(height: 2, color: Colors.white60,)),
                                  Visibility(
                                    visible: false,
                                    child: ListTile(
                                      title: Text("Serviço",style: TextStyle(color: Colors.white,fontSize: 16)),
                                      trailing: Switch(
                                        inactiveTrackColor: Colors.grey,
                                        activeColor: Theme.of(context).primaryIconTheme.color,
                                        value: configuracaoGeral.temServico == 1,
                                        onChanged: (value) {
                                          configuracaoGeralBloc.setTemServico(value);
                                        },
                                      ) ,
                                    ),
                                  ),
                                  Visibility(visible: false, child: Divider(height: 2, color: Colors.white60,)),
                                  Visibility(
                                    visible: false,
                                    child: ListTile(
                                      title: Text("Mostrar serviço em primeiro\nplano no PDV",style: TextStyle(color: Colors.white,fontSize: 16)),
                                      trailing: Switch(
                                        inactiveTrackColor: Colors.grey,
                                        activeColor: Theme.of(context).primaryIconTheme.color,
                                        value: configuracaoGeral.ehServicoDefault == 1,
                                        onChanged: (value) {
                                          configuracaoGeralBloc.setEhServicoDefault(value);
                                        },
                                      ),
                                    ),
                                  ),
                                  Visibility(visible: false, child: Divider(height: 2, color: Colors.white60,)),
                                  Visibility(
                                    visible: false,
                                    child: ListTile(
                                      title:  Row(
                                        children: <Widget>[
                                          Padding(
                                            padding: const EdgeInsets.only(right: 10.0),
                                            child: Image.asset(
                                              'assets/userIcon.png',
                                              fit: BoxFit.contain,
                                              height: 25,
                                            ),
                                          ),
                                          Text("Suporte"),
                                        ],
                                      ),
                                      onTap: () {
                                        // appGlobalBloc.zendesk.startChat().then((r) {
                                        //   print(':::::::::: zenDeskChat iniciado ::::::::::');
                                        // }).catchError((e) {
                                        //   log(hasuraBloc ,appGlobalBloc, 
                                        //     nomeArquivo: "app_globa_bloc",
                                        //     mensagemErro: "Erro ZenDesk: $e",
                                        //     nomeFuncao: "ZenDesk - startChat"
                                        //   );
                                        //   showDialog(context: context,
                                        //     builder: (context){
                                        //       return AlertDialog(
                                        //         title: Text("Erro"),
                                        //         content: Text("Não foi possível iniciar o chat."),
                                        //         actions: <Widget>[
                                        //           FlatButton(
                                        //             child: Text("OK"),
                                        //             onPressed: () {
                                        //               Navigator.pop(context);
                                        //             },
                                        //           )
                                        //         ],
                                        //       );
                                        //     }
                                        //   );
                                        // });
                                      },
                                    ),
                                  ),       
                                  Divider(height: 5, color: Colors.white60),
                                  ExpansionTile(
                                    trailing: Icon(Icons.arrow_right),
                                    title: Row(
                                      children: <Widget>[
                                        Icon(Icons.menu, color: Colors.white),
                                        Padding(
                                          padding: const EdgeInsets.only(left: 14),
                                          child: Text("Menu", style: TextStyle(color: Colors.white,fontSize: 15)),
                                        ),
                                      ],
                                    ),
                                    children: <Widget>[
                                      Container(
                                        padding: EdgeInsets.only(left: 50, right: 50),
                                        color: Colors.transparent,
                                        child: Column(
                                          children: <Widget>[
                                            SizedBox(height: 10),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: <Widget>[
                                                InkWell(
                                                  child: Image.asset("assets/animado.jpg", width: 100),
                                                  onTap: () {
                                                    configuracaoGeralBloc.setMenu(0);
                                                  },
                                                ),
                                                InkWell(
                                                  child: Image.asset("assets/classico.jpg", width: 97),
                                                  onTap: () {
                                                    configuracaoGeralBloc.setMenu(1);
                                                  },
                                                )
                                              ],
                                            ),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: <Widget>[
                                                Padding(
                                                  padding: const EdgeInsets.only(left: 20,top: 8),
                                                  child: InkWell(
                                                    child: Text("Animado", style: TextStyle(color: Colors.white,fontSize: 14)),
                                                    onTap: () {
                                                      configuracaoGeralBloc.setMenu(0);
                                                    },
                                                  ),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.only(right: 20,top: 8),
                                                  child: InkWell(
                                                    child: Text("Clássico", style: TextStyle(color: Colors.white,fontSize: 14)),
                                                    onTap: () {
                                                      configuracaoGeralBloc.setMenu(1);
                                                    },
                                                  ),
                                                ),
                                              ],
                                            ),
                                            StreamBuilder<ConfiguracaoGeral>(
                                              stream: configuracaoGeralBloc.configuracaoGeralOut,
                                              builder: (context, snapshot) {
                                                if (!snapshot.hasData){
                                                  return CircularProgressIndicator();
                                                }
                                                ConfiguracaoGeral configuracaoGeral = snapshot.data;
                                                return Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: <Widget>[
                                                    Padding(
                                                      padding: const EdgeInsets.only(left: 20,top: 8),
                                                      child: Radio(
                                                        activeColor: Theme.of(context).primaryIconTheme.color,
                                                        //ANIMADO
                                                        value: 0,
                                                        groupValue: configuracaoGeral.ehMenuClassico,
                                                        onChanged: (value) {
                                                          configuracaoGeralBloc.setMenu(value);
                                                        },
                                                      )
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets.only(right: 20,top: 8),
                                                      child: Radio(
                                                        activeColor: Theme.of(context).primaryIconTheme.color,
                                                        //CLÁSSICO
                                                        value: 1,
                                                        groupValue: configuracaoGeral.ehMenuClassico,
                                                        onChanged: (value) {
                                                          configuracaoGeralBloc.setMenu(value);
                                                        },
                                                      ),
                                                    ),
                                                  ],
                                                );
                                              }
                                            ),
                                          ],
                                        ),
                                      ), 
                                    ],
                                  ),
                                  Divider(height: 5, color: Colors.white60),
                                ],
                              ),
                            );
                          }
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              customButtomGravar(
                buttonColor: Theme.of(context).primaryIconTheme.color,
                text: Text(locale.palavra.gravar,
                  style: Theme.of(context).textTheme.title,
                ),
                onPressed: () async {
                  if(configuracaoGeralBloc.configuracaoGeral.ehMenuClassico == 1){
                    await configuracaoGeralBloc.saveConfiguracaoGeral();
                    Navigator.pop(context);
                    Navigator.of(context).popAndPushNamed('/Venda');
                  } else {
                    await configuracaoGeralBloc.saveConfiguracaoGeral();
                    Navigator.of(context).popAndPushNamed('/Venda');
                  }
                }
              )
            ],
          ),
        )
      ),
    );

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Ajustes" ,style: Theme.of(context).textTheme.title),
        leading:  StreamBuilder(
          stream: configuracaoGeralBloc.appGlobalBloc.configuracaoGeralOut,
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
      drawer: DrawerApp(),  
      body: Container(
        color: Theme.of(context).primaryColor,
        child: Column(
          children: <Widget>[
            body
          ],
        ),
      ),
    );
  }
}
