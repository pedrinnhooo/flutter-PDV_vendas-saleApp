import 'package:fluggy/generated/locale_base.dart';
import 'package:flutter/material.dart';
import 'package:fluggy/src/pages/cadastro/contato/detail/contato_detail_page.dart';
import 'package:common_files/common_files.dart';

class ContatoListPage extends StatefulWidget {
  PessoaBloc pessoaBloc;
  ContatoListPage({this.pessoaBloc});

  @override
  _ContatoListPageState createState() => _ContatoListPageState();
}

class _ContatoListPageState extends State<ContatoListPage> {


  @override
  Widget build(BuildContext context) {
  
    final locale = Localizations.of<LocaleBase>(context, LocaleBase);
    
    Widget body2 = Expanded(
      child: Container(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "Não há nenhum contato cadastrado.",
              style: Theme.of(context).textTheme.title,
            ),
            SizedBox(
              height: 10,
            ),
            ButtonTheme(
              height: 40,
              minWidth: 200,
              child: RaisedButton(
                color: Theme.of(context).primaryIconTheme.color,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)
                ),
                child: Text("Incluir",//locale.palavra.gravar,
                  style: Theme.of(context).textTheme.title,
                ),
                onPressed: () async {
                  await widget.pessoaBloc.newContato();
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (c, a1, a2) => ContatoDetailPage(pessoaBloc: widget.pessoaBloc),
                      settings: RouteSettings(name: '/DetalheContato'),
                      transitionsBuilder: (c, anim, a2, child) =>
                          FadeTransition(
                              opacity: anim, child: child),
                      transitionDuration:
                          Duration(milliseconds: 180),
                    ),
                  );
                },
              )
            ),            
          ],
        ), 
      )  
    );  

    Widget body1 = Expanded(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            StreamBuilder<Pessoa>(
              initialData: Pessoa(),
              stream: widget.pessoaBloc.pessoaOut,
              builder: (context, snapshot) {
                List<Contato> contatoList = snapshot.data.contato;
                return ListView.builder(
                  physics: ClampingScrollPhysics(),
                  padding: EdgeInsets.only(left: 8, right: 8),
                  shrinkWrap: true,
                  itemCount: contatoList.length,
                  itemBuilder: (context, index) {
                    return Visibility(
                      visible: widget.pessoaBloc.pessoa.contato
                        [index].ehDeletado == 0,
                      child: Card(
                        color: Theme.of(context).accentColor,
                        child: Column(
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.only(top: 12, left: 8, right: 8),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Row(
                                    children: <Widget>[
                                      Text(contatoList[index].nome,
                                        style: Theme.of(context).textTheme.title
                                      ),
                                      Visibility(
                                        visible: contatoList[index].ehPrincipal == 1 ? true : false,
                                        child: Padding(
                                          padding: const EdgeInsets.only(left:5),
                                          child: Icon(
                                            Icons.check,
                                            color: Theme.of(context).primaryIconTheme.color,
                                          ),
                                        ),
                                      )                                          
                                    ],
                                  ),
                                  InkWell(
                                    child: Icon(
                                      Icons.edit, 
                                      color: Theme.of(context).primaryIconTheme.color),
                                      onTap: () async {
                                      await widget.pessoaBloc.getContatoByPessoa(index);
                                      Navigator.push(
                                        context,
                                        PageRouteBuilder(
                                          pageBuilder: (c, a1, a2) => ContatoDetailPage(pessoaBloc: widget.pessoaBloc),
                                          settings: RouteSettings(name: '/DetalheContato'),
                                          transitionsBuilder: (c, anim, a2, child) =>
                                              FadeTransition(
                                                  opacity: anim, child: child),
                                          transitionDuration:
                                              Duration(milliseconds: 180),
                                        ),
                                      );
                                    },
                                  ),                                          
                                ],
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.only(top: 15, left: 15, right: 15),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Row(
                                        children: <Widget>[
                                          Icon(
                                            Icons.phone,
                                            color: Theme.of(context).primaryIconTheme.color,
                                            size: 17,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(left: 3, bottom: 3),
                                            child: Text("Telefone 1",
                                              style: Theme.of(context).textTheme.display3,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Text(contatoList[index].telefone1,
                                        style: Theme.of(context).textTheme.body2
                                      ),
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Row(
                                        children: <Widget>[
                                          Icon(
                                            Icons.phone,
                                            color: Theme.of(context).primaryIconTheme.color,
                                            size: 17,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(left: 3, bottom: 3),
                                            child: Text("Telefone 2",
                                              style: Theme.of(context).textTheme.display3,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Text(contatoList[index].telefone2,
                                        style: Theme.of(context).textTheme.body2
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.only(top: 12, left: 15, right: 15, bottom: 12),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Container(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          children: <Widget>[
                                            Container(
                                              child: Row(
                                                children: <Widget>[
                                                  Icon(
                                                    Icons.email,
                                                    color: Theme.of(context).primaryIconTheme.color,
                                                    size: 17,
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets.only(left: 3),
                                                    child: Text("Email",
                                                      style: Theme.of(context).textTheme.display3,
                                                    ),
                                                  ),
                                                ]
                                              ),
                                            ),    
                                          ],
                                        ),
                                        Text(contatoList[index].email,
                                          style: Theme.of(context).textTheme.body2
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            )                                    
                          ],
                        ),
                      ),
                    );
                  },
                );
              }
            ), 
          ],
        ),
      ),
    );  

    Widget body = widget.pessoaBloc.pessoa.contato.length > 0
      ? body1
      : body2;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(locale.cadastroContato.titulo, 
          style: Theme.of(context).textTheme.title,
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.add_circle,
              size: 30,
            ),
            onPressed: () async {
              await widget.pessoaBloc.newContato();
              Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder: (c, a1, a2) => ContatoDetailPage(pessoaBloc: widget.pessoaBloc),
                  settings: RouteSettings(name: '/DetalheContato'),
                  transitionsBuilder: (c, anim, a2, child) =>
                      FadeTransition(
                          opacity: anim, child: child),
                  transitionDuration:
                      Duration(milliseconds: 180),
                ),
              );
            },
          ),        
        ],
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
