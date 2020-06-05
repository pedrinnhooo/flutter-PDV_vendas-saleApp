import 'package:fluggy/generated/locale_base.dart';
import 'package:flutter/material.dart';
import 'package:fluggy/src/pages/cadastro/produto/detail/produto_detail_page.dart';
import 'package:fluggy/src/pages/cadastro/produto/produto_module.dart';
import 'package:common_files/common_files.dart';

class ProdutoCodigoBarrasListPage extends StatefulWidget {
  @override
  _ProdutoCodigoBarrasListPageState createState() => _ProdutoCodigoBarrasListPageState();
}

class _ProdutoCodigoBarrasListPageState extends State<ProdutoCodigoBarrasListPage> {
  ProdutoBloc produtoBloc;
  
  @override
  void initState() {
    produtoBloc = ProdutoModule.to.getBloc<ProdutoBloc>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.of<LocaleBase>(context, LocaleBase);
    
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
                onSubmitted: (text) {
                  produtoBloc.filtroCodigoBarras = text;
                  produtoBloc.getAllProduto();
                },
              ),
            )
          ],
        ),
        Container(
          padding: EdgeInsets.only(right: 15),
          child: Column(
            children: <Widget>[
              Center(
                child: FloatingActionButton(
                  mini: true,
                  backgroundColor: Theme.of(context).primaryIconTheme.color,
                  //icon: Icon(Icons.add)
                  child: Icon(Icons.add,
                    color: Colors.white,
                  ),
                  onPressed: () async {
                    await produtoBloc.newCodigoBarras();
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (c, a1, a2) => ProdutoDetailPage(),
                        settings: RouteSettings(name: '/ListaProduto'),
                        transitionsBuilder: (c, anim, a2, child) =>
                            FadeTransition(
                                opacity: anim, child: child),
                        transitionDuration:
                            Duration(milliseconds: 180),
                      ),
                    );
                  },
                ),
              )
            ],
          )
        )
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
                child: SingleChildScrollView(
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            StreamBuilder(
                              initialData: List<ProdutoCodigoBarras>(),
                              stream: produtoBloc.produtoCodigoBarrasListOut,
                              builder: (context, snapshot) {
                                if(!snapshot.hasData){
                                  return CircularProgressIndicator();
                                }
                                //Produto produto = snapshot.data;
                                //List<ProdutoCodigoBarras> produtoCodigoBarrasList = produto.produtoCodigoBarras;
                                List<ProdutoCodigoBarras> produtoCodigoBarrasList = snapshot.data;

                                if (produtoCodigoBarrasList.length == 0 || produtoCodigoBarrasList.length == null) {
                                  return Center(child: CircularProgressIndicator());
                                }

                                return ListView.separated(
                                  physics: ClampingScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: produtoCodigoBarrasList.length,
                                  separatorBuilder: (context, index) {
                                    return Divider(
                                      color: Theme.of(context).primaryColor,
                                      height: 6,
                                    );
                                  },                  
                                  itemBuilder: (context, index) {
                                    String tamanho;
                                    switch (produtoCodigoBarrasList[index].gradePosicao) {
                                      case 0: tamanho = "";
                                        break;
                                      case 1: tamanho = produtoBloc.produto.grade.t1;
                                        break;
                                      case 2: tamanho = produtoBloc.produto.grade.t2;
                                        break;
                                      case 3: tamanho = produtoBloc.produto.grade.t3;
                                        break;
                                      case 4: tamanho = produtoBloc.produto.grade.t4;
                                        break;
                                      case 5: tamanho = produtoBloc.produto.grade.t5;
                                        break;
                                      case 6: tamanho = produtoBloc.produto.grade.t6;
                                        break;
                                      case 7: tamanho = produtoBloc.produto.grade.t7;
                                        break;
                                      case 8: tamanho = produtoBloc.produto.grade.t8;
                                        break;
                                      case 9: tamanho = produtoBloc.produto.grade.t9;
                                        break;
                                      case 10: tamanho = produtoBloc.produto.grade.t10;
                                        break;
                                      case 11: tamanho = produtoBloc.produto.grade.t11;
                                        break;
                                      case 12: tamanho = produtoBloc.produto.grade.t12;
                                        break;
                                      case 13: tamanho = produtoBloc.produto.grade.t13;
                                        break;
                                      case 14: tamanho = produtoBloc.produto.grade.t14;
                                        break;
                                      case 15: tamanho = produtoBloc.produto.grade.t15;
                                        break;
                                    }

                                    // var produtoCodigoBarras = produtoCodigoBarrasList.singleWhere(
                                    //     (produtoCodigoBarras) => ((produtoCodigoBarras.idVariante ==
                                    //             produtoCodigoBarrasList[index].idVariante) &&
                                    //         (produtoCodigoBarras.idProduto ==
                                    //             produtoCodigoBarrasList[index].idProduto)),
                                    //     orElse: () => null);

                                    String gradeVariante = "";
                                    if (tamanho != "") {
                                      gradeVariante = tamanho;
                                    }

                                    if ((produtoCodigoBarrasList[index].idVariante != null) &&
                                        (produtoCodigoBarrasList[index].variante.nome != "")) {
                                      gradeVariante = gradeVariante != ""
                                          ? gradeVariante + "\n" + produtoCodigoBarrasList[index].variante.nome
                                          : produtoCodigoBarrasList[index].variante.nome;
                                    }
                                    
                                    return ListTile(
                                      title: Text("${produtoCodigoBarrasList[index].codigoBarras}",
                                        style: Theme.of(context).textTheme.title,
                                      ),
                                      subtitle: Column(
                                        children: <Widget>[
                                          Row(
                                            children: <Widget>[
                                              Text(
                                                "$gradeVariante",
                                                style: Theme.of(context).textTheme.display3,
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      trailing: Container(
                                        height: 30,
                                        width: 30,
                                        child: InkWell(
                                          child: Icon(
                                            Icons.edit, 
                                            color: Theme.of(context).primaryIconTheme.color),
                                          onTap: () async {
                                            await produtoBloc.getProdutoById(produtoCodigoBarrasList[index].id);
                                            Navigator.push(
                                              context,
                                              PageRouteBuilder(
                                                pageBuilder: (c, a1, a2) => ProdutoDetailPage(),
                                                settings: RouteSettings(name: '/ListaProduto'),
                                                transitionsBuilder: (c, anim, a2, child) => FadeTransition(opacity: anim, child: child),
                                                transitionDuration: Duration(milliseconds: 180),
                                              ),
                                            );
                                          },
                                        ),
                                      )
                                    );
                                  },
                                );
                              }
                            ), 
                          ],
                        ),
                      )
                    ],    
                  ),
                ),
              )
            ],
          ),
        )
      ),
    );  

    return Scaffold(
      appBar: AppBar(
        title: Text(locale.cadastroProduto.titulo, 
style: Theme.of(context).textTheme.title,)
      ),      
      body: Container(
          color: Theme.of(context).primaryColor,
          child: Column(
            children: <Widget>[
              header,
              body
            ],
          ),
      ),
    );
  }
}

