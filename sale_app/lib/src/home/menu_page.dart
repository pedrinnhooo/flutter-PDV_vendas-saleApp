import 'package:common_files/common_files.dart';
import 'package:device_info/device_info.dart';
import 'package:fluggy/src/app_module.dart';
import 'package:fluggy/src/home/consultaLogPage.dart';
import 'package:fluggy/src/pages/cadastro/produto/produto_module.dart';
import 'package:fluggy/src/pages/configuracao/ajustes/ajustes_module.dart';
import 'package:fluggy/src/pages/report/dashboard/dashboard/dashboard_module.dart';
import 'package:fluggy/src/venda/consulta_venda/consulta_venda_module.dart';
import 'package:fluggy/src/venda/movimento_caixa/movimento_caixa_module.dart';
import 'package:flutter/material.dart';
import 'package:fluggy/src/home/cadastro_page.dart';
import 'package:fluggy/src/venda/venda_module.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MenuPage extends StatefulWidget {
  MenuPage({Key key}) : super(key: key);

  @override
  _MenuPageState createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> with SingleTickerProviderStateMixin {
  AnimationController animationController;
  List<Animation<double>> translacaoList;
  // SincronizacaoBloc sincBloc;
  // FirebaseMessaging firebaseMessaging;
  AppGlobalBloc _appGlobalBloc;

  @override
  void initState() {
    super.initState();
    _appGlobalBloc = AppModule.to.getBloc<AppGlobalBloc>();
    animationController = AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    translacaoList = List<Animation<double>>(7);
    // sincBloc = AppModule.to.getBloc<SincronizacaoBloc>();
    // firebaseMessaging = FirebaseMessaging();
    // firebaseMessaging.getToken().then((token){
    //   print(token);
    // });
    
    // firebaseMessaging.requestNotificationPermissions(const IosNotificationSettings(sound: true, badge: true, alert: true, provisional: true));
    // firebaseMessaging.onIosSettingsRegistered.listen((IosNotificationSettings settings) {
    //   print("Settings registered: $settings");
    // });
    // firebaseMessaging.configure(
    //   onMessage: (Map<String, dynamic> message) async {
    //     print("onMessage: $message");
    //     displayFirebaseNotification(message);
    //   },
    //   onLaunch: (Map<String, dynamic> message) async {
    //     print("onLaunch: $message");
    //     displayFirebaseNotification(message);
    //   },
    //   onResume: (Map<String, dynamic> message) async {
    //     print("onResume: $message");
    //   },
    // );
    init();
  }
  
  void displayFirebaseNotification(Map<String, dynamic> message) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      transitionDuration: Duration(milliseconds: 500),
      barrierLabel: MaterialLocalizations.of(context).dialogLabel,
      pageBuilder: (context, _, __) {
        return SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                height: 120,
                width: MediaQuery.of(context).size.width,
                color: Colors.transparent,
                child: Card(
                  color: Theme.of(context).accentColor,
                  borderOnForeground: true,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text("${message['notification']['title']}", style: Theme.of(context).textTheme.display3),                            
                            InkWell(
                              child: Icon(Icons.close, size: 24, color: Colors.white,),
                              onTap: () {Navigator.pop(context);},
                            )
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              child: Flexible(
                                child: Text("${message['notification']['body']}", style: TextStyle(color: Colors.white, fontSize: 18),)
                              )
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return SlideTransition(
          position: CurvedAnimation(
            parent: animation,
            curve: Curves.easeOut,
          ).drive(Tween<Offset>(
            begin: Offset(0, -1.0),
            end: Offset(0, 0.01),
          )),
          child: child,
        );
      },
    );
  }

  init() async {
    // await sincBloc.sincronizacaoHasura.getSincronizacaoFromServer();
    // sincBloc.sincronizacaoLambda.start();
    // await Intercom.registerIdentifiedUser(userId: _appGlobalBloc.usuario.id.toString());
    // await Intercom.updateUser(
    //   userId: _appGlobalBloc.usuario.id.toString(),
    //   name: _appGlobalBloc.usuario.razaoNome, 
    //   email: _appGlobalBloc.usuario.contato[0].email,
    //   phone: _appGlobalBloc.usuario.contato[0].telefone1,  
    //   companyId: _appGlobalBloc.usuario.idPessoaGrupo.toString(),
    // );
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    translacaoList[0] = Tween<double>(begin: -10, end: 0).animate(
        CurvedAnimation(
            curve: Curves.easeInOutBack, parent: animationController));
    translacaoList[1] = Tween<double>(begin: 24, end: 0).animate(
        CurvedAnimation(
            curve: Curves.easeInOutBack, parent: animationController));
    translacaoList[2] = Tween<double>(begin: -24, end: 0).animate(
        CurvedAnimation(
            curve: Curves.easeInOutBack, parent: animationController));
    translacaoList[3] = Tween<double>(begin: -20, end: 0).animate(
        CurvedAnimation(
            curve: Curves.easeInOutBack, parent: animationController));
    translacaoList[4] = Tween<double>(begin: -10, end: 0).animate(
        CurvedAnimation(
            curve: Curves.easeInOutBack, parent: animationController));
    translacaoList[5] = Tween<double>(begin: -20, end: 0).animate(
        CurvedAnimation(
            curve: Curves.easeInOutBack, parent: animationController));
    translacaoList[6] =
        Tween<double>(begin: 0, end: 0).animate(animationController);
    animationController.forward();
  }
  

Future<String> getDeviceId(BuildContext context) async {
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  if (Theme.of(context).platform == TargetPlatform.iOS) {
    IosDeviceInfo iosDeviceInfo = await deviceInfo.iosInfo;
    return iosDeviceInfo.identifierForVendor; // unique ID on iOS
  } else {
    AndroidDeviceInfo androidDeviceInfo = await deviceInfo.androidInfo;
    return androidDeviceInfo.androidId; // unique ID on Android
  }
}
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        showDialog(
          context: context,
          child: CustomDialogConfirmation(
            title: "Logout",
            description: "Tem certeza de que deseja sair?",
            buttonCancelText: "Cancelar",
            buttonOkText: "Sair",
            funcaoBotaoCancelar: () {
              Navigator.pop(context);
            },                                                                                 
            funcaoBotaoOk: () {
              animationController.reverse().then(
                (animation) async {
                  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
                  sharedPreferences.remove('token');
                  sharedPreferences.remove('idLoja');
                  Navigator.popAndPushNamed(context, "/Login");
                },
              );
            },
          )
        );
        return Future.value(false);
      },
      child: SafeArea(
        child: Stack(
          children: <Widget>[
            Scaffold(
              backgroundColor: Theme.of(context).primaryColor,
              body: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  AnimatedBuilder(
                    animation: animationController,
                    builder: (BuildContext context, Widget child) {
                      return Transform.translate(
                      offset: Offset(translacaoList[0].value * -40, translacaoList[0].value * 0),
                      child: Column(
                        children: <Widget>[
                          Container(
                            child: Image.asset(
                              'assets/logomarcafluggy.png',
                              fit: BoxFit.fitWidth,
                              height: 80,
                              color: Colors.white,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 10),
                            child: Image.asset(
                              'assets/palavraFluggy.png',
                              fit: BoxFit.fitWidth,
                              height: 40,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    );
                    }
                  ),
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                           AnimatedBuilder(
                            animation: animationController,
                            builder: (BuildContext context, Widget child) {
                              return customMenuDialog(
                                context: context,
                                nome: "Produto",
                                offSetdx: translacaoList[0].value * 20,
                                offSetdy: translacaoList[0].value * 0,
                                sizedBoxHeight: 100,
                                image: Image.asset(
                                  'assets/produtoIcon.png',
                                  fit: BoxFit.contain,
                                  height: 50,
                                ),
                                onTap: () {
                                  animationController.reverse().then(
                                    (animation) {
                                      Navigator.push(context,
                                        PageRouteBuilder(
                                          pageBuilder: (BuildContext context, _, __) => ProdutoModule(),
                                          settings: RouteSettings(name: '/ListaProduto'),
                                          transitionsBuilder: (___, Animation<double> animation, ____, Widget child) {
                                            return FadeTransition(
                                              opacity: animation,
                                              child: child,
                                            );
                                          }
                                        )
                                      );
                                    },
                                  );
                                },
                              );
                            }
                          ),
                          AnimatedBuilder(
                            animation: animationController,
                            builder: (BuildContext context, Widget child) {
                              return customMenuDialog(
                                context: context,
                                nome: "Logs",
                                offSetdx: translacaoList[5].value * 20,
                                offSetdy: translacaoList[5].value * 0,
                                sizedBoxHeight: 60,
                                image: Icon(Icons.assignment, color: Colors.white, size: 30,),
                                onTap: () {
                                  animationController.reverse().then(
                                    (animation) {
                                      Navigator.push(context,
                                        PageRouteBuilder(
                                          pageBuilder: (BuildContext context, _, __) => ConsultaLogPage(),
                                          transitionsBuilder: (___, Animation<double> animation, ____, Widget child) {
                                            return FadeTransition(
                                              opacity: animation,
                                              child: child,
                                            );
                                          }
                                        )
                                      );
                                    },
                                  );
                                },
                              );
                            }
                          ),
                          AnimatedBuilder(
                            animation: animationController,
                            builder: (BuildContext context, Widget child) {
                              return customMenuDialog(
                                context: context,
                                nome: "Configuração",
                                offSetdx: translacaoList[2].value * -20,
                                offSetdy: translacaoList[2].value * 0,
                                sizedBoxHeight: 100,
                                image: Image.asset(
                                  'assets/configuracaoIcon.png',
                                  fit: BoxFit.contain,
                                  height: 40,
                                ),
                                onTap: () {
                                  animationController.reverse().then(
                                    (animation) {
                                      Navigator.push(context,
                                        PageRouteBuilder(
                                          pageBuilder: (BuildContext context, _, __) => AjustesModule(),
                                          settings: RouteSettings(name: '/MenuConfiguracao'),
                                          transitionsBuilder: (___, Animation<double> animation, ____, Widget child) {
                                            return FadeTransition(
                                              opacity: animation,
                                              child: child,
                                            );
                                          }
                                        )
                                      );
                                    },
                                  );
                                },
                                onLongPress: () {
                                  animationController.reverse().then(
                                    (animation) {
                                      Navigator.push(context,
                                        PageRouteBuilder(
                                          pageBuilder: (BuildContext context, _, __) => ConsultaVendaModule(),
                                          transitionsBuilder: (___, Animation<double> animation, ____, Widget child) {
                                            return FadeTransition(
                                              opacity: animation,
                                              child: child,
                                            );
                                          }
                                        )
                                      );
                                    },
                                  );
                                }
                              );
                            }
                          ),
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                         Visibility(
                           visible: false,
                           child: AnimatedBuilder(
                            animation: animationController,
                            builder: (BuildContext context, Widget child) {
                              return customMenuDialog(
                                context: context,
                                nome: "Cadastro",
                                offSetdx: translacaoList[0].value * 20,
                                offSetdy: translacaoList[0].value * 0,
                                sizedBoxHeight: 120,
                                image: Image.asset(
                                  'assets/cadastroIcon.png',
                                  fit: BoxFit.contain,
                                  height: 50,
                                ),
                                onTap: () {
                                  animationController.reverse().then(
                                    (animation) {
                                      Navigator.push(context,
                                        PageRouteBuilder(
                                          pageBuilder: (BuildContext context, _, __) => CadastroPage(),
                                          settings: RouteSettings(name: '/MenuCadastro'),
                                          transitionsBuilder: (___, Animation<double> animation, ____, Widget child) {
                                            return FadeTransition(
                                              opacity: animation,
                                              child: child,
                                            );
                                          }
                                        )
                                      );
                                    },
                                  );
                                },
                              );
                            }
                          ),
                         ),
                        AnimatedBuilder(
                          animation: animationController,
                          builder: (BuildContext context, Widget child) {
                            return customMenuDialog(
                              context: context,
                              nome: "Dashboard",
                              offSetdx: translacaoList[1].value * -0,
                              offSetdy: translacaoList[1].value * -28,
                              sizedBoxHeight: 100,
                              image: Image.asset(
                                'assets/dashboardIcon.png',
                                fit: BoxFit.contain,
                                height: 40,
                              ),
                              onTap: () async {
                                //print("DeviceID: " + await getDeviceId(context));
                                // showDialog(
                                //   context: context,
                                //   child: CustomDialogConfirmation(
                                //     title: "Teste",
                                //     description: "DeviceID: " + await getDeviceId(context),
                                //     buttonCancelText: "Cancelar",
                                //     buttonOkText: "Sair",
                                //     funcaoBotaoCancelar: () {
                                //       Navigator.pop(context);
                                //     },                                                                                 
                                //     funcaoBotaoOk: () {

                                //     },
                                //   )
                                // );                                
                                animationController.reverse().then(
                                  (animation) {
                                    Navigator.push(context,
                                      PageRouteBuilder(
                                        pageBuilder: (BuildContext context, _, __) => DashboardModule(),
                                        settings: RouteSettings(name: '/Dashboard'),
                                        transitionsBuilder: (___, Animation<double> animation, ____, Widget child) {
                                          return FadeTransition(
                                            opacity: animation,
                                            child: child,
                                          );
                                        }
                                      )
                                    );
                                  },
                                );
                              },
                            );
                          }
                        ),
                        

                          AnimatedBuilder(
                            animation: animationController,
                            builder: (BuildContext context, Widget child) {
                              return customMenuDialog(
                                context: context,
                                nome: "Venda",
                                offSetdx: translacaoList[5].value * 20,
                                offSetdy: translacaoList[5].value * 0,
                                sizedBoxHeight: 180,
                                image: Image.asset(
                                  'assets/vendaIcon.png',
                                  fit: BoxFit.contain,
                                  height: 50,
                                ),
                                onTap: () {
                                  animationController.reverse().then(
                                    (animation) {
                                      Navigator.pop(context);
                                      Navigator.push(context,
                                        PageRouteBuilder(
                                          pageBuilder: (BuildContext context, _, __) => VendaModule(),
                                          settings: RouteSettings(name: '/Venda'),
                                          transitionsBuilder: (___, Animation<double> animation, ____, Widget child) {
                                            return FadeTransition(
                                              opacity: animation,
                                              child: child,
                                            );
                                          }
                                        )
                                      );
                                    },
                                  );
                                },
                              );
                            }
                          ),
                          ],
                        )
                      ],
                    ),
                  ),
                  AnimatedBuilder(
                    animation: animationController,
                    builder: (BuildContext context, Widget child) {
                      return customMenuDialog(
                        context: context,
                        nome: "Sair",
                        offSetdx: translacaoList[5].value * 20,
                        offSetdy: translacaoList[5].value * 0,
                        backgroundColor: Colors.transparent,
                        sizedBoxHeight: 70,
                        image: Image.asset(
                          'assets/logoffIcon.png',
                          fit: BoxFit.contain,
                          height: 40,
                        ),
                        onTap: () {
                          showDialog(
                            context: context,
                            child: CustomDialogConfirmation(
                              title: "Logout",
                              description: "Tem certeza de que deseja sair?",
                              buttonCancelText: "Cancelar",
                              buttonOkText: "Sair",
                              funcaoBotaoCancelar: () {
                                Navigator.pop(context);
                              },                                                                                 
                              funcaoBotaoOk: () {
                                animationController.reverse().then(
                                  (animation) async {
                                    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
                                    sharedPreferences.remove('token');
                                    sharedPreferences.remove('idLoja');
                                    Navigator.popAndPushNamed(context, "/Login");
                                  },
                                );
                              },
                            )
                          );
                        },
                      );
                    }
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
