import 'package:common_files/common_files.dart';

class EstoqueDAO {
  HasuraBloc _hasuraBloc;

  MovimentoEstoque movimentoEstoque;
  List<Estoque> estoqueList = [];

 
  EstoqueDAO(this._hasuraBloc, {this.movimentoEstoque});

  Future<List<MovimentoEstoque>> getAllFromServer({int filterIdMovimento=0}) async {
    String query = """ {
    } """;

    // var data = await _hasuraBloc.hasuraConnect.query(query);
    // estoqueList = [];
    // for(var i = 0; i < data['data']['estoque'].length; i++){
    //   estoqueList.add(
    //     Estoque(
    //       id: data['data']['estoque'][i]['id'],
    //       idPessoa: data['data']['estoque'][i]['id'],
    //       idPessoaGrupo: data['data']['estoque'][i]['id_pessoa_grupo'],
    //       idProduto: data['data']['estoque'][i]['id_produto'],
    //       idVariante: data['data']['estoque'][i]['id_variante'],
    //       estoqueTotal: data['data']['estoque'][i]['estoque_total'].toDouble(),
    //       et1: data['data']['estoque'][i]['et1'].toDouble(),
    //       et2: data['data']['estoque'][i]['et2'].toDouble(),
    //       et3: data['data']['estoque'][i]['et3'].toDouble(),
    //       et4: data['data']['estoque'][i]['et4'].toDouble(),
    //       et5: data['data']['estoque'][i]['et5'].toDouble(),
    //       et6: data['data']['estoque'][i]['et6'].toDouble(),
    //       et7: data['data']['estoque'][i]['et7'].toDouble(),
    //       et8: data['data']['estoque'][i]['et8'].toDouble(),
    //       et9: data['data']['estoque'][i]['et9'].toDouble(),
    //       et10: data['data']['estoque'][i]['et10'].toDouble(),
    //       et11: data['data']['estoque'][i]['et11'].toDouble(),
    //       et12: data['data']['estoque'][i]['et12'].toDouble(),
    //       et13: data['data']['estoque'][i]['et13'].toDouble(),
    //       et14: data['data']['estoque'][i]['et14'].toDouble(),
    //       et15: data['data']['estoque'][i]['et15'].toDouble(),
    //       dataCadastro: data['data']['estoque'][i]['data_cadastro'] != null ? DateTime.parse(data['data']['estoque'][i]['data_cadastro']) : null,
    //       dataAtualizacao: data['data']['estoque'][i]['data_atualizacao'] != null ? DateTime.parse(data['data']['estoque'][i]['data_atualizacao']) : null
    //     )       
    //   );
    // }
    //return estoqueList;
  }
}