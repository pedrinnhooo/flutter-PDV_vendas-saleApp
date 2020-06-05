import 'package:common_files/common_files.dart';

class RelatorioCardTipoPagamentoDAO {
  HasuraBloc _hasuraBloc;

  RelatorioCardTipoPagamentoDAO(this._hasuraBloc);

  Future<List<RelatorioCardTipoPagamento>> getReportFromServer({int idPessoa=0, DateTime dataInicial, DateTime dataFinal}) async {
    String query = """ 
      {
        relatorio_card_tipo_pagamento(args: {
          ${idPessoa > 0 ? 'idpessoa: ' + idPessoa.toString() + ',' : ''}
          ${dataInicial != null ? 'datainicial: "' + dataInicial.toIso8601String() +'",' : ''}
          ${dataFinal != null ? 'datafinal: "' + dataFinal.toIso8601String() +'"' : '' }
        }) {
          nome
          valor
          id_tipo_pagamento
        }
      }
    """;

    print("query: $query");
    var data = await _hasuraBloc.hasuraConnect.query(query);
    List<RelatorioCardTipoPagamento> _relatorioCardTipoPagamentoList = [];
    for(var i = 0; i < data['data']['relatorio_card_tipo_pagamento'].length; i++){
      _relatorioCardTipoPagamentoList.add(
        RelatorioCardTipoPagamento(
          nome: data['data']['relatorio_card_tipo_pagamento'][i]['nome'],
          valor: data['data']['relatorio_card_tipo_pagamento'][i]['valor'].toDouble(),
          idTipoPagamento: data['data']['relatorio_card_tipo_pagamento'][i]['id_tipo_pagamento'],
        )      
      );
    }
    return _relatorioCardTipoPagamentoList;
  }

}
