import 'dart:async';
import 'package:flutter/material.dart';

class DeslizarParaCima extends StatefulWidget {
  final Widget child;
  final int delay;

  DeslizarParaCima({@required this.child, this.delay});

  @override
  _DeslizarParaCimaState createState() => _DeslizarParaCimaState();
}

class _DeslizarParaCimaState extends State<DeslizarParaCima>
    with TickerProviderStateMixin {
  AnimationController _animController;
  Animation<Offset> _animOffset;

  @override
  void initState() {
    super.initState();

    _animController = AnimationController(vsync: this, duration: Duration(milliseconds: 180));
    final curve = CurvedAnimation(curve: Curves.decelerate, parent: _animController);
    _animOffset = Tween<Offset>(begin: const Offset(0.0, 0.10), end: Offset.zero).animate(curve);

    if (widget.delay == null) {
      _animController.forward();
    } else {
      Timer(Duration(milliseconds: widget.delay), () {
        _animController.forward();
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    _animController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      child: SlideTransition(
        position: _animOffset,
        child: widget.child,
      ),
      opacity: _animController,
    );
  }
}
