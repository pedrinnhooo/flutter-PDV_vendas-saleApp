import 'package:common_files/common_files.dart';
import 'package:fluggy/generated/locale_base.dart';
import 'package:fluggy/src/pages/configuracao/cupom_layout/cupom_layout_module.dart';
import 'package:fluggy/src/pages/configuracao/cupom_layout/detail/cupom_layout_detail.dart';
import 'package:fluggy/src/pages/configuracao/terminal/terminal_module.dart';
import 'package:flutter/material.dart';

class CupomLayoutList extends StatefulWidget {
  CupomLayoutList({Key key}) : super(key: key);

  @override
  _CupomLayoutListState createState() => _CupomLayoutListState();
}

class _CupomLayoutListState extends State<CupomLayoutList> {
  CupomLayoutBloc cupomLayoutBloc;
  ImpressoraBloc impressoraBloc;

  @override
  void initState() { 
    super.initState();
    cupomLayoutBloc = CupomLayoutModule.to.getBloc<CupomLayoutBloc>();
    try {
      impressoraBloc = TerminalModule.to.getBloc<ImpressoraBloc>();
    } catch (e) {
      impressoraBloc = null;
    }
  }

  Widget build(BuildContext context) {
    final locale = Localizations.of<LocaleBase>(context, LocaleBase);

    Future _initRequester() async {
      return cupomLayoutBloc.getAllCupomLayout();
    }

    Future<List> _dataRequester() async {
      return Future.delayed(Duration(milliseconds: 100), () async {
        return await cupomLayoutBloc.getAllCupomLayout();
      });
    }

    Function _itemBuilder = (List dataList, BuildContext context, int index) {
      return ListTile(
        title: Text("${dataList[index].nome}",
            style: Theme.of(context).textTheme.body2,
          ),
        trailing: Container(
          height: 30,
          width: 30,
          child: InkWell(
            child: Icon(
              Icons.edit, 
              color: Colors.white),
            onTap: () async {
              await cupomLayoutBloc.getCupomLayoutById(dataList[index].id);
              Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder: (c, a1, a2) => CupomLayoutDetail(),
                  transitionsBuilder: (c, anim, a2, child) => FadeTransition(opacity: anim, child: child),
                  transitionDuration:Duration(milliseconds: 180),
                ),
              );
            },
          ),
        ),
        onTap: () {
          if(impressoraBloc != null){
            impressoraBloc.setCupomImpressora(dataList[index]);
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
                    cupomLayoutBloc.filtroNome = text;
                    cupomLayoutBloc.offset = 0;
                    cupomLayoutBloc.getAllCupomLayout();
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
                          await cupomLayoutBloc.newCupomLayout();
                          Navigator.push(
                            context,
                            PageRouteBuilder(
                              pageBuilder: (c, a1, a2) => CupomLayoutDetail(),
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
            children: <Widget>[
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[ 
                    Expanded(
                      child: DynamicListView.build(
                        bloc: cupomLayoutBloc,
                        stream: cupomLayoutBloc.cupomLayoutListOut,
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
      appBar: AppBar(
        title: Text("Cupom", style: Theme.of(context).textTheme.title,),
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
