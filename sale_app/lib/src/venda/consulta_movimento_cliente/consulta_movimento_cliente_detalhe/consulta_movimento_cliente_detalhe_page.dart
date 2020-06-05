import 'dart:io';
import 'dart:math';

import 'package:common_files/common_files.dart';
import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:fluggy/src/pages/widgets/Drawer/drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:fluggy/src/app_module.dart';
import 'package:fluggy/src/venda/consulta_movimento_cliente/pagamento_movimento_cliente/pagamento_movimento_cliente_page.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:date_range_picker/date_range_picker.dart' as DateRangePicker;
import 'package:screenshot/screenshot.dart';
import 'package:path_provider/path_provider.dart';

class ConsultaMovimentoClienteDetalhePage extends StatefulWidget {
  @override
  _ConsultaMovimentoClienteDetalhePageState createState() =>
      _ConsultaMovimentoClienteDetalhePageState();
}

class _ConsultaMovimentoClienteDetalhePageState
    extends State<ConsultaMovimentoClienteDetalhePage> with SingleTickerProviderStateMixin {
  MovimentoClienteBloc movimentoClienteBloc = AppModule.to.getBloc<MovimentoClienteBloc>();
  MoneyMaskedTextController valorMovimentoCliente, valorSaldoAnterior, valorSaldoAtual;
  ScreenshotController screenshotController = ScreenshotController();
  double _valorAtual;
  bool expandido;
  AnimationController animationController;
  Animation<double> translacaoBotaoPagar;
  Animation<double> translacaoBotaoCompartilhar;
  Animation<double> tamanhoDoBotao;
  GlobalKey<ScaffoldState> _scaffoldKey;

  @override
  void initState() {
    super.initState();
    movimentoClienteBloc.getMovimentoCliente(filterBasico: true, dataInicial: DateTime.parse('2019-12-11 18:10:16.143981'));
    _scaffoldKey  = GlobalKey<ScaffoldState>();
    valorMovimentoCliente = MoneyMaskedTextController(leftSymbol: "R\$ ");
    valorSaldoAnterior = MoneyMaskedTextController(leftSymbol: "R\$ ");
    valorSaldoAtual = MoneyMaskedTextController(leftSymbol: "R\$ ");
    expandido = false;
    animationController = AnimationController(vsync: this, duration: Duration(milliseconds: 200));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    translacaoBotaoPagar = Tween<double>(begin: -10, end: 0.8).animate(animationController);
    translacaoBotaoCompartilhar = Tween<double>(begin: 5, end: -0.35).animate(animationController);
    tamanhoDoBotao = Tween<double>(begin: 0, end: 5).animate(animationController);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        centerTitle: true,
        title: Text("Renato Pacheco"),
        elevation: 0,
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: InkWell(child: Icon(Icons.filter_list), onTap: () async {
              final List<DateTime> picked = await DateRangePicker.showDatePicker(
                locale: Locale("pt"),
                context: context,
                initialFirstDate: DateTime.now(),
                initialLastDate:
                    (DateTime.now()).add(Duration(days: 2)),
                firstDate: DateTime(2010),
                lastDate: DateTime(2020));
                if (picked != null) {
                  if (picked.length == 1) {
                    print(picked[0]);
                    movimentoClienteBloc.getMovimentoCliente(filterBasico: false, dataInicial: picked[0]);
                  } else {
                    movimentoClienteBloc.getMovimentoCliente(filterBasico: false, dataInicial: picked[0]);
                  }
                }
              }
            ),
          )
        ],
        leading:  StreamBuilder(
          stream: movimentoClienteBloc.appGlobalBloc.configuracaoGeralOut,
            builder: (context, snapshot) {
              if (!snapshot.hasData){
                return CircularProgressIndicator();
              }
              ConfiguracaoGeral configuracaoGeral = snapshot.data;
              return IconButton(
                icon: Icon(configuracaoGeral.ehMenuClassico == 1 ? 
                Icons.menu : Icons.arrow_back,color: Theme.of(context).primaryIconTheme.color),
                onPressed: () {
                  if (configuracaoGeral.ehMenuClassico == 1) {
                    _scaffoldKey.currentState.openDrawer();
                  } else { 
                    Navigator.pop(context);
                  }
                }
              );
            }
        ),
      ),
      drawer: DrawerApp(),
      body:  Column(
        children: <Widget>[
          Flexible(
            flex: 1,
            child: CustomScrollView(
              physics: NeverScrollableScrollPhysics(),
              slivers: <Widget>[
                SliverAppBar(
                  leading: Text(""),
                  pinned: false,
                  floating: false,
                  snap: false,
                  expandedHeight: 95,
                  flexibleSpace: SafeArea(
                    child: SingleChildScrollView(
                      physics: NeverScrollableScrollPhysics(),
                      child: Padding(
                      padding: EdgeInsets.all(10),
                      child: Column(
                        children: <Widget>[
                          SizedBox(
                            height: 20.0,
                            child: StreamBuilder(
                              stream: movimentoClienteBloc.filtroMovimentoListOut,
                              builder: (context, snapshot) {
                                if (!snapshot.hasData) {
                                  return CircularProgressIndicator();
                                }
                                List _filterList = snapshot.data;
                                
                                return ListView.builder(
                                  itemCount: _filterList.length,
                                  scrollDirection: Axis.horizontal,
                                  shrinkWrap: true,
                                  itemBuilder: (BuildContext context, int index){
                                    return InkWell(
                                      child: Container(
                                        padding: const EdgeInsets.only(right: 8.0, left: 8.0),
                                        decoration: BoxDecoration(
                                          border: Border(
                                            bottom: BorderSide(
                                              width: index == movimentoClienteBloc.getFiltroSelecionado()
                                                ? 2
                                                : 1,
                                              color: index == movimentoClienteBloc.getFiltroSelecionado()
                                                ? Theme.of(context).primaryIconTheme.color
                                                : Theme.of(context).accentColor),
                                          ),
                                        ),
                                        child: Text("${_filterList[index]}", 
                                          style: index == movimentoClienteBloc.getFiltroSelecionado() 
                                            ? Theme.of(context).textTheme.display1
                                            : Theme.of(context).textTheme.display3)),
                                      onTap: () async { 
                                        movimentoClienteBloc.setFiltroSelecionado(index);
                                        var date = DateTime.now();
                                        if(index == 0){
                                          await movimentoClienteBloc.getMovimentoCliente(filterBasico: true);
                                        } else if(index == 1){
                                          await movimentoClienteBloc.getMovimentoCliente(filterBasico: false, dataInicial: DateTime(date.year, date.month-1,1));
                                        } else if(index == 2){
                                          await movimentoClienteBloc.getMovimentoCliente(filterBasico: false, dataInicial: DateTime(date.year, date.month,1));
                                        } else if(index == 3){
                                          var diaDaSemana = date.weekday - 1;
                                          if (diaDaSemana < 0){  diaDaSemana = 6; }
                                          var segundaAtual = date.add(Duration(days: -diaDaSemana));
                                          DateTime segundaAnterior = segundaAtual.add(Duration(days: -7));
                                          await movimentoClienteBloc.getMovimentoCliente(filterBasico: false, dataInicial: DateTime(date.year, date.month, segundaAnterior.day));
                                        }
                                      },
                                    );
                                  },
                                );
                              },
                            ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width,
                            height: 70,
                            padding: EdgeInsets.only(top: 9),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                StreamBuilder(
                                  stream: movimentoClienteBloc.movimentoClienteListOut,
                                  builder: (context, snapshot) {
                                    if(!snapshot.hasData){
                                      return CircularProgressIndicator();
                                    }
                                    List<MovimentoCliente> movimentoClienteList = snapshot.data;
                                    valorSaldoAtual.updateValue(movimentoClienteList[movimentoClienteList.length-1].saldo);
                                    _valorAtual = movimentoClienteList[movimentoClienteList.length-1].saldo;
                                    return Text("${valorSaldoAtual.text}", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 32, color: Colors.white),);
                                  }
                                ),
                                Text("Saldo atual", style: TextStyle(color: Colors.white, fontSize: 14),)
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SliverAppBar(
                leading: Text(""),
                pinned: true,
                elevation: 0,
                flexibleSpace: Padding(
                  padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          LinearPercentIndicator(
                            width: MediaQuery.of(context).size.width - 30,
                            lineHeight: 10.0,
                            percent: 0.5,//(movimentoClienteBloc.movimentoCliente.saldo / movimentoClienteBloc.movimentoCliente),
                            backgroundColor: Colors.grey[350],
                            progressColor: Colors.green[300],
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 20, right: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text("Limite", style: TextStyle(color: Colors.white, fontSize: 12),),
                            StreamBuilder(
                              stream: movimentoClienteBloc.movimentoClienteListOut,
                              builder: (context, snapshot) {
                                if(!snapshot.hasData){
                                  return CircularProgressIndicator();
                                }
                                List<MovimentoCliente> movimentoClienteList = snapshot.data;
                                valorSaldoAtual.updateValue(movimentoClienteList[movimentoClienteList.length - 1].saldo);
                                return Text("${valorSaldoAtual.text} de R\$ 400,00", style: TextStyle(color: Colors.white, fontSize: 12),);
                              }
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: StreamBuilder(
                  initialData: List<MovimentoCliente>(),
                  stream: movimentoClienteBloc.movimentoClienteListOut,
                  builder: (context, snapshot) {
                    List<MovimentoCliente> movimentoClienteList = snapshot.data;
                    if(movimentoClienteList.length == 0){
                      return CircularProgressIndicator();
                    }
                    valorSaldoAnterior.updateValue((movimentoClienteList[0].saldo  - movimentoClienteList[0].valor));
                    return Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                      ),
                      padding: EdgeInsets.all(10),
                      child: Container(
                        decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Theme.of(context).accentColor,
                      ),
                      child: ListTile(
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text("Saldo Anterior",
                              style: Theme.of(context).textTheme.title
                            ),
                            Text("Extrato a partir de "+DateFormat("dd MMMM yyyy", 'pt_BR').format(
                                DateTime.parse("${movimentoClienteList[0].data}")),
                              style: Theme.of(context).textTheme.subhead,
                            ),
                            ],
                        ),
                        trailing: Text(movimentoClienteList[movimentoClienteList.length-1].saldo < 0 ? "- ${valorSaldoAnterior.text}" : "${valorSaldoAnterior.text}", 
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18,color: movimentoClienteList[0].valor < 0 ? Colors.red[400] : Colors.green[400] ),),
                      ),
                    ),
                  );
                }
              ),
            ),
          ],
        ),
      ),
      Expanded(
        flex: 2,
        child: StreamBuilder(
          initialData: List<MovimentoCliente>(),
          stream: movimentoClienteBloc.movimentoClienteListOut,
          builder: (context, snapshot) {
            List<MovimentoCliente> movimentoClienteList = snapshot.data;
            if (!snapshot.hasData) {
              return CircularProgressIndicator();
            }

            return Container(
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
              ),
              padding: EdgeInsets.all(8),
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).accentColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ListView.separated(
                  separatorBuilder: (BuildContext context, int index){
                    return Divider(
                      height: 1,
                      color: Theme.of(context).primaryColor
                    );
                  },
                  itemCount: movimentoClienteList.length,
                  itemBuilder: (BuildContext context, int index){
                    valorMovimentoCliente.updateValue(movimentoClienteList[index].valor);
                    valorSaldoAtual.updateValue(movimentoClienteList[index].saldo);
                    
                    return Slidable(
                      actionPane: SlidableDrawerActionPane(),
                      actionExtentRatio: 0.25,
                      child: ListTile(
                        dense: true,
                        leading: Icon(
                          movimentoClienteList[index].descricao == "Pagamento" 
                          ? Icons.arrow_downward 
                            : movimentoClienteList[index].descricao == "Pagamento cancelado" 
                              ? Icons.unfold_less
                                : Icons.arrow_upward, 
                          color: movimentoClienteList[index].descricao == "Pagamento" 
                            ? Colors.green 
                              : movimentoClienteList[index].descricao == "Pagamento cancelado" 
                                ? Colors.blueAccent[700] 
                                  : Colors.red, size: 27
                        ),
                        title: Padding(
                          padding: const EdgeInsets.only(top : 1.0),
                          child: Text("${movimentoClienteList[index].descricao}", style: Theme.of(context).textTheme.subtitle,),
                        ),
                        subtitle: Text(DateFormat("dd MMMM yyyy", 'pt_BR').format(DateTime.parse("${movimentoClienteList[index].data}")),style: Theme.of(context).textTheme.subhead),
                        trailing: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(movimentoClienteList[index].valor < 0 ? "- ${valorMovimentoCliente.text}" : "${valorMovimentoCliente.text}",
                              style: Theme.of(context).textTheme.subtitle,
                            ),
                            Text(movimentoClienteList[index].saldo < 0 ? "- ${valorSaldoAtual.text}" : "${valorSaldoAtual.text}",
                              style: movimentoClienteList[index].saldo < 0 ? 
                                Theme.of(context).textTheme.display3 :
                                Theme.of(context).textTheme.display3
                            )
                          ],
                        )
                      ),
                      secondaryActions: <Widget>[
                        IconSlideAction(
                          caption: 'Excluir',
                          color: Colors.red,
                          icon: Icons.delete,
                          onTap: () {
                            movimentoClienteBloc.addMovimentoCliente(movimentoClienteList[index].idTipoPagamento, movimentoClienteList[index].valor, true);
                          },
                        ),
                      ],
                    );
                  },
                )
              ),
            );
          }
        ),
      )
    ],
  ),  
    floatingActionButton: Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
            AnimatedBuilder(
              animation: animationController,
              builder: (BuildContext context, Widget child){
                return Transform.translate(
                  offset: Offset(translacaoBotaoPagar.value * -10, translacaoBotaoPagar.value * -3),
                  child: Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: AnimatedContainer(
                      height: tamanhoDoBotao.value * 8,
                      width: tamanhoDoBotao.value * 27,
                      duration: Duration(milliseconds: 8),
                      child: RaisedButton(
                        color: Theme.of(context).primaryIconTheme.color,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.0)),
                        child: Text("Pagar",
                          style: TextStyle(
                            fontSize: 16.0,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onPressed: () {
                          expandido = false;
                          animationController.reverse();
                          Navigator.push(context, 
                            PageRouteBuilder(
                              pageBuilder: (BuildContext context, _, __) => PagamentoMovimentoClientePage(valorRestante: _valorAtual),
                              settings: RouteSettings(name: '/MovimentoClientePagamento'),
                              transitionsBuilder: (___, Animation<double> animation, ____, Widget child) => FadeTransition(opacity: animation, child: child,)
                            )
                          );
                        },
                      ),
                    ),
                  )
                );
              }
            ),
            AnimatedBuilder(
              animation: animationController,
              builder: (BuildContext context, Widget child){
                return Transform.translate(
                  offset: Offset(translacaoBotaoCompartilhar.value * -16, translacaoBotaoCompartilhar.value * 7),
                  child:  AnimatedContainer(
                    height: tamanhoDoBotao.value * 8,
                    width: tamanhoDoBotao.value * 27,
                    duration: Duration(microseconds: 10),
                    child: RaisedButton(      
                      color: Theme.of(context).primaryIconTheme.color,
                      onPressed: () {
                        //shareFunction(index: Random);
                      },
                      shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25.0)),
                      child: Text("Compartilhar",
                        style: TextStyle(
                          fontSize: 16.0,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    ),
                  ),
                );
              }
            )
            ],
          ),
        ],
      ),
    ),
    floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    bottomNavigationBar: Container(
      color: Theme.of(context).primaryColor,  
      child: FloatingActionButton(
        mini: true,
        backgroundColor: Theme.of(context).primaryColor,
        onPressed: animacaoFloatingActionButton,
            child: AnimatedIcon(
          color: Theme.of(context).primaryIconTheme.color,
          size: 28,
          progress: animationController,
          icon: AnimatedIcons.menu_close,
        ),
      )
    )
  );    
}

  animacaoFloatingActionButton(){
    if (!expandido) {
      animationController.forward();
    } else {
      animationController.reverse();
    }
    expandido = !expandido;
  }

  shareFunction({index}) async {
    String _dateTime = DateTime.now().toString().replaceAll("-", "").replaceAll(":", "").replaceAll(".", "").replaceAll(" ", "");
    final directory = (await getApplicationDocumentsDirectory()).path;
    screenshotController.capture(
            path: "$directory/$_dateTime.png",
            pixelRatio: 1.8)
        .then((File image) async {
      final ByteData byteImg = await rootBundle.load(image.path.toString());
      await Share.files(
          'Compartilhar conta',
          {
            'contaNeoPDV$_dateTime.png': byteImg.buffer.asUint8List(),
          },
          '*/*',
          text: '');
      image.deleteSync(recursive: true);
    }).catchError((onError) {
      print(onError);
    });
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }
}
