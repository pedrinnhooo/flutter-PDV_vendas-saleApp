import 'dart:async';
import 'dart:isolate';
import 'package:common_files/src/bloc/hasura_bloc.dart';
import 'package:common_files/src/bloc/shared_venda_bloc.dart';
import 'package:common_files/src/model/entities/cadastro/categoria/categoria.dart';
import 'package:common_files/src/model/entities/cadastro/categoria/categoriaDao.dart';
import 'package:common_files/src/model/entities/cadastro/produto/produto.dart';
import 'package:common_files/src/model/entities/cadastro/produto/produtoDao.dart';
import 'package:common_files/src/model/entities/operacao/movimento/movimento.dart';
import 'package:common_files/src/model/entities/operacao/movimento/movimentoDao.dart';
import 'package:common_files/src/utils/constants.dart';
import 'package:dio/dio.dart';


class Sincronizacao {
  HasuraBloc _hasuraBloc;
  SharedVendaBloc _vendaBloc;
  String _ultSincronizacaoCategoria = "2019-09-13T20:54:31.951813";
  String _ultSincronizacaoProduto = "2019-09-13T20:54:31.951813";

  Sincronizacao(this._hasuraBloc, this._vendaBloc){}
  
  getCategoriaListFromServer() async {
    DateTime dataSync;
    String _query = """
      subscription syncCategoria(\$sinc: timestamp!) {
        categoria(order_by: {data_atualizacao: desc}, where: {data_atualizacao: {_gt: \$sinc}}) {
          id
          id_pessoa_grupo
          nome
          data_cadastro
          data_atualizacao
        }
      }
    """;

    var snap = _hasuraBloc.hasuraConnect.subscription(_query, variables: {"sinc": "$_ultSincronizacaoCategoria"}).map((data) =>
          (data["data"]["categoria"] as List)
              .map((d) => Categoria.fromJson(d))
              .toList());

      snap.stream.listen((data) {
        if (data.length > 0) {
          for (Categoria categoria in data) {
            print("categoria: "+categoria.nome);
            CategoriaDAO categoriaDAO = CategoriaDAO(_hasuraBloc, categoria: categoria);
            categoriaDAO.insert();
            dataSync = categoria.dataAtualizacao;
          }
          _ultSincronizacaoCategoria = dataSync.toString();
          _vendaBloc.getallCategoria();
          snap.changeVariable({"sinc": "$_ultSincronizacaoCategoria"});
        }  
      }).onError((err) {
        print(err);
      });    
  }

  getProdutoListFromServer() async {
    DateTime dataSync;
    String _query = """
      subscription syncProduto(\$sinc: timestamp!) {
        produto(order_by: {data_atualizacao: asc}, where: {data_atualizacao: {_gt: \$sinc}}) {
          id
          id_pessoa_grupo
          id_aparente
          id_categoria
          id_grade
          nome
          preco_custo
          ehativo
          data_cadastro
          data_atualizacao
        }
      }
    """;

    var snap = _hasuraBloc.hasuraConnect.subscription(_query, variables: {"sinc": "$_ultSincronizacaoProduto"}).map((data) =>
          (data["data"]["produto"] as List)
              .map((d) => Produto.fromJson(d))
              .toList());

      snap.stream.listen((data) {
        if (data.length > 0) {
          for (Produto produto in data) {
            print("produto: "+produto.nome);
            ProdutoDAO produtoDAO = ProdutoDAO(_hasuraBloc, produto);
            produtoDAO.insert();
            dataSync = produto.dataAtualizacao;
          }
          _ultSincronizacaoProduto = dataSync.toString();
      _vendaBloc.getallProduto();
          snap.changeVariable({"sinc": "$_ultSincronizacaoProduto"});
        }  
      }).onError((err) {
        print(err);
      });  
  }


  Isolate _isolate;
  bool running = false;
  static int _counterZ = 60;
  String notification = "";
  ReceivePort _receivePort;

  int get counterZ => _counterZ;
  set counterZ(int counterZ) => _counterZ = counterZ;

  void start() async {
    /*print('Started !!');
    running = true;
    _receivePort = ReceivePort();
    _isolate = await Isolate.spawn(_checkTimer, _receivePort.sendPort);
    _receivePort.listen(_handleMessage, onDone:() {
        print("done!");
    });*/
    //notifyListeners();      
  }

  static int getcounter(){
    return Sincronizacao._counterZ;
  }

  static void incCouter(){
    _counterZ++;
  }

  static void setCouter(int value){
    _counterZ = value;
  }

  static void _checkTimer(SendPort sendPort, {bool stopThread = false}) async {
    _counterZ = 6000;
    var timer = Timer.periodic(new Duration(seconds: 1), (Timer t) {
      incCouter();
      if (getcounter() >= 6000) {
        String msg = 'EXECUTA SYNC';      
        print('SEND: ' + msg);
        sendPort.send(msg);
        setCouter(0);
      }
    });
  }

  _handleMessage(dynamic data) async {
    print('RECEIVED: ' + data);
    await syncMovimento();
    //notification = data;
    //notifyListeners();      
  }

  stop() async {
    if (_isolate != null) {
       running = false; 
       notification = '';   
      _receivePort.close();
      _isolate.kill(priority: Isolate.immediate);
      _isolate = null;        
      //notifyListeners();      
      }
  }

  syncMovimento() async {
    Movimento movimento = Movimento();
    List<Movimento> movimentoList;
    MovimentoDAO movimentoDAO = MovimentoDAO(_hasuraBloc, movimento);
    movimentoDAO.filterEhSincronizado = FilterEhSincronizado.naoSincronizados;
    movimentoDAO.loadMovimentoItem = true;
    movimentoDAO.loadMovimentoParcela = true;
    movimentoList = await movimentoDAO.getAll(preLoad: true);
        
    for (Movimento mov in movimentoList) {    
      
      /*String _queryItens = "";
      for (var i=0; i < mov.movimentoItem.length; i++){
        if (i == 0) {
          _queryItens = '{data: [';
        }  

        if ((mov.movimentoItem[i].id != null) && (mov.movimentoItem[i].id > 0)) {
          _queryItens = _queryItens + "{id: ${mov.movimentoItem[i].id},";
        } else {
          _queryItens = _queryItens + "{";
        }    

        _queryItens = _queryItens + 
          """
            id_app: ${mov.movimentoItem[i].idApp},
            id_produto: ${mov.movimentoItem[i].idProduto},
            id_variante: ${mov.movimentoItem[i].idVariante},
            grade_posicao: ${mov.movimentoItem[i].gradePosicao},
            sequencial: ${mov.movimentoItem[i].sequencial},
            quantidade: ${mov.movimentoItem[i].quantidade},
            preco_custo: ${mov.movimentoItem[i].precoCusto},
            preco_tabela: ${mov.movimentoItem[i].precoTabela},
            preco_vendido: ${mov.movimentoItem[i].precoVendido},
            total_liquido: ${mov.movimentoItem[i].totalLiquido},
            total_desconto: ${mov.movimentoItem[i].totalDesconto},
            data_cadastro: "${mov.movimentoItem[i].dataCadastro}",
            data_atualizacao: "${mov.movimentoItem[i].dataAtualizacao}" 
          }  
         """;
        if (i == mov.movimentoItem.length-1){
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
              }},
            """;
        }
      }

      mov.ehsincronizado = 1;
      String _query = """ mutation addMovimento {
          insert_movimento(objects: {""";
      if ((mov.id != null) && (mov.id > 0)) {
        _query = _query + "id: ${mov.id},";
      }    
      _query = _query +
        """
            id_app: ${mov.idApp}, 
            total_itens: ${mov.totalItens}, 
            total_quantidade: ${mov.totalQuantidade},
            valor_total_bruto: ${mov.valorTotalBruto},
            valor_total_desconto: ${mov.valorTotalDesconto},
            valor_total_liquido: ${mov.valorTotalLiquido}, 
            valor_troco: ${mov.valorTroco},
            ehcancelado: ${mov.ehcancelado},
            ehorcamento: ${mov.ehorcamento},
            ehsincronizado: ${mov.ehsincronizado},
            data_movimento: "${mov.dataMovimento}",
            data_fechamento: "${mov.dataFechamento}",
            data_atualizacao: "${mov.dataAtualizacao}",
            movimento_items: $_queryItens
            on_conflict: {
              constraint: movimento_pkey, 
              update_columns: [
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
            }
          }
        }  
      """;
      print(_query);
      try {
        var data = await _hasuraBloc.hasuraConnect.mutation(_query);
        mov.id = data["data"]["insert_movimento"]["returning"][0]["id"];
        for (var i = 0; i < mov.movimentoItem.length; i++) {
          mov.movimentoItem[i].id = data["data"]["insert_movimento"]["returning"][0]["movimento_items"][i]["id"];
          mov.movimentoItem[i].idMovimento = mov.id;
        }
        MovimentoDAO movDao = MovimentoDAO(mov);
         await movDao.insert();
        movDao = null;
      } catch (e) {
        print(e);
      }*/
      await chamaZuminha(mov: mov);
    }
    await _vendaBloc.getAllPedido();
  }

  void doSync() {
    setCouter(60);
  }

  Future chamaZuminha({Movimento mov}) async {
    String resource = mov.ehcancelado == 0 ? "grava-venda" : "cancela-venda";
    mov.ehsincronizado = 1;
    try {
      print(mov.toJson());
      var dio = Dio();
      var token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxIiwiaWRfcGVzc29hIjoxLCJpZF9wZXNzb2FfZ3J1cG8iOjEsIm5vbWUiOiJHdXN0YXZvIiwiYWRtaW4iOnRydWUsImh0dHBzOi8vaGFzdXJhLmlvL2p3dC9jbGFpbXMiOnsieC1oYXN1cmEtYWxsb3dlZC1yb2xlcyI6WyJ1c2VyIl0sIngtaGFzdXJhLWRlZmF1bHQtcm9sZSI6InVzZXIiLCJ4LWhhc3VyYS11c2VyLWlkIjoiMSIsIngtaGFzdXJhLW9yZy1pZCI6IjEifX0=.fWofmiSRa/y+L2a+y2BkbSoyxp7ls22uhhazQSy0nK0=|eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxIiwiaWRfcGVzc29hIjoxLCJpZF9wZXNzb2FfZ3J1cG8iOjEsIm5vbWUiOiJHdXN0YXZvIiwiYWRtaW4iOnRydWUsImh0dHBzOi8vaGFzdXJhLmlvL2p3dC9jbGFpbXMiOnsieC1oYXN1cmEtYWxsb3dlZC1yb2xlcyI6WyJ1c2VyIl0sIngtaGFzdXJhLWRlZmF1bHQtcm9sZSI6InVzZXIiLCJ4LWhhc3VyYS11c2VyLWlkIjoiMSIsIngtaGFzdXJhLW9yZy1pZCI6IjEifX0.ptXO8_uF4oJANmXWWm_eyxUaD4J5I8ympIZba-xVkBY";
      dio.options.headers = {"Authorization" : token, "accept": "*/*", "cache-control": "no-cache"};
      Response response = await dio.post(
        'https://535uyq7s8d.execute-api.sa-east-1.amazonaws.com/prod/$resource', 
        data: mov.toJson(),
      );
      print(response.data['id']);
       mov.id = response.data["id"];
        for (var i = 0; i < mov.movimentoItem.length; i++) {
          mov.movimentoItem[i].id = response.data["movimento_item"][i]["id"];
          mov.movimentoItem[i].idMovimento = mov.id;
        }
        for (var i = 0; i < mov.movimentoParcela.length; i++) {
          mov.movimentoParcela[i].id = response.data["movimento_parcela"][i]["id"];
          mov.movimentoParcela[i].idMovimento = mov.id;
        }
        MovimentoDAO movDao = MovimentoDAO(_hasuraBloc, mov);
        await movDao.insert();
        movDao = null;
      
    } catch (e) {
      print(e);
    }
  }

  @override
  void dispose() {
    stop();
  }
}
