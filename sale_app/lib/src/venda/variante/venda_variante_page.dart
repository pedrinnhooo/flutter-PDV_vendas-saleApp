import 'package:common_files/common_files.dart';
import 'package:fluggy/src/venda/venda_module.dart';
import 'package:flutter/material.dart';
import 'package:fluggy/src/app_module.dart';
import 'package:flutter_colorpicker/utils.dart';

class VendaVariantePage extends StatelessWidget {
  SharedVendaBloc vendaBloc = AppModule.to.getBloc<SharedVendaBloc>();
  Produto _produto;
  int _index;
  int _idGrade;
  bool _ehTroca;
  BuildContext myContext;

  VendaVariantePage({Produto produto, int index, int idGrade, bool ehTroca=false}) {
    this._produto = produto;
    this._index = index;
    this._idGrade = idGrade != null ? idGrade : 0;
    this._ehTroca = ehTroca;
  }

  @override
  Widget build(BuildContext context) {
    return ShowCaseWidget(
      builder: Builder(
        builder: (context) {
          myContext = context;
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
                leading: Text("")),
            body: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).accentColor
              ),
              child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                GridView.builder(
                  padding: EdgeInsets.all(10),
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3),
                  itemCount: _produto.produtoVariante.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: InkWell(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(6)),
                            border: Border.all(width: 0.2),
                            color: Color(int.tryParse(_produto.produtoVariante[index].variante.iconecor))),
                          child: Center(
                            child: Text("${_produto.produtoVariante[index].variante.nome}",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: useWhiteForeground(Color(int.parse(_produto.produtoVariante[index].variante.iconecor)))
                                                                  ? const Color(0xffffffff)
                                                                  : const Color(0xff000000)
                                )
                              ),
                          ),
                        ),  
                        onTap: () {
                          if (!_ehTroca) {
                            vendaBloc.addMovimentoItem(_produto.id, _index,
                              _produto.produtoVariante[index].idVariante, _produto.precoCusto);
                          } else {
                            vendaBloc.addMovimentoItemTroca(_produto.id, _index,
                              _produto.produtoVariante[index].idVariante);
                          }    
                          Navigator.pop(context);
                        },
                      ),
                    );
                  }
                ),
              ],
            ),
          )
         );
        }
      )
    );
  }
}
