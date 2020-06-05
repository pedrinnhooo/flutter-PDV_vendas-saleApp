import 'package:common_files/common_files.dart';
import 'package:fluggy/generated/locale_base.dart';
import 'package:fluggy/src/app_module.dart';
import 'package:fluggy/src/pages/cadastro/servico/servico_module.dart';
import 'package:flutter/material.dart';
import 'package:fluggy/src/pages/cadastro/cliente/cliente_module.dart';
import 'package:fluggy/src/pages/cadastro/produto/produto_module.dart';

class CadastroPage extends StatefulWidget {
  CadastroPage({Key key}) : super(key: key);

  @override
  _CadastroPageState createState() => _CadastroPageState();
}

class _CadastroPageState extends State<CadastroPage> with SingleTickerProviderStateMixin {
  AnimationController animationController;
  List<Animation<double>> translacaoList;
  AppGlobalBloc appGlobalBloc;

  @override
  void initState() {
    super.initState();
    appGlobalBloc = AppModule.to.getBloc<AppGlobalBloc>();
    animationController = AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    translacaoList = List<Animation<double>>(7);
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
        CurvedAnimation(curve: Curves.easeInOutBack, parent: animationController));
    translacaoList[1] = Tween<double>(begin: 24, end: 0).animate(
        CurvedAnimation(curve: Curves.easeInOutBack, parent: animationController));
    translacaoList[2] = Tween<double>(begin: -24, end: 0).animate(
        CurvedAnimation(curve: Curves.easeInOutBack, parent: animationController));
    translacaoList[3] = Tween<double>(begin: -20, end: 0).animate(
        CurvedAnimation(curve: Curves.easeInOutBack, parent: animationController));
    translacaoList[4] = Tween<double>(begin: -10, end: 0).animate(
        CurvedAnimation(curve: Curves.easeInOutBack, parent: animationController));
    translacaoList[5] = Tween<double>(begin: -20, end: 0).animate(
        CurvedAnimation(curve: Curves.easeInOutBack, parent: animationController));
    translacaoList[6] = Tween<double>(begin: 0, end: 0).animate(CurvedAnimation(
        curve: Curves.easeInOutBack, parent: animationController));
    animationController.forward();
  }

  @override
  Widget build(BuildContext context) {

  final locale = Localizations.of<LocaleBase>(context, LocaleBase);

    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            AnimatedBuilder(
              animation: animationController,
              builder: (BuildContext context, Widget child) {
                return Transform.translate(
                  offset: Offset(translacaoList[2].value * -20, translacaoList[2].value * 0),
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Image.asset(
                          'assets/logomarcafluggy.png',
                          fit: BoxFit.contain,
                          height: 80,
                        ),
                      ),
                      Text("CADASTRO", textAlign: TextAlign.center, style: Theme.of(context).textTheme.title),
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
                            nome: locale.cadastroProduto.titulo,
                            offSetdx: translacaoList[0].value * 20,
                            offSetdy: translacaoList[0].value * 0,
                            sizedBoxHeight: 260,
                            image: Image.asset(
                              'assets/produtoIcon.png',
                              fit: BoxFit.contain,
                              height: 50,
                            ),
                            onTap: () {
                              animationController.reverse().then((animation) {
                                Navigator.push(context,
                                  PageRouteBuilder(
                                    pageBuilder:(BuildContext context, _, __) => ProdutoModule(),
                                    settings: RouteSettings(name: '/ListaProduto'),
                                    transitionsBuilder: (___, Animation<double> animation, ____, Widget child) {
                                      return FadeTransition(
                                        opacity: animation,
                                        child: child,
                                      );
                                    }
                                  )
                                );
                              });
                            }
                          );
                        }
                      ),
                    ],
                  ),
                  FutureBuilder(
                    future: appGlobalBloc.getModuloAcesso(ModuloEnum.servico),
                    builder: (context, snapshot){
                      return  Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          AnimatedSwitcher(
                            duration: Duration(milliseconds: 200),
                            switchInCurve: Curves.easeIn,
                            switchOutCurve: Curves.easeOut,
                            child: snapshot.connectionState == ConnectionState.done && snapshot.hasData && snapshot.data == true ? AnimatedBuilder(
                              animation: animationController,
                              builder: (BuildContext context, Widget child) {
                                return customMenuDialog(
                                  context: context,
                                  nome: "Serviço",
                                  offSetdx: translacaoList[2].value * 0,
                                  offSetdy: translacaoList[2].value * 20,
                                  sizedBoxHeight: 120,
                                  image: Image.asset(
                                    'assets/servicoIcon.png',
                                    fit: BoxFit.contain,
                                    height: 50,
                                  ),
                                  onTap: () {
                                    animationController.reverse().then((animation) {
                                      Navigator.push(context, 
                                        PageRouteBuilder(
                                          pageBuilder:(BuildContext context, _, __) => ServicoModule(),
                                          settings: RouteSettings(name: '/ListaServico'),
                                          transitionsBuilder: (___, Animation<double> animation, ____, Widget child) {
                                            return FadeTransition(
                                              opacity: animation,
                                              child: child,
                                            );
                                          }
                                        )
                                      );
                                    });
                                  }
                                );
                              }
                            ) : SizedBox.shrink(),
                          ),
                          AnimatedBuilder(
                            animation: animationController,
                            builder: (BuildContext context, Widget child) {
                              return customMenuDialog(
                                context: context,
                                nome: locale.cadastroCliente.titulo,
                                offSetdx: translacaoList[5].value * -20,
                                offSetdy: translacaoList[5].value * 0,
                                sizedBoxHeight:snapshot.connectionState == ConnectionState.done && snapshot.hasData && snapshot.data == true ? 120 : 260,
                                image: Image.asset(
                                  'assets/clienteIcon.png',
                                  fit: BoxFit.contain,
                                  height: 50,
                                ),
                                onTap: () {
                                  animationController.reverse().then((animation) {
                                    Navigator.push(context,
                                        PageRouteBuilder(
                                          pageBuilder: (BuildContext context, _, __) =>  ClienteModule(),
                                          settings: RouteSettings(name: '/ListaCliente'),
                                          transitionsBuilder: (___, Animation<double> animation, ____,  Widget child) {
                                          return FadeTransition(
                                            opacity: animation,
                                            child: child,
                                          );
                                        },
                                      ),
                                    );
                                  });
                                },
                              );
                            },
                          ),
                        ],
                      );
                    }
                  )
                ],
              ),
            ),
            AnimatedBuilder(
              animation: animationController,
              builder: (BuildContext context, Widget child) {
                return customMenuDialog(
                  context: context,
                  nome: "Voltar",
                  offSetdx: translacaoList[5].value * 20,
                  offSetdy: translacaoList[5].value * 0,
                  sizedBoxHeight: 70,
                  backgroundColor: Colors.transparent,
                  image: Image.asset(
                    'assets/voltarIcon.png',
                    fit: BoxFit.contain,
                    height: 40,
                  ),
                  onTap: () {
                    animationController.reverse().then((animation) {
                      Navigator.pop(context);
                    });
                  },
                );
              }
            )
          ],
        ),
      ),
    );
  }
}
