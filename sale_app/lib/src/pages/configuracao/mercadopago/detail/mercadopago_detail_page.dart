import 'package:common_files/common_files.dart';
import 'package:fluggy/generated/locale_base.dart';
import 'package:fluggy/src/app_module.dart';
import 'package:fluggy/src/pages/configuracao/terminal/terminal_module.dart';
import 'package:flutter/material.dart';

class MercadopagoDetailPage extends StatefulWidget {
  @override
  _MercadopagoDetailPageState createState() => _MercadopagoDetailPageState();
}

class _MercadopagoDetailPageState extends State<MercadopagoDetailPage> {
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
    acessTokenController.value =  acessTokenController.value.copyWith(text: integracaoBloc.integracao.mercadopagoAcessToken); 
    userIdController = TextEditingController();
    userIdController.value =  userIdController.value.copyWith(text: integracaoBloc.integracao.mercadopagoUserId); 
    super.initState();
  } 
  
  @override 
  Widget build(BuildContext context) {

    final locale = Localizations.of<LocaleBase>(context, LocaleBase);

    return Scaffold(
      appBar: AppBar(
        title: Text("MercadoPago"),
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
                       ? locale.palavra.alterar + " " + "Cadastro MercadoPago".toLowerCase()
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
                                "Integração com o MercadoPago".toLowerCase() + " ",                   
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
                           userIdController.clear();
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
                                    Center(child: Image.asset("assets/logomercadopago.png", width: 100)),
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
                                              integracaoBloc.integracao.mercadopagoAcessToken = text;
                                          }    
                                        );
                                      }
                                    ),
                                     StreamBuilder<bool>(
                                      initialData: false,
                                      stream: integracaoBloc.userIdInvalidoOut,
                                      builder: (context, snapshot) {
                                        return customTextField(
                                          context,
                                          autofocus: integracaoBloc.integracao.id != null ? false : true,
                                          controller: userIdController,
                                          labelText: "User ID",
                                          errorText: snapshot.data ? "User ID não pode ser vazio" : "",
                                          onChanged: (text) {
                                              integracaoBloc.integracao.mercadopagoUserId = text;
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
                                  await integracaoBloc.validaMercadopagoAcessToken();
                                  await integracaoBloc.validaUserID();
                                  if (!integracaoBloc.formInvalido){
                                  terminalBloc.setMercadadopagoAccessToken(integracaoBloc.integracao.mercadopagoAcessToken);
                                  print("Acess Token: "+integracaoBloc.integracao.mercadopagoAcessToken);
                                  print("User Id: "+integracaoBloc.integracao.mercadopagoUserId);
                                   terminalBloc.setMercadadopagoIDLoja(await integracaoBloc.getMercadopagoLoja()); 
                                   if ( terminalBloc.mercadopagoIdLoja == null || terminalBloc.mercadopagoIdLoja == ""){
                                    terminalBloc.setMercadadopagoIDLoja(await integracaoBloc.postMercadopagoLoja(0));
                                     if (terminalBloc.mercadopagoIdLoja == null || terminalBloc.mercadopagoIdLoja == ""){                                  
                                        showDialog(
                                        context: context,
                                        child: AlertDialog(
                                          title: Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: <Widget>[
                                              Image.asset("assets/mercadopago.png", width:80,),
                                            ],
                                          ),
                                          content: Text("Erro ao vincular loja" , style: TextStyle(color: Colors.black87, fontSize: 20,  )),
                                          actions: <Widget>[
                                            SizedBox(
                                            height: 40,
                                            width: 500,
                                            child: FlatButton(
                                                child: Text("Cancelar", style: TextStyle(color: Colors.white)),
                                                color: Colors.blue[400],
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(8)
                                                ), 
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                              ),
                                            )
                                          ],
                                        )
                                      );
                                     }
                                  } else {
                                    Navigator.pop(context); 
                                  }     
                                  
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