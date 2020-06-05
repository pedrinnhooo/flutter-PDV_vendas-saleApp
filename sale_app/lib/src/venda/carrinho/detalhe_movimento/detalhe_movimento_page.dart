import 'package:fluggy/generated/locale_base.dart';
import 'package:fluggy/src/app_module.dart';
import 'package:flutter/material.dart';
import 'package:common_files/common_files.dart';

class DetalheMovimentoPage extends StatefulWidget {
  @override
  _DetalheMovimentoPageState createState() => _DetalheMovimentoPageState();
}

class _DetalheMovimentoPageState extends State<DetalheMovimentoPage> {
  SharedVendaBloc _vendaBloc;
  ScrollController _scrollController;
  TextEditingController garantiaController, observacaoController, observacaoInternaController;

  @override
  void initState() {
    _vendaBloc = AppModule.to.getBloc<SharedVendaBloc>();
    observacaoController = TextEditingController();
    observacaoController.value = observacaoController.value.copyWith(text: _vendaBloc.movimento.observacao == null ? "" : _vendaBloc.movimento.observacao);
    super.initState();
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
                                      Text("Adicione uma observação a sua venda"),
                                      SizedBox(height: 20),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 12,right: 12),
                                        child: customBorderTextField(
                                          context,
                                          hintText: "Observação",
                                          controller: observacaoController,
                                          onChanged: (text) {}
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
                          _vendaBloc.setObservacaoMovimento(observacaoController.text);
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