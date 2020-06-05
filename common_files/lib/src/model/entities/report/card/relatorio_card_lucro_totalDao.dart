import 'package:common_files/common_files.dart';

class RelatorioCardLucroTotalDAO {
  HasuraBloc _hasuraBloc;

  RelatorioCardLucroTotalDAO(this._hasuraBloc);

  Future<RelatorioCardLucroTotal> getReportFromServer({int idPessoa=0, DateTime dataInicial, DateTime dataFinal}) async {
    String query = """ 
      {
        relatorio_card_lucro_total(args: {
          ${idPessoa > 0 ? 'idpessoa: ' + idPessoa.toString() + ',' : ''}
          ${dataInicial != null ? 'datainicial: "' + dataInicial.toIso8601String() +'",' : ''}
          ${dataFinal != null ? 'datafinal: "' + dataFinal.toIso8601String() +'"' : '' }
        }) {
          id_pessoa_grupo
          valor_total_liquido
          valor_total_lucro
          valor_total_custo
          percentual_lucro
        }
      }
    """;

    print("query: $query");
    RelatorioCardLucroTotal _relatorioCardLucroTotal;
    var data = await _hasuraBloc.hasuraConnect.query(query);
    if (data['data']['relatorio_card_lucro_total'].length > 0) {
     _relatorioCardLucroTotal = RelatorioCardLucroTotal(
        valorTotalLucro: data['data']['relatorio_card_lucro_total'][0]['valor_total_lucro'],
        valorTotalLiquido: data['data']['relatorio_card_lucro_total'][0]['valor_total_liquido'],
        valorTotalCusto: data['data']['relatorio_card_lucro_total'][0]['valor_total_custo'].toDouble(),
        percentualLucro: data['data']['relatorio_card_lucro_total'][0]['percentual_lucro'],
      );
    } else {
      _relatorioCardLucroTotal = RelatorioCardLucroTotal();
    }
    return _relatorioCardLucroTotal;
  }

}
