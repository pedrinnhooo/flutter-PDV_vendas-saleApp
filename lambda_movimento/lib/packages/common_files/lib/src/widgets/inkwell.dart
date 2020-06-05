import 'package:flutter/material.dart';

class InkWelIcon extends StatelessWidget {
  Image image;
  Color color;
  var onTap;

  InkWelIcon({color, image, onTap}) {
    this.color = color;
    this.image = image;
    this.onTap = onTap;
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
          padding: EdgeInsets.all(8.0),
          decoration: BoxDecoration(shape: BoxShape.circle, color: color),
          child: image),
    );
  }
}
