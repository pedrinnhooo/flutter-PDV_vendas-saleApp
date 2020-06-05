import 'dart:convert';

import 'package:common_files/common_files.dart';

class ProdutoCodigoBarrasDAO implements IEntityDAO {
  HasuraBloc _hasuraBloc;
  AppGlobalBloc _appGlobalBloc;
  final String tableName = "produto_codigo_barras";
  int filterId = 0;
  String filterText = "";
  int filterProduto = 0;
  bool loadVariante = false;

  ProdutoCodigoBarras produtoCodigoBarras;
  List<ProdutoCodigoBarras> produtoCodigoBarrasList;

  @override
  Dao dao;

  ProdutoCodigoBarrasDAO(this._hasuraBloc, this._appGlobalBloc, {this.produtoCodigoBarras}) {
    dao = Dao();
    //dao.createDb();
  }

  @override
  IEntity fromMap(Map<String, dynamic> map) {
    this.produtoCodigoBarras.id = map['id'];
    this.produtoCodigoBarras.idProduto = map['id_codigo'];
    this.produtoCodigoBarras.idVariante = map['id_variante'];
    this.produtoCodigoBarras.gradePosicao = map['grade_posicao'];
    this.produtoCodigoBarras.codigoBarras = map['codigo_barras'];
    this.produtoCodigoBarras.ehDeletado = map['ehdeletado'];
    this.produtoCodigoBarras.dataCadastro = DateTime.parse(map['data_cadastro']);
    this.produtoCodigoBarras.dataAtualizacao = DateTime.parse(map['data_atualizacao']);
    return this.produtoCodigoBarras;
  }

  @override
  Future<List> getAll({bool preLoad = false}) async {
    String where = "";
    List<dynamic> args = [];

    if (filterText != "") {
      where = "1 = 1 ";
      where = where + "and (codigo_barras = '$filterText')";
    }

    List list = await dao.getList(this, where, args);
    produtoCodigoBarrasList = List.generate(list.length, (i) {
      return ProdutoCodigoBarras(
        id: list[i]['id'],
        idProduto: list[i]['id_produto'],
        idVariante: list[i]['id_variante'],
        gradePosicao: list[i]['grade_posicao'],
        codigoBarras: list[i]['codigo_barras'],
        ehDeletado: list[i]['ehdeletado'],
        dataCadastro: list[i]['data_cadastro'] != null ? DateTime.parse(list[i]['data_cadastro']) : null,
        dataAtualizacao: list[i]['data_atualizacao'] != null ? DateTime.parse(list[i]['data_atualizacao']) : null,
      );
    });

    if (preLoad) {
      for (var produtoCodigoBarras in produtoCodigoBarrasList) {
        VarianteDAO varianteDAO = VarianteDAO(_hasuraBloc, _appGlobalBloc, variante: produtoCodigoBarras.variante);
        produtoCodigoBarras.variante = loadVariante
            ? await varianteDAO.getById(produtoCodigoBarras.idVariante)
            : produtoCodigoBarras.variante;
      }
    }        

    return produtoCodigoBarrasList;
  }

  Future<List> getAllFromServer({bool preLoad=false, bool id=false, bool idProduto=false,
    bool idVariante=false, bool gradePosicao=false, bool codigoBarras=false,
    bool ehDeletado=false, bool dataCadastro=false, bool dataAtualizacao=false,
    String filterCodigoBarras="", int filterProdutoDiferente=0, 
    DateTime filtroDataAtualizacao, FilterEhDeletado filterEhDeletado=FilterEhDeletado.naoDeletados}) async {
    List<ProdutoCodigoBarras> produtoCodigoBarrasList;
    String query = """ 
      {
        produto_codigo_barras(where: {
          id_produto: {${filterProdutoDiferente != 0 ? '_neq:  $filterProdutoDiferente' : ''}},
          codigo_barras: {${filterCodigoBarras != "" ? '_eq:  "$filterCodigoBarras"' : ''}},
          ehdeletado: {${filterEhDeletado != FilterEhDeletado.todos ? filterEhDeletado == FilterEhDeletado.naoDeletados ? '_eq:  0' : '_eq:  1' : ''}},
          data_atualizacao: {${filtroDataAtualizacao != null ? '_gt:  '+'"${filtroDataAtualizacao.toIso8601String()}"' : ''}}}, 
          order_by: {${filtroDataAtualizacao == null ? 'id: asc' : 'data_atualizacao: asc'}}) {
            ${id ? "id" : ""}
            ${idProduto ? "id_produto" : ""}
            ${idVariante ? "id_variante" : ""}
            ${gradePosicao ? "grade_posicao" : ""}
            ${codigoBarras ? "codigo_barras" : ""}
            ${ehDeletado ? "ehdeletado" : ""}
            ${dataCadastro ? "data_cadastro" : ""}
            ${dataAtualizacao ? "data_atualizacao" : ""}
        }
      }
    """;

    var data = await _hasuraBloc.hasuraConnect.query(query);
    produtoCodigoBarrasList = [];

      for(var i = 0; i < data['data']['produto_codigo_barras'].length; i++){
        produtoCodigoBarrasList.add(
          ProdutoCodigoBarras(
            id: data['data']['produto_codigo_barras'][i]['id'],
            idProduto: data['data']['produto_codigo_barras'][i]['id_produto'],
            idVariante: data['data']['produto_codigo_barras'][i]['id_variante'],
            gradePosicao: data['data']['produto_codigo_barras'][i]['grade_variante'],
            codigoBarras: data['data']['produto_codigo_barras'][i]['codigo_barras'],
            ehDeletado: data['data']['produto_codigo_barras'][i]['ehdeletado'],
            dataCadastro: data['data']['produto_codigo_barras'][i]['data_cadastro'] != null ? DateTime.parse(data['data']['produto_codigo_barras'][i]['data_cadastro']) : null,
            dataAtualizacao: data['data']['produto_codigo_barras'][i]['data_atualizacao'] != null ? DateTime.parse(data['data']['produto_codigo_barras'][i]['data_atualizacao']) : null
          )       
        );
      }
      return produtoCodigoBarrasList;
    }
  
  @override
  Future<IEntity> getById(int id) async {
    return await dao.getById(this, id);
  }

  Future<IEntity> getByIdFromServer(int id) async {
    String query = """ 
      {
        categoria(where: {id: {_eq: $id}}) {
          id
          id_pessoa_grupo
          nome
          ehdeletado
          data_cadastro
          data_atualizacao
        }
      }
    """;

    var data = await _hasuraBloc.hasuraConnect.query(query);
    Categoria _categoria = Categoria(
      id: data['data']['categoria'][0]['id'],
      idPessoaGrupo: data['data']['categoria'][0]['id_pessoa_grupo'],
      nome: data['data']['categoria'][0]['nome'],
      ehDeletado: data['data']['categoria'][0]['ehdeletado'],
      dataCadastro: DateTime.parse(data['data']['categoria'][0]['data_cadastro']),
      dataAtualizacao: DateTime.parse(data['data']['categoria'][0]['data_atualizacao'])
    );
    return _categoria;
  }

  Future<DateTime> getUltimaSincronizacao() async {
    List<Map> data = await dao.getRawQuery("select max(data_atualizacao) as data_atualizacao from categoria");
    return data[0]['data_atualizacao'] != null ? DateTime.tryParse(data[0]['data_atualizacao']) : DateTime.parse("2019-01-01T00:00:01.000000");
  }

  @override
  Future<IEntity> insert() async {
    this.produtoCodigoBarras.id = await dao.insert(this);
    return this.produtoCodigoBarras;
  }

  Future<IEntity> saveOnServer() async {
    String _query = """  mutation saveCategoria {
      update_sincronizacao(where: {}, _set: {data_atualizacao: "now()"}) {
        returning {
          data_atualizacao
        }
      }

      insert_categoria(objects: {
    """;      

    if ((produtoCodigoBarras.id != null) && (produtoCodigoBarras.id > 0)) {
      _query = _query + "id: ${produtoCodigoBarras.id},";
    }    

    _query = _query + """
        codigo_barras: "${produtoCodigoBarras.codigoBarras}", 
        ehdeletado: ${produtoCodigoBarras.ehDeletado}, 
        data_cadastro: "${produtoCodigoBarras.dataCadastro}",
        data_atualizacao: "now()"},
        on_conflict: {
          constraint: categoria_pkey, 
          update_columns: [
            nome, 
            ehdeletado,
            data_atualizacao
          ]
        }) {
        returning {
          id
        }
      }
    }  
    """; 

    try {
      var data = await _hasuraBloc.hasuraConnect.mutation(_query);
      produtoCodigoBarras.id = data["data"]["insert_categoria"]["returning"][0]["id"];
      return produtoCodigoBarras;
    } catch (error) {
      return null;
    }  
  }

  @override
  Future<IEntity> delete(int id) async {
    return produtoCodigoBarras;
  }  

  @override
  Map<String, dynamic> toMap() {
    return {
      'id': this.produtoCodigoBarras.id,
      'id_produto': this.produtoCodigoBarras.idProduto,
      'id_variante': this.produtoCodigoBarras.idVariante,
      'grade_posicao': this.produtoCodigoBarras.gradePosicao,
      'codigo_barras': this.produtoCodigoBarras.codigoBarras,
      'ehdeletado': this.produtoCodigoBarras.ehDeletado,
      'data_cadastro': this.produtoCodigoBarras.dataCadastro.toString(),
      'data_atualizacao': this.produtoCodigoBarras.dataAtualizacao.toString(),
    };
  }

  String entityToJson() {
    final dyn = toMap();
    return json.encode(dyn);
  }

  IEntity entityFromJson(String str) {
    final jsonData = json.decode(str);
    return fromMap(jsonData);
  }
}
