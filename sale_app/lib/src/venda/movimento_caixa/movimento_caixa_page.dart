import 'dart:convert';
import 'dart:math';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:common_files/common_files.dart';
import 'package:fluggy/generated/locale_base.dart';
import 'package:fluggy/src/app_module.dart';
import 'package:fluggy/src/pages/widgets/Drawer/drawer.dart';
import 'package:fluggy/src/venda/movimento_caixa/movimento_caixa_valor/movimento_caixa_valor_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:vector_math/vector_math.dart' show radians;

class MovimentoCaixaPage extends StatefulWidget {
  @override
  _MovimentoCaixaPageState createState() => _MovimentoCaixaPageState();
}

class _MovimentoCaixaPageState extends State<MovimentoCaixaPage> with SingleTickerProviderStateMixin{
  AppGlobalBloc _appGlobalBloc;
  MovimentoCaixaBloc _movimentoCaixaBloc;
  AnimationController controller;
  Animation<double> translation;
  Animation<double> tamanhoDoBotao;
  bool expandido;
  MoneyMaskedTextController ticketMedio, totalResumoDeVendas, valorAbertura,
    valorTotalReforco, valorTotalRetirada, valorTotalVendaBruta, valorTotalVendaLiquida,
    valorTotalDevolucaoBruta, valorTotalDevolucaoLiquida, valorTotalCancelamento, 
    valorTotalDesconto, valorTotalSaldo, vendaTotalValorLiquido, valorEntradaTipoPagamento,
    valorSaidaTipoPagamento, valorSaldoTipoPagamento;
    GlobalKey<ScaffoldState> _scaffoldKey;

  @override
  void initState() {
    super.initState();
    _appGlobalBloc = AppModule.to.getBloc<AppGlobalBloc>();
    _movimentoCaixaBloc = AppModule.to.getBloc<MovimentoCaixaBloc>();
    _scaffoldKey  = GlobalKey<ScaffoldState>();
    init();
    double _valorTotalReforco = 0.0;
    _movimentoCaixaBloc.movimentoCaixa .movimentoCaixaParcela.forEach((movimentoCaixaParcelaElement) {
      if(movimentoCaixaParcelaElement.ehReforco == 1){
        _valorTotalReforco += movimentoCaixaParcelaElement.valor;
      }
    });
    double _valorTotalRetirada = 0.0;
    _movimentoCaixaBloc.movimentoCaixa .movimentoCaixaParcela.forEach((movimentoCaixaParcelaElement) {
      if(movimentoCaixaParcelaElement.ehRetirada == 1){
        _valorTotalRetirada += movimentoCaixaParcelaElement.valor;
      }
    });
    controller = AnimationController(duration: Duration(milliseconds: 400), vsync: this);
    ticketMedio = MoneyMaskedTextController(leftSymbol: 'R\$ ');
    totalResumoDeVendas = MoneyMaskedTextController(leftSymbol: 'R\$ ');
    valorAbertura = MoneyMaskedTextController(leftSymbol: 'R\$ ', initialValue: _movimentoCaixaBloc.movimentoCaixa != null ? _movimentoCaixaBloc.movimentoCaixa.valorAbertura : 0);
    valorTotalReforco = MoneyMaskedTextController(leftSymbol: 'R\$ ');
    valorTotalRetirada = MoneyMaskedTextController(leftSymbol: '-R\$ ');
    valorTotalVendaBruta = MoneyMaskedTextController(leftSymbol: 'R\$ ', initialValue: _movimentoCaixaBloc.movimentoCaixa != null ? _movimentoCaixaBloc.movimentoCaixa.vendaTotalValorBruto : 0);
    valorTotalVendaLiquida = MoneyMaskedTextController(leftSymbol: 'R\$ ', initialValue: _movimentoCaixaBloc.movimentoCaixa != null ? _movimentoCaixaBloc.movimentoCaixa.vendaTotalValorLiquido : 0);
    valorTotalDevolucaoBruta = MoneyMaskedTextController(leftSymbol: 'R\$ ', initialValue: _movimentoCaixaBloc.movimentoCaixa != null ? _movimentoCaixaBloc.movimentoCaixa.devolucaoTotalValorBruto : 0);
    valorTotalDevolucaoLiquida  = MoneyMaskedTextController(leftSymbol: 'R\$ ', initialValue: _movimentoCaixaBloc.movimentoCaixa != null ? _movimentoCaixaBloc.movimentoCaixa.devolucaoTotalValorLiquido : 0);
    valorTotalCancelamento = MoneyMaskedTextController(leftSymbol: 'R\$ ', initialValue: _movimentoCaixaBloc.movimentoCaixa != null ? _movimentoCaixaBloc.movimentoCaixa.vendaTotalValorCancelado : 0);
    valorTotalDesconto = MoneyMaskedTextController(leftSymbol: 'R\$ ', initialValue: _movimentoCaixaBloc.movimentoCaixa != null ? (_movimentoCaixaBloc.movimentoCaixa.vendaTotalValorDesconto + _movimentoCaixaBloc.movimentoCaixa.devolucaoTotalValorDesconto) : 0);
    valorTotalSaldo = MoneyMaskedTextController(leftSymbol: 'R\$ ', initialValue: _movimentoCaixaBloc.movimentoCaixa != null ? ((
                                          _movimentoCaixaBloc.movimentoCaixa.valorAbertura 
                                          + _valorTotalReforco
                                          + _movimentoCaixaBloc.movimentoCaixa.vendaTotalValorBruto 
                                          + _movimentoCaixaBloc.movimentoCaixa.vendaTotalValorLiquido
                                        ) 
                                         + 
                                        ( 
                                          _valorTotalRetirada
                                          - _movimentoCaixaBloc.movimentoCaixa.devolucaoTotalValorBruto
                                          - _movimentoCaixaBloc.movimentoCaixa.devolucaoTotalValorLiquido 
                                          - _movimentoCaixaBloc.movimentoCaixa.vendaTotalValorDesconto
                                          - _movimentoCaixaBloc.movimentoCaixa.vendaTotalValorCancelado 
                                        )) : 0);
    vendaTotalValorLiquido = MoneyMaskedTextController(leftSymbol: 'R\$ ');
    valorEntradaTipoPagamento = MoneyMaskedTextController(leftSymbol: 'R\$ ');
    valorSaidaTipoPagamento = MoneyMaskedTextController(leftSymbol: 'R\$ ');
    valorSaldoTipoPagamento = MoneyMaskedTextController(leftSymbol: 'R\$ ');
    expandido = false;
  }

  init() async {
    if(await _movimentoCaixaBloc.temCaixaAbertoAnterior() == false){
      _movimentoCaixaBloc.getMovimentoDia();
    } else {
      _movimentoCaixaBloc.initMovimentoCaixa();
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    translation = Tween<double>(begin: -100, end: 110).animate(controller);
    tamanhoDoBotao = Tween<double>(begin: 0, end: 5).animate(controller);
  }

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.of<LocaleBase>(context, LocaleBase);
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(locale.telaMovimentoCaixa.titulo, 
          style: Theme.of(context).textTheme.title,
        ),
        centerTitle: true,
        leading:  StreamBuilder(
          stream: _movimentoCaixaBloc.appGlobalBloc.configuracaoGeralOut,
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
      body: Container(
        color: Theme.of(context).primaryColor,
        child: StreamBuilder<MovimentoCaixa>(
          stream: _movimentoCaixaBloc.movimentoCaixaOut,
          builder: (context, snapshot) {
            MovimentoCaixa movimentoCaixa = snapshot.data;
            if(movimentoCaixa == null || movimentoCaixa.dataFechamento != null){
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Center(
                    child: Container(
                      child: Text("O caixa está fechado.\nDeseja realizar a abertura agora?", style: Theme.of(context).textTheme.body2, textAlign: TextAlign.center,),
                    ),
                  ),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 18.0),
                      child: FlatButton(
                        color: Theme.of(context).primaryIconTheme.color,
                        child: Text("Abrir caixa", style: Theme.of(context).textTheme.body2,),
                        onPressed: () {
                          if(movimentoCaixa != null){
                            if((movimentoCaixa.dataAbertura != null) && ourDate(movimentoCaixa.dataAbertura) == ourDate(DateTime.now())){
                              showDialog(
                                context: context,
                                builder: (context){
                                  return AlertDialog(
                                    backgroundColor: Theme.of(context).accentColor,
                                    title: Text("Alerta"),
                                    content: Text("O caixa já foi fechado.\nNão é possível abri-lo novamente.", style: Theme.of(context).textTheme.body2),
                                    actions: <Widget>[
                                      FlatButton(
                                        color: Theme.of(context).primaryColor,
                                        child: Text("OK"),
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                      )
                                    ],
                                  );
                                }
                              );
                            }
                          } else {
                            Navigator.push(context, 
                              MaterialPageRoute(
                                settings: RouteSettings(name: '/MovimentoCaixaValor'),
                                builder: (context) => MovimentoCaixaValorPage(tipoMovimentoCaixa: TipoMovimentoCaixa.abertura)
                              )
                            );
                          }
                        },
                      ),
                    )
                  ),
                ],
              );
            }
            ticketMedio.updateValue( movimentoCaixa.vendaTotalValorLiquido != null && movimentoCaixa.vendaTotalValorLiquido != 0 ? (movimentoCaixa.vendaTotalValorLiquido/movimentoCaixa.vendaTotalItem) : 0);
            vendaTotalValorLiquido.updateValue(movimentoCaixa.vendaTotalValorLiquido);

            return SingleChildScrollView(
              child: Column(
                   children: <Widget>[
                  Column(
                    children: <Widget>[
                      Stack(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(Radius.circular(10)),
                                side: BorderSide(color: Colors.white70)
                              ),
                              color: Theme.of(context).primaryColor,                                 
                              child: Container(
                                height: 120,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Container(
                                      width: 120,
                                      height: 100,
                                      alignment: Alignment.center,
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: <Widget>[
                                          Text("Data de abertura", style: Theme.of(context).textTheme.body2,),
                                          Text(DateFormat("dd/MM/yyyy").format(movimentoCaixa.dataAbertura), 
                                            style: permiteMovimentoDoDia() == true ? Theme.of(context).textTheme.body2 : TextStyle(color: Colors.red, fontSize: 17))
                                        ],
                                      ),
                                    ),
                                    Container(
                                      width: 120,
                                      height: 100,
                                      alignment: Alignment.center,
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: <Widget>[
                                          Text("Hora", style: Theme.of(context).textTheme.body2,),
                                          Text("${movimentoCaixa.dataAbertura.hour}:${movimentoCaixa.dataAbertura.minute}", style: Theme.of(context).textTheme.body2,)
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 50),
                            child: Align(
                              alignment: Alignment.bottomCenter,
                              child: Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(10)),
                                  side: BorderSide(color: Colors.white70)
                                ),
                                color: Theme.of(context).primaryColor,  
                                child: Container(
                                  padding: const EdgeInsets.only(right: 10, left: 10),
                                  alignment: Alignment.center,
                                  width: 95,
                                  height: 95,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(Radius.circular(10)),
                                    boxShadow: [
                                      BoxShadow(
                                        spreadRadius: 0.01
                                      )
                                    ]
                                  ),
                                  child: Text("a")
                                ),
                              )
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Column(
                    children: <Widget>[
                       Padding(
                         padding: const EdgeInsets.all(8.0),
                         child: Container(
                           height: 80,
                           child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(Radius.circular(6)),
                              side: BorderSide(color: Colors.white70)
                            ),
                            color: Theme.of(context).primaryColor,
                            child:Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text(locale.palavra.totalLiquido, style: Theme.of(context).textTheme.subhead,),
                                    AutoSizeText(
                                      vendaTotalValorLiquido.text,
                                      style: Theme.of(context).textTheme.headline,
                                      maxFontSize: Theme.of(context).textTheme.headline.fontSize,
                                      minFontSize: 8,
                                      maxLines: 1,
                                    ),
                                  ],
                                )
                              ],
                            )
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          height: 100,
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(6)),
                                    side: BorderSide(color: Colors.white70)
                                  ),
                                  color: Theme.of(context).primaryColor,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Text(locale.palavra.qtdVendas, style: Theme.of(context).textTheme.body2),
                                      Container(
                                        padding: EdgeInsets.all(2),
                                        child: AutoSizeText(
                                          movimentoCaixa.vendaTotalQuantidade.toInt().toString(),
                                          style: Theme.of(context).textTheme.headline,
                                          maxFontSize: Theme.of(context).textTheme.headline.fontSize,
                                          minFontSize: 8,
                                          maxLines: 1,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ),
                              Expanded(
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(6)),
                                    side: BorderSide(color: Colors.white70)
                                  ),
                                  color: Theme.of(context).primaryColor,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Text(locale.palavra.ticketMedio, style: Theme.of(context).textTheme.body2),
                                      Container(
                                        padding: EdgeInsets.all(2),
                                        child: AutoSizeText(
                                          ticketMedio.text,
                                          style: Theme.of(context).textTheme.headline,
                                          maxFontSize: Theme.of(context).textTheme.headline.fontSize,
                                          minFontSize: 8,
                                          maxLines: 1,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ),
                              Expanded(
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(6)),
                                    side: BorderSide(color: Colors.white70)
                                  ),
                                  color: Theme.of(context).primaryColor,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Text(locale.palavra.itensVendidos, style: Theme.of(context).textTheme.body2),
                                      Container(
                                        padding: EdgeInsets.all(2),
                                        child: AutoSizeText(
                                          movimentoCaixa.vendaTotalQuantidade.toInt().toString(),
                                          style: Theme.of(context).textTheme.headline,
                                          maxFontSize: Theme.of(context).textTheme.headline.fontSize,
                                          minFontSize: 8,
                                          maxLines: 1,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              )
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(6)),
                            side: BorderSide(color: Colors.white70)
                          ),
                          color: Theme.of(context).primaryColor,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: <Widget>[
                                Text(locale.telaMovimentoCaixa.resumoDeVendas, style: Theme.of(context).textTheme.subhead),
                                StreamBuilder<List<MovimentoCaixaTotalTipoPagamento>>(
                                  stream: _movimentoCaixaBloc.movimentoCaixaTotalTipoPagamentoListOut,
                                  builder: (context, snapshot) {
                                    if(!snapshot.hasData){
                                      return CircularProgressIndicator();
                                    }
                                    List<MovimentoCaixaTotalTipoPagamento> movimentoCaixaTotalTipoPagamento = snapshot.data;
                                    
                                    return ListView.separated(
                                      itemCount: movimentoCaixaTotalTipoPagamento.length,
                                      physics: NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      separatorBuilder: (context, index){
                                        return Divider(color: Colors.white, height: 0.8,);
                                      },
                                      itemBuilder: (context, index) {
                                        totalResumoDeVendas.updateValue(movimentoCaixaTotalTipoPagamento[index].vendaValorTotal);
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
                                                    stream: readBase64Image("/images/tipoPagamento/${_appGlobalBloc.loja.idPessoaGrupo}/${ movimentoCaixaTotalTipoPagamento[index].idTipoPagamento}.txt").asStream(),
                                                    builder: (context, snapshot){
                                                      return ClipRRect(
                                                        borderRadius: BorderRadius.circular(8),
                                                        child: Image.memory(base64Decode(snapshot.data.toString()),
                                                          fit: BoxFit.contain,
                                                          height: 30,
                                                        ),
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
                                                  child: Text(movimentoCaixaTotalTipoPagamento[index].tipoPagamento.nome , style: Theme.of(context).textTheme.body2,),
                                                ),
                                                LinearPercentIndicator(
                                                  width: 180,
                                                  lineHeight: 5,
                                                  percent: (movimentoCaixaTotalTipoPagamento[index].vendaValorTotal / _movimentoCaixaBloc.movimentoCaixa.vendaTotalValorLiquido).clamp(0.0, 1.0),
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
                                              totalResumoDeVendas.text,
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
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child:  Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(6)),
                            side: BorderSide(color: Colors.white70)
                          ),
                          color: Theme.of(context).primaryColor,
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: StreamBuilder(
                              stream: _movimentoCaixaBloc.movimentoCaixaOut,
                              builder: (context, snapshot){
                                if(!snapshot.hasData){
                                  return CircularProgressIndicator();
                                }
                                MovimentoCaixa _movimentoCaixa = snapshot.data;

                                valorAbertura.updateValue(_movimentoCaixa.valorAbertura);
                                double _valorTotalReforco = 0.0;
                                _movimentoCaixa.movimentoCaixaParcela.forEach((movimentoCaixaParcelaElement) {
                                  if(movimentoCaixaParcelaElement.ehReforco == 1){
                                    _valorTotalReforco += movimentoCaixaParcelaElement.valor;
                                  }
                                });
                                valorTotalReforco.updateValue(_valorTotalReforco);
                                double _valorTotalRetirada = 0.0;
                                _movimentoCaixa.movimentoCaixaParcela.forEach((movimentoCaixaParcelaElement) {
                                  if(movimentoCaixaParcelaElement.ehRetirada == 1){
                                    _valorTotalRetirada += movimentoCaixaParcelaElement.valor;
                                  }
                                });
                                valorTotalRetirada.updateValue(_valorTotalRetirada);
                                valorTotalVendaBruta.updateValue(_movimentoCaixa.vendaTotalValorBruto);
                                valorTotalVendaLiquida.updateValue(_movimentoCaixa.vendaTotalValorLiquido);
                                valorTotalDevolucaoBruta.updateValue(_movimentoCaixa.devolucaoTotalValorBruto);
                                valorTotalDevolucaoLiquida.updateValue(_movimentoCaixa.devolucaoTotalValorLiquido);
                                valorTotalCancelamento.updateValue(_movimentoCaixa.vendaTotalValorCancelado);
                                valorTotalDesconto.updateValue((_movimentoCaixa.vendaTotalValorDesconto + _movimentoCaixa.devolucaoTotalValorDesconto));
                                valorTotalSaldo.updateValue(
                                  ((
                                    _movimentoCaixa.valorAbertura 
                                    + _valorTotalReforco
                                    + _movimentoCaixa.vendaTotalValorBruto 
                                    + _movimentoCaixa.vendaTotalValorLiquido
                                  ) 
                                    + 
                                  ( 
                                    _valorTotalRetirada
                                    - _movimentoCaixa.devolucaoTotalValorBruto
                                    - _movimentoCaixa.devolucaoTotalValorLiquido 
                                    - _movimentoCaixa.vendaTotalValorDesconto
                                    - _movimentoCaixa.vendaTotalValorCancelado 
                                  ))
                                );                                

                                return Column(
                                  children: <Widget>[
                                    Text(locale.telaMovimentoCaixa.titulo, style: Theme.of(context).textTheme.subhead,),
                                    Column(
                                      children: <Widget>[
                                        _buildMovimentoCaixaRow(descricao: locale.palavra.abertura, value: valorAbertura.text),
                                        _buildMovimentoCaixaRow(descricao: "Reforço", value: valorTotalReforco.text),
                                        _buildMovimentoCaixaRow(descricao: "Retirada", value: valorTotalRetirada.text),
                                        _buildMovimentoCaixaRow(descricao: "Venda Bruta", value: valorTotalVendaBruta.text),
                                        _buildMovimentoCaixaRow(descricao: "Venda Líquida", value: valorTotalVendaLiquida.text),
                                        _buildMovimentoCaixaRow(descricao: "Devolução Bruta", value: valorTotalDevolucaoBruta.text),
                                        _buildMovimentoCaixaRow(descricao: "Devolução Líquida", value: valorTotalDevolucaoLiquida.text),
                                        _buildMovimentoCaixaRow(descricao: "Cancelamento", value: valorTotalCancelamento.text),
                                        _buildMovimentoCaixaRow(descricao: "Descontos", value: valorTotalDesconto.text),
                                      ]
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 10.0, left: 5),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Text(locale.palavra.saldo+"(=)", style: Theme.of(context).textTheme.body2,),
                                          Text(valorTotalSaldo.text, style: Theme.of(context).textTheme.body2,)
                                        ],
                                      ),
                                    )
                                  ],
                                );
                              }
                            ),
                          ),
                        ),
                      ),
                      StreamBuilder(
                        stream: _movimentoCaixaBloc.movimentoCaixaTotalTipoPagamentoListOut,
                        builder: (context, snapshot){
                          if(!snapshot.hasData){
                            return CircularProgressIndicator();
                          }
                          List<MovimentoCaixaTotalTipoPagamento> movimentoCaixaTotalTipoPagamentoList = snapshot.data;
                          return ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: movimentoCaixaTotalTipoPagamentoList.length,
                            itemBuilder: (context, index){
                              valorEntradaTipoPagamento.updateValue((movimentoCaixaTotalTipoPagamentoList[index].aberturaValorTotal +
                                                  movimentoCaixaTotalTipoPagamentoList[index].reforcoValorTotal +
                                                  movimentoCaixaTotalTipoPagamentoList[index].vendaValorTotal));
                              valorSaidaTipoPagamento.updateValue((movimentoCaixaTotalTipoPagamentoList[index].retiradaValorTotal));
                              valorSaldoTipoPagamento.updateValue(((movimentoCaixaTotalTipoPagamentoList[index].aberturaValorTotal +
                                                  movimentoCaixaTotalTipoPagamentoList[index].reforcoValorTotal +
                                                  movimentoCaixaTotalTipoPagamentoList[index].vendaValorTotal) +
                                                  (movimentoCaixaTotalTipoPagamentoList[index].retiradaValorTotal)));
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child:  Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(6)),
                                    side: BorderSide(color: Colors.white70)
                                  ),
                                  color: Theme.of(context).primaryColor,
                                  child: Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Column(
                                      children: <Widget>[
                                        Container(
                                          padding: EdgeInsets.only(bottom: 8),
                                          decoration: BoxDecoration(
                                            border: Border(bottom: BorderSide(color: Colors.white, width: 1)),
                                          ),
                                          child: Row(
                                            children: <Widget>[
                                              Padding(
                                                padding: const EdgeInsets.only(right: 8.0),
                                                child:  StreamBuilder(
                                                  stream: readBase64Image("/images/tipoPagamento/${_appGlobalBloc.loja.idPessoaGrupo}/${movimentoCaixaTotalTipoPagamentoList[index].idTipoPagamento}.txt").asStream(),
                                                  builder: (context, snapshot){
                                                    return ClipRRect(
                                                      borderRadius: BorderRadius.circular(8),
                                                      child: Image.memory(base64Decode(snapshot.data.toString()),
                                                        fit: BoxFit.contain,
                                                        height: 30,
                                                      ),
                                                    );
                                                  } 
                                                ),
                                              ),
                                              Text(movimentoCaixaTotalTipoPagamentoList[index].tipoPagamento.nome, style: Theme.of(context).textTheme.body2,)
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(top: 8.0),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                            children: <Widget>[
                                              Column(
                                                children: <Widget>[
                                                  Text(locale.palavra.entrada, style: Theme.of(context).textTheme.body2,),
                                                  Text(valorEntradaTipoPagamento.text, style: Theme.of(context).textTheme.body2,)
                                                ],
                                              ),
                                              Container(
                                                color: Colors.white,
                                                height: 35,
                                                width: 1,
                                              ),
                                              Column(
                                                children: <Widget>[
                                                  Text(locale.palavra.saida, style: Theme.of(context).textTheme.body2,),
                                                  Text(valorSaidaTipoPagamento.text, style: Theme.of(context).textTheme.body2,)
                                                ],
                                              ),
                                              Container(
                                                color: Colors.white,
                                                height: 35,
                                                width: 1,
                                              ),
                                              Column(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                children: <Widget>[
                                                  Text(locale.palavra.saldo, style: Theme.of(context).textTheme.body2,),
                                                  Text(valorSaldoTipoPagamento.text, style: Theme.of(context).textTheme.body2,)
                                                ],
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        }
                      )
                    ],
                  )
                ],
              ),
            );
          }
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        showUnselectedLabels: true,
        onTap: (index) {
          if(index == 0){
            permiteMovimentoDoDia() == true ??
            Navigator.push(context, 
              MaterialPageRoute(
                settings: RouteSettings(name: '/MovimentoCaixaValor'),
                builder: (context) => MovimentoCaixaValorPage(tipoMovimentoCaixa: TipoMovimentoCaixa.abertura)
              )
            );
          } else if(index == 1){
            _movimentoCaixaBloc.movimentoCaixaOut.listen((onData){
              _movimentoCaixaBloc.doFechamentoCaixa(onData);
              _movimentoCaixaBloc.initMovimentoCaixa();
            });
          } else if(index == 2){
            permiteMovimentoDoDia() == true ??
            Navigator.push(context, 
              MaterialPageRoute(
                settings: RouteSettings(name: '/MovimentoCaixaValor'),
                builder: (context) => MovimentoCaixaValorPage(tipoMovimentoCaixa: TipoMovimentoCaixa.retirada)
              )
            );
          } else if(index == 3){
            permiteMovimentoDoDia() == true ??
            Navigator.push(context, 
              MaterialPageRoute(
                settings: RouteSettings(name: '/MovimentoCaixaValor'),
                builder: (context) => MovimentoCaixaValorPage(tipoMovimentoCaixa: TipoMovimentoCaixa.reforco)
              )
            );
          }
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.tonality),
            title: Text("Abertura")
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.tonality),
            title: Text("Fechamento")
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.tonality),
            title: Text("Retirada")
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.tonality),
            title: Text("Reforço")
          ),
        ]
      )
    );
  }

  Widget _buildMovimentoCaixaButton({Color color, Color textColor, String text="", Function() onPressed, double cosseno, double seno}) {
    return Transform(
      transform: Matrix4.identity()..translate(
        (translation.value) * cosseno, 
        (translation.value) * seno
      ),
      child: FadeTransition(
        opacity: controller,
        child: AnimatedContainer(
          height: tamanhoDoBotao.value * 8,
          width: tamanhoDoBotao.value * 26,
          duration: Duration(microseconds: 5),
          child: RaisedButton(
            color: color,
            onPressed: onPressed,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
            child: Text(
              text, style: TextStyle(
                fontSize: 15.0,
                color: textColor,
                fontWeight: FontWeight.bold,
              ),
            )
          ),
        ),
      ),
    );
  }
  
  Widget _buildMovimentoCaixaRow({@required String descricao, @required String value}){
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Container(
                  width: 2,
                  height: 15,
                  color: Theme.of(context).primaryIconTheme.color,
                ),
              ),
              Text(descricao, style: Theme.of(context).textTheme.body2),
            ],
          ),
          Container(
            child: Text(value, style: Theme.of(context).textTheme.body2),
          )
        ],
      ),
    );
  }

  bool permiteMovimentoDoDia() {
    if(_movimentoCaixaBloc.movimentoCaixa.dataAbertura != null){
      if(_movimentoCaixaBloc.movimentoCaixa.dataAbertura.difference(DateTime.now()).inHours <= 23){
        return true;
      } else {
        return false;
      }
    }
  }
  
  animacaoFloatingActionButton(){
    if (!expandido) {
      controller.forward();
    } else {
      controller.reverse();
    }
    expandido = !expandido;
  } 
}