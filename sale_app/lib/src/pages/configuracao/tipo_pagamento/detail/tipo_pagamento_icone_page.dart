import 'package:cached_network_image/cached_network_image.dart';
import 'package:common_files/common_files.dart';
import 'package:fluggy/generated/locale_base.dart';
import 'package:flutter/material.dart';
import 'package:fluggy/src/pages/configuracao/tipo_pagamento/tipo_pagamento_module.dart';

class TipoPagamentoIconePage extends StatefulWidget {
  TipoPagamentoIconePage({Key key}) : super(key: key);

  @override
  _TipoPagamentoIconePageState createState() => _TipoPagamentoIconePageState();
}

class _TipoPagamentoIconePageState extends State<TipoPagamentoIconePage> {
  TipoPagamentoBloc tipoPagamentoBloc;
  
  @override
  void initState() {
    tipoPagamentoBloc = TipoPagamentoModule.to.getBloc<TipoPagamentoBloc>();
    init();
    super.initState();
  }
  
  void init() async {
    await tipoPagamentoBloc.getIconsFromS3();
  }  

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.of<LocaleBase>(context, LocaleBase);

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
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Expanded(
                            child: StreamBuilder(
                              initialData: List<String>(),
                              stream: tipoPagamentoBloc.iconListOut,
                              builder: (context, snapshot) {
                                if(!snapshot.hasData){
                                  return CircularProgressIndicator();
                                }

                                List<String> iconeList = snapshot.data;
                                
                                return Padding(
                                  padding: const EdgeInsets.all(25.0),
                                  child: GridView.builder(
                                    physics: ClampingScrollPhysics(),
                                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
                                    itemCount: iconeList.length,
                                    scrollDirection: Axis.vertical,
                                    itemBuilder: (context, index){
                                      return Padding(
                                        padding: const EdgeInsets.all(13.0),
                                        child: StreamBuilder<int>(
                                          stream: tipoPagamentoBloc.iconeSelecionadoOut,
                                          builder: (context, snapshot) {
                                            int selecionado = snapshot.data;
                                            return InkWell(
                                              onTap: () {
                                                tipoPagamentoBloc.tipoPagamento.icone = '${iconeList[index]}';
                                                tipoPagamentoBloc.setIconeSelecionado(index);
                                              },
                                              child: Container(
                                                padding: EdgeInsets.all(8),
                                                decoration: BoxDecoration(
                                                  border: Border.all(color: selecionado == index ? Colors.white : Colors.white.withOpacity(0.6)),
                                                  borderRadius: BorderRadius.circular(10)
                                                ),
                                                child: Stack(
                                                  children: <Widget>[ 
                                                    Container(
                                                      padding: EdgeInsets.all(15),
                                                      child: CachedNetworkImage(
                                                        placeholder: (context, url) => CircularProgressIndicator(),
                                                        errorWidget: (context, url, error) => Icon(Icons.error, color: Colors.white,),
                                                        imageUrl: '$s3Endpoint/${iconeList[index]}',
                                                        color: Colors.white,
                                                        width: double.maxFinite,
                                                        height: double.maxFinite,
                                                      ),
                                                    ),
                                                    Align(
                                                      alignment: Alignment.topRight,
                                                      child: Container(
                                                        decoration: BoxDecoration(shape: BoxShape.circle, color: 
                                                          selecionado == index ? Colors.white : Colors.white.withOpacity(0.8)),
                                                        child: Padding(
                                                          padding: const EdgeInsets.all(1.0),
                                                          child: selecionado == index
                                                        ? Icon(
                                                            Icons.check,
                                                            size: 30.0,
                                                            color: Theme.of(context).primaryIconTheme.color,
                                                          )
                                                        : Icon(
                                                            Icons.check_box_outline_blank,
                                                            size: 30.0,
                                                            color: selecionado == index ? Colors.transparent : Colors.transparent,
                                                          ),
                                                        ),
                                                      ),
                                                    )
                                                  ]
                                                )
                                              ),
                                            );
                                          }
                                        )
                                      );
                                    },
                                  ),
                                );
                              }
                            ),
                          ),
                        ],
                      ),
                    )
                  ],    
                ),
              )
            ],
          ),
        )
      ),
    );  

    return Scaffold(
      appBar: AppBar(
        title: Text(locale.cadastroTipoPagamento.titulo, 
style: Theme.of(context).textTheme.title,)
      ),      
      body: Container(
        color: Theme.of(context).primaryColor,
        child: Column(
          children: <Widget>[
            body
          ],
        ),
      ),
    );
  }
}
