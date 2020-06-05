import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:fluggy/generated/locale_base.dart';
import 'package:fluggy/src/app_module.dart';
import 'package:fluggy/src/pages/widgets/Drawer/drawer.dart';
import 'package:flutter/material.dart';
import 'package:fluggy/src/pages/cadastro/produto/detail/produto_detail_page.dart';
import 'package:fluggy/src/pages/cadastro/produto/produto_module.dart';
import 'package:common_files/common_files.dart';
import 'package:flutter_colorpicker/utils.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';

class ProdutoListPage extends StatefulWidget {
  @override
  _ProdutoListPageState createState() => _ProdutoListPageState();
}

class _ProdutoListPageState extends State<ProdutoListPage> {
  ProdutoBloc produtoBloc;
  HasuraBloc hasuraBloc;
  MoneyMaskedTextController precoTabelaItem;
  GlobalKey<ScaffoldState> _scaffoldKey;
  
  @override
  void initState() {
    _scaffoldKey  = GlobalKey<ScaffoldState>();
    produtoBloc = ProdutoModule.to.getBloc<ProdutoBloc>();
    hasuraBloc = AppModule.to.getBloc<HasuraBloc>();
    precoTabelaItem = MoneyMaskedTextController(leftSymbol: 'R\$ ');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.of<LocaleBase>(context, LocaleBase);

    Future _initRequester() async {
      return produtoBloc.getAllProduto();
    }

    Future<List> _dataRequester() async {
      return Future.delayed(Duration(milliseconds: 100), () async {
        return await produtoBloc.getAllProduto();
      });
    }

    Function _itemBuilder = (List dataList, BuildContext context, int index) {
      precoTabelaItem.updateValue(dataList[index].precoTabelaItem.first.preco);
      return InkWell(
        child: ListTile(
          leading: Container(
            width: 50,
            height: 50,
            child: dataList[index].produtoImagem.length > 0 
            ?  CachedNetworkImage(
                imageUrl: '$s3Endpoint${dataList[index].produtoImagem.first.imagem}',
                errorWidget: (context, erro, object){
                  log(
                    hasuraBloc,
                    produtoBloc.appGlobalBloc,
                    mensagemErro: erro,
                    nomeArquivo: "produto_list_page",
                    nomeFuncao: "Widget -> CachedNetworkImage"
                  );
                  return Icon(
                    Icons.error_outline, 
                    color: Colors.white,
                  );
                },
                fadeInDuration: Duration(milliseconds: 80),
                imageBuilder: (context, imageProvider){
                  return Container(
                    // width: 120,
                    // height: 120,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      image: DecorationImage(
                        image: imageProvider,
                        fit: BoxFit.fill,
                      )
                    )
                  );
                },
              )
          : ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Container(
                color: Color(int.parse(dataList[index].iconeCor)),
                child: Center(
                  child: Text("${dataList[index].nome}".substring(0, 2), 
                    style: TextStyle(
                      color: useWhiteForeground(Color(int.parse(dataList[index].iconeCor)))
                        ? const Color(0xffffffff)
                        : const Color(0xff000000), 
                      fontSize: Theme.of(context).textTheme.title.fontSize)
                  ),
                ),
              )
            ),
          ),
          title: Text("${dataList[index].nome}",
            style: Theme.of(context).textTheme.body1,
          ),
          subtitle: Text("${dataList[index].categoria.nome}", 
            style: Theme.of(context).textTheme.body2,
          ),
          trailing: Container(
            child: Text("${precoTabelaItem.text}", style: Theme.of(context).textTheme.subhead,)
          )
        ),
        onTap: () async {
          await produtoBloc.getProdutoById(dataList[index].id);
          Navigator.push(
            context,
            PageRouteBuilder(
              pageBuilder: (c, a1, a2) => ProdutoDetailPage(),
              settings: RouteSettings(name: '/DetalheProduto'),
              transitionsBuilder: (c, anim, a2, child) => FadeTransition(opacity: anim, child: child),
              transitionDuration: Duration(milliseconds: 180),
            ),
          );
        },
      );
    };
    
    Widget header = Padding(
      padding: EdgeInsets.all(10),
      child: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Flexible(
              flex: 4,
                child: Container(
                padding: EdgeInsets.only(left: 15),
                child: TextField(
                  style: Theme.of(context).textTheme.body2,
                  decoration: InputDecoration(
                    icon: Icon(Icons.search, color: Colors.white70),
                    hintText: locale.palavra.pesquisar,
                    hintStyle: Theme.of(context).textTheme.body2,
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.white70),
                    ), 
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.white70),
                    ), 
                  ),
                  onSubmitted: (text) {
                    produtoBloc.filtroNome = text;
                    produtoBloc.offset = 0;
                    produtoBloc.getAllProduto();
                  },
                ),
              ),
            ),
            Expanded(
              child: Container(
                child: Column(
                  children: <Widget>[
                    Center(
                      child: FloatingActionButton(
                        mini: true,
                        backgroundColor: Theme.of(context).primaryIconTheme.color,
                        child: Icon(Icons.add,
                          color: Colors.white,
                        ),
                        onPressed: () async {
                          await produtoBloc.newProduto();
                          Navigator.push(
                            context,
                            PageRouteBuilder(
                              pageBuilder: (c, a1, a2) => ProdutoDetailPage(),
                              settings: RouteSettings(name: '/DetalheProduto'),
                              transitionsBuilder: (c, anim, a2, child) => FadeTransition(opacity: anim, child: child),
                              transitionDuration: Duration(milliseconds: 180),
                            ),
                          );
                        },
                      ),
                    )
                  ],
                )
              ),
            )
          ],
        ),
      )
    );

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
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[ 
                    Expanded(
                      child: DynamicListView.build(
                        bloc: produtoBloc,
                        stream: produtoBloc.produtoListOut,
                        itemBuilder: _itemBuilder,
                        dataRequester: _dataRequester,
                        initRequester: _initRequester,
                        initLoadingWidget: Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: CircularProgressIndicator(backgroundColor: Colors.white,),
                        ),
                        moreLoadingWidget: Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: CircularProgressIndicator(backgroundColor: Colors.white,),
                        ),
                        noDataWidget: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(bottom: 25.0),
                              child: Image.asset('assets/produtoIcon.png',
                                width: 100,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 25.0),
                              child: Text("Você não possui nenhum produto cadastrado."),
                            ),
                            ButtonTheme(
                              height: 40,
                              minWidth: 200,
                              child: RaisedButton(
                                color: Theme.of(context).primaryIconTheme.color,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)
                                ),
                                child: Text("Incluir",
                                  style: Theme.of(context).textTheme.title,
                                ),
                                onPressed: () async {
                                  await produtoBloc.newProduto();
                                  Navigator.push(
                                    context,
                                    PageRouteBuilder(
                                      pageBuilder: (c, a1, a2) => ProdutoDetailPage(),
                                      settings: RouteSettings(name: '/DetalheProduto'),
                                      transitionsBuilder: (c, anim, a2, child) => FadeTransition(opacity: anim, child: child),
                                      transitionDuration: Duration(milliseconds: 180),
                                    ),
                                  );
                                },
                              )
                            ),
                          ],
                        )
                      ),
                    )
                  ]
                )
              )
            ]
          )
        )
      )
    );  

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(locale.cadastroProduto.titulo,
          style: Theme.of(context).textTheme.title,
        ),
        leading:  StreamBuilder(
          stream: produtoBloc.appGlobalBloc.configuracaoGeralOut,
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
            header,
            body
          ],
        ),
      ),
    );
  }
}

Future getImageFromServer(String path) async {
  Response response = await Dio().get('$s3Endpoint$path',
    options: Options(
      responseType: ResponseType.bytes
    )
  );
  return base64.encode(response.data);
}