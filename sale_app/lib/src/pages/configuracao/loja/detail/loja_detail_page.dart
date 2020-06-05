import 'package:common_files/common_files.dart';
import 'package:fluggy/generated/locale_base.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:fluggy/src/pages/cadastro/contato/list/contato_list_page.dart';
import 'package:fluggy/src/pages/cadastro/endereco/list/endereco_list_page.dart';
import 'package:fluggy/src/pages/configuracao/loja/loja_module.dart';

class LojaDetailPage extends StatefulWidget {
  @override
  _LojaDetailPageState createState() => _LojaDetailPageState();
}

class _LojaDetailPageState extends State<LojaDetailPage> {
  LojaBloc lojaBloc;
  TextEditingController razaoNomeController;
  TextEditingController apelidoFantasiaController;
  TextEditingController ieRgController;
  MaskedTextController cnpjCpfController;

  @override
  void initState() {
    lojaBloc = LojaModule.to.getBloc<LojaBloc>();
    razaoNomeController = TextEditingController();
    razaoNomeController.value =  razaoNomeController.value.copyWith(text: lojaBloc.pessoa.razaoNome); 
    apelidoFantasiaController = TextEditingController();
    apelidoFantasiaController.value =  apelidoFantasiaController.value.copyWith(text: lojaBloc.pessoa.fantasiaApelido); 
    cnpjCpfController = MaskedTextController(mask: lojaBloc.pessoa.ehFisica == 0 ? "00.000.000/0000-00" : "000.000.000-00");
    cnpjCpfController.value =  cnpjCpfController.value.copyWith(text: lojaBloc.pessoa.cnpjCpf); 
    ieRgController = TextEditingController();
    ieRgController.value =  ieRgController.value.copyWith(text: lojaBloc.pessoa.ieRg); 
    super.initState();
  } 
  
  @override
  Widget build(BuildContext context) {

    final locale = Localizations.of<LocaleBase>(context, LocaleBase);

    return Scaffold(
      appBar: AppBar(
        title: Text(locale.cadastroLoja.titulo, 
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
                     child: Text(lojaBloc.pessoa.id != null 
                       ? locale.palavra.alterar + " " + locale.cadastroLoja.titulo.toLowerCase()
                       : locale.cadastro.incluirNovo,
                       style: Theme.of(context).textTheme.title,
                     ),
                   ),
                   Container(
                     padding: EdgeInsets.only(right: 15),
                     child: InkWell(
                         child: Text(lojaBloc.pessoa.id != null ? locale.palavra.excluir : locale.palavra.limpar,
                         style: Theme.of(context).textTheme.display1,
                       ),
                       onTap: () async {
                         if (lojaBloc.pessoa.id != null) {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) => CustomDialogConfirmation(
                              title: locale.palavra.confirmacao,
                              description: locale.mensagem.confirmarExcluirRegistro +
                                locale.palavra.artigo_o + " " +
                                locale.cadastroLoja.titulo.toLowerCase() + " ",
                              item: lojaBloc.pessoa.razaoNome ,
                              buttonOkText: locale.palavra.excluir,
                              buttonCancelText: locale.palavra.cancelar,
                              funcaoBotaoOk: () async {
                                await lojaBloc.deletePessoa();
                                await lojaBloc.getAllPessoa();
                                Navigator.pop(context);
                                Navigator.pop(context);
                              },
                              funcaoBotaoCancelar: () async {
                                Navigator.pop(context);
                              }
                            ),
                          );                           
                         } else {
                           await lojaBloc.newPessoa();
                            razaoNomeController.clear();
                            apelidoFantasiaController.clear();
                            cnpjCpfController.clear();
                            ieRgController.clear();
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
                  child: StreamBuilder<Pessoa>(
                    initialData: Pessoa(),
                    stream: lojaBloc.pessoaOut,
                    builder: (context, snapshot) {
                      Pessoa pessoa = snapshot.data;
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
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Text("Tipo de pessoa",
                                              style: Theme.of(context).textTheme.subtitle,
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(right: 5),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.end,
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: <Widget>[
                                                  Radio(
                                                    activeColor: Theme.of(context).primaryIconTheme.color,
                                                    value: 0,
                                                    groupValue: pessoa.ehFisica,
                                                    onChanged: (i) {
                                                      lojaBloc.setTipoPessoa(i);
                                                      cnpjCpfController.updateMask("00.000.000/0000-00"); 
                                                      cnpjCpfController.updateText(pessoa.cnpjCpf);
                                                    },
                                                  ),
                                                  Text("Jurídica",
                                                    style: Theme.of(context).textTheme.display3,
                                                  ),
                                                  Radio(
                                                    activeColor: Theme.of(context).primaryIconTheme.color,
                                                    value: 1,
                                                    groupValue: pessoa.ehFisica,
                                                    onChanged: (i) {
                                                      lojaBloc.setTipoPessoa(i);
                                                      cnpjCpfController.updateMask("000.000.000-00");
                                                      cnpjCpfController.updateText(pessoa.cnpjCpf);
                                                    },
                                                  ),
                                                  Text("Física",
                                                    style: Theme.of(context).textTheme.display3,
                                                  ),
                                                ]
                                              ),
                                            )
                                          ],
                                        ),
                                        StreamBuilder<bool>(
                                          initialData: false,
                                          stream: lojaBloc.razaoNomeInvalidoOut,
                                          builder: (context, snapshot) {
                                            return customTextField(
                                              context,
                                              autofocus: lojaBloc.pessoa.id != null ? false : true,
                                              controller: razaoNomeController,
                                              labelText: pessoa.ehFisica == 1 ? locale.palavra.nome : locale.palavra.razaoSocial,
                                              errorText: snapshot.data ? locale.mensagem.nomeNaoNulo : null,
                                              onChanged: (text) {
                                                lojaBloc.pessoa.razaoNome = text;
                                              }   
                                            );
                                          }
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        StreamBuilder<bool>(
                                          initialData: false,
                                          stream: lojaBloc.fantasiaApelidoInvalidoOut,
                                          builder: (context, snapshot) {
                                            return customTextField(
                                              context,
                                              controller: apelidoFantasiaController,
                                              labelText: pessoa.ehFisica == 1 ? locale.palavra.apelido : locale.palavra.nomeFantasia,
                                              errorText: snapshot.data ? locale.mensagem.nomeNaoNulo : null,
                                              onChanged: (text) {
                                                lojaBloc.pessoa.razaoNome = text;
                                              }   
                                            );
                                          }
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        StreamBuilder<bool>(
                                          initialData: false,
                                          stream: lojaBloc.cnpjCpfInvalidoOut,
                                          builder: (context, snapshot) {
                                            return numberTextField(
                                              context,
                                              controller: cnpjCpfController,
                                              labelText: pessoa.ehFisica == 1 ? locale.palavra.cpf : locale.palavra.cnpj,
                                              errorText: snapshot.data ? lojaBloc.pessoa.ehFisica == 0 ? "Cnpj inválido" : "Cpf inválido" : null,
                                              onChanged: (text) {
                                                lojaBloc.pessoa.cnpjCpf = text;
                                              }   
                                            );
                                          }
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        customTextField(
                                          context,
                                          controller: ieRgController,
                                          labelText: pessoa.ehFisica == 1 ? locale.palavra.rg : locale.palavra.ie,
                                          onChanged: (text) {
                                            lojaBloc.pessoa.ieRg = text;
                                          }   
                                        ),
                                        Container(
                                          padding: EdgeInsets.only(top: 15),
                                          alignment: Alignment.topLeft,
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              Text(locale.cadastroContato.titulo,
                                                style: Theme.of(context).textTheme.subtitle,
                                              ),    
                                              
                                              InkWell(
                                                child: StreamBuilder<int>(
                                                  initialData: 0,
                                                  stream: lojaBloc.contatoCountOut,
                                                  builder: (context, snapshot) {
                                                    return Row(
                                                      children: <Widget>[
                                                        Padding(
                                                          padding: const EdgeInsets.only(right: 5),
                                                          child: Text(snapshot.data.toString(),
                                                            style: Theme.of(context).textTheme.subtitle
                                                          ),
                                                        ),
                                                        Icon(
                                                            Icons.arrow_forward_ios,
                                                            color: Theme.of(context).cursorColor,
                                                          ),
                                                      ],
                                                    );
                                                  }
                                                ),
                                                onTap: () {
                                                  Navigator.push(
                                                    context,
                                                    PageRouteBuilder(
                                                      pageBuilder: (c, a1, a2) => ContatoListPage(pessoaBloc: lojaBloc),
                                                      settings: RouteSettings(name: '/ListaContato'),
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
                                          padding: EdgeInsets.only(top: 18),
                                          alignment: Alignment.topLeft,
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              Text(locale.palavra.endereco,
                                                style: Theme.of(context).textTheme.subtitle,
                                              ),    
                                              
                                              InkWell(
                                                child: StreamBuilder<int>(
                                                  initialData: 0,
                                                  stream: lojaBloc.enderecoCountOut,
                                                  builder: (context, snapshot) {
                                                    return Row(
                                                      children: <Widget>[
                                                        Padding(
                                                          padding: const EdgeInsets.only(right: 5),
                                                          child: Text(snapshot.data.toString(),
                                                            style: Theme.of(context).textTheme.subtitle
                                                          ),
                                                        ),
                                                        Icon(
                                                            Icons.arrow_forward_ios,
                                                            color: Theme.of(context).cursorColor,
                                                          ),
                                                      ],
                                                    );
                                                  }
                                                ),
                                                onTap: () {
                                                  Navigator.push(
                                                    context,
                                                    PageRouteBuilder(
                                                      pageBuilder: (c, a1, a2) => EnderecoListPage(pessoaBloc: lojaBloc),
                                                      settings: RouteSettings(name: '/ListaEndereco'),
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
                                      lojaBloc.pessoa.cnpjCpf = cnpjCpfController.text;
                                      await lojaBloc.validaForm();
                                      if (!lojaBloc.formInvalido){
                                        print("Nome: "+lojaBloc.pessoa.razaoNome);
                                        await lojaBloc.savePessoa();
                                        //await lojaBloc.getAllPessoa();
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
    lojaBloc.limpaValidacoes();
    super.dispose();
  } 
}
