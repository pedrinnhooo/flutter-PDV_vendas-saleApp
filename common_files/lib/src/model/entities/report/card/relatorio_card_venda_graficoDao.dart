import 'package:common_files/common_files.dart';

class RelatorioCardVendaGraficoDAO {
  HasuraBloc _hasuraBloc;

  RelatorioCardVendaGraficoDAO(this._hasuraBloc);

  Future<List<RelatorioCardVendaGrafico>> getReportFromServer({int idPessoa=0, String tipoRelatorio="dia", DateTime dataInicial, DateTime dataFinal}) async {
    String query = """ 
      {
        relatorio_card_venda_grafico(args: {
          ${idPessoa > 0 ? 'idpessoa: ' + idPessoa.toString() + ',' : ''}
          ${tipoRelatorio != null ? 'tiporelatorio: "' + tipoRelatorio + '",' : ''}
          ${dataInicial != null ? 'datainicial: "' + dataInicial.toIso8601String() +'",' : ''}
          ${dataFinal != null ? 'datafinal: "' + dataFinal.toIso8601String() +'"' : '' }
        }) {
          indice
          label
          valor
        }
      }
    """;

    print("query: $query");
    var data = await _hasuraBloc.hasuraConnect.query(query);
    List<RelatorioCardVendaGrafico> _relatorioCardVendaGraficoList = [];
    for(var i = 0; i < data['data']['relatorio_card_venda_grafico'].length; i++){
      _relatorioCardVendaGraficoList.add(
        RelatorioCardVendaGrafico(
          indice: data['data']['relatorio_card_venda_grafico'][i]['indice'],
          label: data['data']['relatorio_card_venda_grafico'][i]['label'],
          valor: data['data']['relatorio_card_venda_grafico'][i]['valor'].toDouble(),
        )      
      );
    }
    return _relatorioCardVendaGraficoList;
  }

}
