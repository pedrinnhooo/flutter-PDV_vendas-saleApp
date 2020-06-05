import 'package:common_files/common_files.dart';
import 'package:fluggy/generated/locale_base.dart';
import 'package:fluggy/src/pages/configuracao/terminal/terminal_module.dart';
import 'package:fluggy/src/pages/configuracao/terminal_impressora/detail/terminal_impressora_detail.dart';
import 'package:fluggy/src/pages/configuracao/terminal_impressora/terminalL_impressora_module.dart';
import 'package:flutter/material.dart';

class ImpressoraListPage extends StatefulWidget {
  ImpressoraListPage({Key key}) : super(key: key);

  @override
  _ImpressoraListPageState createState() => _ImpressoraListPageState();
}

class _ImpressoraListPageState extends State<ImpressoraListPage> {
  ImpressoraBloc impressoraBloc;
  TerminalBloc terminalBloc;

  @override
  void initState() { 
    super.initState();
    impressoraBloc = ImpressoraModule.to.getBloc<ImpressoraBloc>();
    try {
      terminalBloc = TerminalModule.to.getBloc<TerminalBloc>(); 
    } catch (e) {
      terminalBloc = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.of<LocaleBase>(context, LocaleBase);

     Future _initRequester() async {
      return impressoraBloc.getAllImpressora();
    }

    Future<List> _dataRequester() async {
      return Future.delayed(Duration(milliseconds: 100), () async {
        return await impressoraBloc.getAllImpressora();
      });
    }

    Function _itemBuilder = (List dataList, BuildContext context, int index) {
      return ListTile(
        title: Text("${dataList[index].nome}",
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
              await impressoraBloc.getImpressoraById(dataList[index].id);
              Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder: (c, a1, a2) => ImpressoraDetailPage(),
                  //settings: RouteSettings(name: '/DetalheTerminal'),
                  transitionsBuilder: (c, anim, a2, child) => FadeTransition(opacity: anim, child: child),
                  transitionDuration:Duration(milliseconds: 180),
                ),
              );
            },
          ),
        ),
        onTap: () {
          if(terminalBloc != null){
            terminalBloc.setImpressora(dataList[index]);
            Navigator.pop(context);
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
                    impressoraBloc.filtroNome = text;
                    impressoraBloc.offset = 0;
                    impressoraBloc.getAllImpressora();
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
                          await impressoraBloc.newImpressora();
                          Navigator.push(
                            context,
                            PageRouteBuilder(
                              pageBuilder: (c, a1, a2) => ImpressoraDetailPage(),
                              //settings: RouteSettings(name: '/DetalheTerminal'),
                              transitionsBuilder: (c, anim, a2, child) => FadeTransition( opacity: anim, child: child),
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
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[ 
              Expanded(
                child: DynamicListView.build(
                  bloc: impressoraBloc,
                  stream: impressoraBloc.impressoraListOut,
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
                      Text("Nenhuma impressora cadastrada.\nDeseja adicionar uma impressora agora ?",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w300
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 18.0),
                        child: FlatButton(
                          color: Colors.white,
                          child: Text("Adicionar", style: TextStyle(
                            color: Theme.of(context).accentColor,
                            fontSize: 16,
                          ),),
                          onPressed: () async {
                            await impressoraBloc.newImpressora();
                            // Navigator.push(
                            //   context,
                            //   PageRouteBuilder(
                            //     pageBuilder: (c, a1, a2) => ImpressoraAddPage(),
                            //     settings: RouteSettings(name: '/DetalheTerminal'),
                            //     transitionsBuilder: (c, anim, a2, child) => FadeTransition( opacity: anim, child: child),
                            //     transitionDuration: Duration(milliseconds: 180),
                            //   ),
                            // );
                          },
                        ),
                      )
                    ],
                  )
                ),
              )
            ]
          )
        )
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text("Impressoras"),
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