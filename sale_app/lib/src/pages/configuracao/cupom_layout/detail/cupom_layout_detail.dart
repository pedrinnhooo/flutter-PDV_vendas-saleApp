import 'package:common_files/common_files.dart';
import 'package:fluggy/generated/locale_base.dart';
import 'package:fluggy/src/pages/configuracao/cupom_layout/cupom_layout_module.dart';
import 'package:flutter/material.dart';

class CupomLayoutDetail extends StatefulWidget {
  CupomLayoutDetail({Key key}) : super(key: key);

  @override
  _CupomLayoutDetailState createState() => _CupomLayoutDetailState();
}

class _CupomLayoutDetailState extends State<CupomLayoutDetail> {
  CupomLayoutBloc cupomLayoutBloc;
  TextEditingController nomeController;

  @override
  void initState() { 
    super.initState();
    cupomLayoutBloc = CupomLayoutModule.to.getBloc<CupomLayoutBloc>();
    nomeController = TextEditingController(text: cupomLayoutBloc.cupomLayout.nome != null ? cupomLayoutBloc.cupomLayout.nome : "");
  }

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.of<LocaleBase>(context, LocaleBase);

    return Scaffold(
      appBar: AppBar(
        title: Text("Cupom", style: Theme.of(context).textTheme.title,),
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
                    child: Text(cupomLayoutBloc.cupomLayout.id != null 
                      ? locale.palavra.alterar + " " + locale.cadastroTipoPagamento.titulo.toLowerCase()
                      : locale.cadastro.incluirNovo,
                      style: Theme.of(context).textTheme.subhead,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(right: 15),
                    child: InkWell(
                      child: Text(cupomLayoutBloc.cupomLayout.id != null ? locale.palavra.excluir : locale.palavra.limpar,
                        style: Theme.of(context).textTheme.subhead,
                      ),
                      onTap: () async {
                        if (cupomLayoutBloc.cupomLayout.id != null) {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) => CustomDialogConfirmation(
                            title: locale.palavra.confirmacao,
                            description: locale.mensagem.confirmarExcluirRegistro +
                              locale.palavra.artigo_o + " " +
                              locale.cadastroTipoPagamento.titulo.toLowerCase() + " ",
                            item: cupomLayoutBloc.cupomLayout.nome ,
                            buttonOkText: locale.palavra.excluir,
                            buttonCancelText: locale.palavra.cancelar,
                            funcaoBotaoOk: () async {
                              await cupomLayoutBloc.getAllCupomLayout();
                              Navigator.pop(context);
                              Navigator.pop(context);
                            },
                            funcaoBotaoCancelar: () async {
                              Navigator.pop(context);
                            }
                          ),
                        ); 
                        } else {
                          await cupomLayoutBloc.newCupomLayout();
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
                                  padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      StreamBuilder<bool>(
                                        initialData: false,
                                        stream: cupomLayoutBloc.nomeInvalidoOut,
                                        builder: (context, snapshot) {
                                          return customTextField(
                                            context,
                                            autofocus: cupomLayoutBloc.cupomLayout.id != null ? false : true,
                                            controller: nomeController,
                                            labelText: locale.palavra.nome,
                                            errorText: snapshot.data ? locale.mensagem.nomeNaoNulo : "",
                                            onChanged: (text) {
                                              cupomLayoutBloc.cupomLayout.nome = text;
                                            }
                                          );
                                        }
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: <Widget>[
                                          Expanded(
                                            child: DropdownButton<String>(
                                              iconDisabledColor: Colors.grey,
                                              iconEnabledColor: Colors.white,
                                              isExpanded: true,
                                              hint: StreamBuilder<CupomLayout>(
                                                stream: cupomLayoutBloc.cupomLayoutOut,
                                                builder: (context, snapshot) {
                                                  if(snapshot.data == null || snapshot.data.tamanhoPapel == null){
                                                    return Text("Selecione o tamanho do papel", style: Theme.of(context).textTheme.subtitle,);
                                                  }
                                                  return Text("Tamanho do Papel: ${snapshot.data.tamanhoPapel}mm", style: Theme.of(context).textTheme.subtitle,);
                                                }
                                              ),
                                              items: cupomLayoutBloc.tamanhosList.map((String value) {
                                                return new DropdownMenuItem<String>(
                                                  value: value,
                                                  child: new Text("$value mm", style: Theme.of(context).textTheme.subtitle,),
                                                );
                                              }).toList(),
                                              onChanged: (value) {
                                                cupomLayoutBloc.setTamanhoPapel(int.parse(value));
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 10),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: <Widget>[
                                            Expanded(
                                              child: DropdownButton<String>(
                                                iconDisabledColor: Colors.grey,
                                                iconEnabledColor: Colors.white,
                                                isExpanded: true,
                                                hint: StreamBuilder<CupomLayout>(
                                                  stream: cupomLayoutBloc.cupomLayoutOut,
                                                  builder: (context, snapshot) {
                                                    if(snapshot.data == null || snapshot.data.layout == null){
                                                      return Text("Selecione o layout", style: Theme.of(context).textTheme.subtitle,);
                                                    }
                                                    return Text("Layout: ${snapshot.data.layout}", style: Theme.of(context).textTheme.subtitle,);
                                                  }
                                                ),
                                                items: cupomLayoutBloc.layoutList.map((String value) {
                                                  return new DropdownMenuItem<String>(
                                                    value: value,
                                                    child: new Text("$value", style: Theme.of(context).textTheme.subtitle,),
                                                  );
                                                }).toList(),
                                                onChanged: (value) {
                                                  cupomLayoutBloc.setLayout(value);
                                                  //cupomLayoutBloc.defaultLayout();
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      customButtomGravar(
                        text: Text(locale.palavra.gravar,
                          style: Theme.of(context).textTheme.title,
                        ),
                        buttonColor: Theme.of(context).primaryIconTheme.color,
                        onPressed: () async {
                          cupomLayoutBloc.validaNome();
                          cupomLayoutBloc.validaTamanhoPapel();
                          cupomLayoutBloc.validaLayout();
                          if (!cupomLayoutBloc.formInvalido){
                            print("Nome: "+cupomLayoutBloc.cupomLayout.nome);
                            await cupomLayoutBloc.saveCupomLayout();
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
}