import 'package:common_files/common_files.dart';
import 'package:fluggy/generated/locale_base.dart';
import 'package:flutter/material.dart';
import 'package:fluggy/src/pages/cadastro/preco_tabela/preco_tabela_module.dart';

class PrecoTabelaDetailPage extends StatefulWidget {
  @override
  _PrecoTabelaDetailPageState createState() => _PrecoTabelaDetailPageState();
}

class _PrecoTabelaDetailPageState extends State<PrecoTabelaDetailPage> {
  PrecoTabelaBloc precoTabelaBloc;
  TextEditingController nomeController;

  @override
  void initState() {
    precoTabelaBloc = PrecoTabelaModule.to.getBloc<PrecoTabelaBloc>();
    nomeController = TextEditingController();
    nomeController.value =  nomeController.value.copyWith(text: precoTabelaBloc.precoTabela.nome); 
    super.initState();
  } 
  
  @override
  Widget build(BuildContext context) {

    final locale = Localizations.of<LocaleBase>(context, LocaleBase);

    return Scaffold(
      appBar: AppBar(
        title: Text(locale.cadastroPrecoTabela.titulo, 
style: Theme.of(context).textTheme.title,)
      ),      
      body: Container(
        color: Theme.of(context).primaryColor,
        child: Column(
          children: <Widget>[
            Container(
              //color: Colors.white38,
              height: 60,
              padding: const EdgeInsets.only(bottom: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                   Container(
                     padding: EdgeInsets.only(left: 10),
                     child: Text(precoTabelaBloc.precoTabela.id != null 
                       ? locale.palavra.alterar + " " + locale.cadastroPrecoTabela.titulo.toLowerCase()
                       : locale.cadastro.incluirNovo,
                       style: Theme.of(context).textTheme.title,
                     ),
                   ),
                   Container(
                     padding: EdgeInsets.only(right: 15),
                     child: InkWell(
                         child: Text(precoTabelaBloc.precoTabela.id != null ? locale.palavra.excluir : locale.palavra.limpar,
                         style: Theme.of(context).textTheme.display1,
                       ),
                       onTap: () async {
                         if (precoTabelaBloc.precoTabela.id != null) {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) => CustomDialogConfirmation(
                              title: locale.palavra.confirmacao,
                              description: locale.mensagem.confirmarExcluirRegistro +
                                locale.palavra.artigo_a + " " +
                                locale.cadastroPrecoTabela.titulo.toLowerCase() + " ",
                              item: precoTabelaBloc.precoTabela.nome ,
                              buttonOkText: locale.palavra.excluir,
                              buttonCancelText: locale.palavra.cancelar,
                              funcaoBotaoOk: () async {
                                await precoTabelaBloc.deletePrecoTabela();
                                await precoTabelaBloc.getAllPrecoTabela();
                                Navigator.pop(context);
                                Navigator.pop(context);
                              },
                              funcaoBotaoCancelar: () async {
                                Navigator.pop(context);
                              }
                            ),
                          );                           
                           
                         } else {
                           await precoTabelaBloc.newPrecoTabela();
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
                          child: Row(
                          children: <Widget>[
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(left: 10, right: 10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    StreamBuilder<bool>(
                                      initialData: false,
                                      stream: precoTabelaBloc.nomeInvalidoOut,
                                      builder: (context, snapshot) {
                                        return customTextField(
                                          context,
                                          autofocus: precoTabelaBloc.precoTabela.id != null ? false : true,
                                          controller: nomeController,
                                          labelText: locale.palavra.nome,
                                          errorText: snapshot.data ? locale.mensagem.nomeNaoNulo : "",
                                          onChanged: (text) {
                                              precoTabelaBloc.precoTabela.nome = text;
                                          }   
                                        );
                                      }
                                    ),
                                  ],
                                ),
                              ),
                            )
                            ],
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(top: 10, bottom: 10, left: 20, right: 20),
                        width: double.infinity,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            ButtonTheme(
                              height: 40,
                              minWidth: 50,
                              child: RaisedButton(
                                color: Colors.grey,//Theme.of(context).primaryColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)
                                ),
                                child: Text(locale.palavra.cancelar,
                                  style: Theme.of(context).textTheme.title,
                                ),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              )
                            ),
                            ButtonTheme(
                              height: 40,
                              minWidth: 200,
                              child: RaisedButton(
                                color: Theme.of(context).primaryIconTheme.color,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)
                                ),
                                child: Text(locale.palavra.gravar,
                                  style: Theme.of(context).textTheme.title,
                                ),
                                onPressed: () async {
                                  precoTabelaBloc.validaNome();
                                  if (!precoTabelaBloc.formInvalido){
                                    print("Nome: "+precoTabelaBloc.precoTabela.nome);
                                    await precoTabelaBloc.savePrecoTabela();
                                    await precoTabelaBloc.getAllPrecoTabela();
                                    Navigator.pop(context);
                                  } else {
                                    print("Error form invalido: ");
                                  }
                                },
                              )
                            ),
                          ],
                        ),
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

  @override
  void dispose() {
    print("Dispose PrecoTabela Detail");
    precoTabelaBloc.limpaValidacoes();
    super.dispose();
  }  
}
