import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/cupertino.dart';

class VendaBloc extends BlocBase {
  PageController pageController = PageController();
  PageController gridController = PageController(keepPage: true);

  //dispose will be called automatically by closing its streams
  @override
  void dispose() {
    pageController.dispose();
    gridController.dispose();
    super.dispose();
  }
}
