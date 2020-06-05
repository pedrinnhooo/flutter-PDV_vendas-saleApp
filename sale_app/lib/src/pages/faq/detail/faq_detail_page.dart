import 'package:common_files/common_files.dart';
import 'package:dynamic_widget/dynamic_widget.dart';
import 'package:fluggy/generated/locale_base.dart';
import 'package:flutter/material.dart';
import 'package:fluggy/src/pages/faq/faq_module.dart';
import 'package:intercom_flutter/intercom_flutter.dart';

class FaqCategoriaListPage extends StatefulWidget {
  @override
  _FaqCategoriaListPageState createState() => _FaqCategoriaListPageState();
}

class _FaqCategoriaListPageState extends State<FaqCategoriaListPage> {
  FaqCategoriaBloc faqCategoriaBloc;
  
  
  @override
  void initState() {
    faqCategoriaBloc = FaqCategoriaModule.to.getBloc<FaqCategoriaBloc>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {  
    final locale = Localizations.of<LocaleBase>(context, LocaleBase);

    Future _initRequester() async {
      return faqCategoriaBloc.getAllFaqCategoria();
    }

    Future<List> _dataRequester() async {
      return Future.delayed(Duration(milliseconds: 100), () async {
        return await faqCategoriaBloc.getAllFaqCategoria();
      });
    }

    Function _itemBuilder = (List dataList, BuildContext context, int index) {
      List<Widget> widgetsList = [];
      List<FaqQuestionario> faqQuestionario =  dataList[index].faqQuestionario;
      faqQuestionario.forEach((f){
        widgetsList.add(
        ExpansionCustomTile(
          title: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: <Widget>[
                Text("--", style: TextStyle(color: Theme.of(context).primaryIconTheme.color)),
                SizedBox(width: 10),
                Text("${f.pergunta}",
                  style: Theme.of(context).primaryTextTheme.subtitle),
              ],
            ),
          ),
          children: <Widget> [
            Padding( 
              padding: const EdgeInsets.all(10),
              child: Container(
                padding: EdgeInsets.only(bottom: 5, top: 15, left: 15, right:15),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    width: 1,
                    color: Theme.of(context).primaryIconTheme.color
                  ),
                ),
                child: Text("${f.resposta}", 
                  style: Theme.of(context).primaryTextTheme.body2, 
                  textAlign: TextAlign.justify, 
                ),
              ),
            )             
          ]
        )
      );
    });

     return ExpansionCustomTile(    
      title: Text("${dataList[index].nome}",
        style: Theme.of(context).textTheme.subhead,
      ),
      children:  widgetsList
     );
    };

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
              Stack(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 10, right: 10,bottom: 20, top: 40),
                    child: Container(
                      width: double.infinity,
                      height: 140,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Theme.of(context).primaryColor.withOpacity(0.70),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(top: 50),
                        child: Align(
                          alignment: Alignment.center,
                          child: Text("Olá, como podemos ajudar?", style: Theme.of(context).textTheme.subhead)
                        ),
                      )
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 15),
                    child: Align(
                      alignment: Alignment.center,
                      child: Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Colors.white
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: Image.asset("assets/logomarcafluggy.png", width: 40, color: Theme.of(context).primaryIconTheme.color),
                        )
                      ),
                    ),
                  ),  
                ],
              ),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      child: DynamicListView.build(
                        bloc: faqCategoriaBloc,
                        stream: faqCategoriaBloc.faqCategoriaListOut,
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
              ),
              customButtomGravar(
                buttonColor	: Theme.of(context).primaryIconTheme.color,
                text: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: Icon(Icons.question_answer, color: Colors.white),
                    ),
                    Text("Assistente Virtual",
                      style: Theme.of(context).textTheme.subhead,
                    ),
                  ],
                ),
                onPressed: () => Intercom.displayMessenger()
              )
            ]
          )
        )
      )
    );
    
    return Scaffold(
      appBar: AppBar(
        title: Text("Ajuda"),
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

class DefaultClickListener implements ClickListener {
  @override
  void onClicked(String event) {
    print("Receive click event: " + event);
  }
}
