import 'package:flutter/material.dart';

Widget customMenuDialog({
  BuildContext context,
  double offSetdx, double offSetdy,
  Function onTap,
  Function onLongPress,
  double sizedBoxHeight = 80,
  double sizedBoxWidth = 100,
  Widget image,
  String nome,
  Color backgroundColor
}){
  if(backgroundColor == null){
    backgroundColor = Theme.of(context).accentColor;
  }
  return Container(
    child:  Transform.translate(
      offset: Offset(offSetdx, offSetdy),
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: InkWell(
          onTap: onTap,
          onLongPress: onLongPress,
          child: Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(12)
            ),
            child: SizedBox(
              height: sizedBoxHeight,
              width: sizedBoxWidth,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  image,
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Text(
                      nome,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    )
  );
}