import 'package:common_files/common_files.dart';
import 'package:fluggy/generated/locale_base.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:fluggy/src/pages/cadastro/cliente/cliente_module.dart';
import 'package:intl/intl.dart';

class ClienteDetailPage extends StatefulWidget {
  @override
  _ClienteDetailPageState createState() => _ClienteDetailPageState();
}

class _ClienteDetailPageState extends State<ClienteDetailPage> with SingleTickerProviderStateMixin {
  ClienteBloc clienteBloc;
  DateFormat dateFormat;
  TextEditingController razaoNomeController;
  TextEditingController apelidoFantasiaController;
  TextEditingController ieRgController;

  TextEditingController cepTextController;
  TextEditingController apelidoController;
  TextEditingController logradouroController;
  TextEditingController numeroController;
  TextEditingController complementoController;
  TextEditingController bairroController;
  TextEditingController municipioController;
  TextEditingController estadoController;

  TextEditingController nomeController;
  MaskedTextController telefone1Controller;
  MaskedTextController telefone2Controller;
  TextEditingController emailController;
  MaskedTextController cnpjCpfController;
  TabController _tabController;

  @override
  void initState() {
    clienteBloc = ClienteModule.to.getBloc<ClienteBloc>();
    dateFormat = DateFormat.Md('pt_BR');
    razaoNomeController = TextEditingController();
    razaoNomeController.value =  razaoNomeController.value.copyWith(text: clienteBloc.pessoa.razaoNome); 
    apelidoFantasiaController = TextEditingController();
    apelidoFantasiaController.value =  apelidoFantasiaController.value.copyWith(text: clienteBloc.pessoa.fantasiaApelido); 
    cnpjCpfController = MaskedTextController(mask: clienteBloc.pessoa.cnpjCpf.length <= 14 ? "000.000.000-00" : "00.000.000/0000-00");
    cnpjCpfController.value =  cnpjCpfController.value.copyWith(text: clienteBloc.pessoa.cnpjCpf); 
    ieRgController = TextEditingController();
    ieRgController.value =  ieRgController.value.copyWith(text: clienteBloc.pessoa.ieRg); 

    apelidoController = TextEditingController();
    apelidoController.value = apelidoController.value.copyWith(text: clienteBloc.pessoa.endereco != null && clienteBloc.pessoa.endereco.length > 0 ? clienteBloc.pessoa.endereco.first.apelido : "");
    cepTextController = MaskedTextController(mask: "00000-000");
    cepTextController.value = cepTextController.value.copyWith(text: clienteBloc.pessoa.endereco != null && clienteBloc.pessoa.endereco.length > 0 ? clienteBloc.pessoa.endereco.first.cep : "");
    logradouroController = TextEditingController();
    logradouroController.value = logradouroController.value.copyWith(text: clienteBloc.pessoa.endereco != null && clienteBloc.pessoa.endereco.length > 0 ? clienteBloc.pessoa.endereco.first.logradouro : "");
    numeroController = TextEditingController();
    numeroController.value = numeroController.value.copyWith(text: clienteBloc.pessoa.endereco != null && clienteBloc.pessoa.endereco.length > 0 ? clienteBloc.pessoa.endereco.first.numero : "");
    complementoController = TextEditingController();
    complementoController.value = complementoController.value.copyWith(text: clienteBloc.pessoa.endereco != null && clienteBloc.pessoa.endereco.length > 0 ? clienteBloc.pessoa.endereco.first.complemento : "");
    bairroController = TextEditingController();
    bairroController.value = bairroController.value.copyWith(text: clienteBloc.pessoa.endereco != null && clienteBloc.pessoa.endereco.length > 0 ? clienteBloc.pessoa.endereco.first.bairro : "");
    municipioController = TextEditingController();
    municipioController.value = municipioController.value.copyWith(text: clienteBloc.pessoa.endereco != null && clienteBloc.pessoa.endereco.length > 0 ? clienteBloc.pessoa.endereco.first.municipio : "" );
    estadoController = TextEditingController();
    estadoController .value = estadoController.value.copyWith(text: clienteBloc.pessoa.endereco != null && clienteBloc.pessoa.endereco.length > 0 ? clienteBloc.pessoa.endereco.first.estado : ""  );

    nomeController = TextEditingController();
    nomeController.value =  nomeController.value.copyWith(text: clienteBloc.pessoa.contato != null && clienteBloc.pessoa.contato.length > 0 ? clienteBloc.pessoa.contato.first.nome : ""); 
    telefone1Controller = MaskedTextController(mask: "(00) 00000-0000");
    telefone1Controller.value =  telefone1Controller.value.copyWith(text: clienteBloc.pessoa.contato != null && clienteBloc.pessoa.contato.length > 0 ? clienteBloc.pessoa.contato.first.telefone1 : ""); 
    telefone2Controller = MaskedTextController(mask: "(00) 00000-0000");
    telefone2Controller.value =  telefone2Controller.value.copyWith(text: clienteBloc.pessoa.contato != null && clienteBloc.pessoa.contato.length > 0 ? clienteBloc.pessoa.contato.first.telefone2 : ""); 
    emailController = TextEditingController();           
    emailController.value =  emailController.value.copyWith(text: clienteBloc.pessoa.contato != null && clienteBloc.pessoa.contato.length > 0 ? clienteBloc.pessoa.contato.first.email : ""); 
    _tabController = TabController(initialIndex: 0, length: 2, vsync: this);
    if(clienteBloc.pessoa.id != null){
      clienteBloc.getMovimentoByIdCliente(clienteBloc.pessoa.id);
    }
    super.initState();
  } 
  
  @override
  Widget build(BuildContext context) {
    final nomeKey = GlobalKey<ExpansionTileState>();
    final enderecoKey = GlobalKey<ExpansionTileState>();
    final contatoKey = GlobalKey<ExpansionTileState>();

    final locale = Localizations.of<LocaleBase>(context, LocaleBase);

    return Scaffold(
      appBar: AppBar(
        title: Text(locale.cadastroCliente.titulo, 
          style: Theme.of(context).textTheme.title,
        ),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.all(15),
            child: InkWell(
              child: Text(clienteBloc.pessoa.id != null ? locale.palavra.excluir : locale.palavra.limpar,
                style: TextStyle(
                  fontStyle: Theme.of(context).textTheme.subhead.fontStyle,
                  fontSize: Theme.of(context).textTheme.subhead.fontSize,
                  color: Theme.of(context).primaryIconTheme.color
                ),
              ),
              onTap: () async {
                if (clienteBloc.pessoa.id != null) {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) => CustomDialogConfirmation(
                      title: locale.palavra.confirmacao,
                      description: locale.mensagem.confirmarExcluirRegistro +
                        locale.palavra.artigo_a + " " +
                        locale.cadastroCliente.titulo.toLowerCase() + " ",
                      item: clienteBloc.pessoa.razaoNome + " ?" ,
                      buttonOkText: locale.palavra.excluir,
                      buttonCancelText: locale.palavra.cancelar,
                      funcaoBotaoOk: () async {
                        await clienteBloc.deletePessoa();
                        clienteBloc.offset = 0;
                        await clienteBloc.getAllPessoa();
                        Navigator.pop(context);
                        Navigator.pop(context);
                      },
                      funcaoBotaoCancelar: () async {
                        Navigator.pop(context);
                      }
                    ),
                  );
                } else {
                  await clienteBloc.newPessoa();
                  //nomeController.clear();
                }
              },
            ),
          ),
        ],
      ),      
      body: Container(
        color: Theme.of(context).primaryColor,
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
              stream: clienteBloc.pessoaOut,
              builder: (context, snapshot) {
                Pessoa pessoa = snapshot.data;
                return Column(
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Container(
                      child: TabBar(
                        indicatorWeight: 1,
                        indicatorSize: TabBarIndicatorSize.label,
                        controller: _tabController,
                        tabs: <Widget>[
                          Tab(child: Text("Dados pessoais")),
                          Tab(child: Text("Vendas")),
                        ],
                      ),
                    ),
                    Expanded(
                      child: TabBarView(
                        controller: _tabController,
                        children: <Widget>[
                          SingleChildScrollView(
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 10, right: 10),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        SizedBox(
                                          height: 10,
                                        ),
                                        StreamBuilder<bool>(
                                          initialData: true,
                                          stream: clienteBloc.campoNomeExpandidoOut,
                                          builder: (context, snapshot) {
                                            bool campoHabilitado = snapshot.data;
                                            return CustomExpansionTile(
                                              key: nomeKey,
                                              backgroundColor: Colors.transparent,
                                              initiallyExpanded: true,
                                              onExpansionChanged: (isExpanded) {
                                                clienteBloc.setCampoNomeExpandido(isExpanded);
                                              },
                                              title: StreamBuilder<bool>(
                                                initialData: false,
                                                stream: clienteBloc.razaoNomeInvalidoOut,
                                                builder: (context, snapshot) {
                                                  return customTextField(
                                                    context,
                                                    enabled: true,
                                                    onTap: () { 
                                                      if(nomeKey.currentState.controller.value < 1){
                                                        nomeKey.currentState.handleTap(); 
                                                      }
                                                    },
                                                    controller: razaoNomeController,
                                                    labelText: pessoa.ehFisica == 1 ? locale.palavra.nome : locale.palavra.razaoSocial,
                                                    errorText: snapshot.data ? locale.mensagem.nomeNaoNulo : null,
                                                    onChanged: (text) {
                                                      clienteBloc.pessoa.razaoNome = text;
                                                    }   
                                                  );
                                                }
                                              ),
                                              children: <Widget>[
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                StreamBuilder<bool>(
                                                  initialData: false,
                                                  stream: clienteBloc.fantasiaApelidoInvalidoOut,
                                                  builder: (context, snapshot) {
                                                    return customTextField(
                                                      context,
                                                      controller: apelidoFantasiaController,
                                                      labelText: pessoa.ehFisica == 1 ? locale.palavra.apelido : locale.palavra.nomeFantasia,
                                                      errorText: snapshot.data ? locale.mensagem.nomeNaoNulo : null,
                                                      onChanged: (text) {
                                                        clienteBloc.pessoa.fantasiaApelido = text;
                                                      }   
                                                    );
                                                  }
                                                ),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                StreamBuilder<bool>(
                                                  initialData: false,
                                                  stream: clienteBloc.cnpjCpfInvalidoOut,
                                                  builder: (context, snapshot) {
                                                    return numberTextField(
                                                      context,
                                                      controller: cnpjCpfController,
                                                      labelText: cnpjCpfController.text.length <= 14 ? locale.palavra.cpf : locale.palavra.cnpj,
                                                      errorText: snapshot.data ? cnpjCpfController.text.length <= 14 ? "Cpf inválido" : "Cnpj inválido" : null,
                                                      onChanged: (text) {
                                                        clienteBloc.pessoa.cnpjCpf = text;
                                                        clienteBloc.cnpjCpfInvalidoController.add(clienteBloc.cnpjCpfInvalido);
                                                        if(cnpjCpfController.text.length > 14){
                                                          cnpjCpfController.updateMask("00.000.000/0000-00");
                                                          clienteBloc.setTipoPessoa(0);
                                                          clienteBloc.cnpjCpfInvalidoController.add(false);
                                                        } else {
                                                          cnpjCpfController.updateMask("000.000.000-000");
                                                          clienteBloc.setTipoPessoa(1);
                                                          clienteBloc.cnpjCpfInvalidoController.add(false);
                                                        }
                                                      }   
                                                    );
                                                  }
                                                ),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                StreamBuilder<bool>(
                                                  initialData: false,
                                                  stream: clienteBloc.cnpjCpfInvalidoOut,
                                                  builder: (context, snapshot) {
                                                    return AnimatedSwitcher(
                                                      duration: Duration(milliseconds: 180),
                                                      child:  cnpjCpfController.text.length > 14 
                                                      ? customTextField(
                                                        context,
                                                        controller: ieRgController,
                                                        labelText: pessoa.ehFisica == 1 ? locale.palavra.rg : locale.palavra.ie,
                                                        onChanged: (text) {
                                                          clienteBloc.pessoa.ieRg = text;
                                                        }   
                                                      ) : SizedBox.shrink()
                                                    );
                                                  }
                                                ),
                                              ],
                                            );
                                          }
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Column(
                                          children: <Widget>[
                                            StreamBuilder<bool>(
                                              initialData: false,
                                              stream: clienteBloc.campoEnderecoExpandidoOut,
                                              builder: (context, snapshot) {
                                                bool campoHabilitado = snapshot.data;
                                                return CustomExpansionTile(
                                                  key: enderecoKey,
                                                  onExpansionChanged: (isExpanded) {
                                                    clienteBloc.setCampoEnderecoExpandido(isExpanded);
                                                    if(isExpanded) {
                                                      if(clienteBloc.pessoa.endereco != null && clienteBloc.pessoa.endereco.length == 0){
                                                        clienteBloc.newEndereco();
                                                      }
                                                    }
                                                  },
                                                  backgroundColor: Colors.transparent,
                                                  title: StreamBuilder<bool>(
                                                    initialData: false,
                                                    stream: clienteBloc.enderecoApelidoInvalidoOut,
                                                    builder: (context, snapshot) {
                                                      return customTextField(
                                                        context,
                                                        enabled: campoHabilitado,
                                                        controller: apelidoController,
                                                        labelText: locale.palavra.apelido,
                                                        errorText: snapshot.data ? locale.mensagem.nomeNaoNulo : null,
                                                        onChanged: (text) {
                                                          clienteBloc.pessoa.endereco.first.apelido = text;
                                                        }   
                                                      );
                                                    }
                                                  ),
                                                  children: <Widget>[
                                                    SizedBox(
                                                      height: 10,
                                                    ),
                                                    Row(
                                                      children: <Widget>[
                                                        StreamBuilder<bool>(
                                                          initialData: false,
                                                          stream: clienteBloc.enderecoCepInvalidoOut,
                                                          builder: (context, snapshot) {
                                                            return Expanded(
                                                              child: numberTextField(
                                                                context,
                                                                controller: cepTextController,
                                                                labelText: locale.palavra.cep,
                                                                errorText: snapshot.data ? "Cep inválido" : null,
                                                                onChanged: (text) {
                                                                  clienteBloc.pessoa.endereco.first.cep = text;
                                                                }   
                                                              ),
                                                            );
                                                          }  
                                                        ),
                                                        InkWell(
                                                          child: Container(
                                                            padding: EdgeInsets.all(7),
                                                            decoration: BoxDecoration(
                                                              shape: BoxShape.circle,
                                                            ),
                                                            child: Icon(
                                                              Icons.search, 
                                                              color: Colors.white, size: 25,
                                                            )
                                                          ),
                                                          onTap: () async {
                                                            await clienteBloc.searchCep();
                                                          },
                                                        )
                                                      ],
                                                    ),
                                                    SizedBox(
                                                      height: 10,
                                                    ),
                                                    customTextField(
                                                      context,
                                                      controller: logradouroController,
                                                      labelText: locale.palavra.endereco,
                                                      onChanged: (text) {
                                                        clienteBloc.pessoa.endereco.first.logradouro = text;
                                                      }   
                                                    ),
                                                    SizedBox(
                                                      height: 10,
                                                    ),
                                                    customTextField(
                                                      context,
                                                      controller: numeroController,
                                                      labelText: locale.palavra.numero,
                                                      onChanged: (text) {
                                                        clienteBloc.pessoa.endereco.first.numero = text;
                                                      }   
                                                    ),
                                                    SizedBox(
                                                      height: 10,
                                                    ),
                                                    customTextField(
                                                      context,
                                                      controller: complementoController,
                                                      labelText: "Complemento",
                                                      onChanged: (text) {
                                                        clienteBloc.pessoa.endereco.first.complemento = text;
                                                      }   
                                                    ),
                                                    SizedBox(
                                                      height: 10,
                                                    ),
                                                    customTextField(
                                                      context,
                                                      controller: bairroController,
                                                      labelText: locale.palavra.bairro,
                                                      onChanged: (text) {
                                                        clienteBloc.pessoa.endereco.first.bairro = text;
                                                      }
                                                    ),
                                                    SizedBox(
                                                      height: 10,
                                                    ),
                                                    customTextField(
                                                      context,
                                                      controller: municipioController,
                                                      labelText: locale.palavra.cidade,
                                                      onChanged: (text) {
                                                        clienteBloc.pessoa.endereco.first.municipio = text;
                                                      }   
                                                    ),
                                                    SizedBox(
                                                      height: 10,
                                                    ),
                                                    customTextField(
                                                      context,
                                                      controller: estadoController,
                                                      labelText: locale.palavra.estado,
                                                      onChanged: (text) {
                                                        clienteBloc.pessoa.endereco.first.estado = text;
                                                      }   
                                                    ),
                                                  ]
                                                );
                                              }
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        StreamBuilder<bool>(
                                          initialData: false,
                                          stream: clienteBloc.campoContatoExpandidoOut,
                                          builder: (context, snapshot) {
                                            bool campoExpandido = snapshot.data;
                                            return CustomExpansionTile(
                                              key: contatoKey,
                                              onExpansionChanged: (isExpanded) {
                                                clienteBloc.setCampoContatoExpandido(isExpanded);
                                                if(clienteBloc.pessoa.contato != null && clienteBloc.pessoa.contato.length == 0){
                                                  clienteBloc.newContato();
                                                }
                                              },
                                              title: StreamBuilder<bool>(
                                                initialData: false,
                                                stream: clienteBloc.contatoNomeInvalidoOut,
                                                builder: (context, snapshot) {
                                                  return customTextField(
                                                    context,
                                                    enabled: campoExpandido,
                                                    onTap: () {
                                                      if(!contatoKey.currentState.isExpanded){
                                                        contatoKey.currentState.handleTap();
                                                      }
                                                    },
                                                    controller: nomeController,
                                                    labelText: campoExpandido ? locale.palavra.nome : "Contato",
                                                    errorText: snapshot.data ? locale.mensagem.nomeNaoNulo : null,
                                                    onChanged: (text) {
                                                      clienteBloc.pessoa.contato.first.nome = text;
                                                    }   
                                                  );
                                                }
                                              ),
                                              children: <Widget>[
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                numberTextField(
                                                  context,
                                                  controller: telefone1Controller,
                                                  labelText: locale.palavra.telefone + " 1",
                                                  onChanged: (text) {
                                                    clienteBloc.pessoa.contato.first.telefone1 = text;
                                                  }
                                                ),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                numberTextField(
                                                  context,
                                                  controller: telefone2Controller,
                                                  labelText: locale.palavra.telefone + " 2",
                                                  onChanged: (text) {
                                                    clienteBloc.pessoa.contato.first.telefone2 = text;
                                                  }   
                                                ),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                StreamBuilder<bool>(
                                                  initialData: false,
                                                  stream: clienteBloc.contatoEmailInvalidoOut,
                                                  builder: (context, snapshot) {
                                                    return customTextField(
                                                      context,
                                                      controller: emailController,
                                                      labelText: locale.palavra.email,
                                                      errorText: snapshot.data ? "Email inválido" : null,
                                                      onChanged: (text) {
                                                        clienteBloc.pessoa.contato.first.email = text;
                                                      }   
                                                    );
                                                  }  
                                                )
                                              ]
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
                          Column(
                            children: <Widget>[
                              Expanded(
                                child: StreamBuilder<List<Movimento>>(
                                  stream: clienteBloc.movimentoListControllerOut,
                                  builder: (context, snapshot) {
                                    if(!snapshot.hasData){
                                      return Center(child: CircularProgressIndicator(backgroundColor: Colors.white,));
                                    }

                                    if(clienteBloc.pessoa.id == null){
                                      return Center(
                                        child: Text("Não há vendas para esse cliente"),
                                      );
                                    }

                                    List<Movimento> movimentoList = snapshot.data;
                                    MoneyMaskedTextController valorTotalBruto = MoneyMaskedTextController(leftSymbol: "R\$ ");
                                    double valorTotalBrutoAux = 0;
                                    movimentoList.forEach((movimento){
                                      valorTotalBrutoAux += movimento.valorTotalBruto;
                                    });
                                    valorTotalBruto.updateValue(valorTotalBrutoAux);
                                    return Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: <Widget>[
                                            Image.asset('assets/vendaClienteIcon.png', height: 50),
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Text("Total vendido"),
                                                Text("R\$ ${valorTotalBruto.text} em ${movimentoList.length} venda(s).")
                                              ],
                                            )   
                                          ],
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(left: 8, top: 15),
                                          child: Text("Pedidos pendentes: 0"),
                                        ),
                                        Expanded(
                                          child: ListView.separated(
                                            itemCount: movimentoList.length,
                                            shrinkWrap: true,
                                            separatorBuilder: (context, index){
                                              return Divider(color: Colors.white, height: 0.8,);
                                            },
                                            itemBuilder: (context, index){
                                              return ExpansionTile(
                                                title: Text("${dateFormat.format(movimentoList[index].dataMovimento)} | ${movimentoList[index].dataMovimento.hour}:${movimentoList[index].dataMovimento.minute}", style: Theme.of(context).textTheme.subhead,),
                                                trailing: Text("R\$ ${movimentoList[index].valorTotalBruto}", style: Theme.of(context).textTheme.subhead),
                                                children:  movimentoList[index].movimentoItem.map((movimentoItem){
                                                  return Padding(
                                                    padding: const EdgeInsets.only(left: 10, bottom: 5),
                                                    child: Row(
                                                      children: <Widget>[
                                                        Text("${movimentoItem.produto.nome}", style: Theme.of(context).textTheme.body2,),
                                                      ],
                                                    ),
                                                  );
                                                }).toList()
                                              );
                                            }
                                          ),
                                        )
                                      ],
                                    );
                                  }
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                    customButtomGravar(
                      buttonColor: Theme.of(context).primaryIconTheme.color,
                      text: Text(locale.palavra.gravar,
                        style: Theme.of(context).textTheme.title,
                      ),
                      onPressed: () async {
                        clienteBloc.pessoa.cnpjCpf = cnpjCpfController.text;
                        await clienteBloc.validaForm();
                        if (!clienteBloc.formInvalido){
                          print("Nome: "+clienteBloc.pessoa.razaoNome);
                          await clienteBloc.savePessoa();
                          Navigator.pop(context);
                        } else {
                          print("Error form invalido: ");
                        }
                      }
                    )
                  ]  
                );
              }
            )
          )    
        ),
      ),
    );
  }

  @override
  void dispose() {
    print("Dispose Cliente Detail");
    clienteBloc.limpaValidacoes();
    super.dispose();
  } 
}