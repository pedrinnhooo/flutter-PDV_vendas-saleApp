import 'dart:convert';
import 'dart:io';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:camera/camera.dart';
import 'package:dio/dio.dart';
import 'package:fluggy/generated/locale_base.dart';
import 'package:fluggy/src/app_module.dart';
import 'package:fluggy/src/pages/cadastro/produto/list/produto_codigo_barras_list_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_circle_color_picker/flutter_circle_color_picker.dart';
import 'package:flutter_colorpicker/utils.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:fluggy/src/pages/cadastro/categoria/categoria_module.dart';
import 'package:fluggy/src/pages/cadastro/grade/grade_module.dart';
import 'package:fluggy/src/pages/cadastro/produto/produto_module.dart';
import 'package:fluggy/src/pages/cadastro/variante/variante_module.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:common_files/common_files.dart';

class ProdutoDetailPage extends StatefulWidget {
  Produto produto;

  ProdutoDetailPage({this.produto});

  @override
  _ProdutoDetailPageState createState() => _ProdutoDetailPageState();
}

class _ProdutoDetailPageState extends State<ProdutoDetailPage> with SingleTickerProviderStateMixin {
  ScrollController _scrollController;
  CameraController _controller;
  TabController _tabController;
  Future<void> _initializeControllerFuture;
  ProdutoBloc produtoBloc;
  AppGlobalBloc appGlobalBloc;
  ConsultaEstoqueBloc consultaEstoqueBloc;
  TextEditingController nomeController, idAparenteController, nomeAvatarController, codigoBarrasController;
  MoneyMaskedTextController precoCustoController, precoVendaController;
  CategoriaModule categoriaModule;
  GradeModule gradeModule;
  VarianteModule varianteModule;
  ProdutoEstoqueVariantePage produtoEstoqueVariantePage;
  ProdutoEstoqueGradePage produtoEstoqueGradePage;

  var firstCamera;

  @override
  void initState() {
    produtoBloc = ProdutoModule.to.getBloc<ProdutoBloc>();
    consultaEstoqueBloc = AppModule.to.getBloc<ConsultaEstoqueBloc>();
    appGlobalBloc = AppModule.to.getBloc<AppGlobalBloc>();
    categoriaModule = ProdutoModule.to.getDependency<CategoriaModule>();
    gradeModule = ProdutoModule.to.getDependency<GradeModule>();
    varianteModule = ProdutoModule.to.getDependency<VarianteModule>();
    produtoEstoqueGradePage = ProdutoEstoqueGradePage();
    produtoEstoqueVariantePage = ProdutoEstoqueVariantePage();
    produtoBloc.dateTimeProdutoImagem = DateTime.now().toIso8601String();
    if(widget.produto != null){
      produtoBloc.produto = widget.produto;
      consultaEstoqueBloc.produto = produtoBloc.produto;
      produtoBloc.updateProdutoStream();
      //consultaEstoqueBloc.updateProdutoStream();
    }
    _tabController = TabController(vsync: this, length: 2, initialIndex: 0);
    _tabController.addListener(_handleTabSelection);

    nomeController = TextEditingController();
    codigoBarrasController = TextEditingController();
    nomeAvatarController = TextEditingController();
    idAparenteController = TextEditingController();
    precoCustoController = MoneyMaskedTextController(initialValue: produtoBloc.produto.precoCusto == null ? 0.0 : produtoBloc.produto.precoCusto , leftSymbol: "R\$ ", decimalSeparator: ',', thousandSeparator: '.');
    precoVendaController = MoneyMaskedTextController(initialValue: (produtoBloc.produto.precoTabelaItem == null) || (produtoBloc.produto.precoTabelaItem.length == 0) ? 
                                                                    0.0 : produtoBloc.produto.precoTabelaItem[0].preco , leftSymbol: "R\$ ", decimalSeparator: ',', thousandSeparator: '.');
    idAparenteController.value = idAparenteController.value.copyWith(text: produtoBloc.produto.idAparente == null ? 
                                                                           produtoBloc.configuracaoCadastro.ehProdutoAutoInc != 0 ? 
                                                                           "**novo**" : "" : produtoBloc.produto.idAparente);
    nomeController.value = nomeController.value.copyWith(text: produtoBloc.produto.nome == null ? "" : produtoBloc.produto.nome); 
    nomeAvatarController.value = nomeAvatarController.value.copyWith(text: produtoBloc.produto.nome == null ? "" : produtoBloc.produto.nome); 
    codigoBarrasController.value =  codigoBarrasController.value.copyWith(text: ((produtoBloc.produto.produtoCodigoBarras.length > 0) &&
                                                                                 (produtoBloc.produto.produtoCodigoBarras[0].codigoBarras != null)) ? 
                                                                                 produtoBloc.produto.produtoCodigoBarras[0].codigoBarras : ""); 
    if(produtoBloc.produto.idGrade == null){
      produtoBloc.produto.grade = null;
    }
    
    if (produtoBloc.produto.grade != null) {
      if (produtoBloc.produto.produtoVariante.length > 0) {
        produtoBloc.produtoEstoquePageController = PageController(initialPage: 1);
        produtoBloc.lastPageController = 1;
      } else {
        produtoBloc.produtoEstoquePageController = PageController(initialPage: 2);
        produtoBloc.lastPageController = 2;
      }
    } else {
      if (produtoBloc.produto.produtoVariante.length > 0) {
        produtoBloc.produtoEstoquePageController = PageController(initialPage: 1);
        produtoBloc.lastPageController = 1;
      } else {
        produtoBloc.produtoEstoquePageController = PageController(initialPage: 0);
        produtoBloc.lastPageController = 0;
      }  
    }

    consultaEstoqueBloc.resetBloc();
    consultaEstoqueBloc.produtoVarianteSelecionado = null;

    super.initState();
  } 

  void _handleTabSelection () async {
    produtoBloc.updateProdutoStream();
    if(!_tabController.indexIsChanging) {
      if (consultaEstoqueBloc.movimentoEstoqueList == null || consultaEstoqueBloc.movimentoEstoqueList.length == 0) {       
        consultaEstoqueBloc.produto = produtoBloc.produto;
        await consultaEstoqueBloc.getAllEstoque();
        if (produtoBloc.produto.produtoVariante.length > 0) {
          await consultaEstoqueBloc.consultaVariante();
        } else if (produtoBloc.produto.grade != null) {
          await consultaEstoqueBloc.consultaGrade(ehEdicaoEstoque: true);
        } else {
          await consultaEstoqueBloc.consultaEstoqueTotal(ehEdicaoEstoque: true);  
        }
      }  
    }    
  }
  
  @override
  Widget build(BuildContext context) {
    final locale = Localizations.of<LocaleBase>(context, LocaleBase);
    _scrollController = ScrollController();
    return Scaffold(
    resizeToAvoidBottomInset: true,
    appBar: AppBar(
      title: Text(locale.cadastroProduto.titulo, 
        style: Theme.of(context).textTheme.title,
      ),
      actions: <Widget>[
        Padding(
          padding: const EdgeInsets.all(15),
          child: InkWell(
            child: Text(produtoBloc.produto.id != null ? locale.palavra.excluir : locale.palavra.limpar,
              style: TextStyle(
                fontStyle: Theme.of(context).textTheme.subhead.fontStyle,
                fontSize: Theme.of(context).textTheme.subhead.fontSize,
                color: Theme.of(context).primaryIconTheme.color
              ),
            ),
            onTap: () async {
              if (produtoBloc.produto.id != null) {
                showDialog(
                  context: context,
                  builder: (BuildContext context) => CustomDialogConfirmation(
                    title: locale.palavra.confirmacao,
                    description: locale.mensagem.confirmarExcluirRegistro +
                      locale.palavra.artigo_a + " " +
                      locale.cadastroProduto.titulo.toLowerCase() + " ",
                    item: produtoBloc.produto.nome ,
                    buttonOkText: locale.palavra.excluir,
                    buttonCancelText: locale.palavra.cancelar,
                    funcaoBotaoOk: () async {
                      await produtoBloc.deleteProduto();
                      await produtoBloc.getAllProduto();
                      Navigator.pop(context);
                      Navigator.pop(context);
                    },
                    funcaoBotaoCancelar: () async {
                      Navigator.pop(context);
                    }
                  ),
                );
              } else {
                await produtoBloc.newProduto();
                nomeController.clear();
              }
            },
          ),
        ),
      ],
    ),      
    body: Container(
      color: Theme.of(context).primaryColor,
      child: Column(
        children: <Widget>[
          Expanded(
            child: Container(
              padding: EdgeInsets.only(left: 10, right: 10, bottom: 10),  
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Theme.of(context).accentColor,
                ),
                child: Column(
                  children: <Widget>[
                    StreamBuilder<Produto>(
                      stream: produtoBloc.produtoOut,
                      builder: (context, snapshot) {
                        if(!snapshot.hasData){
                          return CircularProgressIndicator();
                        }
                        Produto produto = snapshot.data;

                        return AnimatedContainer(
                          curve: Curves.easeIn,
                          duration: Duration(milliseconds: 200),
                          width: double.infinity,
                          height: _tabController.index == 0 ? 210 : 150,
                          child: Stack(
                            children: <Widget>[
                              TabBar(
                                indicatorWeight: 1,
                                indicatorSize: TabBarIndicatorSize.label,
                                controller: _tabController,
                                tabs: <Widget>[
                                  Tab(
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text("Produto", 
                                      )
                                    ),
                                  ),
                                  Tab(
                                    child: Align(
                                      alignment: Alignment.centerRight,
                                      child: Text("Estoque", 
                                      )
                                    ),
                                  ),
                                ],
                              ),
                              Align(
                                alignment: Alignment.bottomCenter,
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 55.0, right: 8, left: 8),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).primaryColor,
                                      borderRadius: BorderRadius.circular(10)
                                    ),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: <Widget>[
                                        AnimatedSwitcher(
                                          switchInCurve: Curves.easeIn,
                                          switchOutCurve: Curves.easeOut,
                                          duration: Duration(milliseconds: 100),
                                          transitionBuilder: (Widget child, Animation<double> animation){
                                            return FadeTransition(
                                              opacity: animation,
                                              child: child,
                                            );
                                          },
                                          child: _tabController.index == 0 ? Container(
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                                              crossAxisAlignment: CrossAxisAlignment.end,
                                              children: <Widget>[
                                                InkWell(
                                                  child: Container(
                                                    width: 50,
                                                    height: 20,
                                                    child: Icon(Icons.camera_alt, size: 30, color: Colors.white)
                                                  ),
                                                  onTap: () async {
                                                    produtoBloc.deleteImagem();
                                                    abreCamera();
                                                  }
                                                ),
                                                SizedBox.shrink(),
                                                produto.produtoImagem.length > 0 && produto.produtoImagem.first.ehDeletado == 0
                                                ? Align(
                                                    alignment: Alignment.bottomCenter,
                                                    child: InkWell(
                                                      child: Container(
                                                        width: 50,
                                                        height: 20,
                                                        child: Icon(Icons.close, size: 30, color: Colors.white,)
                                                      ),
                                                      onTap: () {
                                                        produtoBloc.produto.produtoImagem.first.ehDeletado = 1;
                                                        produtoBloc.novaImagem = false;
                                                        produtoBloc.updateProdutoStream();
                                                      },
                                                    )
                                                  ) 
                                                : Align(
                                                  alignment: Alignment.bottomCenter,
                                                    child: InkWell(
                                                    child: Container(
                                                      width: 50,
                                                      height: 20,
                                                      child: Icon(Icons.color_lens, size: 30, color: Colors.white,)
                                                    ),
                                                    onTap: () {
                                                      showDialog(
                                                        context: context,
                                                        builder: (BuildContext context) {
                                                          return AlertDialog(
                                                            backgroundColor: Theme.of(context).accentColor,
                                                            titlePadding: const EdgeInsets.all(0.0),
                                                            contentPadding: const EdgeInsets.all(0.0),
                                                            content: SingleChildScrollView(
                                                              child: Center(
                                                                child: CircleColorPicker(
                                                                  initialColor: Colors.blue,
                                                                  onChanged: (color) {
                                                                    produto.iconeCor = color.toString().replaceAll('Color(', '').replaceAll(")", "").toUpperCase();
                                                                    produtoBloc.updateProdutoStream();
                                                                  },
                                                                  size: const Size(240, 240),
                                                                  strokeWidth: 4,
                                                                  thumbSize: 36,
                                                                ),
                                                              ),
                                                            ),
                                                            actions: <Widget>[
                                                              FlatButton(
                                                                color: Theme.of(context).primaryIconTheme.color,
                                                                child: Text("OK"),
                                                                onPressed: () {
                                                                  Navigator.pop(context);
                                                                },
                                                              )
                                                            ],
                                                          );
                                                        },
                                                      );
                                                    },
                                                  ),
                                                ),
                                              ]
                                            ),
                                          ) : SizedBox.shrink()
                                        ),
                                        Visibility(
                                          visible: false,
                                          replacement: Container(),
                                          child: Padding(
                                            padding: EdgeInsets.only(top: _tabController.index == 0 ? 30: 40),
                                            child: Container(
                                              alignment: Alignment.center,
                                              child: Visibility(
                                                visible: _tabController.index == 0,
                                                child: AnimatedSwitcher(
                                                  switchInCurve: Curves.easeIn,
                                                  switchOutCurve: Curves.easeOut,
                                                  duration: Duration(milliseconds: 300),
                                                  transitionBuilder: (Widget child, Animation<double> animation){
                                                    return FadeTransition(
                                                      opacity: animation,
                                                      child: child,
                                                    );
                                                  },
                                                  child: _tabController.index == 0 ? StreamBuilder<bool>(
                                                    initialData: false,
                                                    stream: produtoBloc.idAparenteInvalidoOut,
                                                    builder: (context, snapshot) {
                                                      return Column(
                                                        mainAxisSize: MainAxisSize.min,
                                                        children: <Widget>[
                                                          Text("CÓDIGO", style: Theme.of(context).textTheme.body2,),
                                                          Container(
                                                            height: 15,
                                                            padding: EdgeInsets.symmetric(horizontal: 40),
                                                            child: TextField(
                                                              textAlign: TextAlign.center,
                                                              autofocus: produtoBloc.configuracaoCadastro.ehProdutoAutoInc == 0 ? produtoBloc.produto.idAparente == null ? true : false : false,
                                                              enabled: (produtoBloc.configuracaoCadastro.ehProdutoAutoInc == 0) && (produtoBloc.produto.idAparente == null),
                                                              controller: idAparenteController,
                                                              keyboardType: TextInputType.text,
                                                              obscureText: false,
                                                              style: Theme.of(context).textTheme.subtitle,
                                                              decoration: InputDecoration(
                                                                contentPadding: EdgeInsets.all(8),
                                                                hintStyle: Theme.of(context).textTheme.subhead,
                                                                labelStyle: Theme.of(context).textTheme.subhead,
                                                                errorText: snapshot.data ? locale.mensagem.codigoInvalido : null,
                                                                errorStyle: Theme.of(context).textTheme.body2,
                                                                errorBorder: UnderlineInputBorder(
                                                                  borderSide: BorderSide(
                                                                    color: Colors.white38
                                                                  ),
                                                                ),
                                                                focusedErrorBorder: UnderlineInputBorder(
                                                                  borderSide: BorderSide(
                                                                    color: Colors.white38
                                                                  ),
                                                                ),
                                                                enabledBorder: UnderlineInputBorder(
                                                                  borderSide: BorderSide(
                                                                    color: Colors.white38
                                                                  ),
                                                                ),
                                                                focusedBorder: UnderlineInputBorder(
                                                                  borderSide: BorderSide(
                                                                    color: Colors.white
                                                                  )
                                                                )
                                                              ),
                                                              onChanged: (text){
                                                                produtoBloc.produto.idAparente = text;
                                                                produtoBloc.updateProdutoStream();
                                                              },
                                                            ),
                                                          ),
                                                        ],
                                                      );
                                                    }
                                                  ) : SizedBox.shrink()
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        AnimatedSwitcher(
                                          switchInCurve: Curves.easeIn,
                                          switchOutCurve: Curves.easeIn,
                                          duration: Duration(milliseconds: 300),
                                          transitionBuilder: (Widget child, Animation<double> animation){
                                            return FadeTransition(
                                              opacity: animation,
                                              child: child,
                                            );
                                          },
                                          child: _tabController.index == 0 ? StreamBuilder<bool>(
                                            initialData: false,
                                            stream: produtoBloc.nomeInvalidoOut,
                                            builder: (context, snapshot) {
                                              return Padding(
                                                padding: const EdgeInsets.only(top: 50),
                                                child: Container(
                                                  height: 50,
                                                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 2),
                                                  child: TextField(
                                                    textAlign: TextAlign.center,
                                                    enabled: _tabController.index == 0,
                                                    controller: nomeController,
                                                    keyboardType: TextInputType.text,
                                                    obscureText: false,
                                                    style: Theme.of(context).textTheme.subtitle,
                                                    decoration: InputDecoration(
                                                      contentPadding: EdgeInsets.all(8),
                                                      hintText: locale.palavra.nome,
                                                      hintStyle: Theme.of(context).textTheme.subhead,
                                                      labelStyle: Theme.of(context).textTheme.subhead,
                                                      errorText: snapshot.data ? locale.mensagem.nomeNaoNulo : null,
                                                      errorStyle: TextStyle(
                                                        fontStyle: Theme.of(context).textTheme.body2.fontStyle,
                                                        color: Colors.red
                                                      ),
                                                      errorBorder: UnderlineInputBorder(
                                                        borderSide: BorderSide(
                                                          color: Colors.white38
                                                        ),
                                                      ),
                                                      focusedErrorBorder: UnderlineInputBorder(
                                                        borderSide: BorderSide(
                                                          color: Colors.white38
                                                        ),
                                                      ),
                                                      enabledBorder: UnderlineInputBorder(
                                                        borderSide: BorderSide(
                                                          color: Colors.white38
                                                        ),
                                                      ),
                                                      focusedBorder: UnderlineInputBorder(
                                                        borderSide: BorderSide(
                                                          color: Colors.white
                                                        )
                                                      )
                                                    ),
                                                    onChanged: (text){
                                                      produtoBloc.produto.nome = text;
                                                      produtoBloc.updateProdutoStream();
                                                      if(text.length > 0 && text.length == 1){
                                                        produtoBloc.nomeInvalido = false;
                                                        produtoBloc.nomeInvalidoController.add(false);
                                                      }
                                                    },
                                                  ),
                                                ),
                                              );
                                            }
                                          ) : SizedBox.shrink()
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 15.0),
                                child: Align(
                                  alignment: Alignment.topCenter,
                                  child: Container(
                                    width: 120,
                                    height: 120,
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).accentColor,
                                      borderRadius: BorderRadius.all(Radius.circular(8)),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black,
                                          spreadRadius: 0.01
                                        )
                                      ]
                                    ),
                                    child: Stack(
                                      children: <Widget>[
                                      produto.produtoImagem.length > 0 && produto.produtoImagem.first.ehDeletado == 0
                                        ? produtoBloc.novaImagem 
                                          ? ClipRRect(
                                              borderRadius: BorderRadius.circular(12),
                                              child: Image.file(File(produtoBloc.path),
                                                gaplessPlayback: true,
                                                fit: BoxFit.cover, 
                                                width: 120,
                                                height: 120,
                                              ),
                                            ) 
                                          : StreamBuilder(
                                              stream: getImageFromServer(produto.produtoImagem.first.imagem).asStream(),
                                              builder: (context, snapshot) {
                                                return AnimatedOpacity(
                                                  duration: Duration(milliseconds: 200),
                                                  opacity: snapshot.hasData ? 1.0 : 0.0,
                                                  child: ClipRRect(
                                                    borderRadius: BorderRadius.circular(8),
                                                    child: snapshot.hasData ? Image.memory(base64Decode(snapshot.data),
                                                      gaplessPlayback: true,
                                                      fit: BoxFit.cover, 
                                                      width: 120,
                                                      height: 120,
                                                    ) : SizedBox.shrink(),
                                                  )
                                                );
                                              }
                                            )
                                        : ClipRRect(
                                          borderRadius: BorderRadius.circular(12),
                                          child: Container(
                                            color: Color(int.parse(produto.iconeCor)),
                                            child: Center(
                                              child: TextFormField(
                                                maxLength: 8,
                                                controller: nomeAvatarController,
                                                decoration: InputDecoration(
                                                  counterText: '',
                                                  border: InputBorder.none,
                                                  hintText: nomeAvatarController.text.length <= 0 ? nomeController.text : "" 
                                                ),
                                                maxLines: 1,
                                                style: TextStyle(
                                                color: useWhiteForeground(Color(int.parse(produto.iconeCor)))
                                                  ? const Color(0xffffffff)
                                                  : const Color(0xff000000), 
                                                  fontSize: 23,
                                                  fontWeight: FontWeight.w500
                                                ),
                                                onChanged: (text) {
                                                  produtoBloc.produto.nome = text;
                                                },
                                              ),
                                            ),
                                          )
                                        ),
                                        Column(
                                          crossAxisAlignment:CrossAxisAlignment.start,
                                          mainAxisAlignment:MainAxisAlignment.end,
                                          children: <Widget>[
                                            Container(
                                              padding: EdgeInsets.only(left: 3),
                                              width: double.infinity,
                                              color: Theme.of(context).primaryColor.withOpacity(0.5),
                                              child: Align(
                                                alignment: Alignment.bottomLeft,
                                                child: Text("${produto.nome}",
                                                  style: TextStyle(
                                                    fontSize:12.0,
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.w500, 
                                                    letterSpacing: 0.8),
                                                ),
                                              ),
                                            ),
                                            Container(
                                              padding: EdgeInsets.only(left: 3),
                                              width: double.infinity,
                                              color: Theme.of(context).primaryColor.withOpacity(0.5),
                                              child: Align(
                                                child: Text("${precoVendaController.text}",
                                                  style: TextStyle(fontSize:12.0, color: Colors.white, fontWeight: FontWeight.w500, letterSpacing: 0.8)),
                                                alignment: Alignment.bottomLeft,
                                              )
                                            )  
                                          ],
                                        )
                                      ]
                                    )
                                  )
                                ),
                              ),
                            ],
                          ),
                        );
                      }
                    ),
                    Expanded(
                      child: TabBarView(
                        controller: _tabController,
                        children: <Widget>[    
                          SingleChildScrollView(
                            controller: _scrollController,
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 10, right: 10),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Visibility(
                                          visible: true,
                                          child: StreamBuilder<bool>(
                                            initialData: false,
                                            stream: produtoBloc.precoVendaInvalidoOut,
                                            builder: (context, snapshot) {
                                              return numberTextField(
                                                context,
                                                autofocus: produtoBloc.produto.precoTabelaItem.length > 0 ? false : true,
                                                controller: precoVendaController,
                                                labelText: locale.palavra.precoVenda,
                                                errorText: snapshot.data ? locale.mensagem.precoVendaInvalido : null,
                                                onChanged: (text) {
                                                  produtoBloc.produto.precoTabelaItem.first.preco = double.parse(precoVendaController.text.replaceAll("R\$", "").replaceAll(".", "").replaceAll(",", "."));
                                                }   
                                              );
                                            }
                                          ),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Visibility(
                                          visible: true,
                                          child: StreamBuilder<bool>(
                                            initialData: false,
                                            stream: produtoBloc.precoCustoInvalidoOut,
                                            builder: (context, snapshot) {
                                              return numberTextField(
                                                context,
                                                autofocus: produtoBloc.produto.precoCusto != null ? false : true,
                                                controller: precoCustoController,
                                                labelText: locale.palavra.precoCusto,
                                                errorText: snapshot.data ? locale.mensagem.precoCustoInvalido : null,
                                                onChanged: (text) {
                                                  produtoBloc.produto.precoCusto = double.parse(precoCustoController.text.replaceAll("R\$", "").replaceAll(".", "").replaceAll(",", "."));
                                                }   
                                              );
                                            }
                                          ),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        StreamBuilder<bool>(
                                          initialData: false,
                                          stream: produtoBloc.categoriaInvalidaOut,
                                          builder: (context, snapshot) {
                                            return Column(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: <Widget>[
                                                Container(
                                                  alignment: Alignment.topLeft,
                                                  child: Text(locale.cadastroCategoria.titulo,
                                                    style: Theme.of(context).textTheme.body2,
                                                  ),
                                                ),
                                                InkWell(
                                                  child: Container(
                                                    alignment: Alignment.topLeft,
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: <Widget>[
                                                        Text(produtoBloc.produto.categoria.nome != null ? produtoBloc.produto.categoria.nome : locale.palavra.selecione,
                                                          style: Theme.of(context).textTheme.subhead,
                                                        ),
                                                        Icon(
                                                          Icons.arrow_forward_ios,
                                                          color: Theme.of(context).cursorColor,
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                  onTap: () {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        settings: RouteSettings(name: '/ListaCategoria'),
                                                        builder: (context) {
                                                          return categoriaModule;
                                                        }  
                                                      ),
                                                    );
                                                  },  
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.only(top: 2),
                                                  child: Divider(color: Colors.white,),
                                                ),
                                                Visibility(
                                                  visible: snapshot.data,
                                                  child: Row(
                                                    children: <Widget>[
                                                      Text(
                                                        "Selecione uma categoria",
                                                        style: TextStyle(
                                                          fontStyle: Theme.of(context).textTheme.body2.fontStyle,
                                                          fontSize: Theme.of(context).textTheme.body2.fontSize,
                                                          color: Colors.red
                                                        )
                                                      ),
                                                    ],
                                                  ),
                                                )
                                              ],
                                            );
                                          }
                                        ),
                                        Visibility(
                                          visible: false,
                                          child: FutureBuilder(
                                            future: appGlobalBloc.getModuloAcesso(ModuloEnum.grade),
                                            builder: (context, snapshot) {
                                              return AnimatedSwitcher(
                                                switchInCurve: Curves.easeIn,
                                                switchOutCurve: Curves.easeOut,
                                                duration: Duration(milliseconds: 200),
                                                child: snapshot.connectionState == ConnectionState.done && snapshot.hasData && snapshot.data == true
                                                ? InkWell(
                                                    child: Column(
                                                      children: <Widget>[
                                                        Container(
                                                          alignment: Alignment.topLeft,
                                                          child: Text(locale.cadastroGrade.titulo,
                                                          style: Theme.of(context).textTheme.body2,
                                                          ),
                                                        ),
                                                        Container(
                                                          alignment: Alignment.topLeft,
                                                          child: Row(
                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                            children: <Widget>[
                                                              StreamBuilder<bool>(
                                                                initialData: false,
                                                                stream: produtoBloc.gradeInvalidaOut,
                                                                builder: (context, snapshot) {
                                                                  return Text(produtoBloc.produto.grade != null && produtoBloc.produto.grade.nome != null ? produtoBloc.produto.grade.nome : locale.palavra.selecione,
                                                                    style: Theme.of(context).textTheme.subhead,
                                                                  );
                                                                }
                                                              ),
                                                              produtoBloc.produto.grade == null 
                                                              ? Icon(
                                                                  Icons.arrow_forward_ios,
                                                                  color: Theme.of(context).cursorColor,
                                                                )
                                                              : Icon(
                                                                  Icons.close,
                                                                  color: Theme.of(context).cursorColor,
                                                                )
                                                            ],
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding: const EdgeInsets.only(top: 2),
                                                          child: Divider(color: Colors.white,),
                                                        )
                                                      ],
                                                    ),
                                                    onTap: () {
                                                      produtoBloc.produto.grade == null 
                                                      ? Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                            settings: RouteSettings(name: '/ListaGrade'),
                                                            builder: (context) {
                                                              return gradeModule;
                                                            }  
                                                          ),
                                                        )
                                                      : produtoBloc.deleteGrade();
                                                    },
                                                  ) 
                                                : SizedBox.shrink()
                                              );
                                            }
                                          ),
                                        ),
                                        Visibility(
                                          visible: false,
                                          child: FutureBuilder(
                                            future: appGlobalBloc.getModuloAcesso(ModuloEnum.variante),
                                            builder: (context, snapshot) {
                                              return AnimatedSwitcher(
                                                switchInCurve: Curves.easeIn,
                                                switchOutCurve: Curves.easeOut,
                                                duration: Duration(milliseconds: 200),
                                                child: snapshot.connectionState == ConnectionState.done && snapshot.hasData && snapshot.data 
                                                ? Column(
                                                    children: <Widget>[
                                                      InkWell(
                                                        child: Container(
                                                          padding: EdgeInsets.only(top: 10),
                                                          alignment: Alignment.topLeft,
                                                          child: Row(
                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                            children: <Widget>[
                                                              Text(locale.cadastroVariante.titulo,
                                                                style: Theme.of(context).textTheme.subhead,
                                                              ),
                                                              Row(
                                                                children: <Widget>[
                                                                  Padding(
                                                                    padding: const EdgeInsets.only(right: 5),
                                                                    child: Text(produtoBloc.varianteList.length > 0 ?
                                                                      produtoBloc.varianteList.length.toString() : "",
                                                                      style: Theme.of(context).textTheme.subhead
                                                                    ),
                                                                  ),
                                                                  Icon(
                                                                    Icons.arrow_forward_ios,
                                                                    color: Theme.of(context).cursorColor,
                                                                  ),
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        onTap: () {
                                                          Navigator.push(context,
                                                            MaterialPageRoute(
                                                              settings: RouteSettings(name: '/ListaVariante'),
                                                              builder: (context) => varianteModule
                                                            )
                                                          );
                                                        },  
                                                      ),
                                                      SizedBox(
                                                        height: 20,
                                                        child: Padding(
                                                          padding: const EdgeInsets.only(top: 2),
                                                          child: Divider(color: Colors.white,),
                                                        )
                                                      ), 
                                                    ] 
                                                  ) 
                                                : SizedBox.shrink()
                                              );
                                            }
                                          ),
                                        ),
                                        Visibility(
                                          visible: false,
                                          child: InkWell(
                                            child: Container(
                                              padding: EdgeInsets.only(top: 10),
                                              alignment: Alignment.topLeft,
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: <Widget>[
                                                  Text("Código de barras",
                                                    style: Theme.of(context).textTheme.body2,
                                                  ),
                                                  Row(
                                                    children: <Widget>[
                                                      Padding(
                                                        padding: const EdgeInsets.only(right: 5),
                                                        child: Text(produtoBloc.produto.produtoCodigoBarras.length > 0 ?
                                                          produtoBloc.produto.produtoCodigoBarras.length.toString() : "",
                                                          style: Theme.of(context).textTheme.subhead
                                                        ),
                                                      ),
                                                      Icon(
                                                        Icons.arrow_forward_ios,
                                                        color: Theme.of(context).cursorColor,
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                            onTap: () {
                                              Navigator.push(context,
                                                MaterialPageRoute(
                                                  builder: (context) => ProdutoCodigoBarrasListPage()
                                                )
                                              );
                                            },  
                                          ),
                                        ),
                                        Visibility(
                                          visible: true,
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              Container(
                                                child: Expanded(
                                                  child: StreamBuilder<bool>(
                                                    initialData: false,
                                                    stream: produtoBloc.codigoBarrasInvalidoOut,
                                                    builder: (context, snapshot) {
                                                      return customTextField(
                                                        context,
                                                        controller: codigoBarrasController,
                                                        labelText: "Código de barras",
                                                        errorText: snapshot.data ? "Código de barras já cadastrado" : null,
                                                        onChanged: (text) {
                                                          if (produtoBloc.produto.produtoCodigoBarras.length == 0) {
                                                            produtoBloc.produto.produtoCodigoBarras.add(ProdutoCodigoBarras());
                                                          }
                                                          produtoBloc.produto.produtoCodigoBarras[0].codigoBarras = text;
                                                        });
                                                      }
                                                    ),
                                                  ),
                                                ),    
                                                InkWell(
                                                  child: Image.asset(
                                                    'assets/codBarrasIcon.png',
                                                    color: Colors.white,
                                                    fit: BoxFit.contain,
                                                    height: 40,
                                                    width: 40,
                                                  ),
                                                  onTap: () async {
                                                    try {
                                                      String barcodeScanRes = await FlutterBarcodeScanner.scanBarcode("#${Colors.red.value.toRadixString(16)}", "Cancelar", false, ScanMode.BARCODE);
                                                      print("Barcode: "+barcodeScanRes); 
                                                      if (barcodeScanRes != "" && barcodeScanRes != "-1") {
                                                        if (produtoBloc.produto.produtoCodigoBarras.length == 0) {
                                                          produtoBloc.produto.produtoCodigoBarras.add(ProdutoCodigoBarras());
                                                        }
                                                        produtoBloc.produto.produtoCodigoBarras[0].codigoBarras = barcodeScanRes;
                                                        codigoBarrasController.value = codigoBarrasController.value.copyWith(
                                                                                          text: produtoBloc.produto.produtoCodigoBarras[0].codigoBarras
                                                                                        );
                                                      }
                                                    } catch (error) {
                                                      
                                                    }  
                                                  },  
                                                )  
                                              ],
                                            )
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              Text("Estoque", style: Theme.of(context).textTheme.subhead),
                                              Switch(
                                                value: true,
                                                activeColor: Theme.of(context).primaryIconTheme.color,
                                                onChanged: (value) {
                                                  print("$value");
                                                },
                                              )
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            PageView(
                              physics: NeverScrollableScrollPhysics(),
                              controller: produtoBloc.produtoEstoquePageController,
                              children: <Widget>[
                                //Paginas
                                ProdutoEstoquePage(),
                                produtoEstoqueVariantePage,
                                produtoEstoqueGradePage,
                              ],
                            ),
                          ]
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        child: customButtomGravar(
                          buttonColor: Theme.of(context).primaryIconTheme.color,
                          text: Text(locale.palavra.gravar,
                            style: Theme.of(context).textTheme.title,
                          ),
                          onPressed: () async {
                            await produtoBloc.validaCampos();
                            if (!produtoBloc.formInvalido){
                              consultaEstoqueBloc.produtoController.add(produtoBloc.produto);
                              await produtoBloc.saveProduto();
                              //await produtoBloc.getAllProduto();
                              Navigator.pop(context);
                            } else {
                              print("Error form invalido: ");
                            }
                            _scrollController.animateTo(
                              200,
                              curve: Curves.easeOut,
                              duration: const Duration(milliseconds: 300),
                            );
                          }
                        )
                      )
                    ]  
                  )
                )    
              ),
            )
          ],
        ),
      ),
    );
  }

  Future getImageFromServer(String path) async {
    try {
      Response response = await Dio().get('$s3Endpoint$path',
        options: Options(
          responseType: ResponseType.bytes
        )
      );
      return base64.encode(response.data);
    } catch (e) {
      print("Erro ao consultar a imagem no servidor.");
    }
  }

  abreCamera() async {
    List<CameraDescription> cameras;
    try {
      cameras = await availableCameras();
      firstCamera = cameras.first;
        _controller = CameraController(
        firstCamera,
        ResolutionPreset.low,
        enableAudio: false
      );
      _initializeControllerFuture = _controller.initialize();
      showDialog(
      context: this.context,
      builder: (context){
        return Scaffold(
          body: FutureBuilder<void>(
            future: _initializeControllerFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                final size = MediaQuery.of(context).size;
                return ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    child: Transform.scale(
                      scale: _controller.value.aspectRatio / size.aspectRatio,
                      child: Center(
                        child: AspectRatio(
                          aspectRatio: _controller.value.aspectRatio,
                          child: CameraPreview(_controller),
                        ),
                      ),
                    ),
                  ),
                );
              } else {
                return Center(child: CircularProgressIndicator());
              }
            },
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
          floatingActionButton: FloatingActionButton(
            child: Icon(Icons.camera_alt),
            onPressed: () async {
              try {
                await _initializeControllerFuture;
                final path = join((await getTemporaryDirectory()).path,
                  '${DateTime.now()}.png',
                );
                await _controller.takePicture(path);
                produtoBloc.addImagem(path);
                produtoBloc.updateProdutoStream();
                Navigator.pop(context);
              } catch (e) {
                print(e);
              }
            },
          ),
        );
      }
    );
    } catch (e) {
      print("Erro nas permissões de acesso ou inicialização da camera do aparelho. ERRO: $e");
    }
  } 

  @override
  void dispose() {
    print("Dispose Produto Detail");
    produtoBloc.limpaValidacoes();
    produtoEstoqueGradePage = null;
    produtoEstoqueVariantePage = null;
    consultaEstoqueBloc.resetBloc();
    super.dispose();
  }   
}

class ProdutoEstoquePage extends StatelessWidget {

  final ConsultaEstoqueBloc consultaEstoqueBloc = AppModule.to.getBloc<ConsultaEstoqueBloc>();
  final ProdutoBloc produtoBloc = ProdutoModule.to.getBloc<ProdutoBloc>();
  bool _firstDig;

  ProdutoEstoquePage() {
    consultaEstoqueBloc.produto = produtoBloc.produto;
    _firstDig = true;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        InkWell(
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 5,
              ),
              Visibility(
                visible: consultaEstoqueBloc.produtoVarianteSelecionado != null || consultaEstoqueBloc.produto.grade != null,
                child: Row(
                  children: <Widget>[
                    InkWell(
                      child: Container(
                        padding: EdgeInsets.only(left: 15, right: 8, bottom: 20),
                        child: Icon(
                          Icons.arrow_back,
                          size: 25,
                          color: Colors.white,
                        ),
                      ),
                      onTap: () {
                      produtoBloc.produtoEstoquePageController.jumpToPage(produtoBloc.lastPageController.toInt());
                      },
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 5, bottom: 20),
                      child: StreamBuilder<String>(
                        stream: consultaEstoqueBloc.labelVarianteTamanhoControllerOut,
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return Center(child: CircularProgressIndicator());
                          }
                          String _labelVarianteTamanho = snapshot.data;
                          return Text(
                            _labelVarianteTamanho != null ? "$_labelVarianteTamanho " : "",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold                      
                            ),
                          );
                        }
                      )
                    ),
                  ],
                ),
              ),
              StreamBuilder<int>(
                initialData: 0,
                stream: consultaEstoqueBloc.estoqueDigitadoControllerOut,
                builder: (context, snapshot) {
                  int _estoqueDigitado = snapshot.data;
                  return StreamBuilder<int>(
                    stream: consultaEstoqueBloc.oldEstoqueControllerOut,
                    builder: (context, snapshot) {
                      if(!snapshot.hasData){
                        return CircularProgressIndicator();
                      }
                      int _oldEstoque = snapshot.data;
                      return StreamBuilder<String>(
                        initialData: "Somar",
                        stream: consultaEstoqueBloc.txtTipoAtualizacaoEstoqueControllerOut,
                        builder: (context, snapshot) {
                          String _txtTipoAtualizacaoEstoque = snapshot.data;
                          return StreamBuilder<int>(
                            stream: consultaEstoqueBloc.newEstoqueControllerOut,
                            builder: (context, snapshot) {
                              if(!snapshot.hasData){
                                return CircularProgressIndicator();
                              }
                              int _newEstoque = snapshot.data;
                              return Column(
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.only(right: 18.0, left: 18.0, top: 10),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Container(
                                          width: 84,
                                          child: Column(
                                            children: <Widget>[
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: <Widget>[
                                                  Image.asset(
                                                    'assets/estoqueAtualIcon.png',
                                                    fit: BoxFit.contain,
                                                    height: 25,
                                                  ),
                                                  Expanded(
                                                    child: AutoSizeText(
                                                      _oldEstoque.toString(),
                                                      style: Theme.of(context).textTheme.title,
                                                      textAlign: TextAlign.right,
                                                      minFontSize: 8,
                                                      maxLines: 1,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Text(
                                                "Estoque atual",
                                                style: Theme.of(context).textTheme.body2,
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          width: 85,
                                          child: Column(
                                            mainAxisSize: MainAxisSize.max,
                                            children: <Widget>[
                                              Container(
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: <Widget>[
                                                    Image.asset(
                                                      'assets/novoEstoqueIcon.png',
                                                      fit: BoxFit.contain,
                                                      height: 28,
                                                    ),
                                                    Container(
                                                      width: 20,
                                                      child: Visibility(
                                                        visible: _oldEstoque < consultaEstoqueBloc.newEstoque,
                                                        child: Container(
                                                          child: Icon(
                                                            _oldEstoque < consultaEstoqueBloc.newEstoque ? Icons.arrow_upward : Icons.arrow_downward,
                                                            size: 16,
                                                            color:  _oldEstoque < consultaEstoqueBloc.newEstoque ? Colors.green : Colors.red,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: AutoSizeText(
                                                        _newEstoque.toString(),
                                                        style: Theme.of(context).textTheme.title,
                                                        textAlign: TextAlign.right,
                                                        minFontSize: 8,
                                                        maxLines: 1,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Text(
                                                "Novo Estoque",
                                                style: Theme.of(context).textTheme.body2,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ]
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: <Widget>[
                                          Image.asset(
                                            'assets/estoqueInputIcon.png',
                                            fit: BoxFit.contain,
                                            height: 50,
                                          ),
                                          Text(
                                            "$_txtTipoAtualizacaoEstoque",
                                            style: TextStyle(
                                              color: _txtTipoAtualizacaoEstoque == "Somar" ? 
                                                Colors.green : _txtTipoAtualizacaoEstoque == "Sobrepor" ?
                                                Colors.white : Colors.red,
                                              fontSize: Theme.of(context).textTheme.title.fontSize
                                            ),
                                          ),
                                        ],
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 18.0),
                                        child: Text(
                                          _estoqueDigitado.toString(),
                                          style: TextStyle(
                                            color: _txtTipoAtualizacaoEstoque == "Somar" ? 
                                              Colors.green : _txtTipoAtualizacaoEstoque == "Sobrepor" ?
                                              Colors.white : Colors.red,
                                            fontSize: Theme.of(context).textTheme.display2.fontSize
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              );
                            }
                          );
                        }
                      );
                    }
                  );
                }
              )
            ],
          ),
          onTap: () async {
            consultaEstoqueBloc.newEstoque = 0;
            _firstDig = true;
            showModalBottomSheet(
              isDismissible: false,
              context: context,
              builder: (BuildContext context){
                return SafeArea(
                  child: Container(
                    height: 310,
                    child: Container(
                      child: Column(
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.only(top: 0),
                            child: StreamBuilder<TipoAtualizacaoEstoque>(
                              stream: consultaEstoqueBloc.tipoAtualizacaoEstoqueControllerOut,
                              builder: (context, snapshot) {
                                TipoAtualizacaoEstoque _tipoAtualizacaoEstoque = snapshot.data;
                                return GridView.count(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  crossAxisCount: 3,
                                  childAspectRatio: 2.2,
                                  padding: const EdgeInsets.all(4.0),
                                  mainAxisSpacing: 4.0,
                                  crossAxisSpacing: 4.0,
                                  children: <String>[
                                    // @formatter:off
                                    'Somar', 'Sobrepor', 'Subtrair',
                                    '7', '8', '9',
                                    '4', '5', '6',
                                    '1', '2', '3',
                                    'DEL', '0', 'OK',
                                    // @formatter:on
                                  ].map((key) {
                                    return Padding(
                                      padding: const EdgeInsets.all(2),
                                        child: GridTile(
                                          child: AbsorbPointer(
                                            absorbing: key == "Somar" ? 
                                                   _tipoAtualizacaoEstoque == TipoAtualizacaoEstoque.somar ? 
                                                     false : 
                                                     consultaEstoqueBloc.movimentoEstoqueList.length == 0 ?
                                                       false : 
                                                       true :
                                                 key == "Subtrair" ?      
                                                   _tipoAtualizacaoEstoque == TipoAtualizacaoEstoque.subtrair ? 
                                                     false : 
                                                     consultaEstoqueBloc.movimentoEstoqueList.length == 0 ?
                                                       false : 
                                                       true :
                                                 key == "Sobrepor" ?      
                                                   _tipoAtualizacaoEstoque == TipoAtualizacaoEstoque.sobrepor ? 
                                                     false : 
                                                     consultaEstoqueBloc.movimentoEstoqueList.length == 0 ?
                                                       false : 
                                                       true :
                                                 false ,
                                            child: InkWell(
                                              child: Container(
                                                alignment: Alignment.center,
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(8),
                                                  border: Border.all(width: 2, color: Theme.of(context).primaryColor,),
                                                  color: key == "DEL" ? 
                                                    Colors.red : 
                                                    key == "OK" ? 
                                                    Colors.green[400] : 
                                                    key == "Subtrair" && _tipoAtualizacaoEstoque == TipoAtualizacaoEstoque.subtrair  ?
                                                    Colors.grey :
                                                    key == "Sobrepor" && _tipoAtualizacaoEstoque == TipoAtualizacaoEstoque.sobrepor ?
                                                    Colors.grey :
                                                    key == "Somar" && _tipoAtualizacaoEstoque == TipoAtualizacaoEstoque.somar ?
                                                    Colors.grey :
                                                    Colors.transparent,
                                                ),
                                                child: Text(key,
                                                  style: TextStyle(
                                                    fontSize: Theme.of(context).textTheme.title.fontSize,
                                                    color: key == "Somar" ? 
                                                      _tipoAtualizacaoEstoque == TipoAtualizacaoEstoque.somar ? 
                                                        Colors.white : 
                                                        consultaEstoqueBloc.movimentoEstoqueList.length == 0 ?
                                                          Colors.white : 
                                                          Colors.white24 :
                                                    key == "Subtrair" ?      
                                                      _tipoAtualizacaoEstoque == TipoAtualizacaoEstoque.subtrair ? 
                                                        Colors.white : 
                                                        consultaEstoqueBloc.movimentoEstoqueList.length == 0 ?
                                                          Colors.white : 
                                                          Colors.white24 :
                                                    key == "Sobrepor" ?      
                                                      _tipoAtualizacaoEstoque == TipoAtualizacaoEstoque.sobrepor ? 
                                                        Colors.white : 
                                                        consultaEstoqueBloc.movimentoEstoqueList.length == 0 ?
                                                          Colors.white : 
                                                          Colors.white24 :
                                                    Colors.white
                                                  ),
                                                ),
                                              ),
                                              onTap: () {
                                                if (key == "OK") {
                                                  // if (consultaEstoqueBloc.txtDigitado != "") {
                                                  //   consultaEstoqueBloc.txtDigitado = "";
                                                    consultaEstoqueBloc.setNewEstoque(consultaEstoqueBloc.estoqueDigitado);
                                                    consultaEstoqueBloc.setMovimentoEstoque(consultaEstoqueBloc.estoqueDigitado);
                                                  // }  
                                                  Navigator.pop(context);
                                                } else if (key == "DEL") {
                                                  if ((consultaEstoqueBloc.txtDigitado == "") || (consultaEstoqueBloc.txtDigitado.length == 1)) {
                                                    _firstDig = true;
                                                    consultaEstoqueBloc.txtDigitado = "0";
                                                  } else {
                                                    consultaEstoqueBloc.txtDigitado = consultaEstoqueBloc.txtDigitado.substring(0, consultaEstoqueBloc.txtDigitado.length - 1);
                                                  }
                                                  consultaEstoqueBloc.setEstoqueDigitado(int.parse(consultaEstoqueBloc.txtDigitado));
                                                  consultaEstoqueBloc.setNewEstoque(consultaEstoqueBloc.estoqueDigitado);
                                                } else if (key == "Subtrair") {
                                                  consultaEstoqueBloc.setTipoAtualizacaoEstoque(TipoAtualizacaoEstoque.subtrair);
                                                  consultaEstoqueBloc.setNewEstoque(consultaEstoqueBloc.estoqueDigitado);
                                                } else if (key == "Sobrepor") {
                                                  consultaEstoqueBloc.setTipoAtualizacaoEstoque(TipoAtualizacaoEstoque.sobrepor);
                                                  consultaEstoqueBloc.setNewEstoque(consultaEstoqueBloc.estoqueDigitado);
                                                } else if (key == "Somar") {
                                                  consultaEstoqueBloc.setTipoAtualizacaoEstoque(TipoAtualizacaoEstoque.somar);
                                                  consultaEstoqueBloc.setNewEstoque(consultaEstoqueBloc.estoqueDigitado);
                                                } else {
                                                  if(consultaEstoqueBloc.estoqueDigitado < 9999){
                                                    consultaEstoqueBloc.txtDigitado = _firstDig ? key : consultaEstoqueBloc.txtDigitado + key;
                                                    _firstDig = false;
                                                    consultaEstoqueBloc.setEstoqueDigitado(int.parse(consultaEstoqueBloc.txtDigitado));                                                     
                                                    consultaEstoqueBloc.setNewEstoque(consultaEstoqueBloc.estoqueDigitado);
                                                  }
                                                }
                                              },
                                            ),
                                        //)
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                );
                              }
                            ),
                          )  
                        ],
                      ),
                    ),  
                  ),
                );
              }  
            );  
          },
        ),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Divider(color: Colors.white,),
              ListTile(
                dense: true,
                title: Text("Histórico"),
                onTap: () {
                  Navigator.push(context, 
                    MaterialPageRoute(
                      builder: (context) => ConsultaEstoqueHistoricoPage()
                    )
                  );
                },
                trailing: Icon(Icons.arrow_forward_ios, color: Colors.white,),
              ),
              Divider(color: Colors.white,),
            ],
          ),
        ),
      ]
    );
  }
}


class ProdutoEstoqueGradePage extends StatelessWidget {

  final ConsultaEstoqueBloc consultaEstoqueBloc = AppModule.to.getBloc<ConsultaEstoqueBloc>();
  final ProdutoBloc produtoBloc = ProdutoModule.to.getBloc<ProdutoBloc>();

  ProdutoEstoqueGradePage() {
    consultaEstoqueBloc.produto = produtoBloc.produto;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Visibility(
          visible: consultaEstoqueBloc.produtoVarianteSelecionado != null,
          child: Expanded(
            child: StreamBuilder<ProdutoVariante>(
              initialData: ProdutoVariante(),
              stream: consultaEstoqueBloc.produtoVarianteSelecionadoControllerOut,
              builder: (context, snapshot) {
                ProdutoVariante _produtoVariante = snapshot.data;
                return Container(
                  child: Row(
                    children: <Widget>[
                      InkWell(
                        child: Container(
                          padding: EdgeInsets.all(8),
                          child: Icon(
                            Icons.arrow_back,
                            size: 25,
                            color: Colors.white,
                          ),
                        ),
                        onTap: () {
                          produtoBloc.produtoEstoquePageController.jumpToPage(1);
                          //produtoBloc.produtoEstoquePageController.jumpToPage(produtoBloc.lastPageController.toInt());
                        },
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 5),
                        child: Text(
                          _produtoVariante.variante.nome != null ? _produtoVariante.variante.nome : "",
                          style: Theme.of(context).textTheme.subhead
                        )
                      ),
                    ],
                  ),
                );
              }
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(6.0),
          child: StreamBuilder<List<EstoqueGradeMovimento>>(
            stream: consultaEstoqueBloc.estoqueGradeOut,
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return CircularProgressIndicator();
              }

              List<EstoqueGradeMovimento> gradeList = snapshot.data;

              return StreamBuilder<List<String>>(
                stream: consultaEstoqueBloc.gradeTamanhosListControllerOut,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return CircularProgressIndicator();
                  }
                  List<String> _gradeTamanhosList = snapshot.data;
                  return GridView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
                    itemCount: gradeList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
                        padding: const EdgeInsets.all(8),
                        child: InkWell(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(width: 0.2),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Stack(children: <Widget>[
                                Align(
                                  alignment: Alignment.topLeft,
                                  child: Text("${_gradeTamanhosList[index]}",
                                  style: Theme.of(context).textTheme.subhead,
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    "${gradeList[index].estoqueNovo == null ? gradeList[index].estoqueAtual : gradeList[index].estoqueNovo}", 
                                    style: TextStyle(
                                      color: gradeList[index].estoqueNovo == null ? Colors.white :
                                        gradeList[index].estoqueNovo > gradeList[index].estoqueAtual ? Colors.green[400] :
                                        gradeList[index].estoqueNovo < gradeList[index].estoqueAtual ? Colors.red :
                                        Colors.yellow,
                                      fontSize: Theme.of(context).textTheme.title.fontSize,
                                      fontWeight: FontWeight.bold  
                                    ),
                                    
                                  )
                                )
                              ]),
                            ),
                          ),
                          onTap: () async {
                            await consultaEstoqueBloc.setProdutoTamanhoSelecionado(index, consultaEstoqueBloc.gradeTamanhosList[index]);
                            await consultaEstoqueBloc.setOldEstoque();
                            await consultaEstoqueBloc.getMovimentoEstoque();
                            produtoBloc.lastPageController = 2;
                            produtoBloc.produtoEstoquePageController.jumpToPage(0);
                          },
                        ),
                      );
                    }
                  );
                }
              );
            }
          )
        ),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Divider(color: Colors.white,),
              ListTile(
                dense: true,
                title: Text("Histórico"),
                onTap: () {
                  Navigator.push(context, 
                    MaterialPageRoute(
                      builder: (context) => ConsultaEstoqueHistoricoPage()
                    )
                  );
                },
                trailing: Icon(Icons.arrow_forward_ios, color: Colors.white,),
              ),
              Divider(color: Colors.white,),
            ],
          ),
        ),
      ],
    );
  }
}

class ProdutoEstoqueVariantePage extends StatelessWidget {

  final ConsultaEstoqueBloc consultaEstoqueBloc = AppModule.to.getBloc<ConsultaEstoqueBloc>();
  final ProdutoBloc produtoBloc = ProdutoModule.to.getBloc<ProdutoBloc>();

  ProdutoEstoqueVariantePage() {
    consultaEstoqueBloc.produto = produtoBloc.produto;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(6.0),
          child: StreamBuilder<Produto>(
            stream: consultaEstoqueBloc.produtoControllerOut,
            builder: (context, snapshot) {
              if(!snapshot.hasData){
                return CircularProgressIndicator();
              }
              Produto _produto = snapshot.data;
              return GridView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
                itemCount: _produto.produtoVariante != null ? _produto.produtoVariante.length : 0,
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: const EdgeInsets.all(8),
                    child: InkWell(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(width: 0.2),
                          color: Color(int.tryParse(_produto.produtoVariante[index].variante.iconecor))),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Stack(children: <Widget>[
                            Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                "${_produto.produtoVariante[index].variante.nome}",
                                style: TextStyle(
                                  color: useWhiteForeground(Color(int.parse(_produto.produtoVariante[index].variante.iconecor)))
                                                            ? const Color(0xffffffff)
                                                            : const Color(0xff000000),
                                  fontWeight: FontWeight.bold,                          
                                  fontSize: 11
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.center,
                              child: Text(
                                "${_produto.produtoVariante[index].newEstoque == null ? _produto.produtoVariante[index].estoque : _produto.produtoVariante[index].newEstoque}",
                                style: TextStyle(
                                  color: useWhiteForeground(Color(int.parse(_produto.produtoVariante[index].variante.iconecor)))
                                                        ? const Color(0xffffffff)
                                                        : const Color(0xff000000), 
                                  fontWeight: FontWeight.bold,                          
                                  fontSize: 28                       
                                )
                              )
                            ),
                          ]),
                        ),
                      ),
                      onTap: () async {
                        if (_produto.grade != null) {
                          await consultaEstoqueBloc.setProdutoVarianteSelecionado(index);
                          await consultaEstoqueBloc.consultaGrade(idVariante: consultaEstoqueBloc.produtoVarianteSelecionado.idVariante, ehEdicaoEstoque: true);
                          produtoBloc.lastPageController = 1;
                          produtoBloc.produtoEstoquePageController.jumpToPage(2);
                        } else {
                          await consultaEstoqueBloc.setProdutoVarianteSelecionado(index);
                          await consultaEstoqueBloc.setOldEstoque();
                          await consultaEstoqueBloc.getMovimentoEstoque();
                          produtoBloc.lastPageController = 1;
                          produtoBloc.produtoEstoquePageController.jumpToPage(0);
                      } 
                      },
                    ),
                  );
                }
              );
            }
          )
        ),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Divider(color: Colors.white,),
              ListTile(
                dense: true,
                title: Text("Histórico"),
                onTap: () {
                  Navigator.push(context, 
                    MaterialPageRoute(
                      builder: (context) => ConsultaEstoqueHistoricoPage()
                    )
                  );
                },
                trailing: Icon(Icons.arrow_forward_ios, color: Colors.white,),
              ),
              Divider(color: Colors.white,),
            ],
          ),
        ),
      ]
    );
  }
}


class ConsultaEstoqueHistoricoPage extends StatefulWidget {
  @override
  _ConsultaEstoqueHistoricoPageState createState() => _ConsultaEstoqueHistoricoPageState();
}

class _ConsultaEstoqueHistoricoPageState extends State<ConsultaEstoqueHistoricoPage> {
  ConsultaEstoqueBloc _consultaEstoqueBloc;

  @override
  void initState() {
    _consultaEstoqueBloc = AppModule.to.getBloc<ConsultaEstoqueBloc>();
    _consultaEstoqueBloc.getEstoqueHistorico();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.of<LocaleBase>(context, LocaleBase);
    DateFormat dateFormat = new DateFormat.Md('pt_BR');

    Widget header = Container(
      height: 60,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                width: 300,
                padding: EdgeInsets.only(left: 15),
                child: TextField(
                  style: Theme.of(context).textTheme.body2,
                  decoration: InputDecoration(
                    icon: Icon(Icons.search, color: Colors.white70),
                    hintText: locale.palavra.pesquisar,
                    hintStyle: Theme.of(context).textTheme.body2,
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.white70),
                    ), 
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.white70),
                    ), 
                  ),
                  onSubmitted: (text) async {
                    
                  },
                ),
              )
            ],
          ),
        ],
      ),
    );

    Widget body = Expanded(
      child: Container(
        padding: EdgeInsets.only(left: 10, right: 10, bottom: 20),  
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Theme.of(context).accentColor,
          ),
          child: Column(
            children: <Widget>[
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[ 
                    Expanded(
                      child: StreamBuilder<List<EstoqueHistorico>>(
                        stream: _consultaEstoqueBloc.estoqueHistoricoListControllerOut,
                        builder: (context, snapshot) {
                          List<EstoqueHistorico> estoqueHistoricoList = snapshot.data;
                          return ListView.builder(
                            itemCount: estoqueHistoricoList.length,
                            itemBuilder: (context, index){
                              return ListTile(
                                dense: true,
                                title: Text(estoqueHistoricoList[index].descricao, style: Theme.of(context).textTheme.body2),
                                subtitle: Text(estoqueHistoricoList[index].variante != null ? 
                                  estoqueHistoricoList[index].variante.nome + " - " + estoqueHistoricoList[index].gradeDescricao : "" , 
                                  style: Theme.of(context).textTheme.body2),
                                trailing: Text(estoqueHistoricoList[index].quantidade.toString(), style: Theme.of(context).textTheme.body2),
                                leading: Text(dateFormat.format(estoqueHistoricoList[index].dataMovimento), style: Theme.of(context).textTheme.body2)
                              );
                            }
                          );
                        }
                      )
                    )
                  ]
                )
              )
            ]
          )
        )
      )
    );
    
    return Scaffold(
      appBar: AppBar(
        title: Text("Estoque Histórico", style: Theme.of(context).textTheme.title,),
      ),      
      body: Container(
        color: Theme.of(context).primaryColor,
        child: Column(
          children: <Widget>[
            //header,
            body
          ],
        ),
      ),
    );
  }
}