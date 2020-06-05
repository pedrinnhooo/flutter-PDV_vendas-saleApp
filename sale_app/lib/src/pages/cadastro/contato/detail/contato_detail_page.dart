import 'package:fluggy/generated/locale_base.dart';
import 'package:flutter/material.dart';
import 'package:common_files/common_files.dart';

class ContatoDetailPage extends StatefulWidget {
  PessoaBloc pessoaBloc;
    ContatoDetailPage({this.pessoaBloc});
  
  @override
  _ContatoDetailPageState createState() => _ContatoDetailPageState();
}

class _ContatoDetailPageState extends State<ContatoDetailPage> {
  TextEditingController nomeController;
  TextEditingController telefone1Controller;
  TextEditingController telefone2Controller;
  TextEditingController emailController;
  
  @override
  void initState() {
    nomeController = TextEditingController();
    nomeController.value =  nomeController.value.copyWith(text: widget.pessoaBloc.pessoa.contato[
                                                                  widget.pessoaBloc.indexContato
                                                                ].nome); 
    telefone1Controller = TextEditingController();
    telefone1Controller.value =  telefone1Controller.value.copyWith(text: widget.pessoaBloc.pessoa.contato[
                                                                  widget.pessoaBloc.indexContato
                                                                ].telefone1); 
    telefone2Controller = TextEditingController();
    telefone2Controller.value =  telefone2Controller.value.copyWith(text: widget.pessoaBloc.pessoa.contato[
                                                                  widget.pessoaBloc.indexContato
                                                                ].telefone2); 
    emailController = TextEditingController();
    emailController.value =  emailController.value.copyWith(text: widget.pessoaBloc.pessoa.contato[
                                                                  widget.pessoaBloc.indexContato
                                                                ].email); 
    super.initState();
  } 
  
  @override
  Widget build(BuildContext context) {

    final locale = Localizations.of<LocaleBase>(context, LocaleBase);

    return Scaffold(
      appBar: AppBar(
        title: Text(locale.cadastroContato.titulo, 
          style: Theme.of(context).textTheme.title,),
        leading: InkWell(
          child: Icon(
            Icons.arrow_back
          ),
          onTap: () async {
            await widget.pessoaBloc.validaContatoEmail();
            if (!widget.pessoaBloc.contatoEmailInvalido) {
              await widget.pessoaBloc.validaContatoVazio();
              Navigator.pop(context);
            }  
          },
        ),
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
                     child: Text(widget.pessoaBloc.pessoa.contato
                       [widget.pessoaBloc.indexContato].id != null 
                       ? locale.palavra.alterar + " " + locale.cadastroContato.titulo.toLowerCase()
                       : locale.cadastro.incluirNovo,
                       style: Theme.of(context).textTheme.title,
                     ),
                   ),
                   Container(
                     padding: EdgeInsets.only(right: 15),
                     child: InkWell(
                         child: Text(widget.pessoaBloc.pessoa.id != null ? locale.palavra.excluir : locale.palavra.limpar,
                         style: Theme.of(context).textTheme.display1,
                       ),
                       onTap: () async {
                         if (widget.pessoaBloc.pessoa.id != null) {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) => CustomDialogConfirmation(
                              title: locale.palavra.confirmacao,
                              description: locale.mensagem.confirmarExcluirRegistro +
                                locale.palavra.artigo_o + " " +
                                locale.cadastroContato.titulo.toLowerCase() + " ",
                              item: widget.pessoaBloc.pessoa.contato
                                [widget.pessoaBloc.indexContato].nome ,
                              buttonOkText: locale.palavra.excluir,
                              buttonCancelText: locale.palavra.cancelar,
                              funcaoBotaoOk: () async {
                                await widget.pessoaBloc.deleteContato();
                                Navigator.pop(context);
                                Navigator.pop(context);
                              },
                              funcaoBotaoCancelar: () async {
                                Navigator.pop(context);
                              }
                            ),
                          );                           
                         } else {
                           await widget.pessoaBloc.newPessoa();
                            nomeController.clear();
                            telefone1Controller.clear();
                            telefone2Controller.clear();
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
                  child: StreamBuilder<Contato>(
                    initialData: Contato(),
                    stream: widget.pessoaBloc.contatoOut,
                    builder: (context, snapshot) {
                      Contato contato = snapshot.data;
                      return Column(
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
                                          stream: widget.pessoaBloc.contatoNomeInvalidoOut,
                                          builder: (context, snapshot) {
                                            return customTextField(
                                              context,
                                               //autofocus: contato.nome != "" ? false : true,
                                              controller: nomeController,
                                              labelText: locale.palavra.nome,
                                              errorText: snapshot.data ? locale.mensagem.nomeNaoNulo : null,
                                              onChanged: (text) {
                                                contato.nome = text;
                                              }   
                                            );
                                          }
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        StreamBuilder<bool>(
                                          initialData: false,
                                          stream: widget.pessoaBloc.fantasiaApelidoInvalidoOut,
                                          builder: (context, snapshot) {
                                            return customTextField(
                                              context,
                                              controller: telefone1Controller,
                                              labelText: locale.palavra.telefone + " 1",
                                              onChanged: (text) {
                                                contato.telefone1 = text;
                                              }   
                                            );
                                          }
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        StreamBuilder<bool>(
                                          initialData: false,
                                          stream: widget.pessoaBloc.cnpjCpfInvalidoOut,
                                          builder: (context, snapshot) {
                                            return customTextField(
                                              context,
                                              controller: telefone2Controller,
                                              labelText: locale.palavra.telefone + " 2",
                                              onChanged: (text) {
                                                contato.telefone2 = text;
                                              }   
                                            );
                                          }
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        StreamBuilder<bool>(
                                          initialData: false,
                                          stream: widget.pessoaBloc.contatoEmailInvalidoOut,
                                          builder: (context, snapshot) {
                                            return customTextField(
                                              context,
                                              controller: emailController,
                                              labelText: locale.palavra.email,
                                              errorText: snapshot.data ? "Email inválido" : null,
                                              onChanged: (text) {
                                                contato.email = text;
                                              }   
                                            );
                                          }  
                                        )
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
                                  minWidth: 200,
                                  child: RaisedButton(
                                    color: Theme.of(context).primaryIconTheme.color,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12)
                                    ),
                                    child: Text("Voltar",//locale.palavra.gravar,
                                      style: Theme.of(context).textTheme.title,
                                    ),
                                    onPressed: () async {
                                      /*await widget.pessoaBloc.validaForm();
                                      if (!widget.pessoaBloc.formInvalido){
                                        await widget.pessoaBloc.saveContato();
                                        //await widget.pessoaBloc.getAllPessoa();
                                        Navigator.pop(context);
                                      } else {
                                        print("Error form invalido: ");
                                      }*/
                                      await widget.pessoaBloc.validaContatoEmail();
                                      if (!widget.pessoaBloc.contatoEmailInvalido) {
                                        await widget.pessoaBloc.validaContatoVazio();
                                        Navigator.pop(context);
                                      }  
                                    },
                                  )
                                ),
                              ],
                            ),
                          )
                        ]  
                      );
                    }
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
    print("Dispose Loja Detail");
    widget.pessoaBloc.limpaValidacoes();
    super.dispose();
  } 
}