import 'package:common_files/common_files.dart';
import 'package:date_range_picker/date_range_picker.dart' as DateRangePicker;
import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:fluggy/src/AppConfig.dart';
import 'package:fluggy/src/app_module.dart';
import 'package:fluggy/src/venda/consulta_venda/consulta_venda_bloc.dart';
import 'package:fluggy/src/venda/consulta_venda/consulta_venda_module.dart';

class ConsultaVendaPage extends StatefulWidget {
  @override
  _ConsultaVendaPageState createState() => _ConsultaVendaPageState();
}

class _ConsultaVendaPageState extends State<ConsultaVendaPage> {
  ConsultaVendaBloc consultaBloc;
  DateFormat dateFormat;
  DateFormat timeFormat;
  MoneyMaskedTextController valorTotalLiquido;
  SincronizacaoBloc sincBloc;
  String date;

  @override
  void initState() {
    consultaBloc = ConsultaVendaModule.to.getBloc<ConsultaVendaBloc>();
    consultaBloc.getAllMovimento(DateTime.now(), DateTime.now());
    sincBloc = AppModule.to.getBloc<SincronizacaoBloc>();
    valorTotalLiquido = MoneyMaskedTextController(leftSymbol: "R\$ ");
    date = "";
    initializeDateFormatting();
    dateFormat = DateFormat.Md('pt_BR');
    timeFormat = DateFormat.Hm('pt_BR');
    super.initState();
  }

   Widget returnRangePicker(BuildContext context) {
    return new Theme(
      data: Theme.of(context).copyWith(
        accentColor: Theme.of(context).primaryIconTheme.color,
        indicatorColor: Colors.white,
        dialogBackgroundColor: Theme.of(context).primaryColor,
        primaryColor: Theme.of(context).accentColor, // Header
        iconTheme: IconThemeData(
          color: Colors.white
        ),
        buttonTheme: ButtonThemeData(
          textTheme: ButtonTextTheme.accent,
          highlightColor: Colors.white, // onHover
          buttonColor: Theme.of(context).primaryColor,
          colorScheme: Theme.of(context).colorScheme.copyWith(
            onSecondary: Colors.yellow,
            primary: Colors.blueAccent,
            surface: Colors.pinkAccent,
            secondary: Theme.of(context).primaryIconTheme.color,
            brightness: Brightness.dark,
            onBackground: Theme.of(context).primaryColor
          ),
          disabledColor: Colors.redAccent
        )
      ),
      child: new Builder(
        builder: (context) => new FlatButton(
          onPressed: () async {
            final List<DateTime> picked = await DateRangePicker.showDatePicker(
              locale: Locale("pt"),
              context: context,
              firstDate: DateTime(DateTime.now().year-1,1,1),
              initialFirstDate: DateTime.now(),
              initialLastDate: DateTime.now(),
              lastDate: DateTime(DateTime.now().year,12,31)
            );
            if (picked != null) {
              if (picked.length == 0) {
                consultaBloc.getAllMovimento(picked[0], DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 23, 59, 59));
                setState(() {
                  date = picked[0].day.toString()+"/"+picked[0].month.toString()+"/"+picked[0].year.toString();
                });
              } else {
                consultaBloc.getAllMovimento(picked[0], picked[1]);
                setState(() {
                  date = 
                    picked[0].day.toString()+"/"+picked[0].month.toString()+"/"+picked[0].year.toString()+
                    " - " +
                    picked[1].day.toString()+"/"+picked[1].month.toString()+"/"+picked[1].year.toString();
                });
              }
            }
          },
          child: Icon(Icons.filter_list, color: Colors.white),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    AppConfig().init(context);
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
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor
        ),
        child: Column(
          children: <Widget>[
            returnRangePicker(context),
            // InkWell(
            //   child: ListTile(
            //     title: Text("Filtrar: "+date, style: Theme.of(context).textTheme.subtitle,),
            //     trailing: Icon(Icons.filter_list, size: 29, color: Theme.of(context).primaryIconTheme.color,),
            //   ),
            //   onTap: () async {
            //     returnRangePicker(context);
            //   },
            // ),
            Expanded(
              child: StreamBuilder<List<Movimento>>(
                initialData: List<Movimento>(),
                stream: consultaBloc.movimentoListOut,
                builder: (context, snapshot) {
                  List<Movimento> movimentoList = snapshot.data;

                  if (movimentoList.length == 0 ||
                      movimentoList.length == null) {
                    return Center(child: CircularProgressIndicator());
                  }

                  return ListView.builder(
                    itemCount: movimentoList.length,
                    itemBuilder: (context, index) {
                      valorTotalLiquido.updateValue(
                          movimentoList[index].valorTotalLiquido);
                      return Slidable(
                        actionPane: SlidableDrawerActionPane(),
                        actionExtentRatio: 0.25,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 4),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Theme.of(context).accentColor,
                              borderRadius: BorderRadius.circular(9)
                            ),
                            child: ListTile(
                              title: Text(movimentoList[index].idCliente > 0 ? "${movimentoList[index].cliente.razaoNome}" : "Consumidor", style: Theme.of(context).textTheme.body2,),
                              leading: Container(
                                padding: EdgeInsets.all(1.0),
                                height: AppConfig.safeBlockVertical * 11,
                                width: AppConfig.safeBlockHorizontal * 18,
                                child: Column(
                                  children: <Widget>[
                                    Row(
                                      children: <Widget>[
                                        Text(movimentoList[index].id == null
                                          ? "***"
                                          : "#${movimentoList[index].id}",
                                        style: TextStyle(
                                          color: movimentoList[index].id == null
                                            ? Colors.red
                                            : Color(0xff63dcc0),
                                          fontWeight: FontWeight.bold))
                                      ],
                                    ),
                                    Row(children: <Widget>[
                                        Text(dateFormat.format(movimentoList[index].dataMovimento), style: Theme.of(context).textTheme.body2,)
                                      ],
                                    ),
                                    Row(children: <Widget>[
                                        Text(timeFormat.format(movimentoList[index].dataMovimento), style: Theme.of(context).textTheme.body2,)
                                      ],
                                    )
                                  ],
                                )
                              ),
                              trailing: Container(
                                padding: EdgeInsets.all(1.0),
                                height: AppConfig.safeBlockVertical * 11,
                                width: AppConfig.safeBlockHorizontal * 22,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Row(mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[
                                        Text("${valorTotalLiquido.text}",
                                          style: Theme.of(context).textTheme.body2,
                                        )
                                      ],
                                    ),
                                    Row(mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[
                                        Text(movimentoList[index].totalItens.round() <= 1
                                          ? "${movimentoList[index].totalItens.round()} item"
                                          : "${movimentoList[index].totalItens.round()} itens",
                                          style: Theme.of(context).textTheme.body2,)
                                      ],
                                    )
                                  ],
                                )
                              ),
                            ),
                          ),
                        ),
                        secondaryActions: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(top: 4.0),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: Colors.red,
                              ),
                              child: IconSlideAction(
                                caption: 'Excluir',
                                color: Colors.transparent,
                                icon: Icons.close,
                                onTap: () async {
                                  consultaBloc.cancelMovimento(index);
                                  await sincBloc.sincronizacaoLambda.stop();
                                  sincBloc.sincronizacaoLambda.start();
                                }
                              ),
                            ),
                          )
                        ],
                      );
                    },
                  );
                }
              ),
            )
          ],
        ),
      ),
    );
  }
}
