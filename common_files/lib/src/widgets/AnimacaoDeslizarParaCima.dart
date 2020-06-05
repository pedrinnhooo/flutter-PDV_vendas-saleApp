import 'dart:async';
import 'package:flutter/material.dart';

class DeslizarParaCima extends StatefulWidget {
  final Widget child;
  final int delay;

  DeslizarParaCima({@required this.child, this.delay});

  @override
  DeslizarParaCimaState createState() => DeslizarParaCimaState();
}

class DeslizarParaCimaState extends State<DeslizarParaCima>
    with TickerProviderStateMixin {
  AnimationController animController;
  Animation<Offset> _animOffset;

  @override
  void initState() {
    super.initState();
    animController = AnimationController(vsync: this, duration: Duration(milliseconds: 180));
    final curve = CurvedAnimation(curve: Curves.decelerate, parent: animController);
    _animOffset = Tween<Offset>(begin: const Offset(0.0, 0.10), end: Offset.zero).animate(curve);

    if (widget.delay == null) {
        animController.forward();
    } else {
      Timer(Duration(milliseconds: widget.delay), () {
        animController.forward();
      });
    }
  }

  // @override
  // void dispose() {
  //   animController.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      child: SlideTransition(
        position: _animOffset,
        child: widget.child,
      ),
      opacity: animController,
    );
  }
}
