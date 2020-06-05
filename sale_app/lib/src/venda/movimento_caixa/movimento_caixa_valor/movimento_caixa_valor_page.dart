import 'package:common_files/common_files.dart';
import 'package:fluggy/src/app_module.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';

class MovimentoCaixaValorPage extends StatefulWidget {
  TipoMovimentoCaixa tipoMovimentoCaixa;
  
  MovimentoCaixaValorPage({this.tipoMovimentoCaixa});

  @override
  _MovimentoCaixaValorPageState createState() => _MovimentoCaixaValorPageState();
}

class _MovimentoCaixaValorPageState extends State<MovimentoCaixaValorPage> {
  MovimentoCaixaBloc _movimentoCaixaBloc;
  SharedVendaBloc _vendaBloc;
  MoneyMaskedTextController valorLiquido, valorRetiradaDisponivel;
  String _valorDigitado = "0,00";
  String _txt = "";
  bool _firstDig = true;

  @override
  void initState() {
    super.initState();
    valorLiquido = MoneyMaskedTextController();
    valorRetiradaDisponivel = MoneyMaskedTextController(leftSymbol: 'R\$ ');
    _movimentoCaixaBloc = AppModule.to.getBloc<MovimentoCaixaBloc>();
    _vendaBloc = AppModule.to.getBloc<SharedVendaBloc>();
    if(widget.tipoMovimentoCaixa == TipoMovimentoCaixa.retirada){
      _movimentoCaixaBloc.getValorDisponivelRetirada();
    }
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
        color: Theme.of(context).primaryColor,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Flexible(
              flex: 2,
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
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text("R\$ ", style: Theme.of(context).textTheme.subtitle,),
                                Text("$_valorDigitado", style: Theme.of(context).accentTextTheme.display1,),
                              ],
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  widget.tipoMovimentoCaixa == TipoMovimentoCaixa.abertura 
                                  ? "Abertura" 
                                    : widget.tipoMovimentoCaixa == TipoMovimentoCaixa.fechamento
                                    ? "Fechamento" 
                                      : widget.tipoMovimentoCaixa == TipoMovimentoCaixa.reforco
                                      ? "Reforço"
                                        : widget.tipoMovimentoCaixa == TipoMovimentoCaixa.sangria
                                        ? "Sangria" 
                                          : widget.tipoMovimentoCaixa == TipoMovimentoCaixa.retirada 
                                          ? "Retirada" : "", style: Theme.of(context).textTheme.body2
                                ),
                              ],
                            ),
                            Visibility(
                              visible: widget.tipoMovimentoCaixa == TipoMovimentoCaixa.retirada,
                              child: Column(
                                children: <Widget>[
                                  SizedBox(height: 20),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Text("Valor disponível", style: Theme.of(context).textTheme.subtitle),
                                    ],
                                  ),
                                  StreamBuilder(
                                    stream: _movimentoCaixaBloc.valorRetiradaDisponivelOut,
                                    builder: (context, snapshot){
                                      if(!snapshot.hasData){
                                        return Center(child: CircularProgressIndicator());
                                      }
                                      valorRetiradaDisponivel.updateValue(snapshot.data);
                                      return Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: <Widget>[
                                          Text(valorRetiradaDisponivel.text, style: Theme.of(context).textTheme.subtitle),
                                        ],
                                      );
                                    },
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ]
                  )
                ),
              )
            ),
            Flexible(
              flex: 3,
              child: Align(
                alignment: Alignment.bottomCenter,
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
                        onPressed: () async {
                          if (key == "OK") {
                            if (_valorDigitado != "0,00") {
                              _valorDigitado = _valorDigitado.replaceAll(".", "");
                              if (widget.tipoMovimentoCaixa == TipoMovimentoCaixa.abertura){
                                await _movimentoCaixaBloc.doAberturaCaixa(getOnlyValue(formatValue(_txt)));
                              } else if (widget.tipoMovimentoCaixa == TipoMovimentoCaixa.reforco) {
                                await _movimentoCaixaBloc.doReforcoMovimentoCaixa(getOnlyValue(formatValue(_txt)));
                                await _movimentoCaixaBloc.getMovimentoDia();
                              } else if(widget.tipoMovimentoCaixa == TipoMovimentoCaixa.sangria){
                                await _movimentoCaixaBloc.doSangriaMovimentoCaixa();
                                await _movimentoCaixaBloc.getMovimentoDia();
                              } else if(widget.tipoMovimentoCaixa == TipoMovimentoCaixa.retirada){
                                await _movimentoCaixaBloc.doRetiradaMovimentoCaixa(getOnlyValue(formatValue(_txt)));
                                await _movimentoCaixaBloc.getMovimentoDia();
                              }
                              await _vendaBloc.verificaCaixaAberto();
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
                                _valorDigitado = formatValue(_txt);
                              });
                            } else {
                              setState(() {
                                if(_txt.length <= 7){
                                  _txt = _firstDig ? key : _txt + key;
                                  _firstDig = false;
                                  _valorDigitado = formatValue(_txt);
                                }
                              }
                            );
                          }
                        },
                      )),
                    );
                  }).toList(),
                ),
              )
            ),
          ],
        ),
      )
    );
  }

  String formatValue(String value) {
    switch (value.length) {
      case 1:
        return "0,0" + value;
        break;
      case 2:
        return "0," + value;
        break;
      case 3:
        return value.substring(0, 1) + "," + value.substring(1, value.length);
        break;
      case 4:
        return value.substring(0, 2) + "," + value.substring(2, value.length);
        break;
      case 5:
        return value.substring(0, 3) + "," + value.substring(3, value.length);
        break;
      case 6:
        return value.substring(0, 1) +
            "." +
            value.substring(1, 4) +
            "," +
            value.substring(4, value.length);
        break;
      case 7:
        return value.substring(0, 2) +
            "." +
            value.substring(2, 5) +
            "," +
            value.substring(5, value.length);
        break;
      case 8:
        return value.substring(0, 3) +
            "." +
            value.substring(3, 6) +
            "," +
            value.substring(6, value.length);
        break;
      default:
    }
  }

  double getOnlyValue(String value) {
    String _temp;
    double _value;
    _temp = value.replaceAll(".", "");
    _temp = _temp.replaceAll(",", ".");
    _value = double.parse(_temp);
    return _value;
  }
}