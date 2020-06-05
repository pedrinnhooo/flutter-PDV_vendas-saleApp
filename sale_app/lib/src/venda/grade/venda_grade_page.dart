import 'package:common_files/common_files.dart';
import 'package:flutter/material.dart';
import 'package:fluggy/src/app_module.dart';
import 'package:fluggy/src/venda/variante/venda_variante_page.dart';

class VendaGradePage extends StatelessWidget {
  SharedVendaBloc vendaBloc = AppModule.to.getBloc<SharedVendaBloc>();
  Produto _produto;
  int _index;
  bool _ehTroca;

  VendaGradePage({Produto produto, int index, bool ehTroca=false}) {
    this._produto = produto;
    this._index = index;
    this._ehTroca = ehTroca;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                'assets/palavraFluggy.png',
                fit: BoxFit.contain,
                height: 40,
              )
            ],
          ),
        ),
        body: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(6.0),
                child: StreamBuilder(
                  stream: vendaBloc.gradeListOut,
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Center(child: CircularProgressIndicator());
                    }
                    List grade = snapshot.data;

                  return GridView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3),
                    itemCount: grade.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: InkWell(
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(6)),
                                border: Border.all(width: 0.2,),
                                color: Theme.of(context).accentColor
                            ),
                            child: Center(child: Text("${grade[index]}", style: Theme.of(context).textTheme.title,)),
                          ),
                          onTap: () {
                            if (_produto.produtoVariante.length > 0) {
                              Navigator.pop(context);
                              Navigator.push(context,
                                PageRouteBuilder(
                                  settings: RouteSettings(name: '/ProdutoVariante'),
                                  pageBuilder: (c, a1, a2) => VendaVariantePage(
                                      produto: _produto,
                                      index: index + 1,
                                      idGrade: _produto.idGrade,
                                      ehTroca: this._ehTroca),
                                  transitionsBuilder: (c, anim, a2, child) => FadeTransition(opacity: anim, child: child),
                                  transitionDuration: Duration(milliseconds: 180),
                                ),
                              );
                            } else {
                              if (!_ehTroca) {
                                vendaBloc.addMovimentoItem(_produto.id, index + 1, null, _produto.precoCusto);
                              } else {
                                vendaBloc.addMovimentoItemTroca(_produto.id, index + 1, null);
                              }
                              Navigator.pop(context);
                            }
                          },
                        ),
                      );
                    }
                  );
                }
              ),
            ),
          ]
        ),
      )
    );
  }
}
