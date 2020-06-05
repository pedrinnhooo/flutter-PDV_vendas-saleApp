import 'dart:convert';

import 'package:common_files/common_files.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:fluggy/src/AppConfig.dart';
import 'package:fluggy/src/app_module.dart';
import 'package:fluggy/src/venda/consulta_movimento_cliente/pagamento_movimento_cliente/pagamento_movimento_valor/pagamento_movimento_valor_page.dart';

class PagamentoMovimentoClientePage extends StatefulWidget {
  double valorRestante;
  PagamentoMovimentoClientePage({this.valorRestante});
  @override
  _PagamentoMovimentoClientePageState createState() => _PagamentoMovimentoClientePageState();
}

class _PagamentoMovimentoClientePageState extends State<PagamentoMovimentoClientePage> {
  MovimentoClienteBloc movimentoClienteBloc;
  MoneyMaskedTextController valorSaldoAtual;
  String _txt;
  bool _firstDig;

  @override
  void initState() {
    super.initState();
    this._firstDig = true;
    this._txt = "";
    movimentoClienteBloc = AppModule.to.bloc<MovimentoClienteBloc>();
    movimentoClienteBloc.getallTipoPagamentos();
    valorSaldoAtual = MoneyMaskedTextController();
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
          color: Theme.of(context).primaryColor,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Flexible(
              flex: 3,
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    StreamBuilder(
                    stream: movimentoClienteBloc.movimentoClienteListOut,
                    builder: (context, snapshot) {
                      if(!snapshot.hasData){
                        return CircularProgressIndicator();
                      }
                      
                      List<MovimentoCliente> movimentoClienteList = snapshot.data;
                      valorSaldoAtual.updateValue(movimentoClienteList[movimentoClienteList.length-1].saldo);
                      widget.valorRestante = movimentoClienteList[movimentoClienteList.length-1].saldo;

                      return Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(movimentoClienteList[movimentoClienteList.length-1].saldo < 0 ? "-R\$" : "R\$ ",
                          style: Theme.of(context).textTheme.subtitle
                        ),
                        Text(" ${valorSaldoAtual.text}",
                          style: TextStyle(
                            color: Theme.of(context).textTheme.title.color,
                            fontStyle: Theme.of(context).textTheme.title.fontStyle,
                            fontWeight: Theme.of(context).textTheme.title.fontWeight,
                            fontSize: 36
                          )
                        )
                      ],);
                    }
                  ),
                  Text("Saldo Atual", style: Theme.of(context).textTheme.display3,),
                ]),
              )
            ),
            Flexible(
              flex: 1,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: StreamBuilder<List<TipoPagamento>>(
                  initialData: List<TipoPagamento>(),
                  stream: movimentoClienteBloc.tipoPagamentoListOut,
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return CircularProgressIndicator();
                    }
                    List<TipoPagamento> tipoPagamentoList = snapshot.data;

                    return GridView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount( crossAxisCount: 3, childAspectRatio: 1.45),
                      itemCount: tipoPagamentoList.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Padding(
                          padding: const EdgeInsets.all(2.5),
                          child: InkWell(
                            child: Container(
                              decoration: BoxDecoration(
                                color: Theme.of(context).accentColor,
                                borderRadius: BorderRadius.circular(8),),
                              child: Center(
                                child: Column(
                                  children: <Widget>[
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[
                                        Hero(
                                          tag:'${tipoPagamentoList[index].id}',
                                          child: FutureBuilder(
                                            future: Future.wait(
                                              tipoPagamentoList.map((tipoPagamento) async {
                                                tipoPagamento.icone = await readBase64Image("/images/tipoPagamento/${tipoPagamento.idPessoaGrupo}/${tipoPagamento.id}.txt");
                                              })
                                            ),
                                            builder: (context, snapshot) {
                                              if(snapshot.data == null || !snapshot.hasData){
                                                return Center(child: CircularProgressIndicator());
                                              } 
                                              return ClipRRect(
                                                borderRadius: BorderRadius.circular(8),
                                                child: Image.memory(base64Decode(tipoPagamentoList[index].icone),
                                                  fit: BoxFit.contain, 
                                                  color: Colors.white,
                                                  width: 50,
                                                  height: 50,
                                                ),
                                              );
                                            }
                                          )
                                        )
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[
                                        Text(tipoPagamentoList[index].nome,
                                          style: Theme.of(context).textTheme.display3
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              )),
                            onTap: () {
                              Navigator.push(context,
                                PageRouteBuilder(
                                  opaque: false,
                                  settings: RouteSettings(name: '/MovimentoValorPagamento'),
                                  pageBuilder: (BuildContext context, _, __) {
                                    return PagamentoMovimentoValorPage(
                                      tipoPagamento: tipoPagamentoList[index],
                                      valorRestante: valorSaldoAtual.text
                                    );
                                  },
                                  transitionsBuilder: (___, Animation<double> animation, ____, Widget child) {
                                    return FadeTransition(
                                      opacity: animation,
                                      child: child,
                                    );
                                  }
                                )
                              );
                            },
                          ),
                        );
                      }
                    );
                  }
                ),
              ),
            ),
          ],
        ),
      )
    );
  }
}
