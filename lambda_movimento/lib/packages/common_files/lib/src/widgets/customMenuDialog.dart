import 'package:flutter/material.dart';

Widget customMenuDialog({
  BuildContext context,
  double offSetdx, double offSetdy,
  Function onTap,
  double sizedBoxHeight = 80,
  double sizedBoxWidth = 100,
  Widget image,
  String nome
}){
  return Container(
    child:  Transform.translate(
      offset: Offset(offSetdx, offSetdy),
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: InkWell(
          onTap: onTap,
          child: Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
                color: Theme.of(context).accentColor,
                borderRadius: BorderRadius.circular(12)),
            child: SizedBox(
              height: sizedBoxHeight,
              width: sizedBoxWidth,
              child: Column(
                mainAxisAlignment:
                    MainAxisAlignment.center,
                children: <Widget>[
                  image,
                  Text(
                    nome,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white),
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