import 'dart:convert';

import 'package:common_files/common_files.dart';

class CategoriaDAO implements IEntityDAO {
  HasuraBloc _hasuraBloc;
  final String tableName = "categoria";
  int filterId = 0;
  String filterText = "";

  Categoria categoria;
  List<Categoria> categoriaList;

  @override
  Dao dao;

  CategoriaDAO(this._hasuraBloc, {this.categoria}) {
    dao = Dao();
    //dao.createDb();
  }

  @override
  IEntity fromMap(Map<String, dynamic> map) {
    this.categoria.id = map['id'];
    this.categoria.idPessoaGrupo = map['id_pessoa_grupo'];
    this.categoria.nome = map['nome'];
    this.categoria.ehDeletado = map['ehdeletado'];
    this.categoria.dataCadastro = DateTime.parse(map['data_cadastro']);
    this.categoria.dataAtualizacao = DateTime.parse(map['data_atualizacao']);
    return this.categoria;
  }

  @override
  Future<List> getAll({bool preLoad = false}) async {
    String where = "";
    List<dynamic> args = [];

    if (filterText != "") {
      where = "1 = 1 ";
      where = where + "and (nome like '%" + filterText + "%')";
    }

    List list = await dao.getList(this, where, args);
    categoriaList = List.generate(list.length, (i) {
      return Categoria(
               id: list[i]['id'],
               idPessoaGrupo: list[i]['id_pessoa_grupo'],
               nome: list[i]['nome'],
               ehDeletado: list[i]['ehdeletado'],
               dataCadastro: DateTime.parse(list[i]['data_cadastro']),
               dataAtualizacao: DateTime.parse(list[i]['data_atualizacao']),
      );
    });
    return categoriaList;
  }

  Future<List> getAllFromServer({bool preLoad=false, bool id=false, bool idPessoaGrupo=false,
    bool ehDeletado=false, bool dataCadastro=false, bool dataAtualizacao=false, String filtroNome=""}) async {
    String query = """ 
      {
        categoria(where: {
          nome: {${filtroNome != "" ? '_ilike:  '+'"$filtroNome%"' : ''}}}, 
          order_by: {nome: asc}) {
            ${id ? "id" : ""}
            ${idPessoaGrupo ? "id_pessoa_grupo" : ""}
            nome
            ${ehDeletado ? "ehdeletado" : ""}
            ${dataCadastro ? "data_cadastro" : ""}
            ${dataAtualizacao ? "data_atualizacao" : ""}
        }
      }
    """;

    var data = await _hasuraBloc.hasuraConnect.query(query);
    categoriaList = [];

      for(var i = 0; i < data['data']['categoria'].length; i++){
        categoriaList.add(
          Categoria(
            id: data['data']['categoria'][i]['id'],
            idPessoaGrupo: data['data']['categoria'][i]['id_pessoa_grupo'],
            nome: data['data']['categoria'][i]['nome'],
            ehDeletado: data['data']['categoria'][i]['ehdeletado'],
            dataCadastro: data['data']['categoria'][i]['data_cadastro'],
            dataAtualizacao: data['data']['categoria'][i]['data_atualizacao']
          )       
        );
      }
      return categoriaList;
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


  @override
  Future<IEntity> insert() async {
    this.categoria.id = await dao.insert(this);
    return this.categoria;
  }

  Future<IEntity> saveOnServer() async {
    String _query = """ mutation saveCategoria {
        insert_categoria(objects: {""";

    if ((categoria.id != null) && (categoria.id > 0)) {
      _query = _query + "id: ${categoria.id},";
    }    

    _query = _query + """
        nome: "${categoria.nome}", 
        ehdeletado: ${categoria.ehDeletado}, 
        data_cadastro: "${categoria.dataCadastro}",
        data_atualizacao: "${categoria.dataAtualizacao}"},
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
      categoria.id = data["data"]["insert_categoria"]["returning"][0]["id"];
      return categoria;
    } catch (error) {
      return null;
    }  
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'id': this.categoria.id,
      'id_pessoa_grupo': this.categoria.idPessoaGrupo,
      'nome': this.categoria.nome,
      'ehdeletado': this.categoria.ehDeletado,
      'data_cadastro': this.categoria.dataCadastro.toString(),
      'data_atualizacao': this.categoria.dataAtualizacao.toString(),
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
