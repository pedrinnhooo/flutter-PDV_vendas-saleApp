import 'package:flutter/material.dart';
import 'package:fluggy/src/venda/consulta_movimento_cliente/consulta_movimento_cliente_detalhe/consulta_movimento_cliente_detalhe_page.dart';

class ConsultaMovimentoClientePage extends StatefulWidget {
  @override
  _ConsultaMovimentoClientePageState createState() =>
      _ConsultaMovimentoClientePageState();
}

class _ConsultaMovimentoClientePageState
    extends State<ConsultaMovimentoClientePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Lista de fiadeiros"),
      ),
      body: Column(
        children: <Widget>[
          ListTile(title: Text("Filtro"),),
          Expanded(
            child: ListView.builder(
              itemCount: 18,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: Text("João $index"),
                  trailing: Text("Valor R\$ $index"),
                  onTap: () {
                    Navigator.push(context,
                      PageRouteBuilder(
                        opaque: false,
                        settings: RouteSettings(name: '/DetalheMovimentoCliente'),
                        pageBuilder: (BuildContext context, _, __) => ConsultaMovimentoClienteDetalhePage()
                      )
                    );
                  },
                );
              }
            ),
          )
        ],
      )
    );
  }
}