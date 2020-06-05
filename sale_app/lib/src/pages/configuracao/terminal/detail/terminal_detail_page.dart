import 'package:common_files/common_files.dart';
import 'package:fluggy/generated/locale_base.dart';
import 'package:fluggy/src/pages/configuracao/mercadopago/mercadopago_module.dart';
import 'package:fluggy/src/pages/configuracao/picpay/picpay_module.dart';
import 'package:fluggy/src/pages/configuracao/terminal_impressora/terminalL_impressora_module.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:fluggy/src/pages/configuracao/terminal/terminal_module.dart';
import 'package:fluggy/src/pages/configuracao/transacao/transacao_module.dart';

class TerminalDetailPage extends StatefulWidget {
  @override
  _TerminalDetailPageState createState() => _TerminalDetailPageState();
}

class _TerminalDetailPageState extends State<TerminalDetailPage> {
  TerminalBloc terminalBloc;
  IntegracaoBloc integracaoBloc;
  TextEditingController nomeController;
  MercadopagoModule mercadopagoModule;
  PicpayModule picpayModule;
  MoneyMaskedTextController valorDesconto;
  TransacaoModule transacaoModule;
  ImpressoraModule impressoraModule;
  ImpressoraBloc impressoraBloc;

  @override
  void initState() {
    terminalBloc = TerminalModule.to.getBloc<TerminalBloc>();
    integracaoBloc = TerminalModule.to.getBloc<IntegracaoBloc>();
    impressoraBloc = TerminalModule.to.getBloc<ImpressoraBloc>();
    transacaoModule = TerminalModule.to.getDependency<TransacaoModule>();
    impressoraModule = TerminalModule.to.getDependency<ImpressoraModule>();
    mercadopagoModule = TerminalModule.to.getDependency<MercadopagoModule>();
    picpayModule = TerminalModule.to.getDependency<PicpayModule>();
    valorDesconto = MoneyMaskedTextController(decimalSeparator: ".");
    nomeController = TextEditingController();
    nomeController.value = nomeController.value.copyWith(text: terminalBloc.terminal.nome); 
    super.initState();
  } 
  
  @override
  Widget build(BuildContext context) {
    
    final locale = Localizations.of<LocaleBase>(context, LocaleBase);

    return Scaffold(
      appBar: AppBar(
        title: Text(locale.cadastroTerminal.titulo, 
          style: Theme.of(context).textTheme.title,)
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
                     child: Text(terminalBloc.terminal.id != null 
                       ? locale.palavra.alterar + " " + locale.cadastroTerminal.titulo.toLowerCase()
                       : locale.cadastro.incluirNovo,
                       style: Theme.of(context).textTheme.subhead,
                     ),
                   ),
                   Container(
                     padding: EdgeInsets.only(right: 15),
                     child: InkWell(
                         child: Text(terminalBloc.terminal.id != null ? locale.palavra.excluir : locale.palavra.limpar,
                         style: Theme.of(context).textTheme.subhead,
                       ),
                       onTap: () async {
                         if (terminalBloc.terminal.id != null) {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) => CustomDialogConfirmation(
                              title: locale.palavra.confirmacao,
                              description: locale.mensagem.confirmarExcluirRegistro +
                                locale.palavra.artigo_a + " " +
                                locale.cadastroTerminal.titulo.toLowerCase() + " ",
                              item: terminalBloc.terminal.nome ,
                              buttonOkText: locale.palavra.excluir,
                              buttonCancelText: locale.palavra.cancelar,
                              funcaoBotaoOk: () async {
                                await terminalBloc.deleteTerminal();
                                await terminalBloc.getAllTerminal();
                                Navigator.pop(context);
                                Navigator.pop(context);
                              },
                              funcaoBotaoCancelar: () async {
                                Navigator.pop(context);
                              }
                            ),
                          );
                         } else {
                           await terminalBloc.newTerminal();
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
                                  children: <Widget>[
                                    StreamBuilder<bool>(
                                      initialData: false,
                                      stream: terminalBloc.nomeInvalidoOut,
                                      builder: (context, snapshot) {
                                        return customTextField(
                                          context,
                                          autofocus: terminalBloc.terminal.id != null ? false : true,
                                          controller: nomeController,
                                          labelText: locale.palavra.nome,
                                          errorText: snapshot.data ? locale.mensagem.nomeNaoNulo : null,
                                          onChanged: (text) {
                                              terminalBloc.terminal.nome = text;
                                          }   
                                        );
                                      }
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    StreamBuilder<Terminal>(
                                      initialData: Terminal(),  
                                      stream: terminalBloc.terminalOut,
                                      builder: (context, snapshot) {
                                        Terminal terminal = snapshot.data;
                                        return Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: <Widget>[
                                             Column(
                                              children: <Widget>[
                                                Container(
                                                  alignment: Alignment.topLeft,
                                                  child: Text(locale.cadastroTransacao.titulo,
                                                  style: Theme.of(context).textTheme.body2,
                                                  ),
                                                ),
                                                Container(
                                                  alignment: Alignment.topLeft,
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: <Widget>[
                                                      StreamBuilder<bool>(
                                                        initialData: false,
                                                        stream: terminalBloc.transacaoInvalidaOut,
                                                        builder: (context, snapshot) {
                                                          return Text(terminal.transacao.nome != null ? terminal.transacao.nome : locale.palavra.selecione,
                                                            style: Theme.of(context).textTheme.subtitle,
                                                          );
                                                        }
                                                      ),
                                                      InkWell(
                                                        child: Icon(
                                                            Icons.arrow_forward_ios,
                                                            color: Theme.of(context).cursorColor,
                                                          ),
                                                        onTap: () {
                                                          Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                              settings: RouteSettings(name: '/ListaTransacao'),
                                                              builder: (context) {
                                                                return transacaoModule;
                                                              }  
                                                            ),
                                                          );
                                                        },  
                                                      )
                                                    ],
                                                  ),
                                                ),                                              
                                                Padding(
                                                  padding: const EdgeInsets.only(top: 2),
                                                  child: Divider(color: Colors.white,),
                                                )
                                              ],
                                            ),
                                          ],
                                        );  
                                      },
                                    ),
                                    StreamBuilder<Terminal>(
                                      initialData: Terminal(),  
                                      stream: terminalBloc.terminalOut,
                                      builder: (context, snapshot) {
                                        Terminal terminal = snapshot.data;
                                        return Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: <Widget>[
                                             Column(
                                              children: <Widget>[
                                                Padding(
                                                  padding: const EdgeInsets.only(top: 20.0),
                                                  child: Container(
                                                    alignment: Alignment.topLeft,
                                                    child: InkWell(
                                                      onTap: () async {
                                                        await integracaoBloc.getintegracaoByIdMercadopago(terminalBloc.terminal.idPessoa);
                                                        Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                            settings: RouteSettings(name: '/ConfiguracaoMercadopago'),
                                                            builder: (context) {
                                                              return mercadopagoModule;
                                                            }  
                                                          ),
                                                        );
                                                      },  
                                                      child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        children: <Widget>[
                                                          StreamBuilder<bool>(
                                                            initialData: false,
                                                            stream: terminalBloc.transacaoInvalidaOut,
                                                            builder: (context, snapshot) {
                                                              return Text("MercadoPago",
                                                                style: !snapshot.data ? Theme.of(context).textTheme.subtitle : Theme.of(context).textTheme.body2,
                                                              );
                                                            }
                                                          ),
                                                          Icon( 
                                                            terminalBloc.terminal.mercadopagoQrCode != null ?   
                                                            Icons.check : Icons.arrow_forward_ios,
                                                            color: terminalBloc.terminal.mercadopagoQrCode != null ?
                                                            Colors.green : Theme.of(context).cursorColor,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.only(top: 2),
                                                  child: Divider(color: Colors.white,),
                                                )
                                              ],
                                            ),
                                          ],
                                        );
                                      },
                                    ),
                                    StreamBuilder<Terminal>(
                                      initialData: Terminal(),  
                                      stream: terminalBloc.terminalOut,
                                      builder: (context, snapshot) {
                                        Terminal terminal = snapshot.data;
                                        return Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: <Widget>[
                                             Column(
                                              children: <Widget>[
                                                Padding(
                                                  padding: const EdgeInsets.only(top: 20.0),
                                                  child: Container(
                                                    alignment: Alignment.topLeft,
                                                    child: InkWell(
                                                      onTap: () async {
                                                        Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                            settings: RouteSettings(name: '/ConfiguracaoPicpay'),
                                                            builder: (context) {
                                                              return picpayModule;
                                                            }  
                                                          ),
                                                        );
                                                      },  
                                                      child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        children: <Widget>[
                                                          StreamBuilder<bool>(
                                                            initialData: false,
                                                            stream: terminalBloc.transacaoInvalidaOut,
                                                            builder: (context, snapshot) {
                                                              return Text("PicPay",
                                                                style: !snapshot.data ? Theme.of(context).textTheme.subtitle : Theme.of(context).textTheme.body1,
                                                              );
                                                            }
                                                          ),
                                                          Icon( 
                                                            terminalBloc.terminal.temPicpay == 1 ?   
                                                            Icons.check : Icons.arrow_forward_ios,
                                                            color: terminalBloc.terminal.temPicpay == 1 ?
                                                            Colors.green : Theme.of(context).cursorColor,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.only(top: 2),
                                                  child: Divider(color: Colors.white,),
                                                )
                                              ],
                                            ),
                                          ],
                                        );
                                      },
                                    ),
                                    StreamBuilder<Terminal>(
                                      initialData: Terminal(),  
                                      stream: terminalBloc.terminalOut,
                                      builder: (context, snapshot) {
                                        Terminal terminal = snapshot.data;
                                        return Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: <Widget>[
                                              Column(
                                              children: <Widget>[
                                                Container(
                                                  alignment: Alignment.topLeft,
                                                  child: Text("Impressora",
                                                  style: Theme.of(context).textTheme.body2,
                                                  ),
                                                ),
                                                Container(
                                                  alignment: Alignment.topLeft,
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: <Widget>[
                                                      StreamBuilder<Terminal>(
                                                        initialData: Terminal(),  
                                                        stream: terminalBloc.terminalOut,
                                                        builder: (context, snapshot) {
                                                          Terminal terminal = snapshot.data;
                                                          return Text(
                                                            terminal.terminalImpressora != null && terminal.terminalImpressora.length > 0 && terminal.terminalImpressora.first.ehDeletado != 1
                                                            ? terminal.terminalImpressora.first.nome 
                                                            : locale.palavra.selecione,
                                                            style: Theme.of(context).textTheme.subtitle
                                                          );
                                                        }
                                                      ),
                                                      InkWell(
                                                        child: Icon(
                                                          Icons.arrow_forward_ios,
                                                          color: Theme.of(context).cursorColor,
                                                        ),
                                                        onTap: () async {
                                                          if(terminal.terminalImpressora != null && terminal.terminalImpressora.length > 0 && terminal.terminalImpressora.first.ehDeletado == 0){
                                                            if(terminal.terminalImpressora.first.id != null){
                                                              await impressoraBloc.getImpressoraById(terminal.terminalImpressora.first.id);
                                                            } else {
                                                              await impressoraBloc.setImpressora(terminal.terminalImpressora.first);
                                                            }
                                                          }
                                                          Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                              settings: RouteSettings(name: '/ListaImpressora'),
                                                              builder: (context) {
                                                                return impressoraModule;
                                                              }  
                                                            ),
                                                          );
                                                        },  
                                                      )
                                                    ],
                                                  ),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.only(top: 2),
                                                  child: Divider(color: Colors.white,),
                                                )
                                              ],
                                            ),
                                          ],
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
                      customButtomGravar(
                        buttonColor: Theme.of(context).primaryIconTheme.color,
                        text: Text(locale.palavra.gravar,
                          style: Theme.of(context).textTheme.title,
                        ),
                        onPressed: () async {
                          if (!terminalBloc.formInvalido){
                            if (terminalBloc.mercadopagoIdLoja != "" ){
                              List<String> mercadopagoTerminalList = await terminalBloc.postMercadopagoTerminal();
                                terminalBloc.terminal.mercadopagoIdTerminal = mercadopagoTerminalList[0];
                                terminalBloc.terminal.mercadopagoQrCode = mercadopagoTerminalList[1];  
                                                               
                             await integracaoBloc.saveIntegracao();
                            }

                            print("Nome: "+terminalBloc.terminal.nome);
                            await terminalBloc.saveTerminal();
                            Navigator.pop(context);
                          } else {
                            print("Error form invalido: ");
                          }
                          // //await terminalBloc.validaForm();
                          // if (!terminalBloc.formInvalido){
                          //   print("Nome: "+terminalBloc.terminal.nome);
                          //   await terminalBloc.saveTerminal();
                          //   Navigator.pop(context);
                          // } else {
                          //   print("Error form invalido: ");
                          // }
                        },
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
    print("Dispose Terminal Detail");
    terminalBloc.limpaValidacoes();
    super.dispose();
  }   
}

