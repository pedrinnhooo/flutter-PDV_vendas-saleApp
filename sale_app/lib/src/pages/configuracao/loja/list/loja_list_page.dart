import 'package:common_files/common_files.dart';
import 'package:fluggy/generated/locale_base.dart';
import 'package:fluggy/src/pages/widgets/Drawer/drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:fluggy/src/pages/configuracao/loja/detail/loja_detail_page.dart';
import 'package:fluggy/src/pages/configuracao/loja/loja_module.dart';

class LojaListPage extends StatefulWidget {
  @override
  _LojaListPageState createState() => _LojaListPageState();
}

class _LojaListPageState extends State<LojaListPage> {
  LojaBloc lojaBloc;
  GlobalKey<ScaffoldState> _scaffoldKey;
  
  @override
  void initState() {
    lojaBloc = LojaModule.to.getBloc<LojaBloc>();
    _scaffoldKey  = GlobalKey<ScaffoldState>();
    init();
    super.initState();
  }

  void init() async {
    await lojaBloc.getAllPessoa();
  }  
  
  @override
  Widget build(BuildContext context) {
  
    final locale = Localizations.of<LocaleBase>(context, LocaleBase);

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
                    lojaBloc.filtroNome = text;
                  lojaBloc.getAllPessoa();
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
                          await lojaBloc.newPessoa();
                          Navigator.push(
                            context,
                            PageRouteBuilder(
                              pageBuilder: (c, a1, a2) => LojaDetailPage(),
                              settings: RouteSettings(name: '/DetalheLoja'),
                              transitionsBuilder: (c, anim, a2, child) =>
                                  FadeTransition(
                                      opacity: anim, child: child),
                              transitionDuration:
                                  Duration(milliseconds: 180),
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
                child: SingleChildScrollView(
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            StreamBuilder(
                              initialData: List<Pessoa>(),
                              stream: lojaBloc.pessoaListOut,
                              builder: (context, snapshot) {
                                List<Pessoa> pessoaList = snapshot.data;

                                if (pessoaList.length == 0 ||
                                    pessoaList.length == null) {
                                  return Center(child: CircularProgressIndicator());
                                }

                                return ListView.separated(
                                  physics: ClampingScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: pessoaList.length,
                                  separatorBuilder: (context, index) {
                                    return Divider(
                                      color: Theme.of(context).primaryColor,
                                      height: 6,
                                    );
                                  },                  
                                  itemBuilder: (context, index) {
                                    return Slidable(
                                      actionPane: SlidableDrawerActionPane(),
                                      actionExtentRatio: 0.25,
                                      child: ListTile(
                                        title: Text("${pessoaList[index].razaoNome}",
                                            style: Theme.of(context).textTheme.title,
                                          ),
                                        trailing: Container(
                                          height: 30,
                                          width: 30,
                                          child: InkWell(
                                            child: Icon(
                                              Icons.edit, 
                                              color: Theme.of(context).primaryIconTheme.color),
                                            onTap: () async {
                                              await lojaBloc.getPessoaById(pessoaList[index].id);
                                              Navigator.push(context,
                                                PageRouteBuilder(
                                                  pageBuilder: (c, a1, a2) => LojaDetailPage(),
                                                  settings: RouteSettings(name: '/DetalheLoja'),
                                                  transitionsBuilder: (c, anim, a2, child) =>
                                                      FadeTransition(
                                                          opacity: anim, child: child),
                                                  transitionDuration:
                                                      Duration(milliseconds: 180),
                                                ),
                                              );
                                            },
                                          ),
                                        )
                                      ),  
                                      secondaryActions: <Widget>[
                                        IconSlideAction(
                                          caption: locale.palavra.excluir,
                                          color: Colors.red,
                                          icon: Icons.close,
                                          onTap: () async {
                                            lojaBloc.deletePessoa();
                                          }
                                        )
                                      ],
                                    );
                                  },
                                );
                              }
                            ), 
                          ],
                        ),
                      )
                    ],    
                  ),
                ),
              )
            ],
          ),
        )
      ),
    );  

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(locale.cadastroLoja.titulo, 
          style: Theme.of(context).textTheme.title,
        ),
        leading:  StreamBuilder(
          stream: lojaBloc.appGlobalBloc.configuracaoGeralOut,
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
