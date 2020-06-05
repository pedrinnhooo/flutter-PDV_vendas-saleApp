import 'dart:convert';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:fluggy/src/app_module.dart';
import 'package:path/path.dart' as path_;
import 'package:common_files/common_files.dart';
import 'package:fluggy/src/pages/cadastro/produto/produto_module.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/utils.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:fluggy/src/AppConfig.dart';
import 'package:fluggy/src/venda/consulta_estoque/consulta_estoque_cor/consulta_estoque_cor_page.dart';
import 'package:fluggy/src/venda/consulta_estoque/consulta_estoque_module.dart';
import 'package:fluggy/src/venda/consulta_estoque/consulta_estoque_tamanho/consulta_estoque_tamanho_page.dart';

class ConsultaEstoquePage extends StatefulWidget {
  @override
  _ConsultaEstoquePageState createState() => _ConsultaEstoquePageState();
}

class _ConsultaEstoquePageState extends State<ConsultaEstoquePage> with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  MoneyMaskedTextController valorFormatado;
  ConsultaEstoqueBloc consultaEstoqueBloc;
  SharedVendaBloc vendaBloc;
  Animation<double> animation;
  AnimationController controller;
  ProdutoModule produtoModule;
  ProdutoBloc produtoBloc;
  TabController _tabController;

  @override
  void initState() {
    super.initState();
    consultaEstoqueBloc = ConsultaEstoqueModule.to.getBloc<ConsultaEstoqueBloc>();
    produtoModule = ConsultaEstoqueModule.to.getDependency<ProdutoModule>();
    produtoBloc = ConsultaEstoqueModule.to.getBloc<ProdutoBloc>();
    vendaBloc = AppModule.to.getBloc<SharedVendaBloc>();
    valorFormatado = MoneyMaskedTextController(leftSymbol: 'R\$ ');
    consultaEstoqueBloc.pageCounter = 0;
    consultaEstoqueBloc.notificaContador();
    _tabController = TabController(length: 1, vsync: this, initialIndex: 0);
    _tabController.addListener(_handleTabSelection);
    valorFormatado.updateValue(consultaEstoqueBloc.produto.precoTabelaItem.first.preco);
    controller = AnimationController(duration: const Duration(seconds: 1), vsync: this);
    controller.repeat();
    init();
  }

  init() async { 
    if (consultaEstoqueBloc.movimentoEstoqueList == null || consultaEstoqueBloc.movimentoEstoqueList.length == 0) {
      await consultaEstoqueBloc.getAllEstoque();
      if (consultaEstoqueBloc.produto.grade.id != null && consultaEstoqueBloc.produto.produtoVariante.length > 0) {
        consultaEstoqueBloc.produto.produtoVariante.forEach((produtoVariante){
          consultaEstoqueBloc.consultaGrade(idVariante: produtoVariante.idVariante, ehEdicaoEstoque: false);
        });
        await consultaEstoqueBloc.consultaEstoqueTotal(ehEdicaoEstoque: false);
      } else if(consultaEstoqueBloc.produto.grade.id != null) {
        consultaEstoqueBloc.consultaGrade(ehEdicaoEstoque: false);
        await consultaEstoqueBloc.consultaEstoqueTotal(ehEdicaoEstoque: false);
      } else if (consultaEstoqueBloc.produto.produtoVariante.length > 0) {
        await consultaEstoqueBloc.consultaVariante();
        await consultaEstoqueBloc.consultaEstoqueTotal(ehEdicaoEstoque: false);
      }
    }
  }

  void _handleTabSelection () async {
    print("aaaaaaaaaaaaa");
    if(_tabController.indexIsChanging){
      print("aaaaaaaaaaaaa");
    }
  }

  @override
  Widget build(BuildContext context) {
    AppConfig().init(context);
    return Material(
      color: Colors.transparent,
      child: Container(
        width: double.maxFinite,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 15, left: 15),
              child: Container(
                height: MediaQuery.of(context).size.width + 200 ,
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.symmetric(vertical: 8,),
                decoration: BoxDecoration(
                  color: Theme.of(context).accentColor,
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10.0,
                      offset: const Offset(0.0, 10.0),
                    ),
                  ],
                ),
                child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: StreamBuilder(
                      stream: consultaEstoqueBloc.pageCounterOut,
                      builder: (context, snapshot) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            InkWell(
                              child: consultaEstoqueBloc.pageCounter == 0
                              ? Text("")
                              : Icon(
                                  Icons.arrow_back,
                                  color: Colors.white,
                                  size: 32,
                                ),
                              onTap: () {
                                if (consultaEstoqueBloc.pageController.page == 1) {
                                  consultaEstoqueBloc.pageController.jumpToPage(0);
                                  consultaEstoqueBloc.pageCounter = 0;
                                  consultaEstoqueBloc.updateProdutoStream();
                                  consultaEstoqueBloc.notificaContador();
                                } else if(consultaEstoqueBloc.produto.idGrade != null) {
                                  consultaEstoqueBloc.pageController.jumpToPage(1);
                                  consultaEstoqueBloc.pageCounter = 1;
                                  consultaEstoqueBloc.notificaContador();
                                } else {
                                  consultaEstoqueBloc.pageController.jumpToPage(0);
                                  consultaEstoqueBloc.pageCounter = 0;
                                  consultaEstoqueBloc.updateProdutoStream();
                                  consultaEstoqueBloc.notificaContador();
                                }
                              },
                            ),
                            InkWell(
                              child: Icon(Icons.close, color: Colors.white, size: 32),
                              onTap: () {
                                Navigator.pop(context);
                              },
                            ),
                          ],
                        );
                      }
                    ),
                  ),
                  Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        PageView(
                          physics: NeverScrollableScrollPhysics(),
                          controller: consultaEstoqueBloc.pageController,
                          children: <Widget>[
                            Column(
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Expanded(
                                      child: Stack(
                                        children: <Widget>[
                                          Padding(
                                            padding: const EdgeInsets.only(top: 30.0, right: 8, left: 8),
                                            child: Container(
                                              height: 180,
                                              decoration: BoxDecoration(
                                                color: Theme.of(context).primaryColor,
                                                borderRadius: BorderRadius.circular(10)
                                              ),
                                              child: StreamBuilder<Produto>(
                                                stream: consultaEstoqueBloc.produtoControllerOut,
                                                builder: (context, snapshot) {
                                                  if(!snapshot.hasData){
                                                    return CircularProgressIndicator();
                                                  }
                                                  Produto produto = snapshot.data;
                                                  return Column(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: <Widget>[
                                                      Padding(
                                                        padding: const EdgeInsets.all(8.0),
                                                        child: InkWell(
                                                            child: Container(
                                                            alignment: Alignment.topRight,
                                                            child: Icon(Icons.edit, color: Colors.white70, size: 25,),
                                                          ),
                                                          onTap: () async {
                                                            await produtoBloc.getProdutoById(consultaEstoqueBloc.produto.id);
                                                            produtoModule.produto = produtoBloc.produto;
                                                            Navigator.push(
                                                              context,
                                                              PageRouteBuilder(
                                                                pageBuilder: (c, a1, a2) => produtoModule,
                                                                settings: RouteSettings(name: '/DetalheProduto'),
                                                                transitionsBuilder: (c, anim, a2, child) => FadeTransition(opacity: anim, child: child),
                                                                transitionDuration: Duration(milliseconds: 180),
                                                              ),
                                                            );
                                                          },
                                                        ),
                                                      ),
                                                      Container(
                                                        alignment: Alignment.bottomCenter,
                                                        padding: EdgeInsets.only(bottom: 15),
                                                        child: Column(
                                                          mainAxisAlignment: MainAxisAlignment.end,
                                                          crossAxisAlignment: CrossAxisAlignment.center,
                                                          children: <Widget>[
                                                            Text("${produto.idAparente}",style: Theme.of(context).textTheme.body2),
                                                            Container(
                                                              alignment: Alignment.center,
                                                              width: 200,
                                                              child: AutoSizeText(
                                                                "${produto.nome}",
                                                                style: Theme.of(context).textTheme.subhead,
                                                                maxFontSize: Theme.of(context).textTheme.subhead.fontSize,
                                                                minFontSize: 8,
                                                                maxLines: 2,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  );
                                                }
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(top: 10.0),
                                            child: Align(
                                              alignment: Alignment.topCenter,
                                              child: Container(
                                                width: 115,
                                                height: 115,
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
                                                  consultaEstoqueBloc.produto.produtoImagem.length > 0 && consultaEstoqueBloc.produto.produtoImagem.first.ehDeletado == 0
                                                    ? FutureBuilder<String>(
                                                        future: readBase64Image("${consultaEstoqueBloc.produto.produtoImagem.first.imagem.replaceAll(".png", "")}.txt"),
                                                        builder: (context, snapshot){
                                                          return AnimatedOpacity(
                                                            duration: Duration(milliseconds: 100),
                                                            opacity: snapshot.hasData ? 1.0 : 0.0,
                                                            child: ClipRRect(
                                                              borderRadius: BorderRadius.circular(8),
                                                              child: snapshot.hasData ? Image.memory(base64Decode(snapshot.data),
                                                                gaplessPlayback: true,
                                                                fit: BoxFit.cover, 
                                                                width: 115,
                                                                height: 115,
                                                              ) : SizedBox.shrink(),
                                                            )
                                                          );
                                                        },
                                                      )
                                                    : ClipRRect(
                                                      borderRadius: BorderRadius.circular(12),
                                                      child: Container(
                                                        color: Color(int.parse(consultaEstoqueBloc.produto.iconeCor)),
                                                        child: Center(
                                                          child: TextFormField(
                                                            maxLength: 8,
                                                            controller: TextEditingController(),
                                                            decoration: InputDecoration(
                                                              counterText: '',
                                                              border: InputBorder.none,
                                                              hintText: ""
                                                            ),
                                                            maxLines: 1,
                                                            style: TextStyle(
                                                            color: useWhiteForeground(Color(int.parse(consultaEstoqueBloc.produto.iconeCor)))
                                                              ? const Color(0xffffffff)
                                                              : const Color(0xff000000), 
                                                              fontSize: 23,
                                                              fontWeight: FontWeight.w500
                                                            ),
                                                            onChanged: (text) {
                                                              consultaEstoqueBloc.produto.nome = text;
                                                            },
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
                                                              "${consultaEstoqueBloc.produto.nome}",
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
                                                              "${valorFormatado.text}",
                                                              style: Theme.of(context).textTheme.body2,
                                                              maxFontSize: Theme.of(context).textTheme.body2.fontSize,
                                                              minFontSize: 8,
                                                              maxLines: 1,
                                                            ),
                                                          )
                                                        )  
                                                      ],
                                                    )
                                                  ]
                                                )
                                              )
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                Expanded(
                                  child: Container(
                                  alignment: Alignment.center,
                                  child:  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Text(
                                        "Estoque",
                                        textAlign: TextAlign.center,
                                        style: Theme.of(context).textTheme.title
                                      ),
                                      StreamBuilder(
                                        initialData: 0.0,
                                        stream: consultaEstoqueBloc.estoqueTotalOut,
                                        builder: (context, snapshot) {
                                          if(!snapshot.hasData){
                                            return Text("0",
                                              style: TextStyle(
                                                fontSize: 32,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.white
                                              ),
                                            );
                                          }

                                          if(consultaEstoqueBloc.produto.idGrade != null || consultaEstoqueBloc.produto.produtoVariante.length > 0){
                                            return DecoratedBoxTransition(
                                              child: InkWell(
                                                child: DecoratedBox(
                                                  decoration: BoxDecoration(),
                                                  child: Container(
                                                    width: 60,
                                                    height: 60,
                                                    child: Center(
                                                      child: Text("${snapshot.data.toString()}", style: Theme.of(context).textTheme.body2,),
                                                    ),
                                                  ),
                                                ),
                                                onTap: () {
                                                  if (consultaEstoqueBloc.produto.idGrade != null && consultaEstoqueBloc.produto.idGrade > 0) {
                                                    consultaEstoqueBloc.pageController.jumpToPage(1);
                                                  } else if (consultaEstoqueBloc.produto.produtoVariante != null && consultaEstoqueBloc.produto.produtoVariante.length > 0) {
                                                    consultaEstoqueBloc.pageController.jumpToPage(2);
                                                  }
                                                },
                                              ),
                                              decoration: DecorationTween(
                                                begin: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(60),
                                                  color: Theme.of(context).primaryColor,
                                                ), 
                                                end: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(60),
                                                ), 
                                              ).animate(controller),
                                            );
                                          }
                                          return Text("${snapshot.data.toString()}",
                                            style: TextStyle(
                                              fontSize: 32,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.white),
                                            );
                                          },
                                        ),
                                      ]
                                    )
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 10.0),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: <Widget>[
                                        Text(
                                          "Preço de venda",
                                          textAlign: TextAlign.center,
                                          style: Theme.of(context).textTheme.subhead
                                        ),
                                        StreamBuilder(
                                          stream: consultaEstoqueBloc.produtoControllerOut,
                                          builder: (context, snapshot) {
                                            if(!snapshot.hasData){
                                              return CircularProgressIndicator();
                                            }
                                            Produto produto = snapshot.data;
                                            valorFormatado.updateValue(produto.precoTabelaItem.first.preco);
                                            return Text("${valorFormatado.text}", style: Theme.of(context).textTheme.headline,);
                                          }
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(bottom: 8.0),
                                          child: Center(
                                            child: Text("Ultima venda: 22/10/2019", style: Theme.of(context).textTheme.body2,),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Container(
                                  alignment: Alignment.bottomCenter,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.only(bottom: 15),
                                        child: Divider(color: Colors.white70, height: 1),
                                      ),
                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                                        children: <Widget>[
                                          FlatButton(
                                            splashColor: Colors.white24,
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.end,
                                              children: <Widget>[
                                                Padding(
                                                  padding: const EdgeInsets.only(bottom: 6.0),
                                                  child: Image.asset('assets/compartilharIcon.png', width: 25,),
                                                ),
                                                Text("Compartilhar", style: Theme.of(context).textTheme.body2,)
                                              ],
                                            ),
                                            onPressed: () {
                                              
                                            },
                                          ),
                                          FlatButton(
                                            splashColor: Colors.white24,
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.end,
                                              children: <Widget>[
                                                Padding(
                                                  padding: const EdgeInsets.only(bottom: 8.0),
                                                  child: Image.asset('assets/trocaIcon.png', width: 25,),
                                                ),
                                                Text("Troca", style: Theme.of(context).textTheme.body2,)
                                              ],
                                            ),
                                            onPressed: () async {
                                              await vendaBloc.addMovimentoItemTroca(consultaEstoqueBloc.produto.id, null, null);
                                              Navigator.pop(context);
                                            },
                                          )
                                        ],
                                      ),
                                    ],
                                  )
                                )
                              ],
                            ),
                            ConsultaEstoqueTamanhoPage(),
                            ConsultaEstoqueCorPage()
                          ]
                        ),
                      ]
                    ),
                  )
                ],
              ),
            ),
          ),
        ]),
      ),
    );
  }
  @override
  void dispose() {
    controller.stop();
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;
}