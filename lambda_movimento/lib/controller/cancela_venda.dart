import '../packages/postgresql-dart-master/lib/postgres.dart';
import '../utils/constants.dart';
import 'grava_venda.dart';
import '../packages/common_files/lib/common_files.dart';


class CancelaVenda {
  HasuraBlocLambda _hasuraBloc;
  Map<String, dynamic> _json;
  Map<String, dynamic> jsonRetorno;
  Movimento _movimento;
  List<double> _quantidadeGrade = [];
  UsuarioHasura _usuario;


  CancelaVenda(this._hasuraBloc, this._usuario, {Map<String, dynamic> json}) {
    this._json = json;
    _movimento = Movimento.fromJson(_json);
    print(_movimento.id.toString());
  }    
  
  Future<bool> executaCancelaVenda() async {
    if (_movimento.ehfinalizado == 0) {
      bool _result;
      GravaVenda gravaVenda = GravaVenda(_hasuraBloc, this._usuario, json: this._json);
      _result = await gravaVenda.executaGravaVenda();
      if (_result) {
        _movimento.id = (_movimento.id == 0 || _movimento.id == null) ?
          gravaVenda.jsonRetorno["id"] :
          _movimento.id;
        jsonRetorno = _movimento.toJson();
        print("jsonRetorno sem atualizar estoque: "+jsonRetorno.toString());
        return true;
      } else {
        return false;
      }
    }  
    
    var postgresConnection = PostgreSQLConnection(postgresUrl, 5432, 
      postgresDatabase, username: postgresUsername, password: postgresPassword);
    try {
      try {
        print("Atualizar estoque");
        
        if (postgresConnection.isClosed) {
          print("Abre conexao");
          await postgresConnection.open();
        }  
        await postgresConnection.transaction((ctx) async {
          print("Itens: "+_movimento.movimentoItem.length.toString());
          if (_movimento.ehorcamento == 0) {
            for (var i=0; i < _movimento.movimentoItem.length; i++){
              print("idProduto: "+_movimento.movimentoItem[i].idProduto.toString());
              print("idVariante: "+_movimento.movimentoItem[i].idVariante.toString());
              print("grade_posicao: "+_movimento.movimentoItem[i].gradePosicao.toString());
              _quantidadeGrade = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];
              if (_movimento.movimentoItem[i].gradePosicao > 0) {
                _quantidadeGrade[_movimento.movimentoItem[i].gradePosicao - 1] = _movimento.movimentoItem[i].quantidade;
              }  
              print("array_grade: "+_quantidadeGrade.toString());

              print("select estoque");
              String sql = """SELECT id FROM estoque WHERE (id_pessoa = ${_usuario.idPessoa}) 
                and (id_produto = ${_movimento.movimentoItem[i].idProduto}) and (id_variante = ${_movimento.movimentoItem[i].idVariante})""";
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
                          ${_movimento.movimentoItem[i].idVariante}, ${_movimento.movimentoItem[i].quantidade},
                          ${_quantidadeGrade[0]}, ${_quantidadeGrade[1]}, ${_quantidadeGrade[2]}, ${_quantidadeGrade[3]},
                          ${_quantidadeGrade[4]}, ${_quantidadeGrade[5]}, ${_quantidadeGrade[6]}, ${_quantidadeGrade[7]},
                          ${_quantidadeGrade[8]}, ${_quantidadeGrade[9]}, ${_quantidadeGrade[10]}, ${_quantidadeGrade[11]},
                          ${_quantidadeGrade[12]}, ${_quantidadeGrade[13]}, ${_quantidadeGrade[14]})""";
                print("sql: "+sql);
                ctx.query(sql).catchError((_) => null);
                print("fim insert");
              } else {
                print("update");
                sql = 
                """UPDATE estoque SET estoque_total = estoque_total + ${_movimento.movimentoItem[i].quantidade},
                          et1 = et1 + ${_quantidadeGrade[0]}, et2 = et2 + ${_quantidadeGrade[1]}, 
                          et3 = et3 + ${_quantidadeGrade[2]}, et4 = et4 + ${_quantidadeGrade[3]}, 
                          et5 = et5 + ${_quantidadeGrade[4]}, et6 = et6 + ${_quantidadeGrade[5]}, 
                          et7 = et7 + ${_quantidadeGrade[6]}, et8 = et8 + ${_quantidadeGrade[7]}, 
                          et9 = et9 + ${_quantidadeGrade[8]}, et10 = et10 + ${_quantidadeGrade[9]}, 
                          et11 = et11 + ${_quantidadeGrade[10]}, et12 = et12 + ${_quantidadeGrade[11]}, 
                          et13 = et13 + ${_quantidadeGrade[12]}, et14 = et14 + ${_quantidadeGrade[13]}, 
                          et15 = et15 + ${_quantidadeGrade[14]} WHERE id = $idEstoque""";
                print("sql: "+sql);
                ctx.query(sql).catchError((_) => null);
                print("fim update");
              }
            }
          }  
          _movimento.ehsincronizado = 1;
          String sqlMovimento = 
          """UPDATE movimento SET ehcancelado = ${_movimento.ehcancelado}, ehsincronizado = ${_movimento.ehsincronizado},
             data_atualizacao = now() WHERE id = ${_movimento.id}""";
          print("sql: "+sqlMovimento);
          ctx.query(sqlMovimento).catchError((_) => null);
          print("fim update");
        });
        jsonRetorno = _movimento.toJson();
        print("jsonRetorno apos Postgres: "+jsonRetorno.toString());
        return true;
      } catch (e) {
        print("Postgres<ERRO>: " + e.toString());
        return false;
      }  
    } finally {
      postgresConnection.close();
    }  
  }
}