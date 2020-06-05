import 'dart:convert';

import 'package:common_files/src/bloc/hasura_bloc.dart';
import 'package:common_files/src/model/dao/dao.dart';
import 'package:common_files/src/model/entities/cadastro/produto/produto.dart';
import 'package:common_files/src/model/entities/interfaces.dart';
import 'package:common_files/src/model/entities/operacao/estoque/estoque.dart';

class EstoqueDAO extends IEntityDAO {
  HasuraBloc _hasuraBloc;
  String get tableName => 'estoque';
  Estoque estoque;
  EstoqueDAO estoqueDao;

  @override
  Dao dao;

  EstoqueDAO({this.estoque}) {
    dao = Dao();
  }

  @override
  Future<IEntity> insert() async {
    this.estoque.id = await dao.insert(this);
    return this.estoque;
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'id': this.estoque.id,
      'id_produto': this.estoque.idProduto,
      'estoque_total': this.estoque.estoqueTotal
    };
  }

  // @override
  // Future<IEntity> getById(int id) async {
  //   return await dao.getById(this, id);
  // }

  @override
  IEntity fromMap(Map<String, dynamic> map) {
    this.estoque.id = map['id'];
    this.estoque.idProduto = map['id_produto'];
    this.estoque.estoqueTotal = map['estoque_total'].toDouble();
    return this.estoque;
  }

  IEntity _fromJson(Map<String, dynamic> json) {
    return Estoque(
      id: json['id'],
      idProduto: json['id_produto'],
      estoqueTotal: json['estoque_total'],
    );
  }

  consultaEstoque({int idProduto}) async {
    String query = """ {
        estoque_aggregate(where: {id_produto: {_eq: $idProduto}}) {
          aggregate {
            sum {
              estoque_total
            }
          }
        }
      } """;

    var response = await _hasuraBloc.hasuraConnect.query(query);
    var filteredResponse = jsonEncode(response['data']['estoque_aggregate']
        ['aggregate']['sum']['estoque_total']);
    var x = filteredResponse.indexOf(".");
    filteredResponse = x != -1 ? filteredResponse.substring(0,x) : filteredResponse;
    return int.parse(filteredResponse);
  }

  Future<List<String>> consultaEstoqueGrade({Produto produto}) async {
    String query = """ {
        estoque_aggregate(where: {id_produto: {_eq: ${produto.id}}}) {
          aggregate {
            sum {
              id_produto
              estoque_total
              et1
              et2
              et3
              et4
              et5
              et6
              et7
              et8
              et9
              et10
              et11
              et12
              et13
              et14
              et15
            }
          }
        }
      }
    """;

    var data = await _hasuraBloc.hasuraConnect.query(query);
    List<String> estoqueGradeList = [];
    if ((produto.grade.t1 != null) && (produto.grade.t1 != "")) {
      estoqueGradeList.add(data['data']['estoque_aggregate']['aggregate']['sum']['et1'].toString());
    }  
    if ((produto.grade.t2 != null) && (produto.grade.t2 != "")) {
      estoqueGradeList.add(data['data']['estoque_aggregate']['aggregate']['sum']['et2'].toString());
    }  
    if ((produto.grade.t3 != null) && (produto.grade.t3 != "")) {
      estoqueGradeList.add(data['data']['estoque_aggregate']['aggregate']['sum']['et3'].toString());
    }  
    if ((produto.grade.t4 != null) && (produto.grade.t4 != "")) {
      estoqueGradeList.add(data['data']['estoque_aggregate']['aggregate']['sum']['et4'].toString());
    }  
    if ((produto.grade.t5 != null) && (produto.grade.t5 != "")) {
      estoqueGradeList.add(data['data']['estoque_aggregate']['aggregate']['sum']['et5'].toString());
    }  
    if ((produto.grade.t6 != null) && (produto.grade.t6 != "")) {
      estoqueGradeList.add(data['data']['estoque_aggregate']['aggregate']['sum']['et6'].toString());
    }  
    if ((produto.grade.t7 != null) && (produto.grade.t7 != "")) {
      estoqueGradeList.add(data['data']['estoque_aggregate']['aggregate']['sum']['et7'].toString());
    }  
    if ((produto.grade.t8 != null) && (produto.grade.t8 != "")) {
      estoqueGradeList.add(data['data']['estoque_aggregate']['aggregate']['sum']['et8'].toString());
    }  
    if ((produto.grade.t9 != null) && (produto.grade.t9 != "")) {
      estoqueGradeList.add(data['data']['estoque_aggregate']['aggregate']['sum']['et9'].toString());
    }  
    if ((produto.grade.t10 != null) && (produto.grade.t10 != "")) {
      estoqueGradeList.add(data['data']['estoque_aggregate']['aggregate']['sum']['et10'].toString());
    }  
    if ((produto.grade.t11 != null) && (produto.grade.t11 != "")) {
      estoqueGradeList.add(data['data']['estoque_aggregate']['aggregate']['sum']['et11'].toString());
    }  
    if ((produto.grade.t12 != null) && (produto.grade.t12 != "")) {
      estoqueGradeList.add(data['data']['estoque_aggregate']['aggregate']['sum']['et12'].toString());
    }  
    if ((produto.grade.t13 != null) && (produto.grade.t13 != "")) {
      estoqueGradeList.add(data['data']['estoque_aggregate']['aggregate']['sum']['et13'].toString());
    }  
    if ((produto.grade.t14 != null) && (produto.grade.t14 != "")) {
      estoqueGradeList.add(data['data']['estoque_aggregate']['aggregate']['sum']['et14'].toString());
    }  
    if ((produto.grade.t15 != null) && (produto.grade.t15 != "")) {
      estoqueGradeList.add(data['data']['estoque_aggregate']['aggregate']['sum']['et15'].toString());
    }  
    return estoqueGradeList;
  }

  Future<List<int>> consultaVariante({tamanho, Produto produto, bool loadGrade}) async {
    String query = """ 
      {
      estoque(where: {id_produto: {_eq: ${produto.id}}}, order_by: {id_variante: asc}) {
        ${loadGrade ? '' : "et"+tamanho.toString()}
        id_variante
        estoque_total
      }
    }
    """;

    var data = await _hasuraBloc.hasuraConnect.query(query);
    List<int> estoqueVarianteList = [];

    if(loadGrade){
      for(var i = 0; i < data['data']['estoque'].length; i++){
        estoqueVarianteList.add(data['data']['estoque'][i]['estoque_total']);  
      }
      return estoqueVarianteList;
    }

    if(data['data']['estoque'][0]['id_variante'] != null){
      for(var i=0; i < data['data']['estoque'].length; i++){
        estoqueVarianteList.add(data['data']['estoque'][i]['et$tamanho']);
      }
    }

    return estoqueVarianteList;
  }
}
