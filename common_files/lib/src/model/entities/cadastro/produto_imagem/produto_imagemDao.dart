import 'dart:convert';

import 'package:common_files/common_files.dart';

class ProdutoImagemDAO implements IEntityDAO {
  HasuraBloc _hasuraBloc;
  AppGlobalBloc _appGlobalBloc;
  final String tableName = "produto_imagem";
  int filterProduto;
  String filterText;

  ProdutoImagem produtoImagem;
  List<ProdutoImagem> produtoImagemList;

  @override
  Dao dao;

  ProdutoImagemDAO(this._hasuraBloc, this._appGlobalBloc, {this.produtoImagem, this.produtoImagemList}) {
    dao = Dao();
    if (produtoImagem == null) {
      produtoImagem = ProdutoImagem();
    }
  }

  @override
  IEntity fromMap(Map<String, dynamic> map) {
    try {
      this.produtoImagem.id = map['id'];
      this.produtoImagem.idProduto = map['id_produto'];
      this.produtoImagem.imagem = map['imagem'];
      this.produtoImagem.ehDeletado = map['ehdeletado'];
      this.produtoImagem.dataCadastro = map['data_cadastro'];
      this.produtoImagem.dataAtualizacao = map['data_atualizacao'];
    } catch(error, stacktrace) {
      _appGlobalBloc.logger.e(error.toString(), '<produto_imagemDao> fromMap');
      log(_hasuraBloc, _appGlobalBloc,
        nomeArquivo: "produto_imagemDao",
        nomeFuncao: "fromMap",
        error: error.toString(),
        stacktrace: stacktrace.toString()
      );
    }   
    return this.produtoImagem;
  }

  @override
  Future<List> getAll({bool preLoad = false}) async {
    String where = "";
    try {
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
          ehDeletado: list[i]['ehdeletado'],
          dataCadastro: DateTime.parse(list[i]['data_cadastro']),
          dataAtualizacao: DateTime.parse(list[i]['data_atualizacao']),
        );
      });
    } catch(error, stacktrace) {
      _appGlobalBloc.logger.e(error.toString(), '<produto_imagemDao> getAll');
      log(_hasuraBloc, _appGlobalBloc,
        nomeArquivo: "produto_imagemDao",
        nomeFuncao: "getAll",
        error: error.toString(),
        stacktrace: stacktrace.toString(),
        query: where
      );
    }   
    return produtoImagemList;
  }

  Future<List<ProdutoImagem>> getAllFromServer({bool id=false, bool dataCadastro=false,
    bool dataAtualizacao=false, bool idProduto=false, bool iconeCor=false, bool ehdeletado = false,
    int filtroId=-1}) async {
      String _query;
      try {
        _query = """
          query getAllFromServer {
            produto_imagem( """;
        _query += filtroId != -1 
        ? """where: {id_produto: {_eq: 10}}""" : "";
        _query += """order_by: {id_produto: asc}) {
          ${id ? "id" : ""}
          ${idProduto ? "id_produto" : ""}
          imagem
          ${ehdeletado ? "ehdeletado" : ""}
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
            ehDeletado: data['data']['produto_imagem'][i]['ehdeletado'],
            dataAtualizacao: data['data']['produto_imagem'][i]['data_atualizacao'],
            dataCadastro: data['data']['produto_imagem'][i]['data_cadastro'],
          )
        );
      }
    } catch(error, stacktrace) {
      _appGlobalBloc.logger.e(error.toString(), '<produto_imagemDao> getAllFromServer');
      log(_hasuraBloc, _appGlobalBloc,
        nomeArquivo: "produto_imagemDao",
        nomeFuncao: "getAllFromServer",
        error: error.toString(),
        stacktrace: stacktrace.toString(),
        query: _query
      );
    }   
    return produtoImagemList;
  }

  @override
  Future<IEntity> getById(int id) async {
    try {
      produtoImagem = await dao.getById(this, id);
      return produtoImagem;
    } catch(error, stacktrace) {
      _appGlobalBloc.logger.e(error.toString(), '<produto_imagemDao> getById');
      log(_hasuraBloc, _appGlobalBloc,
        nomeArquivo: "produto_imagemDao",
        nomeFuncao: "getById",
        error: error.toString(),
        stacktrace: stacktrace.toString(),
        query: "id: ${id.toString()}"
      );
      return null;
    }   
  }

  Future<ProdutoImagem> getByIdFromServer(int id) async {
    String _query;
    try {
      _query = """
        query getProdutoImagemById {
          produto_imagem(where: {id: {_eq: $id}}) {
            id
            id_produto
            imagem
            ehdeletado
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
            ehDeletado: data['data']['produto_imagem'][0]['ehdeletado'],
            dataAtualizacao: data['data']['produto_imagem'][0]['data_atualizacao'],
            dataCadastro: data['data']['produto_imagem'][0]['data_cadastro'],
          );
      return produtoImagem;
    } catch(error, stacktrace) {
      _appGlobalBloc.logger.e(error.toString(), '<produto_imagemDao> getByIdFromServer');
      log(_hasuraBloc, _appGlobalBloc,
        nomeArquivo: "produto_imagemDao",
        nomeFuncao: "getByIdFromServer",
        error: error.toString(),
        stacktrace: stacktrace.toString(),
        query: _query
      );
      return null;
    }   
  }

  @override
  Future<IEntity> insert() async {
    try {
      this.produtoImagem.id = await dao.insert(this);
      return this.produtoImagem;
    } catch(error, stacktrace) {
      _appGlobalBloc.logger.e(error.toString(), '<produto_imagemDao> insert');
      log(_hasuraBloc, _appGlobalBloc,
        nomeArquivo: "produto_imagemDao",
        nomeFuncao: "insert",
        error: error.toString(),
        stacktrace: stacktrace.toString(),
        object: produtoImagem.toString()
      );
      return null;
    }   
  }

  Future<ProdutoImagem> saveOnServer() async {
    String _query;
    try {
      _query = """
        mutation saveProdutoImagem {
          insert_produto_imagem(
            objects: { """;

      if ((produtoImagem.id != null) && (produtoImagem.id > 0)) {
        _query = _query + "id: ${produtoImagem.id},";
      }  
      
      _query += """
            id_produto: ${produtoImagem.idProduto}, 
            imagem: "${produtoImagem.imagem}", 
            ehdeletado: ${produtoImagem.ehDeletado}
            data_atualizacao: "now()"}, 
          on_conflict: {
            constraint: produto_imagem_pkey, 
            update_columns: [
              id_produto
              imagem
              ehdeletado
              data_atualizacao
            ]}) {
          returning {
            id
          }
        }
      }
      """;

      var data = await _hasuraBloc.hasuraConnect.mutation(_query);
      produtoImagem.id = data['data']['insert_produto_imagem']["returning"][0]['id'];
      return produtoImagem;
    } catch(error, stacktrace) {
      _appGlobalBloc.logger.e(error.toString(), '<produto_imagemDao> saveOnServer');
      log(_hasuraBloc, _appGlobalBloc,
        nomeArquivo: "produto_imagemDao",
        nomeFuncao: "saveOnServer",
        error: error.toString(),
        stacktrace: stacktrace.toString(),
        object: produtoImagem.toString(),
        query: _query
      );
      return null;
    }   
  }

  @override
  Future<IEntity> delete(int id) async {
    return produtoImagem;
  }  

  @override
  Map<String, dynamic> toMap() {
    try {
      return {
        'id': produtoImagem.id,
        'id_produto': produtoImagem.idProduto,
        'imagem': produtoImagem.imagem,
        'ehdeletado': produtoImagem.ehDeletado,
        'data_cadastro': produtoImagem.dataCadastro,
        'data_atualizacao': produtoImagem.dataAtualizacao,
      };
    } catch(error, stacktrace) {
      _appGlobalBloc.logger.e(error.toString(), '<produto_imagemDao> toMap');
      log(_hasuraBloc, _appGlobalBloc,
        nomeArquivo: "produto_imagemDao",
        nomeFuncao: "toMap",
        error: error.toString(),
        stacktrace: stacktrace.toString(),
      );
      return null;
    }   
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
    try {
      return ProdutoImagem(
        id: this.produtoImagem.id = json['id'],
        idProduto: this.produtoImagem.idProduto = json['id_produto'],
        imagem: this.produtoImagem.imagem = json['imagem'],
        ehDeletado: this.produtoImagem.ehDeletado = json['ehdeletado'],
        dataCadastro: this.produtoImagem.dataCadastro = json['data_cadastro'],
        dataAtualizacao: this.produtoImagem.dataAtualizacao =
            json['data_atualizacao'],
      );
    } catch(error, stacktrace) {
      _appGlobalBloc.logger.e(error.toString(), '<produto_imagemDao> fromJson');
      log(_hasuraBloc, _appGlobalBloc,
        nomeArquivo: "produto_imagemDao",
        nomeFuncao: "fromJson",
        error: error.toString(),
        stacktrace: stacktrace.toString()
      );
      return null;
    }   
  }

  List prepareListToJson() {
    List jsonList = List();
    for (produtoImagem in produtoImagemList) {
      jsonList.add(toMap());
    }
    return jsonList;
  }

  List<IEntity> prepareListFromJson(List<dynamic> map) {
    try {
      List list = map;
      produtoImagemList = List.generate(list.length, (i) {
        return ProdutoImagem(
          id: list[i]['id'],
          idProduto: list[i]['id_produto'],
          imagem: list[i]['imagem'],
          ehDeletado: list[i]['ehdeletado'],
          dataCadastro: list[i]['data_cadastro'],
          dataAtualizacao: list[i]['data_atualizacao'],
        );
      });
    } catch(error, stacktrace) {
      _appGlobalBloc.logger.e(error.toString(), '<produto_imagemDao> prepareListFromJson');
      log(_hasuraBloc, _appGlobalBloc,
        nomeArquivo: "produto_imagemDao",
        nomeFuncao: "prepareListFromJson",
        error: error.toString(),
        stacktrace: stacktrace.toString()
      );
    }   
    return produtoImagemList;
  }
}
