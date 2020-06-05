import 'package:flutter/material.dart';



class CustomWebDialogConfirmation extends StatelessWidget {
  final String title, description, item, buttonOkText, buttonCancelText;

  final Function() funcaoBotaoCancelar;
  final Function() funcaoBotaoOk;    

  CustomWebDialogConfirmation({
    this.title = "Confirmação",
    @required this.description,
    @required this.buttonOkText,
    @required this.buttonCancelText,
    this.item,
    this.funcaoBotaoCancelar,
    this.funcaoBotaoOk    
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
      ),      
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: dialogContent(context),
    );
  }

  dialogContent(BuildContext context) {
  return Stack(
    children: <Widget>[
      Container(
        width: 350,
        padding: EdgeInsets.only(
          top: 55,
        ),
        margin: EdgeInsets.only(top: 66),
        decoration: new BoxDecoration(
          color: Colors.white,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Center(
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: Theme.of(context).textTheme.title,
                  children: <TextSpan> [
                    TextSpan(text: description,style: TextStyle(color: Colors.black,fontSize: 15)), 
                    TextSpan(text: item, style: TextStyle(color: Colors.red,fontSize: 15)),
                    TextSpan(text: " ?",style: TextStyle(color: Colors.black,fontSize: 15)),
                  ]
                ),
              ),
            ),
            SizedBox(height: 24.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                FlatButton(
                  onPressed: () {
                    funcaoBotaoCancelar();
                  },
                  child: Text(buttonCancelText,
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                FlatButton(
                  onPressed: () {
                    funcaoBotaoOk();
                  },
                  child: Text(buttonOkText,
                    style: TextStyle(color: Colors.red,fontSize: 16),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      Positioned(
        left: 16,
        right: 160,
        top: 50,
        child: Container(
          height: 34,
          decoration: BoxDecoration(
            color: Colors.red,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(8)
          ),
          child: Center(
            child: Text(title,
              style: TextStyle(color: Colors.white,fontSize: 16),
            ),
          ),
        ),
      ),
    ],
  );
}
}