import 'dart:convert';

import 'package:common_files/common_files.dart';
import 'package:flutter/material.dart';
import 'package:fluggy/src/app_module.dart';

class PagamentoValorPage extends StatefulWidget {
  final TipoPagamento tipoPagamento;
  String valorRestante;
  PagamentoValorPage({Key key, this.tipoPagamento, this.valorRestante})
      : super(key: key) {
    this.valorRestante = this.valorRestante.toString().replaceAll(".", "");
  }

  _PagamentoValorPageState createState() => _PagamentoValorPageState(
      tipoPagamento: this.tipoPagamento, valorRestante: this.valorRestante);
}

class _PagamentoValorPageState extends State<PagamentoValorPage> {
  SharedVendaBloc vendaBloc = AppModule.to.getBloc<SharedVendaBloc>();
  TipoPagamento _tipoPagamento;
  String _valorRestante;
  String _valorDigitado;
  String _txt;
  bool _firstDig;
  BuildContext myContext;
  GlobalKey botaoValorUm = GlobalKey();
  GlobalKey botaoValorCinco = GlobalKey();
  GlobalKey botaoValorZero = GlobalKey();
  GlobalKey botaoValorOK = GlobalKey();

  _PagamentoValorPageState(
      {@required TipoPagamento tipoPagamento, String valorRestante}) {
    this._tipoPagamento = tipoPagamento;
    this._valorRestante = valorRestante;
    this._valorDigitado =
        formatValue(this._valorRestante.toString().replaceAll(",", ""));
    this._firstDig = true;
    this._txt = "";
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

  @override
  Widget build(BuildContext context) {

    if (vendaBloc.tutorial != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) =>
        ShowCaseWidget.of(myContext).startShowCase([botaoValorUm]));
    }

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
            ),
            body: Container(
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
                            Column(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Hero(
                                  tag: '${_tipoPagamento.id}',
                                  child: FutureBuilder<String>(
                                    future: readBase64Image("/images/tipoPagamento/${_tipoPagamento.idPessoaGrupo}/${_tipoPagamento.id}.txt"),
                                    builder: (context, snapshot){
                                      return AnimatedOpacity(
                                        duration: Duration(milliseconds: 200),
                                        opacity: snapshot.hasData ? 1.0 : 0.0,
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(8),
                                          child: snapshot.hasData ? Image.memory(base64Decode(snapshot.data),
                                            gaplessPlayback: true,
                                            fit: BoxFit.cover, 
                                            width: 60,
                                            height: 60,
                                          ) : SizedBox.shrink(),
                                        )
                                      );
                                    },
                                  )
                                ),
                              ),
                              Text("${_tipoPagamento.nome}", 
                                style: Theme.of(context).textTheme.title
                              )],
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
                                      Text("R\$", style: Theme.of(context).textTheme.body2,),
                                      Text(" $_valorDigitado", style: Theme.of(context).accentTextTheme.display1,),
                                    ],
                                  ),
                                  Text("Valor restante R\$ $_valorRestante",
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

                          if(vendaBloc.tutorial != null){
                            if (key == '1') {
                              return Padding(
                                padding: const EdgeInsets.all(2),
                                child: GridTile(
                                  child: Showcase.withWidget(
                                    key: botaoValorUm,
                                    disposeOnTap: false,
                                    disableAnimation: true,
                                    width: 200,
                                    height: 200,
                                    container: Column(
                                      children: <Widget>[
                                        SizedBox(height: 15),
                                        Row(
                                          children: <Widget>[
                                            Image.asset("assets/mascote.png", width: 60),
                                          ],
                                        ),
                                        SizedBox(height: 15),
                                        Row(
                                          children: <Widget>[
                                            Text("Clique para adicionar o valor 1", 
                                              style: TextStyle(color: Colors.white, fontSize: 16)),
                                          ],
                                        ),
                                        SizedBox(height: 15),
                                        Row(
                                          children: <Widget>[
                                            Image.asset("assets/setaBaixoEsquerda.png", width: 40),
                                          ],
                                        ),
                                      ],
                                    ),
                                    onTargetClick: () async {
                                      if(_valorDigitado.length < 10){
                                        _txt = _firstDig ? key : _txt + key;
                                        _firstDig = false;
                                        _valorDigitado = formatValue(_txt);
                                        await vendaBloc.setTutorialPasso(12);
                                        WidgetsBinding.instance.addPostFrameCallback((_) =>
                                          ShowCaseWidget.of(myContext).startShowCase([botaoValorCinco]));
                                      }
                                    },
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
                                      onPressed: ()  {},
                                    ),
                                  )
                                ),
                              );
                            } 

                            if (key == '5') {
                              return Padding(
                                padding: const EdgeInsets.all(2),
                                child: GridTile(
                                  child: Showcase.withWidget(
                                    key: botaoValorCinco,
                                    disposeOnTap: false,
                                    disableAnimation: true,
                                    width: 200,
                                    height: 200,
                                    container: Column(
                                      children: <Widget>[
                                        Row(
                                          children: <Widget>[
                                            Image.asset("assets/setaTrilha.png", width: 35),
                                          ],
                                        ),
                                        SizedBox(height: 15),
                                        Row(
                                          children: <Widget>[
                                            Image.asset("assets/mascote.png", width: 60),
                                          ],
                                        ),
                                        SizedBox(height: 15),
                                        Row(
                                          children: <Widget>[
                                            Text("Clique para adicionar o valor 5", 
                                              style: TextStyle(color: Colors.white, fontSize: 16)),
                                          ],
                                        ),
                                      ],
                                    ),
                                    onTargetClick: () async {
                                      if(_valorDigitado.length < 10){
                                        _txt = _firstDig ? key : _txt + key;
                                        _firstDig = false;
                                        _valorDigitado = formatValue(_txt);
                                        await vendaBloc.setTutorialPasso(13);
                                        WidgetsBinding.instance.addPostFrameCallback((_) =>
                                          ShowCaseWidget.of(myContext).startShowCase([botaoValorZero]));
                                      }    
                                    },
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
                                      onPressed: () {},  
                                    ),
                                  )
                                ),
                              );
                            } 

                            if (key == '0') {
                              return Padding(
                                padding: const EdgeInsets.all(2),
                                child: GridTile(
                                  child: Showcase.withWidget(
                                    key: botaoValorZero,
                                    disposeOnTap: false,
                                    disableAnimation: true,
                                    width: 200,
                                    height: 200,
                                    container: Column(
                                      children: <Widget>[
                                        Row(
                                          children: <Widget>[
                                            Image.asset("assets/mascote.png", width: 60),
                                          ],
                                        ),
                                        SizedBox(height: 15),
                                        Row(
                                          children: <Widget>[
                                            Text("Clique duas vezes para adicionar o valor 0", 
                                              style: TextStyle(color: Colors.white, fontSize: 16)),
                                          ],
                                        ),
                                        SizedBox(height: 15),
                                        Row(
                                          children: <Widget>[
                                            Image.asset("assets/setaAdicionarItem.png", width: 35),
                                          ],
                                        ),
                                      ],
                                    ),
                                    onTargetClick: () async {
                                      if(_valorDigitado.length < 10){
                                        _txt = _firstDig ? key : _txt + key;
                                        _firstDig = false;
                                        _valorDigitado = formatValue(_txt);
                                      }
                                      if (vendaBloc.tutorial.passo == 13) {
                                        await vendaBloc.setTutorialPasso(14);
                                        WidgetsBinding.instance.addPostFrameCallback((_) =>
                                          ShowCaseWidget.of(myContext).startShowCase([botaoValorZero]));
                                      } else if (vendaBloc.tutorial.passo == 14) {
                                        await vendaBloc.setTutorialPasso(15);
                                        WidgetsBinding.instance.addPostFrameCallback((_) =>
                                          ShowCaseWidget.of(myContext).startShowCase([botaoValorOK]));
                                      }
                                    },
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
                                      onPressed: ()  {},
                                    ),
                                  )
                                ),
                              );
                            } 

                            if (key == 'OK') {
                              return Padding(
                                padding: const EdgeInsets.all(2),
                                child: GridTile(
                                  child: Showcase.withWidget(
                                    width: 200,
                                    height: 200,
                                    container: Column(
                                      children: <Widget>[
                                        Row(
                                          children: <Widget>[
                                            Image.asset("assets/mascote.png", width: 60),
                                          ],
                                        ),
                                        SizedBox(height: 15),
                                        Row(
                                          children: <Widget>[
                                            Text("Clique para atribuir o valor", 
                                              style: TextStyle(color: Colors.white, fontSize: 16)),
                                          ],
                                        ),
                                        SizedBox(height: 15),
                                        Row(
                                          children: <Widget>[
                                            Image.asset("assets/setaAdicionarItem.png", width: 35),
                                          ],
                                        ),
                                      ],
                                    ),
                                    key: botaoValorOK,
                                    disposeOnTap: false,
                                    disableAnimation: true,
                                    onTargetClick: () async {
                                      if (_valorDigitado != "0,00") {
                                        _valorDigitado = _valorDigitado.replaceAll(".", "");
                                        vendaBloc.addMovimentoParcela(_tipoPagamento,double.parse(_valorDigitado.replaceAll(",", ".")));
                                        await vendaBloc.setTutorialPasso(16); 
                                        Navigator.pop(context);
                                      }
                                    },
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
                                      onPressed: ()  {},
                                    ),
                                  )
                                ),
                              );
                            } 
                          }

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
                                    vendaBloc.addMovimentoParcela(_tipoPagamento,double.parse(_valorDigitado.replaceAll(",", ".")));
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
                                    if(_valorDigitado.length < 10){
                                      _txt = _firstDig ? key : _txt + key;
                                      _firstDig = false;
                                      _valorDigitado = formatValue(_txt);
                                    }
                                  });
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
      )
    );
  }
}
