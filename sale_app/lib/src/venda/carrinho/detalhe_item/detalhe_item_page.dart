import 'package:fluggy/generated/locale_base.dart';
import 'package:fluggy/src/app_module.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:common_files/common_files.dart';

class DetalheItemPage extends StatefulWidget {
  int index;
  DetalheItemPage({index}) {
    this.index = index;
  }
  @override
  _DetalheItemPageState createState() => _DetalheItemPageState();
}

class _DetalheItemPageState extends State<DetalheItemPage> {
  SharedVendaBloc sharedVendaBloc;
  ScrollController _scrollController;
  TextEditingController garantiaController, observacaoController, observacaoInternaController;

  @override
  void initState() {
    sharedVendaBloc = AppModule.to.getBloc<SharedVendaBloc>();
    observacaoController = TextEditingController(); 
    observacaoInternaController = TextEditingController(); 
    garantiaController = TextEditingController(); 
    observacaoController.value = observacaoController.value.copyWith(
      text: sharedVendaBloc.movimento.movimentoItem[widget.index].observacao == null ? "" : sharedVendaBloc.movimento.movimentoItem[widget.index].observacao);
    garantiaController.value = garantiaController.value.copyWith(
      text: sharedVendaBloc.movimento.movimentoItem[widget.index].garantia == null ? "" : sharedVendaBloc.movimento.movimentoItem[widget.index].garantia);
    garantiaController.value = observacaoInternaController.value.copyWith(
      text: sharedVendaBloc.movimento.movimentoItem[widget.index].observacaoInterna == null ? "" : sharedVendaBloc.movimento.movimentoItem[widget.index].observacaoInterna);
    super.initState();
  }

  Future<DateTime> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(Duration(seconds: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
      builder: (BuildContext context, Widget child) {
        return Theme(
          data: ThemeData.dark(),
          child: child,
        );
      },
    );
    if (picked != null){
      sharedVendaBloc.setDatePedido(widget.index, picked);
    }
  }

  
  @override
  Widget build(BuildContext context) {
    final locale = Localizations.of<LocaleBase>(context, LocaleBase);
    _scrollController = ScrollController();
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'assets/palavraFluggy.png',
              fit: BoxFit.contain,
              height: 35,
            )
          ],
        ),
      ),      
      body: Container(
        color: Theme.of(context).primaryColor,
        child: Column(
          children: <Widget>[
            Expanded(
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
                          controller: _scrollController,
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 10, right: 10),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      SizedBox(height: 20),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 12,right: 12),
                                        child: customBorderTextField(
                                          context,
                                          hintText: "Observação",
                                          controller: observacaoController,
                                          onChanged: (text) {
                                          }
                                        ),
                                      ),
                                      SizedBox(height: 40),
                                      InkWell(
                                        onTap: () {
                                        _selectDate(context);
                                        }, 
                                        child: Visibility(
                                          visible: sharedVendaBloc.movimento.movimentoItem[widget.index].produto.ehservico == 1 ? true : false,
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: <Widget>[
                                              Container(
                                                alignment: Alignment.topLeft,
                                                child: Padding(
                                                  padding: const EdgeInsets.only(left: 12, right: 12),
                                                  child: Text("Prazo de entrega",
                                                  style: Theme.of(context).textTheme.display3,
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(left: 12,right: 12),
                                                child: Container(
                                                  alignment: Alignment.topLeft,
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: <Widget>[
                                                      StreamBuilder<Movimento>(
                                                          stream: sharedVendaBloc.movimentoOut,
                                                          builder: (context, snapshot) {
                                                            if(!snapshot.hasData || snapshot.data.movimentoItem.length == 0){
                                                              return CircularProgressIndicator();
                                                            }
                                                            Movimento movimento = snapshot.data;
                                                            return Text(movimento.movimentoItem[widget.index].prazoEntrega != null 
                                                              ? DateFormat('dd/MM/yyyy')
                                                              .format(DateTime.parse("${movimento.movimentoItem[widget.index].prazoEntrega}")) 
                                                              : locale.palavra.selecione, 
                                                            style: TextStyle(color: Colors.white, fontSize: 18));
                                                          }
                                                        ),
                                                        Icon(
                                                            Icons.calendar_today,
                                                            color: Theme.of(context).cursorColor,
                                                          )
                                                      ],
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(top: 2,right: 12,left: 12),
                                                child: Divider(color: Colors.white,),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Visibility(
                                        visible: sharedVendaBloc.movimento.movimentoItem[widget.index].produto.ehservico == 1 ? true : false,
                                        child: Padding(
                                          padding: const EdgeInsets.only(left: 12,right: 12),
                                          child: customTextField(
                                            context,
                                            labelText: "Garantia",
                                            controller: garantiaController,
                                            onChanged: (text) {
                                              sharedVendaBloc.setGarantiaPedido(widget.index, text);
                                            } 
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 50),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 12,right: 12),
                                        child: Visibility(
                                          visible: sharedVendaBloc.movimento.movimentoItem[widget.index].produto.ehservico == 1 ? true : false,
                                          child: customBorderTextField(
                                            context,
                                            hintText: "Observação interna",
                                            controller: observacaoInternaController,
                                            onChanged: (text) {
                                              sharedVendaBloc.setObservacaoInternaPedido(widget.index, text);
                                            } 
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      customButtomGravar(
                        buttonColor: Theme.of(context).primaryIconTheme.color,
                        text: Text(locale.palavra.gravar,
                          style: Theme.of(context).textTheme.title,
                        ),
                        onPressed: () {
                          sharedVendaBloc.setObservacaoPedido(widget.index, observacaoController.text);
                          Navigator.pop(context);
                        } 
                      )
                    ]  
                  )
                )    
              ),
            )
          ],
        ),
      ),
    );
  }
}