import 'package:common_files/common_files.dart';
import 'package:fluggy/src/app_module.dart';
import 'package:fluggy/src/venda/venda_module.dart';
import 'package:flutter/material.dart';

class ReciboPage extends StatelessWidget {
  Icon icon;
  String message;
  String mensagemBotao;
  double value;
  BuildContext myContext;
  SharedVendaBloc vendaBloc = AppModule.to.getBloc<SharedVendaBloc>();

  ReciboPage({icon, message, value = 0.0, mensagemBotao = "Fechar"}) {
    this.icon = icon;
    this.message = message;
    this.value = value;
    this.mensagemBotao = mensagemBotao;
  }

  @override
  Widget build(BuildContext context) {
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
              height: 40,
            )
          ],
        ),
        leading: Text(""),
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[icon],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      message,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 25
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        Text(
                          value == 0.0 ? "" : "R\$ ",
                          style: Theme.of(context).accentTextTheme.display2,
                        ),
                      ],
                    ),
                    Column(
                      children: <Widget>[
                        Text(
                          value == 0.0 ? "" : value.toStringAsFixed(2),
                          style: Theme.of(context).accentTextTheme.display3,
                        )
                      ],
                    )
                  ],
                ),
              ],
            ),
            Align(alignment: Alignment.bottomCenter, child: Text(""))
          ],
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor
        ),
        padding: EdgeInsets.only(bottom: 10, right: 20, left: 20, top: 5),
        child: ButtonTheme(
          height: 50.0,
          child: RaisedButton(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: Text(mensagemBotao,
              style: Theme.of(context).textTheme.title,
            ),
            color: Theme.of(context).accentColor,
            onPressed: () async {
              if(vendaBloc.tutorial != null){
                await vendaBloc.setTutorialPasso(vendaBloc.tutorial.passo == 6 ? 7 : 19); 
              }
              Navigator.pop(context);
            }
          ),
        ),
      ),
    );
  }
}
