import 'package:flutter/material.dart';
import 'package:fluggy/src/app_bloc.dart';
import 'package:fluggy/src/app_module.dart';
import 'package:fluggy/src/home/menu_page.dart';
import 'package:fluggy/src/venda/venda_module.dart';
import 'package:rect_getter/rect_getter.dart';
import 'package:fluggy/src/app_module.dart';
import 'package:fluggy/src/venda/venda_module.dart';

import '../app_bloc.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePage createState() => _HomePage();
}

class _HomePage extends State<HomePage> {
  AppBloc appBloc;
  final Duration animationDuration = Duration(milliseconds: 70);
  //70
  final Duration delay = Duration(milliseconds: 45);
  //45
  GlobalKey rectGetterKey = RectGetter.createGlobalKey();
  Rect rect;

  @override
  void initState() {
    super.initState();
    appBloc = AppModule.to.getBloc<AppBloc>();
  }

  void _onTap() async {
    setState(() => rect = RectGetter.getRectFromKey(rectGetterKey));
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() =>
          rect = rect.inflate(1.3 * MediaQuery.of(context).size.longestSide));
      Future.delayed(animationDuration + delay, _goToNextPage);
    });
  }

  void _goToNextPage() {
    Navigator.of(context)
        .push(FadeRouteBuilder(page: MenuPage()))
        .then((_) => setState(() => rect = null));
  }
  
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Scaffold(
          body: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text("a"),
                    FlatButton(
                      color: Theme.of(context).primaryColor,
                      child: Text(
                        "Português",
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () {
                        appBloc.setLocale(locale: Locale('pt'));
                        Navigator.push(context, MaterialPageRoute(builder: (_) => VendaModule(), settings: RouteSettings(name: '/Venda'),));
                      },
                    ),
                    FlatButton(
                      color: Theme.of(context).primaryColor,
                      child: Text(
                        "Inglês",
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () {
                        appBloc.setLocale(locale: Locale('en'));
                        Navigator.push(context, MaterialPageRoute(builder: (_) => VendaModule(), settings: RouteSettings(name: '/Venda'),));
                      },
                    ),
                    FlatButton(
                      color: Theme.of(context).primaryColor,
                      child: Text(
                        "Espanhol",
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () {
                         appBloc.setLocale(locale: Locale('es'));
                         Navigator.push(context, MaterialPageRoute(builder: (_) => VendaModule(), settings: RouteSettings(name: '/Venda'),));
                      },
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
        _ripple(),
      ],
    );
  }

  Widget _ripple() {
    if (rect == null) {
      return Container();
    }
    return AnimatedPositioned(
      duration: animationDuration,
      left: rect.left,
      right: MediaQuery.of(context).size.width - rect.right,
      top: rect.top,
      bottom: MediaQuery.of(context).size.height - rect.bottom,
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          //color: Colors.white24
          color: Theme.of(context).accentColor,
        ),
      ),
    );
  }
}

class FadeRouteBuilder<T> extends PageRouteBuilder<T> {
  final Widget page;

  FadeRouteBuilder({@required this.page})
      : super(
          pageBuilder: (context, animation1, animation2) => page,
          transitionsBuilder: (context, animation1, animation2, child) {
            return FadeTransition(opacity: animation1, child: child);
          },
        );
}
