import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:camera/camera.dart';
import 'package:common_files/common_files.dart';
import 'package:fluggy/generated/locale_base.dart';
import 'package:flutter/material.dart';
import 'package:flutter_circle_color_picker/flutter_circle_color_picker.dart';
import 'package:flutter_colorpicker/material_picker.dart';
import 'package:flutter_colorpicker/utils.dart';
import 'package:fluggy/src/pages/cadastro/variante/variante_module.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class VarianteDetailPage extends StatefulWidget {
  VarianteDetailPage({Key key,}) : super(key: key);

  @override
  _VarianteDetailPageState createState() => _VarianteDetailPageState();
}

class _VarianteDetailPageState extends State<VarianteDetailPage> {
  CameraController _controller;
  VarianteBloc varianteBloc;
  TextEditingController nomeController, nomeAvatarController;
  String nomeAvatar = "";
  var firstCamera;
  bool edit = true;

  @override
  void initState() {
    super.initState();
    varianteBloc = VarianteModule.to.getBloc<VarianteBloc>();
    init();
    nomeController = TextEditingController();
    nomeAvatarController = TextEditingController();
    nomeController.value =  nomeController.value.copyWith(text: varianteBloc.variante.nome); 
    nomeAvatarController.text = varianteBloc.variante.nomeAvatar == null ? varianteBloc.variante.nome : varianteBloc.variante.nomeAvatar;
  } 

  init() async {
    var appDir = (await getTemporaryDirectory()).path;
    Directory(appDir).delete(recursive: true);
  }

  @override
  void dispose() {
    print("DISPOSE VARIANTE PAGE");
    varianteBloc.limpaValidacoes();
    try {
      _controller.dispose();  
    } catch (e) {
    }
    super.dispose();
  }  
  
  @override
  Widget build(BuildContext context) {
    Color currentColor = Colors.amber;
    void changeColor(Color color) => setState(() => currentColor = color);
    final locale = Localizations.of<LocaleBase>(context, LocaleBase);

    return Scaffold(
      appBar: AppBar(
        title: Text(locale.cadastroVariante.titulo, 
          style: Theme.of(context).textTheme.title,)
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
                     child: Text(varianteBloc.variante.id != null 
                       ? locale.palavra.alterar + " " + locale.cadastroVariante.titulo.toLowerCase()
                       : locale.cadastro.incluirNovo,
                       style: Theme.of(context).textTheme.subhead,
                     ),
                   ),
                   Container(
                     padding: EdgeInsets.only(right: 15),
                     child: InkWell(
                         child: Text(varianteBloc.variante.id != null ? locale.palavra.excluir : locale.palavra.limpar,
                         style: Theme.of(context).textTheme.subhead,
                       ),
                       onTap: () async {
                         if (varianteBloc.variante.id != null) {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) => CustomDialogConfirmation(
                              title: locale.palavra.confirmacao,
                              description: locale.mensagem.confirmarExcluirRegistro +
                                locale.palavra.artigo_a + " " +
                                locale.cadastroVariante.titulo.toLowerCase() + " ",
                              item: varianteBloc.variante.nome ,
                              buttonOkText: locale.palavra.excluir,
                              buttonCancelText: locale.palavra.cancelar,
                              funcaoBotaoOk: () async {
                                await varianteBloc.deleteVariante();
                                await varianteBloc.getAllVariante();
                                Navigator.pop(context);
                                Navigator.pop(context);
                              },
                              funcaoBotaoCancelar: () async {
                                Navigator.pop(context);
                              }
                            ),
                          );         
                         } else {
                           await varianteBloc.newVariante();
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
                        child: Container(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10, right: 10),
                            child: Column(
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(top: 10.0, bottom: 10),
                                  child: StreamBuilder<Variante>(
                                    stream: varianteBloc.varianteOut,
                                    builder: (context, snapshot) {
                                      Variante variante = snapshot.data;
                                      if(!snapshot.hasData) {return CircularProgressIndicator();} 
                                      return Stack(
                                        children: <Widget>[
                                          Padding(
                                            padding: const EdgeInsets.only(top: 30.0),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: Theme.of(context).primaryColor,
                                                borderRadius: BorderRadius.circular(6)
                                              ),
                                              width: double.infinity,
                                              height: 140,
                                              child: Padding(
                                                padding: EdgeInsets.only(bottom: 20),
                                                child: Container(
                                                  alignment: Alignment.bottomCenter,
                                                  child: variante.temImagem == 0 ? 
                                                    InkWell(
                                                      onTap: () {
                                                        showDialog(
                                                          context: context,
                                                          builder: (BuildContext context) {
                                                            return AlertDialog(
                                                              backgroundColor: Theme.of(context).primaryColor,
                                                              titlePadding: const EdgeInsets.all(0.0),
                                                              contentPadding: const EdgeInsets.all(0.0),
                                                              content: SingleChildScrollView(
                                                                child: Center(
                                                                  child: CircleColorPicker(
                                                                    initialColor: Colors.blue,
                                                                    onChanged: (color) {
                                                                      varianteBloc.setCorVariante(color);
                                                                    },
                                                                    size: const Size(240, 240),
                                                                    strokeWidth: 4,
                                                                    thumbSize: 36,
                                                                  ),
                                                                ),
                                                              ),
                                                              actions: <Widget>[
                                                                FlatButton(
                                                                  color: Colors.white,
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
                                                      child: Container(
                                                        width: 50,
                                                        height: 20,
                                                        child: Icon(Icons.color_lens, size: 30, color: Colors.white,)
                                                      ),
                                                    ) : 
                                                    InkWell(
                                                    child: Container(
                                                      width: 50,
                                                      height: 20,
                                                      child: Icon(Icons.close, size: 30, color: Colors.white,)
                                                    ),
                                                    onTap: () {
                                                      setState(() {
                                                        nomeAvatar = nomeAvatar; 
                                                      });
                                                      varianteBloc.deleteImagem();
                                                    },
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Align(
                                            alignment: Alignment.topCenter,
                                            child: Container(
                                              padding: const EdgeInsets.only(right: 10, left: 10),
                                              alignment: Alignment.center,
                                              width: 120,
                                              height: 120,
                                              decoration: BoxDecoration(
                                                color: Color(int.parse(variante.iconecor.replaceAll("Color(", "").replaceAll(")", ""))),
                                                borderRadius: BorderRadius.all(Radius.circular(8)),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.black,
                                                    spreadRadius: 0.01)
                                                ]
                                              ),
                                              child: TextFormField(
                                                maxLines: 1,
                                                maxLength: 8,
                                                controller: nomeAvatarController,
                                                decoration: InputDecoration(
                                                  counterText: '',
                                                  border: InputBorder.none,
                                                  hintText: nomeAvatarController.text.length <= 0 ? nomeController.text : "" 
                                                ),
                                                style: TextStyle(
                                                color: useWhiteForeground(varianteBloc.variante.iconecor == null ? Colors.grey : Color(int.parse(varianteBloc.variante.iconecor)))
                                                  ? const Color(0xffffffff)
                                                  : const Color(0xff000000), 
                                                  fontSize: 23,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                                onChanged: (text) {
                                                  varianteBloc.variante.nomeAvatar = text;
                                                  edit = false;
                                                },
                                              ),
                                            )
                                          ),
                                        ],
                                      );
                                    }
                                  )
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: EdgeInsets.only(top: 50, left: 15, right: 15),
                                    child: Container(
                                      alignment: Alignment.topCenter,
                                      child: StreamBuilder<bool>(
                                        initialData: false,
                                        stream: varianteBloc.nomeInvalidoOut,
                                        builder: (context, snapshot) {
                                          return customCenteredField(context,
                                            autofocus: varianteBloc.variante.id != null ? false : true,
                                            controller: nomeController,
                                            labelText: locale.palavra.nome,
                                            errorText: snapshot.data ? locale.mensagem.nomeNaoNulo : null,
                                            onChanged: (text) {
                                              varianteBloc.variante.nome = text;
                                              if(text.length <= 8 && edit == true){
                                                setState(() {
                                                  nomeAvatarController.text = text; 
                                                });
                                                varianteBloc.variante.nomeAvatar = text;
                                              }
                                              if(text == ""){
                                                nomeAvatarController.text = "";
                                                varianteBloc.variante.nomeAvatar = "";
                                                edit = true;
                                              }
                                            }
                                          );
                                        }
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      customButtomGravar(
                        buttonColor: Theme.of(context).primaryIconTheme.color,
                        text: Text(locale.palavra.gravar,
                          style: Theme.of(context).textTheme.title,
                        ),
                        onPressed: () async {
                          varianteBloc.validaNome();
                          if (!varianteBloc.formInvalido){
                            await varianteBloc.saveVariante();
                            Navigator.pop(context);
                          } else {
                            print("Error form invalido: ");
                          }
                        },
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
}