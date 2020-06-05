import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget customButtomGravar({EdgeInsetsGeometry containerPadding = const EdgeInsets.only(top: 10, left: 20, right: 20, bottom: 10), Color buttonColor = Colors.white, Widget text, Function onPressed}){
  return Container(
    padding: containerPadding,
    width: double.infinity,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Expanded(
          child: ButtonTheme(
            height: 40,
            child: RaisedButton(
              color: buttonColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8)
              ),
              child: text,
              onPressed: onPressed
            )
          ),
        ),
      ],
    ),
  );
}
