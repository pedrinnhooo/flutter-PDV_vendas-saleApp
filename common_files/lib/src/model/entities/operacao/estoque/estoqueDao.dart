import 'package:common_files/common_files.dart';

class EstoqueDAO extends IEntityDAO {
  HasuraBloc _hasuraBloc;
  AppGlobalBloc _appGlobalBloc;
  String get tableName => 'estoque';
  Estoque estoque;
  EstoqueDAO estoqueDao;
  List<Estoque> estoqueList = [];
  List<EstoqueHistorico> estoqueHistoricoList;

  @override
  Dao dao;

  EstoqueDAO(this._hasuraBloc, this._appGlobalBloc, {this.estoque}) {
    dao = Dao();
  }

  @override
  IEntity fromMap(Map<String, dynamic> map) {
    this.estoque.id = map['id'];
    this.estoque.idProduto = map['id_produto'];
    this.estoque.estoqueTotal = map['estoque_total'].toDouble();
    return this.estoque;
  }

  @override
  Future<IEntity> getById(int id) async {
    return await dao.getById(this, id);
  }

  @override
  Future<IEntity> insert() async {
    try {
      this.estoque.id = await dao.insert(this);
    } catch(error, stacktrace) {
      _appGlobalBloc.logger.e(error.toString(), '<estoqueDao> insert');
      log(_hasuraBloc, _appGlobalBloc,
        nomeArquivo: "estoqueDao",
        nomeFuncao: "insert",
        error: error.toString(),
        stacktrace: stacktrace.toString(),
        object: estoque.toString()
      );
    }
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



  IEntity _fromJson(Map<String, dynamic> json) {
    return Estoque(
      id: json['id'],
      idProduto: json['id_produto'],
      estoqueTotal: json['estoque_total'],
    );
  }

  Future<List<Estoque>> getAllFromServer({int idProduto=0}) async {
    String query = """ {
      estoque(where: {
        id_produto: {${idProduto > 0 ? '_eq: '+"${idProduto.toString()}" : ''}}}, 
        order_by: {id_variante: asc}) {
        id
        id_pessoa
        id_pessoa_grupo
        id_produto
        id_variante
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
        data_cadastro
        data_atualizacao
      }  
    } """;

    print(query);

    var data = await _hasuraBloc.hasuraConnect.query(query);
    estoqueList = [];
    for(var i = 0; i < data['data']['estoque'].length; i++){
      estoqueList.add(
        Estoque(
          id: data['data']['estoque'][i]['id'] ,
          idPessoa: data['data']['estoque'][i]['id'],
          idPessoaGrupo: data['data']['estoque'][i]['id_pessoa_grupo'],
          idProduto: data['data']['estoque'][i]['id_produto'],
          idVariante: data['data']['estoque'][i]['id_variante'],
          estoqueTotal: data['data']['estoque'][i]['estoque_total'] != null ? data['data']['estoque'][i]['estoque_total'].toDouble() : 0,
          et1:  data['data']['estoque'][i]['et1'] != null ? data['data']['estoque'][i]['et1'].toDouble() : 0,
          et2:  data['data']['estoque'][i]['et2'] != null ? data['data']['estoque'][i]['et2'].toDouble() : 0,
          et3:  data['data']['estoque'][i]['et3'] != null ? data['data']['estoque'][i]['et3'].toDouble() : 0,
          et4:  data['data']['estoque'][i]['et4'] != null ? data['data']['estoque'][i]['et4'].toDouble() : 0,
          et5:  data['data']['estoque'][i]['et5'] != null ? data['data']['estoque'][i]['et5'].toDouble() : 0,
          et6:  data['data']['estoque'][i]['et6'] != null ? data['data']['estoque'][i]['et6'].toDouble() : 0,
          et7:  data['data']['estoque'][i]['et7'] != null ? data['data']['estoque'][i]['et7'].toDouble() : 0,
          et8:  data['data']['estoque'][i]['et8'] != null ? data['data']['estoque'][i]['et8'].toDouble() : 0,
          et9:  data['data']['estoque'][i]['et9'] != null ? data['data']['estoque'][i]['et9'].toDouble() : 0,
          et10: data['data']['estoque'][i]['et10'] != null ? data['data']['estoque'][i]['et10'].toDouble() : 0,
          et11: data['data']['estoque'][i]['et11'] != null ? data['data']['estoque'][i]['et11'].toDouble() : 0,
          et12: data['data']['estoque'][i]['et12'] != null ? data['data']['estoque'][i]['et12'].toDouble() : 0,
          et13: data['data']['estoque'][i]['et13'] != null ? data['data']['estoque'][i]['et13'].toDouble() : 0,
          et14: data['data']['estoque'][i]['et14'] != null ? data['data']['estoque'][i]['et14'].toDouble() : 0,
          et15: data['data']['estoque'][i]['et15'] != null ? data['data']['estoque'][i]['et15'].toDouble() : 0,
          dataCadastro: data['data']['estoque'][i]['data_cadastro'] != null ? DateTime.parse(data['data']['estoque'][i]['data_cadastro']) : null,
          dataAtualizacao: data['data']['estoque'][i]['data_atualizacao'] != null ? DateTime.parse(data['data']['estoque'][i]['data_atualizacao']) : null
        )       
      );
    }
    return estoqueList;
  }
  
  Future<int> consultaEstoqueTotal({int idProduto}) async {
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
    return response['data']['estoque_aggregate']['aggregate']['sum']['estoque_total'] != null ? 
      response['data']['estoque_aggregate']['aggregate']['sum']['estoque_total'].toInt() :
      0;
  }

  Future<List<String>> consultaEstoqueGrade({Produto produto, int idVariante=0}) async {
    String query = """ {
        estoque_aggregate(where: {
          id_produto: {_eq: ${produto.id}},
          id_variante: {${idVariante > 0 ? '_eq: '+"${idVariante.toString()}" : ''}}}) {
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
      estoqueGradeList.add(data['data']['estoque_aggregate']['aggregate']['sum']['et1'] != null ? data['data']['estoque_aggregate']['aggregate']['sum']['et1'].toInt().toString() : "0");
    }  
    if ((produto.grade.t2 != null) && (produto.grade.t2 != "")) {
      estoqueGradeList.add(data['data']['estoque_aggregate']['aggregate']['sum']['et2'] != null ? data['data']['estoque_aggregate']['aggregate']['sum']['et2'].toInt().toString() : "0");
    }  
    if ((produto.grade.t3 != null) && (produto.grade.t3 != "")) {
      estoqueGradeList.add(data['data']['estoque_aggregate']['aggregate']['sum']['et3'] != null ? data['data']['estoque_aggregate']['aggregate']['sum']['et3'].toInt().toString() : "0");
    }  
    if ((produto.grade.t4 != null) && (produto.grade.t4 != "")) {
      estoqueGradeList.add(data['data']['estoque_aggregate']['aggregate']['sum']['et4'] != null ? data['data']['estoque_aggregate']['aggregate']['sum']['et4'].toInt().toString() : "0");
    }  
    if ((produto.grade.t5 != null) && (produto.grade.t5 != "")) {
      estoqueGradeList.add(data['data']['estoque_aggregate']['aggregate']['sum']['et5'] != null ? data['data']['estoque_aggregate']['aggregate']['sum']['et5'].toInt().toString() : "0");
    }  
    if ((produto.grade.t6 != null) && (produto.grade.t6 != "")) {
      estoqueGradeList.add(data['data']['estoque_aggregate']['aggregate']['sum']['et6'] != null ? data['data']['estoque_aggregate']['aggregate']['sum']['et6'].toInt().toString() : "0");
    }  
    if ((produto.grade.t7 != null) && (produto.grade.t7 != "")) {
      estoqueGradeList.add(data['data']['estoque_aggregate']['aggregate']['sum']['et7'] != null ? data['data']['estoque_aggregate']['aggregate']['sum']['et7'].toInt().toString() : "0");
    }  
    if ((produto.grade.t8 != null) && (produto.grade.t8 != "")) {
      estoqueGradeList.add(data['data']['estoque_aggregate']['aggregate']['sum']['et8'] != null ? data['data']['estoque_aggregate']['aggregate']['sum']['et8'].toInt().toString() : "0");
    }  
    if ((produto.grade.t9 != null) && (produto.grade.t9 != "")) {
      estoqueGradeList.add(data['data']['estoque_aggregate']['aggregate']['sum']['et9'] != null ? data['data']['estoque_aggregate']['aggregate']['sum']['et9'].toInt().toString() : "0");
    }  
    if ((produto.grade.t10 != null) && (produto.grade.t10 != "")) {
      estoqueGradeList.add(data['data']['estoque_aggregate']['aggregate']['sum']['et10'] != null ? data['data']['estoque_aggregate']['aggregate']['sum']['et10'].toInt().toString() : "0");
    }  
    if ((produto.grade.t11 != null) && (produto.grade.t11 != "")) {
      estoqueGradeList.add(data['data']['estoque_aggregate']['aggregate']['sum']['et11'] != null ? data['data']['estoque_aggregate']['aggregate']['sum']['et11'].toInt().toString() : "0");
    }  
    if ((produto.grade.t12 != null) && (produto.grade.t12 != "")) {
      estoqueGradeList.add(data['data']['estoque_aggregate']['aggregate']['sum']['et12'] != null ? data['data']['estoque_aggregate']['aggregate']['sum']['et12'].toInt().toString() : "0");
    }  
    if ((produto.grade.t13 != null) && (produto.grade.t13 != "")) {
      estoqueGradeList.add(data['data']['estoque_aggregate']['aggregate']['sum']['et13'] != null ? data['data']['estoque_aggregate']['aggregate']['sum']['et13'].toInt().toString() : "0");
    }  
    if ((produto.grade.t14 != null) && (produto.grade.t14 != "")) {
      estoqueGradeList.add(data['data']['estoque_aggregate']['aggregate']['sum']['et14'] != null ? data['data']['estoque_aggregate']['aggregate']['sum']['et14'].toInt().toString() : "0");
    }  
    if ((produto.grade.t15 != null) && (produto.grade.t15 != "")) {
      estoqueGradeList.add(data['data']['estoque_aggregate']['aggregate']['sum']['et15'] != null ? data['data']['estoque_aggregate']['aggregate']['sum']['et15'].toInt().toString() : "0");
    }  
    return estoqueGradeList;
  }

  Future<Map<int,int>> consultaVariante({tamanho, Produto produto, bool loadGrade}) async {
    String query = """ 
      {
      estoque(where: {id_produto: {_eq: ${produto.id}}}, order_by: {id_variante: asc}) {
        ${loadGrade ? "et"+tamanho.toString() : ''}
        id_variante
        estoque_total
      }
    }
    """;

    var data = await _hasuraBloc.hasuraConnect.query(query);
    Map<int,int> temp = Map();
    Map<int,int> estoqueVarianteList = Map();

    if(loadGrade){
      for(var i = 0; i < data['data']['estoque'].length; i++){
        // map[0] = data['data']['estoque'][i]['id_variante'];
        // map[1] = data['data']['estoque'][i]['estoque_total'];
        temp = {data['data']['estoque'][i]['id_variante']: data['data']['estoque'][i]['estoque_total'].toInt()};
        estoqueVarianteList.addAll(temp);  
      }
      return estoqueVarianteList;
    }

    if(data['data']['estoque'][0]['id_variante'] != null){
      for(var i=0; i < data['data']['estoque'].length; i++){
        temp = {data['data']['estoque'][i]['id_variante']: data['data']['estoque'][i]['estoque_total'].toInt()};
        estoqueVarianteList.addAll(temp);
      }
    }
    return estoqueVarianteList;
  }
  
  Future<List<EstoqueHistorico>> getEstoqueHistoricoFromServer({Produto produto}) async {
    String query = """ {
      estoque_historico(
        where: {
          id_produto: {_eq: ${produto.id}}
        }, 
        order_by: {id: asc}
      ) {
        id_movimento
        id_produto
        id_variante
        grade_posicao
        descricao
        estoque_novo
        quantidade
        data_movimento
        variante {
          nome
        }
      }      
    } """;


      // movimento_estoque(where: {
      //   ehatualizado: {_eq: 1}, 
      //   movimento_estoque_items: {
      //     id_produto: {_eq: ${produto.id}}
      //   }
      // }) {
      //   movimento_estoque_items(where: {
      //     id_produto: {_eq: ${produto.id}}
      //   }) {
      //     tipo_atualizacao_estoque
      //     id_produto
      //     id_variante
      //     grade_posicao
      //     quantidade
      //     variante {
      //       nome
      //     }
      //   }
      //   data_movimento
      // }
      // movimento(where: {
      //   ehcancelado: {_eq: 0}, 
      //   ehorcamento: {_eq: 0}, 
      //   ehfinalizado: {_eq: 1}, 
      //   movimento_items: {
      //     id_produto: {_eq: ${produto.id}}
      //   }
      // }) {
      //   movimento_items(where: {
      //     id_produto: {_eq: ${produto.id}}
      //   }) {
      //     id_movimento
      //     id_produto
      //     id_variante
      //     grade_posicao
      //     quantidade
      //     variante {
      //       nome
      //     }
      //   }
      //   data_movimento
      // }

    var data = await _hasuraBloc.hasuraConnect.query(query);
    estoqueHistoricoList = [];
    for(var i = 0; i < data['data']['estoque_historico'].length; i++){
      estoqueHistoricoList.add(
        EstoqueHistorico(
          idProduto: data['data']['estoque_historico'][i]['id_produto'],
          dataMovimento: DateTime.parse(data['data']['estoque_historico'][i]['data_movimento']),
          idVariante: data['data']['estoque_historico'][i]['id_variante'],
          gradePosicao: data['data']['estoque_historico'][i]['grade_posicao'] != null ? data['data']['estoque_historico'][i]['grade_posicao'] : null,
          quantidade: data['data']['estoque_historico'][i]['quantidade'].toDouble(),
          estoqueNovo: data['data']['estoque_historico'][i]['estoque_novo'].toDouble(),
          descricao: data['data']['estoque_historico'][i]['descricao'],
          variante: data['data']['estoque_historico'][i]['variante'] != null ? Variante.fromJson(data['data']['estoque_historico'][i]['variante']) : null,
          gradeDescricao: await getGradeDescricao(produto, data['data']['estoque_historico'][i]['grade_posicao'] != null ? data['data']['estoque_historico'][i]['grade_posicao'] : 0)
          //produto: Produto.fromJson(data['data']['movimento_estoque'][i]['produto'])  
        )       
      );
    }

    // for(var i = 0; i < data['data']['movimento'].length; i++){
    //   for(var y = 0; y < data['data']['movimento'][i]["movimento_items"].length; y++){
    //     estoqueHistoricoList.add(
    //       EstoqueHistorico(
    //         dataMovimento: DateTime.parse(data['data']['movimento'][i]['data_movimento']),
    //         idMovimento: data['data']['movimento'][i]["movimento_items"][y]['id_movimento'],
    //         idProduto: data['data']['movimento'][i]["movimento_items"][y]['id_produto'],
    //         idVariante: data['data']['movimento'][i]["movimento_items"][y]['id_variante'],
    //         gradePosicao: data['data']['movimento'][i]["movimento_items"][y]['grade_posicao'] != null ? data['data']['movimento'][i]["movimento_items"][y]['grade_posicao'] : null,
    //         quantidade: data['data']['movimento'][i]["movimento_items"][y]['quantidade'].toDouble(),
    //         descricao: data['data']['movimento'][i]["movimento_items"][y]['quantidade'] < 0 ? "Devolução" : "Venda",
    //         variante: data['data']['movimento'][i]["movimento_items"][y]['variante'] != null ? Variante.fromJson(data['data']['movimento'][i]["movimento_items"][y]['variante']) : null,
    //         gradeDescricao: await getGradeDescricao(produto, data['data']['movimento'][i]["movimento_items"][y]['grade_posicao'] != null ? data['data']['movimento'][i]["movimento_items"][y]['grade_posicao'] : 0)
    //         //produto: Produto.fromJson(data['data']['movimento_estoque'][i]['produto'])  
    //       )       
    //     );
    //   }  
    // }
    return estoqueHistoricoList;
  }

  Future<String>getGradeDescricao(Produto produto, int gradePosicao) async {
    String _gradeDescricao;
    switch (gradePosicao) {
      case 1: _gradeDescricao = produto.grade.t1;
        break;
      case 2: _gradeDescricao = produto.grade.t2;
        break;
      case 3: _gradeDescricao = produto.grade.t3;
        break;
      case 4: _gradeDescricao = produto.grade.t4;
        break;
      case 5: _gradeDescricao = produto.grade.t5;
        break;
      case 6: _gradeDescricao = produto.grade.t6;
        break;
      case 7: _gradeDescricao = produto.grade.t7;
        break;
      case 8: _gradeDescricao = produto.grade.t8;
        break;
      case 9: _gradeDescricao = produto.grade.t9;
        break;
      case 10: _gradeDescricao = produto.grade.t10;
        break;
      case 11: _gradeDescricao = produto.grade.t11;
        break;
      case 12: _gradeDescricao = produto.grade.t12;
        break;
      case 13: _gradeDescricao = produto.grade.t13;
        break;
      case 14: _gradeDescricao = produto.grade.t14;
        break;
      case 15: _gradeDescricao = produto.grade.t15;
        break;
      default: _gradeDescricao = "";
    }
    return _gradeDescricao;
  }
}