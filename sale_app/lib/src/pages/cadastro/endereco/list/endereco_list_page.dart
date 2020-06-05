import 'package:common_files/common_files.dart';
import 'package:fluggy/generated/locale_base.dart';
import 'package:flutter/material.dart';
import 'package:fluggy/src/pages/cadastro/endereco/detail/endereco_detail_page.dart';
class EnderecoListPage extends StatefulWidget {
  PessoaBloc pessoaBloc;
  EnderecoListPage({this.pessoaBloc});

  @override
  _EnderecoListPageState createState() => _EnderecoListPageState();
}

class _EnderecoListPageState extends State<EnderecoListPage> {
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
              "Não há nenhum endereço cadastrado.",
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
                      pageBuilder: (c, a1, a2) => EnderecoDetailPage(pessoaBloc: widget.pessoaBloc),
                      settings: RouteSettings(name: '/DetalheEndereco'),
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
                List<Endereco> enderecoList = snapshot.data.endereco;
                return ListView.builder(
                  physics: ClampingScrollPhysics(),
                  padding: EdgeInsets.only(left: 8, right: 8),
                  shrinkWrap: true,
                  itemCount: enderecoList.length,
                  itemBuilder: (context, index) {
                    return Visibility(
                      visible: enderecoList[index].ehDeletado == 0,
                      child: Card(
                        color: Theme.of(context).accentColor,
                        child: Column(
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.only(top: 12, left: 8, right: 8),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(enderecoList[index].apelido,
                                    style: Theme.of(context).textTheme.title
                                  ),
                                  Container(
                                    height: 30,
                                    width: 30,
                                    child: InkWell(
                                      child: Icon(
                                        Icons.edit, 
                                        color: Theme.of(context).primaryIconTheme.color),
                                        onTap: () async {
                                        await widget.pessoaBloc.getEnderecoByPessoa(index);
                                        Navigator.push(
                                          context,
                                          PageRouteBuilder(
                                            pageBuilder: (c, a1, a2) => EnderecoDetailPage(pessoaBloc: widget.pessoaBloc),
                                            settings: RouteSettings(name: '/DetalheEndereco'),
                                            transitionsBuilder: (c, anim, a2, child) =>
                                                FadeTransition(
                                                    opacity: anim, child: child),
                                            transitionDuration:
                                                Duration(milliseconds: 180),
                                          ),
                                        );
                                      },
                                    ),
                                  ),                                          
                                ],
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.only(top: 15, left: 15, right: 15, bottom: 12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Row(
                                    children: <Widget>[
                                      Icon(
                                        Icons.room,
                                        color: Theme.of(context).primaryIconTheme.color,
                                        size: 16,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 3),
                                        child: Text(locale.palavra.endereco,
                                          style: Theme.of(context).textTheme.display3,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Text(enderecoList[index].numero != "" ? enderecoList[index].logradouro + " , "+enderecoList[index].numero : "",
                                    style: Theme.of(context).textTheme.body2
                                  ),
                                ],
                              ),
                            ),
                            Visibility(
                              visible: enderecoList[index].complemento != "",
                              child: Container(
                                padding: EdgeInsets.only(left: 15, right: 15, bottom: 12),
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
                                                      Icons.extension,
                                                      color: Theme.of(context).primaryIconTheme.color,
                                                      size: 17,
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets.only(left: 3),
                                                      child: Text("Complemento",
                                                        style: Theme.of(context).textTheme.display3,
                                                      ),
                                                    ),
                                                  ]
                                                ),
                                              ),    
                                            ],
                                          ),
                                          Text(enderecoList[index].complemento,
                                            style: Theme.of(context).textTheme.body2
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.only(left: 15, right: 15, bottom: 12),
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
                                                    Icons.group,
                                                    color: Theme.of(context).primaryIconTheme.color,
                                                    size: 17,
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets.only(left: 3),
                                                    child: Text("Bairro",
                                                      style: Theme.of(context).textTheme.display3,
                                                    ),
                                                  ),
                                                ]
                                              ),
                                            ),    
                                          ],
                                        ),
                                        Text(enderecoList[index].bairro,
                                          style: Theme.of(context).textTheme.body2
                                        ),
                                      ],
                                    ),
                                  ),
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
                                                  Image.asset(
                                                    'assets/email-alert.png',
                                                    color: Theme.of(context).primaryIconTheme.color,
                                                    fit: BoxFit.contain,
                                                    height: 18,
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets.only(left: 3),
                                                    child: Text("Cep",
                                                      style: Theme.of(context).textTheme.display3,
                                                    ),
                                                  ),
                                                ]
                                              ),
                                            ),    
                                          ],
                                        ),
                                        Text(enderecoList[index].cep,
                                          style: Theme.of(context).textTheme.body2
                                        ),
                                      ],
                                    ),
                                  ),

                                ],
                              ),
                            ),                                    
                            Container(
                              padding: EdgeInsets.only(left: 15, right: 15, bottom: 12),
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
                                                    Icons.location_city,
                                                    color: Theme.of(context).primaryIconTheme.color,
                                                    size: 17,
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets.only(left: 3),
                                                    child: Text("Cidade",
                                                      style: Theme.of(context).textTheme.display3,
                                                    ),
                                                  ),
                                                ]
                                              ),
                                            ),    
                                          ],
                                        ),
                                        Text(enderecoList[index].municipio,
                                          style: Theme.of(context).textTheme.body2
                                        ),
                                      ],
                                    ),
                                  ),
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
                                                  Image.asset(
                                                    'assets/city-variant.png',
                                                    color: Theme.of(context).primaryIconTheme.color,
                                                    fit: BoxFit.contain,
                                                    height: 18,
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets.only(left: 3),
                                                    child: Text("Estado",
                                                      style: Theme.of(context).textTheme.display3,
                                                    ),
                                                  ),
                                                ]
                                              ),
                                            ),    
                                          ],
                                        ),
                                        Text(enderecoList[index].estado,
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

    Widget body = widget.pessoaBloc.pessoa.endereco.length > 0
      ? body1
      : body2;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(locale.palavra.endereco),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.add_circle,
              size: 30,
            ),
            onPressed: () async {
              await widget.pessoaBloc.newEndereco();
              Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder: (c, a1, a2) => EnderecoDetailPage(pessoaBloc: widget.pessoaBloc),
                  settings: RouteSettings(name: '/DetalheEndereco'),
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