import 'package:common_files/common_files.dart';
import 'package:fluggy/generated/locale_base.dart';
import 'package:fluggy/src/pages/configuracao/ajustes/ajustes_module.dart';
import 'package:fluggy/src/pages/configuracao/cupom_layout/cupom_layout_module.dart';
import 'package:fluggy/src/pages/configuracao/loja/loja_module.dart';
import 'package:fluggy/src/pages/configuracao/tipo_pagamento/tipo_pagamento_module.dart';
import 'package:flutter/material.dart';
import 'package:fluggy/src/pages/configuracao/terminal/terminal_module.dart';
import 'package:fluggy/src/pages/configuracao/transacao/transacao_module.dart';
import 'package:fluggy/src/pages/configuracao/vendedor/vendedor_module.dart';

class ConfiguracaoPage extends StatefulWidget {
  ConfiguracaoPage({Key key}) : super(key: key);

  @override
  _ConfiguracaoPageState createState() => _ConfiguracaoPageState();
}

class _ConfiguracaoPageState extends State<ConfiguracaoPage> with SingleTickerProviderStateMixin {
  AnimationController animationController;
  List<Animation<double>> translacaoList;

  @override
  void initState() {
    super.initState();
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
    translacaoList[6] = Tween<double>(begin: -30, end: 0).animate(CurvedAnimation(
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
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            AnimatedBuilder(
              animation: animationController,
              builder: (BuildContext context, Widget child) {
                return Transform.translate(
                  offset: Offset(translacaoList[6].value * 0, translacaoList[6].value * 20),
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
                      Text("CONFIGURAÇÃO", textAlign: TextAlign.center, style: Theme.of(context).textTheme.title,),
                    ],
                  ),
                );
              }
            ),
            Container(
              child: Center(
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
                              nome: "Loja",
                              offSetdx: translacaoList[1].value * -0,
                              offSetdy: translacaoList[1].value * -30,
                              image: Image.asset(
                                'assets/lojaIcon.png',
                                fit: BoxFit.contain,
                                height: 50,
                              ),
                              sizedBoxHeight: 160,
                              onTap: () {
                                  animationController.reverse().then((animation) {
                                  Navigator.of(context).push(
                                    PageRouteBuilder(
                                      pageBuilder: (BuildContext context, _, __) => LojaModule(),
                                      settings: RouteSettings(name: '/ConfiguracaoLoja'),
                                      transitionsBuilder: (___, Animation<double> animation, ____, Widget child) {
                                        return FadeTransition(
                                          opacity: animation,
                                          child: child,
                                        );
                                      }
                                    ),
                                  );
                                });
                              }
                            );
                          },
                        ),
                        AnimatedBuilder(
                          animation: animationController,
                          builder: (BuildContext context, Widget child) {
                            return customMenuDialog(
                              context: context,
                              nome: "Ajustes",
                              offSetdx: translacaoList[3].value * -0,
                              offSetdy: translacaoList[3].value * -30,
                              image: Image.asset(
                                'assets/ajustesIcon.png',
                                fit: BoxFit.contain,
                                height: 40,
                              ),
                              sizedBoxHeight: 80,
                              onTap: () {
                                animationController.reverse().then((animation) {
                                  Navigator.of(context).push(
                                    PageRouteBuilder(
                                      pageBuilder: (BuildContext context, _, __) => AjustesModule(),
                                      settings: RouteSettings(name: '/ConfiguracaoAjustes'),
                                      transitionsBuilder: (___, Animation<double> animation, ____, Widget child) {
                                        return FadeTransition(
                                          opacity: animation,
                                          child: child,
                                        );
                                      }
                                    ),
                                  );
                                });
                              }
                            );
                          }
                        ),
                        AnimatedBuilder(
                          animation: animationController,
                          builder: (BuildContext context, Widget child) {
                            return customMenuDialog(
                              context: context,
                              nome: "Transação",
                              offSetdx: translacaoList[0].value * 20,
                              offSetdy: translacaoList[0].value * 0,
                              image: Icon(Icons.compare_arrows,size: 30,color: Colors.white,),
                              sizedBoxHeight: 80,
                              onTap: () {
                                animationController.reverse().then((animation) {
                                  Navigator.of(context).push(
                                    PageRouteBuilder(
                                      pageBuilder: (BuildContext context, _, __) => TransacaoModule(),
                                      settings: RouteSettings(name: '/ConfiguracaoTransacao'),
                                      transitionsBuilder: (___, Animation<double> animation, ____, Widget child) {
                                        return FadeTransition(
                                          opacity: animation,
                                          child: child,
                                        );
                                      }
                                    ),
                                  );
                                });
                              }
                            );
                          }
                        ),
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                         AnimatedBuilder(
                            animation: animationController,
                            builder: (BuildContext context, Widget child) {
                              return customMenuDialog(
                                context: context,
                                nome: locale.cadastroVendedor.titulo,
                                offSetdx: translacaoList[0].value * 0,
                                offSetdy: translacaoList[0].value * -60,
                                sizedBoxHeight: 120,
                                image: Image.asset(
                                  'assets/vendedorIcon.png',
                                  fit: BoxFit.contain,
                                  height: 40,
                                ),
                                onTap: () {
                                  animationController.reverse().then((animation) {
                                    Navigator.push(context,
                                      PageRouteBuilder(
                                        pageBuilder:(BuildContext context, _, __) => VendedorModule(),
                                        settings: RouteSettings(name: '/ListaVendedor'),
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
                        AnimatedBuilder(
                          animation: animationController,
                          builder: (BuildContext context, Widget child) {
                            return customMenuDialog(
                              context: context,
                              nome: "Terminal",
                              offSetdx: translacaoList[3].value * -0,
                              offSetdy: translacaoList[3].value * -30,
                              image: Image.asset(
                                'assets/terminalIcon.png',
                                fit: BoxFit.contain,
                                height: 40,
                              ),
                              sizedBoxHeight: 80,
                              onTap: () {
                                animationController.reverse().then((animation) {
                                  Navigator.of(context).push(
                                    PageRouteBuilder(
                                      pageBuilder: (BuildContext context, _, __) => TerminalModule(),
                                      settings: RouteSettings(name: '/ConfiguracaoTerminal'),
                                      transitionsBuilder: (___, Animation<double> animation, ____, Widget child) {
                                        return FadeTransition(
                                          opacity: animation,
                                          child: child,
                                        );
                                      }
                                    ),
                                  );
                                });
                              },
                            );
                          }
                        ),
                        AnimatedBuilder(
                          animation: animationController,
                          builder: (BuildContext context, Widget child) {
                            return customMenuDialog(
                              context: context,
                              nome: "Tipo de pagamento",
                              offSetdx: translacaoList[4].value * -20,
                              offSetdy: translacaoList[4].value * 0,
                              image: Icon(Icons.store,size: 40,color: Colors.white,),
                              sizedBoxHeight: 120,
                              onTap: () {
                                animationController.reverse().then((animation) {
                                  Navigator.of(context).push(
                                    PageRouteBuilder(
                                      pageBuilder: (BuildContext context, _, __) => TipoPagamentoModule(),
                                      settings: RouteSettings(name: '/ConfiguracaoTipoPagamento'),
                                      transitionsBuilder: (___, Animation<double> animation, ____, Widget child) {
                                        return FadeTransition(
                                          opacity: animation,
                                          child: child,
                                        );
                                      }
                                    ),
                                  );
                                });
                              },
                            );
                          }
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
            AnimatedBuilder(
              animation: animationController,
              builder: (BuildContext context, Widget child) {
                return customMenuDialog(
                  context: context,
                  nome: "Voltar",
                  offSetdx: translacaoList[4].value * -20,
                  offSetdy: translacaoList[4].value * 0,
                  image: Image.asset(
                    'assets/voltarIcon.png',
                    fit: BoxFit.contain,
                    height: 40,
                  ),
                  backgroundColor: Colors.transparent,
                  sizedBoxHeight: 120,
                  onTap: () {
                    animationController.reverse().then((animation) {
                      Navigator.pop(context);
                    });
                  },
                );
              }
            ),
          ],
        ),
      ),
    );
  }
}
