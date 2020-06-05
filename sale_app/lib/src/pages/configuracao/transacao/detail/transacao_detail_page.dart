import 'package:common_files/common_files.dart';
import 'package:fluggy/generated/locale_base.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:fluggy/src/pages/cadastro/preco_tabela/preco_tabela_module.dart';
import 'package:fluggy/src/pages/configuracao/transacao/transacao_module.dart';

class TransacaoDetailPage extends StatefulWidget {
  @override
  _TransacaoDetailPageState createState() => _TransacaoDetailPageState();
}

class _TransacaoDetailPageState extends State<TransacaoDetailPage> {
  TransacaoBloc transacaoBloc;
  TextEditingController nomeController;
  TextEditingController descontoController;
  MoneyMaskedTextController valorDesconto = MoneyMaskedTextController(decimalSeparator: ".");
  PrecoTabelaModule precoTabelaModule = TransacaoModule.to.getDependency<PrecoTabelaModule>();

  @override
  void initState() {
    transacaoBloc = TransacaoModule.to.getBloc<TransacaoBloc>();
    nomeController = TextEditingController();
    nomeController.value =  nomeController.value.copyWith(text: transacaoBloc.transacao.nome); 
    descontoController = TextEditingController();
    valorDesconto.updateValue(transacaoBloc.transacao.descontoPercentual);
    descontoController.value =  descontoController.value.copyWith(text: valorDesconto.text); 
    super.initState();
  } 
  
  @override
  Widget build(BuildContext context) {
    
    final locale = Localizations.of<LocaleBase>(context, LocaleBase);

    return Scaffold(
      appBar: AppBar(
        title: Text(locale.cadastroTransacao.titulo, 
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
                     child: Text(transacaoBloc.transacao.id != null 
                       ? locale.palavra.alterar + " " + locale.cadastroTransacao.titulo.toLowerCase()
                       : locale.cadastro.incluirNovo,
                       style: Theme.of(context).textTheme.subhead,
                     ),
                   ),
                   Container(
                     padding: EdgeInsets.only(right: 15),
                     child: InkWell(
                         child: Text(transacaoBloc.transacao.id != null ? locale.palavra.excluir : locale.palavra.limpar,
                         style: Theme.of(context).textTheme.subhead,
                       ),
                       onTap: () async {
                         if (transacaoBloc.transacao.id != null) {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) => CustomDialogConfirmation(
                              title: locale.palavra.confirmacao,
                              description: locale.mensagem.confirmarExcluirRegistro +
                                locale.palavra.artigo_a + " " +
                                locale.cadastroTransacao.titulo.toLowerCase() + " ",
                              item: transacaoBloc.transacao.nome ,
                              buttonOkText: locale.palavra.excluir,
                              buttonCancelText: locale.palavra.cancelar,
                              funcaoBotaoOk: () async {
                                await transacaoBloc.deleteTransacao();
                                await transacaoBloc.getAllTransacao();
                                Navigator.pop(context);
                                Navigator.pop(context);
                              },
                              funcaoBotaoCancelar: () async {
                                Navigator.pop(context);
                              }
                            ),
                          );                           
                           
                         } else {
                           await transacaoBloc.newTransacao();
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
                                        stream: transacaoBloc.nomeInvalidoOut,
                                        builder: (context, snapshot) {
                                          return customTextField(
                                            context,
                                            autofocus: transacaoBloc.transacao.id != null ? false : true,
                                            controller: nomeController,
                                            labelText: locale.palavra.nome,
                                            errorText: snapshot.data ? locale.mensagem.nomeNaoNulo : null,
                                            onChanged: (text) {
                                                transacaoBloc.transacao.nome = text;
                                            }   
                                          );
                                        }
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      StreamBuilder<Transacao>(
                                        initialData: Transacao(),  
                                        stream: transacaoBloc.transacaoOut,
                                        builder: (context, snapshot) {
                                          Transacao transacao = snapshot.data;
                                          return Column(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: <Widget>[
                                              Container(
                                                alignment: Alignment.topLeft,
                                                child: Text("Movimento de estoque",
                                                style: Theme.of(context).textTheme.body2,
                                                ),
                                              ),
                                              Container(
                                                padding: EdgeInsets.only(top: 1),
                                                alignment: Alignment.topLeft,
                                                child: DropdownButton(
                                                  items: [
                                                    DropdownMenuItem(
                                                      value: 0,  
                                                      child: Container(
                                                        padding: EdgeInsets.only(bottom: 18),
                                                        child: Text("Subtrai", style: Theme.of(context).textTheme.subtitle)
                                                      ),
                                                    ),
                                                    DropdownMenuItem(
                                                      value: 1,  
                                                      child: Container(
                                                        padding: EdgeInsets.only(bottom: 18),
                                                        child: Text("Soma", style: Theme.of(context).textTheme.subtitle)
                                                      ),
                                                    )
                                                  ],
                                                  value: transacao.tipoEstoque,
                                                  isExpanded: true,
                                                  //isDense: true,
                                                  style: Theme.of(context).textTheme.subtitle,

                                                  onChanged: (value) {
                                                    transacaoBloc.setTipoEstoque(value);  
                                                  } ,  
                                                ),
                                              ),
                                              //Text("teste"),
                                              Container(
                                                alignment: Alignment.topLeft,
                                                child: numberTextField(context,
                                                  controller: descontoController,
                                                  suffixText: "%",
                                                  labelText: "Desconto automático",//locale.palavra.nome,
                                                  onChanged: (text) async {
                                                    //transacao.descontoPercentual = double.parse(text.replaceAll(",", "."));
                                                    transacaoBloc.transacao.descontoPercentual = double.parse(text.replaceAll(",", "."));
                                                    // transacaoBloc.updateStream();
                                                    valorDesconto.updateValue(transacao.descontoPercentual);
                                                  }   
                                                ),
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Column(
                                                children: <Widget>[
                                                  Container(
                                                    alignment: Alignment.topLeft,
                                                    child: Text("Tabela de preço",
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
                                                          stream: transacaoBloc.precoTabelaInvalidoOut,
                                                          builder: (context, snapshot) {
                                                            return Text(transacao.precoTabela.nome != null ? transacao.precoTabela.nome : locale.palavra.selecione,
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
                                                                settings: RouteSettings(name: '/ListaPrecoTabela'),
                                                                builder: (context) {
                                                                  return precoTabelaModule;
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
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: <Widget>[
                                                  Text("Tem pagamento",
                                                    style: Theme.of(context).textTheme.subtitle,
                                                  ),
                                                  Switch(
                                                    inactiveTrackColor: Colors.grey,
                                                    activeColor: Theme.of(context).primaryIconTheme.color,
                                                    value: transacao.temPagamento == 1,
                                                    onChanged: (value) {
                                                      transacaoBloc.setTemPagamento(value);
                                                    },
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: <Widget>[
                                                  Text("Tem vendedor",
                                                    style: Theme.of(context).textTheme.subtitle,
                                                  ),
                                                  Switch(
                                                    inactiveTrackColor: Colors.grey,
                                                    activeColor: Theme.of(context).primaryIconTheme.color,
                                                    value: transacao.temVendedor == 1,
                                                    onChanged: (value) {
                                                      transacaoBloc.setTemVendedor(value);
                                                    },
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: <Widget>[
                                                  Text("Tem cliente",
                                                    style: Theme.of(context).textTheme.subtitle,
                                                  ),
                                                  Switch(
                                                    inactiveTrackColor: Colors.grey,
                                                    activeColor: Theme.of(context).primaryIconTheme.color,
                                                    value: transacao.temCliente == 1,
                                                    onChanged: (value) {
                                                      transacaoBloc.setTemCliente(value);
                                                    },
                                                  ),
                                                ],
                                              ),
                                            ],
                                          );  
                                        },
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
                        text: Text(locale.palavra.gravar,
                          style: Theme.of(context).textTheme.title,
                        ),
                        buttonColor:  Theme.of(context).primaryIconTheme.color,
                        onPressed: () async {
                          await transacaoBloc.validaForm();
                          if (!transacaoBloc.formInvalido){
                            print("Nome: "+transacaoBloc.transacao.nome);
                            await transacaoBloc.saveTransacao();
                            await transacaoBloc.getAllTransacao();
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
    print("Dispose Transacao Detail");
    transacaoBloc.limpaValidacoes();
    super.dispose();
  }   
}

