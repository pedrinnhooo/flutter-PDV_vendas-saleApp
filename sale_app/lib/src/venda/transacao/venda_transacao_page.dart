import 'package:common_files/common_files.dart';
import 'package:flutter/material.dart';
import 'package:fluggy/src/app_module.dart';
import 'package:fluggy/src/venda/transacao/venda_transacao_bloc.dart';
import 'package:fluggy/src/venda/transacao/venda_transacao_module.dart';

class VendaTransacaoPage extends StatefulWidget {
  @override
  _VendaTransacaoPageState createState() => _VendaTransacaoPageState();
}

class _VendaTransacaoPageState extends State<VendaTransacaoPage> {
  VendaTransacaoBloc transacaoBloc = VendaTransacaoModule.to.getBloc<VendaTransacaoBloc>();
  SharedVendaBloc vendaBloc = AppModule.to.getBloc<SharedVendaBloc>();

  @override
  void initState() {
    transacaoBloc.getAllTransacao();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'assets/palavraFluggy.png',
              fit: BoxFit.contain,
              height: 40,
            )
          ],
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor
        ),
        child: Column(
          children: <Widget>[
            StreamBuilder(
              stream: transacaoBloc.transacaoListOut,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }
                List<Transacao> transacaoList = snapshot.data;
                
                return Expanded(
                  child: ListView.builder(
                    itemCount: transacaoList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return InkWell(
                        child: Padding(
                          padding: const EdgeInsets.only(right: 8.0, left: 8.0, top: 5),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: Theme.of(context).accentColor
                            ),
                            child: ListTile(
                              title: Text(
                                "${transacaoList[index].nome}", style: TextStyle(fontSize: 18),
                              ),
                            ),
                          ),
                        ),
                        onTap: () {
                          if(vendaBloc.movimento.transacao.id == transacaoList[index].id){
                            vendaBloc.getallProduto();
                            Navigator.pop(context);
                          } else {
                            vendaBloc.resetBloc();
                            vendaBloc.setMovimentoTransacao(transacaoList[index]);
                            vendaBloc.getallProduto();
                            Navigator.pop(context);
                          }
                        },
                      );
                    },
                  ),
                );
              }
            )
          ],
        ),
      ),
    );
  }
}
