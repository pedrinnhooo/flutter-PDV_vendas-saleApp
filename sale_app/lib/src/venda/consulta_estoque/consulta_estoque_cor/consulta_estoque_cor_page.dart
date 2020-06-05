import 'dart:convert';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:path/path.dart' as path_;
import 'package:common_files/common_files.dart';
import 'package:flutter/material.dart';
import 'package:fluggy/src/AppConfig.dart';
import 'package:fluggy/src/venda/consulta_estoque/consulta_estoque_module.dart';
import 'package:flutter_colorpicker/utils.dart';

class ConsultaEstoqueCorPage extends StatefulWidget {
  @override
  _ConsultaEstoqueCorPageState createState() => _ConsultaEstoqueCorPageState();
}

class _ConsultaEstoqueCorPageState extends State<ConsultaEstoqueCorPage> {
  ConsultaEstoqueBloc consultaEstoqueBloc;

  @override
  void initState() { 
    super.initState();
    consultaEstoqueBloc = ConsultaEstoqueModule.to.getBloc<ConsultaEstoqueBloc>();
    consultaEstoqueBloc.pageCounter = 2;
    consultaEstoqueBloc.notificaContador();
  }

  @override
  Widget build(BuildContext context) {
    AppConfig().init(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(15.0),
          child: Row(
            children: <Widget>[
              Container(
                child: SizedBox(
                  height: 100,
                  child: consultaEstoqueBloc.produto.produtoImagem.length > 0 && consultaEstoqueBloc.produto.produtoImagem.first.ehDeletado == 0
                  ? FutureBuilder<String>(
                    future: readBase64Image("${consultaEstoqueBloc.produto.produtoImagem.first.imagem.replaceAll(".png", "")}.txt"),
                    builder: (context, snapshot){
                      return AnimatedOpacity(
                        duration: Duration(milliseconds: 100),
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
                        width: 100,
                        height: 50,
                        color: Color(int.parse(consultaEstoqueBloc.produto.iconeCor)),
                        child: Center(
                          child: Text("${consultaEstoqueBloc.produto.nome}".substring(0, 2), 
                            style: TextStyle(
                              color: useWhiteForeground(Color(int.parse(consultaEstoqueBloc.produto.iconeCor)))
                                ? const Color(0xffffffff)
                                : const Color(0xff000000), 
                              fontSize: Theme.of(context).textTheme.title.fontSize)
                          ),
                        ),
                      )
                    )
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      width: 200,
                      child: AutoSizeText(
                        "${consultaEstoqueBloc.produto.nome}",
                        style: Theme.of(context).textTheme.subhead,
                        maxFontSize: Theme.of(context).textTheme.subhead.fontSize,
                        minFontSize: 8,
                        maxLines: 2,
                      ),
                    ),
                    Hero(
                      tag: 'tamanho',
                      child: consultaEstoqueBloc.tamanho != null 
                      ? Text("${consultaEstoqueBloc.gradeTamanhosList[consultaEstoqueBloc.tamanho-1]}", style: Theme.of(context).textTheme.body2) 
                      : Text(""),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
        Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(6.0),
              child: GridView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
                itemCount: consultaEstoqueBloc.produto.produtoVariante.length,
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(width: 0.2),
                        color: Color(int.tryParse(consultaEstoqueBloc.produto.produtoVariante[index].variante.iconecor))),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Stack(children: <Widget>[
                          Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              "${consultaEstoqueBloc.produto.produtoVariante[index].variante.nome}",
                              style: TextStyle(
                                color: useWhiteForeground(Color(int.parse(consultaEstoqueBloc.produto.produtoVariante[index].variante.iconecor)))
                                                          ? const Color(0xffffffff)
                                                          : const Color(0xff000000),
                                fontSize: 11
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.center,
                            child:  Text(
                              consultaEstoqueBloc.varianteList.length > 0 
                              ? "${consultaEstoqueBloc.varianteList[index]}"
                              : "${consultaEstoqueBloc.produto.produtoVariante[index].estoque}",
                              style: TextStyle(
                                color: useWhiteForeground(Color(int.parse(consultaEstoqueBloc.produto.produtoVariante[index].variante.iconecor)))
                                                      ? const Color(0xffffffff)
                                                      : const Color(0xff000000), 
                                fontSize: Theme.of(context).textTheme.title.fontSize                       
                              )
                            ),
                          ),
                        ]),
                      ),
                    ),
                  );
                }
              )
            ),
          ]
        )
      ]
    );
  }
}
