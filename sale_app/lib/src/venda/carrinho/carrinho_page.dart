import 'dart:convert';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:common_files/common_files.dart';
import 'package:fluggy/src/venda/carrinho/detalhe_item/detalhe_item_page.dart';
import 'package:fluggy/src/venda/carrinho/detalhe_movimento/detalhe_movimento_page.dart';
import 'package:fluggy/src/venda/consulta_venda/consulta_venda_bloc.dart';
import 'package:fluggy/src/venda/consulta_venda/consulta_venda_module.dart';
import 'package:fluggy/src/venda/orcamento/orcamento_page.dart';
import 'package:fluggy/src/venda/pagamento/pagamento_desconto/pagamento_desconto_module.dart';
import 'package:fluggy/src/venda/recibo/recibo_page.dart';
import 'package:fluggy/src/venda/venda_bloc.dart';
import 'package:fluggy/src/venda/venda_module.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/utils.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:fluggy/src/AppConfig.dart';
import 'package:fluggy/src/app_module.dart';
import 'package:fluggy/src/venda/carrinho/desconto_item/desconto_item_module.dart';
import 'package:fluggy/src/venda/carrinho/quantidade_item/quantidade_item_page.dart';
import 'package:fluggy/src/venda/carrinho/valor_item/valor_item_page.dart';
import 'package:fluggy/src/venda/pedido/pedido_page.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path/path.dart' as path_;
import 'package:intl/intl.dart';

class CarrinhoPage extends StatefulWidget {
  @override
  _CarrinhoPageState createState() => _CarrinhoPageState();
}

class _CarrinhoPageState extends State<CarrinhoPage> {
  SharedVendaBloc vendaBloc;
  PageController pageController;
  SincronizacaoBloc sincBloc;
  ConsultaVendaBloc consultaVendaBloc;
  MoneyMaskedTextController precoVendido;
  MoneyMaskedTextController totalLiquido; 
  MoneyMaskedTextController totalDesconto;
  MoneyMaskedTextController valorTotalVendaLiquido;
  BuildContext myContext;
  DateFormat dateFormat;
  DateFormat timeFormat = DateFormat.Hm('pt_BR');
  GlobalKey itemCarrinho = GlobalKey();
  GlobalKey botaoDirecionarPagamento = GlobalKey();
  MoneyMaskedTextController subtotalProduto;
  MoneyMaskedTextController subtotalServico;
  List<Widget> produtoList = []; 
  List<Widget> servicoList = []; 
  final formatCurrency = new NumberFormat.simpleCurrency();

  @override
  void initState() {
    super.initState();
    vendaBloc = AppModule.to.getBloc<SharedVendaBloc>();
    pageController = VendaModule.to.bloc<VendaBloc>().pageController;
    sincBloc = AppModule.to.getBloc<SincronizacaoBloc>();
    consultaVendaBloc = VendaModule.to.getBloc<ConsultaVendaBloc>();
    valorTotalVendaLiquido = MoneyMaskedTextController(leftSymbol: "R\$ ");
    precoVendido = MoneyMaskedTextController(leftSymbol: "R\$ ");
    totalLiquido = MoneyMaskedTextController(leftSymbol: "R\$ ");
    subtotalProduto = MoneyMaskedTextController(leftSymbol: "R\$ ");
    subtotalServico = MoneyMaskedTextController(leftSymbol: "R\$ ");
    totalDesconto = MoneyMaskedTextController();
    dateFormat = DateFormat.Md('pt_BR');
    timeFormat = DateFormat.Hm('pt_BR');
    // if(vendaBloc.tutorial != null){
    //   loadTutorial();
    // }
  }

  // loadTutorial() async {
  //   if (vendaBloc.tutorial.passo == 3) {
  //     WidgetsBinding.instance.addPostFrameCallback((_) =>
  //       ShowCaseWidget.of(myContext).startShowCase([itemCarrinho]));
  //   } else if (vendaBloc.tutorial.passo == 9) {
  //      WidgetsBinding.instance.addPostFrameCallback((_) =>
  //       ShowCaseWidget.of(myContext).startShowCase([botaoDirecionarPagamento]));
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    AppConfig().init(context);
    // return ShowCaseWidget(
    //   builder: Builder(
    //     builder: (context) {
    //       myContext = context;
          return TabBarView(
            children: <Widget>[
              StreamBuilder(
                initialData: Movimento(),
                stream: vendaBloc.movimentoOut,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(child: CircularProgressIndicator());
                  }

                  final Movimento movimento = snapshot.data;

                  if (movimento.movimentoItem.length == 0) {
                    return Column(
                      children: <Widget>[
                        PedidoPage(),
                      ],
                    );
                  } else {
                    var item = movimento.movimentoItem.firstWhere((movItem) => (movItem.ehdeletado == 0), orElse: () => null);
                    if (item == null) {
                      return Column(
                        children: <Widget>[
                          PedidoPage(),
                        ],
                      );
                    }
                  }

                  movimento.movimentoItem.sort((a, b) => a.ehservico.compareTo(b.produto.ehservico));
                  var firstServicoWhere = movimento.movimentoItem.firstWhere((element)=> element.ehservico == 1 && element.ehdeletado == 0, orElse:  () => null);
                  int indexOfFirstServico = movimento.movimentoItem.indexOf(firstServicoWhere);

                  var firstProdutoWhere = movimento.movimentoItem.firstWhere((element)=> element.ehservico == 0 && element.ehdeletado == 0, orElse:  () => null);
                  int indexOfProduto = movimento.movimentoItem.indexOf(firstProdutoWhere);

                  var lastServicoWhere = movimento.movimentoItem.lastWhere((element)=> element.ehservico == 1 && element.ehdeletado == 0, orElse:  () => null);
                  int indexOfLastServico = movimento.movimentoItem.indexOf(lastServicoWhere);

                  return Column(
                    children: <Widget>[ 
                      Expanded(
                        child: ListView.separated(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: movimento.movimentoItem.length,
                        separatorBuilder: (context, index) {
                          if(firstServicoWhere != null){
                            if(index == indexOfFirstServico-1){
                              return Column(
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.only(top: 6, left: 13, right: 13),
                                    child: StreamBuilder<Movimento>(
                                      initialData: Movimento(),
                                      stream: vendaBloc.movimentoOut,
                                      builder: (context, snapshot) {
                                        Movimento movimento = snapshot.data;
                                        subtotalProduto.updateValue(movimento.valorTotalLiquidoProduto);
                                          return Visibility(
                                            visible: firstServicoWhere != null && firstProdutoWhere != null ? true : false,
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: <Widget>[
                                                Text("Subtotal:",style: TextStyle(color: Colors.white)),
                                                Text("${subtotalProduto.text}", style: TextStyle(color: Colors.white)),
                                              ],
                                            ),
                                          );
                                        }
                                    ),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 10, bottom: 4),
                                    child: Visibility(
                                      visible: true,
                                      child: Row(
                                        children: <Widget>[
                                          Text("Serviço",style: Theme.of(context).textTheme.title),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            }
                          }
                          return SizedBox.shrink();
                        },
                        itemBuilder: (context, index) {
                          precoVendido.updateValue(movimento.movimentoItem[index].precoVendido);
                          totalLiquido.updateValue(movimento.movimentoItem[index].totalLiquido);
                          if (movimento.movimentoItem[index].totalDesconto != null) {
                            totalDesconto.updateValue(movimento.movimentoItem[index].totalDesconto);
                          }

                          String tamanho="";
                          switch (movimento.movimentoItem[index].gradePosicao) {
                            case 0: tamanho = "";
                              break;
                            case 1:tamanho = movimento.movimentoItem[index].produto.grade.t1;
                              break; 
                            case 2: tamanho = movimento.movimentoItem[index].produto.grade.t2;
                              break;
                            case 3: tamanho = movimento.movimentoItem[index].produto.grade.t3;
                              break;
                            case 4: tamanho = movimento.movimentoItem[index].produto.grade.t4;
                              break;
                            case 5: tamanho = movimento.movimentoItem[index].produto.grade.t5;
                              break;
                            case 6: tamanho = movimento.movimentoItem[index].produto.grade.t6;
                              break;
                            case 7: tamanho = movimento.movimentoItem[index].produto.grade.t7;
                              break;
                            case 8: tamanho = movimento.movimentoItem[index].produto.grade.t8;
                              break;
                            case 9: tamanho = movimento.movimentoItem[index].produto.grade.t9;
                              break;
                            case 10: tamanho = movimento.movimentoItem[index].produto.grade.t10;
                              break;
                            case 11: tamanho = movimento.movimentoItem[index].produto.grade.t11;
                              break;
                            case 12: tamanho = movimento.movimentoItem[index].produto.grade.t12;
                              break;
                            case 13: tamanho = movimento.movimentoItem[index].produto.grade.t13;
                              break;
                            case 14: tamanho = movimento.movimentoItem[index].produto.grade.t14;
                              break;
                            case 15: tamanho = movimento.movimentoItem[index].produto.grade.t15;
                              break;
                          }

                          var produtoVariante = movimento.movimentoItem[index].produto.produtoVariante.singleWhere(
                            (prodVariante) => ((prodVariante.idVariante == movimento.movimentoItem[index].idVariante) &&
                            (prodVariante.idProduto == movimento.movimentoItem[index].idProduto)),
                            orElse: () => null
                          );

                          String a = "";
                          if (tamanho != "") {
                            a = "Tam. $tamanho";
                          }

                          if ((produtoVariante != null) &&
                              (produtoVariante.variante.nome != "")) {
                            a = a != ""
                                ? a + "  Cor: " + produtoVariante.variante.nome
                                : produtoVariante.variante.nome;
                          }

                          // if(index == 0 && vendaBloc.tutorial != null){
                          //   return Showcase.withWidget(
                          //     key: itemCarrinho,
                          //     disableAnimation: true,
                          //     width: 200,
                          //     height: 200,
                          //     disposeOnTap: false,
                          //     container: Padding(
                          //       padding: const EdgeInsets.only(left: 38),
                          //         child: Column(
                          //           children: <Widget>[
                          //             Row(
                          //               children: <Widget>[
                          //                 Padding(
                          //                   padding: const EdgeInsets.only(right: 12,top: 10),
                          //                   child: Image.asset("assets/deslizar.png", width: 50),
                          //                 )
                          //               ],
                          //             ),
                          //             SizedBox(height: 18),
                          //             Row(
                          //               children: <Widget>[
                          //                 Image.asset("assets/mascote.png", width: 60),
                          //               ],
                          //             ),
                          //             SizedBox(height: 18),
                          //             Row(
                          //               children: <Widget>[
                          //                 Text("Para editar as informações do item\narraste de um lado para o outro", 
                          //                   style: TextStyle(color: Colors.white, fontSize: 16), textAlign: TextAlign.center),
                          //               ],
                          //             ),
                          //             SizedBox(height: 15),
                          //             SizedBox(
                          //               width: 150,
                          //               height: 40,
                          //               child: FlatButton(
                          //                 shape: RoundedRectangleBorder(
                          //                   borderRadius: BorderRadius.circular(8)
                          //                 ),
                          //                 onPressed: () async {
                          //                   WidgetsBinding.instance.addPostFrameCallback((_) =>
                          //                     ShowCaseWidget.of(myContext).startShowCase([botaoDirecionarPagamento]));
                          //                 }, 
                          //                 child: Text("Entendi", style: TextStyle(color: Colors.white)),
                          //                 color: Theme.of(context).primaryIconTheme.color,
                          //               ),
                          //             ),
                          //           ],
                          //         ),
                          //       ),
                          //       child: Column( 
                          //         children: <Widget>[
                          //           Visibility(
                          //             visible: index == indexOfProduto && movimento.movimentoItem[index].ehdeletado == 0 ? true : false,
                          //             child: Row(
                          //               children: <Widget>[
                          //                 Padding(
                          //                   padding: const EdgeInsets.only(left: 12, bottom: 4),
                          //                   child: Text(movimento.movimentoItem[index].produto.ehservico == 0 ? "Produto" : "Servico",style: Theme.of(context).textTheme.title),
                          //                 ),
                          //               ],
                          //             ),
                          //           ),
                          //           Visibility(
                          //             visible: movimento.movimentoItem[index].ehdeletado == 0 ? true : false,
                          //             child: Slidable(
                          //               actionPane: SlidableDrawerActionPane(),
                          //               actionExtentRatio: 0.25,
                          //               child: Padding(
                          //                 padding: const EdgeInsets.only(right: 8.0, left: 8.0, top: 4),
                          //                 child: Container(
                          //                   decoration: BoxDecoration(
                          //                     borderRadius: BorderRadius.circular(8),
                          //                     color: Theme.of(context).primaryColor,
                          //                   ),
                          //                   child: Container(
                          //                     decoration: BoxDecoration(
                          //                       borderRadius: BorderRadius.circular(8),
                          //                       border: Border.all(width: 2, color: Theme.of(context).accentColor,),
                          //                     ),
                          //                     child: ListTile(
                          //                       contentPadding: EdgeInsets.only(top: 0, bottom: 0, right: 5, left: 5),
                          //                       key: Key("${movimento.movimentoItem[index].id}"),
                          //                       title: Container(
                          //                         child: AutoSizeText(
                          //                           "${movimento.movimentoItem[index].produto.nome}",
                          //                           style: Theme.of(context).textTheme.body2,
                          //                           maxFontSize: Theme.of(context).textTheme.body2.fontSize,
                          //                           minFontSize: 10,
                          //                           maxLines: 2,
                          //                         ),
                          //                       ),
                          //                       subtitle: Text("$a",
                          //                         style: Theme.of(context).textTheme.body2,
                          //                       ),
                          //                       leading: Container(
                          //                         decoration: BoxDecoration(borderRadius: BorderRadius.circular(3)),
                          //                         height: AppConfig.safeBlockVertical * 11,
                          //                         width: AppConfig.safeBlockHorizontal * 18,
                          //                         child: movimento.movimentoItem[index].produto.produtoImagem.length > 0 && movimento.movimentoItem[index].produto.produtoImagem.first.ehDeletado == 0
                          //                         ? FutureBuilder<String>(
                          //                             future: readBase64Image(path_.dirname(movimento.movimentoItem[index].produto.produtoImagem.first.imagem)+"/${movimento.movimentoItem[index].produto.id}.txt"),
                          //                             builder: (context, snapshot){
                          //                               if(!snapshot.hasData){
                          //                                 return SizedBox.shrink();
                          //                               }
                          //                               return ClipRRect(
                          //                                 borderRadius: BorderRadius.circular(12),
                          //                                 child: Image.memory(base64Decode(snapshot.data),
                          //                                   fit: BoxFit.cover, 
                          //                                   width: 115,
                          //                                   height: 115,
                          //                                 ),
                          //                               );
                          //                             },
                          //                           )
                          //                         : ClipRRect(
                          //                           borderRadius: BorderRadius.circular(8),
                          //                           child: Container(
                          //                             color: Color(int.parse(movimento.movimentoItem[index].produto.iconeCor)),
                          //                             child: Center(
                          //                               child: Text("${movimento.movimentoItem[index].produto.nome}".substring(0, 2), 
                          //                                 style: TextStyle(
                          //                                   color: useWhiteForeground(Color(int.parse(movimento.movimentoItem[index].produto.iconeCor)))
                          //                                     ? const Color(0xffffffff)
                          //                                     : const Color(0xff000000), 
                          //                                   fontSize: Theme.of(context).textTheme.title.fontSize
                          //                                 )
                          //                               ),
                          //                             ),
                          //                           )
                          //                         )
                          //                       ),  
                          //                       trailing: Container(
                          //                         child: Column(
                          //                           mainAxisAlignment: MainAxisAlignment.center,
                          //                           crossAxisAlignment: CrossAxisAlignment.end,
                          //                           children: <Widget>[
                          //                             AutoSizeText(
                          //                               "${movimento.movimentoItem[index].quantidade.round()}x  ${precoVendido.text}",
                          //                               style: Theme.of(context).textTheme.caption,
                          //                               maxFontSize: Theme.of(context).textTheme.caption.fontSize,
                          //                               minFontSize: 8,
                          //                               maxLines: 1,
                          //                             ),
                          //                             AutoSizeText(
                          //                               movimento.movimentoItem[index].totalLiquido < 0 ?
                          //                                 "- ${totalLiquido.text}" :
                          //                                 "${totalLiquido.text}",
                          //                               style: GoogleFonts.sourceSansPro(
                          //                                 color: Colors.white,
                          //                                 fontSize: 18,
                          //                                 fontWeight: FontWeight.w600
                          //                               ),
                          //                               maxFontSize: 18,
                          //                               minFontSize: 10,
                          //                               maxLines: 1,
                          //                             ),
                          //                             AutoSizeText(
                          //                               movimento.movimentoItem[index].totalDesconto == 0.0
                          //                                 ? ""
                          //                                 : "Desconto ${totalDesconto.text}",
                          //                               style: Theme.of(context).textTheme.caption,
                          //                               maxFontSize: Theme.of(context).textTheme.caption.fontSize,
                          //                               maxLines: 1,
                          //                             ),
                          //                           ],
                          //                         ),
                          //                       ),
                          //                     ),
                          //                   ),
                          //                 ),
                          //               ),
                          //               actions: <Widget>[
                          //                 Padding(
                          //                   padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                          //                   child: Container(
                          //                     decoration: BoxDecoration(
                          //                       color: Colors.teal[600],
                          //                       borderRadius: BorderRadius.circular(8)
                          //                     ),
                          //                     child: IconSlideAction(
                          //                       caption: 'Quantidade',
                          //                       color: Colors.transparent,
                          //                       icon: Icons.add_shopping_cart,
                          //                       onTap: () {
                          //                         Navigator.push(context,
                          //                           PageRouteBuilder(
                          //                             opaque: false,
                          //                             pageBuilder: (BuildContext context, _, __) => QuantidadeItemPage(index: index),
                          //                             settings: RouteSettings(name: '/CarrinhoQuantidadeItem'),
                          //                             transitionsBuilder: (___, Animation<double> animation, ____, Widget child) => FadeTransition(opacity: animation,child: child,)
                          //                           )
                          //                         );
                          //                       },
                          //                     ),
                          //                   ),
                          //                 ),
                          //                 Padding(
                          //                   padding: const EdgeInsets.all(8.0),
                          //                   child: Container(
                          //                     decoration: BoxDecoration(
                          //                       color: Colors.teal[300],
                          //                       borderRadius: BorderRadius.circular(8)
                          //                     ),
                          //                     child: IconSlideAction(
                          //                       caption: 'Valor',
                          //                       color: Colors.transparent,
                          //                       icon: Icons.attach_money,
                          //                       onTap: () {
                          //                         Navigator.push(context,
                          //                           PageRouteBuilder(
                          //                             opaque: false,
                          //                             pageBuilder: (BuildContext context, _, __) => ValorItemPage(index: index,),
                          //                             settings: RouteSettings(name: '/CarrinhoValorItem'),
                          //                             transitionsBuilder: (___, Animation<double> animation, ____, Widget child) => FadeTransition(opacity: animation, child: child,)
                          //                           )
                          //                         );
                          //                       },
                          //                     ),
                          //                   ),
                          //                 ),
                          //                 Padding(
                          //                   padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                          //                   child: Container(
                          //                     decoration: BoxDecoration(
                          //                       color: Colors.teal[100],
                          //                       borderRadius: BorderRadius.circular(8)
                          //                     ),
                          //                     child: IconSlideAction(
                          //                       caption: 'Desconto',
                          //                       color: Colors.transparent,
                          //                       icon: Icons.tune,
                          //                       onTap: () {
                          //                         Navigator.push(context,
                          //                           PageRouteBuilder(
                          //                             opaque: false,
                          //                             pageBuilder: (BuildContext context, _, __) => DescontoItemModule(index: index),
                          //                             settings: RouteSettings(name: '/CarrinhoDescontoItem'),
                          //                             transitionsBuilder: (___, Animation<double> animation, ____, Widget child) => FadeTransition(opacity: animation, child: child,),
                          //                           )
                          //                         );
                          //                       },
                          //                     ),
                          //                   )
                          //                 )
                          //               ],
                          //               secondaryActions: <Widget>[
                          //                 Padding(
                          //                   padding: const EdgeInsets.all(8.0),
                          //                   child: Container(
                          //                     decoration: BoxDecoration(
                          //                       color: Colors.red,
                          //                       borderRadius: BorderRadius.circular(8)
                          //                     ),
                          //                     child: IconSlideAction(
                          //                       caption: 'Excluir',
                          //                       icon: Icons.delete,
                          //                       color: Colors.transparent,
                          //                       onTap: () {
                          //                         vendaBloc.removeMovimentoItem(index);
                          //                       },
                          //                     ),
                          //                   ),
                          //                 ),
                          //               ],
                          //             ),
                          //           ),
                          //           Visibility(
                          //             visible: index == indexOfLastServico && firstProdutoWhere != null ? true : false,
                          //             child: Padding(
                          //             padding: const EdgeInsets.only(top: 6, left: 13, right: 13),
                          //             child: StreamBuilder<Movimento>(
                          //               initialData: Movimento(),
                          //               stream: vendaBloc.movimentoOut,
                          //               builder: (context, snapshot) {
                          //                 Movimento movimento = snapshot.data;
                          //                 subtotalServico.updateValue(movimento.valorTotalServico);
                          //                   return Row(
                          //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          //                     children: <Widget>[
                          //                       Text("Subtotal:",style: TextStyle(color: Colors.white)),
                          //                       Text("${subtotalServico.text}", style: TextStyle(color: Colors.white)),
                          //                     ],
                          //                   );
                          //                 }
                          //               ),
                          //             ),
                          //           ),
                          //         ]
                          //       )
                          //     );
                          //   }

                        return Column(
                          children: <Widget>[
                            Visibility(
                              visible: index == indexOfProduto && movimento.movimentoItem[index].ehdeletado == 0 && indexOfFirstServico != -1,
                              child: Row(
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.only(left: 12, bottom: 4),
                                    child: Text(movimento.movimentoItem[index].produto.ehservico == 0 ? "Produto" : "Servico",style: Theme.of(context).textTheme.title),
                                  ),
                                ],
                              ),
                            ),
                            Visibility(
                              visible: movimento.movimentoItem[index].ehdeletado == 0 ? true : false,
                              child: Slidable(
                                actionPane: SlidableDrawerActionPane(),
                                actionExtentRatio: 0.25,
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 8.0, left: 8.0, top: 4),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(width: 2, color: Theme.of(context).primaryColor,),
                                    ),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(width: 2, color: Theme.of(context).accentColor,),
                                      ),
                                      child: ListTile(
                                        contentPadding: EdgeInsets.only(top: 0, bottom: 0, right: 5, left: 5),
                                        key: Key("${movimento.movimentoItem[index].id}"),
                                        title: Container(
                                          child: AutoSizeText(
                                            "${movimento.movimentoItem[index].produto.nome}",
                                            style: Theme.of(context).textTheme.body2,
                                            maxFontSize: Theme.of(context).textTheme.body2.fontSize,
                                            minFontSize: 10,
                                            maxLines: 2,
                                          ),
                                        ),
                                        subtitle: Text("$a",
                                          style: Theme.of(context).textTheme.body2,
                                        ),
                                        leading: Container(
                                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(3)),
                                          height: AppConfig.safeBlockVertical * 11,
                                          width: AppConfig.safeBlockHorizontal * 18,
                                          child: movimento.movimentoItem[index].produto.produtoImagem.length > 0 && movimento.movimentoItem[index].produto.produtoImagem.first.ehDeletado == 0
                                          ? FutureBuilder<String>(
                                              future: readBase64Image("${movimento.movimentoItem[index].produto.produtoImagem.first.imagem.replaceAll(".png", "")}.txt"),
                                              builder: (context, snapshot){
                                                return AnimatedOpacity(
                                                  duration: Duration(milliseconds: 200),
                                                  opacity: snapshot.hasData ? 1.0 : 0.0,
                                                  child: ClipRRect(
                                                    borderRadius: BorderRadius.circular(8),
                                                    child: snapshot.hasData ? Image.memory(base64Decode(snapshot.data),
                                                      gaplessPlayback: true,
                                                      fit: BoxFit.cover, 
                                                      width: 115,
                                                      height: 115,
                                                    ) : SizedBox.shrink(),
                                                  )
                                                );
                                              },
                                            )
                                          : ClipRRect(
                                            borderRadius: BorderRadius.circular(8),
                                            child: Container(
                                              color: Color(int.parse(movimento.movimentoItem[index].produto.iconeCor)),
                                              child: Center(
                                                child: Text("${movimento.movimentoItem[index].produto.nome}".substring(0, 2), 
                                                  style: TextStyle(
                                                    color: useWhiteForeground(Color(int.parse(movimento.movimentoItem[index].produto.iconeCor)))
                                                      ? const Color(0xffffffff)
                                                      : const Color(0xff000000), 
                                                    fontSize: Theme.of(context).textTheme.title.fontSize
                                                  )
                                                ),
                                              ),
                                            )
                                          )
                                        ),  
                                        trailing: Container(
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.end,
                                            children: <Widget>[
                                              AutoSizeText(
                                                "${movimento.movimentoItem[index].quantidade.round()}x  ${precoVendido.text}",
                                                style: Theme.of(context).textTheme.caption,
                                                maxFontSize: Theme.of(context).textTheme.caption.fontSize,
                                                minFontSize: 8,
                                                maxLines: 1,
                                              ),
                                              AutoSizeText(
                                                movimento.movimentoItem[index].totalLiquido < 0 ?
                                                  "- ${totalLiquido.text}" :
                                                  "${totalLiquido.text}",
                                                style: GoogleFonts.sourceSansPro(
                                                  color: Colors.white,
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w600
                                                ),
                                                maxFontSize: 18,
                                                minFontSize: 10,
                                                maxLines: 1,
                                              ),
                                              AutoSizeText(
                                                movimento.movimentoItem[index].totalDesconto == 0.0
                                                  ? ""
                                                  : "Desconto ${totalDesconto.text}",
                                                style: Theme.of(context).textTheme.caption,
                                                maxFontSize: Theme.of(context).textTheme.caption.fontSize,
                                                maxLines: 1,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                actions: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.teal[600],
                                        borderRadius: BorderRadius.circular(8)
                                      ),
                                      child: IconSlideAction(
                                        caption: 'Quantidade',
                                        color: Colors.transparent,
                                        icon: Icons.add_shopping_cart,
                                        onTap: () {
                                          Navigator.push(context,
                                            PageRouteBuilder(
                                              opaque: false,
                                              pageBuilder: (BuildContext context, _, __) => QuantidadeItemPage(index: index),
                                              settings: RouteSettings(name: '/CarrinhoQuantidadeItem'),
                                              transitionsBuilder: (___, Animation<double> animation, ____, Widget child) => FadeTransition(opacity: animation,child: child,)
                                            )
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 8.0, bottom: 8.0,left: 9,right: 9),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.teal[300],
                                        borderRadius: BorderRadius.circular(8)
                                      ),
                                      child: IconSlideAction(
                                        caption: 'Valor',
                                        color: Colors.transparent,
                                        icon: Icons.attach_money,
                                        onTap: () {
                                          Navigator.push(context,
                                            PageRouteBuilder(
                                              opaque: false,
                                              pageBuilder: (BuildContext context, _, __) => ValorItemPage(index: index,),
                                              settings: RouteSettings(name: '/CarrinhoValorItem'),
                                              transitionsBuilder: (___, Animation<double> animation, ____, Widget child) => FadeTransition(opacity: animation, child: child,)
                                            )
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 8.0, bottom: 8.0,right: 9),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.teal[100],
                                        borderRadius: BorderRadius.circular(8)
                                      ),
                                      child: IconSlideAction(
                                        caption: 'Desconto',
                                        color: Colors.transparent,
                                        icon: Icons.tune,
                                        onTap: () {
                                          Navigator.push(context,
                                            PageRouteBuilder(
                                              opaque: false,
                                              pageBuilder: (BuildContext context, _, __) => DescontoItemModule(index: index),
                                              settings: RouteSettings(name: '/CarrinhoDescontoItem'),
                                              transitionsBuilder: (___, Animation<double> animation, ____, Widget child) => FadeTransition(opacity: animation, child: child,),
                                            )
                                          );
                                        },
                                      ),
                                    )
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.teal[100],
                                        borderRadius: BorderRadius.circular(8)
                                      ),
                                      child: IconSlideAction(
                                        caption: 'Detalhes',
                                        color: Colors.transparent,
                                        icon: Icons.more_horiz,
                                        onTap: () {
                                        Navigator.push(
                                        context,
                                        PageRouteBuilder(
                                          opaque: false,
                                          pageBuilder: (BuildContext context, _, __) {
                                            return DetalheItemPage(index: index);
                                          },
                                          transitionsBuilder: (___, Animation<double> animation, ____, Widget child) {
                                            return FadeTransition(
                                              opacity: animation,
                                              child: child,
                                            );
                                          }));
                                        },
                                      ),
                                    )
                                  )
                                ],
                                secondaryActions: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.all(8),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.red,
                                        borderRadius: BorderRadius.circular(8)
                                      ),
                                      child: IconSlideAction(
                                        caption: 'Excluir',
                                        icon: Icons.delete,
                                        color: Colors.transparent,
                                        onTap: () {
                                          vendaBloc.removeMovimentoItem(index);
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Visibility(
                              visible: index == indexOfLastServico && firstProdutoWhere != null ? true : false,
                              child: Padding(
                              padding: const EdgeInsets.only(top: 6, left: 13, right: 13),
                              child: StreamBuilder<Movimento>(
                                initialData: Movimento(),
                                stream: vendaBloc.movimentoOut,
                                builder: (context, snapshot) {
                                  Movimento movimento = snapshot.data;
                                  subtotalServico.updateValue(movimento.valorTotalLiquidoServico);
                                    return Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Text("Subtotal:",style: TextStyle(color: Colors.white)),
                                        Text("${subtotalServico.text}", style: TextStyle(color: Colors.white)),
                                      ],
                                    );
                                  }
                                ),
                              ),
                            ),
                          ],
                        );
                      }
                    ),
                  ),
                  Container(
                    color: Theme.of(context).primaryColor,
                    padding: EdgeInsets.only(bottom: 10, right: 20, left: 20, top: 5),
                    child: ButtonTheme(
                      height: 45,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Container(
                            width: 60,
                            child: RaisedButton(
                              color: Theme.of(context).primaryIconTheme.color,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6)
                              ),
                              child: Text("• • •",
                                style: TextStyle(color: Colors.white, fontSize: 20),
                              ),
                              onPressed: () {
                                showModalBottomSheet(
                                  context: context,
                                  builder: (BuildContext context){
                                    return SafeArea(
                                      child: Container(
                                        color: Theme.of(context).accentColor,
                                        width: AppConfig.safeBlockVertical * 10,
                                        height: AppConfig.safeBlockVertical * 32,
                                        padding: EdgeInsets.all(15),
                                        child: Column(
                                          children: <Widget>[
                                            Column(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: <Widget>[
                                                ListTile(
                                                  contentPadding: EdgeInsets.all(1),
                                                  title: Text("Esvaziar sacola", style: TextStyle(color: Colors.red), textAlign: TextAlign.left,),
                                                  onTap: () { 
                                                    if(vendaBloc.movimento.movimentoItem.length > 0){
                                                      vendaBloc.resetBloc();
                                                      Navigator.pop(context);
                                                      pageController.animateToPage(0, duration: Duration(milliseconds: 600), curve: Curves.fastOutSlowIn);                                                
                                                    }
                                                  },
                                                ),
                                                Divider(height: 1, color: Colors.white,),
                                                ListTile(
                                                  contentPadding: EdgeInsets.all(1),
                                                  title: Text("Adicionar observação",),
                                                  trailing: Icon(Icons.arrow_forward_ios, color: Colors.white,),
                                                  onTap: () {
                                                    Navigator.pop(context);
                                                    Navigator.push(context,
                                                      PageRouteBuilder(
                                                        pageBuilder: (BuildContext context, _, __) {
                                                          return DetalheMovimentoPage();
                                                        },
                                                      )
                                                    );
                                                  },
                                                ),
                                                Divider(height: 1, color: Colors.white,),
                                              ],
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(top: 15),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: <Widget>[
                                                  InkWell(
                                                    child: Container(
                                                      child: Column(
                                                        children: <Widget>[
                                                          Image.asset('assets/descontoNaVendaIcon.png', height: 30, color: Colors.white,),
                                                          Text("Desconto na venda",)
                                                        ],
                                                      )
                                                    ),
                                                    onTap: () async {
                                                      if(vendaBloc.movimento.movimentoItem.length > 0){
                                                        Navigator.pop(context);
                                                        Navigator.push(context,
                                                          MaterialPageRoute(
                                                            builder: (context) => PagamentoDescontoModule(),
                                                            settings: RouteSettings(name: '/PagamentoDesconto')
                                                          )
                                                        );
                                                      }
                                                    },
                                                  ),
                                                  InkWell(
                                                    child: Container(
                                                      child: Column(
                                                        children: <Widget>[
                                                          Icon(Icons.save, size: 30, color: Colors.white,),
                                                          Text("Salvar",)
                                                        ],
                                                      )
                                                    ),
                                                    onTap: () async {
                                                      if(vendaBloc.movimento.movimentoItem.length > 0){
                                                        Navigator.pop(context);
                                                        vendaBloc.saveVenda(1);
                                                        await sincBloc.sincronizacaoLambda.stop();
                                                        sincBloc.sincronizacaoLambda.start();
                                                        pageController.animateToPage(0, curve: Interval(0.89, 0.92, curve: Curves.fastOutSlowIn),
                                                        duration: Duration(milliseconds: 300));
                                                        Navigator.push(context,
                                                          MaterialPageRoute(
                                                            builder: (BuildContext context) {
                                                              return ReciboPage(
                                                                icon: Icon(
                                                                  Icons.check_circle_outline,
                                                                  size: 100,
                                                                  color: Colors.white
                                                                  ),
                                                                message: "Pedido salvo com sucesso!",
                                                              );
                                                            },
                                                          )
                                                        );
                                                      }
                                                    },
                                                  ),
                                                  InkWell(
                                                    child: Container(
                                                      child: Column(
                                                        children: <Widget>[
                                                          Icon(Icons.share, size: 30, color: movimento.movimentoItem.length > 0 ? Colors.white : Colors.grey),
                                                          Text("Compartilhar",)
                                                        ],
                                                      )
                                                    ),
                                                    onTap: () {
                                                      if(movimento.movimentoItem.length > 0){
                                                        Navigator.pop(context);
                                                        Navigator.push(context,
                                                          MaterialPageRoute(
                                                            settings: RouteSettings(name: '/Orcamento'),
                                                            builder: (context) {
                                                              return OrcamentoPage(index: vendaBloc.movimento.id == null ? 0 : vendaBloc.movimento.id,);
                                                            }
                                                          )
                                                        );
                                                      }
                                                    },
                                                  ),
                                                  InkWell(
                                                    child: Container(
                                                      child: Column(
                                                        children: <Widget>[
                                                          Icon(Icons.print, size: 30, color: Colors.white),
                                                          Text("Imprimir")
                                                        ],
                                                      )
                                                    ),
                                                    onTap: () {
                                                      if(vendaBloc.appGlobalBloc.terminal.terminalImpressora != null && vendaBloc.appGlobalBloc.terminal.terminalImpressora.length > 0){
                                                        vendaBloc.printRecibo();
                                                      } else {
                                                        showDialog(
                                                          context: context,
                                                          builder: (context){
                                                            return CustomDialogConfirmation(
                                                              title: "Informação",
                                                              description: "Parece que esse terminal não tem nenhuma impressora cadastrada ou vinculada, gostaria de realizar o cadastro agora?",
                                                              buttonCancelText: "Cancelar",
                                                              buttonOkText: "Cadastrar",
                                                              funcaoBotaoCancelar: () {
                                                                Navigator.pop(context);
                                                              },                                                                                 
                                                              funcaoBotaoOk: () async {
                                                                Navigator.popAndPushNamed(context, '/ConfiguracaoTerminal');
                                                              },
                                                            );
                                                          }
                                                        );
                                                      }
                                                    },
                                                  ),
                                                ],
                                              ),
                                            ),  
                                          ]
                                        ),
                                      ),
                                    );
                                  }
                                );
                              }
                            ),
                          ),
                          Expanded(
                            child: 
                            // Showcase.withWidget(
                            //   key: botaoDirecionarPagamento,
                            //   disableAnimation: true,
                            //   width: 200,
                            //   height: 200,
                            //   disposeOnTap: false,
                            //   container: Column(
                            //     children: <Widget>[
                            //       Row(
                            //         children: <Widget>[
                            //           Image.asset("assets/mascote.png", width: 60),
                            //         ],
                            //       ),
                            //       SizedBox(height: 15),
                            //       Row(
                            //         children: <Widget>[
                            //           Text("Clique para ir para\na tela de pagamento", 
                            //             style: TextStyle(color: Colors.white, fontSize: 16), textAlign: TextAlign.center,),
                            //         ],
                            //       ),
                            //       SizedBox(height: 15),
                            //       Row(
                            //         children: <Widget>[
                            //           Image.asset("assets/setaAdicionarItem.png", width: 60),
                            //         ],
                            //       ),
                            //     ],
                            //   ),
                            //   onTargetClick: () async {
                            //     if (vendaBloc.tutorial.passo == 3) {
                            //       await vendaBloc.setTutorialPasso(4);
                            //       pageController.nextPage(
                            //         duration: Duration(milliseconds: 600),
                            //         curve: Curves.fastOutSlowIn,
                            //       );
                            //     } else {
                            //       await vendaBloc.setTutorialPasso(10); 
                            //       pageController.nextPage(
                            //         duration: Duration(milliseconds: 600),
                            //         curve: Curves.fastOutSlowIn,
                            //       );
                            //     }
                            //   },
                            //   child:
                              Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: RaisedButton(
                                  color: Theme.of(context).accentColor,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                                  child: StreamBuilder<Movimento>(
                                    initialData: Movimento(),
                                    stream: vendaBloc.movimentoOut,
                                    builder: (context, snapshot) {
                                      Movimento movimento = snapshot.data;
                                      var moneyMask = MoneyMaskedTextController(leftSymbol: "R\$ ");
                                      moneyMask.updateValue(movimento.valorRestante);
                                      return Text(movimento.valorTotalLiquido > 0 ?
                                        "Pagar ${movimento.movimentoItem.length > 0 ? moneyMask.text : "R\$ 0,00"}" :
                                        "Pagar -${movimento.movimentoItem.length > 0 ? moneyMask.text : "R\$ 0,00"}",
                                        style: Theme.of(context).textTheme.title,
                                      );
                                    }
                                  ),
                                  onPressed: () {
                                    if(vendaBloc.movimento.movimentoItem.length > 0){
                                      pageController.nextPage(
                                        duration: Duration(milliseconds: 600),
                                        curve: Curves.fastOutSlowIn);
                                    }
                                  }
                                ),
                              )
                            )
                          // )
                        ],
                      )
                    )
                  )
                ]
              );
            }
          ),
              Expanded(
                child: StreamBuilder<List<Movimento>>(
                  initialData: List<Movimento>(),
                  stream: consultaVendaBloc.movimentoListOut,
                  builder: (context, snapshot) {
                    List<Movimento> movimentoList = snapshot.data;

                    if (movimentoList.length == 0 ||
                        movimentoList.length == null) {
                      return Center(child: CircularProgressIndicator());
                    }

                    return ListView.builder(
                      itemCount: movimentoList.length,
                      itemBuilder: (context, index) {
                        valorTotalVendaLiquido.updateValue(movimentoList[index].valorTotalLiquido);
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
                                          Text("${valorTotalVendaLiquido.text}",
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
                                    consultaVendaBloc.cancelMovimento(index);
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
          );
    //     }
    //   )
    // );
  }
}
