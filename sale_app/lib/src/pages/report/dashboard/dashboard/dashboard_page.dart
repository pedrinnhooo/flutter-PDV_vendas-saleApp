import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:common_files/common_files.dart';
import 'package:fluggy/src/app_module.dart';
import 'package:fluggy/src/pages/report/dashboard/dashboard/dashboard_module.dart';
import 'package:fluggy/src/pages/report/list/sale/category/report_list_sale_category_module.dart';
import 'package:fluggy/src/pages/report/list/sale/payment/report_list_sale_payment_module.dart';
import 'package:fluggy/src/pages/report/list/sale/product/report_list_sale_product_module.dart';
import 'package:fluggy/src/pages/report/list/sale/ticket/report_list_sale_ticket_module.dart';
import 'package:flutter/material.dart';
import 'package:flutter_echarts/flutter_echarts.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({Key key}) : super(key: key);

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  AppGlobalBloc appGlobalBloc;
  DashboardBloc dashboardBloc;
  MoneyMaskedTextController valorTotalBruto = MoneyMaskedTextController(leftSymbol: "R\$ ");
  MoneyMaskedTextController ticketMedio = MoneyMaskedTextController(leftSymbol: "R\$ ");
  MoneyMaskedTextController valorTotalLiquido = MoneyMaskedTextController(leftSymbol: "R\$ ");
  MoneyMaskedTextController valorTotalLucro = MoneyMaskedTextController(leftSymbol: "R\$ ");
  MoneyMaskedTextController valorTotalCusto = MoneyMaskedTextController(leftSymbol: "R\$ ");
  MoneyMaskedTextController percentualLucro = MoneyMaskedTextController(rightSymbol: " %");
  MoneyMaskedTextController valorTipoPagamento = MoneyMaskedTextController(leftSymbol: "R\$ ");
  MoneyMaskedTextController valorProduto = MoneyMaskedTextController(leftSymbol: "R\$ ");
  MoneyMaskedTextController valorCategoria = MoneyMaskedTextController(leftSymbol: "R\$ ");
  DateFormat dateFormat = new DateFormat.yMd('pt_BR');

  @override
  void initState() {
    appGlobalBloc = AppModule.to.getBloc<AppGlobalBloc>();
    dashboardBloc = DashboardModule.to.getBloc<DashboardBloc>();
    dashboardBloc.getRelatorioData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Dashboard", style: Theme.of(context).textTheme.title,),
      ),
      body: Container(
        padding: EdgeInsets.only(left: 15, right: 15),
        color: Theme.of(context).primaryColor,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              StreamBuilder<List<String>>(
                stream: dashboardBloc.relatorioCardVendaGraficoDataControllerOut,
                builder: (context, snapshot) {
                  if (!snapshot.hasData || snapshot.data.length == 0) {
                    return CircularProgressIndicator();
                  }
                  List<String> _relatorioCardVendaGraficoData = snapshot.data;

                  return StreamBuilder<List<String>>(
                    stream: dashboardBloc.relatorioCardVendaGraficoAnteriorDataControllerOut,
                    builder: (context, snapshot) {
                      if (!snapshot.hasData || snapshot.data.length == 0) {
                        return CircularProgressIndicator();
                      }
                      List<String> _relatorioCardVendaGraficoAnteriorData = snapshot.data;
                      return  InkWell(
                        onTap: () {
                          Navigator.push(context,
                            PageRouteBuilder(
                              pageBuilder:
                              (BuildContext context, _, __) => ReportListSaleTicketModule(),
                              settings: RouteSettings(name: '/ReportListSaleTicketPage'),
                            )
                          );
                        },
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                            side: BorderSide(color: Colors.white54
                            //Theme.of(context).accentColor
                            )
                          ),
                          color: Theme.of(context).primaryColor,
                          child: Column(
                            children: <Widget>[
                              Container(
                                padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text(
                                      "VENDAS POR PERÍODO",
                                      style: Theme.of(context).textTheme.body2,
                                    ),
                                    Container(
                                      padding: EdgeInsets.only(left: 3),
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: Colors.white70,
                                          width: 1
                                        ),
                                        borderRadius: BorderRadius.circular(8)
                                      ),
                                      child: StreamBuilder<PeriodoRelatorioItem>(
                                        stream: dashboardBloc.periodoRelatorioSelecionadoControllerOut,
                                        builder: (context, snapshot) {
                                          if (!snapshot.hasData) {
                                            return CircularProgressIndicator();
                                          }
                                          PeriodoRelatorioItem _periodoRelatorioItem = snapshot.data;
                                          return DropdownButtonHideUnderline(
                                            child: DropdownButton<PeriodoRelatorioItem>(
                                              //hint:  Text("Select item"),
                                              isDense: true,
                                              elevation: 2,
                                              style: TextStyle(fontSize: 10),
                                              iconSize: 25,
                                              iconEnabledColor: Colors.white,
                                              value:  _periodoRelatorioItem,
                                              onChanged: (PeriodoRelatorioItem value) async {
                                                await dashboardBloc.setPeriodoRelatorio(value, context: context);
                                                await dashboardBloc.getRelatorioData();
                                              },
                                              items: dashboardBloc.periodoList.map((PeriodoRelatorioItem _periodo) {
                                                return  DropdownMenuItem<PeriodoRelatorioItem>(
                                                  value: _periodo,
                                                  child: Row(
                                                    children: <Widget>[
                                                      _periodo.icon,
                                                      SizedBox(width: 5,),
                                                      Text(
                                                        _periodo.nome,
                                                        //style:  Theme.of(context).textTheme.body2,
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              }).toList(),
                                            ),
                                          );
                                        }
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: StreamBuilder<DateTime>(
                                  stream: dashboardBloc.dataInicialControllerOut,
                                  builder: (context, snapshot) {
                                    if (!snapshot.hasData) {
                                      return CircularProgressIndicator();
                                    }
                                    DateTime _dataInicial = snapshot.data;
                                    return StreamBuilder<DateTime>(
                                      stream: dashboardBloc.dataFinalControllerOut,
                                      builder: (context, snapshot) {
                                        if (!snapshot.hasData) {
                                          return CircularProgressIndicator();
                                        }
                                        DateTime _dataFinal = snapshot.data;
                                        return Text(
                                          "${dateFormat.format(_dataInicial)} - ${dateFormat.format(_dataFinal)}",
                                          style: Theme.of(context).textTheme.body2,
                                        );
                                      }
                                    );
                                  }
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: Container(
                                  alignment: Alignment.centerRight,
                                  width: double.infinity,
                                  height: 250,
                                  child: Echarts(
                                    option: '''
                                      {
                                        legend: {
                                          data: ['selecionado', 'anterior'],
                                          textStyle: {
                                            color: '#ffffff'
                                          }
                                        },
                                        xAxis: {
                                          type: 'category',
                                          data: [${_relatorioCardVendaGraficoData[0].length >= _relatorioCardVendaGraficoAnteriorData[0].length ? _relatorioCardVendaGraficoData[0] : _relatorioCardVendaGraficoAnteriorData[0]}]
                                        },
                                        yAxis: {
                                          type: 'value',
                                          axisLabel: {
                                            formatter: function(value) {
                                              return 'R\$ '+value;
                                            }
                                          }
                                        },
                                        textStyle:{
                                          color: 'white'
                                        },
                                        series: [
                                          {
                                            data: [${_relatorioCardVendaGraficoData[1]}],
                                            name: 'selecionado',
                                            type: 'line',
                                            smooth: true,
                                            itemStyle: {
                                              normal: {
                                                color: "#32b87b"
                                              }
                                            },
                                            symbol: "circle"                            
                                          },
                                        {
                                            data: [${_relatorioCardVendaGraficoAnteriorData[1]}],
                                            name: 'anterior',
                                            type: 'line',
                                            smooth: true,
                                            itemStyle: {
                                              normal: {
                                                color: "#ffa500"
                                              }
                                            },
                                            symbol: "circle"                            
                                          }                                
                                        ],
                                        backgroundColor: '#030c31',
                                        grid: {
                                          containLabel: true,
                                          left: 20,
                                          top: 30,
                                          right: 10,
                                          bottom: 10
                                        }
                                      }
                                    ''',
                                  ),
                                ),
                              ),
                            ],
                          )
                        ),
                      );
                    }
                  );
                }
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        height: 120,
                        child: StreamBuilder<RelatorioCardVendaTotal>(
                          stream: dashboardBloc.relatorioCardVendaTotalControllerOut,
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) {
                              return CircularProgressIndicator();
                            }
                            RelatorioCardVendaTotal _relatorioCardVendaTotal = snapshot.data;
                            valorTotalBruto.updateValue(_relatorioCardVendaTotal.valorTotalBruto);
                            ticketMedio.updateValue(_relatorioCardVendaTotal.ticketMedio);
                            return Stack(
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(top: 10),
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.push(context,
                                        PageRouteBuilder(
                                          pageBuilder:
                                          (BuildContext context, _, __) => ReportListSaleTicketModule(),
                                          settings: RouteSettings(name: '/ReportListSaleTicketPage'),
                                        )
                                      );
                                    },
                                    child: Card(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(Radius.circular(6)),
                                        side: BorderSide(color: Colors.white70)
                                      ),
                                      color: Theme.of(context).primaryColor,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: <Widget>[
                                          Center(
                                            child: Text(
                                              "Total de Vendas",
                                              style: TextStyle(
                                                color: Colors.white
                                              ),
                                            ),
                                          ),
                                          Container(
                                            padding: EdgeInsets.all(2),
                                            child: Center(
                                              child: AutoSizeText(
                                                valorTotalBruto.text,
                                                style: Theme.of(context).textTheme.title,
                                                maxFontSize: Theme.of(context).textTheme.title.fontSize,
                                                minFontSize: Theme.of(context).textTheme.body2.fontSize,
                                                maxLines: 1,
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.topCenter,
                                  child: Container(
                                    padding: EdgeInsets.all(4),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Theme.of(context).primaryColor
                                    ),
                                    child: Image.asset('assets/caixaIcon.png', height: 30,)
                                  )
                                ),
                              ],
                            );
                          }
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        height: 120,
                        child: StreamBuilder<RelatorioCardLucroTotal>(
                          stream: dashboardBloc.relatorioCardLucroTotalControllerOut,
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) {
                              return CircularProgressIndicator();
                            }
                            RelatorioCardLucroTotal _relatorioCardLucroTotal = snapshot.data;
                            valorTotalLucro.updateValue(_relatorioCardLucroTotal.valorTotalLucro);
                            return Stack(
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(top: 10),
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.push(context,
                                        PageRouteBuilder(
                                          pageBuilder:
                                          (BuildContext context, _, __) => ReportListSaleTicketModule(),
                                          settings: RouteSettings(name: '/ReportListSaleTicketPage'),
                                        )
                                      );
                                    },
                                    child: Card(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(Radius.circular(6)),
                                        side: BorderSide(color: Colors.white70)
                                      ),
                                      color: Theme.of(context).primaryColor,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: <Widget>[
                                          Center(
                                            child: Text(
                                              "Total de lucro",
                                              style: TextStyle(
                                                color: Colors.white
                                              ),
                                            ),
                                          ),
                                          Container(
                                            padding: EdgeInsets.all(2),
                                            child: Center(
                                              child: AutoSizeText(
                                                valorTotalLucro.text,
                                                style: Theme.of(context).textTheme.title,
                                                maxFontSize: Theme.of(context).textTheme.title.fontSize,
                                                minFontSize: Theme.of(context).textTheme.body2.fontSize,
                                                maxLines: 1,
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.topCenter,
                                  child: Container(
                                    padding: EdgeInsets.all(4),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Theme.of(context).primaryColor
                                    ),
                                    child: Image.asset('assets/precoCustoIcon.png', height: 30),
                                  )
                                )
                              ],
                            );
                          }
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        height: 120,
                        child: StreamBuilder<RelatorioCardVendaTotal>(
                          stream: dashboardBloc.relatorioCardVendaTotalControllerOut,
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) {
                              return CircularProgressIndicator();
                            }
                            RelatorioCardVendaTotal _relatorioCardVendaTotal = snapshot.data;
                            return Stack(
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(top: 10),
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.push(context,
                                        PageRouteBuilder(
                                          pageBuilder:
                                          (BuildContext context, _, __) => ReportListSaleTicketModule(),
                                          settings: RouteSettings(name: '/ReportListSaleTicketPage'),
                                        )
                                      );
                                    },
                                    child: Card(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(Radius.circular(6)),
                                        side: BorderSide(color: Colors.white70)
                                      ),
                                      color: Theme.of(context).primaryColor,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: <Widget>[
                                          Center(
                                            child: Text(
                                              "Qtde de Vendas",
                                              style: TextStyle(
                                                color: Colors.white
                                              ),
                                            ),
                                          ),
                                          Container(
                                            padding: EdgeInsets.all(2),
                                            child: Center(
                                              child: AutoSizeText(
                                                 _relatorioCardVendaTotal.quantidadeVendas.toString(),
                                                style: Theme.of(context).textTheme.title,
                                                maxFontSize: Theme.of(context).textTheme.title.fontSize,
                                                minFontSize: Theme.of(context).textTheme.body2.fontSize,
                                                maxLines: 1,
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.topCenter,
                                  child: Container(
                                    padding: EdgeInsets.all(4),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Theme.of(context).primaryColor
                                    ),
                                    child: Image.asset('assets/vendaClienteIcon.png', height: 35,),
                                  )
                                )
                              ],
                            );
                          }
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        height: 120,
                        child: StreamBuilder<RelatorioCardVendaTotal>(
                          stream: dashboardBloc.relatorioCardVendaTotalControllerOut,
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) {
                              return CircularProgressIndicator();
                            }
                            RelatorioCardVendaTotal _relatorioCardVendaTotal = snapshot.data;
                            ticketMedio.updateValue(_relatorioCardVendaTotal.ticketMedio);
                            return Stack(
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(top: 10),
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.push(context,
                                        PageRouteBuilder(
                                          pageBuilder:
                                          (BuildContext context, _, __) => ReportListSaleTicketModule(),
                                          settings: RouteSettings(name: '/ReportListSaleTicketPage'),
                                        )
                                      );
                                    },
                                    child: Card(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(Radius.circular(6)),
                                        side: BorderSide(color: Colors.white70)
                                      ),
                                      color: Theme.of(context).primaryColor,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: <Widget>[
                                          Center(
                                            child: Text(
                                              "Ticket Médio",
                                              style: TextStyle(
                                                color: Colors.white
                                              ),
                                            ),
                                          ),
                                          Container(
                                            padding: EdgeInsets.all(2),
                                            child: Center(
                                              child: AutoSizeText(
                                                ticketMedio.text,
                                                style: Theme.of(context).textTheme.title,
                                                maxFontSize: Theme.of(context).textTheme.title.fontSize,
                                                minFontSize: Theme.of(context).textTheme.body2.fontSize,
                                                maxLines: 1,
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.topCenter,
                                  child: Container(
                                    padding: EdgeInsets.only(bottom: 5),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Theme.of(context).primaryColor
                                    ),
                                    child: Image.asset('assets/ticketMedioIcon.png', height: 40,),
                                  )
                                )
                              ],
                            );
                          }
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: InkWell(
                  onTap: () {
                    Navigator.push(context,
                      PageRouteBuilder(
                        pageBuilder:
                        (BuildContext context, _, __) => ReportListSalePaymentModule(),
                        settings: RouteSettings(name: '/ReportListSaleTicketPage'),
                      )
                    );
                  },                
                  child: Card(
                    elevation: 1,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(6)),
                      side: BorderSide(color: Colors.white70)
                    ),
                    color: Theme.of(context).primaryColor,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: Text("TIPOS DE PAGAMENTO", style: Theme.of(context).textTheme.body2,),
                          ),
                          StreamBuilder<List<RelatorioCardTipoPagamento>>(
                            stream: dashboardBloc.relatorioCardTipoPagamentoListControllerOut,
                            builder: (context, snapshot) {
                              if(!snapshot.hasData){
                                return CircularProgressIndicator();
                              }
                              List<RelatorioCardTipoPagamento> _relatorioCardTipoPagamentoList = snapshot.data;
                              
                              return ListView.separated(
                                itemCount: _relatorioCardTipoPagamentoList.length,
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                separatorBuilder: (context, index){
                                  return Divider(color: Colors.white, height: 0.8,);
                                },
                                itemBuilder: (context, index) {
                                  valorTipoPagamento.updateValue(_relatorioCardTipoPagamentoList[index].valor);
                                  return ListTile(
                                    contentPadding: EdgeInsets.all(0.8),
                                    dense: true,
                                    leading: Container(
                                      width: 50,
                                      height: 50,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Container(
                                            padding: EdgeInsets.all(6),
                                            child: StreamBuilder(
                                              stream: readBase64Image("/images/tipoPagamento/${appGlobalBloc.loja.idPessoaGrupo}/${ _relatorioCardTipoPagamentoList[index].idTipoPagamento}.txt").asStream(),
                                              builder: (context, snapshot){
                                                return AnimatedSwitcher(
                                                  duration: Duration(milliseconds: 200),
                                                  child: snapshot.data != null 
                                                  ? Image.memory(base64Decode(snapshot.data.toString()),
                                                    fit: BoxFit.contain,
                                                    height: 30,
                                                    color: Colors.white,
                                                  ) 
                                                  : Icon(Icons.error_outline, color: Colors.white,)
                                                );
                                              } 
                                            ),
                                          ),
                                          Container(
                                            width: 1,
                                            height: 20,
                                            color: Colors.white,
                                          ),
                                        ],
                                      ),
                                    ),
                                    title: Container(
                                      alignment: Alignment.centerLeft,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Padding(
                                            padding: const EdgeInsets.only(bottom: 5),
                                            child: Text(_relatorioCardTipoPagamentoList[index].nome , style: Theme.of(context).textTheme.body2,),
                                          ),
                                          LinearPercentIndicator(
                                            width: 180,
                                            lineHeight: 5,
                                            percent: (_relatorioCardTipoPagamentoList[index].valor / dashboardBloc.totalTipoPagamento).clamp(0.0, 1.0),
                                            backgroundColor: Theme.of(context).accentColor,
                                            progressColor: Theme.of(context).primaryIconTheme.color,
                                            padding: EdgeInsets.all(2.2),
                                          ),
                                        ],
                                      ),
                                    ),
                                    trailing: Container(
                                      alignment: Alignment.centerRight,
                                      width: 70,
                                      child: AutoSizeText(
                                        valorTipoPagamento.text,
                                        style: Theme.of(context).textTheme.body2,
                                        maxFontSize: Theme.of(context).textTheme.body2.fontSize,
                                        minFontSize: 8,
                                        maxLines: 1,
                                      ),
                                    )
                                  );
                                }
                              );
                            }
                          ),
                        ]
                      ),
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  Navigator.push(context,
                    PageRouteBuilder(
                      pageBuilder:
                      (BuildContext context, _, __) => ReportListSaleProductModule(),
                      settings: RouteSettings(name: '/ReportListSaleTicketPage'),
                    )
                  );
                },                
                child: Card(
                  elevation: 1,
                  color: Theme.of(context).primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(6)),
                    side: BorderSide(color: Colors.white70)
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Text("PRODUTOS MAIS VENDIDOS", style: Theme.of(context).textTheme.body2,),
                        ),
                        StreamBuilder<List<RelatorioCardTopProduto>>(
                          stream: dashboardBloc.relatorioCardTopProdutoListControllerOut,
                          builder: (context, snapshot) {
                            if(!snapshot.hasData){
                              return CircularProgressIndicator();
                            }
                            List<RelatorioCardTopProduto> _relatorioCardTopProdutoList = snapshot.data;
                            
                            return ListView.separated(
                              itemCount: _relatorioCardTopProdutoList.length,
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              separatorBuilder: (context, index){
                                return Divider(color: Colors.white,);
                              },
                              itemBuilder: (context, index) {
                                valorProduto.updateValue(_relatorioCardTopProdutoList[index].valor);
                                return Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Padding(
                                          padding: const EdgeInsets.only(left: 7, bottom: 5),
                                          child: Text(_relatorioCardTopProdutoList[index].nome , style: Theme.of(context).textTheme.body2,),
                                        ),
                                        LinearPercentIndicator(
                                          width: 220,
                                          lineHeight: 5,
                                          percent: (_relatorioCardTopProdutoList[index].valor / _relatorioCardTopProdutoList[0].valor).clamp(0.0, 1.0),
                                          backgroundColor: Theme.of(context).accentColor,
                                          progressColor: Theme.of(context).primaryIconTheme.color,
                                        ),
                                      ],
                                    ),
                                    Container(
                                      alignment: Alignment.centerRight,
                                      child: AutoSizeText(
                                        valorProduto.text,
                                        style: Theme.of(context).textTheme.body2,
                                        maxFontSize: Theme.of(context).textTheme.body2.fontSize,
                                        minFontSize: 8,
                                        maxLines: 1,
                                      ),
                                    )
                                  ],
                                );
                              }
                            );
                          }
                        ),
                      ]
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  Navigator.push(context,
                    PageRouteBuilder(
                      pageBuilder:
                      (BuildContext context, _, __) => ReportListSaleCategoryModule(),
                      settings: RouteSettings(name: '/ReportListSaleTicketPage'),
                    )
                  );
                },                  
                child: Card(
                  elevation: 1,
                  color: Theme.of(context).primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(6)),
                    side: BorderSide(color: Colors.white70)
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Text("CATEGORIAS MAIS VENDIDAS", style: Theme.of(context).textTheme.body2),
                        ),
                        StreamBuilder<List<RelatorioCardTopCategoria>>(
                          stream: dashboardBloc.relatorioCardTopCategoriaListControllerOut,
                          builder: (context, snapshot) {
                            if(!snapshot.hasData){
                              return CircularProgressIndicator();
                            }
                            List<RelatorioCardTopCategoria> _relatorioCardTopCategoriaList = snapshot.data;
                            
                            return ListView.separated(
                              itemCount: _relatorioCardTopCategoriaList.length,
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              separatorBuilder: (context, index){
                                return Divider(color: Colors.white,);
                              },
                              itemBuilder: (context, index) {
                                valorCategoria.updateValue(_relatorioCardTopCategoriaList[index].valor);
                                return Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Padding(
                                          padding: const EdgeInsets.only(left: 7, bottom: 5),
                                          child: Text(_relatorioCardTopCategoriaList[index].nome , style: Theme.of(context).textTheme.body2,),
                                        ),
                                        LinearPercentIndicator(
                                          width: 220,
                                          lineHeight: 5,
                                          percent: (_relatorioCardTopCategoriaList[index].valor / _relatorioCardTopCategoriaList[0].valor).clamp(0.0, 1.0),
                                          backgroundColor: Theme.of(context).accentColor,
                                          progressColor: Theme.of(context).primaryIconTheme.color,
                                        ),
                                      ],
                                    ),
                                    Container(
                                      alignment: Alignment.centerRight,
                                      child: AutoSizeText(
                                        valorCategoria.text,
                                        style: Theme.of(context).textTheme.body2,
                                        maxFontSize: Theme.of(context).textTheme.body2.fontSize,
                                        minFontSize: 8,
                                        maxLines: 1,
                                      ),
                                    )
                                  ],
                                );
                              }
                            );
                          }
                        ),
                      ]
                    ),
                  ),
                ),
              ),   
            ],
          ),
        ),
      ),
    );
  }
}