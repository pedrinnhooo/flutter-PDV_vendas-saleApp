import 'package:flutter/material.dart';
import '../widgets/dialog.dart' as customDialog;

Future confirmaOperacao({
  BuildContext context,
  String titulo,
  String mensagem, 
  String textoBotaoCancelar = "Cancelar",
  String textoBotaoConfirmar = "Confirmar",
  
  Function funcaoBotaoCancelar,
  Function funcaoBotaoOk
}){
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return  customDialog.AlertCustomDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0))
        ),
        backgroundColor: Theme.of(context).accentColor,
        title: Text("Confirmação",
          style: Theme.of(context).textTheme.title),
        content: Text(mensagem,
          style: Theme.of(context).accentTextTheme.display1),
        actions: <Widget>[
          FlatButton(
            child: Text(textoBotaoCancelar, 
              style: Theme.of(context).textTheme.display1),
            onPressed: funcaoBotaoCancelar,
          ),
          FlatButton(
            child: Text(textoBotaoConfirmar, 
              style: Theme.of(context).textTheme.display1),
            onPressed: funcaoBotaoOk,
          )
        ],
      );
    }
  );
}
