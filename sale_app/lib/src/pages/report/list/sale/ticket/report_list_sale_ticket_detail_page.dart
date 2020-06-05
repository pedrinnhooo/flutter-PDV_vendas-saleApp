import 'dart:io';
import 'dart:typed_data';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:common_files/common_files.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:fluggy/src/pages/report/list/sale/ticket/report_list_sale_ticket_module.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:fluggy/src/AppConfig.dart';
import 'package:fluggy/src/app_module.dart';
import 'package:intl/intl.dart';
import 'package:screenshot/screenshot.dart';
import 'package:path_provider/path_provider.dart';

class ReportListSaleTicketDetailPage extends StatefulWidget {
  int index;
  ReportListSaleTicketDetailPage({this.index});

  @override
  _ReportListSaleTicketDetailPageState createState() => _ReportListSaleTicketDetailPageState();
}

class _ReportListSaleTicketDetailPageState extends State<ReportListSaleTicketDetailPage> {
  ReportListSaleTicketBloc reportListSaleTicketBloc;
  AppGlobalBloc appGlobalBloc;
  MoneyMaskedTextController precoVendido;
  MoneyMaskedTextController totalDesconto;
  MoneyMaskedTextController totalLiquido;
  MoneyMaskedTextController valorTotalBruto;
  MoneyMaskedTextController valorTotalDesconto;
  MoneyMaskedTextController valorTotalLiquido;
  ScreenshotController screenshotController; 
  DateFormat dateFormat;

  @override
  void initState() { 
    super.initState();
    screenshotController = ScreenshotController();
    reportListSaleTicketBloc = ReportListSaleTicketModule.to.getBloc<ReportListSaleTicketBloc>();
    appGlobalBloc = AppModule.to.getBloc<AppGlobalBloc>();
    precoVendido = MoneyMaskedTextController(leftSymbol: "R\$ ");
    totalDesconto = MoneyMaskedTextController(leftSymbol: "R\$ "); 
    totalLiquido = MoneyMaskedTextController(leftSymbol: "R\$ ");
    valorTotalBruto = MoneyMaskedTextController(leftSymbol: "R\$ ");
    valorTotalDesconto = MoneyMaskedTextController(leftSymbol: "R\$ ");
    valorTotalLiquido = MoneyMaskedTextController(leftSymbol: "R\$ ");
    reportListSaleTicketBloc.getSaleById(widget.index);
    dateFormat = DateFormat.jms('pt_BR');
  }

  shareFunction({index}) async {
    String _dateTime = DateTime.now().toString().replaceAll("-", "").replaceAll(":", "").replaceAll(".", "").replaceAll(" ", "");
    final directory = (await getTemporaryDirectory()).path;
    screenshotController.capture(
      path: "$directory/$_dateTime.png",
      pixelRatio: 1.8)
      .then((File image) async {
        final ByteData byteImg = await rootBundle.load(image.path.toString());
        await Share.files(
          'Compartilhamento Fluggy',
          {
            'Fluggy$_dateTime.png': byteImg.buffer.asUint8List(),
          },
          '*/*',
          text: '');
        image.deleteSync(recursive: true);
      }).catchError((onError) {
        print(onError);
        File image = File("$directory/$_dateTime.png",);
        image.deleteSync(recursive: true);
      }
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
        padding: const EdgeInsets.all(15.0),
        height: double.infinity,
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor
        ),
        child: Container(
          padding: EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: Theme.of(context).accentColor,
            borderRadius: BorderRadius.circular(8)
          ),
          child: SingleChildScrollView(
            child: Screenshot(
              controller: screenshotController,
              child: Container(
                padding: EdgeInsets.all(5),
                child: Column(
                  children: <Widget>[
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.asset('assets/reciboHeader.png',
                        fit: BoxFit.fitWidth, 
                        width: double.infinity,
                        height: 8,
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        border: Border.all(width: 0.01, color: Colors.transparent),                        
                        color: Colors.yellow[100],
                        borderRadius: BorderRadius.circular(3)
                      ),
                      child: StreamBuilder(
                        stream: reportListSaleTicketBloc.movimentoOut,
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return Center(child: CircularProgressIndicator());
                          }

                          final Movimento movimento = snapshot.data;
                          valorTotalLiquido.updateValue(movimento.valorTotalLiquido);
                          valorTotalDesconto.updateValue(movimento.valorTotalDesconto);
                          valorTotalBruto.updateValue(movimento.valorTotalBruto);

                          return Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Text(appGlobalBloc.loja.razaoNome != null ? appGlobalBloc.loja.razaoNome : "Nome da sua loja", 
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: Theme.of(context).textTheme.title.fontSize,
                                  fontStyle: Theme.of(context).textTheme.title.fontStyle
                                ), 
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              appGlobalBloc.loja.endereco.length > 0 ? Text("${appGlobalBloc.loja.endereco.first.logradouro}, ${appGlobalBloc.loja.endereco.first.numero}-${appGlobalBloc.loja.endereco.first.bairro}", style: TextStyle(
                                  color: Colors.black,
                                  fontSize: Theme.of(context).textTheme.body2.fontSize,
                                  fontStyle: Theme.of(context).textTheme.body2.fontStyle
                                ), textAlign: TextAlign.center,
                              ) : Text("Endereço não cadastrado", textAlign: TextAlign.center, style: TextStyle(color: Colors.black),),
                              appGlobalBloc.loja.endereco.length > 0 ? Text("${appGlobalBloc.loja.endereco.first.ibgeMunicipio}, ${appGlobalBloc.loja.endereco.first.estado}, ${appGlobalBloc.loja.endereco.first.cep}", style: TextStyle(
                                  color: Colors.black,
                                  fontSize: Theme.of(context).textTheme.body2.fontSize,
                                  fontStyle: Theme.of(context).textTheme.body2.fontStyle
                                ), textAlign: TextAlign.center,
                              ) : Text("", textAlign: TextAlign.center),
                              SizedBox(
                                height: 20,
                              ),
                              Divider(height: 0.5, color: Colors.black,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text("19/09/2019", style: TextStyle(
                                    color: Colors.black,
                                    fontSize: Theme.of(context).textTheme.body2.fontSize,
                                    fontStyle: Theme.of(context).textTheme.body2.fontStyle
                                    ), 
                                  ),
                                  Text(reportListSaleTicketBloc.movimento.idApp == null 
                                    ? "Novo orçamento" 
                                    : "Venda #${reportListSaleTicketBloc.movimento.id}",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: Theme.of(context).textTheme.subhead.fontSize,
                                      fontStyle: Theme.of(context).textTheme.subhead.fontStyle,
                                      fontWeight: FontWeight.w600
                                    ), 
                                    textAlign: TextAlign.center,
                                  ),
                                  Text("12:30", 
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: Theme.of(context).textTheme.body2.fontSize,
                                      fontStyle: Theme.of(context).textTheme.body2.fontStyle
                                    ),
                                  )
                                ],
                              ),
                              Divider(height: 0.5, color: Colors.black,),
                              Padding(padding: EdgeInsets.only(bottom: 10)),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Text("Cliente: ${reportListSaleTicketBloc.movimento.cliente.fantasiaApelido != "" ? reportListSaleTicketBloc.movimento.cliente.fantasiaApelido : "Não informado"}\nVendedor: ${reportListSaleTicketBloc.movimento.vendedor.fantasiaApelido != "" ? reportListSaleTicketBloc.movimento.vendedor.fantasiaApelido : "Não informado"}",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: Theme.of(context).textTheme.body2.fontSize,
                                      fontStyle: Theme.of(context).textTheme.body2.fontStyle
                                    ),
                                  )
                                ],
                              ),
                              Padding(
                                padding: EdgeInsets.only(bottom: 30),
                              ),
                              ListView.separated(
                                separatorBuilder: (context, index) => Divider(
                                  height: 2,
                                  color: Colors.grey,
                                ),
                                scrollDirection: Axis.vertical,
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: movimento.movimentoItem.length,
                                itemBuilder: (context, index) {
                                  precoVendido.updateValue(movimento.movimentoItem[index].precoVendido);
                                  totalLiquido.updateValue(movimento.movimentoItem[index].totalLiquido);
                                  if (index == movimento.movimentoItem.length - 1) {
                                    shareFunction(index: index);
                                  }
                                  if (movimento.movimentoItem[index].totalDesconto != null) {
                                    totalDesconto.updateValue(movimento.movimentoItem[index].totalDesconto);
                                  }
                                  String tamanho;
                                  switch (movimento.movimentoItem[index].gradePosicao) {
                                    case 0:
                                      {
                                        tamanho = "";
                                      }
                                      break;
                                    case 1:
                                      {
                                        tamanho = movimento.movimentoItem[index].produto.grade.t1;
                                      }
                                      break;
                                    case 2:
                                      {
                                        tamanho = movimento.movimentoItem[index].produto.grade.t2;
                                      }
                                      break;
                                    case 3:
                                      {
                                        tamanho = movimento.movimentoItem[index].produto.grade.t3;
                                      }
                                      break;
                                    case 4:
                                      {
                                        tamanho = movimento.movimentoItem[index].produto.grade.t4;
                                      }
                                      break;
                                    case 5:
                                      {
                                        tamanho = movimento.movimentoItem[index].produto.grade.t5;
                                      }
                                      break;
                                    case 6:
                                      {
                                        tamanho = movimento.movimentoItem[index].produto.grade.t6;
                                      }
                                      break;
                                    case 7:
                                      {
                                        tamanho = movimento.movimentoItem[index].produto.grade.t7;
                                      }
                                      break;
                                    case 8:
                                      {
                                        tamanho = movimento.movimentoItem[index].produto.grade.t8;
                                      }
                                      break;
                                    case 9:
                                      {
                                        tamanho = movimento.movimentoItem[index].produto.grade.t9;
                                      }
                                      break;
                                    case 10:
                                      {
                                        tamanho = movimento.movimentoItem[index].produto.grade.t10;
                                      }
                                      break;
                                    case 11:
                                      {
                                        tamanho = movimento.movimentoItem[index].produto.grade.t11;
                                      }
                                      break;
                                    case 12:
                                      {
                                        tamanho = movimento.movimentoItem[index].produto.grade.t12;
                                      }
                                      break;
                                    case 13:
                                      {
                                        tamanho = movimento.movimentoItem[index].produto.grade.t13;
                                      }
                                      break;
                                    case 14:
                                      {
                                        tamanho = movimento.movimentoItem[index].produto.grade.t14;
                                      }
                                      break;
                                    case 15:
                                      {
                                        tamanho = movimento.movimentoItem[index].produto.grade.t15;
                                      }
                                      break;
                                  }

                                  String a = "";
                                  if (tamanho != "") {
                                    a = "Tam: $tamanho";
                                  }

                                  if ((movimento.movimentoItem[index].variante.nome != "")) {
                                    a = a != ""
                                      ? a + " Cor: " + movimento.movimentoItem[index].variante.nome
                                      : movimento.movimentoItem[index].variante.nome;
                                  }
                                  return ListTile(
                                    contentPadding: EdgeInsets.all(1),
                                    key: Key("$index"),
                                    leading: Container(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Container(
                                            width: 230,
                                            child: AutoSizeText(
                                              "${movimento.movimentoItem[index].produto.nome}",
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: Theme.of(context).textTheme.title.fontSize,
                                                fontStyle: Theme.of(context).textTheme.title.fontStyle
                                              ),
                                              minFontSize: 13,
                                              maxLines: 1,
                                            ),
                                          ),
                                          // Text(
                                          //   "${movimento.movimentoItem[index].produto.nome}",
                                          //   style: TextStyle(
                                          //     color: Colors.black,
                                          //     fontSize: Theme.of(context).textTheme.title.fontSize,
                                          //     fontStyle: Theme.of(context).textTheme.title.fontStyle
                                          //   ),
                                          // ),
                                          Expanded(
                                            child: Text("$a",
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: Theme.of(context).textTheme.body2.fontSize,
                                                fontStyle: Theme.of(context).textTheme.body2.fontStyle
                                              ),
                                            ),
                                          ),
                                        ],
                                      )
                                    ),
                                    trailing: Container(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        children: <Widget>[
                                          Text("${movimento.movimentoItem[index].quantidade.round()}x  ${precoVendido.text}",
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: Theme.of(context).textTheme.body2.fontSize,
                                              fontStyle: Theme.of(context).textTheme.body2.fontStyle
                                            ),
                                          ),
                                          Text("${totalLiquido.text}",
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: Theme.of(context).textTheme.subhead.fontSize,
                                              fontStyle: Theme.of(context).textTheme.subhead.fontStyle,
                                              fontWeight: FontWeight.w600
                                            ),
                                          ),
                                          Text(movimento.movimentoItem[index].totalDesconto == 0.0
                                            ? ""
                                            : "Desconto ${totalDesconto.text}",
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: Theme.of(context).textTheme.body2.fontSize,
                                              fontStyle: Theme.of(context).textTheme.body2.fontStyle
                                            ),
                                          ),
                                        ],
                                      )
                                    ),
                                  );
                                }
                              ),
                              Divider(
                                color: Colors.black,
                              ),
                              ListTile(
                                contentPadding: EdgeInsets.all(1),
                                title: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: <Widget>[
                                    Text("Total Bruto",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: Theme.of(context).textTheme.body2.fontSize,
                                        fontStyle: Theme.of(context).textTheme.body2.fontStyle
                                      ),
                                    ),
                                    Text("Desconto",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: Theme.of(context).textTheme.body2.fontSize,
                                        fontStyle: Theme.of(context).textTheme.body2.fontStyle
                                      ),
                                    ),
                                    Text("Total Líquido",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: Theme.of(context).textTheme.body2.fontSize,
                                        fontStyle: Theme.of(context).textTheme.body2.fontStyle
                                      ),
                                    ),
                                  ],
                                ),
                                trailing: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: <Widget>[
                                    Expanded(
                                      child: Text("${valorTotalBruto.text}",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: Theme.of(context).textTheme.subhead.fontSize,
                                          fontStyle: Theme.of(context).textTheme.subhead.fontStyle,
                                          fontWeight: FontWeight.w600
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        "${valorTotalDesconto.text}",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: Theme.of(context).textTheme.body2.fontSize,
                                          fontStyle: Theme.of(context).textTheme.body2.fontStyle
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        "${valorTotalLiquido.text}",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: Theme.of(context).textTheme.body2.fontSize,
                                          fontStyle: Theme.of(context).textTheme.body2.fontStyle
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Divider(
                                color: Colors.black,
                              )
                            ],
                          );
                        }
                      ),
                    ),
                    RotatedBox(
                      quarterTurns: 2,
                      child:ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.asset('assets/reciboHeader.png',
                          fit: BoxFit.fitWidth,
                          width: double.infinity,
                          height: 9,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (integer) {
          shareFunction();
        },
        backgroundColor: Theme.of(context).primaryColor,
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.email,
              size: 20,
              color: Colors.white,
            ),
            title: Text("E-mail", style: TextStyle(color: Colors.white),),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.message,
              size: 20,
              color: Colors.white,
            ),
            title: Text("WhatsApp",),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.send,
              size: 20,
              color: Colors.white,
            ),
            title: Text("SMS",),
          ),
        ]
      )
    );
  }
}
