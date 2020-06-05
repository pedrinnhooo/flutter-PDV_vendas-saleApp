import 'package:common_files/common_files.dart';
import 'package:fluggy/generated/locale_base.dart';
import 'package:flutter/material.dart';
import 'package:fluggy/src/pages/cadastro/categoria/categoria_module.dart';

class CategoriaDetailPage extends StatefulWidget {
  @override
  _CategoriaDetailPageState createState() => _CategoriaDetailPageState();
}

class _CategoriaDetailPageState extends State<CategoriaDetailPage> {
  CategoriaBloc categoriaBloc;
  TextEditingController nomeController;

  @override
  void initState() {
    categoriaBloc = CategoriaModule.to.getBloc<CategoriaBloc>();
    nomeController = TextEditingController();
    nomeController.value =  nomeController.value.copyWith(text: categoriaBloc.categoria.nome); 
    super.initState();
  } 
  
  @override
  Widget build(BuildContext context) {
    final locale = Localizations.of<LocaleBase>(context, LocaleBase);

    return Scaffold(
      appBar: AppBar(
        title: Text(locale.cadastroCategoria.titulo, 
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
                     child: Text(categoriaBloc.categoria.id != null 
                       ? locale.palavra.alterar + " " + locale.cadastroCategoria.titulo.toLowerCase()
                       : locale.cadastro.incluirNovo,
                       style: Theme.of(context).textTheme.subhead,
                     ),
                   ),
                   Container(
                     padding: EdgeInsets.only(right: 15),
                     child: InkWell(
                         child: Text(categoriaBloc.categoria.id != null ? locale.palavra.excluir : locale.palavra.limpar,
                         style: Theme.of(context).textTheme.subhead,
                       ),
                       onTap: () async {
                         if (categoriaBloc.categoria.id != null) {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) => CustomDialogConfirmation(
                              title: locale.palavra.confirmacao,
                              description: locale.mensagem.confirmarExcluirRegistro +
                                locale.palavra.artigo_a + " " +
                                locale.cadastroCategoria.titulo.toLowerCase() + " ",
                              item: categoriaBloc.categoria.nome ,
                              buttonOkText: locale.palavra.excluir,
                              buttonCancelText: locale.palavra.cancelar,
                              funcaoBotaoOk: () async {
                                await categoriaBloc.deleteCategoria();
                                await categoriaBloc.getAllCategoria();
                                Navigator.pop(context);
                                Navigator.pop(context);
                              },
                              funcaoBotaoCancelar: () async {
                                Navigator.pop(context);
                              }
                            ),
                          );
                         } else {
                           await categoriaBloc.newCategoria();
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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              alignment: Alignment.bottomCenter,
                              child: Text("Nome",
                                style: Theme.of(context).textTheme.body2,
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              child: StreamBuilder<bool>(
                                initialData: false,
                                stream: categoriaBloc.nomeInvalidoOut,
                                builder: (context, snapshot) {
                                  return customCenteredField(
                                    context,
                                    // autofocus: categoriaBloc.categoria.id != null ? false : true,
                                    controller: nomeController,
                                    enabled: true,
                                    errorText: snapshot.data ? locale.mensagem.nomeNaoNulo : "",
                                    onChanged: (text){
                                      categoriaBloc.categoria.nome = text;
                                    },
                                  );
                                }
                              ),
                            ),
                          ]
                        ),
                      ),
                      customButtomGravar(
                          buttonColor: Theme.of(context).primaryIconTheme.color,
                          text: Text(locale.palavra.gravar,
                            style: Theme.of(context).textTheme.title,
                          ),
                          onPressed: () async {
                            categoriaBloc.validaNome();
                            if (!categoriaBloc.formInvalido){
                              print("Nome: "+categoriaBloc.categoria.nome);
                              await categoriaBloc.saveCategoria();
                              Navigator.pop(context);
                            } else {
                              print("Error form invalido: ");
                            }
                          }
                        )
                    ],
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
    print("Dispose Categoria Detail");
    categoriaBloc.limpaValidacoes();
    super.dispose();
  }   
}