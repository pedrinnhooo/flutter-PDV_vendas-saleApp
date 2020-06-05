import 'package:common_files/common_files.dart';

class RelatorioCardVendaTotalDAO {
  HasuraBloc _hasuraBloc;

  RelatorioCardVendaTotalDAO(this._hasuraBloc);

  Future<RelatorioCardVendaTotal> getReportFromServer({int idPessoa=0, DateTime dataInicial, DateTime dataFinal}) async {
    String query = """ 
      {
        relatorio_card_venda_total(args: {
          ${idPessoa > 0 ? 'idpessoa: ' + idPessoa.toString() + ',' : ''}
          ${dataInicial != null ? 'datainicial: "' + dataInicial.toIso8601String() +'",' : ''}
          ${dataFinal != null ? 'datafinal: "' + dataFinal.toIso8601String() +'"' : '' }
        }) {
          id_pessoa_grupo
          valor_total_bruto
          quantidade_vendas
          ticket_medio
          quantidade_vendida
        }
      }
    """;

    print("query: $query");
    RelatorioCardVendaTotal _relatorioCardVendaTotal;
    var data = await _hasuraBloc.hasuraConnect.query(query);
    if (data['data']['relatorio_card_venda_total'].length > 0) {
      _relatorioCardVendaTotal = RelatorioCardVendaTotal(
        valorTotalBruto: data['data']['relatorio_card_venda_total'][0]['valor_total_bruto'],
        quantidadeVendas: data['data']['relatorio_card_venda_total'][0]['quantidade_vendas'],
        ticketMedio: data['data']['relatorio_card_venda_total'][0]['ticket_medio'],
        quantidadeVendida: data['data']['relatorio_card_venda_total'][0]['quantidade_vendida'],
      );
    } else {
      _relatorioCardVendaTotal = RelatorioCardVendaTotal();
    }
    
    return _relatorioCardVendaTotal;
  }

}
