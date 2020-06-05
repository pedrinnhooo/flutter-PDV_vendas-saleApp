import 'package:fluggy/generated/locale_base.dart';
import 'package:flutter/material.dart';
import 'package:common_files/common_files.dart';
class EnderecoDetailPage extends StatefulWidget {
  PessoaBloc pessoaBloc;
  EnderecoDetailPage({this.pessoaBloc});
  
  @override
  _EnderecoDetailPageState createState() => _EnderecoDetailPageState();
}

class _EnderecoDetailPageState extends State<EnderecoDetailPage> {

  @override
  void initState() {
    super.initState();
  } 
  
  @override
  Widget build(BuildContext context) {

    final locale = Localizations.of<LocaleBase>(context, LocaleBase);

    return Scaffold(
      appBar: AppBar(
        title: Text(locale.palavra.endereco),
        leading: InkWell(
          child: Icon(
            Icons.arrow_back
          ),
          onTap: () async {
            await widget.pessoaBloc.validaEnderecoVazio();
            Navigator.pop(context);
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
                     child: Text(widget.pessoaBloc.pessoa.endereco
                       [widget.pessoaBloc.indexEndereco].id != null 
                       ? locale.palavra.alterar + " " + locale.palavra.endereco.toLowerCase()
                       : locale.cadastro.incluirNovo,
                       style: Theme.of(context).textTheme.title,
                     ),
                   ),
                   Container(
                     padding: EdgeInsets.only(right: 15),
                     child: InkWell(
                         child: Text(widget.pessoaBloc.pessoa.endereco[widget.pessoaBloc.indexEndereco].id != null ? locale.palavra.excluir : locale.palavra.limpar,
                         style: Theme.of(context).textTheme.display1,
                       ),
                       onTap: () async {
                         if (widget.pessoaBloc.pessoa.endereco[widget.pessoaBloc.indexEndereco].id != null) {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) => CustomDialogConfirmation(
                              title: locale.palavra.confirmacao,
                              description: locale.mensagem.confirmarExcluirRegistro +
                                locale.palavra.artigo_o + " " +
                                locale.palavra.endereco.toLowerCase() + " ",
                              item: widget.pessoaBloc.pessoa.endereco
                                [widget.pessoaBloc.indexEndereco].apelido ,
                              buttonOkText: locale.palavra.excluir,
                              buttonCancelText: locale.palavra.cancelar,
                              funcaoBotaoOk: () async {
                                await widget.pessoaBloc.deleteEndereco();
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
                          //  apelidoController.clear();
                          //  logradouroController.clear();
                          //  numeroController.clear();
                          //  complementoController.clear();
                          //  bairroController.clear();
                          //  municipioController.clear();
                          //  estadoController.clear();
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
                  child: StreamBuilder<Endereco>(
                    initialData: Endereco(),
                    stream: widget.pessoaBloc.enderecoOut,
                    builder: (context, snapshot) {
                      Endereco endereco = snapshot.data;
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
                                          stream: widget.pessoaBloc.enderecoApelidoInvalidoOut,
                                          builder: (context, snapshot) {
                                            return customTextField(
                                              context,
                                               //autofocus: contato.nome != "" ? false : true,
                                              controller: widget.pessoaBloc.apelidoController,
                                              labelText: locale.palavra.apelido,
                                              errorText: snapshot.data ? locale.mensagem.nomeNaoNulo : null,
                                              onChanged: (text) {
                                                endereco.apelido = text;
                                              }   
                                            );
                                          }
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Row(
                                          children: <Widget>[
                                            StreamBuilder<bool>(
                                              initialData: false,
                                              stream: widget.pessoaBloc.enderecoCepInvalidoOut,
                                              builder: (context, snapshot) {
                                                return Expanded(
                                                  child: numberTextField(
                                                      context,
                                                      controller: widget.pessoaBloc.cepTextController,
                                                      labelText: locale.palavra.cep,
                                                      errorText: snapshot.data ? "Cep inválido" : null,
                                                      onChanged: (text) {
                                                        endereco.cep = text;
                                                      }   
                                                    ),
                                                );
                                              }  
                                            ),
                                            InkWell(
                                              child: Icon(
                                                Icons.search,
                                                color: Colors.white,
                                              ),
                                              onTap: () async {
                                                await widget.pessoaBloc.searchCep();    
                                              },
                                            )
                                          ],
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        customTextField(
                                          context,
                                          controller: widget.pessoaBloc.logradouroController,
                                          labelText: locale.palavra.endereco,
                                          onChanged: (text) {
                                            endereco.logradouro = text;
                                          }   
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        customTextField(
                                          context,
                                          controller: widget.pessoaBloc.numeroController,
                                          labelText: locale.palavra.numero,
                                          onChanged: (text) {
                                            endereco.numero = text;
                                          }   
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        customTextField(
                                          context,
                                          controller: widget.pessoaBloc.complementoController,
                                          labelText: "Complemento",
                                          onChanged: (text) {
                                            endereco.complemento = text;
                                          }   
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        customTextField(
                                          context,
                                          controller: widget.pessoaBloc.bairroController,
                                          labelText: locale.palavra.bairro,
                                          onChanged: (text) {
                                            endereco.bairro = text;
                                          }
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        customTextField(
                                          context,
                                          controller: widget.pessoaBloc.municipioController,
                                          labelText: locale.palavra.cidade,
                                          onChanged: (text) {
                                            endereco.municipio = text;
                                          }   
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        customTextField(
                                          context,
                                          controller: widget.pessoaBloc.estadoController,
                                          labelText: locale.palavra.estado,
                                          onChanged: (text) {
                                            endereco.estado = text;
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
                                      await widget.pessoaBloc.validaEnderecoVazio();
                                      await widget.pessoaBloc.validaEnderecoCep();
                                      if (!widget.pessoaBloc.enderecoCepInvalido){
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
