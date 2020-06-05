import 'dart:convert';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:common_files/common_files.dart';
import 'package:fluggy/generated/locale_base.dart';
import 'package:fluggy/src/home/menu_page.dart';
import 'package:fluggy/src/pages/cadastro/cliente/cliente_module.dart';
import 'package:fluggy/src/pages/configuracao/vendedor/vendedor_module.dart';
import 'package:fluggy/src/pages/widgets/Drawer/drawer.dart';
import 'package:fluggy/src/venda/gridItemBuilder.dart';
import 'package:fluggy/src/venda/listItemBuilder.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/utils.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:fluggy/src/app_module.dart';
import 'package:fluggy/src/venda/carrinho/carrinho_page.dart';
import 'package:fluggy/src/venda/consulta_estoque/consulta_estoque_module.dart';
import 'package:fluggy/src/venda/grade/venda_grade_page.dart';
import 'package:fluggy/src/venda/pagamento/pagamento_page.dart';
import 'package:fluggy/src/venda/transacao/venda_transacao_module.dart';
import 'package:fluggy/src/venda/variante/venda_variante_page.dart';
import 'package:fluggy/src/venda/venda_bloc.dart';
import 'package:fluggy/src/venda/venda_module.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intercom_flutter/intercom_flutter.dart';
import 'dart:async';

class VendaPage extends StatefulWidget {
  const VendaPage({Key key}): super(key: key);
	@override
	_VendaPageState createState() => _VendaPageState();
}
class _VendaPageState extends State<VendaPage> {
   OverlayEntry overlayEntry;
  PageController pageController;
  TextEditingController pesquisaController;
  SharedVendaBloc vendaBloc;
  HasuraBloc hasuraBloc;
  SincronizacaoBloc _sincronizacaoBloc;
  ScrollController scrollController;
  PageController gridController; 
  GlobalKey<ScaffoldState> _scaffoldKey;
  MoneyMaskedTextController precoProduto;
  AppGlobalBloc appGlobalBloc = AppModule.to.getBloc<AppGlobalBloc>();
  BuildContext myContext;
  GlobalKey trilha = GlobalKey();
  GlobalKey categoriaPDV = GlobalKey();
  GlobalKey clienteVendedor = GlobalKey();
  GlobalKey produtoPrimeiraVenda = GlobalKey();
  GlobalKey botaoDirecionarCarrinho = GlobalKey();
  GlobalKey produtoSegundaVenda = GlobalKey();
  String nChat = "";

  @override
  void initState() {
    super.initState();
    _scaffoldKey  = GlobalKey<ScaffoldState>();
    vendaBloc = AppModule.to.getBloc<SharedVendaBloc>();
    // hasuraBloc = AppModule.to.getBloc<HasuraBloc>();
    _sincronizacaoBloc = AppModule.to.getBloc<SincronizacaoBloc>();
    pageController = VendaModule.to.bloc<VendaBloc>().pageController;
    gridController = VendaModule.to.bloc<VendaBloc>().gridController;
    pesquisaController = TextEditingController();
    pesquisaController.value = pesquisaController.value.copyWith(text: vendaBloc.filterText == "" ? "" : vendaBloc.filterText);
    scrollController = ScrollController(keepScrollOffset: true);
    precoProduto = MoneyMaskedTextController(leftSymbol: "R\$ ");
    init();
    //checkChat();
  }
 
  @override
  void dispose() {
    super.dispose();
  }

  init() async {
    await appGlobalBloc.updateConfiguracaoGeralStream();
    // await Intercom.registerIdentifiedUser(userId: appGlobalBloc.usuario.id.toString());
    // await Intercom.updateUser(
    //   userId: appGlobalBloc.usuario.id.toString(),
    //   name: appGlobalBloc.usuario.razaoNome, 
    //   email: appGlobalBloc.usuario.contato[0].email,
    //   phone: appGlobalBloc.usuario.contato[0].telefone1,  
    //   companyId: appGlobalBloc.usuario.idPessoaGrupo.toString(),
    // );
    
    loadTables();
  }

  checkChat() async {
    const oneSec = const Duration(seconds:5);
    new Timer.periodic(oneSec, (Timer t) async {
      int x = await Intercom.unreadConversationCount();
      setState(() {
        print("x: ${x.toString()}");
        nChat = x.toString();
      });
    });
  }

  loadTables() async {
    while (!await vendaBloc.primeiraSincronizacaoFinalizada()) {
      //print(" ************************* Não terminou *************************");
    }
    vendaBloc.appGlobalBloc.getMenu();
    await vendaBloc.initBloc();
    // await vendaBloc.getallProduto();
    await vendaBloc.setCurrentPage(0);
    // if (vendaBloc.tutorial == null) {
    //   await vendaBloc.getTutorialByModulo("Venda");
    // }
    // if (vendaBloc.tutorial != null && vendaBloc.tutorial.passo == 0) {
    //   tutorialVendaSimples();
    // } 
    // if (vendaBloc.tutorial != null && vendaBloc.tutorial.passo == 7) {
    //   tutorialVendaLongPress();
    // } 
    // if (vendaBloc.tutorial != null && vendaBloc.tutorial.passo == 19){
    //   await tutorialConcluido();
    // }
  }

  tutorialVendaSimples() async {
    await vendaBloc.setTutorialPasso(1);
    await welcomeTutorial();
  }

  tutorialVendaLongPress() async {
   await welcomeTutorialSegundaVenda();
  }

  welcomeTutorial() {
    showDialog(
      barrierDismissible: false,
      context: context,
      child: AlertDialog(
        backgroundColor: Colors.transparent,
        title: Container(
          height: 160,
        ),
        content: Column(
          children: <Widget>[
            Image.asset("assets/mascote.png", width: 70),
            SizedBox(height: 20),
            Text("  Veja como é simples e\nfacil realizar uma venda\nno APP FLUGGY.", 
            style: TextStyle(color: Colors.white, fontSize: 17),textAlign: TextAlign.center),
            SizedBox(height: 30),
            SizedBox(
              width: 150,
              height: 40,
              child: FlatButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                  WidgetsBinding.instance.addPostFrameCallback((_) =>
                    ShowCaseWidget.of(myContext).startShowCase([categoriaPDV]));
                }, 
                child: Text("Iniciar", style: TextStyle(color: Colors.white)),
                color: Theme.of(context).primaryIconTheme.color,
              ),
            )
          ],
        ),
        actions: <Widget>[
          Text("")
        ],
      ),
    );
  }

  venderTutorial() {
    showDialog(
      barrierDismissible: false,
      context: context,
      child: AlertDialog(
        backgroundColor: Colors.transparent,
        title: Container(
          height: 180,
        ),
        content: Column(
          children: <Widget>[
            Image.asset("assets/mascote.png", width: 70),
            SizedBox(height: 20),
            Text("Vamos praticar!", style: TextStyle(color: Colors.white, fontSize: 17)),
            SizedBox(height: 30),
            SizedBox(
              width: 150,
              height: 40,
              child: FlatButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                  WidgetsBinding.instance.addPostFrameCallback((_) =>
                    ShowCaseWidget.of(myContext).startShowCase([produtoPrimeiraVenda]));
                }, 
                child: Text("Vender", style: TextStyle(color: Colors.white)),
                color: Theme.of(context).primaryIconTheme.color,
              ),
            )
          ],
        ),
        actions: <Widget>[
          Text("")
        ],
      ),
    );
  }

  welcomeTutorialSegundaVenda() {
    showDialog(
      barrierDismissible: false,
      context: context,
      child: AlertDialog(
        backgroundColor: Colors.transparent,
        title: Container(
          height: 160,
        ),
        content: Column(
          children: <Widget>[
            Image.asset("assets/mascote.png", width: 70),
            SizedBox(height: 20),
            Text("Agora vamos Realizar\n uma venda com 2\n tipos de pagamentos", 
              style: TextStyle(color: Colors.white, fontSize: 17)),
            SizedBox(height: 30),
            SizedBox(
              width: 150,
              height: 40,
              child: FlatButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)
                ),
                onPressed: () {
                  WidgetsBinding.instance.addPostFrameCallback((_) =>
                    ShowCaseWidget.of(myContext).startShowCase([produtoSegundaVenda]));
                    Navigator.of(context).pop();
                }, 
                child: Text("Iniciar", style: TextStyle(color: Colors.white)),
                color: Theme.of(context).primaryIconTheme.color,
              ),
            )
          ],
        ),
        actions: <Widget>[
          Text("")
        ],
      ),
    );
  }

  tutorialConcluido() {
    showDialog(
      barrierDismissible: false,
      context: context,
      child: AlertDialog(
        backgroundColor: Colors.transparent,
        title: Container(
          height: 160,
        ),
        content: Column(
          children: <Widget>[
            Image.asset("assets/mascote.png", width: 70),
            SizedBox(height: 20),
            Text("Parabéns!, você concluiu\no tutorial agora é com\nvocê! aproveite o app :)",
              style: TextStyle(color: Colors.white, fontSize: 17), textAlign: TextAlign.center),
            SizedBox(height: 30),
            SizedBox(
              width: 150,
              height: 40,
              child: FlatButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)
                ),
                onPressed: () async {
                  await vendaBloc.setTutorialPasso(20);
                  await vendaBloc.setTutorialVendaConcluida();
                  Navigator.pop(context);
                }, 
                child: Text("Fechar", style: TextStyle(color: Colors.white)),
                color: Theme.of(context).primaryIconTheme.color,
              ),
            )
          ],
        ),
        actions: <Widget>[
          Text("")
        ],
      ),
    );
  }

	@override
	Widget build(BuildContext context) {
    final locale = Localizations.of<LocaleBase>(context, LocaleBase);
    gridController = PageController(initialPage: vendaBloc.tipoApresentacaoProduto == TipoApresentacaoProduto.grid ? 1 : 0);

		return StreamBuilder(
      stream: vendaBloc.statusSincronizacaoHasuraOut,
      builder: (context, snapshot) {

      if(!snapshot.hasData || snapshot.data == null){
        return Container(
          color: Theme.of(context).primaryColor,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Text("Os seus dados estão sendo sincronizados.\nAguarde um momento.", style: Theme.of(context).textTheme.subtitle, textAlign: TextAlign.center,),
              ),
              CircularProgressIndicator(backgroundColor: Colors.white,),
            ],
          ),
        );
      }

      if(snapshot.data == StatusSincronizacao.erro){
        return Container(
          color: Theme.of(context).primaryColor,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Text("Parece que algo de errado ocorreu com a sincronização.", style: Theme.of(context).textTheme.subtitle, textAlign: TextAlign.center,),
              ),
              CircularProgressIndicator(backgroundColor: Colors.white,),
            ],
          ),
        );
      }

      return StreamBuilder<ConfiguracaoGeral>(
        initialData: ConfiguracaoGeral(),
        stream: vendaBloc.appGlobalBloc.configuracaoGeralOut,
        builder: (context, snapshot) {
          ConfiguracaoGeral configuracaoGeral = snapshot.data;
          return WillPopScope(
            onWillPop: () {
              if (configuracaoGeral.ehMenuClassico == 1) {
                _scaffoldKey.currentState.openDrawer();
              } else {
                Navigator.pop(context);
                Navigator.push(context, 
                  MaterialPageRoute(
                    settings: RouteSettings(name: '/MenuPage'),
                    builder: (context) => MenuPage()
                  )
                );
              }
              return Future.value(false);
            },
            child: Scaffold(
              key: _scaffoldKey,
              appBar: AppBar(
                centerTitle: true, 
                title: Image.asset(
                  'assets/palavraFluggy.png',
                  fit: BoxFit.contain,
                  height: 35
                ),
                leading:  StreamBuilder(
                  stream: vendaBloc.appGlobalBloc.configuracaoGeralOut,
                    builder: (context, snapshot) {
                      if (!snapshot.hasData){
                        return CircularProgressIndicator();
                      }
                      ConfiguracaoGeral configuracaoGeral = snapshot.data;
                      return IconButton(
                      icon: Icon(
                        Icons.menu,
                        color: Theme.of(context).primaryIconTheme.color,
                      ),
                      onPressed: () async {
                        if (configuracaoGeral.ehMenuClassico == 1) {
                          _scaffoldKey.currentState.openDrawer();
                        } else {
                          Navigator.pop(context);
                          Navigator.push(context, 
                            MaterialPageRoute(
                              settings: RouteSettings(name: '/MenuPage'),
                              builder: (context) => MenuPage()
                            )
                          );
                        }
                      }
                    );
                  }
                ),
                actions: <Widget>[ 
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      StreamBuilder<Movimento>(
                        stream: vendaBloc.movimentoOut,
                        builder: (context, snapshot) {
                          Movimento _movimento  = snapshot.data;
                          if(!snapshot.hasData){
                            return SizedBox.shrink();
                          }
                          return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[
                                Visibility(
                                  visible: true,
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 15, right: 20),
                                    child: Stack(
                                      overflow: Overflow.visible, 
                                      children: <Widget>[
                                        InkWell(
                                          child: Image.asset('assets/suporteIcon.png', height: 28, color: Theme.of(context).primaryIconTheme.color),
                                          onTap: (){
                                            appGlobalBloc.zendesk.setVisitorInfo(name: '${appGlobalBloc.loja.razaoNome}', 
                                              phoneNumber: appGlobalBloc.loja.contato != null && appGlobalBloc.loja.contato.length > 0 ? "${appGlobalBloc.loja.contato.first.telefone1}" : "Sem número cadastrado.", 
                                              email: appGlobalBloc.loja.contato != null && appGlobalBloc.loja.contato.length > 0 ? "${appGlobalBloc.loja.contato.first.email}" : "Sem e-mail cadastrado.",).then((r) {
                                              print(':::::::::::::::::: ZENDESK setVisitorInfo executado com sucesso ::::::::::::::::::::');
                                            }).catchError((e) {
                                              print(':::::::::::::::::: ERRO ZENDESK setVisitorInfo ::::::::::::::::::::');
                                              log(hasuraBloc, appGlobalBloc, 
                                                nomeArquivo: "app_globa_bloc",
                                                mensagemErro: "Erro ZenDesk: $e",
                                                nomeFuncao: "ZenDesk - setVisitorInfo"
                                              );
                                            });
                                             appGlobalBloc.zendesk.startChat().then((r) {
                                              print(':::::::::: zenDeskChat iniciado ::::::::::');
                                            }).catchError((e) {
                                              log(hasuraBloc ,appGlobalBloc, 
                                                nomeArquivo: "venda_page",
                                                mensagemErro: "Erro ZenDesk: $e",
                                                nomeFuncao: "ZenDesk - startChat"
                                              );
                                              showDialog(context: context,
                                                builder: (context){
                                                  return AlertDialog(
                                                    backgroundColor: Theme.of(context).accentColor,
                                                    title: Text("Informação"),
                                                    content: Text("Não foi possível iniciar o chat, tente novamente em instantes."),
                                                    actions: <Widget>[
                                                      FlatButton(
                                                        color: Colors.white,
                                                        child: Text("OK", style: TextStyle(color: Theme.of(context).primaryColor),),
                                                        onPressed: () {
                                                          Navigator.pop(context);
                                                        },
                                                      )
                                                    ],
                                                  );
                                                }
                                              );
                                            });
                                          },
                                        )
                                      ]
                                    )
                                  )
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(right: 15),
                                  child: Stack(
                                    overflow: Overflow.visible, 
                                    children: <Widget>[
                                      _movimento.idCliente == null || _movimento.idCliente == 0 
                                        ? InkWell(
                                          child: Icon(Icons.person_outline,
                                            color: Theme.of(context).primaryIconTheme.color,
                                            size: 30,
                                          ),
                                          onTap: (){
                                            vendaBloc.filterOnServer = false;
                                            Navigator.push(context, 
                                              MaterialPageRoute(
                                                settings: RouteSettings(name: '/ListaCliente'),
                                                builder: (context) => ClienteModule()
                                              )
                                            );
                                          },
                                        )
                                      : InkWell(
                                          child: Icon(Icons.person,
                                            color: Theme.of(context).primaryIconTheme.color,
                                            size: 30,
                                          ),
                                        onTap: () {
                                          return showGeneralDialog(
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
                                                      height: 100,
                                                      width: MediaQuery.of(context).size.width,
                                                      color: Colors.transparent,
                                                      child: Card(
                                                        color: Theme.of(context).accentColor,
                                                        borderOnForeground: true,
                                                        shape: RoundedRectangleBorder(
                                                          borderRadius: BorderRadius.only(bottomRight: Radius.circular(20), bottomLeft: Radius.circular(20)),
                                                        ),
                                                        child: Padding(
                                                          padding: const EdgeInsets.all(10.0),
                                                          child: Column(
                                                            mainAxisAlignment: MainAxisAlignment.start,
                                                            children: <Widget>[
                                                              Row(
                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                                children: <Widget>[
                                                                  Text("Cliente", style: Theme.of(context).textTheme.title),
                                                                  InkWell(
                                                                    child: Icon(Icons.close, color: Colors.white, size: 25),
                                                                    onTap: () {
                                                                      Navigator.of(context).pop();
                                                                    },
                                                                  )
                                                                ],
                                                              ),
                                                              Row(
                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                                children: <Widget>[
                                                                  Text(vendaBloc.nomeCliente, style: Theme.of(context).textTheme.subtitle),
                                                                  InkWell(
                                                                  child: Padding(
                                                                    padding: const EdgeInsets.only(top: 10.0),
                                                                    child: Image.asset(
                                                                      'assets/trashbin.png', color: Colors.white,
                                                                      height: 20,
                                                                    ),
                                                                  ),
                                                                  onTap: () {
                                                                    vendaBloc.movimento.idCliente = 0;
                                                                    vendaBloc.nomeCliente = "";
                                                                    vendaBloc.updateMovimentoStream();
                                                                    Navigator.pop(context);
                                                                  },
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
                                                  end: Offset(0, 0.06),
                                                )),
                                                child: child,
                                              );
                                            },
                                          );
                                        }
                                      ),
                                      Positioned(
                                        bottom: 15.5,
                                        right: 0.2,
                                        child: Container(
                                          alignment: Alignment.topRight,
                                          padding: EdgeInsets.all(2.7),
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color:  _movimento.idCliente == null || _movimento.idCliente == 0 ? Colors.transparent : Colors.red),
                                          child: Text(_movimento.idCliente == null || _movimento.idCliente == 0 ? "" : "1",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 14
                                            ),
                                          )
                                        )
                                      ),
                                    ],
                                  ),
                                ),
                                Visibility(
                                  visible: false,
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 15, right: 15),
                                    child: Stack(
                                      overflow: Overflow.visible, 
                                      children: <Widget>[
                                        _movimento.idVendedor == null || _movimento.idVendedor == 0 
                                        ? InkWell(
                                            child: Image.asset('assets/vendedorMiniIcon.png', height: 32,),
                                            onTap: (){
                                              vendaBloc.filterOnServer = false;
                                              Navigator.push(context, 
                                                MaterialPageRoute(
                                                  settings: RouteSettings(name: '/ListaVendedor'),
                                                  builder: (context) => VendedorModule()
                                                )
                                              );
                                            },
                                          )
                                        : InkWell(
                                            child: Image.asset('assets/vendedorMiniIcon.png', height: 32,),
                                            onTap: () {
                                              return showGeneralDialog(
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
                                                          height: 100,
                                                          width: MediaQuery.of(context).size.width,
                                                          color: Colors.transparent,
                                                          child: Card(
                                                            color: Theme.of(context).accentColor,
                                                            borderOnForeground: true,
                                                            shape: RoundedRectangleBorder(
                                                              borderRadius: BorderRadius.only(bottomRight: Radius.circular(20), bottomLeft: Radius.circular(20)),
                                                            ),
                                                            child: Padding(
                                                              padding: const EdgeInsets.all(10.0),
                                                              child: Column(
                                                                mainAxisAlignment: MainAxisAlignment.start,
                                                                children: <Widget>[
                                                                  Row(
                                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                                    children: <Widget>[
                                                                      Text("Vendedor", style: Theme.of(context).textTheme.title),
                                                                      InkWell(
                                                                        child: Icon(Icons.close, color: Colors.white, size: 25),
                                                                        onTap: () {
                                                                          Navigator.of(context).pop();
                                                                        },
                                                                      )
                                                                    ],
                                                                  ),
                                                                  Row(
                                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                    children: <Widget>[
                                                                      Text(vendaBloc.nomeVendedor, style: Theme.of(context).textTheme.subtitle),
                                                                      InkWell(
                                                                        child: Padding(
                                                                          padding: const EdgeInsets.only(top: 10.0),
                                                                          child: Image.asset(
                                                                            'assets/trashbin.png', color: Colors.white,
                                                                            height: 20,
                                                                          ),
                                                                        ),
                                                                        onTap: () {
                                                                          vendaBloc.movimento.idVendedor = 0;
                                                                          vendaBloc.nomeVendedor = "";
                                                                          vendaBloc.updateMovimentoStream();
                                                                          Navigator.pop(context);
                                                                        },
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ]
                                                              ),
                                                            ),
                                                          ),
                                                        )
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
                                                      end: Offset(0, 0.06),
                                                    )
                                                  ),
                                                  child: child,
                                                );
                                              },
                                            );
                                          }
                                        ),
                                        Positioned(
                                          bottom: 15.5,
                                          right: 0.2,
                                          child: Container(
                                            alignment: Alignment.topRight,
                                            padding: EdgeInsets.all(2.7),
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: _movimento.idVendedor == null ||  _movimento.idVendedor == 0 ? Colors.transparent : Colors.red),
                                            child: Text(_movimento.idVendedor == null || _movimento.idVendedor == 0 ? "" : "1",
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 14
                                              ),
                                            )
                                          )
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            );
                          }
                        ),
                      ]
                    ),
                  ],
                ),
                drawer: DrawerApp(),
                body: Container(
                  color: Theme.of(context).primaryColor,
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(
                            right: 20.0, left: 20.0, bottom: 10, top: 2),
                            child: StreamBuilder(
                              initialData: 0,
                              stream: vendaBloc.currentPageOut,
                              builder: (context, snapshot) {
                                int currentPage = snapshot.data;
                                return Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    InkWell(
                                      child: InkWelIcon(
                                        color: snapshot.data >= 0.0
                                          ? Theme.of(context).primaryIconTheme.color
                                          : Theme.of(context).accentColor,
                                        image: Image.asset(
                                          'assets/price_tag.png',
                                          fit: BoxFit.contain,
                                          height: 23,
                                          color: snapshot.data >= 1.0
                                            ? Colors.white70
                                            : Colors.white70,
                                        )
                                      ),
                                      onTap: () {
                                        pageController.animateToPage(0, duration: Duration(milliseconds: 600), curve: Curves.fastOutSlowIn);
                                      },
                                      onLongPress: () {
                                        Navigator.push(context, PageRouteBuilder(
                                          opaque: false,
                                          settings: RouteSettings(name: '/VendaTransacao'),
                                          pageBuilder: (BuildContext context, _, __) => VendaTransacaoModule()
                                          )
                                        );
                                      },
                                    ),
                                    Expanded(
                                      child: AnimatedContainer(
                                        duration: Duration(milliseconds: 100),
                                        height: 2,
                                        color: snapshot.data >= 1.0
                                          ? Theme.of(context).primaryIconTheme.color
                                          : Theme.of(context).accentColor,
                                      ),
                                    ),
                                    Stack(
                                      overflow: Overflow.visible, 
                                      children: <Widget>[
                                        InkWelIcon(
                                          onTap: () {
                                            pageController.animateToPage(1, duration: Duration(milliseconds: 600), curve: Curves.fastOutSlowIn);
                                          },
                                          color: snapshot.data >= 1.0
                                            ? Theme.of(context).primaryIconTheme.color
                                            : Theme.of(context).accentColor,
                                          image: Image.asset(
                                            'assets/cesta.png',
                                            fit: BoxFit.contain,
                                            height: 23,
                                            color: Colors.white70,
                                          )
                                        ),
                                        Positioned(
                                          bottom: 19,
                                          right: 28,
                                          child: StreamBuilder<List<Movimento>>(
                                            initialData: List<Movimento>(),
                                            stream: vendaBloc.pedidoListOut,
                                            builder: (context, snapshot) {
                                              List<Movimento> movimentoList = snapshot.data;
                                              if (movimentoList.length == 0 || vendaBloc.movimento.movimentoItem.length > 0) {
                                                return Text("");
                                              }
                                              return Container(
                                                alignment: Alignment.topRight,
                                                padding: EdgeInsets.all(4.1),
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: Colors.orange),
                                                child: Text(
                                                  "${movimentoList.length}",
                                                  style: TextStyle(color: Colors.white),
                                                )
                                              );
                                            }
                                          ),
                                        ),
                                        Positioned(
                                          bottom: 19,
                                          left: 28,
                                          child: StreamBuilder<Movimento>(
                                            initialData: Movimento(),
                                            stream: vendaBloc.movimentoOut,
                                            builder: (context, snapshot) {
                                              Movimento movimento = snapshot.data;
                                              if (movimento.movimentoItem.length == 0) {
                                                return Text("");
                                              }
                                              return Container(
                                                alignment: Alignment.topRight,
                                                padding: EdgeInsets.all(4.1),
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: currentPage >= 1.0
                                                    ? Theme.of(context).accentColor
                                                    : Theme.of(context).primaryIconTheme.color),
                                                child: Text(
                                                  "${movimento.totalQuantidade.round()}",
                                                  style: TextStyle(color: Colors.white),
                                                )
                                              );
                                            }
                                          ),
                                        ),
                                      ]
                                    ),
                                    Expanded(
                                      child: AnimatedContainer(
                                        duration: Duration(milliseconds: 100),
                                        height: 2,
                                        color: snapshot.data >= 2.0
                                            ? Theme.of(context).primaryIconTheme.color
                                            : Theme.of(context).accentColor,
                                      ),
                                    ),
                                    InkWelIcon(
                                      color: snapshot.data == 2.0
                                        ? Theme.of(context).primaryIconTheme.color
                                        : Theme.of(context).accentColor,
                                      image: Image.asset(
                                        'assets/dinheiroIcon.png',
                                        color: Colors.white70,
                                        fit: BoxFit.contain,
                                        height: 23,
                                      ),
                                      onTap: () {
                                        if(vendaBloc.movimento.movimentoItem.length > 0){
                                          pageController.animateToPage(2,
                                            duration: Duration(milliseconds: 600),
                                            curve: Curves.fastOutSlowIn);
                                        }
                                      },
                                    ),
                                  ],
                                );
                              }
                            )
                          ),
                          Expanded(
                            child: PageView(
                              physics: NeverScrollableScrollPhysics(),
                              controller: pageController,
                              onPageChanged: (num) async {
                                await vendaBloc.setCurrentPage(num);
                              },
                              children: <Widget>[
                                Column(
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                                      child: Container(
                                        width: double.infinity,
                                        child: SizedBox(
                                          height: 25,
                                          child: StreamBuilder<List<Categoria>>(
                                            stream: vendaBloc.categoriaListOut,
                                            builder: (context, snapshot) {
                                              if (!snapshot.hasData) {
                                                return Center(child: CircularProgressIndicator());
                                              }

                                              final List<Categoria> categoriaList = snapshot.data;

                                              if (categoriaList.length == 0) {
                                                return Container(
                                                  child: Center(
                                                    child: Text(
                                                      "Não há nenhuma categoria cadastrada",
                                                      style: Theme.of(context).textTheme.body2,
                                                    ),
                                                  ),
                                                );
                                              }

                                              return ListView.builder(
                                                shrinkWrap: true,
                                                scrollDirection: Axis.horizontal,
                                                itemCount: categoriaList[0].nome == "Todos"
                                                    ? categoriaList.length
                                                    : categoriaList.length + 1,
                                                itemBuilder: (context, index) {
                                                  if (index == 0) {
                                                    if (categoriaList[0].nome != "Todos") {
                                                      Categoria categoria = Categoria();
                                                      categoria.id = 0;
                                                      categoria.nome = "Todos";
                                                      categoriaList.insert(0, categoria);
                                                    }
                                                  }

                                                  return InkWell(
                                                    child: Container(
                                                      padding: EdgeInsets.symmetric(horizontal: 15),
                                                      child: Text(categoriaList[index].nome.toUpperCase(),
                                                        style: categoriaList[index].id == vendaBloc.getFilterCategoria() 
                                                          ? Theme.of(context).textTheme.body1
                                                          : Theme.of(context).textTheme.body1
                                                      ),
                                                      decoration: BoxDecoration(
                                                        border: Border(
                                                          bottom: BorderSide(
                                                            width: categoriaList[index].id == vendaBloc.getFilterCategoria()
                                                                ? 2.0
                                                                : 1.5,
                                                            color: categoriaList[index].id == vendaBloc.getFilterCategoria()
                                                              ? Theme.of(context).primaryIconTheme.color
                                                              : Colors.transparent
                                                          ),
                                                        ),
                                                      )
                                                    ),
                                                    onTap: () {
                                                      vendaBloc.setFilterCategoria(categoriaList[index].id);
                                                      vendaBloc.offset = 0;
                                                      vendaBloc.getallProduto();
                                                    },
                                                  );
                                                }
                                              );
                                            }
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                                      child: Container(
                                        color: Colors.white54,
                                        height: 1,
                                        width: double.infinity,
                                      ),
                                    ),
                                    Container(
                                      height: 50,
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: <Widget>[
                                          Padding(
                                            padding: const EdgeInsets.only(left: 10.5, right: 10),
                                            child: Image.asset('assets/buscaIcon.png', height: 18),
                                          ),
                                          Flexible(
                                            child: TextFormField(
                                              controller: pesquisaController,
                                              decoration: InputDecoration(
                                                hintText: 'Pesquisar',
                                                hintStyle: TextStyle(color: Colors.white),
                                                suffixIcon: StreamBuilder<String>(
                                                  initialData: "",
                                                  stream: vendaBloc.filterTextOut,
                                                  builder: (context, snapshot) {
                                                    return AnimatedSwitcher(
                                                      switchInCurve: Curves.easeIn,
                                                      switchOutCurve: Curves.easeOut,
                                                      duration: Duration(milliseconds: 60),
                                                      child: snapshot.data.length > 0
                                                      ? IconButton(
                                                          icon: Icon(Icons.close, color: Colors.white),
                                                          onPressed: () async {
                                                            WidgetsBinding.instance.addPostFrameCallback((_) => pesquisaController.clear());
                                                            vendaBloc.setFilterText("");
                                                            vendaBloc.offset = 0;
                                                            await vendaBloc.getallProduto();
                                                            FocusScope.of(context).unfocus();
                                                          }
                                                      ) 
                                                      : SizedBox.shrink() ,
                                                    );
                                                  }
                                                ),
                                              ),
                                              onChanged: (text) {
                                                vendaBloc.setFilterText(text);
                                              },
                                              onEditingComplete: () async {
                                                vendaBloc.offset = 0;
                                                await vendaBloc.getallProduto();
                                                FocusScope.of(context).unfocus();
                                                if (vendaBloc.filterText == "") {
                                                  pesquisaController.clear();
                                                }
                                              },
                                            ),
                                            // TextField(
                                            //   controller: pesquisaController,
                                            //   style: TextStyle(fontSize: 17, color: Colors.white),
                                            //   decoration: InputDecoration(
                                            //     border: InputBorder.none,
                                            //     hintText: 'Pesquisar',
                                            //     hintStyle: TextStyle(color: Colors.white),
                                            //   ),
                                            //   onChanged: (text) {
                                            //     vendaBloc.setFilterText(text);
                                            //   },
                                            //   onEditingComplete: () async {
                                            //     vendaBloc.offset = 0;
                                            //     await vendaBloc.getallProduto();
                                            //     FocusScope.of(context).unfocus();
                                            //     if (vendaBloc.filterText == "") {
                                            //       pesquisaController.clear();
                                            //     }
                                            //   },
                                            // ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(right: 10.5, left: 10.5),
                                            child: Row(
                                              children: <Widget>[
                                                Padding(
                                                  padding: const EdgeInsets.only(right: 2),
                                                  child: StreamBuilder(
                                                    stream: vendaBloc.gridListViewOut,
                                                    builder: (context, snapshot) {
                                                      return IconButton(
                                                        icon: Icon(
                                                          snapshot.data == TipoApresentacaoProduto.list 
                                                            ? Icons.dashboard
                                                            : Icons.format_list_numbered,
                                                          size: 25,
                                                          color: Colors.white,
                                                        ),
                                                        onPressed: () {
                                                          vendaBloc.setCurrentView();
                                                        },
                                                      );
                                                    }
                                                  ),
                                                ),
                                                Visibility(
                                                  visible: false,
                                                  child: FutureBuilder(
                                                    future: appGlobalBloc.getModuloAcesso(ModuloEnum.servico),
                                                    builder: (context, snapshot){
                                                      return AnimatedSwitcher(
                                                        duration: Duration(milliseconds: 200),
                                                        switchInCurve: Curves.easeIn,
                                                        switchOutCurve: Curves.easeOut,
                                                        child: snapshot.connectionState == ConnectionState.done && snapshot.hasData && snapshot.data == true 
                                                        ? Padding(
                                                          padding: const EdgeInsets.only(right: 15.0),
                                                          child: StreamBuilder(
                                                            stream: vendaBloc.servicoListViewOut,
                                                            builder: (context, snapshot) {
                                                              return InkWell(
                                                                child: Container(
                                                                  child: snapshot.data == FilterTemServico.naoServico 
                                                                    ? Image.asset('assets/servicoMiniIcon.png', height: 25,)
                                                                    : Icon(Icons.widgets, color: Colors.white54, size: 30.8),
                                                                ),
                                                                onTap: () {
                                                                  vendaBloc.offset = 0;
                                                                  vendaBloc.setServicoView();
                                                                },
                                                              );
                                                            }
                                                          ),
                                                        )
                                                        : SizedBox.shrink()
                                                      );
                                                    }
                                                  ),
                                                ),
                                                GestureDetector(
                                                  child: Image.asset(
                                                    'assets/codBarrasIcon.png',
                                                    fit: BoxFit.contain,
                                                    height: 40,
                                                  ),
                                                  onTap: () async {
                                                    try {
                                                      String barcodeScanRes = await FlutterBarcodeScanner.scanBarcode("#${Colors.red.value.toRadixString(16)}", "Cancelar", false, ScanMode.BARCODE);
                                                      print("Barcode: "+barcodeScanRes); 
                                                      barcodeScanRes = barcodeScanRes == "-1" ? "" : barcodeScanRes;
                                                      if ( barcodeScanRes != "" ){
                                                        await vendaBloc.setFilterText(barcodeScanRes);
                                                        await vendaBloc.getallProduto();
                                                        if (vendaBloc.produto != null) {
                                                          if (vendaBloc.produto.idGrade == 0 || vendaBloc.produto.idGrade == null) {
                                                            if (vendaBloc.produto.produtoVariante.length == 0) {
                                                              await vendaBloc.addMovimentoItem(vendaBloc.produto.id, 0, null, vendaBloc.produto.precoTabelaItem.first.preco);
                                                            } else {
                                                              Navigator.push(context,PageRouteBuilder(
                                                                settings: RouteSettings(name: '/VendaProdutoVariante'),
                                                                pageBuilder: (BuildContext context, _, __) => VendaVariantePage(produto: vendaBloc.produto, index: 0),
                                                                transitionsBuilder: (___,Animation<double> animation, ____, Widget child) {
                                                                  return FadeTransition(opacity: animation, child: child,);
                                                                  }
                                                                )
                                                              );
                                                            }
                                                          } else {
                                                            await vendaBloc.getProdutoGrade(index: 0);
                                                              Navigator.push(context, PageRouteBuilder(
                                                                settings: RouteSettings(name: '/VendaProdutoGrade'),
                                                                pageBuilder: (c, a1, a2) => VendaGradePage(produto: vendaBloc.produto, index: 0),
                                                                transitionsBuilder: (c, anim, a2, child) => FadeTransition(opacity: anim, child: child),
                                                                transitionDuration: Duration(milliseconds: 180),
                                                              ),
                                                            );
                                                          }
                                                        } else {
                                                          print("produto não encontrado");
                                                          showDialog(
                                                            context: context,
                                                            builder: (BuildContext context) => CustomDialogConfirmation(
                                                              title: locale.palavra.confirmacao,
                                                              description: "Produto não encontrado",
                                                              buttonOkText: "Ok",
                                                              buttonCancelText: "",
                                                              funcaoBotaoOk: () async {
                                                                Navigator.pop(context);
                                                              }
                                                            ),
                                                          );
                                                        }
                                                      }
                                                    } catch (erro) {
                                                      print("Erro ao ler codbarra: $erro");
                                                    }
                                                  },
                                                )
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                                      child: StreamBuilder<TipoApresentacaoProduto>(
                                        stream: vendaBloc.gridListViewOut,
                                        builder: (context, snapshot) {
                                          if (!snapshot.hasData) {
                                            return Center(
                                              child: CircularProgressIndicator(
                                                backgroundColor: Colors.white,
                                              )
                                            );
                                          }

                                          Future _refreshProdutoList() async {
                                            vendaBloc.offset = 0;
                                            await vendaBloc.getallProduto();
                                          }

                                          Future _loadMoreProduto() async {
                                            List newProdutoList =  await vendaBloc.getallProduto();
                                            if (newProdutoList != null) {
                                              if (newProdutoList.length == 0) {
                                                double edge = 50.0;
                                                double offsetFromBottom = scrollController.position.maxScrollExtent - scrollController.position.pixels;
                                                if (offsetFromBottom < edge) {
                                                  scrollController.animateTo(scrollController.offset - (edge - offsetFromBottom), duration: new Duration(milliseconds: 500), curve: Curves.easeOut);
                                                }
                                              }
                                            }
                                          }

                                          scrollController.addListener(() {
                                            if (scrollController.position.pixels == scrollController.position.maxScrollExtent) {
                                              _loadMoreProduto();
                                            }
                                          });

                                          if(snapshot.data == TipoApresentacaoProduto.grid){
                                            return Scrollbar(
                                              child: RefreshIndicator(
                                                displacement: 20,
                                                color: Colors.white,
                                                onRefresh: _refreshProdutoList,
                                                child: StreamBuilder(
                                                  stream: vendaBloc.produtoListOut,
                                                  builder: (context, snapshot){
                                                    if(!snapshot.hasData){
                                                      return Center(child: CircularProgressIndicator(backgroundColor: Colors.white));
                                                    }
                                                    List<Produto> produtoList = snapshot.data;
                                                    if(produtoList.length == 0 && vendaBloc.filterCategoria != 0){
                                                      return Center(
                                                        child: Text("Não há nenhum produto associado a essa categoria.", style: Theme.of(context).textTheme.body1),
                                                      );
                                                    }
                                                    
                                                    return GridView.builder(
                                                      controller: scrollController,
                                                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3), 
                                                      scrollDirection: Axis.vertical,
                                                      itemCount: produtoList.length + 1,
                                                      itemBuilder: (context, index){
                                                        if(index < produtoList.length){
                                                          precoProduto.updateValue(produtoList[index].precoTabelaItem.first.preco);
                                                          return GridItemBuilder(
                                                            bloc: vendaBloc,
                                                            child: Padding(
                                                              padding: const EdgeInsets.only(right: 6, top: 6, left: 6, bottom: 6),
                                                              child: Container(
                                                                decoration: BoxDecoration(
                                                                  color: Theme.of(context).accentColor,
                                                                  borderRadius: BorderRadius.all(Radius.circular(8)),
                                                                  boxShadow: [
                                                                    BoxShadow(
                                                                      color: Colors.black,
                                                                      spreadRadius: 0.01
                                                                    )
                                                                  ]
                                                                ),
                                                                child: Stack(
                                                                  children: <Widget>[
                                                                    produtoList[index].produtoImagem.length > 0 && produtoList[index].produtoImagem.first.ehDeletado == 0
                                                                    ? FutureBuilder<String>(
                                                                        future: readBase64Image("${produtoList[index].produtoImagem.first.imagem.replaceAll(".png", "")}.txt"),
                                                                        builder: (context, snapshot){
                                                                          return AnimatedOpacity(
                                                                            duration: Duration(milliseconds: 200),
                                                                            opacity: snapshot.hasData ? 1.0 : 0.0,
                                                                            child: ClipRRect(
                                                                              borderRadius: BorderRadius.circular(8),
                                                                              child: snapshot.hasData ? Image.memory(base64Decode(snapshot.data),
                                                                                gaplessPlayback: true,
                                                                                width: double.infinity,
                                                                                fit: BoxFit.cover
                                                                              ) : SizedBox.shrink(),
                                                                            )
                                                                          );
                                                                        },
                                                                      )
                                                                    : ClipRRect(
                                                                      borderRadius: BorderRadius.circular(8),
                                                                      child: Container(
                                                                        color: Color(int.parse(produtoList[index].iconeCor)),
                                                                        child: Center(
                                                                          child: Text("${produtoList[index].nome}".substring(0, 2), 
                                                                            style: TextStyle(
                                                                              color: useWhiteForeground(Color(int.parse(produtoList[index].iconeCor)))
                                                                                ? const Color(0xffffffff)
                                                                                : const Color(0xff000000), 
                                                                              fontSize: Theme.of(context).textTheme.title.fontSize)
                                                                          ),
                                                                        ),
                                                                      )
                                                                    ),
                                                                    Column(
                                                                      crossAxisAlignment:CrossAxisAlignment.start,
                                                                      mainAxisAlignment:MainAxisAlignment.end,
                                                                      children: <Widget>[
                                                                        Container(
                                                                          padding: EdgeInsets.only(left: 3),
                                                                          width: double.infinity,
                                                                          color: Theme.of(context).primaryColor.withOpacity(0.5),
                                                                          child: Align(
                                                                            alignment: Alignment.bottomLeft,
                                                                            child: AutoSizeText(
                                                                              "${produtoList[index].nome}",
                                                                              style: Theme.of(context).textTheme.body2,
                                                                              maxFontSize: Theme.of(context).textTheme.body2.fontSize,
                                                                              minFontSize: 8,
                                                                              maxLines: 2,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        Container(
                                                                          padding: EdgeInsets.only(left: 3),
                                                                          width: double.infinity,
                                                                          color: Theme.of(context).primaryColor.withOpacity(0.5),
                                                                          child: Align(
                                                                            alignment: Alignment.bottomLeft,
                                                                            child: AutoSizeText(
                                                                              "${precoProduto.text}",
                                                                              style: Theme.of(context).textTheme.body2,
                                                                              maxFontSize: Theme.of(context).textTheme.body2.fontSize,
                                                                              minFontSize: 8,
                                                                              maxLines: 1,
                                                                            ),
                                                                          ),
                                                                        )  
                                                                      ],
                                                                    )
                                                                  ]
                                                                )
                                                              ),
                                                            ),
                                                            onTap: () async {
                                                              if(appGlobalBloc.terminal.temControleCaixa == 1){
                                                                if(vendaBloc.statusCaixa == StatusCaixa.aberto){ 
                                                                  if (produtoList[index].idGrade == 0 || produtoList[index].idGrade == null) {
                                                                    if (produtoList[index].produtoVariante.length == 0) {
                                                                      await vendaBloc.addMovimentoItem(produtoList[index].id, 0, null, produtoList[index].precoTabelaItem.first.preco);
                                                                    } else {
                                                                      Navigator.push(context, PageRouteBuilder(
                                                                        settings: RouteSettings(name: '/VendaProdutoVariante'),
                                                                        pageBuilder: (BuildContext context, _, __) => VendaVariantePage(produto: produtoList[index], index: 0),
                                                                        transitionsBuilder: (___,Animation<double> animation, ____, Widget child) {
                                                                          return FadeTransition(opacity: animation, child: child,);
                                                                          }
                                                                        )
                                                                      );
                                                                    }
                                                                  } else {
                                                                    await vendaBloc.getProdutoGrade(index: index);
                                                                      Navigator.push(context, PageRouteBuilder(
                                                                        settings: RouteSettings(name: '/VendaProdutoGrade'),
                                                                        pageBuilder: (c, a1, a2) => VendaGradePage(produto:produtoList[index], index: index),
                                                                        transitionsBuilder: (c, anim, a2, child) => FadeTransition(opacity: anim, child: child),
                                                                        transitionDuration: Duration(milliseconds: 180),
                                                                      ),
                                                                    );
                                                                  }
                                                                }
                                                              } else {
                                                                if (produtoList[index].idGrade == 0 || produtoList[index].idGrade == null) {
                                                                  if (produtoList[index].produtoVariante.length == 0) {
                                                                    await vendaBloc.addMovimentoItem(produtoList[index].id, 0, null, produtoList[index].precoTabelaItem.first.preco);
                                                                  } else {
                                                                    Navigator.push(context, PageRouteBuilder(
                                                                      settings: RouteSettings(name: '/VendaProdutoVariante'),
                                                                      pageBuilder: (BuildContext context, _, __) => VendaVariantePage(produto: produtoList[index], index: 0),
                                                                      transitionsBuilder: (___,Animation<double> animation, ____, Widget child) {
                                                                        return FadeTransition(opacity: animation, child: child,);
                                                                        }
                                                                      )
                                                                    );
                                                                  }
                                                                } else {
                                                                  await vendaBloc.getProdutoGrade(index: index);
                                                                    Navigator.push(context, PageRouteBuilder(
                                                                      settings: RouteSettings(name: '/VendaProdutoGrade'),
                                                                      pageBuilder: (c, a1, a2) => VendaGradePage(produto:produtoList[index], index: index),
                                                                      transitionsBuilder: (c, anim, a2, child) => FadeTransition(opacity: anim, child: child),
                                                                      transitionDuration: Duration(milliseconds: 180),
                                                                    ),
                                                                  );
                                                                }
                                                              }
                                                            },
                                                            onLongPress: () {
                                                              showDialog(
                                                                context: context,
                                                                builder: (_) => ConsultaEstoqueModule(produto: produtoList[index])
                                                              );
                                                            }
                                                          );
                                                        }
                                                      }
                                                    );
                                                  }
                                                ),
                                              )
                                            );
                                          } else {
                                            return Scrollbar(
                                              child: RefreshIndicator(
                                                displacement: 20,
                                                color: Colors.white,
                                                onRefresh: _refreshProdutoList,
                                                child: StreamBuilder(
                                                  stream: vendaBloc.produtoListOut,
                                                  builder: (context, snapshot){
                                                    if(!snapshot.hasData){
                                                      return CircularProgressIndicator();
                                                    }
                                                    List<Produto> produtoList = snapshot.data;
                                                    if(produtoList.length == 0 && vendaBloc.filterCategoria != 0){
                                                      return Center(
                                                        child: Text("Não há nenhum produto associado a essa categoria.", style: Theme.of(context).textTheme.body1),
                                                      );
                                                    }
                                                    return ListView.builder(
                                                      controller: scrollController,
                                                      itemCount: produtoList.length + 1,
                                                      shrinkWrap: true,
                                                      itemBuilder: (context, index){
                                                        if(index < produtoList.length) {
                                                          precoProduto.updateValue(produtoList[index].precoTabelaItem.first.preco);
                                                          return ListItemBuilder(
                                                            bloc: vendaBloc,
                                                            child: Padding(
                                                              padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 5),
                                                              child: Container(
                                                              decoration: BoxDecoration(
                                                                borderRadius: BorderRadius.circular(8),
                                                                border: Border.all(width: 2, color: Theme.of(context).accentColor),
                                                              ),
                                                              child: ListTile(
                                                                leading: Container(
                                                                height: 60.0,
                                                                width: 60.0,
                                                                decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(3))),
                                                                  child: produtoList[index].produtoImagem.length > 0 && produtoList[index].produtoImagem.first.ehDeletado == 0
                                                                    ? FutureBuilder<String>(
                                                                        future: readBase64Image("${produtoList[index].produtoImagem.first.imagem.replaceAll(".png", "")}.txt"),
                                                                        builder: (context, snapshot){
                                                                          return AnimatedOpacity(
                                                                            duration: Duration(milliseconds: 200),
                                                                            opacity: snapshot.hasData ? 1.0 : 0.0,
                                                                            child: ClipRRect(
                                                                              borderRadius: BorderRadius.circular(8),
                                                                              child: snapshot.hasData ? Image.memory(base64Decode(snapshot.data),
                                                                                gaplessPlayback: true,
                                                                                width: double.infinity,
                                                                                fit: BoxFit.cover
                                                                              ) : SizedBox.shrink(),
                                                                            )
                                                                          );
                                                                        },
                                                                      )
                                                                    : ClipRRect(
                                                                      borderRadius: BorderRadius.circular(8),
                                                                      child: Container(
                                                                        color: Color(int.parse(produtoList[index].iconeCor)),
                                                                        child: Center(
                                                                          child: Text("${produtoList[index].nome}".substring(0, 2), 
                                                                            style: TextStyle(
                                                                              color: useWhiteForeground(Color(int.parse(produtoList[index].iconeCor)))
                                                                                ? const Color(0xffffffff)
                                                                                : const Color(0xff000000), 
                                                                              fontSize: Theme.of(context).textTheme.title.fontSize)
                                                                          ),
                                                                        ),
                                                                      )
                                                                    ),
                                                                  ),
                                                                  title: Container(
                                                                    child: AutoSizeText(
                                                                      "${produtoList[index].nome}",
                                                                      style: Theme.of(context).textTheme.body2,
                                                                      maxFontSize: Theme.of(context).textTheme.body2.fontSize,
                                                                      minFontSize: 8,
                                                                      maxLines: 2,
                                                                    ),
                                                                  ),
                                                                  subtitle: Text("${produtoList[index].categoria.nome}", style: Theme.of(context).textTheme.body2,),
                                                                  trailing:  Container(
                                                                    alignment: Alignment.centerRight,
                                                                    width: 70,
                                                                    child: AutoSizeText("${precoProduto.text}",
                                                                      style: GoogleFonts.sourceSansPro(
                                                                        fontSize: Theme.of(context).textTheme.body2.fontSize,
                                                                        fontWeight: FontWeight.w600
                                                                      ),
                                                                      maxFontSize: Theme.of(context).textTheme.body2.fontSize,
                                                                      minFontSize: 8,
                                                                      maxLines: 1,
                                                                    ),
                                                                  ),
                                                                )
                                                              ),
                                                            ),
                                                            onTap: () async {
                                                              if(appGlobalBloc.terminal.temControleCaixa == 1){
                                                                if(vendaBloc.statusCaixa == StatusCaixa.aberto){ 
                                                                  if (produtoList[index].idGrade == 0 || produtoList[index].idGrade == null) {
                                                                    if (produtoList[index].produtoVariante.length == 0) {
                                                                      await vendaBloc.addMovimentoItem(produtoList[index].id, 0, null, produtoList[index].precoTabelaItem.first.preco);
                                                                    } else {
                                                                      Navigator.push(context, PageRouteBuilder(
                                                                        settings: RouteSettings(name: '/VendaProdutoVariante'),
                                                                        pageBuilder: (BuildContext context, _, __) => VendaVariantePage(produto: produtoList[index], index: 0),
                                                                        transitionsBuilder: (___,Animation<double> animation, ____, Widget child) {
                                                                          return FadeTransition(opacity: animation, child: child,);
                                                                          }
                                                                        )
                                                                      );
                                                                    }
                                                                  } else {
                                                                    await vendaBloc.getProdutoGrade(index: index);
                                                                      Navigator.push(context, PageRouteBuilder(
                                                                        settings: RouteSettings(name: '/VendaProdutoGrade'),
                                                                        pageBuilder: (c, a1, a2) => VendaGradePage(produto:produtoList[index], index: index),
                                                                        transitionsBuilder: (c, anim, a2, child) => FadeTransition(opacity: anim, child: child),
                                                                        transitionDuration: Duration(milliseconds: 180),
                                                                      ),
                                                                    );
                                                                  }
                                                                }
                                                              } else {
                                                                if (produtoList[index].idGrade == 0 || produtoList[index].idGrade == null) {
                                                                  if (produtoList[index].produtoVariante.length == 0) {
                                                                    await vendaBloc.addMovimentoItem(produtoList[index].id, 0, null, produtoList[index].precoTabelaItem.first.preco);
                                                                  } else {
                                                                    Navigator.push(context, PageRouteBuilder(
                                                                      settings: RouteSettings(name: '/VendaProdutoVariante'),
                                                                      pageBuilder: (BuildContext context, _, __) => VendaVariantePage(produto: produtoList[index], index: 0),
                                                                      transitionsBuilder: (___,Animation<double> animation, ____, Widget child) {
                                                                        return FadeTransition(opacity: animation, child: child,);
                                                                        }
                                                                      )
                                                                    );
                                                                  }
                                                                } else {
                                                                  await vendaBloc.getProdutoGrade(index: index);
                                                                    Navigator.push(context, PageRouteBuilder(
                                                                      settings: RouteSettings(name: '/VendaProdutoGrade'),
                                                                      pageBuilder: (c, a1, a2) => VendaGradePage(produto:produtoList[index], index: index),
                                                                      transitionsBuilder: (c, anim, a2, child) => FadeTransition(opacity: anim, child: child),
                                                                      transitionDuration: Duration(milliseconds: 180),
                                                                    ),
                                                                  );
                                                                }
                                                              }
                                                            },
                                                            onLongPress: () {
                                                              showDialog(
                                                                context: context,
                                                                builder: (_) => ConsultaEstoqueModule(produto: produtoList[index])
                                                              );
                                                            }
                                                          );
                                                        }
                                                      }
                                                    );
                                                  }
                                                ),
                                              )
                                            );
                                          }
                                        }
                                      )
                                    )
                                  ),
                                  // Showcase.withWidget(
                                  //   key: botaoDirecionarCarrinho, 
                                  //   disposeOnTap: false,
                                  //   disableAnimation: true,
                                  //   width: 200,
                                  //   height: 200,
                                  //   container: Column(
                                  //     children: <Widget>[
                                  //       Row(
                                  //         children: <Widget>[
                                  //           Image.asset("assets/mascote.png", width: 60),
                                  //         ],
                                  //       ),
                                  //       SizedBox(height: 15),
                                  //       Row(
                                  //         children: <Widget>[
                                  //           Text("Clique para visualizar\no carrinho", 
                                  //             style: TextStyle(color: Colors.white,fontSize: 17),textAlign: TextAlign.center,)
                                  //         ],
                                  //       ),
                                  //       SizedBox(height: 15),
                                  //       Row(
                                  //         children: <Widget>[
                                  //           Image.asset("assets/setaAdicionarItem.png", width: 30)
                                  //         ],
                                  //       ),
                                  //     ],
                                  //   ),
                                  //   onTargetClick: () async {
                                  //     if (vendaBloc.tutorial.passo == 2) {
                                  //       await vendaBloc.setTutorialPasso(3);
                                  //     } else if (vendaBloc.tutorial.passo == 8) {
                                  //       await vendaBloc.setTutorialPasso(9);
                                  //     }
                                  //     pageController.nextPage(
                                  //       duration: Duration(milliseconds: 600),
                                  //       curve: Curves.fastOutSlowIn,
                                  //     );
                                  //   },
                                  //   child: 
                                    Container(
                                      width: double.infinity,
                                      color: Theme.of(context).primaryColor,  
                                      padding: EdgeInsets.only(bottom: 10, right: 20, left: 20, top: 5),
                                      child: ButtonTheme(
                                        height: 45.0,
                                        child: StreamBuilder<Movimento>(
                                          initialData: Movimento(),
                                          stream: vendaBloc.movimentoOut,
                                          builder: (context, snapshot) {
                                            Movimento movimento = snapshot.data;
                                            var moneyMask =	MoneyMaskedTextController(leftSymbol: "R\$ ");
                                            moneyMask.updateValue(movimento.valorRestante);
                                            return RaisedButton(
                                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                              color: Theme.of(context).accentColor,
                                              child:  AutoSizeText("Cobrar ${moneyMask.text}",
                                                // movimento.totalQuantidade.round() > 1
                                                //   ? "${movimento.totalQuantidade.round()} Itens  =   ${moneyMask.text}"
                                                //   : "${movimento.totalQuantidade.round()} Item   =   ${movimento.valorTotalLiquido < 0 ? "-" + moneyMask.text : moneyMask.text}",
                                                style: Theme.of(context).textTheme.title,
                                                maxFontSize: Theme.of(context).textTheme.title.fontSize,
                                                minFontSize: 8,
                                                maxLines: 1
                                              ),
                                              onPressed: () {
                                              if(movimento.movimentoItem.length > 0){
                                                pageController.animateToPage(2, duration: Duration(milliseconds: 100), curve: Curves.fastOutSlowIn);
                                                // pageController.nextPage(
                                                //   duration: Duration(milliseconds: 600),
                                                //   curve: Curves.fastOutSlowIn);
                                              }
                                            }
                                          );
                                        }
                                      )
                                    )
                                  )
                                // )
                              ],
                            ),
                            CarrinhoPage(),
                            PagamentoPage(),
                          ]
                        ),
                      )
                    ]
                  ),
                )
              ),
            );
          }
        );
      }
    );
  }
}