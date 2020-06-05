import 'package:common_files/common_files.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:fluggy/src/app_module.dart';

class QuantidadeItemPage extends StatefulWidget {
  int index;
  QuantidadeItemPage({index}) {
    this.index = index;
  }

  @override
  _QuantidadeItemPageState createState() =>
      _QuantidadeItemPageState(index: this.index);
}

class _QuantidadeItemPageState extends State<QuantidadeItemPage> {
  int _index;
  _QuantidadeItemPageState({index}) {
    this._index = index;
  }
  SharedVendaBloc vendaBloc = AppModule.to.getBloc<SharedVendaBloc>();
  MoneyMaskedTextController valorBruto = MoneyMaskedTextController();
  String _valorDigitado = "0";
  String _txt = "";
  bool _firstDig = true;

  @override
  Widget build(BuildContext context) {
    valorBruto.updateValue(vendaBloc.movimento.valorTotalBruto);

    double getOnlyValue(String value) {
      String _temp;
      double _value;
      _temp = value.replaceAll(".", "");
      _temp = _temp.replaceAll(",", ".");
      _value = double.parse(_temp);
      return _value;
    }

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
        body:  Container(
          color: Theme.of(context).primaryColor,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                height: 220,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Theme.of(context).accentColor,
                    ),
                    child: Column(
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.only(top: 15),
                          child: Center(child: Text("${vendaBloc.movimento.movimentoItem[this._index].produto.nome} ", style: Theme.of(context).primaryTextTheme.subhead,)),
                        ),

                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text(" $_valorDigitado", style: Theme.of(context).accentTextTheme.display1,),
                                ],
                              ),
                              Text("Quantidade atual: ${vendaBloc.movimento.movimentoItem[this._index].quantidade.round()}",
                                style: Theme.of(context).textTheme.body2,
                              ),
                            ],
                          ),
                        ),
                      ]
                    )
                  ),
                )
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.center,
                  child: GridView.count(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    crossAxisCount: 3,
                    childAspectRatio: 1.2,
                    padding: const EdgeInsets.all(10.0),
                    mainAxisSpacing: 4.0,
                    crossAxisSpacing: 4.0,
                    children: <String>[
                      // @formatter:off
                      '7', '8', '9',
                      '4', '5', '6',
                      '1', '2', '3',
                      'DEL', '0', 'OK',
                      // @formatter:on
                    ].map((key) {
                      return Padding(
                        padding: const EdgeInsets.all(2),
                        child: GridTile(
                          child: FlatButton(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)
                            ),
                          splashColor: Theme.of(context).primaryColor,
                          child: Text(
                            key,
                            style: TextStyle(
                              fontSize: 26.0,
                              color: Colors.white,
                            ),
                          ),
                          color: key == "DEL" ? 
                            Colors.red : key == "OK" ? Colors.green[400]:
                            Theme.of(context).accentColor,
                          onPressed: () {
                            if (key == "OK") {
                              if (_valorDigitado != "0,00") {
                                vendaBloc.setQuantidadeMovimentoItem(_index, double.parse(_valorDigitado.replaceAll(",", ".")));
                                Navigator.pop(context);
                              }
                            } else if (key == "DEL") {
                              setState(() {
                                if ((_txt == "") || (_txt.length == 1)) {
                                  _firstDig = true;
                                  _txt = "0";
                                } else {
                                  _txt = _txt.substring(0, _txt.length - 1);
                                }
                                _valorDigitado = getOnlyValue(_txt).round().toString();
                              });
                            } else {
                              setState(() {
                                _txt = _firstDig ? key : _txt + key;
                                _firstDig = false;
                                _valorDigitado = getOnlyValue(_txt).round().toString();

                              });
                            }
                          },
                        )),
                      );
                    }).toList(),
                  ),
                )),
            ],
          ),
        )
      );
  }
}