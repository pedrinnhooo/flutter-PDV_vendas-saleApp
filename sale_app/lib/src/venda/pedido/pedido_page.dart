import 'package:common_files/common_files.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:fluggy/src/AppConfig.dart';
import 'package:fluggy/src/app_module.dart';
import 'package:intl/date_symbol_data_local.dart';

class PedidoPage extends StatefulWidget {
  @override
  _PedidoPageState createState() => _PedidoPageState();
}

class _PedidoPageState extends State<PedidoPage> {
  SharedVendaBloc vendaBloc = AppModule.to.getBloc<SharedVendaBloc>();

  @override
  Widget build(BuildContext context) {
    initializeDateFormatting();
    DateFormat dateFormat = new DateFormat.Md('pt_BR');
    DateFormat timeFormat = new DateFormat.Hm('pt_BR');
    AppConfig().init(context);

    return Expanded(
      child: StreamBuilder(
        stream: vendaBloc.pedidoListOut,
        builder: (context, snapshot) {
          var precoUnitario = MoneyMaskedTextController(leftSymbol: "R\$ ");
          var totalLiquido = MoneyMaskedTextController(leftSymbol: "R\$ ");
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          final List<Movimento> pedidoList = snapshot.data;

          if (pedidoList.length == 0) {
            return Container(
              color: Theme.of(context).primaryColor,
              child: Center(
                child: Text(
                  "Não há nenhum pedido pendente.",
                  style: Theme.of(context).textTheme.title,
                ),
              ),
            );
          }
          return ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: pedidoList.length,
            itemBuilder: (context, index) {
              totalLiquido.updateValue(pedidoList[index].valorTotalLiquido);
              precoUnitario.updateValue(pedidoList[index].valorTotalLiquido);
              return GestureDetector(
                child: Slidable(
                  actionPane: SlidableDrawerActionPane(),
                  actionExtentRatio: 0.25,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 5),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(width: 2, color: Theme.of(context).accentColor,),
                      ),
                      child: ListTile(
                        key: Key("${pedidoList[index]}"),
                        title: Column(
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Text("Consumidor",
                                style: Theme.of(context).textTheme.body2,),
                              ],
                            ),
                            Row(
                              children: <Widget>[
                                Text(
                                  "Obs:",
                                  style: TextStyle(fontSize: 12),
                                ),
                              ],
                            ),
                          ],
                        ),
                        trailing: Container(
                          padding: EdgeInsets.all(1.0),
                          height: AppConfig.safeBlockVertical * 11,
                          width: AppConfig.safeBlockHorizontal * 22,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                  Text(pedidoList[index].valorTotalLiquido > 0 ?
                                    "${totalLiquido.text}" :
                                    "-${totalLiquido.text}",
                                    style: pedidoList[index].valorTotalLiquido > 0 
                                      ? Theme.of(context).textTheme.body2
                                      : Theme.of(context).accentTextTheme.body2,
                                  )
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                  Text(pedidoList[index].totalItens.round() <= 1
                                    ? "${pedidoList[index].totalItens.round()} item"
                                    : "${pedidoList[index].totalItens.round()} itens",
                                    style: Theme.of(context).textTheme.body2,)
                                ],
                              )
                            ],
                          )
                        ),
                        leading: Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text("#${pedidoList[index].idApp}",
                                style: Theme.of(context).textTheme.body2
                              ),
                              Text(dateFormat.format(pedidoList[index].dataMovimento,),
                                style: Theme.of(context).textTheme.body2,
                              ),
                              Text(timeFormat.format(pedidoList[index].dataMovimento),
                                style: Theme.of(context).textTheme.body2,
                              )
                            ],
                          )
                        ),
                      ),
                    ),
                  ),
                  secondaryActions: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(left: 2.0, right: 8.0, top: 5),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(8)
                        ),
                        child: IconSlideAction(
                          caption: 'Excluir',
                          color: Colors.transparent,
                          icon: Icons.delete,
                          onTap: () {
                            vendaBloc.cancelPedido(index);
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                onTap: () {
                  vendaBloc.getPedido(index); 
                },
              );
            },
          );
        }
      )
    );
  }
}
