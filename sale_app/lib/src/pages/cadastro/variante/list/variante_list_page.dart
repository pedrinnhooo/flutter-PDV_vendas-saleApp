import 'dart:io';

import 'package:common_files/common_files.dart';
import 'package:fluggy/generated/locale_base.dart';
import 'package:fluggy/src/pages/widgets/Drawer/drawer.dart';
import 'package:flutter/material.dart';
import 'package:fluggy/src/pages/cadastro/produto/produto_module.dart';
import 'package:fluggy/src/pages/cadastro/variante/detail/variante_detail_page.dart';
import 'package:fluggy/src/pages/cadastro/variante/variante_module.dart';
import 'package:path_provider/path_provider.dart';

class VarianteListPage extends StatefulWidget {
  VarianteListPage({Key key}) : super(key: key);

  @override
  _VarianteListState createState() => _VarianteListState();
}

class _VarianteListState extends State<VarianteListPage> {
  VarianteBloc varianteBloc;
  ProdutoBloc produtoBloc;
  GlobalKey<ScaffoldState> _scaffoldKey;

  @override
  void initState() { 
    super.initState();
    _scaffoldKey  = GlobalKey<ScaffoldState>();
    varianteBloc = VarianteModule.to.getBloc<VarianteBloc>();
    try {
      produtoBloc = ProdutoModule.to.getBloc<ProdutoBloc>();
    } catch (e) {
      produtoBloc = null;
    }
  }

  bool findVarianteOnVarianteList({Variante variante, List<Variante> array}){
    for(var i=0; i<array.length; i++){
      if(array[i].nome == variante.nome){
        return true;
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.of<LocaleBase>(context, LocaleBase);

    Future _initRequester() async {
      return varianteBloc.getAllVariante();
    }

    Future<List> _dataRequester() async {
      return Future.delayed(Duration(milliseconds: 100), () async {
        return await varianteBloc.getAllVariante();
      });
    }

    Function _itemBuilder = (List dataList, BuildContext context, int index) {
      return ListTile(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            InkWell(
              child: Container(
                child: Visibility(
                  visible: produtoBloc == null ? false : true,
                  child: produtoBloc != null ? Checkbox(
                    activeColor: Theme.of(context).primaryIconTheme.color,
                    value: findVarianteOnVarianteList(variante: dataList[index], array: produtoBloc.varianteList),
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    onChanged: (i) {
                      if(findVarianteOnVarianteList(variante: dataList[index], array: produtoBloc.varianteList)){
                        produtoBloc.removeVarianteList(dataList[index]);
                      } else {
                        produtoBloc.addVarianteList(dataList[index]);
                      }
                      varianteBloc.updateStream();
                    },
                  ) : SizedBox.shrink(),
                ),
              ),
              onTap: () {
                if(produtoBloc != null){
                  if(findVarianteOnVarianteList(variante: dataList[index], array: produtoBloc.varianteList)){
                    produtoBloc.removeVarianteList(dataList[index]);
                  } else {
                    produtoBloc.addVarianteList(dataList[index]);
                  }
                  varianteBloc.updateStream();
                }
              },
            ),
            Text("${dataList[index].nome}",
              style: Theme.of(context).textTheme.body2,
            )
          ]
        ),
        trailing: Container(
          height: 30,
          width: 30,
          child: InkWell(
            child: Icon(
              Icons.edit, 
              color: Colors.white 
              //Theme.of(context).primaryIconTheme.color
            ),
            onTap: () async {
              var appDir = (await getTemporaryDirectory()).path;
              Directory(appDir).delete(recursive: true);
              await varianteBloc.getVarianteById(dataList[index].id);
              Navigator.push(context,
                PageRouteBuilder(
                  pageBuilder: (c, a1, a2) => VarianteDetailPage(),
                  settings: RouteSettings(name: '/DetalheVariante'),
                  transitionsBuilder: (c, anim, a2, child) => FadeTransition(opacity: anim, child: child),
                  transitionDuration: Duration(milliseconds: 180),
                ),
              );
            },
          ),
        ),
        onTap: () {
          if(produtoBloc != null){
            if(findVarianteOnVarianteList(variante: dataList[index], array: produtoBloc.varianteList)){
              produtoBloc.removeVarianteList(dataList[index]);
            } else {
              produtoBloc.addVarianteList(dataList[index]);
            }
            varianteBloc.updateStream();
          }
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
                  onSubmitted: (text) async {
                    varianteBloc.filtroNome = text;
                    varianteBloc.offset = 0;
                    varianteBloc.getAllVariante();
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
                          await varianteBloc.newVariante();
                          Navigator.push(
                            context,
                            PageRouteBuilder(
                              pageBuilder: (c, a1, a2) => VarianteDetailPage(),
                              settings: RouteSettings(name: '/DetalheVariante'),
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
                        bloc: varianteBloc,
                        stream: varianteBloc.varianteListOut,
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
                              child: Image.asset('assets/varianteIcon.png',
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
                                  await varianteBloc.newVariante();
                                  Navigator.push(
                                    context,
                                    PageRouteBuilder(
                                      pageBuilder: (c, a1, a2) => VarianteDetailPage(),
                                      settings: RouteSettings(name: '/DetalheVariante'),
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
        title: Text(locale.cadastroVariante.titulo, 
          style: Theme.of(context).textTheme.title,
        ),
        leading:  StreamBuilder(
          stream: varianteBloc.appGlobalBloc.configuracaoGeralOut,
          builder: (context, snapshot) {
            if (!snapshot.hasData){
              return CircularProgressIndicator();
            }
            ConfiguracaoGeral configuracaoGeral = snapshot.data;
            return IconButton(
              icon: Icon(configuracaoGeral.ehMenuClassico == 1 ? 
              Icons.menu : Icons.arrow_back,color: Theme.of(context).primaryIconTheme.color),
              onPressed: () {
                if (configuracaoGeral.ehMenuClassico == 1) {
                  _scaffoldKey.currentState.openDrawer();
                } else { 
                  Navigator.pop(context);
                }
              }
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