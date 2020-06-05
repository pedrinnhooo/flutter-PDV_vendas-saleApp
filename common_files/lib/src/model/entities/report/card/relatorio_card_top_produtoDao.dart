import 'package:common_files/common_files.dart';

class RelatorioCardTopProdutoDAO {
  HasuraBloc _hasuraBloc;

  RelatorioCardTopProdutoDAO(this._hasuraBloc);

  Future<List<RelatorioCardTopProduto>> getReportFromServer({int idPessoa=0, String ordem, DateTime dataInicial, DateTime dataFinal}) async {
    String query = """ 
      {
        relatorio_card_top_produto(args: {
          ${idPessoa > 0 ? 'idpessoa: ' + idPessoa.toString() + ',' : ''}
          ${ordem != null ? 'ordem: ' + ordem + ',' : ''}
          ${dataInicial != null ? 'datainicial: "' + dataInicial.toIso8601String() +'",' : ''}
          ${dataFinal != null ? 'datafinal: "' + dataFinal.toIso8601String() +'"' : '' }
        }) {
          id_aparente
          nome
          quantidade
          valor
        }
      }
    """;

    print("query: $query");
    var data = await _hasuraBloc.hasuraConnect.query(query);
    List<RelatorioCardTopProduto> _relatorioCardTopProdutoList = [];
    for(var i = 0; i < data['data']['relatorio_card_top_produto'].length; i++){
      _relatorioCardTopProdutoList.add(
        RelatorioCardTopProduto(
          idAparente: data['data']['relatorio_card_top_produto'][i]['id_aparente'],
          nome: data['data']['relatorio_card_top_produto'][i]['nome'],
          quantidade: data['data']['relatorio_card_top_produto'][i]['quantidade'].toDouble(),
          valor: data['data']['relatorio_card_top_produto'][i]['valor'].toDouble(),
        )      
      );
    }
    return _relatorioCardTopProdutoList;
  }

}
