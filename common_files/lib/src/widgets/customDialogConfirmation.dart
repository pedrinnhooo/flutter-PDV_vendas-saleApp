import 'package:flutter/material.dart';

class Consts {
  Consts._();

  static const double padding = 16.0;
  static const double avatarRadius = 66.0;
}

class CustomDialogConfirmation extends StatelessWidget {
  final String title, description, item, buttonOkText, buttonCancelText;

  final Function() funcaoBotaoCancelar;
  final Function() funcaoBotaoOk;    

  CustomDialogConfirmation({
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
          borderRadius: BorderRadius.circular(Consts.padding),
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
        padding: EdgeInsets.only(
          top: 55,
          //bottom: Consts.padding,
          //left: Consts.padding,
          //right: Consts.padding,
        ),
        margin: EdgeInsets.only(top: Consts.avatarRadius),
        decoration: new BoxDecoration(
          color: Theme.of(context).accentColor,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                style: Theme.of(context).textTheme.body1,
                children: <TextSpan> [
                  TextSpan(text: description), 
                  TextSpan(text: item, style: Theme.of(context).textTheme.body1),
                  //TextSpan(text: " ?"),
                ]
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
                    style: Theme.of(context).textTheme.button,
                  ),
                ),
                FlatButton(
                  onPressed: () {
                    funcaoBotaoOk();
                  },
                  child: Text(buttonOkText,
                    style: Theme.of(context).textTheme.button,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      Positioned(
        left: Consts.padding,
        right: 160,
        top: 50,
        child: Container(
          padding: EdgeInsets.only(top: 4, left: 10),
//          width: 10,
          height: 34,
          decoration: BoxDecoration(
            color: Theme.of(context).primaryIconTheme.color,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(10)
          ),
          child: Text(title,
            style: Theme.of(context).textTheme.title,
          ),
        ),
      ),
    ],
  );
}
}