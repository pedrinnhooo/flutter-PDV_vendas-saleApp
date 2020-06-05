import 'package:common_files/common_files.dart';
import 'package:common_files/src/model/dao/dao.dart';
import 'package:common_files/src/model/entities/cadastro/preco_tabela/preco_tabela_item.dart';
import 'package:common_files/src/model/entities/interfaces.dart';

class PrecoTabelaItemDAO implements IEntityDAO {
  HasuraBloc _hasuraBloc;
  final String tableName = "preco_tabela_item";
  int filterId = 0;
  String filterText = "";
  int filterPrecoTabela = 0;
  int filterProduto = 0;
 
  PrecoTabelaItem _precoTabelaItem;
  List<PrecoTabelaItem> _precoTabelaItemList;

  @override
  Dao dao;

  PrecoTabelaItemDAO(this._hasuraBloc, this._precoTabelaItem) {
    dao = Dao();
  }

  @override
  IEntity fromMap(Map<String, dynamic> map) {
    _precoTabelaItem.id = map['id'];
    _precoTabelaItem.idPrecoTabela = map['id_preco_tabela'];
    _precoTabelaItem.idProduto = map['id_produto'];
    _precoTabelaItem.preco = map['preco'];
    _precoTabelaItem.dataCadastro = map['data_cadastro'];
    _precoTabelaItem.dataAtualizacao = map['data_atualizacao'];
    return _precoTabelaItem;
  }

  @override
  Future<List> getAll({bool preLoad = false}) async {
    String where = "";
    List<dynamic> args = [];
    where = "1 = 1 ";
    if ((filterId > 0) || (filterText != "")) {
      if (filterId > 0) {
        where = where + "and (id = " + filterId.toString() + ") ";
      }
      if (filterText != "") {
        where = where + "and (nome like '%" + filterText + "%') ";
      }
    }
    if (filterPrecoTabela > 0) {
      where = where + "and (id_preco_tabela = " + filterPrecoTabela.toString() + ") ";
    }
    if (filterProduto > 0) {
      where = where + "and (id_produto = " + filterProduto.toString() + ") ";
    }

    List list = await dao.getList(this, where, args);
    _precoTabelaItemList = List.generate(list.length, (i) {
      return PrecoTabelaItem(
        id: list[i]['id'],
        idPrecoTabela: list[i]['id_preco_tabela'],
        idProduto: list[i]['id_produto'],
        preco: list[i]['preco'],
        dataCadastro: DateTime.parse(list[i]['data_cadastro']),
        dataAtualizacao: DateTime.parse(list[i]['data_atualizacao']),
      );
    });

    return _precoTabelaItemList;
  }

  Future<List<PrecoTabelaItem>> getAllPrecoTabelaItemFromServer({
    bool id=false, bool idPrecoTabela=false, bool idProduto=false,
    bool preco=false, bool, dataCadastro=false, bool dataAtualizacao=false,
    int filtroId=-1
  }) async {
    String _query = """
    query getAllPrecoTabelaItem {
      preco_tabela_item(
        ${filtroId != -1 ? "where: {id: {_eq: $filtroId}},": ""} 
          order_by: {id: asc}) 
      {
        ${id ? "id" : ""}
        ${idPrecoTabela ? "id_preco_tabela" : "" }
        ${idProduto ? "id_produto" : "" }
        ${preco ? "preco" : "" }
        ${dataCadastro ? "data_cadastro" : "" }
        ${dataAtualizacao ? "data_atualizacao" : "" }
      }
    }
    """;

    var data = await _hasuraBloc.hasuraConnect.query(_query);
      for(var i=0; i < data['data']['preco_tabela_item'].length; i++){
        _precoTabelaItemList.add(
          PrecoTabelaItem(
            id: data['data']['preco_tabela_item'][i]['id'],
            idProduto: data['data']['preco_tabela_item'][i]['id_produto'],
            idPrecoTabela: data['data']['preco_tabela_item'][i]['id_preco_tabela'],
            preco: data['data']['preco_tabela_item'][i]['preco'],
            dataCadastro: data['data']['preco_tabela_item'][i]['data_cadastro'],
            dataAtualizacao: data['data']['preco_tabela_item'][i]['data_atualizacao'],
          )
        );
      }
    return _precoTabelaItemList;
  }

  @override
  Future<IEntity> getById(int id) async {
    _precoTabelaItem = await dao.getById(this, id);
    return _precoTabelaItem;
  }

  @override
  Future<IEntity> insert() async {
    _precoTabelaItem.id = await dao.insert(this);
    return _precoTabelaItem;
  }

  Future<PrecoTabelaItem> saveOnServer() async {
    String _query = """
      mutation savePrecoTabelaItem {
        insert_preco_tabela_item(
          objects: {""";

      if ((_precoTabelaItem.id != null) && (_precoTabelaItem.id > 0)) {
        _query += "id: ${_precoTabelaItem.id},";
      }

        _query += """
            id_produto: ${_precoTabelaItem.idProduto}, 
            id_preco_tabela: ${_precoTabelaItem.idPrecoTabela}, 
            preco: ${_precoTabelaItem.preco}, 
            data_cadastro: "${_precoTabelaItem.dataCadastro}", 
            data_atualizacao: "${_precoTabelaItem.dataAtualizacao}"}, 
          on_conflict: {
            constraint: preco_tabela_item_pkey, 
            update_columns: [
              id_produto,
              id_preco_tabela,
              preco,
              data_atualizacao
            ]}) {
          returning {
            id
          }
        }
      } """;

    try {
      var data = await _hasuraBloc.hasuraConnect.mutation(_query);
      _precoTabelaItem.id = data['data']['insert_preco_tabela_item'][0]['id'];
      return _precoTabelaItem;
    } catch (e) {
      return null;
    }
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'id': _precoTabelaItem.id,
      'id_preco_tabela': _precoTabelaItem.idPrecoTabela,
      'id_produto': _precoTabelaItem.idProduto,
      'preco': _precoTabelaItem.preco,
      'data_cadastro': _precoTabelaItem.dataCadastro.toString(),
      'data_atualizacao': _precoTabelaItem.dataAtualizacao.toString(),
    };
  }
}
