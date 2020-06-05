import 'package:common_files/common_files.dart';

class RelatorioCardTopCategoriaDAO {
  HasuraBloc _hasuraBloc;

  RelatorioCardTopCategoriaDAO(this._hasuraBloc);

  Future<List<RelatorioCardTopCategoria>> getReportFromServer({int idPessoa=0, String ordem, DateTime dataInicial, DateTime dataFinal}) async {
    String query = """ 
      {
        relatorio_card_top_categoria(args: {
          ${idPessoa > 0 ? 'idpessoa: ' + idPessoa.toString() + ',' : ''}
          ${ordem != null ? 'ordem: ' + ordem + ',' : ''}
          ${dataInicial != null ? 'datainicial: "' + dataInicial.toIso8601String() +'",' : ''}
          ${dataFinal != null ? 'datafinal: "' + dataFinal.toIso8601String() +'"' : '' }
        }) {
          nome
          quantidade
          valor
        }
      }
    """;

    print("query: $query");
    var data = await _hasuraBloc.hasuraConnect.query(query);
    List<RelatorioCardTopCategoria> _relatorioCardTopCategoriaList = [];
    for(var i = 0; i < data['data']['relatorio_card_top_categoria'].length; i++){
      _relatorioCardTopCategoriaList.add(
        RelatorioCardTopCategoria(
          nome: data['data']['relatorio_card_top_categoria'][i]['nome'],
          quantidade: data['data']['relatorio_card_top_categoria'][i]['quantidade'].toDouble(),
          valor: data['data']['relatorio_card_top_categoria'][i]['valor'].toDouble(),
        )      
      );
    }
    return _relatorioCardTopCategoriaList;
  }

}
