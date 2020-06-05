import 'dart:convert';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:path/path.dart' as path_;
import 'package:common_files/common_files.dart';
import 'package:flutter/material.dart';
import 'package:fluggy/src/venda/consulta_estoque/consulta_estoque_module.dart';
import 'package:flutter_colorpicker/utils.dart';


class ConsultaEstoqueTamanhoPage extends StatefulWidget {
  @override
  _ConsultaEstoqueTamanhoPageState createState() => _ConsultaEstoqueTamanhoPageState();
}

class _ConsultaEstoqueTamanhoPageState extends State<ConsultaEstoqueTamanhoPage> {
  ConsultaEstoqueBloc consultaEstoqueBloc;

  @override
  void initState() {
    consultaEstoqueBloc = ConsultaEstoqueModule.to.getBloc<ConsultaEstoqueBloc>();
    consultaEstoqueBloc.pageCounter = 1;
    consultaEstoqueBloc.notificaContador();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
                padding: const EdgeInsets.only(left: 8.0),
                child: Container(
                  width: 200,
                  child: AutoSizeText(
                    "${consultaEstoqueBloc.produto.nome}",
                    style: Theme.of(context).textTheme.subhead,
                    maxFontSize: Theme.of(context).textTheme.subhead.fontSize,
                    minFontSize: 8,
                    maxLines: 2,
                  ),
                ),
              )
            ],
          ),
        ),
        Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(6.0),
              child: StreamBuilder(
                stream: consultaEstoqueBloc.estoqueGradeOut,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return CircularProgressIndicator();
                  }
                  List<EstoqueGradeMovimento> gradeList = snapshot.data;

                  return GridView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
                    itemCount: gradeList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: InkWell(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(width: 0.2),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Stack(children: <Widget>[
                                Align(
                                  alignment: Alignment.topLeft,
                                  child: Hero(
                                    tag: 'tamanho',
                                    child: Text("${consultaEstoqueBloc.gradeTamanhosList[index]}",
                                      style: Theme.of(context).textTheme.subhead,
                                    ),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    "${gradeList[index].estoqueAtual}"
                                    , style: Theme.of(context).textTheme.subhead)
                                )
                              ]),
                            ),
                          ),
                          onTap: () async {
                            if(consultaEstoqueBloc.produto.produtoVariante != null && consultaEstoqueBloc.produto.produtoVariante.length > 0){
                              consultaEstoqueBloc.tamanho = index+1;
                              await consultaEstoqueBloc.setProdutoTamanhoSelecionado(index+1, consultaEstoqueBloc.gradeTamanhosList[index]);
                              consultaEstoqueBloc.consultaVarianteByGrade(index+1);
                              consultaEstoqueBloc.pageController.jumpToPage(2);
                            }
                          },
                        ),
                      );
                    }
                  );
                }
              ),
            ),
          ]
        )
      ]
    );
  }
}
