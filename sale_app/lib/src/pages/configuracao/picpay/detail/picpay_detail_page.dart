import 'package:common_files/common_files.dart';
import 'package:fluggy/generated/locale_base.dart';
import 'package:fluggy/src/app_module.dart';
import 'package:fluggy/src/pages/configuracao/terminal/terminal_module.dart';
import 'package:flutter/material.dart';

class PicpayDetailPage extends StatefulWidget {
  @override
  _PicpayDetailPageDetailPageState createState() => _PicpayDetailPageDetailPageState();
}

class _PicpayDetailPageDetailPageState extends State<PicpayDetailPage> {
  IntegracaoBloc integracaoBloc;
  AppGlobalBloc _appGlobalBloc;
  TerminalBloc terminalBloc;
  TextEditingController acessTokenController;
  TextEditingController userIdController;

  @override
  void initState() {
    integracaoBloc = TerminalModule.to.getBloc<IntegracaoBloc>(); 
    terminalBloc = TerminalModule.to.getBloc<TerminalBloc>();
    _appGlobalBloc = AppModule.to.getBloc<AppGlobalBloc>();
    acessTokenController = TextEditingController();
    acessTokenController.value =  acessTokenController.value.copyWith(text: integracaoBloc.integracao.picpayAcessToken); 
    super.initState();
  } 
  
  @override 
  Widget build(BuildContext context) {

    final locale = Localizations.of<LocaleBase>(context, LocaleBase);

    return Scaffold(
      appBar: AppBar(
        title: Text("PicPay"),
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
                     child: Text(integracaoBloc.integracao.id != null 
                       ? locale.palavra.alterar + " " + "Cadastro PicPay".toLowerCase()
                       : locale.cadastro.incluirNovo,
                       style: Theme.of(context).textTheme.title,
                     ),
                   ),
                   Container(
                     padding: EdgeInsets.only(right: 15),
                     child: InkWell(
                         child: Text(integracaoBloc.integracao.id != null ? locale.palavra.excluir : locale.palavra.limpar,
                         style: Theme.of(context).textTheme.display1,
                       ),
                       onTap: () async {
                         if (integracaoBloc.integracao.id != null) {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) => CustomDialogConfirmation(
                              title: locale.palavra.confirmacao,
                              description: locale.mensagem.confirmarExcluirRegistro +
                                locale.palavra.artigo_a + " " +
                                "Integração com a PicPay".toLowerCase() + " ",                   
                              buttonOkText: locale.palavra.excluir,
                              buttonCancelText: locale.palavra.cancelar,
                              funcaoBotaoOk: () async {
                                await integracaoBloc.deleteIntegracao();
                                await integracaoBloc.getAllIntegracao();
                                Navigator.pop(context);
                                Navigator.pop(context);
                              },
                              funcaoBotaoCancelar: () async {
                                Navigator.pop(context);
                              }
                            ),
                          );      
                         } else {
                           await integracaoBloc.newIntegracao();
                           acessTokenController.clear();
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
                                    SizedBox(height: 15),
                                    Center(child: Image.asset("assets/logopicpay.png", width: 120)),
                                    SizedBox(height: 15),
                                    StreamBuilder<bool>(
                                      initialData: false,
                                      stream: integracaoBloc.acessTokenInvalidoOut,
                                      builder: (context, snapshot) {
                                        return customTextField(
                                          context,
                                          autofocus: integracaoBloc.integracao.id != null ? false : true,
                                          controller: acessTokenController,
                                          labelText: "Acess Token",
                                          errorText: snapshot.data ? "Acess Token não pode ser vazio" : "",

                                          onChanged: (text) {
                                              integracaoBloc.integracao.picpayAcessToken = text;
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
                            Expanded(
                              child: ButtonTheme(
                                height: 40,
                                minWidth: double.infinity,
                                child: RaisedButton(
                                  color: Theme.of(context).primaryIconTheme.color,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12)
                                  ),
                                  child: Text("Vincular",
                                    style: Theme.of(context).textTheme.title,
                                  ),
                                  onPressed: () async {
                                  await integracaoBloc.validaPicpayAcessToken();
                                  terminalBloc.terminal.temPicpay = 1;
                                  if (!integracaoBloc.formInvalido){
                                    terminalBloc.setPicpayAccessToken(integracaoBloc.integracao.picpayAcessToken);
                                    print("Acess Token: "+integracaoBloc.integracao.picpayAcessToken);    
                                    Navigator.pop(context);   
                                  } else {
                                     print("Error form invalido: "); 
                                    }
                                         
                                  },
                                )
                              ),
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

  //  @override
  //  void dispose() {
  //    print("Dispose Mercadopago Detail");
  //    integracaoBloc.limpaValidacoes();
  //    super.dispose();
  //  }   
}