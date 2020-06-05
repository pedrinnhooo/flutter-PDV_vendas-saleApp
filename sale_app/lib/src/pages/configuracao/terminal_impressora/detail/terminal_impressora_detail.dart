import 'package:common_files/common_files.dart';
import 'package:esc_pos_printer/esc_pos_printer.dart';
import 'package:fluggy/generated/locale_base.dart';
import 'package:fluggy/src/pages/configuracao/cupom_layout/cupom_layout_module.dart';
import 'package:fluggy/src/pages/configuracao/terminal/terminal_module.dart';
import 'package:flutter_bluetooth_basic/flutter_bluetooth_basic.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';

class ImpressoraDetailPage extends StatefulWidget {
  @override
  _ImpressoraDetailPageState createState() => _ImpressoraDetailPageState();
}

class _ImpressoraDetailPageState extends State<ImpressoraDetailPage> {
  ImpressoraBloc impressoraBloc;
  TerminalBloc terminalBloc;
  CupomLayoutModule cupomLayoutModule;
  MoneyMaskedTextController valorDesconto;

  @override
  void initState() {
    impressoraBloc = TerminalModule.to.getBloc<ImpressoraBloc>();
    cupomLayoutModule = TerminalModule.to.getDependency<CupomLayoutModule>();
    valorDesconto = MoneyMaskedTextController(decimalSeparator: ".");
    if(impressoraBloc.terminalImpressora != null){
      impressoraBloc.nomeTextEditingController.value =  impressoraBloc.nomeTextEditingController.value.copyWith(text: impressoraBloc.terminalImpressora.nome); 
      impressoraBloc.ipTextEditingController.value =  impressoraBloc.ipTextEditingController.value.copyWith(text: impressoraBloc.terminalImpressora.ip != null ? impressoraBloc.terminalImpressora.ip : null);
      impressoraBloc.macAddressTextEditingController.value = impressoraBloc.macAddressTextEditingController.value.copyWith(text: impressoraBloc.terminalImpressora.macAddress != null ? impressoraBloc.terminalImpressora.macAddress : null);
      impressoraBloc.textoCabecalhoController.value = impressoraBloc.textoCabecalhoController.value.copyWith(text: impressoraBloc.terminalImpressora.textoCabecalho != null ? impressoraBloc.terminalImpressora.textoCabecalho : null);
      impressoraBloc.textoRodapeController.value = impressoraBloc.textoRodapeController.value.copyWith(text: impressoraBloc.terminalImpressora.textoRodape != null ? impressoraBloc.terminalImpressora.textoRodape : null);
    }
    try {
      terminalBloc = TerminalModule.to.getBloc<TerminalBloc>(); 
    } catch (e) {
      terminalBloc = null;
    }
    super.initState();
  } 
  
  @override
  Widget build(BuildContext context) {
    
    final locale = Localizations.of<LocaleBase>(context, LocaleBase);

    return StreamBuilder<TerminalImpressora>(
      initialData: TerminalImpressora(),
      stream: impressoraBloc.impressoraOut,
      builder: (context, snapshot){
        if(snapshot.data.nome == null){
          return Scaffold(
            appBar: AppBar(
              title: Text("Impressoras", style: Theme.of(context).textTheme.title,),
            ),     
            body: Container(
              color: Theme.of(context).primaryColor,
              child: Column(
                children: <Widget>[ 
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
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          InkWell(
                                            child: ListTile(
                                              title: Text("Rede/Wifi", style: Theme.of(context).textTheme.body2,),
                                              trailing: Icon(Icons.chevron_right, color: Colors.white, size: 30),
                                            ),
                                            onTap: () {
                                              Navigator.push(context, 
                                                MaterialPageRoute(
                                                  builder: (context) => ImpressoraRedeList(impressoraBloc: impressoraBloc,),
                                                )
                                              );
                                            },
                                          ),
                                          Divider(
                                            color: Colors.white,
                                            height: 2,
                                          ),
                                          InkWell(
                                            child: ListTile(
                                              title: Text("Bluetooth", style: Theme.of(context).textTheme.body2,),
                                              trailing: Icon(Icons.chevron_right, color: Colors.white, size: 30),
                                            ),
                                            onTap: () {
                                              Navigator.push(context, 
                                                MaterialPageRoute(
                                                  builder: (context) => ImpressoraBluetoothList(impressoraBloc: impressoraBloc,),
                                                )
                                              );
                                            }
                                          ),
                                          Divider(
                                            color: Colors.white,
                                            height: 2,
                                          ),
                                        ],
                                      ),
                                    )
                                  ],    
                                ),
                              ),
                            )
                          ],
                        ),
                      )
                    ),
                  )
                ]
              )
            )
          );
        }
  
        return Scaffold(
          appBar: AppBar(
            title: Text("Impressora", style: Theme.of(context).textTheme.title,),
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
                        child: Text(impressoraBloc.terminalImpressora.id != null 
                          ? locale.palavra.alterar + " " + "Impressora".toLowerCase()
                          : locale.cadastro.incluirNovo,
                          style: Theme.of(context).textTheme.subhead,
                        ),
                      ),
                      Visibility(
                        visible: true,
                        child: Container(
                          padding: EdgeInsets.only(right: 15),
                          child: InkWell(
                            child: Text(impressoraBloc.terminalImpressora.id != null ? locale.palavra.excluir : locale.palavra.limpar,
                            style: Theme.of(context).textTheme.subhead,
                            ),
                            onTap: () async {
                              if (impressoraBloc.terminalImpressora.id != null) {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) => CustomDialogConfirmation(
                                    title: locale.palavra.confirmacao,
                                    description: locale.mensagem.confirmarExcluirRegistro +
                                      locale.palavra.artigo_a + " " +
                                      "impressora ",
                                    item: impressoraBloc.terminalImpressora.nome ,
                                    buttonOkText: locale.palavra.excluir,
                                    buttonCancelText: locale.palavra.cancelar,
                                    funcaoBotaoOk: () async {
                                      if(terminalBloc != null){
                                        await terminalBloc.deleteImpressora();
                                      }
                                      Navigator.pop(context);
                                      Navigator.pop(context);
                                    },
                                    funcaoBotaoCancelar: () async {
                                      Navigator.pop(context);
                                    }
                                  ),
                                );
                              } else {
                                await impressoraBloc.newImpressora();
                                impressoraBloc.nomeTextEditingController.clear();
                              }
                            },
                          ),
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
                                          stream: impressoraBloc.nomeInvalidoOut,
                                          builder: (context, snapshot) {
                                            return customTextField(
                                              context,
                                              autofocus: impressoraBloc.terminalImpressora.id != null ? false : true,
                                              controller: impressoraBloc.nomeTextEditingController,
                                              labelText: locale.palavra.nome,
                                              errorText: snapshot.data ? locale.mensagem.nomeNaoNulo : null,
                                              onChanged: (text) {
                                                impressoraBloc.terminalImpressora.nome = text;
                                              }   
                                            );
                                          }
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Visibility(
                                          visible: terminalBloc != null ? false : true,
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: <Widget>[
                                              Container(
                                                alignment: Alignment.topLeft,
                                                child: Text("Impressora",
                                                style: Theme.of(context).textTheme.display3,
                                                ),
                                              ),
                                              Container(
                                                alignment: Alignment.topLeft,
                                                child: InkWell(
                                                  child: InkWell(
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: <Widget>[
                                                        StreamBuilder<TerminalImpressora>(
                                                          initialData: TerminalImpressora(),
                                                          stream: impressoraBloc.impressoraOut,
                                                          builder: (context, snapshot) {
                                                            return Text(snapshot.data.nome != null ? snapshot.data.nome : locale.palavra.selecione,
                                                              style: Theme.of(context).textTheme.subtitle
                                                            );
                                                          }
                                                        ),
                                                        InkWell(
                                                          child: Icon(
                                                            Icons.arrow_forward_ios,
                                                            color: Theme.of(context).cursorColor,
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                    onTap: () async {
                                                      // Navigator.push(context, 
                                                      //   MaterialPageRoute(
                                                      //     builder: (context) => ImpressoraAddPage()
                                                      //   )
                                                      // );
                                                    },  
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(top: 2),
                                                child: Divider(color: Colors.white,),
                                              ),
                                            ],
                                          ),
                                        ),
                                        StreamBuilder(
                                          stream: impressoraBloc.impressoraOut,
                                          builder: (context, snapshot) {
                                            if(!snapshot.hasData){
                                              return SizedBox.shrink();
                                            }

                                            TerminalImpressora terminalImpressora = snapshot.data;
                                            impressoraBloc.ipTextEditingController.text = terminalImpressora.ip;
                                            return Visibility(
                                              visible: terminalImpressora.ip != null && terminalImpressora.ip != "null" ? true : false,
                                              child: StreamBuilder<bool>(
                                                initialData: false,
                                                stream: impressoraBloc.nomeInvalidoOut,
                                                builder: (context, snapshot) {
                                                  return Row(
                                                    children: <Widget>[
                                                      Expanded(
                                                        child: customTextField(
                                                          context,
                                                          autofocus: impressoraBloc.terminalImpressora.id != null ? false : true,
                                                          controller: impressoraBloc.ipTextEditingController,
                                                          labelText: "Endereço IP",
                                                          errorText: snapshot.data ? "ip não nulo" : null,
                                                          onChanged: (text) {
                                                            impressoraBloc.terminalImpressora.ip = text;
                                                          }   
                                                        ),
                                                      ),
                                                      InkWell(
                                                        child: Container(
                                                          child: StreamBuilder<bool>(
                                                            initialData: false,
                                                            stream: impressoraBloc.testeConexaoOut,
                                                            builder: (context, snapshot) {
                                                              return Icon(Icons.wifi_tethering, 
                                                                color: snapshot.data ? Theme.of(context).primaryIconTheme.color : Colors.red, 
                                                                size: 28,
                                                              );
                                                            }
                                                          ),
                                                        ),
                                                        onTap: () {
                                                          impressoraBloc.testConnection(impressoraBloc.terminalImpressora.ip, context);
                                                        },
                                                      )
                                                    ],
                                                  );
                                                }
                                              ),
                                            );
                                          }
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        StreamBuilder(
                                          stream: impressoraBloc.impressoraOut,
                                          builder: (context, snapshot) {
                                            if(!snapshot.hasData){
                                              return SizedBox.shrink();
                                            }

                                            TerminalImpressora terminalImpressora = snapshot.data;
                                            impressoraBloc.macAddressTextEditingController.text = terminalImpressora.macAddress;
                                            return Visibility(
                                              visible: terminalImpressora.macAddress != null && terminalImpressora.macAddress != "null" ? true : false,
                                              child: StreamBuilder<bool>(
                                                initialData: false,
                                                stream: impressoraBloc.nomeInvalidoOut,
                                                builder: (context, snapshot) {
                                                  return Row(
                                                    children: <Widget>[
                                                      Expanded(
                                                        child: customTextField(
                                                          context,
                                                          autofocus: impressoraBloc.terminalImpressora.id != null ? false : true,
                                                          controller: impressoraBloc.macAddressTextEditingController,
                                                          labelText: "Endereço MAC",
                                                          errorText: snapshot.data ? "mac não nulo" : null,
                                                          onChanged: (text) {
                                                            impressoraBloc.terminalImpressora.macAddress = text;
                                                          }   
                                                        ),
                                                      ),
                                                      InkWell(
                                                        child: Container(
                                                          child: StreamBuilder<bool>(
                                                            initialData: false,
                                                            stream: impressoraBloc.testeConexaoOut,
                                                            builder: (context, snapshot) {
                                                              return Icon(Icons.wifi_tethering, 
                                                                color: snapshot.data ? Theme.of(context).textTheme.display1.color : Colors.red, 
                                                                size: 28,
                                                              );
                                                            }
                                                          ),
                                                        ),
                                                        onTap: () async { 
                                                          BluetoothDevice bluetoothDevice = BluetoothDevice();
                                                          bluetoothDevice.address = terminalImpressora.macAddress;
                                                          bluetoothDevice.name = terminalImpressora.nome;
                                                          bluetoothDevice.type = 3;
                                                          bluetoothDevice.connected = true;
                                                          PrinterBluetooth printerBluetooth = PrinterBluetooth(bluetoothDevice);
                                                          impressoraBloc.testBluetoothConnection(printerBluetooth, context);
                                                        },
                                                      )
                                                    ],
                                                  );
                                                }
                                              ),
                                            );
                                          }
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        TextFormField(
                                          controller: impressoraBloc.textoCabecalhoController,
                                          cursorColor: Colors.white,
                                          style: Theme.of(context).textTheme.subtitle,
                                          maxLines: 3,
                                          maxLength: 40,
                                          decoration: InputDecoration(
                                            counter: SizedBox.shrink(),
                                            contentPadding: EdgeInsets.all(10),
                                            labelText: " Texto cabeçalho",
                                            labelStyle: Theme.of(context).textTheme.caption,
                                            errorStyle: Theme.of(context).textTheme.body2,
                                            errorBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Colors.white38
                                              ),
                                            ),
                                            focusedErrorBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Colors.white38
                                              ),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Colors.white38
                                              ),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Colors.white
                                              )
                                            )
                                          ),
                                          onChanged: (text) {
                                            impressoraBloc.terminalImpressora.textoCabecalho = text;
                                          },
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        TextFormField(
                                          controller: impressoraBloc.textoRodapeController,
                                          cursorColor: Colors.white,
                                          maxLength: 40,
                                          maxLines: 3,
                                          style: Theme.of(context).textTheme.subtitle,
                                          decoration: InputDecoration(
                                            contentPadding: EdgeInsets.all(10),
                                            counter: SizedBox.shrink(),
                                            labelText: " Texto rodapé",
                                            labelStyle: Theme.of(context).textTheme.caption,
                                            errorStyle: Theme.of(context).textTheme.body2,
                                            errorBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Colors.white38
                                              ),
                                            ),
                                            focusedErrorBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Colors.white38
                                              ),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Colors.white38
                                              ),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Colors.white
                                              )
                                            )
                                          ),
                                          onChanged: (text) {
                                            impressoraBloc.terminalImpressora.textoRodape = text;
                                          },
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        StreamBuilder<Terminal>(
                                          initialData: Terminal(),  
                                          stream: terminalBloc.terminalOut,
                                          builder: (context, snapshot) {
                                            return Column(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: <Widget>[
                                                Column(
                                                  children: <Widget>[
                                                    Container(
                                                      alignment: Alignment.topLeft,
                                                      child: Text("Layout",
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
                                                              return Text(impressoraBloc.terminalImpressora.idCupomLayout != null ? impressoraBloc.terminalImpressora.cupomLayout.nome : locale.palavra.selecione,
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
                                                                  //settings: RouteSettings(name: '/ListaTransacao'),
                                                                  builder: (context) {
                                                                    return cupomLayoutModule;
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
                                                FlatButton(
                                                  color: Colors.white,
                                                  child: Text("Imprimir página de teste", style: TextStyle(color: Theme.of(context).accentColor),),
                                                  onPressed: () {
                                                    if(impressoraBloc.terminalImpressora.ip != null){
                                                      impressoraBloc.testPrint(impressoraBloc.terminalImpressora.ip);
                                                    } else {
                                                      BluetoothDevice bluetoothDevice = BluetoothDevice();
                                                      bluetoothDevice.address = impressoraBloc.terminalImpressora.macAddress;
                                                      bluetoothDevice.name = impressoraBloc.terminalImpressora.nome;
                                                      bluetoothDevice.type = 3;
                                                      bluetoothDevice.connected = true;
                                                      PrinterBluetooth printerBluetooth = PrinterBluetooth(bluetoothDevice);
                                                      impressoraBloc.testBluetoothPrint(printerBluetooth);
                                                    }
                                                  },
                                                )
                                              ],
                                            );
                                          },
                                        ),
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
                              //await impressoraBloc.validaNome();
                              //if (!impressoraBloc.formInvalido){
                                if(terminalBloc != null){
                                  if(impressoraBloc.terminalImpressora.macAddress != null){
                                    terminalBloc.setImpressoraBluetooth(impressoraBloc.terminalImpressora);
                                    Navigator.pop(context);
                                  } else {
                                    terminalBloc.setImpressora(impressoraBloc.terminalImpressora);
                                    Navigator.pop(context);
                                  }
                                }
                              //}
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
      },
    );
  }

  @override
  void dispose() {
    print("Dispose Impressora Detail");
    impressoraBloc.limpaValidacoes();
    impressoraBloc.resetBloc();
    super.dispose();
  }   
}

class ImpressoraRedeList extends StatefulWidget {
  ImpressoraBloc impressoraBloc;
  ImpressoraRedeList({this.impressoraBloc});

  @override
  _ImpressoraRedeListState createState() => _ImpressoraRedeListState();
}

class _ImpressoraRedeListState extends State<ImpressoraRedeList> {

  @override
  void initState() { 
    super.initState();
    widget.impressoraBloc.getlocalIp();
  }

  @override
  Widget build(BuildContext context) {
    Widget body = Expanded(
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[ 
                    StreamBuilder(
                      stream: widget.impressoraBloc.pesquisaOut,
                      builder: (context, snapshot) {
                        if(!snapshot.hasData || snapshot.data == true){
                          return Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text("Aguarde um momento, estamos buscando por impressoras na rede.", style: Theme.of(context).textTheme.subtitle, textAlign: TextAlign.center,),
                                Padding(
                                  padding: const EdgeInsets.only(top: 20.0),
                                  child: CircularProgressIndicator(backgroundColor: Colors.white,),
                                ),
                              ],
                            ),
                          );
                        }

                        return StreamBuilder<List<TerminalImpressora>>(
                          stream: widget.impressoraBloc.impressoraListOut,
                          builder: (context, snapshot){
                            if(!snapshot.hasData){
                              return CircularProgressIndicator();
                            }

                            if(snapshot.data.length == 0){
                              return  Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text("Não foi encontrada nenhuma impressora na rede. Certifique-se de que ela esteja ligada e conectada a mesma rede do smartphone.",
                                      style: Theme.of(context).textTheme.subtitle,
                                      textAlign: TextAlign.center,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 20.0),
                                      child: FlatButton(
                                        color: Colors.white,
                                        child: Text("Atualizar", style: TextStyle(
                                          color: Theme.of(context).accentColor,),
                                        ),
                                        onPressed: () {
                                          widget.impressoraBloc.scanNetwork();
                                        },
                                      ),
                                    )
                                  ]
                                ),
                              );
                            }
                            List<TerminalImpressora> _impressoraList = snapshot.data;
                            
                            return Expanded(
                              child: ListView.separated(
                                itemCount: _impressoraList.length,
                                separatorBuilder: (context, index){
                                  return Divider(color: Colors.white,);
                                },
                                itemBuilder: (context, index){
                                  return ListTile(
                                    title: Text("${_impressoraList[index].ip}", style: Theme.of(context).textTheme.subtitle,),
                                    onTap: () async {
                                      await widget.impressoraBloc.setImpressora(_impressoraList[index]);
                                      Navigator.pop(context);
                                    },
                                  );
                                },
                              )
                            );
                          },
                        );
                      }
                    ),
                  ]
                )
              )
            ]
          )
        )
      )
    );

    return Scaffold(
      appBar: AppBar(
        title: Text("Impressoras de Rede"),
      ),      
      body: Container(
        color: Theme.of(context).primaryColor,
        child: Column(
          children: <Widget>[
            body
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}

class ImpressoraBluetoothList extends StatefulWidget {
  ImpressoraBloc impressoraBloc;
  ImpressoraBluetoothList({this.impressoraBloc});

  @override
  _ImpressoraBluetoothListState createState() => _ImpressoraBluetoothListState();
}

class _ImpressoraBluetoothListState extends State<ImpressoraBluetoothList> {

  @override
  void initState() { 
    super.initState();
    try {
      widget.impressoraBloc.scanBluetoothDevices(); 
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget body = Expanded(
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
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[ 
                    StreamBuilder(
                      stream: widget.impressoraBloc.pesquisaOut,
                      builder: (context, snapshot) {
                        if(!snapshot.hasData || snapshot.data == true){
                          return Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text("Aguarde um momento, estamos buscando por impressoras pareados ao smartphone.", style: Theme.of(context).textTheme.subtitle, textAlign: TextAlign.center,),
                                Padding(
                                  padding: const EdgeInsets.only(top: 20.0),
                                  child: CircularProgressIndicator(backgroundColor: Colors.white,),
                                ),
                              ],
                            ),
                          );
                        }

                        return StreamBuilder(
                          stream: widget.impressoraBloc.impressoraBluetoothListOut,
                          builder: (context, snapshot){
                            if(!snapshot.hasData){
                              return CircularProgressIndicator();
                            }

                            if(snapshot.data.length == 0){
                              return  Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text("Não foi encontrada nenhuma impressora Bluetooth. Certifique-se de que ela esteja ligada e pareada ao smartphone.",
                                      style: Theme.of(context).textTheme.subtitle,
                                      textAlign: TextAlign.center,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 20.0),
                                      child: FlatButton(
                                        color: Colors.white,
                                        child: Text("Atualizar", style: TextStyle(
                                          color: Theme.of(context).accentColor,),
                                        ),
                                        onPressed: () {
                                          widget.impressoraBloc.scanBluetoothDevices();
                                        },
                                      ),
                                    )
                                  ]
                                ),
                              );
                            }
                            List<PrinterBluetooth> _impressoraList = snapshot.data;
                            
                            return Expanded(
                              child: ListView.separated(
                                itemCount: _impressoraList.length,
                                separatorBuilder: (context, index){
                                  return Divider(color: Colors.white,);
                                },
                                itemBuilder: (context, index){
                                  return ListTile(
                                    title: Text("Nome: ${_impressoraList[index].name}" ?? '', style: Theme.of(context).textTheme.subtitle,),
                                    subtitle: Text("MAC: ${_impressoraList[index].address}", style: TextStyle(color: Colors.white),),
                                    onTap: () {
                                      widget.impressoraBloc.setImpressoraBluetooth(_impressoraList[index]);
                                      Navigator.pop(context);
                                    },
                                  );
                                },
                              )
                            );
                          },
                        );
                      }
                    )
                  ]
                )
              )
            ]
          )
        )
      )
    );

    return Scaffold(
      appBar: AppBar(
        title: Text("Impressoras Bluetooth"),
      ),      
      body: Container(
        color: Theme.of(context).primaryColor,
        child: Column(
          children: <Widget>[
            //header,
            body
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}