import 'dart:convert';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:dio/dio.dart';
import 'package:fluggy/generated/locale_base.dart';
import 'package:fluggy/src/pages/cadastro/servico/servico_module.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/material_picker.dart';
import 'package:flutter_colorpicker/utils.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:fluggy/src/pages/cadastro/categoria/categoria_module.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:common_files/common_files.dart';

class ServicoDetailPage extends StatefulWidget {
  Produto produto;

  ServicoDetailPage({this.produto});

  @override
  _ServicoDetailPageState createState() => _ServicoDetailPageState();
}

class _ServicoDetailPageState extends State<ServicoDetailPage> {
  ScrollController _scrollController;
  CameraController _controller;
  Future<void> _initializeControllerFuture;
  ServicoBloc servicoBloc;
  TextEditingController nomeController, idAparenteController, nomeAvatarController, codigoBarrasController;
  MoneyMaskedTextController precoCustoController, precoVendaController;
  CategoriaModule categoriaModule;
  var firstCamera;

  @override
  void initState() {
    servicoBloc = ServicoModule.to.getBloc<ServicoBloc>();
    categoriaModule = ServicoModule.to.getDependency<CategoriaModule>();
    if(widget.produto != null){
      servicoBloc.produto = widget.produto;
      servicoBloc.updateProdutoStream();
    }
    nomeController = TextEditingController();
    codigoBarrasController = TextEditingController();
    nomeAvatarController = TextEditingController();
    idAparenteController = TextEditingController();
    precoCustoController = MoneyMaskedTextController(initialValue: servicoBloc.produto.precoCusto == null ? 0.0 : servicoBloc.produto.precoCusto , leftSymbol: "R\$ ", decimalSeparator: ',', thousandSeparator: '.');
    precoVendaController = MoneyMaskedTextController(initialValue: (servicoBloc.produto.precoTabelaItem == null) || (servicoBloc.produto.precoTabelaItem.length == 0) ? 
                                                                    0.0 : servicoBloc.produto.precoTabelaItem[0].preco , leftSymbol: "R\$ ", decimalSeparator: ',', thousandSeparator: '.');
    idAparenteController.value = idAparenteController.value.copyWith(text: servicoBloc.produto.idAparente == null ? 
                                                                           servicoBloc.configuracaoCadastro.ehProdutoAutoInc != 0 ? 
                                                                           "**novo**" : "" : servicoBloc.produto.idAparente);
    nomeController.value = nomeController.value.copyWith(text: servicoBloc.produto.nome == null ? "" : servicoBloc.produto.nome); 
    nomeAvatarController.value = nomeAvatarController.value.copyWith(text: servicoBloc.produto.nome == null ? "" : servicoBloc.produto.nome); 
    codigoBarrasController.value =  codigoBarrasController.value.copyWith(text: ((servicoBloc.produto.produtoCodigoBarras.length > 0) &&
                                                                                 (servicoBloc.produto.produtoCodigoBarras[0].codigoBarras != null)) ? 
                                                                                 servicoBloc.produto.produtoCodigoBarras[0].codigoBarras : ""); 
    if(servicoBloc.produto.idGrade == null){
      servicoBloc.produto.grade = null;
    }
    super.initState();
  } 
  
  @override
  Widget build(BuildContext context) {
    final locale = Localizations.of<LocaleBase>(context, LocaleBase);
    _scrollController = ScrollController();
    return Scaffold(
      appBar: AppBar(
        title: Text("Cadastro de serviço"),
      ),      
      body: Container(
        color: Theme.of(context).primaryColor,
        child: Column(
          children: <Widget>[
            Container(
              height: 60,
              padding: const EdgeInsets.only(bottom: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                   Container(
                     padding: EdgeInsets.only(left: 10),
                     child: Text(servicoBloc.produto.id != null 
                       ? locale.palavra.alterar + " " + "serviço"
                       : locale.cadastro.incluirNovo,
                       style: Theme.of(context).textTheme.subhead,
                     ),
                   ),
                   Container(
                     padding: EdgeInsets.only(right: 15),
                     child: InkWell(
                         child: Text(servicoBloc.produto.id != null ? locale.palavra.excluir : locale.palavra.limpar,
                         style: Theme.of(context).textTheme.subhead,
                       ),
                       onTap: () async {
                         if (servicoBloc.produto.id != null) {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) => CustomDialogConfirmation(
                              title: locale.palavra.confirmacao,
                              description: locale.mensagem.confirmarExcluirRegistro +
                                locale.palavra.artigo_a + " " +
                                locale.cadastroProduto.titulo.toLowerCase() + " ",
                              item: servicoBloc.produto.nome ,
                              buttonOkText: locale.palavra.excluir,
                              buttonCancelText: locale.palavra.cancelar,
                              funcaoBotaoOk: () async {
                                await servicoBloc.deleteProduto();
                                await servicoBloc.getAllProduto();
                                Navigator.pop(context);
                                Navigator.pop(context);
                              },
                              funcaoBotaoCancelar: () async {
                                Navigator.pop(context);
                              }
                            ),
                          );
                         } else {
                           await servicoBloc.newProduto();
                           nomeController.clear();
                         }
                       },
                     ),
                   )  
                ],
              ),
            ),
                       
            Expanded(
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
                        child: SingleChildScrollView(
                          controller: _scrollController,
                          child: Column(
                            children: <Widget>[
                              StreamBuilder<Produto>(
                                stream: servicoBloc.produtoOut,
                                builder: (context, snapshot) {
                                  Produto servico = snapshot.data;
                                  return Stack(
                                    children: <Widget>[
                                      Align(
                                        alignment: Alignment.bottomCenter,
                                        child: Padding(
                                          padding: const EdgeInsets.only(top: 30.0, right: 8, left: 8),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: Theme.of(context).primaryColor,
                                              borderRadius: BorderRadius.circular(10)
                                            ),
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: <Widget>[
                                                Container(
                                                  height: 50,
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
                                                          var appDir = (await getTemporaryDirectory()).path;
                                                          Directory(appDir).delete(recursive: true);
                                                          abreCamera();
                                                        }
                                                      ),
                                                      SizedBox.shrink(),
                                                      servico.produtoImagem.length > 0 && servico.produtoImagem.first.ehDeletado == 0
                                                      ? Align(
                                                          alignment: Alignment.bottomCenter,
                                                          child: InkWell(
                                                            child: Container(
                                                              width: 50,
                                                              height: 20,
                                                              child: Icon(Icons.close, size: 30, color: Colors.white,)
                                                            ),
                                                            onTap: () {
                                                              servicoBloc.produto.produtoImagem.first.ehDeletado = 1;
                                                              servicoBloc.novaImagem = false;
                                                              servicoBloc.updateProdutoStream();
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
                                                                  titlePadding: const EdgeInsets.all(0.0),
                                                                  contentPadding: const EdgeInsets.all(0.0),
                                                                  content: SingleChildScrollView(
                                                                    child: MaterialPicker(
                                                                      pickerColor: Color(int.parse(servico.iconeCor)),
                                                                      onColorChanged: (color) {
                                                                        servico.iconeCor = color.toString().replaceAll('Color(', '').replaceAll(")", "").toUpperCase();
                                                                        servicoBloc.updateProdutoStream();
                                                                      },
                                                                      enableLabel: true,
                                                                    ),
                                                                  ),
                                                                  actions: <Widget>[
                                                                    FlatButton(
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
                                                ),
                                                Container(
                                                  height: 90,
                                                  alignment: Alignment.bottomCenter,
                                                  child: Visibility(
                                                    visible: true,
                                                    child: StreamBuilder<bool>(
                                                      initialData: false,
                                                      stream: servicoBloc.idAparenteInvalidoOut,
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
                                                                autofocus: servicoBloc.configuracaoCadastro.ehProdutoAutoInc == 0 ? servicoBloc.produto.idAparente == null ? true : false : false,
                                                                enabled: (servicoBloc.configuracaoCadastro.ehProdutoAutoInc == 0) && (servicoBloc.produto.idAparente == null),
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
                                                                  servicoBloc.produto.idAparente = text;
                                                                  servicoBloc.updateProdutoStream();
                                                                },
                                                              ),
                                                            ),
                                                          ],
                                                        );
                                                      }
                                                    ),
                                                  ),
                                                ),
                                                Visibility(
                                                  visible: true,
                                                  child: StreamBuilder<bool>(
                                                    initialData: false,
                                                    stream: servicoBloc.nomeInvalidoOut,
                                                    builder: (context, snapshot) {
                                                      return Container(
                                                        height: 65,
                                                        padding: EdgeInsets.symmetric(horizontal: 40),
                                                        child: TextField(
                                                          textAlign: TextAlign.center,
                                                          autofocus: servicoBloc.produto.nome != "" ? false : true,
                                                          enabled: true,
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
                                                            servicoBloc.produto.nome = text;
                                                            servicoBloc.updateProdutoStream();
                                                          },
                                                        ),
                                                      );
                                                    }
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(top: 10.0),
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
                                              servico.produtoImagem.length > 0 && servico.produtoImagem.first.ehDeletado == 0
                                                ? servicoBloc.novaImagem 
                                                  ? ClipRRect(
                                                      borderRadius: BorderRadius.circular(12),
                                                      child: Image.file(File(servicoBloc.path),
                                                        fit: BoxFit.cover, 
                                                        width: 120,
                                                        height: 120,
                                                      ),
                                                    ) 
                                                  : FutureBuilder(
                                                      future: Future.wait([
                                                        getImageFromServer(servico.produtoImagem.first.imagem)
                                                      ]),
                                                      builder: (context, snapshot) {
                                                        if(snapshot.data == null){
                                                          return Center(child: CircularProgressIndicator());
                                                        }
                                                        return ClipRRect(
                                                          borderRadius: BorderRadius.circular(12),
                                                          child: Image.memory(base64Decode(snapshot.data[0]),
                                                            fit: BoxFit.cover, 
                                                            width: 120,
                                                            height: 120,
                                                          ),
                                                        );
                                                      },
                                                    ) 
                                                : ClipRRect(
                                                  borderRadius: BorderRadius.circular(12),
                                                  child: Container(
                                                    color: Color(int.parse(servico.iconeCor)),
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
                                                        color: useWhiteForeground(Color(int.parse(servico.iconeCor)))
                                                          ? const Color(0xffffffff)
                                                          : const Color(0xff000000), 
                                                          fontSize: 23,
                                                          fontWeight: FontWeight.w500
                                                        ),
                                                        onChanged: (text) {
                                                          servicoBloc.produto.nome = text;
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
                                                        child: Text("${servico.nome}",
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
                                  );
                                }
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 10.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Expanded(
                                      child:  Padding(
                                        padding: const EdgeInsets.only(left: 10),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: <Widget>[
                                            Padding(
                                              padding: const EdgeInsets.only(right: 10.0),
                                              child: Image.asset(
                                                'assets/precoCustoIcon.png',
                                                fit: BoxFit.contain,
                                                height: 35,
                                              ),
                                            ),
                                            Expanded(
                                              child: Padding(
                                                padding: const EdgeInsets.only(right: 10.0),
                                                child: Visibility(
                                                  visible: true,
                                                  child: StreamBuilder<bool>(
                                                    initialData: false,
                                                    stream: servicoBloc.precoCustoInvalidoOut,
                                                    builder: (context, snapshot) {
                                                      return numberTextField(
                                                        context,
                                                        autofocus: servicoBloc.produto.precoCusto != null ? false : true,
                                                        controller: precoCustoController,
                                                        labelText: locale.palavra.precoCusto,
                                                        errorText: snapshot.data ? locale.mensagem.precoCustoInvalido : null,
                                                        onChanged: (text) {
                                                          servicoBloc.produto.precoCusto = double.parse(precoCustoController.text.replaceAll("R\$", "").replaceAll(".", "").replaceAll(",", "."));
                                                        }   
                                                      );
                                                    }
                                                  ),
                                                ),
                                              ),
                                            )
                                          ]
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.only(right: 10),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          children: <Widget>[
                                            Padding(
                                              padding: const EdgeInsets.only(right: 10.0),
                                              child: Image.asset(
                                                'assets/precoVendaIcon.png',
                                                fit: BoxFit.contain,
                                                height: 35,
                                              ),
                                            ),
                                            Expanded(
                                              child: Visibility(
                                                visible: true,
                                                child: StreamBuilder<bool>(
                                                  initialData: false,
                                                  stream: servicoBloc.precoVendaInvalidoOut,
                                                  builder: (context, snapshot) {
                                                    return numberTextField(
                                                      context,
                                                      autofocus: servicoBloc.produto.precoTabelaItem.length > 0 ? false : true,
                                                      controller: precoVendaController,
                                                      labelText: "Preço do serviço",
                                                      errorText: snapshot.data ? locale.mensagem.precoVendaInvalido : null,
                                                      onChanged: (text) {
                                                        servicoBloc.produto.precoTabelaItem.first.preco = double.parse(precoVendaController.text.replaceAll("R\$", "").replaceAll(".", "").replaceAll(",", "."));
                                                      }   
                                                    );
                                                  }
                                                ),
                                              ),
                                            )
                                          ]
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Row(
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
                                              stream: servicoBloc.nomeInvalidoOut,
                                              builder: (context, snapshot) {
                                                return customTextField(
                                                  context,
                                                  autofocus: servicoBloc.produto.nome != "" ? false : true,
                                                  controller: nomeController,
                                                  labelText: locale.palavra.nome,
                                                  errorText: snapshot.data ? locale.mensagem.nomeNaoNulo : null,
                                                  onChanged: (text) {
                                                    servicoBloc.produto.nome = text;
                                                  }   
                                                );
                                              }
                                            ),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          InkWell(
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
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: <Widget>[
                                                Container(
                                                  alignment: Alignment.topLeft,
                                                  child: Text(locale.cadastroCategoria.titulo,
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
                                                        stream: servicoBloc.categoriaInvalidaOut,
                                                        builder: (context, snapshot) {
                                                          return Text(servicoBloc.produto.categoria.nome != null ? servicoBloc.produto.categoria.nome : locale.palavra.selecione,
                                                            style: Theme.of(context).textTheme.subtitle,
                                                          );
                                                        }
                                                      ),
                                                      Icon(
                                                          Icons.arrow_forward_ios,
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
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      customButtomGravar(
                        buttonColor: Theme.of(context).primaryIconTheme.color,
                        text: Text(locale.palavra.gravar,
                          style: Theme.of(context).textTheme.title,
                        ),
                        onPressed: () async {
                          await servicoBloc.validaCampos();
                          if (!servicoBloc.formInvalido){
                            servicoBloc.produto.ehservico = 1;
                            await servicoBloc.saveProduto();
                            await servicoBloc.getAllProduto();
                            
                            Navigator.pop(context);
                          } else {
                            print("Error form invalido: ");
                          }
                          _scrollController.animateTo(
                            200,
                            curve: Curves.easeOut,
                            duration: const Duration(milliseconds: 300),
                          );
                        }, 
                      ),
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
    Response response = await Dio().get('$s3Endpoint$path',
      options: Options(
        responseType: ResponseType.bytes
      )
    );
    return base64.encode(response.data);
  }

  abreCamera() async {
    final cameras = await availableCameras();
    firstCamera = cameras.first;
    _controller = CameraController(
      firstCamera,
      ResolutionPreset.low,
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
                servicoBloc.addImagem(path);
                servicoBloc.updateProdutoStream();
                Navigator.pop(context);
              } catch (e) {
                print(e);
              }
            },
          ),
        );
      }
    );
  } 

  @override
  void dispose() {
    print("Dispose servico Detail");
    servicoBloc.limpaValidacoes();
    servicoBloc.resetBloc();
    super.dispose();
  }   
}
