import 'dart:convert';

import 'package:common_files/src/bloc/hasura_bloc.dart';
import 'package:common_files/src/model/dao/dao.dart';
import 'package:common_files/src/model/entities/cadastro/produto/produto_variante.dart';
import 'package:common_files/src/model/entities/cadastro/variante/variante.dart';
import 'package:common_files/src/model/entities/cadastro/variante/varianteDao.dart';
import 'package:common_files/src/model/entities/interfaces.dart';

class ProdutoVarianteDAO implements IEntityDAO {
  HasuraBloc _hasuraBloc;
  final String tableName = "produto_variante";
  int filterProduto;
  String filterText;

  Variante _variante;
  ProdutoVariante produtoVariante;
  List<ProdutoVariante> produtoVarianteList = [];

  @override
  Dao dao;

  ProdutoVarianteDAO(this._hasuraBloc, {this.produtoVariante, this.produtoVarianteList}) {
    dao = Dao();
    produtoVariante = produtoVariante == null ? ProdutoVariante() : produtoVariante;
    produtoVarianteList = produtoVarianteList == null ? [] : produtoVarianteList;    
    _variante = Variante();
  }

  @override
  IEntity fromMap(Map<String, dynamic> map) {
    this.produtoVariante.id = map['id'];
    this.produtoVariante.idProduto = map['id_produto'];
    this.produtoVariante.idVariante = map['id_variante'];
    this.produtoVariante.dataCadastro = map['data_cadastro'];
    this.produtoVariante.dataAtualizacao = map['data_atualizacao'];
    return this.produtoVariante;
  }

  @override
  Future<List> getAll({bool preLoad = false}) async {
    String where = "";
    List<dynamic> args = [];
    if (filterProduto > 0) {
      where = where + "(id_produto = ?)";
      args.add(filterProduto);
    }

    List list = await dao.getList(this, where, args);
    produtoVarianteList = List.generate(list.length, (i) {
      return ProdutoVariante(
        id: list[i]['id'],
        idProduto: list[i]['id_produto'],
        idVariante: list[i]['id_variante'],
        dataCadastro: list[i]['data_cadastro'],
        dataAtualizacao: list[i]['data_atualizacao'],
      );
    });

    if (preLoad) {
      for (var produtoVariante in produtoVarianteList) {
        Variante _vari = Variante();
        VarianteDAO varianteDAO = VarianteDAO(_hasuraBloc, variante: _vari);
        produtoVariante.variante =
            await varianteDAO.getById(produtoVariante.idVariante);
        varianteDAO = null;
      }
    }
    return produtoVarianteList;
  }

  Future<List<ProdutoVariante>> getAllFromServer({bool id=false, bool idProduto=false, bool ehDeletado=false, 
                                                  bool idVariante=false, bool dataCadastro=false, 
                                                  bool dataAtualizacao=false, bool variante=false}) async {
    String query = """ 
    {
      produto_variante{
        ${id ? "id" : ""}
        ${idProduto ? "id_produto" : ""}
        ${idVariante ? "id_variante" : ""}
        ${ehDeletado ? "ehdeletado" : ""}
        ${dataCadastro ? "data_cadastro" : ""}
        ${dataAtualizacao ? "data_atualizacao" : ""}
      """;

        query += variante ? """ 
          variante {
            id
            nome
            nome_avatar
            possui_imagem
            iconecor
            ehdeletado
            data_cadastro
            data_atualizacao
          }""" : ""; 

        query += """
      }
    }""";

    var data = await _hasuraBloc.hasuraConnect.query(query);
    Variante _variante;
    
    for(var i=0; i< data.length; i++){
      if(data['data']['produto_variante'][i]['variante'] != null){
         _variante = Variante.fromJson(data['data']['produto_variante'][i]['variante']);
      }
      produtoVarianteList.add(
        ProdutoVariante(
          id: data['data']['produto_variante'][i]['id'],
          idProduto: data['data']['produto_variante'][i]['id_produto'],
          idVariante: data['data']['produto_variante'][i]['id_variante'],
          ehDeletado: data['data']['produto_variante'][i]['ehdeletado'],
          variante: _variante,
          dataCadastro: DateTime.parse(data['data']['produto_variante'][i]['data_cadastro']),
          dataAtualizacao: DateTime.parse(data['data']['produto_variante'][i]['data_atualizacao'])
        )
      );
    }
    return produtoVarianteList;
  }

  @override
  Future<IEntity> getById(int id) async {
    produtoVariante = await dao.getById(this, id);
    return produtoVariante;
  }

  @override
  Future<IEntity> insert() async {
    this.produtoVariante.id = await dao.insert(this);
    return this.produtoVariante;
  }

  Future<ProdutoVariante> saveOnServer() async {
    String _query = """
    mutation saveProduto {
      insert_produto_variante(
        objects: {""";

    if ((produtoVariante.id != null) && (produtoVariante.id > 0)) {
      _query = _query + "id: ${produtoVariante.id},";
    }
    _query += """
          id_produto: ${produtoVariante.idProduto}, 
          id_variante: ${produtoVariante.idVariante}, 
          ehdeletado: ${produtoVariante.ehDeletado},
          data_cadastro: "${produtoVariante.dataCadastro}", 
          data_atualizacao: "${produtoVariante.dataAtualizacao}", 
        }, 
        on_conflict: {
          constraint: produto_variante_pkey, 
          update_columns: [
            id_produto,
            id_variante,
            ehdeletado,
            data_atualizacao,
          ]
        }) {
        returning {
          id
        }
      }
    } """;

    try {
      var data = await _hasuraBloc.hasuraConnect.mutation(_query);
      produtoVariante.id = data["data"]["insert_produto_variante"]["returning"][0]["id"];
      return produtoVariante;
    } catch (error) {
      return null;
    }  
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'id': produtoVariante.id,
      'id_produto': produtoVariante.idProduto,
      'id_variante': produtoVariante.idVariante,
      'data_cadastro': produtoVariante.dataCadastro,
      'data_atualizacao': produtoVariante.dataAtualizacao,
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

  IEntity fromJson(Map<String, dynamic> json) {
    /*return ProdutoImagem(
      id: this.produto_imagem.id = json['id'],
      idProduto: this.produto_imagem.idProduto = json['id_produto'],
      imagem: this.produto_imagem.imagem = json['imagem'],
      dataCadastro: this.produto_imagem.dataCadastro = json['data_cadastro'],
      dataAtualizacao: this.produto_imagem.dataAtualizacao = json['data_atualizacao'],
    );*/
  }

  List<IEntity> prepareListFromJson(List<dynamic> map) {
    /*List list = map;
    produto_imagemList = List.generate(list.length, (i) {
      return ProdutoImagem(
               id: list[i]['id'],
               idProduto: list[i]['id_produto'],
               imagem: list[i]['imagem'],
               dataCadastro: list[i]['data_cadastro'],
               dataAtualizacao :list[i]['data_atualizacao'],
      );
    });
    return produto_imagemList;
    */
  }
}
