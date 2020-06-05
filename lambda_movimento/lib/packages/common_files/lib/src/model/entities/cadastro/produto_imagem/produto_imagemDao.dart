import 'dart:convert';

import 'package:common_files/common_files.dart';
import 'package:common_files/src/model/dao/dao.dart';
import 'package:common_files/src/model/entities/cadastro/produto_imagem/produto_imagem.dart';
import 'package:common_files/src/model/entities/interfaces.dart';

class ProdutoImagemDAO implements IEntityDAO {
  HasuraBloc _hasuraBloc;
  final String tableName = "produtoImagem";
  int filterProduto;
  String filterText;

  ProdutoImagem produtoImagem;
  List<ProdutoImagem> produtoImagemList;

  @override
  Dao dao;

  ProdutoImagemDAO(this._hasuraBloc, {this.produtoImagem, this.produtoImagemList}) {
    dao = Dao();
    if (produtoImagem == null) {
      produtoImagem = ProdutoImagem();
    }
  }

  @override
  IEntity fromMap(Map<String, dynamic> map) {
    this.produtoImagem.id = map['id'];
    this.produtoImagem.idProduto = map['id_produto'];
    this.produtoImagem.imagem = map['imagem'];
    this.produtoImagem.dataCadastro = map['data_cadastro'];
    this.produtoImagem.dataAtualizacao = map['data_atualizacao'];
    return this.produtoImagem;
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
    produtoImagemList = List.generate(list.length, (i) {
      return ProdutoImagem(
        id: list[i]['id'],
        idProduto: list[i]['id_produto'],
        imagem: list[i]['imagem'],
        dataCadastro: list[i]['data_cadastro'],
        dataAtualizacao: list[i]['data_atualizacao'],
      );
    });
    return produtoImagemList;
  }

  Future<List<ProdutoImagem>> getAllFromServer({bool id=false, bool dataCadastro=false,
    bool dataAtualizacao=false, bool idProduto=false, bool iconeCor=false,
    int filtroId=-1}) async {
      String _query = """
        query getAllFromServer {
          produto_imagem( """;
      _query += filtroId != -1 
      ? """where: {id_produto: {_eq: 10}}""" : "";
      _query += """order_by: {id_produto: asc}) {
        ${id ? "id" : ""}
        ${idProduto ? "id_produto" : ""}
        imagem
        ${dataCadastro ? "data_cadastro" : ""}
        ${dataAtualizacao ? "data_atualizacao" : ""}
      }
    } 
    """;

    var data = await _hasuraBloc.hasuraConnect.query(_query);
    List<ProdutoImagem> produtoImagemList = [];
    for(var i = 0; i < data['data']['produto_imagem'].length; i++){
      produtoImagemList.add(
        ProdutoImagem(
          id: data['data']['produto_imagem'][i]['id'],
          idProduto: data['data']['produto_imagem'][i]['id_produto'],
          imagem: data['data']['produto_imagem'][i]['imagem'],
          dataAtualizacao: data['data']['produto_imagem'][i]['data_atualizacao'],
          dataCadastro: data['data']['produto_imagem'][i]['data_cadastro'],
        )
      );
    }
    return produtoImagemList;
  }

  @override
  Future<IEntity> getById(int id) async {
    produtoImagem = await dao.getById(this, id);
    return produtoImagem;
  }

  Future<ProdutoImagem> getByIdFromServer(int id) async {
    String _query = """
      query getProdutoImagemById {
        produto_imagem(where: {id: {_eq: $id}}) {
          id
          id_produto
          imagem
          data_cadastro
          data_atualizacao
        }
      }
    """;

    var data = await _hasuraBloc.hasuraConnect.query(_query);
      produtoImagem = 
        ProdutoImagem(
          id: data['data']['produto_imagem'][0]['id'],
          idProduto: data['data']['produto_imagem'][0]['id_produto'],
          imagem: data['data']['produto_imagem'][0]['imagem'],
          dataAtualizacao: data['data']['produto_imagem'][0]['data_atualizacao'],
          dataCadastro: data['data']['produto_imagem'][0]['data_cadastro'],
        );
    return produtoImagem;
  }

  @override
  Future<IEntity> insert() async {
    this.produtoImagem.id = await dao.insert(this);
    return this.produtoImagem;
  }

  Future<ProdutoImagem> saveOnServer() async {
    String _query = """
      mutation saveProdutoImagem {
        insert_produto_imagem(
          objects: { """;

    if ((produtoImagem.id != null) && (produtoImagem.id > 0)) {
      _query = _query + "id: ${produtoImagem.id},";
    }  
    
    _query += """
          id_produto: ${produtoImagem.idProduto}, 
          imagem: "${produtoImagem.imagem}", 
          data_cadastro: "${produtoImagem.dataCadastro}", 
          data_atualizacao: "${produtoImagem.dataAtualizacao}"}, 
        on_conflict: {
          constraint: produto_imagem_pkey, 
          update_columns: [
            id_produto
            imagem
            data_cadastro
            data_atualizacao
          ]}) {
        returning {
          id
        }
      }
    }
    """;

    try {
      var data = await _hasuraBloc.hasuraConnect.mutation(_query);
      produtoImagem.id = data['data']['insert_produto_imagem'][0]['id'];
      return produtoImagem;
    } catch (e) {
      return null;
    }
  }


  @override
  Map<String, dynamic> toMap() {
    return {
      'id': produtoImagem.id,
      'id_produto': produtoImagem.idProduto,
      'imagem': produtoImagem.imagem,
      'data_cadastro': produtoImagem.dataCadastro,
      'data_atualizacao': produtoImagem.dataAtualizacao,
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
    return ProdutoImagem(
      id: this.produtoImagem.id = json['id'],
      idProduto: this.produtoImagem.idProduto = json['id_produto'],
      imagem: this.produtoImagem.imagem = json['imagem'],
      dataCadastro: this.produtoImagem.dataCadastro = json['data_cadastro'],
      dataAtualizacao: this.produtoImagem.dataAtualizacao =
          json['data_atualizacao'],
    );
  }

  List prepareListToJson() {
    List jsonList = List();
    for (produtoImagem in produtoImagemList) {
      jsonList.add(toMap());
    }
    return jsonList;
  }

  List<IEntity> prepareListFromJson(List<dynamic> map) {
    List list = map;
    produtoImagemList = List.generate(list.length, (i) {
      return ProdutoImagem(
        id: list[i]['id'],
        idProduto: list[i]['id_produto'],
        imagem: list[i]['imagem'],
        dataCadastro: list[i]['data_cadastro'],
        dataAtualizacao: list[i]['data_atualizacao'],
      );
    });
    return produtoImagemList;
  }
}
