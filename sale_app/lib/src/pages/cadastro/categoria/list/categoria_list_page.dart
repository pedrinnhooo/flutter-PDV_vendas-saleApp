import 'package:common_files/common_files.dart';
import 'package:fluggy/generated/locale_base.dart';
import 'package:fluggy/src/pages/cadastro/servico/servico_module.dart';
import 'package:fluggy/src/pages/widgets/Drawer/drawer.dart';
import 'package:flutter/material.dart';
import 'package:fluggy/src/pages/cadastro/categoria/categoria_module.dart';
import 'package:fluggy/src/pages/cadastro/categoria/detail/categoria_detail_page.dart';
import 'package:fluggy/src/pages/cadastro/produto/produto_module.dart';

class CategoriaListPage extends StatefulWidget {
  @override
  _CategoriaListPageState createState() => _CategoriaListPageState();
}

class _CategoriaListPageState extends State<CategoriaListPage> {
  CategoriaBloc categoriaBloc;
  ProdutoBloc produtoBloc;
  ServicoBloc servicoBloc;
  GlobalKey<ScaffoldState> _scaffoldKey;
  
  @override
  void initState() {
    super.initState();
    categoriaBloc = CategoriaModule.to.getBloc<CategoriaBloc>();
    _scaffoldKey  = GlobalKey<ScaffoldState>();
    try {
      servicoBloc = ServicoModule.to.getBloc<ServicoBloc>();
      categoriaBloc.ehServico = true;
    } catch (e) {
      servicoBloc = null;
    }
    try {
      produtoBloc = ProdutoModule.to.getBloc<ProdutoBloc>();
      categoriaBloc.ehServico = false;
    } 
    catch (e) {
      produtoBloc = null;
    }
  }

  @override
  Widget build(BuildContext context) {  
    final locale = Localizations.of<LocaleBase>(context, LocaleBase);

    Future _initRequester() async {
      return categoriaBloc.getAllCategoria();
    }

    Future<List> _dataRequester() async {
      return Future.delayed(Duration(milliseconds: 100), () async {
        return await categoriaBloc.getAllCategoria();
      });
    }

    Function _itemBuilder = (List dataList, BuildContext context, int index) {
      return ListTile(
        onTap: () {
          if (produtoBloc != null) {
            produtoBloc.setCategoria(dataList[index]); 
            Navigator.pop(context);
          }
        },
        title: Text("${dataList[index].nome}",
          style: Theme.of(context).textTheme.body2,
        ),
        trailing: Container(
          height: 30,
          width: 30,
          child: InkWell(
            child: Icon(
              Icons.edit, 
              color: Colors.white70
            ),
            onTap: () async {
              await categoriaBloc.getCategoriaById(dataList[index].id);
              Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder: (c, a1, a2) => CategoriaDetailPage(),
                  settings: RouteSettings(name: '/DetalheCategoria'),
                  transitionsBuilder: (c, anim, a2, child) => FadeTransition(opacity: anim, child: child),
                  transitionDuration: Duration(milliseconds: 180),
                ),
              );
            },
          ),
        )
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
                    categoriaBloc.filtroNome = text;
                    categoriaBloc.offset = 0;
                    await categoriaBloc.getAllCategoria();
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
                          await categoriaBloc.newCategoria();
                          Navigator.push(context,
                            PageRouteBuilder(
                              pageBuilder: (c, a1, a2) => CategoriaDetailPage(),
                              settings: RouteSettings(name: '/DetalheCategoria'),
                              transitionsBuilder: (c, anim, a2, child) => FadeTransition(opacity: anim, child: child),
                              transitionDuration:Duration(milliseconds: 180),
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
                        bloc: categoriaBloc,
                        stream: categoriaBloc.categoriaListOut,
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
                              child: Text("Você não possui nenhuma categoria cadastrada."),
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
                                  await categoriaBloc.newCategoria();
                                  Navigator.push(context,
                                    PageRouteBuilder(
                                      pageBuilder: (c, a1, a2) => CategoriaDetailPage(),
                                      settings: RouteSettings(name: '/DetalheCategoria'),
                                      transitionsBuilder: (c, anim, a2, child) => FadeTransition(opacity: anim, child: child),
                                      transitionDuration:Duration(milliseconds: 180),
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
        title: Text(locale.cadastroCategoria.titulo, 
          style: Theme.of(context).textTheme.title,
        ),
      ),
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
