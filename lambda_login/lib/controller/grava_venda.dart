import '../packages/postgresql-dart-master/lib/postgres.dart';
import '../packages/common_files/lib/common_files.dart';
import 'hasura_singleton.dart';
import 'usuario_hasura.dart';

class GravaVenda {
  Map<String, dynamic> _json;
  Map<String, dynamic> jsonRetorno;
  Movimento _movimento;
  List<double> _quantidadeGrade = [];
  UsuarioHasura _usuario;
  //var _hasuraSingleton = HasuraSingleton();

  GravaVenda(this._usuario, {Map<String, dynamic> json}) {
    hasuraSingleton.getHasuraConnect(token: _usuario.token.split("|")[1]);
    this._json = json;
    _movimento = Movimento.fromJson(_json);
    print(_movimento.id.toString());
  }
  
  Future<bool> executaGravaVenda() async {
    var postgresConnection = PostgreSQLConnection(postgresUrl, 5432, 
      postgresDatabase, username: postgresUsername, password: postgresPassword);

    String _queryItens = "";
    String _queryParcelas = "";
    try {
      print("Gravar movimento");
      for (var i=0; i < _movimento.movimentoItem.length; i++){
        print("for movimentoItem");
        if (i == 0) {
          _queryItens = '{data: [';
        }  

        if ((_movimento.movimentoItem[i].id != null) && (_movimento.movimentoItem[i].id > 0)) {
          _queryItens = _queryItens + "{id: ${_movimento.movimentoItem[i].id},";
        } else {
          _queryItens = _queryItens + "{";
        }    

        _queryItens = _queryItens + 
          """
            id_app: ${_movimento.movimentoItem[i].idApp},
            id_produto: ${_movimento.movimentoItem[i].idProduto},
            id_variante: ${_movimento.movimentoItem[i].idVariante},
            grade_posicao: ${_movimento.movimentoItem[i].gradePosicao},
            sequencial: ${_movimento.movimentoItem[i].sequencial},
            quantidade: ${_movimento.movimentoItem[i].quantidade},
            preco_custo: ${_movimento.movimentoItem[i].precoCusto},
            preco_tabela: ${_movimento.movimentoItem[i].precoTabela},
            preco_vendido: ${_movimento.movimentoItem[i].precoVendido},
            total_liquido: ${_movimento.movimentoItem[i].totalLiquido},
            total_desconto: ${_movimento.movimentoItem[i].totalDesconto},
            data_cadastro: "${_movimento.movimentoItem[i].dataCadastro}",
            data_atualizacao: "${_movimento.movimentoItem[i].dataAtualizacao}" 
          }  
          """;
        if (i == _movimento.movimentoItem.length-1){
          _queryItens = _queryItens + 
            """],
                on_conflict: {
                  constraint: movimento_item_pkey, 
                  update_columns: [
                    quantidade,
                    preco_custo,
                    preco_tabela,
                    preco_vendido,
                    total_liquido,
                    total_desconto,
                    data_cadastro,
                    data_atualizacao
                  ]
                }  
              },
            """;
        }
      }
      print("query_itens: "+_queryItens);
    
      print("_movimento.movimentoParcela.length: "+ _movimento.movimentoParcela.length.toString());
      if (_movimento.movimentoParcela.length != 0) {
        for (var i=0; i < _movimento.movimentoParcela.length; i++){
          print("for movimentoParcela");
          print("1");
          if (i == 0) {
            _queryParcelas = '{data: [';
          }  
          print("2");

          if ((_movimento.movimentoParcela[i].id != null) && (_movimento.movimentoParcela[i].id > 0)) {
            _queryParcelas = _queryParcelas + "{id: ${_movimento.movimentoParcela[i].id},";
          } else {
            _queryParcelas = _queryParcelas + "{";
          }    
          print("3");

          _queryParcelas = _queryParcelas + 
            """
              id_app: ${_movimento.movimentoParcela[i].idApp},
              id_tipo_pagamento: ${_movimento.movimentoParcela[i].idTipoPagamento},
              valor: ${_movimento.movimentoParcela[i].valor},
              data_cadastro: "${_movimento.movimentoParcela[i].dataCadastro}",
              data_atualizacao: "${_movimento.movimentoParcela[i].dataAtualizacao}" 
            }  
            """;
          print("4");
          if (i == _movimento.movimentoParcela.length-1){
            _queryParcelas = _queryParcelas + 
              """],
                  on_conflict: {
                    constraint: movimento_parcela_pkey, 
                    update_columns: [
                      id_tipo_pagamento,
                      valor
                    ]
                  }  
                },
              """;
          }
          print("5");
        }
      }  
      print("query_parcelas: "+_queryParcelas);

      _movimento.ehsincronizado = 1;
      String _query = """ mutation addMovimento {
          insert_movimento(objects: {""";
      if ((_movimento.id != null) && (_movimento.id > 0)) {
        _query = _query + "id: ${_movimento.id},";
      }    
      _query = _query +
        """
            id_app: ${_movimento.idApp}, 
            total_itens: ${_movimento.totalItens}, 
            total_quantidade: ${_movimento.totalQuantidade},
            valor_total_bruto: ${_movimento.valorTotalBruto},
            valor_total_desconto: ${_movimento.valorTotalDesconto},
            valor_total_liquido: ${_movimento.valorTotalLiquido}, 
            valor_troco: ${_movimento.valorTroco},
            ehcancelado: ${_movimento.ehcancelado},
            ehorcamento: ${_movimento.ehorcamento},
            ehsincronizado: ${_movimento.ehsincronizado},
            data_movimento: "${_movimento.dataMovimento}",
            data_fechamento: "${_movimento.dataFechamento}",
            data_atualizacao: "${_movimento.dataAtualizacao}",
            movimento_items: $_queryItens""";
            _query = _queryParcelas != "" ? _query + "movimento_parcelas: $_queryParcelas" : _query; 
            _query = _query + """
            }
            on_conflict: {
              constraint: movimento_pkey, 
              update_columns: [
                ehorcamento,
                ehcancelado,
                valor_total_bruto, 
                valor_total_liquido, 
                valor_total_desconto, 
                total_itens, 
                total_quantidade
              ]
            }) {
            returning {
              id
              movimento_items{
                id
                id_app
              }
              movimento_parcelas{
                id
                id_app
              }
            }
          }
        }  
      """;
      print("query Hasura: "+_query);
      var data = await hasuraSingleton.hasuraConnect.mutation(_query);
      _movimento.id = data["data"]["insert_movimento"]["returning"][0]["id"];
      for (var i = 0; i < _movimento.movimentoItem.length; i++) {
        _movimento.movimentoItem[i].id = data["data"]["insert_movimento"]["returning"][0]["movimento_items"][i]["id"];
        _movimento.movimentoItem[i].idMovimento = _movimento.id;
      }
      for (var i = 0; i < _movimento.movimentoParcela.length; i++) {
        _movimento.movimentoParcela[i].id = data["data"]["insert_movimento"]["returning"][0]["movimento_parcelas"][i]["id"];
        _movimento.movimentoParcela[i].idMovimento = _movimento.id;
      }
      jsonRetorno = _movimento.toJson();
      print("jsonRetorno apos Hasura: "+jsonRetorno.toString());

      if ((_movimento.ehorcamento == 0) && (_movimento.ehcancelado == 0) && (_movimento.ehfinalizado == 0)) {
        print("Atualizar estoque");
        if (postgresConnection.isClosed) {
          print("Abre conexao");
          await postgresConnection.open();
        }  
        await postgresConnection.transaction((ctx) async {
          print("Itens: "+_movimento.movimentoItem.length.toString());
          for (var i=0; i < _movimento.movimentoItem.length; i++){
            if (_movimento.movimentoItem[i].ehservico == 0) {
              print("idProduto: "+_movimento.movimentoItem[i].idProduto.toString());
              print("idVariante: "+_movimento.movimentoItem[i].idVariante.toString());
              print("grade_posicao: "+_movimento.movimentoItem[i].gradePosicao.toString());
              _quantidadeGrade = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];
              if (_movimento.movimentoItem[i].gradePosicao > 0) {
                _quantidadeGrade[_movimento.movimentoItem[i].gradePosicao - 1] = _movimento.movimentoItem[i].quantidade;
              }  
              print("array_grade: "+_quantidadeGrade.toString());

              print("select estoque");
              String sql = """
                SELECT id FROM estoque WHERE (id_pessoa = ${_usuario.idPessoa}) 
                and (id_produto = ${_movimento.movimentoItem[i].idProduto}) and 
                ${_movimento.movimentoItem[i].idVariante == 0 ? 'id_variante ISNULL' : '(id_variante = ${_movimento.movimentoItem[i].idVariante})'}
              """;
              print("sql: "+sql);
              var resultEstoque = await ctx.query(sql);
              print(resultEstoque);
              int idEstoque;
              try{
                idEstoque = resultEstoque.first[0];           
              } catch (e) {
                idEstoque = 0;
              }
              if (idEstoque == 0) {
                print("insert");
                sql = 
                """INSERT INTO estoque (id_pessoa, id_pessoa_grupo, id_produto, id_variante, estoque_total,
                          et1, et2, et3, et4, et5, et6, et7, et8, et9, et10, et11, et12, et13, et14, et15) VALUES 
                          (${_usuario.idPessoa}, ${_usuario.idPessoa}, ${_movimento.movimentoItem[i].idProduto}, 
                          ${_movimento.movimentoItem[i].idVariante == 0 ? 'NULL' : _movimento.movimentoItem[i].idVariante}, 
                          ${_movimento.movimentoItem[i].quantidade*-1},
                          ${_quantidadeGrade[0]*-1}, ${_quantidadeGrade[1]*-1}, ${_quantidadeGrade[2]*-1}, ${_quantidadeGrade[3]*-1},
                          ${_quantidadeGrade[4]*-1}, ${_quantidadeGrade[5]*-1}, ${_quantidadeGrade[6]*-1}, ${_quantidadeGrade[7]*-1},
                          ${_quantidadeGrade[8]*-1}, ${_quantidadeGrade[9]*-1}, ${_quantidadeGrade[10]*-1}, ${_quantidadeGrade[11]*-1},
                          ${_quantidadeGrade[12]*-1}, ${_quantidadeGrade[13]*-1}, ${_quantidadeGrade[14]*-1})""";
                print("sql: "+sql);
                ctx.query(sql).catchError((_) => null);
                print("fim insert");
              } else {
                print("update");
                sql = 
                """UPDATE estoque SET estoque_total = estoque_total + ${_movimento.movimentoItem[i].quantidade*-1},
                          et1 = et1 + ${_quantidadeGrade[0]*-1}, et2 = et2 + ${_quantidadeGrade[1]*-1}, 
                          et3 = et3 + ${_quantidadeGrade[2]*-1}, et4 = et4 + ${_quantidadeGrade[3]*-1}, 
                          et5 = et5 + ${_quantidadeGrade[4]*-1}, et6 = et6 + ${_quantidadeGrade[5]*-1}, 
                          et7 = et7 + ${_quantidadeGrade[6]*-1}, et8 = et8 + ${_quantidadeGrade[7]*-1}, 
                          et9 = et9 + ${_quantidadeGrade[8]*-1}, et10 = et10 + ${_quantidadeGrade[9]*-1}, 
                          et11 = et11 + ${_quantidadeGrade[10]*-1}, et12 = et12 + ${_quantidadeGrade[11]*-1}, 
                          et13 = et13 + ${_quantidadeGrade[12]*-1}, et14 = et14 + ${_quantidadeGrade[13]*-1}, 
                          et15 = et15 + ${_quantidadeGrade[14]*-1} WHERE id = $idEstoque""";
                print("sql: "+sql);
                ctx.query(sql).catchError((_) => null);
                print("fim update");
              }
            }  
          }  
          print("atualiza movimento como finalizado");
          _movimento.ehfinalizado = 1;
          String sqlMovimento = 
          """UPDATE movimento SET ehfinalizado = 1,
             data_atualizacao = now() WHERE id = ${_movimento.id}""";
          print("sqlMovimento: "+sqlMovimento);
          ctx.query(sqlMovimento).catchError((_) => null);
          print("fim update");
        });
      }  
      jsonRetorno = _movimento.toJson();
      print("jsonRetorno apos Postgres: "+jsonRetorno.toString());
      return true;
    } catch (e) {
      print("Postgres<ERRO>: " + e.toString());
      return false;
    } finally {
      postgresConnection.close();
    }  
  }
}


