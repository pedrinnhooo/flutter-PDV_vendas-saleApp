import 'package:common_files/common_files.dart';
import 'package:fluggy/generated/locale_base.dart';
import 'package:flutter/material.dart';
import 'package:fluggy/src/pages/cadastro/preco_tabela/detail/preco_tabela_detail_page.dart';
import 'package:fluggy/src/pages/cadastro/preco_tabela/preco_tabela_module.dart';
import 'package:fluggy/src/pages/configuracao/transacao/transacao_module.dart';

class PrecoTabelaListPage extends StatefulWidget {
  @override
  _PrecoTabelaListPageState createState() => _PrecoTabelaListPageState();
}

class _PrecoTabelaListPageState extends State<PrecoTabelaListPage> {
  PrecoTabelaBloc precoTabelaBloc;
  TransacaoBloc transacaoBloc;
  
  @override
  void initState() {
    precoTabelaBloc = PrecoTabelaModule.to.getBloc<PrecoTabelaBloc>();
    try {
      transacaoBloc = TransacaoModule.to.getBloc<TransacaoBloc>();
    } catch (e) {
      transacaoBloc = null;
    }
    init();
    super.initState();
  }

  void init() async {
    await precoTabelaBloc.getAllPrecoTabela();
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
                    precoTabelaBloc.filtroNome = text;
                    precoTabelaBloc.getAllPrecoTabela();
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
                          await precoTabelaBloc.newPrecoTabela();
                          Navigator.push(
                            context,
                            PageRouteBuilder(
                              pageBuilder: (c, a1, a2) => PrecoTabelaDetailPage(),
                              settings: RouteSettings(name: '/DetalhePrecoTabela'),
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
                child: SingleChildScrollView(
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            StreamBuilder(
                              initialData: List<PrecoTabela>(),
                              stream: precoTabelaBloc.precoTabelaListOut,
                              builder: (context, snapshot) {
                                List<PrecoTabela> precoTabelaList = snapshot.data;

                                if (precoTabelaList.length == 0 || precoTabelaList.length == null) {
                                  return Center(child: CircularProgressIndicator());
                                }

                                return ListView.separated(
                                  physics: ClampingScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: precoTabelaList.length,
                                  separatorBuilder: (context, index) {
                                    return Divider(
                                      color: Theme.of(context).primaryColor,
                                      height: 6,
                                    );
                                  },                  
                                  itemBuilder: (context, index) {
                                    return ListTile(
                                      title: Text("${precoTabelaList[index].nome}",
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
                                            await precoTabelaBloc.getPrecoTabelaById(precoTabelaList[index].id);
                                            Navigator.push(
                                              context,
                                              PageRouteBuilder(
                                                pageBuilder: (c, a1, a2) => PrecoTabelaDetailPage(),
                                                settings: RouteSettings(name: '/DetalhePrecoTabela'),
                                                transitionsBuilder: (c, anim, a2, child) => FadeTransition(opacity: anim, child: child),
                                                transitionDuration: Duration(milliseconds: 180),
                                              ),
                                            );
                                          },
                                        ),
                                      )
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
      appBar: AppBar(
        title: Text(locale.cadastroPrecoTabela.titulo, 
          style: Theme.of(context).textTheme.title,)
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
