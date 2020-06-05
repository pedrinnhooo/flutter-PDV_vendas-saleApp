import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:fluggy/localization/localizations.dart';
import 'package:fluggy/src/app_module.dart';
import 'package:fluggy/src/home/cadastro_page.dart';
import 'package:fluggy/src/home/configuracao_page.dart';
import 'package:fluggy/src/home/home_module.dart';
import 'package:fluggy/src/home/menu_page.dart';
import 'package:fluggy/src/pages/cadastro/categoria/categoria_module.dart';
import 'package:fluggy/src/pages/cadastro/categoria/detail/categoria_detail_page.dart';
import 'package:fluggy/src/pages/cadastro/categoria/list/categoria_list_page.dart';
import 'package:fluggy/src/pages/cadastro/cliente/cliente_module.dart';
import 'package:fluggy/src/pages/cadastro/cliente/detail/cliente_detail_page.dart';
import 'package:fluggy/src/pages/cadastro/cliente/list/cliente_list_page.dart';
import 'package:fluggy/src/pages/cadastro/contato/detail/contato_detail_page.dart';
import 'package:fluggy/src/pages/cadastro/contato/list/contato_list_page.dart';
import 'package:fluggy/src/pages/cadastro/endereco/detail/endereco_detail_page.dart';
import 'package:fluggy/src/pages/cadastro/endereco/list/endereco_list_page.dart';
import 'package:fluggy/src/pages/cadastro/grade/detail/grade_detail_page.dart';
import 'package:fluggy/src/pages/cadastro/grade/grade_module.dart';
import 'package:fluggy/src/pages/cadastro/grade/list/grade_list_page.dart';
import 'package:fluggy/src/pages/cadastro/produto/detail/produto_detail_page.dart';
import 'package:fluggy/src/pages/cadastro/produto/list/produto_list_page.dart';
import 'package:fluggy/src/pages/cadastro/produto/produto_module.dart';
import 'package:fluggy/src/pages/cadastro/servico/detail/servico_detail_page.dart';
import 'package:fluggy/src/pages/cadastro/servico/list/servico_list_page.dart';
import 'package:fluggy/src/pages/cadastro/servico/servico_module.dart';
import 'package:fluggy/src/pages/cadastro/variante/detail/variante_detail_page.dart';
import 'package:fluggy/src/pages/cadastro/variante/list/variante_list_page.dart';
import 'package:fluggy/src/pages/cadastro/variante/variante_module.dart';
import 'package:fluggy/src/pages/configuracao/ajustes/ajustes_module.dart';
import 'package:fluggy/src/pages/configuracao/loja/list/loja_list_page.dart';
import 'package:fluggy/src/pages/configuracao/loja/loja_module.dart';
import 'package:fluggy/src/pages/configuracao/mercadopago/mercadopago_module.dart';
import 'package:fluggy/src/pages/configuracao/picpay/picpay_module.dart';
import 'package:fluggy/src/pages/configuracao/terminal/detail/terminal_detail_page.dart';
import 'package:fluggy/src/pages/configuracao/terminal/list/terminal_list_page.dart';
import 'package:fluggy/src/pages/configuracao/terminal/terminal_module.dart';
import 'package:fluggy/src/pages/configuracao/terminal_impressora/terminalL_impressora_module.dart';
import 'package:fluggy/src/pages/configuracao/tipo_pagamento/detail/tipo_pagamento_icone_page.dart';
import 'package:fluggy/src/pages/configuracao/tipo_pagamento/list/tipo_pagamento_list_page.dart';
import 'package:fluggy/src/pages/configuracao/tipo_pagamento/tipo_pagamento_module.dart';
import 'package:fluggy/src/pages/configuracao/transacao/list/transacao_list_page.dart';
import 'package:fluggy/src/pages/configuracao/transacao/transacao_module.dart';
import 'package:fluggy/src/pages/configuracao/vendedor/list/vendedor_list_page.dart';
import 'package:fluggy/src/pages/configuracao/vendedor/vendedor_module.dart';
import 'package:fluggy/src/pages/operacao/login/login_bloc.dart';
import 'package:fluggy/src/pages/operacao/login/login_module.dart';
import 'package:fluggy/src/pages/operacao/login_cadastro/login_cadastro_module.dart';
import 'package:fluggy/src/pages/report/dashboard/dashboard/dashboard_module.dart';
import 'package:fluggy/src/pages/report/list/sale/category/report_list_sale_category_page.dart';
import 'package:fluggy/src/pages/report/list/sale/payment/report_list_sale_payment_page.dart';
import 'package:fluggy/src/pages/report/list/sale/ticket/report_list_sale_ticket_detail_page.dart';
import 'package:fluggy/src/venda/carrinho/carrinho_page.dart';
import 'package:fluggy/src/venda/carrinho/desconto_item/desconto_item_page.dart';
import 'package:fluggy/src/venda/carrinho/quantidade_item/quantidade_item_page.dart';
import 'package:fluggy/src/venda/carrinho/valor_item/valor_item_page.dart';
import 'package:fluggy/src/venda/consulta_estoque/consulta_estoque_module.dart';
import 'package:fluggy/src/venda/consulta_movimento_cliente/consulta_movimento_cliente_module.dart';
import 'package:fluggy/src/venda/consulta_movimento_cliente/consulta_movimento_cliente_page.dart';
import 'package:fluggy/src/venda/consulta_movimento_cliente/pagamento_movimento_cliente/pagamento_movimento_cliente_page.dart';
import 'package:fluggy/src/venda/consulta_movimento_cliente/pagamento_movimento_cliente/pagamento_movimento_valor/pagamento_movimento_valor_page.dart';
import 'package:fluggy/src/venda/consulta_venda/consulta_venda_module.dart';
import 'package:fluggy/src/venda/grade/venda_grade_page.dart';
import 'package:fluggy/src/venda/movimento_caixa/movimento_caixa_module.dart';
import 'package:fluggy/src/venda/movimento_caixa/movimento_caixa_valor/movimento_caixa_valor_page.dart';
import 'package:fluggy/src/venda/orcamento/orcamento_page.dart';
import 'package:fluggy/src/venda/pagamento/pagamento_desconto/pagamento_desconto_module.dart';
import 'package:fluggy/src/venda/pagamento/pagamento_page.dart';
import 'package:fluggy/src/venda/pagamento/pagamento_valor/pagamento_valor_page.dart';
import 'package:fluggy/src/venda/pedido/pedido_page.dart';
import 'package:fluggy/src/venda/recibo/recibo_page.dart';
import 'package:fluggy/src/venda/transacao/venda_transacao_page.dart';
import 'package:fluggy/src/venda/variante/venda_variante_page.dart';
import 'package:fluggy/src/venda/venda_module.dart';
import 'package:flutter/material.dart';
import 'package:fluggy/src/app_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fluggy/src/pages/report/list/sale/ticket/report_list_sale_ticket_page.dart';
import 'package:fluggy/src/pages/report/list/sale/product/report_list_sale_product_page.dart';
import 'package:logger_flutter/logger_flutter.dart';

class AppWidget extends StatefulWidget {
  @override
  _AppWidgetState createState() => _AppWidgetState();
}

class _AppWidgetState extends State<AppWidget> with SingleTickerProviderStateMixin{
  AppBloc appBloc;
  LoginBloc loginBloc;
  FirebaseAnalytics analytics;
  FirebaseMessaging firebaseMessaging;
  AnimationController animationController;
  Animation<double> animation;
  Map<int, Color> color =
    {
      50:Color.fromRGBO(136,14,79, .1),
      100:Color.fromRGBO(136,14,79, .2),
      200:Color.fromRGBO(136,14,79, .3),
      300:Color.fromRGBO(136,14,79, .4),
      400:Color.fromRGBO(136,14,79, .5),
      500:Color.fromRGBO(136,14,79, .6),
      600:Color.fromRGBO(136,14,79, .7),
      700:Color.fromRGBO(136,14,79, .8),
      800:Color.fromRGBO(136,14,79, .9),
      900:Color.fromRGBO(136,14,79, 1),
    };
  
  @override
  void initState() {
    super.initState();
    loginBloc = AppModule.to.getBloc<LoginBloc>();
    appBloc = AppModule.to.getBloc<AppBloc>();
    analytics = FirebaseAnalytics();
    animationController = AnimationController(vsync: this, duration: Duration(milliseconds: 400));
    animation = Tween(begin: 0.0, end: 1.0).animate(animationController);
    animationController.forward();
    Crashlytics.instance.enableInDevMode = false;
    FlutterError.onError = Crashlytics.instance.recordFlutterError;
    firebaseMessaging = FirebaseMessaging();
    firebaseMessaging.getToken().then((token){
      print(token);
    });
    
    firebaseMessaging.requestNotificationPermissions(const IosNotificationSettings(sound: true, badge: true, alert: true, provisional: true));
    firebaseMessaging.onIosSettingsRegistered.listen((IosNotificationSettings settings) {
      print("Settings registered: $settings");
    });
    firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
        displayFirebaseNotification(message);
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
        displayFirebaseNotification(message);
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown
    ]);
    return StreamBuilder(
      initialData: Locale('pt'),
      stream: appBloc.localeOut,
      builder: (context, snapshot) {
        Locale locale = snapshot.data;
        return FutureBuilder<bool>(
          future: loginBloc.temTokenSharedPreferences(),
          builder: (context, snapshot) {
            if(!snapshot.hasData){
              return FadeTransition(
                opacity: animation,
                child: Container(
                  color: Color(0xff030c31),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      FadeTransition(
                        opacity: animation,
                        child: Image.asset('assets/palavraFluggy.png',
                          gaplessPlayback: true,
                          width: 200,
                          height: 200,
                        )
                      ),
                    ],
                  )
                ),
              );
            }
            bool temTokenSharedPreferences = snapshot.data;
            return MaterialApp(
              initialRoute: !temTokenSharedPreferences ? '/Login' : '/Venda',
              routes: {
                '/Login': (context) => LoginModule(),
                '/LoginCadastro': (context) => LoginCadastroModule(),
                '/Menu': (context) => HomeModule(),
                '/MenuCadastro': (context) => CadastroPage(),
                '/CadastroProduto': (context) => ProdutoModule(),
                '/CadastroCategoria': (context) => CategoriaModule(),
                '/CadastroServico': (context) => ServicoModule(),
                '/CadastroGrade': (context) => GradeModule(),
                '/CadastroVariante': (context) => VarianteModule(),
                '/CadastroCliente': (context) => ClienteModule(),
                '/ListaProduto': (context) => ProdutoListPage(),
                '/ListaCategoria': (context) => CategoriaListPage(),
                '/ListaServico': (context) => ServicoListPage(),
                '/ListaGrade': (context) => GradeListPage(),
                '/ListaVariante': (context) => VarianteListPage(),
                '/ListaCliente': (context) => ClienteListPage(),
                '/ListaContato': (context) => ContatoListPage(),
                '/ListaEndereco': (context) => EnderecoListPage(),
                '/ListaLoja': (context) => LojaListPage(),
                '/ListaTerminal': (context) => TerminalModule(),
                '/ListaTransacao': (context) => TransacaoListPage(),
                '/ListaVendedor': (context) => VendedorListPage(),
                '/ListaTipoPagamento': (context) => TipoPagamentoListPage(),
                '/ListaImpressora': (context) => ImpressoraModule(),
                '/SelecaoIconeTipoPagamento': (context) => TipoPagamentoIconePage(), 
                '/DetalheProduto': (context) => ProdutoDetailPage(),
                '/DetalheCategoria': (context) => CategoriaDetailPage(),
                '/DetalheServico': (context) => ServicoDetailPage(),
                '/DetalheGrade': (context) => GradeDetailPage(),
                '/DetalheVariante': (context) => VarianteDetailPage(),
                '/DetalheCliente': (context) => ClienteDetailPage(),
                '/DetalheContato': (context) => ContatoDetailPage(),
                '/DetalheEndereco': (context) => EnderecoDetailPage(),
                '/DetalheTerminal': (context) => TerminalDetailPage(),
                '/MenuConfiguracao': (context) => ConfiguracaoPage(),
                '/ConfiguracaoAjustes': (context) => AjustesModule(),
                '/ConfiguracaoLoja': (context) => LojaModule(),
                '/ConfiguracaoTerminal': (context) => TerminalModule(),
                '/ConfiguracaoTransacao': (context) => TransacaoModule(),
                '/ConfiguracaoVendedor': (context) => VendedorModule(),
                '/ConfiguracaoTipoPagamento': (context) => TipoPagamentoModule(),
                '/ConfiguracaoMercadopago' : (context) => MercadopagoModule(),
                '/Ajustes': (context) => AjustesModule(),
                '/Estoque': (context) => ConsultaEstoqueModule(),
                '/Venda': (context) => LogConsoleOnShake(dark: true, debugOnly: false, child: VendaModule()),
                '/VendaTransacao': (context) => VendaTransacaoPage(),
                '/VendaProdutoVariante': (context) => VendaVariantePage(),
                '/VendaProdutoGrade': (context) => VendaGradePage(),
                '/Carrinho': (context) => CarrinhoPage(),
                '/CarrinhoQuantidadeItem': (context) => QuantidadeItemPage(),
                '/CarrinhoValorItem': (context) => ValorItemPage(),
                '/CarrinhoDescontoItem': (context) => DescontoItemPage(),
                '/MovimentoValorPagamento': (context) => PagamentoMovimentoValorPage(),
                '/Recibo': (context) => ReciboPage(),
                '/Pedido': (context) => PedidoPage(),
                '/Pagamento': (context) => PagamentoPage(),
                '/PagamentoDesconto': (context) => PagamentoDescontoModule(),
                '/PagamentoValor': (context) => PagamentoValorPage(),
                '/Orcamento': (context) => OrcamentoPage(),
                '/Recibo': (context) => ReciboPage(),
                '/Transacao': (context) => TransacaoModule(),
                '/MovimentoCaixa': (context) => MovimentoCaixaModule(),
                '/MovimentoCaixaValor': (context) => MovimentoCaixaValorPage(),
                '/MovimentoCliente': (context) => ConsultaMovimentoClienteModule(),
                '/DetalheMovimentoCliente': (context) => ConsultaMovimentoClientePage(),
                '/MovimentoClientePagamento': (context) => PagamentoMovimentoClientePage(),
                '/ConsultaVenda': (context) => ConsultaVendaModule(),
                //Relatorio
                '/Dashboard': (context) => DashboardModule(),
                //Report Lists - 
                '/ReportListSaleTicketPage': (context) => ReportListSaleTicketPage(),
                '/ReportListSaleTicketDetailPage': (context) => ReportListSaleTicketDetailPage(),
                '/ReportListSaleProductPage': (context) => ReportListSaleProductPage(),
                '/ReportListSalePaymentPage': (context) => ReportListSalePaymentPage(),
                '/ReportListSaleCategoryPage': (context) => ReportListSaleCategoryPage(),
              },
              debugShowCheckedModeBanner: false,
              localizationsDelegates: [
                LocDelegate(),
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
              ],
              navigatorObservers: [
                FirebaseAnalyticsObserver(analytics: analytics),
              ],
              supportedLocales: [
                Locale('pt'),
                Locale('en'), 
                Locale('es')
              ],
              locale: locale,
              title: 'fluggy Software',
              //darkTheme
              theme: ThemeData(
                primarySwatch: MaterialColor(0xff030c31, color),
                primaryIconTheme: IconThemeData(color: MaterialColor(0xff2fa98d, color)),
                accentColor: MaterialColor(0xff2e3c76, color),
                canvasColor: MaterialColor(0xff2e3c76, color),
                cursorColor: Colors.white,
                brightness: Brightness.light,
                unselectedWidgetColor: Colors.white60,
                textTheme: TextTheme(
                  overline: GoogleFonts.sourceSansPro(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.w400,
                    letterSpacing: 3
                  ),
                  caption: GoogleFonts.sourceSansPro(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w400
                  ),
                  button: GoogleFonts.sourceSansPro(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500
                  ),
                  body2: GoogleFonts.sourceSansPro(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w400
                  ),
                  body1: GoogleFonts.sourceSansPro(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w400
                  ),
                  subtitle: GoogleFonts.sourceSansPro(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500
                  ),
                  subhead: GoogleFonts.sourceSansPro(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w400
                  ),
                  title: GoogleFonts.sourceSansPro(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w400
                  ),
                  headline: GoogleFonts.sourceSansPro(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w400
                  ),
                  display1: GoogleFonts.sourceSansPro(
                    color: Colors.white,
                    fontSize: 34,
                    fontWeight: FontWeight.w400
                  ),
                  display2: GoogleFonts.sourceSansPro(
                    color: Colors.white,
                    fontSize: 48,
                    fontWeight: FontWeight.w400
                  ),
                  display3: GoogleFonts.sourceSansPro(
                    color: Colors.white,
                    fontSize: 60,
                    fontWeight: FontWeight.w300
                  ),
                  display4: GoogleFonts.sourceSansPro(
                    color: Colors.white,
                    fontSize: 96,
                    fontWeight: FontWeight.w300
                  ),
                ),
              ),
            );
          }
        );
      }
    );
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
}