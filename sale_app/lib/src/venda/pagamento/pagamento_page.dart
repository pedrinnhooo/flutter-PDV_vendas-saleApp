import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:common_files/common_files.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:fluggy/src/AppConfig.dart';
import 'package:fluggy/src/app_module.dart';
import 'package:fluggy/src/venda/pagamento/pagamento_bloc.dart';
import 'package:fluggy/src/venda/pagamento/pagamento_desconto/pagamento_desconto_module.dart';
import 'package:fluggy/src/venda/pagamento/pagamento_valor/pagamento_valor_page.dart';
import 'package:fluggy/src/venda/recibo/recibo_page.dart';
import 'package:fluggy/src/venda/venda_bloc.dart';
import 'package:fluggy/src/venda/venda_module.dart';

class PagamentoPage extends StatefulWidget {
  @override
  _PagamentoPageState createState() => _PagamentoPageState();
}

class _PagamentoPageState extends State<PagamentoPage> {
  PageController pageController;
  PagamentoBloc pagamentoBloc;
  SharedVendaBloc vendaBloc;
  SincronizacaoBloc sincBloc;
  AppGlobalBloc appGlobalBloc;
  BuildContext myContext;
  GlobalKey botaoDinheiro = GlobalKey();
  GlobalKey botaoDebito = GlobalKey();
  GlobalKey botaoCredito = GlobalKey();
  GlobalKey botaoFinalizarVenda = GlobalKey();
  GlobalKey conferirValoresVenda = GlobalKey();
  GlobalKey conferirFormasPagamento = GlobalKey();
  GlobalKey salvarPedido = GlobalKey();
  GlobalKey descontoPedido = GlobalKey();
  GlobalKey debitolista = GlobalKey();

  @override
  void initState() {
   super.initState();
    pageController = VendaModule.to.bloc<VendaBloc>().pageController;
    pagamentoBloc = PagamentoBloc();
    vendaBloc = AppModule.to.getBloc<SharedVendaBloc>();
    sincBloc = AppModule.to.getBloc<SincronizacaoBloc>();
    appGlobalBloc = AppModule.to.getBloc<AppGlobalBloc>();
    vendaBloc.getallTipoPagamentos();
    // if (vendaBloc.tutorial != null) {
    //   if (vendaBloc.tutorial.passo == 4) {
    //     WidgetsBinding.instance.addPostFrameCallback((_) =>
    //       ShowCaseWidget.of(myContext).startShowCase([conferirValoresVenda]));
    //   } else if (vendaBloc.tutorial.passo == 10) {
    //     WidgetsBinding.instance.addPostFrameCallback((_) =>
    //       ShowCaseWidget.of(myContext).startShowCase([botaoDebito]));
    //   }
    // }
  }

  @override
  Widget build(BuildContext context) {
    AppConfig().init(context);

    Future _initRequester() async {
      return vendaBloc.getallMovimento();
    }

    Future<List> _dataRequester() async {
      return Future.delayed(Duration(milliseconds: 100), () async {
        return await vendaBloc.getallMovimento();
      });
    }

    Function _gridItemBuilder = (List dataList, BuildContext context, int index) {
      List<TipoPagamento> tipoPagamentoList = dataList;

      // if(vendaBloc.tutorial != null){
      //   if (index == 0) {
      //     return Showcase.withWidget(
      //       key: botaoDinheiro,
      //       disposeOnTap: false,
      //       disableAnimation: true,
      //       width: 200,
      //       height: 200,
      //       container: Column(
      //         children: <Widget>[
      //           Row(
      //             children: <Widget>[
      //               Image.asset("assets/setaCategoria.png", width: 60),
      //               Image.asset("assets/mascote.png", width: 60),
      //             ],
      //           ),
      //           SizedBox(height: 15),
      //           Row(
      //             children: <Widget>[
      //               Text("Para prosseguir selecione\na forma de dinheiro", 
      //                 style: TextStyle(color: Colors.white, fontSize: 16), textAlign: TextAlign.center),
      //             ],
      //           ),
      //         ],
      //       ),
      //       onTargetClick: () async {
      //         await vendaBloc.setTutorialPasso(5);
      //         if (vendaBloc.movimento.valorRestante != 0) {
      //           vendaBloc.addMovimentoParcela(tipoPagamentoList[index], vendaBloc.movimento.valorRestante);
      //         }
      //         WidgetsBinding.instance.addPostFrameCallback((_) =>
      //           ShowCaseWidget.of(myContext).startShowCase([botaoFinalizarVenda]));
      //       },
      //       child: InkWell(
      //         child: Padding(
      //           padding: const EdgeInsets.only(left: 3.0, right: 3.0, bottom: 5),
      //             child: Container(
      //           padding: EdgeInsets.all(8),
      //             decoration: BoxDecoration(
      //               color: Theme.of(context).accentColor,
      //               borderRadius: BorderRadius.circular(9),),
      //             child: Center(
      //               child: Column(
      //                 mainAxisAlignment: MainAxisAlignment.spaceAround,
      //                 children: <Widget>[
      //                   Row(
      //                     mainAxisAlignment: MainAxisAlignment.center,
      //                     children: <Widget>[
      //                       Hero(
      //                         tag: "${tipoPagamentoList[index].id}",
      //                         child: StreamBuilder(
      //                           stream: readBase64Image("/images/tipoPagamento/${tipoPagamentoList[index].idPessoaGrupo}/${tipoPagamentoList[index].id}.txt").asStream().asBroadcastStream(),
      //                           builder: (context, snapshot) {
      //                             if(snapshot.data == null || !snapshot.hasData){
      //                               return Center(child: CircularProgressIndicator());
      //                             } 
      //                             return ClipRRect(
      //                               borderRadius: BorderRadius.circular(8),
      //                               child: Image.memory(base64Decode(snapshot.data),
      //                                 fit: BoxFit.contain, 
      //                                 color: Colors.white,
      //                                 width: 50,
      //                                 height: 50,
      //                               ),
      //                             );
      //                           }
      //                         )
      //                       )
      //                     ],
      //                   ),
      //                   Container(
      //                     alignment: Alignment.center,
      //                     width: 80,
      //                     child: AutoSizeText(
      //                       tipoPagamentoList[index].nome.toString(),
      //                       style: Theme.of(context).textTheme.body2,
      //                       maxFontSize: Theme.of(context).textTheme.body2.fontSize,
      //                       minFontSize: 8,
      //                       maxLines: 1,
      //                     ),
      //                   )
      //                 ],
      //               ),
      //             )
      //           ),
      //         ),
      //       ),
      //     );
      //   }

      //   if (index == 1) {
      //     return Showcase.withWidget(
      //       key: botaoDebito,
      //       disposeOnTap: false,
      //       disableAnimation: true,
      //       width: 200,
      //       height: 200,
      //       container: Padding(
      //         padding: const EdgeInsets.only(left: 25),
      //         child: Column(
      //           children: <Widget>[
      //             SizedBox(height: 15),
      //             Row(
      //               children: <Widget>[
      //                 Image.asset("assets/mascote.png", width: 60),
      //                 Padding(
      //                   padding: const EdgeInsets.only(left: 15),
      //                   child: Image.asset("assets/setaCategoria.png", width: 60),
      //                 )
      //               ],
      //             ),
      //             SizedBox(height: 15),
      //             Row(
      //               children: <Widget>[
      //                 Text("Segure pressionado a forma\nde pagamento débito", 
      //                   style: TextStyle(color: Colors.white, fontSize: 16), textAlign: TextAlign.center),
      //               ],
      //             ),
      //           ],
      //         ),
      //       ),
      //       onLongPress: () async {
      //         if (vendaBloc.movimento.valorRestante > 0) {
      //           var moneyMask = MoneyMaskedTextController();
      //           moneyMask.updateValue(vendaBloc.movimento.valorRestante);
      //         ShowCaseWidget.of(context).dismiss();
      //         await vendaBloc.setTutorialPasso(11); 
      //           Navigator.push(context,
      //             PageRouteBuilder(
      //               opaque: false,
      //               settings: RouteSettings(name: '/PagamentoValor'),
      //               pageBuilder: (BuildContext context, _, __) {
      //                 return PagamentoValorPage(
      //                   tipoPagamento: tipoPagamentoList[index],
      //                   valorRestante: moneyMask.text);
      //                 },
      //               transitionsBuilder: (__, Animation<double> animation, ___, Widget child) {
      //                 return FadeTransition(
      //                   opacity: animation,
      //                   child: child,
      //                 );
      //               }
      //             )
      //           ).then((_) {
      //             setState(() {
      //               ShowCaseWidget.of(context).startShowCase([debitolista]);
      //             });
      //           });
      //         }
      //       },
      //       child: InkWell(
      //         child: Padding(
      //           padding: const EdgeInsets.only(left: 3.0, right: 3.0, bottom: 5),
      //             child: Container(
      //           padding: EdgeInsets.all(8),
      //             decoration: BoxDecoration(
      //               color: Theme.of(context).accentColor,
      //               borderRadius: BorderRadius.circular(9),),
      //             child: Center(
      //               child: Column(
      //                 mainAxisAlignment: MainAxisAlignment.spaceAround,
      //                 children: <Widget>[
      //                   Row(
      //                     mainAxisAlignment: MainAxisAlignment.center,
      //                     children: <Widget>[
      //                       Hero(
      //                         tag: "${tipoPagamentoList[index].id}",
      //                         child: StreamBuilder(
      //                           stream: readBase64Image("/images/tipoPagamento/${tipoPagamentoList[index].idPessoaGrupo}/${tipoPagamentoList[index].id}.txt").asStream().asBroadcastStream(),
      //                           builder: (context, snapshot) {
      //                             if(snapshot.data == null || !snapshot.hasData){
      //                               return Center(child: CircularProgressIndicator());
      //                             } 
      //                             return ClipRRect(
      //                               borderRadius: BorderRadius.circular(8),
      //                               child: Image.memory(base64Decode(snapshot.data),
      //                                 fit: BoxFit.contain, 
      //                                 color: Colors.white,
      //                                 width: 50,
      //                                 height: 50,
      //                               ),
      //                             );
      //                           }
      //                         )
      //                       )
      //                     ],
      //                   ),
      //                   Container(
      //                     alignment: Alignment.center,
      //                     width: 80,
      //                     child: AutoSizeText(
      //                       tipoPagamentoList[index].nome.toString(),
      //                       style: Theme.of(context).textTheme.body2,
      //                       maxFontSize: Theme.of(context).textTheme.body2.fontSize,
      //                       minFontSize: 8,
      //                       maxLines: 1,
      //                     ),
      //                   )
      //                 ],
      //               ),
      //             )
      //           ),
      //         ),
      //       ),
      //     );
      //   }
        
      //   if (index == 2) {
      //     return Showcase.withWidget(
      //       key: botaoCredito,
      //       disposeOnTap: false,
      //       disableAnimation: true,
      //       width: 200,
      //       height: 200,
      //       container: Padding(
      //         padding: const EdgeInsets.only(left: 8.0, top: 12),
      //         child: Column(
      //           children: <Widget>[
      //             Row(
      //               children: <Widget>[
      //                 Padding(
      //                   padding: const EdgeInsets.only(left: 30),
      //                   child: Image.asset("assets/mascote.png", width: 60),
      //                 ),
      //                 Image.asset("assets/setaCategoria.png", width: 60),
      //               ],
      //             ),
      //             SizedBox(height: 15),
      //             Row(
      //               children: <Widget>[
      //                 Text("Para prosseguir selecione\na forma de crédito", 
      //                   style: TextStyle(color: Colors.white, fontSize: 16), textAlign: TextAlign.center),
      //               ],
      //             ),
      //           ],
      //         ),
      //       ),
      //       onTargetClick: () async {
      //         if (vendaBloc.movimento.valorRestante != 0) {
      //           vendaBloc.addMovimentoParcela(tipoPagamentoList[index], vendaBloc.movimento.valorRestante);
      //           await vendaBloc.setTutorialPasso(17);
      //           WidgetsBinding.instance.addPostFrameCallback((_) =>
      //             ShowCaseWidget.of(myContext).startShowCase([botaoFinalizarVenda]));
      //         }
      //       },
      //       child: InkWell(
      //         child: Padding(
      //           padding: const EdgeInsets.only(left: 3.0, right: 3.0, bottom: 5),
      //             child: Container(
      //           padding: EdgeInsets.all(8),
      //             decoration: BoxDecoration(
      //               color: Theme.of(context).accentColor,
      //               borderRadius: BorderRadius.circular(9),),
      //             child: Center(
      //               child: Column(
      //                 mainAxisAlignment: MainAxisAlignment.spaceAround,
      //                 children: <Widget>[
      //                   Row(
      //                     mainAxisAlignment: MainAxisAlignment.center,
      //                     children: <Widget>[
      //                       Hero(
      //                         tag: "${tipoPagamentoList[index].id}",
      //                         child:StreamBuilder(
      //                           stream: readBase64Image("/images/tipoPagamento/${tipoPagamentoList[index].idPessoaGrupo}/${tipoPagamentoList[index].id}.txt").asStream().asBroadcastStream(),
      //                           builder: (context, snapshot) {
      //                             if(snapshot.data == null || !snapshot.hasData){
      //                               return Center(child: CircularProgressIndicator());
      //                             } 
      //                             return ClipRRect(
      //                               borderRadius: BorderRadius.circular(8),
      //                               child: Image.memory(base64Decode(snapshot.data),
      //                                 fit: BoxFit.contain, 
      //                                 color: Colors.white,
      //                                 width: 50,
      //                                 height: 50,
      //                               ),
      //                             );
      //                           }
      //                         )
      //                       )
      //                     ],
      //                   ),
      //                   Container(
      //                     alignment: Alignment.center,
      //                     width: 80,
      //                     child: AutoSizeText(
      //                       tipoPagamentoList[index].nome.toString(),
      //                       style: Theme.of(context).textTheme.body2,
      //                       maxFontSize: Theme.of(context).textTheme.body2.fontSize,
      //                       minFontSize: 8,
      //                       maxLines: 1,
      //                     ),
      //                   )
      //                 ],
      //               ),
      //             )
      //           ),
      //         ),
      //       ),
      //     );
      //   }
      // }

      return InkWell(
        child: Padding(
          padding: const EdgeInsets.only(left: 3.0, right: 3.0, bottom: 5),
          child: Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Theme.of(context).accentColor,
              borderRadius: BorderRadius.circular(9),),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Hero(
                        tag: "${tipoPagamentoList[index].id}",
                        child: FutureBuilder<String>(
                          future: readBase64Image("/images/tipoPagamento/${tipoPagamentoList[index].idPessoaGrupo}/${tipoPagamentoList[index].id}.txt"),
                          builder: (context, snapshot){
                            return AnimatedOpacity(
                              duration: Duration(milliseconds: 200),
                              opacity: snapshot.hasData ? 1.0 : 0.0,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: snapshot.hasData ? Image.memory(base64Decode(snapshot.data),
                                  gaplessPlayback: true,
                                  fit: BoxFit.contain, 
                                  color: Colors.white,
                                  width: 50,
                                  height: 50,
                                ) : SizedBox.shrink(),
                              )
                            );
                          },
                        )
                      )
                    ],
                  ),
                  Container(
                    alignment: Alignment.center,
                    width: 80,
                    child: AutoSizeText(
                      tipoPagamentoList[index].nome.toString(),
                      style: Theme.of(context).textTheme.body2,
                      maxFontSize: Theme.of(context).textTheme.body2.fontSize,
                      minFontSize: 8,
                      maxLines: 1,
                    ),
                  )
                ],
              ),
            )
          ),
        ),
        onLongPress: () {
          if (vendaBloc.movimento.valorRestante > 0) {
            var moneyMask = MoneyMaskedTextController();
            moneyMask.updateValue(vendaBloc.movimento.valorRestante);

            Navigator.push(context,
              PageRouteBuilder(
                opaque: false,
                settings: RouteSettings(name: '/PagamentoValor'),
                pageBuilder: (BuildContext context, _, __) {
                  return PagamentoValorPage(
                    tipoPagamento: tipoPagamentoList[index],
                    valorRestante: moneyMask.text);
                  },
                transitionsBuilder: (__, Animation<double> animation, ___, Widget child) {
                  return FadeTransition(
                    opacity: animation,
                    child: child,
                  );
                }
              )
            );
          }
        },
        onTap: () async {
          if (vendaBloc.movimento.valorRestante != 0) {
            if(tipoPagamentoList[index].nome == "QrCode") {
              if ( appGlobalBloc.terminal.temPicpay != null) {
                vendaBloc.addMovimentoParcela(tipoPagamentoList[index], vendaBloc.movimento.valorRestante);
              } else {
                showDialog(
                  barrierDismissible: false,
                  context: context,
                  child: AlertDialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)
                    ),
                    title: Text("Escolha sua forma de pagamento",style: TextStyle(color: Colors.black, fontSize: 16)),
                    content: Padding(
                      padding: const EdgeInsets.only(top: 20, bottom: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          InkWell(
                            onTap: appGlobalBloc.terminal.mercadopagoQrCode != null ? () async {
                             await vendaBloc.mercadopagoOrdemdePagamento(); 
                              showDialog(
                                context: context,
                                child: AlertDialog(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)
                                  ),
                                  title: Column(
                                    children: <Widget>[
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: <Widget>[
                                          Image.asset("assets/mercadopago.png", width:80,),
                                        ],
                                      ),
                                      SizedBox(height: 15),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: <Widget>[
                                          Container(
                                            width: 230,
                                            child: AutoSizeText(
                                              "Escaneie o QrCode com o seu celular", 
                                                style: TextStyle(color: Colors.grey, fontSize: 16),
                                              maxFontSize: 16,
                                              minFontSize: 14,
                                            )
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                  content: Padding(
                                    padding: const EdgeInsets.only(top: 20,bottom: 20),
                                    child: Container(
                                      width: 170,
                                      height: 170, 
                                      child: Image.network("https://www.mercadopago.com/instore/merchant/qr/7074752/33282767a3924220841a2a8df8441e9c78c072d6dcfc41b38a178778d79642da.png")
                                    ),
                                  ),

                                  // Image.network("${appGlobalBloc.terminal.mercadopagoQrCode}");
                                  actions: <Widget>[
                                    SizedBox(
                                    height: 40,
                                    width: 500,
                                    child: FlatButton(
                                        child: Text("Cancelar", style: TextStyle(color: Colors.white)),
                                        color: Colors.blue[400],
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(8)
                                        ), 
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                      ),
                                    )
                                  ],
                                )
                              );
                            } : () {},
                            child: appGlobalBloc.terminal.mercadopagoQrCode != null ?
                            Container(
                              padding: EdgeInsets.all(15),
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(10)
                              ),
                              child: Image.asset("assets/mercadopago.png", width: 70)
                            ) :
                            Container(
                              padding: EdgeInsets.all(15),
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(10)
                              ),
                              child: Image.asset("assets/logomercadopagocinza.png", width: 70)
                            )
                          ),
                          InkWell(
                            onTap: appGlobalBloc.terminal.temPicpay != 1 ? () async {
                              showDialog(
                                context: context,
                                child: AlertDialog(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)
                                  ),
                                  title: Column(
                                    children: <Widget>[
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: <Widget>[
                                          Image.asset("assets/logopicpay.png", width: 130),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: <Widget>[
                                          Container(
                                            width: 230,
                                            child: AutoSizeText(
                                              "Escaneie o QrCode com o seu celular", 
                                                style: TextStyle(color: Colors.grey, fontSize: 16),
                                              maxFontSize: 16,
                                              minFontSize: 14,
                                            )
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                  content: FutureBuilder(
                                    future: vendaBloc.picpayOrdemdePagamento(),
                                    builder: (context, snapshot) {
                                      if (!snapshot.hasData) {
                                        return SizedBox(
                                          width: 50,
                                          height: 50,
                                          child: Center(
                                            child: CircularProgressIndicator(
                                              backgroundColor: Colors.greenAccent,
                                              strokeWidth: 4.0,
                                            ),
                                          ),
                                        );
                                      }
                                      return Image.memory(base64.decode("${snapshot.data}"
                                      .replaceAll("data:image/png;base64,", "")));
                                    }
                                  ),  
                                  actions: <Widget>[
                                    SizedBox(
                                    height: 40,
                                    width: 500,
                                    child: FlatButton(
                                        child: Text("Cancelar", style: TextStyle(color: Colors.white)),
                                        color: Colors.greenAccent[400],
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(8)
                                        ), 
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                      ),
                                    )
                                  ],
                                )
                              );
                            } : () {},
                            child: appGlobalBloc.terminal.temPicpay == 1 ?
                            Container(
                              padding: EdgeInsets.all(5),
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(10)
                              ),
                              child:Image.asset("assets/logopicpay.png", width: 115)
                            ) :
                            Container(
                              padding: EdgeInsets.all(5),
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(10)
                              ),
                              child: Image.asset("assets/logopicpay.png", color: Colors.grey[600], width: 115), 
                            )
                          ),
                        ],
                      ),
                    ),
                    actions: <Widget>[
                      SizedBox(
                        height: 40,
                        width: 500,
                        child: FlatButton(
                          child: Text("Cancelar", style: TextStyle(color: Colors.white)),
                          color: Theme.of(context).primaryIconTheme.color,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)
                          ), 
                          onPressed: () async {
                            Navigator.pop(context);
                          },
                        ),
                      )
                    ],
                  )
                );
              }
            } else { 
              vendaBloc.addMovimentoParcela(tipoPagamentoList[index], vendaBloc.movimento.valorRestante);
            }
          } else {
            pageController.animateToPage(0, curve: Interval(0.2, 0.5, curve: Curves.fastOutSlowIn), 
              duration: Duration(milliseconds: 300));
            vendaBloc.saveVenda(0);
            await sincBloc.sincronizacaoLambda.stop();
            sincBloc.sincronizacaoLambda.start();
            Navigator.push(context,
              PageRouteBuilder(
                opaque: false,
                settings: RouteSettings(name: '/Recibo'),
                pageBuilder: (BuildContext context, _, __) {
                  return ReciboPage(
                    icon: Icon(
                      Icons.check_circle_outline,
                      size: 100,
                      color: Colors.white,
                    ),
                    message: "Venda concluída",
                    value: vendaBloc.movimento.valorRestante,
                  );
                },
              )
            );
          }
        }
      );
    };

    return ShowCaseWidget(
      builder: Builder(
        builder: (context) {
          myContext = context;
          return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            // Showcase.withWidget(
            //   key: conferirValoresVenda,
            //   disposeOnTap: false,
            //   disableAnimation: true,
            //     width: 200,
            //     height: 200,
            //     container: Column(
            //       children: <Widget>[
            //         Row(
            //           children: <Widget>[
            //             Image.asset("assets/setaTrilha.png", width: 40)
            //           ],
            //         ),
            //         SizedBox(height: 15),
            //         Row(
            //           children: <Widget>[
            //             Image.asset("assets/mascote.png", width: 60),
            //           ],
            //         ),
            //         SizedBox(height: 15),
            //         Row(
            //           children: <Widget>[
            //             Text("Confira os Valores\nda venda", 
            //               style: TextStyle(color: Colors.white, fontSize: 16), textAlign: TextAlign.center),
            //           ],
            //         ),
            //         SizedBox(height: 15),
            //         SizedBox(
            //           width: 150,
            //           height: 40,
            //           child: FlatButton(
            //             shape: RoundedRectangleBorder(
            //               borderRadius: BorderRadius.circular(8)
            //             ),
            //             onPressed: () async {
            //               WidgetsBinding.instance.addPostFrameCallback((_) =>
            //                 ShowCaseWidget.of(myContext).startShowCase([descontoPedido]));
            //             }, 
            //             child: Text("Entendi", style: TextStyle(color: Colors.white)),
            //             color: Theme.of(context).primaryIconTheme.color,
            //           ),
            //         ),
            //       ],
            //     ),
            //     child:
             StreamBuilder<Movimento>(
                  initialData: Movimento(),
                  stream: vendaBloc.movimentoOut,
                  builder: (context, snapshot) {
                    Movimento movimento = snapshot.data;
                    var valorTroco = MoneyMaskedTextController();
                    var valorTotalDesconto = MoneyMaskedTextController(leftSymbol: "R\$ ");
                    var valorRestante = MoneyMaskedTextController();
                    valorTroco.updateValue(movimento.valorTroco);
                    valorRestante.updateValue(movimento.valorRestante);
                    valorTotalDesconto.updateValue(movimento.valorTotalDesconto);

                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        InkWell(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(movimento.valorRestante >= 0 ?
                                "R\$ " :
                                "-R\$ ",
                                style: TextStyle(
                                  fontSize: AppConfig.safeBlockHorizontal * 5,
                                  color: movimento.valorRestante >= 0 ? 
                                    Theme.of(context).textTheme.subhead.color :
                                    Colors.red
                                ),
                              ),
                              Container(
                                width: 200,
                                child: AutoSizeText(
                                  "${valorRestante.text}",
                                  style: Theme.of(context).textTheme.display2,
                                  textAlign: TextAlign.center,
                                  presetFontSizes: [Theme.of(context).textTheme.display2.fontSize, 38, 28, 18, 8],
                                  maxLines: 1,
                                  ),
                                ),
                              ]
                            ),
                            onLongPress: () {
                              vendaBloc.removeDescontoMovimento();
                            },
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: <Widget>[
                                Text(
                                  "Desconto: ${valorTotalDesconto.text}",
                                  style: movimento.valorTotalDesconto > 0 
                                        ? Theme.of(context).textTheme.title
                                        : Theme.of(context).textTheme.title
                                ),
                                Text(
                                  "Troco: R\$ ${valorTroco.text}",
                                  style: Theme.of(context).textTheme.title
                                )
                              ],
                            ),
                          ),
                        ],
                      );
                    }
                  ),
                // ),
              Expanded(
                child: StreamBuilder<Movimento>(
                  stream: vendaBloc.movimentoOut,
                  initialData: Movimento(),
                  builder: (context, snapshot) {
                    if (snapshot.data.movimentoParcela.length > 0) {
                      return ListView.builder(
                      itemCount: snapshot.data.movimentoParcela.length,
                      itemBuilder: (BuildContext context, int index) {
                        var moneyMask = MoneyMaskedTextController(leftSymbol: "R\$ ");
                        moneyMask.updateValue(snapshot.data.movimentoParcela[index].valor);

                        // if(vendaBloc.tutorial != null){
                        //   if (index == 0) {
                        //     return Showcase.withWidget(
                        //       key: debitolista,
                        //       disposeOnTap: false,
                        //       disableAnimation: true,
                        //       width: 200,
                        //       height: 200,
                        //       container: Column(
                        //         children: <Widget>[
                        //           SizedBox(height: 15),
                        //           Row(
                        //             children: <Widget>[
                        //               Image.asset("assets/setaTrilha.png", width: 40)
                        //             ],
                        //           ),
                        //           SizedBox(height: 15),
                        //           Row(
                        //             children: <Widget>[
                        //               Image.asset("assets/mascote.png", width: 60),
                        //             ],
                        //           ),
                        //           SizedBox(height: 15),
                        //           Row(
                        //             children: <Widget>[
                        //               Text("Aqui a forma débito foi\nadicionado na lista ", 
                        //                 style: TextStyle(color: Colors.white,fontSize: 16), textAlign: TextAlign.center)
                        //             ],
                        //           ),
                        //           SizedBox(height: 15),
                        //           SizedBox(
                        //             width: 150,
                        //             height: 40,
                        //             child: FlatButton(
                        //               shape: RoundedRectangleBorder(
                        //                 borderRadius: BorderRadius.circular(8)
                        //               ),
                        //               onPressed: () async {
                        //                 WidgetsBinding.instance.addPostFrameCallback((_) =>
                        //                   ShowCaseWidget.of(myContext).startShowCase([botaoCredito]));
                        //               }, 
                        //               child: Text("Entendi", style: TextStyle(color: Colors.white)),
                        //               color: Theme.of(context).primaryIconTheme.color,
                        //             ),
                        //           ),
                        //         ],
                        //       ),
                        //       child: Container(
                        //         decoration: BoxDecoration(
                        //           color: Theme.of(context).accentColor,
                        //           borderRadius: BorderRadius.circular(8)
                        //         ),
                        //         child: ListTile(
                        //           dense: true,
                        //           key: Key("listTile[$index]"),
                        //           title: Text(
                        //               "${snapshot.data.movimentoParcela[index].tipoPagamento.nome}", style: Theme.of(context).textTheme.body2),
                        //           trailing: Text(snapshot.data.movimentoParcela[index].valor > 0 
                        //             ? "${moneyMask.text}" 
                        //             : "-${moneyMask.text}",
                        //             style: snapshot.data.movimentoParcela[index].valor > 0 ? 
                        //                 Theme.of(context).textTheme.body2 : 
                        //                 Colors.red),
                        //         ),
                        //       ),
                        //     );
                        //   }
                        // }

                        return Slidable(
                          actionPane: SlidableDrawerActionPane(),
                          actionExtentRatio: 0.25,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 3, bottom: 3, left: 6, right: 6),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(width: 2, color: Theme.of(context).accentColor,),
                              ),
                              child: ListTile(
                                dense: true,
                                key: Key("listTile[$index]"),
                                leading: FutureBuilder<String>(
                                  future: readBase64Image("/images/tipoPagamento/${snapshot.data.movimentoParcela[index].tipoPagamento.idPessoaGrupo}/${snapshot.data.movimentoParcela[index].tipoPagamento.id}.txt"),
                                  builder: (context, snapshot){
                                    return AnimatedOpacity(
                                      duration: Duration(milliseconds: 200),
                                      opacity: snapshot.hasData ? 1.0 : 0.0,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: snapshot.hasData ? Image.memory(base64Decode(snapshot.data),
                                          gaplessPlayback: true,
                                          fit: BoxFit.contain, 
                                          color: Colors.white,
                                          width: 35,
                                          height: 35,
                                        ) : SizedBox.shrink(),
                                      )
                                    );
                                  }
                                ),
                                title: Text(
                                    "${snapshot.data.movimentoParcela[index].tipoPagamento.nome}", style: Theme.of(context).textTheme.body2),
                                trailing: Text(snapshot.data.movimentoParcela[index].valor > 0 
                                  ? "${moneyMask.text}" 
                                  : "-${moneyMask.text}",
                                  style: snapshot.data.movimentoParcela[index].valor > 0 ? 
                                      Theme.of(context).textTheme.body2 : 
                                      Colors.red
                                ),
                              ),
                            ),
                          ),
                          secondaryActions: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0, bottom: 8.0, right: 8),
                              child: Container(
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(8)),
                              child: IconSlideAction(
                                caption: 'Excluir',
                                icon: Icons.delete,
                                color: Colors.transparent,
                                onTap: () {
                                  vendaBloc.removeMovimentoParcela(index);
                                  if (vendaBloc.movimento.movimentoParcela.length == 0) {}
                                },
                              ),
                            ),
                          ),
                        ],
                      );
                    }
                  );
                }
                return Container(
                  padding: EdgeInsets.all(AppConfig.blockSizeHorizontal * 4),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                          child: Showcase.withWidget(
                            key: salvarPedido,
                            disposeOnTap: false,
                            disableAnimation: true,
                            width: 200,
                            height: 200,
                            container: Column(
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Image.asset("assets/setaTrilha.png", width: 40)
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
                                    Text("Aqui você pode salvar seu pedido", 
                                      style: TextStyle(color: Colors.white, fontSize: 16)),
                                  ],
                                ),
                                SizedBox(height: 15),
                                SizedBox(
                                  width: 150,
                                  height: 40,
                                  child: FlatButton(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8)
                                    ),
                                    onPressed: () async {
                                      WidgetsBinding.instance.addPostFrameCallback((_) =>
                                        ShowCaseWidget.of(myContext).startShowCase([conferirFormasPagamento]));
                                    }, 
                                    child: Text("Entendi", style: TextStyle(color: Colors.white)),
                                    color: Theme.of(context).primaryIconTheme.color,
                                  ),
                                ),
                              ],
                            ),
                            child: FlatButton(
                              child: Container(
                                height: 80,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Image.asset(
                                      'assets/caixaIcon.png',
                                      fit: BoxFit.contain,
                                      height: 30
                                    ),
                                    Text(
                                      "Salvar Pedido",
                                      style: Theme.of(context).textTheme.body2,
                                    ),
                                  ],
                                ),
                              ),
                              textColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                side: BorderSide(
                                  color: Theme.of(context).accentColor,
                                  width: 1,
                                  style: BorderStyle.solid
                                ), 
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(8), 
                                  bottomLeft: Radius.circular(8)
                                )
                              ),
                              onPressed: () async {
                                await vendaBloc.saveVenda(1);
                                await sincBloc.sincronizacaoLambda.stop();
                                      sincBloc.sincronizacaoLambda.start();
                                pageController.animateToPage(0, curve: Interval(0.89, 0.92, curve: Curves.fastOutSlowIn),
                                duration: Duration(milliseconds: 300));
                                Navigator.push(context,
                                  PageRouteBuilder(
                                    settings: RouteSettings(name: '/Recibo'),
                                    pageBuilder:(BuildContext context, _, __) => ReciboPage(
                                      icon: Icon(
                                        Icons.check_circle_outline,
                                        size: 100,
                                        color: Colors.white,
                                      ),
                                      message: "Pedido salvo com sucesso!",
                                    ),
                                    transitionsBuilder: (___, Animation<double> animation, ____, Widget child) => FadeTransition(opacity: animation, child: child,)
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        Expanded(
                          child: Showcase.withWidget(
                            key: descontoPedido,
                            disposeOnTap: false,
                            disableAnimation: true,
                            width: 200,
                            height: 200,
                            container: Column(
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Image.asset("assets/setaCategoria.png", width: 40)
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
                                    Text("Aqui você pode\naplicar desconto", 
                                      style: TextStyle(color: Colors.white, fontSize: 16)),
                                  ],
                                ),
                                SizedBox(height: 15),
                                SizedBox(
                                  width: 150,
                                  height: 40,
                                  child: FlatButton(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8)
                                    ),
                                    onPressed: () async {
                                      WidgetsBinding.instance.addPostFrameCallback((_) =>
                                        ShowCaseWidget.of(myContext).startShowCase([salvarPedido]));
                                    }, 
                                    child: Text("Entendi", style: TextStyle(color: Colors.white)),
                                    color: Theme.of(context).primaryIconTheme.color,
                                  ),
                                ),
                              ],
                            ),
                            child:  FlatButton(
                              child: Container(
                                height: 80,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Image.asset(
                                      'assets/estoqueIcon.png',
                                      fit: BoxFit.contain,
                                      height: 30,
                                    ),
                                    Text("Desconto",
                                      style: Theme.of(context).textTheme.body2,
                                    )
                                  ],
                                ),
                              ),
                              textColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                side: BorderSide(
                                  color: Theme.of(context).accentColor,
                                  width: 1,
                                  style: BorderStyle.solid
                                ), 
                                borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(8), 
                                  bottomRight: Radius.circular(8)
                                )
                              ),
                              onPressed: () async {
                                Navigator.push(context,
                                  PageRouteBuilder(
                                    opaque: false,
                                    settings: RouteSettings(name: '/PagamentoDesconto'),
                                    pageBuilder: (BuildContext context, _, __) {
                                      return PagamentoDescontoModule();
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
                          ),
                        ),
                      ]
                    ),
                  );
                }
              ),
            ),
            Container(
              height: 190,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Showcase.withWidget(
                  key: conferirFormasPagamento,
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
                          Text("Você pode selecionar mais\nde uma forma de\npagamento", 
                            style: TextStyle(color: Colors.white, fontSize: 16), textAlign: TextAlign.center),
                          Padding(
                            padding: const EdgeInsets.only(left: 12),
                            child: Image.asset("assets/setaAdicionarItem.png", width: 40),
                          )
                        ],
                      ),
                      SizedBox(height: 15),
                      SizedBox(
                        width: 150,
                        height: 40,
                        child: FlatButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)
                          ),
                          onPressed: () async {
                            WidgetsBinding.instance.addPostFrameCallback((_) =>
                              ShowCaseWidget.of(myContext).startShowCase([botaoDinheiro]));
                          }, 
                          child: Text("Entendi", style: TextStyle(color: Colors.white)),
                          color: Theme.of(context).primaryIconTheme.color,
                        ),
                      ),
                    ],
                  ),
                  child: DynamicGridView.build(
                    scrollPhysics: vendaBloc.tipoPagamentoList != null ?? vendaBloc.tipoPagamentoList.length <= 6 ? NeverScrollableScrollPhysics() : ClampingScrollPhysics(),
                    bloc: vendaBloc,
                    stream: vendaBloc.tipoPagamentoListOut,
                    initRequester: _initRequester,
                    dataRequester: _dataRequester,
                    gridItemAspectRatio: 1.35,
                    itemBuilder: _gridItemBuilder,
                    initLoadingWidget: Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: CircularProgressIndicator(backgroundColor: Colors.white,),
                    ),
                    moreLoadingWidget: Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: CircularProgressIndicator(backgroundColor: Colors.white,),
                    ),
                  )
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: StreamBuilder<Movimento>(
                initialData: Movimento(),
                stream: vendaBloc.movimentoOut,
                builder: (context, snapshot) {
                  Movimento movimento = snapshot.data;
                  var moneyMask =	MoneyMaskedTextController(leftSymbol: "R\$ ");
                  moneyMask.updateValue(movimento.valorRestante);
                  return Container(
                    padding: EdgeInsets.only(bottom: 10, right: 20, left: 20, top: 5),
                    color: Theme.of(context).primaryColor,
                    child: ButtonTheme(
                      height: 50.0,
                      child: SizedBox(
                        width: double.infinity,
                        child:
                        //  Showcase.withWidget(
                        //   key: botaoFinalizarVenda,
                        //   disposeOnTap: false,
                        //   disableAnimation: true,
                        //   width: 200,
                        //   height: 200,
                        //   container: Padding(
                        //     padding: const EdgeInsets.only(left: 60),
                        //     child: Column(
                        //       children: <Widget>[
                        //         Row(
                        //           children: <Widget>[
                        //             Image.asset("assets/mascote.png", width: 60),
                        //           ],
                        //         ),
                        //         SizedBox(height: 15),
                        //         Row(
                        //           children: <Widget>[
                        //             Text("Clique no botão para\nfinalizar a venda", 
                        //               style: TextStyle(color: Colors.white, fontSize: 16),textAlign: TextAlign.center),
                        //           ],
                        //         ),
                        //         SizedBox(height: 15),
                        //         Row(
                        //           children: <Widget>[
                        //             Image.asset("assets/setaBaixoEsquerda.png", width: 40),
                        //           ],
                        //         ),
                        //       ],
                        //     ),
                        //   ),
                        //   onTargetClick: () async {
                        //     await vendaBloc.setTutorialPasso(vendaBloc.tutorial.passo == 5 ? 6 : 18);
                        //     ShowCaseWidget.of(context).dismiss();
                        //     Navigator.push(context,
                        //       PageRouteBuilder( 
                        //         opaque: false,
                        //         settings: RouteSettings(name: '/Recibo'),
                        //         pageBuilder: (BuildContext context, _, __) {
                        //           return ReciboPage(
                        //             icon: Icon(
                        //               Icons.check_circle_outline,
                        //               size: 100,
                        //               color: Colors.white,
                        //             ),
                        //             message: "Venda concluída",
                        //             value: movimento.valorRestante,
                        //           );
                        //         },
                        //       )
                        //     );
                        //   },
                        //   child:
                         ButtonTheme(
                            height: 45.0,
                            child: RaisedButton(
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              child: Text(
                                movimento.valorRestante == 0
                                  ? "Finalizar"
                                  : movimento.valorRestante > 0 
                                    ? "Restante ${moneyMask.text}" 
                                    : "Restante -${moneyMask.text}",
                                style: Theme.of(context).textTheme.title, 
                              ),
                              color: movimento.valorRestante != 0
                                ? Theme.of(context).accentColor
                                : Theme.of(context).primaryIconTheme.color,
                              onPressed: () async {
                                if (pageController.hasClients) {
                                  if (pageController.page < 2) {
                                    pageController.nextPage(duration: Duration(milliseconds: 600), curve: Curves.fastOutSlowIn);
                                  } else if (pageController.page == 2 && vendaBloc.movimento.valorRestante == 0) {
                                    pageController.animateToPage(0, curve: Interval(0.2, 0.5, curve: Curves.fastOutSlowIn), duration: Duration(milliseconds: 300));
                                    vendaBloc.saveVenda(0);
                                    await sincBloc.sincronizacaoLambda.stop();
                                    sincBloc.sincronizacaoLambda.start();
                                    Navigator.push(context,
                                      PageRouteBuilder(
                                        opaque: false,
                                        settings: RouteSettings(name: '/Recibo'),
                                        pageBuilder: (BuildContext context, _, __) {
                                          return ReciboPage(
                                            icon: Icon(
                                              Icons.check_circle_outline,
                                              size: 100,
                                              color: Colors.white,
                                            ),
                                            message: "Venda concluída",
                                            value: movimento.valorRestante,
                                          );
                                        },
                                      )
                                    );
                                  }
                                }
                              }
                            )
                          // )
                          )
                        ),
                      )
                    );
                  }
                ),
              )
            ],
          );
        }
      )
    );
  }
}
