import 'package:cached_network_image/cached_network_image.dart';
import 'package:common_files/common_files.dart';
import 'package:fluggy/generated/locale_base.dart';
import 'package:flutter/material.dart';
import 'package:fluggy/src/pages/configuracao/tipo_pagamento/detail/tipo_pagamento_icone_page.dart';
import 'package:fluggy/src/pages/configuracao/tipo_pagamento/tipo_pagamento_module.dart';

class TipoPagamentoDetailPage extends StatefulWidget {
  @override
  _TipoPagamentoDetailPageState createState() => _TipoPagamentoDetailPageState();
}

class _TipoPagamentoDetailPageState extends State<TipoPagamentoDetailPage> {
  TipoPagamentoBloc tipoPagamentoBloc;
  TextEditingController nomeController;

  @override
  void initState() {
    tipoPagamentoBloc = TipoPagamentoModule.to.getBloc<TipoPagamentoBloc>();
    nomeController = TextEditingController();
    nomeController.value =  nomeController.value.copyWith(text: tipoPagamentoBloc.tipoPagamento.nome); 
    super.initState();
  } 
  
  @override
  Widget build(BuildContext context) {
    final locale = Localizations.of<LocaleBase>(context, LocaleBase);

    return Scaffold(
      appBar: AppBar(
        title: Text(locale.cadastroTipoPagamento.titulo, 
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
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                   Container(
                     padding: EdgeInsets.only(left: 10),
                     child: Text(tipoPagamentoBloc.tipoPagamento.id != null 
                       ? locale.palavra.alterar + " " + locale.cadastroTipoPagamento.titulo.toLowerCase()
                       : locale.cadastro.incluirNovo,
                       style: Theme.of(context).textTheme.subhead,
                     ),
                   ),
                   Container(
                     padding: EdgeInsets.only(right: 15),
                     child: InkWell(
                         child: Text(tipoPagamentoBloc.tipoPagamento.id != null ? locale.palavra.excluir : locale.palavra.limpar,
                         style: Theme.of(context).textTheme.subhead,
                       ),
                       onTap: () async {
                         if (tipoPagamentoBloc.tipoPagamento.id != null) {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) => CustomDialogConfirmation(
                              title: locale.palavra.confirmacao,
                              description: locale.mensagem.confirmarExcluirRegistro +
                                locale.palavra.artigo_o + " " +
                                locale.cadastroTipoPagamento.titulo.toLowerCase() + " ",
                              item: tipoPagamentoBloc.tipoPagamento.nome ,
                              buttonOkText: locale.palavra.excluir,
                              buttonCancelText: locale.palavra.cancelar,
                              funcaoBotaoOk: () async {
                                await tipoPagamentoBloc.deleteTipoPagamento();
                                await tipoPagamentoBloc.getAllTipoPagamento();
                                Navigator.pop(context);
                                Navigator.pop(context);
                              },
                              funcaoBotaoCancelar: () async {
                                Navigator.pop(context);
                              }
                            ),
                          );
                         } else {
                           await tipoPagamentoBloc.newTipoPagamento();
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
                padding: EdgeInsets.only(left: 10, right: 10, bottom: 20,),  
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
                                  padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      StreamBuilder<bool>(
                                        initialData: false,
                                        stream: tipoPagamentoBloc.nomeInvalidoOut,
                                        builder: (context, snapshot) {
                                          return customTextField(
                                            context,
                                            autofocus: tipoPagamentoBloc.tipoPagamento.id != null ? false : true,
                                            controller: nomeController,
                                            labelText: locale.palavra.nome,
                                            errorText: snapshot.data ? locale.mensagem.nomeNaoNulo : null,
                                            onChanged: (text) {
                                                tipoPagamentoBloc.tipoPagamento.nome = text;
                                            }   
                                          );
                                        }
                                      ),
                                      Container(
                                        decoration: BoxDecoration(
                                          border: Border(
                                            bottom: BorderSide(
                                              color: Colors.white
                                            )
                                          )
                                        ),
                                        child: ListTile(
                                          onTap: () {
                                            Navigator.push(context, 
                                            MaterialPageRoute(
                                              settings: RouteSettings(name: '/SelecaoIconeTipoPagamento'),
                                              builder: (context) {
                                                return TipoPagamentoIconePage();
                                              }
                                            ));
                                          },
                                          contentPadding: EdgeInsets.all(0),
                                          title: Text("Icone", style: Theme.of(context).textTheme.subtitle,),
                                          trailing: tipoPagamentoBloc.tipoPagamento.icone.length > 0 
                                          ? CachedNetworkImage(
                                              placeholder: (context, url) => CircularProgressIndicator(),
                                              errorWidget: (context, url, error) => Icon(Icons.error, color: Colors.white,),
                                              imageUrl: '$s3Endpoint/${tipoPagamentoBloc.tipoPagamento.icone}',
                                              color: Theme.of(context).textTheme.subtitle.color,
                                              width: 45,
                                              height: 45,
                                            )
                                          : Icon(Icons.arrow_forward, color: Colors.white,),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
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
                          tipoPagamentoBloc.validaNome();
                          if (!tipoPagamentoBloc.formInvalido){
                            print("Nome: "+tipoPagamentoBloc.tipoPagamento.nome);
                            await tipoPagamentoBloc.saveTipoPagamento();
                            await tipoPagamentoBloc.getAllTipoPagamento();
                            Navigator.pop(context);
                          } else {
                            print("Error form invalido: ");
                          }
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
    print("Dispose TipoPagamento Detail");
    super.dispose();
  }  
}
