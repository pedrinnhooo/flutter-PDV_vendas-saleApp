import 'package:common_files/common_files.dart';
import 'package:fluggy/src/app_module.dart';
import 'package:fluggy/src/pages/cadastro/categoria/categoria_module.dart';
import 'package:fluggy/src/pages/cadastro/cliente/cliente_module.dart';
import 'package:fluggy/src/pages/cadastro/grade/grade_module.dart';
import 'package:fluggy/src/pages/cadastro/produto/produto_module.dart';
import 'package:fluggy/src/pages/cadastro/servico/servico_module.dart';
import 'package:fluggy/src/pages/cadastro/variante/variante_module.dart';
import 'package:fluggy/src/pages/configuracao/ajustes/ajustes_module.dart';
import 'package:fluggy/src/pages/configuracao/loja/loja_module.dart';
import 'package:fluggy/src/pages/configuracao/terminal/terminal_module.dart';
import 'package:fluggy/src/pages/configuracao/tipo_pagamento/tipo_pagamento_module.dart';
import 'package:fluggy/src/pages/configuracao/transacao/transacao_module.dart';
import 'package:fluggy/src/pages/configuracao/vendedor/vendedor_module.dart';
import 'package:fluggy/src/pages/operacao/login/login_module.dart';
import 'package:fluggy/src/pages/widgets/Drawer/oval-right-clipper.dart';
import 'package:fluggy/src/venda/consulta_movimento_cliente/consulta_movimento_cliente_detalhe/consulta_movimento_cliente_detalhe_page.dart';
import 'package:fluggy/src/venda/movimento_caixa/movimento_caixa_module.dart';
import 'package:fluggy/src/venda/venda_module.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DrawerApp extends StatefulWidget {
  @override
  _DrawerAppState createState() => _DrawerAppState();
}

class _DrawerAppState extends State<DrawerApp> {
  AppGlobalBloc appGlobalBloc;
 

  @override
  void initState() {
    super.initState();
    appGlobalBloc = AppModule.to.getBloc<AppGlobalBloc>();
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
            funcaoBotaoOk: () async {
              SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
              sharedPreferences.remove('token');
              sharedPreferences.remove('idLoja');
              Navigator.popAndPushNamed(context, "/Login");
            },
          )
        );
        return Future.value(false);
      },
      child: ClipPath(
        clipper: OvalRightBorderClipper(),
        child: Drawer(
          child: Container(
            width: 300,
            padding: const EdgeInsets.only(left: 16.0, right: 50),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor, boxShadow: [BoxShadow(color: Colors.black45)]
            ),
            child: SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    SizedBox(height: 40),
                    Text(
                      "${appGlobalBloc.loja.fantasiaApelido}",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18.0,
                          fontWeight: FontWeight.w600),
                    ),
                    Text(
                      "${appGlobalBloc.loja.razaoNome}",
                      style: TextStyle(color: Colors.grey, fontSize: 16.0),
                    ),
                    SizedBox(height: 30.0),
                    Divider(height: 3, color: Colors.white30),
                    ListTile(
                      leading: Image.asset(
                        'assets/produtoIcon.png',
                        fit: BoxFit.contain,
                        height: 24,
                      ),
                      title: Text("Produto", style: TextStyle(color:  Colors.white)),
                      onTap: () {
                        Navigator.of(context).pushAndRemoveUntil(
                          PageRouteBuilder(
                            pageBuilder: (c, a1, a2) => ProdutoModule(),
                            settings: RouteSettings(name: '/CadastroProduto'),
                            transitionsBuilder: (c, anim, a2, child) => FadeTransition(opacity: anim, child: child),
                            transitionDuration:Duration(milliseconds: 180),
                          ),
                          (Route<dynamic> route) {
                            if(route.settings.name == '/Venda' || route.settings.name == "/Dashboard" || route.settings.name == '/ConfiguracaoAjustes'){
                              return false;
                            }
                            return true;
                          }
                        );
                      },
                    ),
                    Divider(height: 3, color: Colors.white30),
                    Visibility(
                      visible: false,
                      child: ExpansionTile(
                        leading: Icon(Icons.library_books, color: Theme.of(context).primaryIconTheme.color),
                        title: Text("Cadastros", style: TextStyle(color:  Colors.white)),
                        children: <Widget>[
                          ListTile(
                           onTap: () {
                             Navigator.push(context,
                              PageRouteBuilder(
                                pageBuilder: (c, a1, a2) => ProdutoModule(),
                                settings: RouteSettings(name: '/CadastroProduto'),
                                transitionsBuilder: (c, anim, a2, child) => FadeTransition(opacity: anim, child: child),
                                transitionDuration:Duration(milliseconds: 180),
                              ),
                            );
                           },
                           title: Row(
                            children: <Widget>[
                              Text("---",style: TextStyle(color: Theme.of(context).primaryIconTheme.color, fontSize: 13)),
                              Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Text("Produto",style: TextStyle(color: Colors.white, fontSize: 13)),
                              ),
                            ],
                           ),
                          ),
                           ListTile(
                           onTap: () {
                             Navigator.push(context,
                              PageRouteBuilder(
                                pageBuilder: (c, a1, a2) => GradeModule(),
                                settings: RouteSettings(name: '/CadastroGrade'),
                                transitionsBuilder: (c, anim, a2, child) => FadeTransition(opacity: anim, child: child),
                                transitionDuration:Duration(milliseconds: 180),
                              ),
                            );
                           },
                           title: Row(
                            children: <Widget>[
                              Text("---",style: TextStyle(color: Theme.of(context).primaryIconTheme.color, fontSize: 13)),
                              Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Text("Grade",style: TextStyle(color: Colors.white, fontSize: 13)),
                              ),
                            ],
                           ),
                          ),
                           ListTile(
                           onTap: () {
                             Navigator.push(context,
                              PageRouteBuilder(
                                pageBuilder: (c, a1, a2) => CategoriaModule(),
                                settings: RouteSettings(name: '/CadastroCategoria'),
                                transitionsBuilder: (c, anim, a2, child) => FadeTransition(opacity: anim, child: child),
                                transitionDuration:Duration(milliseconds: 180),
                              ),
                            );
                           },
                           title: Row(
                            children: <Widget>[
                              Text("---",style: TextStyle(color: Theme.of(context).primaryIconTheme.color, fontSize: 13)),
                              Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Text("Categoria",style: TextStyle(color: Colors.white, fontSize: 13)),
                              ),
                            ],
                           ),
                          ),
                           ListTile(
                           onTap: () {
                             Navigator.push(context,
                              PageRouteBuilder(
                                pageBuilder: (c, a1, a2) => VarianteModule(),
                                settings: RouteSettings(name: '/CadastroVariante'),
                                transitionsBuilder: (c, anim, a2, child) => FadeTransition(opacity: anim, child: child),
                                transitionDuration:Duration(milliseconds: 180),
                              ),
                            );
                           },
                           title: Row(
                            children: <Widget>[
                              Text("---",style: TextStyle(color: Theme.of(context).primaryIconTheme.color, fontSize: 13)),
                              Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Text("Variante",style: TextStyle(color: Colors.white, fontSize: 13)),
                              ),
                            ],
                           ),
                          ),
                           ListTile(
                           onTap: () {
                             Navigator.push(context,
                              PageRouteBuilder(
                                pageBuilder: (c, a1, a2) => ServicoModule(),
                                settings: RouteSettings(name: '/CadastroServico'),
                                transitionsBuilder: (c, anim, a2, child) => FadeTransition(opacity: anim, child: child),
                                transitionDuration:Duration(milliseconds: 180),
                              ),
                            );
                           },
                           title: Row(
                            children: <Widget>[
                              Text("---",style: TextStyle(color: Theme.of(context).primaryIconTheme.color, fontSize: 13)),
                              Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Text("Serviço",style: TextStyle(color: Colors.white, fontSize: 13)),
                              ),
                            ],
                           ),
                          ),
                           ListTile(
                           onTap: () {
                             Navigator.push(context,
                              PageRouteBuilder(
                                pageBuilder: (c, a1, a2) => ClienteModule(),
                                settings: RouteSettings(name: '/CadastroCliente'),
                                transitionsBuilder: (c, anim, a2, child) => FadeTransition(opacity: anim, child: child),
                                transitionDuration:Duration(milliseconds: 180),
                              ),
                            );
                           },
                           title: Row(
                            children: <Widget>[
                              Text("---",style: TextStyle(color: Theme.of(context).primaryIconTheme.color, fontSize: 13)),
                              Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Text("Cliente",style: TextStyle(color: Colors.white, fontSize: 13)),
                              ),
                            ],
                           ),
                          ),
                        ],
                      ),
                    ),
                    Visibility(visible: false, child: Divider(height: 3, color: Colors.white30)),
                    Visibility(
                      visible: false,
                      child: ListTile(
                        leading: Icon(Icons.store, color: Theme.of(context).primaryIconTheme.color),
                        title: Text("Caixa", style: TextStyle(color:  Colors.white)),
                        onTap: () {
                          Navigator.push(context,
                            PageRouteBuilder(
                              pageBuilder: (c, a1, a2) => MovimentoCaixaModule(),
                              settings: RouteSettings(name: '/ListaMovimentoCaixa'),
                              transitionsBuilder: (c, anim, a2, child) => FadeTransition(opacity: anim, child: child),
                              transitionDuration:Duration(milliseconds: 180),
                            ),
                          );
                        },
                      ),
                    ),
                    Visibility(visible: false, child: Divider(height: 3, color: Colors.white30)),
                    ListTile(
                      leading: Image.asset(
                        'assets/dashboardIcon.png',
                        fit: BoxFit.contain,
                        height: 24,
                      ),
                      title: Text("Dashboard", style: TextStyle(color:  Colors.white)),
                      onTap: () {
                        Navigator.popAndPushNamed(context, '/Dashboard');
                      },
                    ),
                    Visibility(visible: true, child: Divider(height: 3, color: Colors.white30)),
                    Visibility(
                      visible: false,
                      child: ListTile(
                        leading: Icon(Icons.attach_money, color: Theme.of(context).primaryIconTheme.color),
                        title: Text("Conta cliente", style: TextStyle(color:  Colors.white)),
                        onTap: () {
                          Navigator.push(context,
                            PageRouteBuilder(
                              pageBuilder: (c, a1, a2) => ConsultaMovimentoClienteDetalhePage(),
                              settings: RouteSettings(name: '/ListaMovimentoCliente'),
                              transitionsBuilder: (c, anim, a2, child) => FadeTransition(opacity: anim, child: child),
                              transitionDuration:Duration(milliseconds: 180),
                            ),
                          );
                        },
                      ),
                    ),
                    Visibility(visible: false, child: Divider(height: 3, color: Colors.white30)),
                    ListTile(
                      leading: Image.asset(
                        'assets/vendaIcon.png',
                        fit: BoxFit.contain,
                        height: 24,
                      ),
                      title: Text("Venda", style: TextStyle(color:  Colors.white)),
                      onTap: () {
                          Navigator.of(context).pushAndRemoveUntil(
                          PageRouteBuilder(
                            pageBuilder: (c, a1, a2) => VendaModule(),
                            settings: RouteSettings(name: '/Venda'),
                            transitionsBuilder: (c, anim, a2, child) => FadeTransition(opacity: anim, child: child),
                            transitionDuration:Duration(milliseconds: 180),
                          ),
                          (Route<dynamic> route) {
                            if(route.settings.name == '/CadastroProduto' || route.settings.name == "/Dashboard" || route.settings.name == '/ConfiguracaoAjustes'){
                              return false;
                            }
                            return true;
                          }
                        );
                      },
                    ),
                    Divider(height: 3, color: Colors.white30),
                    ListTile(
                      leading: Image.asset(
                        'assets/configuracaoIcon.png',
                        fit: BoxFit.contain,
                        height: 24,
                      ),
                      title: Text("Ajustes",style: TextStyle(color: Colors.white, fontSize: 13)),
                      onTap: () {
                        Navigator.of(context).pushAndRemoveUntil(
                          PageRouteBuilder(
                            pageBuilder: (c, a1, a2) => AjustesModule(),
                            settings: RouteSettings(name: '/ConfiguracaoAjustes'),
                            transitionsBuilder: (c, anim, a2, child) => FadeTransition(opacity: anim, child: child),
                            transitionDuration:Duration(milliseconds: 180),
                          ),
                          (Route<dynamic> route) {
                            if(route.settings.name == '/CadastroProduto' || route.settings.name == "/Dashboard" || route.settings.name == '/Venda'){
                              return false;
                            }
                            return true;
                          }
                        );
                      },
                    ),
                    Visibility(
                      visible: false,
                      child: ExpansionTile(
                        leading: Icon(Icons.settings, color: Theme.of(context).primaryIconTheme.color),
                        title: Text("Configurações", style: TextStyle(color:  Colors.white)),
                        children: <Widget>[
                          Visibility(
                            visible: false,
                            child: ListTile(
                              title: Row(
                                children: <Widget>[
                                  Text("---",style: TextStyle(color: Theme.of(context).primaryIconTheme.color, fontSize: 13)),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 8.0),
                                    child: Text("Loja",style: TextStyle(color: Colors.white, fontSize: 13)),
                                  ),
                                ],
                              ),
                              onTap: () {
                                Navigator.push(context,
                                  PageRouteBuilder(
                                    pageBuilder: (c, a1, a2) => LojaModule(),
                                    settings: RouteSettings(name: '/ConfiguracaoLoja'),
                                    transitionsBuilder: (c, anim, a2, child) => FadeTransition(opacity: anim, child: child),
                                    transitionDuration:Duration(milliseconds: 180),
                                  ),
                                );
                              },
                            ),
                          ),
                          ListTile(
                            title: Row(
                              children: <Widget>[
                                Text("---",style: TextStyle(color: Theme.of(context).primaryIconTheme.color, fontSize: 13)),
                                Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: Text("Terminal",style: TextStyle(color: Colors.white, fontSize: 13)),
                                ),
                              ],
                            ),
                            onTap: () {
                              Navigator.push(context,
                                PageRouteBuilder(
                                  pageBuilder: (c, a1, a2) => TerminalModule(),
                                  settings: RouteSettings(name: '/ConfiguracaoTerminal'),
                                  transitionsBuilder: (c, anim, a2, child) => FadeTransition(opacity: anim, child: child),
                                  transitionDuration:Duration(milliseconds: 180),
                                ),
                              );
                            },
                          ),
                          Visibility(
                            visible: false,
                            child: ListTile(
                              title: Row(
                                children: <Widget>[
                                  Text("---",style: TextStyle(color: Theme.of(context).primaryIconTheme.color, fontSize: 13)),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 8.0),
                                    child: Text("Tipo de pagamento",style: TextStyle(color: Colors.white, fontSize: 13)),
                                  ),
                                ],
                              ),
                              onTap: () {
                                Navigator.push(context,
                                  PageRouteBuilder(
                                    pageBuilder: (c, a1, a2) => TipoPagamentoModule(),
                                    settings: RouteSettings(name: '/ConfiguracaoTipoPagamento'),
                                    transitionsBuilder: (c, anim, a2, child) => FadeTransition(opacity: anim, child: child),
                                    transitionDuration:Duration(milliseconds: 180),
                                  ),
                                );
                              },
                            ),
                          ),
                          Visibility(
                            visible: false,
                            child: ListTile(
                              title: Row(
                                children: <Widget>[
                                  Text("---",style: TextStyle(color: Theme.of(context).primaryIconTheme.color, fontSize: 13)),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 8.0),
                                    child: Text("Transação",style: TextStyle(color: Colors.white, fontSize: 13)),
                                  ),
                                ],
                              ),
                              onTap: () {
                                Navigator.push(context,
                                  PageRouteBuilder(
                                    pageBuilder: (c, a1, a2) => TransacaoModule(),
                                    settings: RouteSettings(name: '/ConfiguracaoTransacao'),
                                    transitionsBuilder: (c, anim, a2, child) => FadeTransition(opacity: anim, child: child),
                                    transitionDuration:Duration(milliseconds: 180),
                                  ),
                                );
                              },
                            ),
                          ),
                          Visibility(
                            visible: false,
                            child: ListTile(
                              title: Row(
                                children: <Widget>[
                                  Text("---",style: TextStyle(color: Theme.of(context).primaryIconTheme.color, fontSize: 13)),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 8.0),
                                    child: Text("Vendedor",style: TextStyle(color: Colors.white, fontSize: 13)),
                                  ),
                                ],
                              ),
                              onTap: () {
                                Navigator.push(context,
                                  PageRouteBuilder(
                                    pageBuilder: (c, a1, a2) => VendedorModule(),
                                    settings: RouteSettings(name: '/ConfiguracaoVendedor'),
                                    transitionsBuilder: (c, anim, a2, child) => FadeTransition(opacity: anim, child: child),
                                    transitionDuration:Duration(milliseconds: 180),
                                  ),
                                );
                              },
                            ),
                          ),
                          Visibility(
                            visible: true,
                            child: ListTile(
                              title: Row(
                                children: <Widget>[
                                  Text("---",style: TextStyle(color: Theme.of(context).primaryIconTheme.color, fontSize: 13)),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 8.0),
                                    child: Text("Ajustes",style: TextStyle(color: Colors.white, fontSize: 13)),
                                  ),
                                ],
                              ),
                              onTap: () {
                                  Navigator.push(context,
                                  PageRouteBuilder(
                                    pageBuilder: (c, a1, a2) => AjustesModule(),
                                    settings: RouteSettings(name: '/ConfiguracaoAjustes'),
                                    transitionsBuilder: (c, anim, a2, child) => FadeTransition(opacity: anim, child: child),
                                    transitionDuration:Duration(milliseconds: 180),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    Divider(height: 3, color: Colors.white30),
                    Container(
                      padding: EdgeInsets.only(left: 50, top: 50),
                      width: double.infinity,
                      child: ListTile(
                        title: Row(
                          children: <Widget>[
                            Image.asset(
                              'assets/logoffIcon.png',
                              fit: BoxFit.contain,
                              height: 28,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left : 8.0),
                              child: Text("Logout", style: TextStyle(color:  Colors.white)),
                            ),
                          ],
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
                              funcaoBotaoOk: () async {
                                SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
                                sharedPreferences.remove('token');
                                sharedPreferences.remove('idLoja');
                                Navigator.push(context,
                                  PageRouteBuilder(
                                    pageBuilder: (c, a1, a2) => LoginModule(),
                                    settings: RouteSettings(name: '/Login'),
                                    transitionsBuilder: (c, anim, a2, child) => FadeTransition(opacity: anim, child: child),
                                    transitionDuration:Duration(milliseconds: 180),
                                  ),
                                );
                              },
                            )
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}