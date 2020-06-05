import 'package:common_files/common_files.dart';
import 'package:fluggy/generated/locale_base.dart';
import 'package:flutter/material.dart';
import 'package:fluggy/src/pages/configuracao/vendedor/vendedor_module.dart';

class VendedorDetailPage extends StatefulWidget {
  @override
  _VendedorDetailPageState createState() => _VendedorDetailPageState();
}

class _VendedorDetailPageState extends State<VendedorDetailPage> {
  VendedorBloc vendedorBloc;
  TextEditingController nomeController;

  @override
  void initState() {
    vendedorBloc = VendedorModule.to.getBloc<VendedorBloc>();
    nomeController = TextEditingController();
    nomeController.value =  nomeController.value.copyWith(text: vendedorBloc.pessoa.razaoNome); 
    super.initState();
  } 
  
  @override
  Widget build(BuildContext context) {

    final locale = Localizations.of<LocaleBase>(context, LocaleBase);

    return Scaffold(
      appBar: AppBar(
        title: Text(locale.cadastroVendedor.titulo, 
          style: Theme.of(context).textTheme.title,
        )
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
                children: <Widget>[
                   Container(
                     padding: EdgeInsets.only(left: 10),
                     child: Text(vendedorBloc.pessoa.id != null 
                       ? locale.palavra.alterar + " " + locale.cadastroVendedor.titulo.toLowerCase()
                       : locale.cadastro.incluirNovo,
                       style: Theme.of(context).textTheme.subhead,
                     ),
                   ),
                   Container(
                     padding: EdgeInsets.only(right: 15),
                     child: InkWell(
                         child: Text(vendedorBloc.pessoa.id != null ? locale.palavra.excluir : locale.palavra.limpar,
                         style: Theme.of(context).textTheme.subhead,
                       ),
                       onTap: () async {
                         if (vendedorBloc.pessoa.id != null) {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) => CustomDialogConfirmation(
                              title: locale.palavra.confirmacao,
                              description: locale.mensagem.confirmarExcluirRegistro +
                                locale.palavra.artigo_o + " " +
                                locale.cadastroVendedor.titulo.toLowerCase() + " ",
                              item: vendedorBloc.pessoa.razaoNome ,
                              buttonOkText: locale.palavra.excluir,
                              buttonCancelText: locale.palavra.cancelar,
                              funcaoBotaoOk: () async {
                                await vendedorBloc.deletePessoa();
                                await vendedorBloc.getAllPessoa();
                                Navigator.pop(context);
                                Navigator.pop(context);
                              },
                              funcaoBotaoCancelar: () async {
                                Navigator.pop(context);
                              }
                            ),
                          );                           
                         } else {
                           await vendedorBloc.newPessoa();
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
                  padding: EdgeInsets.only(top: 8),
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
                                      stream: vendedorBloc.razaoNomeInvalidoOut,
                                      builder: (context, snapshot) {
                                        return customTextField(
                                          context,
                                          autofocus: vendedorBloc.pessoa.id != null ? false : true,
                                          controller: nomeController,
                                          labelText: locale.palavra.nome,
                                          errorText: snapshot.data ? locale.mensagem.nomeNaoNulo : null,
                                          onChanged: (text) {
                                              vendedorBloc.pessoa.razaoNome = text;
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
                                  vendedorBloc.validaForm();
                                  if (!vendedorBloc.formInvalido){
                                    print("Nome: "+vendedorBloc.pessoa.razaoNome);
                                    await vendedorBloc.savePessoa();
                                    await vendedorBloc.getAllPessoa();
                                    Navigator.pop(context);
                                  } else {
                                    print("Error form invalido: ");
                                  }
                                                                    
                                  //await vendedorBloc.saveCategoria();
                                  // vendedorBloc.pageController.animateToPage(0,
                                  //   duration: Duration(milliseconds: 600),
                                  //   curve: Curves.fastOutSlowIn);
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
    print("Dispose Vendedor Detail");
    vendedorBloc.limpaValidacoes();
    super.dispose();
  }   
}
