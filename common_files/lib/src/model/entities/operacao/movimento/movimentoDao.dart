import 'package:common_files/common_files.dart';

class MovimentoDAO implements IEntityDAO {
  HasuraBloc _hasuraBloc;
  AppGlobalBloc _appGlobalBloc;
  final String tableName = "movimento";
  String filterText;
  bool filterEhOrcamento = false;
  FilterEhCancelado filterEhCancelado = FilterEhCancelado.todos;
  bool filterData = false;
  DateTime filterDataInicial = DateTime.now();
  DateTime filterDataFinal = DateTime.now();
  FilterEhSincronizado filterEhSincronizado = FilterEhSincronizado.todos;
  bool loadMovimentoItem = false;
  bool loadMovimentoParcela = false;
  bool loadProduto = false;
  bool loadTipoPagamento = false;
  bool loadTransacao = false;
  int filterPrecoTabela = 1;

    
  Movimento movimento;
  MovimentoItem movimentoItem;
  MovimentoParcela movimentoParcela;
  List<Movimento> movimentoList;

  @override
  Dao dao;

  MovimentoDAO(this._hasuraBloc, this._appGlobalBloc, this.movimento) {
    dao = Dao();
    if (movimento == null) {
      movimento = Movimento();
    }
  }

  @override
  IEntity fromMap(Map<String, dynamic> map) {}

  @override
  Future<List> getAll({bool preLoad=false}) async {
    String where = "id_pessoa = ${_appGlobalBloc.loja.id} ";
    where = filterEhOrcamento ? where + "and ehorcamento = 1 " : where; 
    if (filterEhCancelado != FilterEhCancelado.todos) {
      where = filterEhCancelado == FilterEhCancelado.cancelados ? where + "and ehcancelado = 1 " : 
        where + "and ((ehcancelado = 0) or (ehcancelado ISNULL)) "; 
    }   
    if (filterEhSincronizado != FilterEhSincronizado.todos) {
      where = filterEhSincronizado == FilterEhSincronizado.sincronizados ? where + "and ehsincronizado = 1 " : 
        where + "and ((ehsincronizado = 0) or (ehsincronizado ISNULL)) "; 
    }
    where = filterData ? 
      where + """and date(data_movimento) between '${ourDate(filterDataInicial)}' and '${ourDate(filterDataFinal)}' """ : 
      where;
    

    List<dynamic> args = [];

    List list = await dao.getList(this, where, args);
    movimentoList = List.generate(list.length, (i) {
      return Movimento(
               idApp: list[i]['id_app'],
               id: list[i]['id'],
               idPessoa: list[i]['id_pessoa'],
               idCliente: list[i]['id_cliente'],
               idVendedor: list[i]['id_vendedor'],
               idTransacao: list[i]['id_transacao'],
               idTerminal: list[i]['id_terminal'],
               ehorcamento: list[i]['ehorcamento'],
               ehcancelado: list[i]['ehcancelado'],
               ehsincronizado: list[i]['ehsincronizado'],
               ehfinalizado: list[i]['ehfinalizado'],
               valorTotalBruto: list[i]['valor_total_bruto'],
               valorTotalDesconto: list[i]['valor_total_desconto'],
               valorTotalLiquido: list[i]['valor_total_liquido'],
               valorTroco: list[i]['valor_troco'],
               valorTotalBrutoProduto: list[i]['valor_total_bruto_produto'],
               valorTotalBrutoServico: list[i]['valor_total_bruto_servico'],
               valorTotalDescontoItemProduto: list[i]['valor_total_desconto_item_produto'],
               valorTotalDescontoItemServico : list[i]['valor_total_desconto_item_servico'],
               valorTotalLiquidoProduto: list[i]['valor_total_liquido_produto'],
               valorTotalLiquidoServico: list[i]['valor_total_liquido_servico'],
               totalQuantidade: list[i]['total_quantidade'],
               totalItens: list[i]['total_itens'],
               observacao: list[i]['observacao'],
               dataMovimento: DateTime.parse(list[i]['data_movimento']),
               dataFechamento: DateTime.parse(list[i]['data_fechamento']),
               dataAtualizacao: DateTime.parse(list[i]['data_atualizacao']),
      );
    });

    if (preLoad) {
      for (Movimento movimento in movimentoList){
        movimentoItem = MovimentoItem();
        MovimentoItemDAO movimentoItemDAO = MovimentoItemDAO(_hasuraBloc, _appGlobalBloc, movimentoItem);
        if (loadMovimentoItem) {
          movimentoItemDAO.filterMovimento = movimento.idApp;
          movimentoItemDAO.loadProduto = this.loadProduto;         
          List<MovimentoItem> movimentoItemList = await movimentoItemDAO.getAll(preLoad: true);
          movimento.movimentoItem = movimentoItemList;
        }
        movimentoItemDAO = null;

        movimentoParcela = MovimentoParcela();
        MovimentoParcelaDAO movimentoParcelaDAO = MovimentoParcelaDAO(_hasuraBloc, movimentoParcela, _appGlobalBloc);
        if (loadMovimentoParcela) {
          movimentoParcelaDAO.filterMovimento = movimento.idApp;
          movimentoParcelaDAO.loadTipoPagamento = this.loadTipoPagamento;         
          List<MovimentoParcela> movimentoParcelaList = await movimentoParcelaDAO.getAll(preLoad: true);
          movimento.movimentoParcela = movimentoParcelaList;
        }
        movimentoParcelaDAO = null;

        if (loadTransacao) {
          Transacao transacao = Transacao();
          TransacaoDAO transacaoDAO = TransacaoDAO(_hasuraBloc, transacao, _appGlobalBloc);
          movimento.transacao = await transacaoDAO.getById(movimento.idTransacao);
        }
      }
    }  
    return movimentoList;  
  }

  @override
  Future<IEntity> getById(int id) async {
    movimento = await dao.getById(this, id);
    return movimento;
  }

  Future<IEntity> getByIdFromServer(int id) async {
    String query = """ 
      {
        movimento(where: {id: {_eq: $id}}) {
          id_app
          id
          id_pessoa
          id_cliente
          id_vendedor
          id_transacao
          id_terminal
          ehorcamento
          ehcancelado
          ehsincronizado
          ehfinalizado
          valor_total_bruto
          valor_total_desconto
          valor_total_liquido
          valor_total_bruto_produto
          valor_total_bruto_servico
          valor_total_desconto_item_produto
          valor_total_desconto_item_servico
          valor_total_liquido_produto
          valor_total_liquido_servico
          valor_troco
          total_itens
          total_quantidade
          observacao
          data_movimento
          data_fechamento
          data_atualizacao
          pessoaByVendedorId {
            cnpj_cpf
            fantasia_apelido
            razao_nome
          }
          pessoaByClienteId {
            cnpj_cpf
            fantasia_apelido
            razao_nome
          }
          movimento_parcelas {
            id_tipo_pagamento
            valor
            tipo_pagamento {
              ehdinheiro
              ehfiado
              nome
            }
          }
          movimento_items {
            id_produto
            id_variante
            grade_posicao
            sequencial
            quantidade
            preco_custo
            preco_tabela
            preco_vendido
            total_bruto
            total_desconto
            total_liquido
            prazo_entrega
            garantia
            observacao
            observacao_interna
            ehservico
            variante {
              nome
            }
            produto {
              id_aparente
              nome
              grade {
                t1
                t2
                t3
                t4
                t5
                t6
                t7
                t8
                t9
                t10
                t11
                t12
                t13
                t14
                t15
              }
            }
          }
          terminal {
            nome
          }
          transacao {
            nome
          }
        }
      }
    """;

    var data = await _hasuraBloc.hasuraConnect.query(query);    
    
    if( data['data']['movimento'][0].length > 0){
      // FILL MOVIMENTO.VENDEDOR ENTITY WITH MOVIMENTO DATA
      Pessoa _vendedor = Pessoa();
      if(data['data']['movimento'][0]['pessoaByVendedorId'] != null){
        _vendedor = Pessoa (
          cnpjCpf:          data['data']['movimento'][0]['pessoaByVendedorId']['cnpj_cpf'],
          fantasiaApelido:  data['data']['movimento'][0]['pessoaByVendedorId']['fantasia_apelido'],
          razaoNome:        data['data']['movimento'][0]['pessoaByVendedorId']['razao_nome'],
        );
      }

      // FILL MOVIMENTO.CLIENTE ENTITY WITH MOVIMENTO DATA
      Pessoa _cliente = Pessoa();
      if(data['data']['movimento'][0]['pessoaByClienteId'] != null) {
        _cliente = Pessoa (
          cnpjCpf:          data['data']['movimento'][0]['pessoaByClienteId']['cnpj_cpf'],
          fantasiaApelido:  data['data']['movimento'][0]['pessoaByClienteId']['fantasia_apelido'],
          razaoNome:        data['data']['movimento'][0]['pessoaByClienteId']['razao_nome'],
        );
      }

      // FILL MOVIMENTO.MOVIMENTO_ITEM ENTITY WITH MOVIMENTO DATA
      List<MovimentoItem> _movimentoItemList = [];   
      for(var i = 0; i < data['data']['movimento'][0]['movimento_items'].length; i++){

        // FILL MOVIMENTO.MOVIMENTO_ITEM.VARIANTE ENTITY WITH MOVIMENTO DATA
        Variante _variante = Variante();
        if(data['data']['movimento'][0]['movimento_items'][i]['variante'] != null){
          _variante = Variante(
            nome: data['data']['movimento'][0]['movimento_items'][i]['variante']['nome'], 
          );
        }
        
        // FILL MOVIMENTO.MOVIMENTO_ITEM.PRODUTO.GRADE ENTITY WITH MOVIMENTO DATA
        Grade _grade = Grade();
        if(data['data']['movimento'][0]['movimento_items'][i]['produto']['grade'] != null){
          _grade = Grade(
            t1:   data['data']['movimento'][0]['movimento_items'][i]['produto']['grade']['t1'],
            t2:   data['data']['movimento'][0]['movimento_items'][i]['produto']['grade']['t2'],
            t3:   data['data']['movimento'][0]['movimento_items'][i]['produto']['grade']['t3'],
            t4:   data['data']['movimento'][0]['movimento_items'][i]['produto']['grade']['t4'],
            t5:   data['data']['movimento'][0]['movimento_items'][i]['produto']['grade']['t5'],
            t6:   data['data']['movimento'][0]['movimento_items'][i]['produto']['grade']['t6'],
            t7:   data['data']['movimento'][0]['movimento_items'][i]['produto']['grade']['t7'],
            t8:   data['data']['movimento'][0]['movimento_items'][i]['produto']['grade']['t8'],
            t9:   data['data']['movimento'][0]['movimento_items'][i]['produto']['grade']['t9'],
            t10:  data['data']['movimento'][0]['movimento_items'][i]['produto']['grade']['t10'],
            t11:  data['data']['movimento'][0]['movimento_items'][i]['produto']['grade']['t11'],
            t12:  data['data']['movimento'][0]['movimento_items'][i]['produto']['grade']['t12'],
            t13:  data['data']['movimento'][0]['movimento_items'][i]['produto']['grade']['t13'],
            t14:  data['data']['movimento'][0]['movimento_items'][i]['produto']['grade']['t14'],
            t15:  data['data']['movimento'][0]['movimento_items'][i]['produto']['grade']['t15'],
          );
        }

        // FILL MOVIMENTO.MOVIMENTO_ITEM.PRODUTO ENTITY WITH MOVIMENTO DATA
        Produto _produto = Produto(
          idAparente: data['data']['movimento'][0]['movimento_items'][i]['produto']['id_aparente'],
          nome:       data['data']['movimento'][0]['movimento_items'][i]['produto']['nome'],
          grade:      _grade
        );

        _movimentoItemList.add(
          MovimentoItem(
            idProduto:     data['data']['movimento'][0]['movimento_items'][i]['id_produto'],
            idVariante:    data['data']['movimento'][0]['movimento_items'][i]['id_variante'],
            gradePosicao:  data['data']['movimento'][0]['movimento_items'][i]['grade_posicao'],
            sequencial:    data['data']['movimento'][0]['movimento_items'][i]['sequencial'],
            quantidade:    double.parse(data['data']['movimento'][0]['movimento_items'][i]['quantidade'].toString()),
            precoCusto:    double.parse(data['data']['movimento'][0]['movimento_items'][i]['preco_custo'].toString()),
            precoTabela:   double.parse(data['data']['movimento'][0]['movimento_items'][i]['preco_tabela'].toString()),
            precoVendido:  double.parse(data['data']['movimento'][0]['movimento_items'][i]['preco_vendido'].toString()),
            totalBruto:    double.parse(data['data']['movimento'][0]['movimento_items'][i]['total_bruto'] != null ? data['data']['movimento'][0]['movimento_items'][i]['total_bruto'].toString() : '0.00'),
            totalDesconto: double.parse(data['data']['movimento'][0]['movimento_items'][i]['total_desconto'].toString()),
            totalLiquido:  double.parse(data['data']['movimento'][0]['movimento_items'][i]['total_liquido'].toString()),
            prazoEntrega:  data['data']['movimento'][0]['movimento_items'][i]['prazo_entrega'],
            garantia:      data['data']['movimento'][0]['movimento_items'][i]['garantia'],
            observacao:    data['data']['movimento'][0]['movimento_items'][i]['observacao'],
            observacaoInterna: data['data']['movimento'][0]['movimento_items'][i]['observacao_interna'],
            ehservico:     data['data']['movimento'][0]['movimento_items'][i]['ehservico'],
            variante: _variante,
            produto: _produto,          
          )
        );
      }

      // FILL MOVIMENTO.MOVIMENTO_PARCELA ENTITY WITH MOVIMENTO DATA
      List<MovimentoParcela> _movimentoParcelaList = [];   
      for(var i = 0; i < data['data']['movimento'][0]['movimento_parcelas'].length; i++){

        // FILL MOVIMENTO.MOVIMENTO_PARCELA.TIPO_PAGAMENTO ENTITY WITH MOVIMENTO DATA
        TipoPagamento _tipoPagamento = TipoPagamento(
          nome:       data['data']['movimento'][0]['movimento_parcelas'][i]['tipo_pagamento']['nome'],
          ehDinheiro: data['data']['movimento'][0]['movimento_parcelas'][i]['tipo_pagamento']['ehdinheiro'],
          ehFiado:    data['data']['movimento'][0]['movimento_parcelas'][i]['tipo_pagamento']['ehfiado'],
        );

        _movimentoParcelaList.add(
          MovimentoParcela(
            idTipoPagamento:  data['data']['movimento'][0]['movimento_parcelas'][i]['id_produto'],
            valor:            data['data']['movimento'][0]['movimento_parcelas'][i]['id_variante'],
            tipoPagamento:    _tipoPagamento
          )
        );
      }

      // FILL MOVIMENTO ENTITY WITH MOVIMENTO DATA
      movimento = Movimento(
        idApp:              data['data']['movimento'][0]['id_app'],
        id:                 data['data']['movimento'][0]['id'],
        idPessoa:           data['data']['movimento'][0]['id_pessoa'],
        idCliente:          data['data']['movimento'][0]['id_cliente'],
        idVendedor:         data['data']['movimento'][0]['id_vendedor'],
        idTransacao:        data['data']['movimento'][0]['id_transacao'],
        idTerminal:         data['data']['movimento'][0]['id_terminal'],
        ehorcamento:        data['data']['movimento'][0]['ehorcamento'],
        ehcancelado:        data['data']['movimento'][0]['ehcancelado'],
        ehsincronizado:     data['data']['movimento'][0]['ehsincronizado'],
        ehfinalizado:       data['data']['movimento'][0]['ehfinalizado'],
        valorTotalBruto:    double.parse(data['data']['movimento'][0]['valor_total_bruto'].toString()),
        valorTotalDesconto: double.parse(data['data']['movimento'][0]['valor_total_desconto'].toString()),
        valorTotalLiquido:  double.parse(data['data']['movimento'][0]['valor_total_liquido'].toString()),
        valorTroco:         double.parse(data['data']['movimento'][0]['valor_troco'].toString()),
        valorTotalBrutoProduto:    double.parse(data['data']['movimento'][0]['valor_total_bruto_produto'].toString()),
        valorTotalBrutoServico:    double.parse(data['data']['movimento'][0]['valor_total_bruto_servico'].toString()),
        valorTotalDescontoItemProduto: double.parse(data['data']['movimento'][0]['valor_total_desconto_item_produto'].toString()),
        valorTotalDescontoItemServico: double.parse(data['data']['movimento'][0]['valor_total_desconto_item_servico'].toString()),
        valorTotalLiquidoProduto:  double.parse(data['data']['movimento'][0]['valor_total_liquido_produto'].toString()),
        valorTotalLiquidoServico:  double.parse(data['data']['movimento'][0]['valor_total_liquido_servico'].toString()),
        totalItens:         data['data']['movimento'][0]['total_itens'],
        observacao:         data['data']['movimento'][0]['observacao'],
        totalQuantidade:    double.parse(data['data']['movimento'][0]['total_quantidade'].toString()),
        dataMovimento:      DateTime.parse(data['data']['movimento'][0]['data_movimento']),
        dataFechamento:     DateTime.parse(data['data']['movimento'][0]['data_fechamento']),
        dataAtualizacao:    DateTime.parse(data['data']['movimento'][0]['data_atualizacao']),
        vendedor:           _vendedor,
        cliente:            _cliente,
        movimentoParcela:   _movimentoParcelaList,
        movimentoItem:      _movimentoItemList,

      );
    }
    return movimento;
  }

  @override
  Future<IEntity> insert() async {
    this.movimento.idApp = await dao.insert(this);
      for (MovimentoItem movimentoItem in movimento.movimentoItem){
        movimentoItem.idMovimentoApp = this.movimento.idApp;
        MovimentoItemDAO movimentoItemDAO = MovimentoItemDAO(_hasuraBloc, _appGlobalBloc, movimentoItem);
        await movimentoItemDAO.insert();
        movimentoItemDAO = null;
      }
      for (MovimentoParcela movimentoParcela in movimento.movimentoParcela){
        movimentoParcela.idMovimentoApp = this.movimento.idApp;
        MovimentoParcelaDAO movimentoParcelaDAO = MovimentoParcelaDAO(_hasuraBloc, movimentoParcela, _appGlobalBloc);
        await movimentoParcelaDAO.insert();
        if (movimentoParcela.tipoPagamento.ehFiado == 1) {
          MovimentoCliente movimentoCliente = MovimentoCliente();
          MovimentoClienteDAO movimentoClienteDAO = MovimentoClienteDAO(_hasuraBloc, _appGlobalBloc, movimentoCliente);
          movimentoCliente.idAppMovimento = this.movimento.idApp;
          movimentoCliente.idPessoa = this.movimento.idPessoa;
          movimentoCliente.idCliente = 1;//this.movimento.idCliente;
          movimentoCliente.idTipoPagamento = movimentoParcela.idTipoPagamento;
          movimentoCliente.data = DateTime.now();
          movimentoCliente.valor = movimentoParcela.valor * -1;
          movimentoCliente.descricao = "Venda";
          double novoSaldo = await movimentoClienteDAO.getSaldoAtual(movimentoCliente.idCliente);
          novoSaldo += movimentoCliente.valor;
          movimentoCliente.saldo = novoSaldo;
          movimentoCliente = await movimentoClienteDAO.insert();
          movimentoClienteDAO = null;
        }
        movimentoParcelaDAO = null;
      }
    return this.movimento;
  }

  Future<IEntity> saveOnServer() async {
    String _queryItens = "";
    String _queryParcelas = "";
    try {
      for (var i=0; i < movimento.movimentoItem.length; i++){
        if (i == 0) {
          _queryItens = '{data: [';
        }  

        if ((movimento.movimentoItem[i].id != null) && (movimento.movimentoItem[i].id > 0)) {
          _queryItens = _queryItens + "{id: ${movimento.movimentoItem[i].id},";
        } else {
          _queryItens = _queryItens + "{";
        }    

        _queryItens = _queryItens + 
          """
            id_app: ${movimento.movimentoItem[i].idApp},
            id_produto: ${movimento.movimentoItem[i].idProduto},
            id_variante: ${movimento.movimentoItem[i].idVariante},
            grade_posicao: ${movimento.movimentoItem[i].gradePosicao},
            sequencial: ${movimento.movimentoItem[i].sequencial},
            quantidade: ${movimento.movimentoItem[i].quantidade},
            preco_custo: ${movimento.movimentoItem[i].precoCusto},
            preco_tabela: ${movimento.movimentoItem[i].precoTabela},
            preco_vendido: ${movimento.movimentoItem[i].precoVendido},
            total_bruto: ${movimento.movimentoItem[i].totalBruto},
            total_liquido: ${movimento.movimentoItem[i].totalLiquido},
            total_desconto: ${movimento.movimentoItem[i].totalDesconto},
            prazo_entrega: "${movimento.movimentoItem[i].prazoEntrega}",
            garantia: "${movimento.movimentoItem[i].garantia != null ? movimento.movimentoItem[i].garantia : ''}",
            observacao: "${movimento.movimentoItem[i].observacao != null ? movimento.movimentoItem[i].observacao : ''}",
            observacao_interna: "${movimento.movimentoItem[i].observacaoInterna != null ? movimento.movimentoItem[i].observacaoInterna : ''}",
            ehservico: ${movimento.movimentoItem[i].ehservico},
            data_cadastro: "${movimento.movimentoItem[i].dataCadastro}",
            data_atualizacao: "${movimento.movimentoItem[i].dataAtualizacao}" 
          }  
          """;
        if (i == movimento.movimentoItem.length-1){
          _queryItens = _queryItens + 
            """],
                on_conflict: {
                  constraint: movimento_item_pkey, 
                  update_columns: [
                    quantidade,
                    preco_custo,
                    preco_tabela,
                    preco_vendido,
                    total_bruto,
                    total_liquido,
                    total_desconto,
                    prazo_entrega,
                    garantia,
                    observacao,
                    observacao_interna,
                    ehservico,
                    data_cadastro,
                    data_atualizacao
                  ]
                }  
              },
            """;
        }
      }
      print("query_itens: "+_queryItens);
    
      print("_movimento.movimentoParcela.length: "+ movimento.movimentoParcela.length.toString());
      if (movimento.movimentoParcela.length != 0) {
        for (var i=0; i < movimento.movimentoParcela.length; i++){
          if (i == 0) {
            _queryParcelas = '{data: [';
          }  

          if ((movimento.movimentoParcela[i].id != null) && (movimento.movimentoParcela[i].id > 0)) {
            _queryParcelas = _queryParcelas + "{id: ${movimento.movimentoParcela[i].id},";
          } else {
            _queryParcelas = _queryParcelas + "{";
          }    

          _queryParcelas = _queryParcelas + 
            """
              id_app: ${movimento.movimentoParcela[i].idApp},
              id_tipo_pagamento: ${movimento.movimentoParcela[i].idTipoPagamento},
              valor: ${movimento.movimentoParcela[i].valor},
              data_cadastro: "${movimento.movimentoParcela[i].dataCadastro}",
              data_atualizacao: "${movimento.movimentoParcela[i].dataAtualizacao}" 
            }  
            """;
          if (i == movimento.movimentoParcela.length-1) {
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
        }
      }  
      print("query_parcelas: "+_queryParcelas);

      movimento.ehsincronizado = 1;
      String _query = """ mutation addMovimento {
          insert_movimento(objects: {""";
      if ((movimento.id != null) && (movimento.id > 0)) {
        _query = _query + "id: ${movimento.id},";
      }    
      _query = _query +
        """
            id_app: ${movimento.idApp},
            id_cliente: ${movimento.idCliente},  
            id_vendedor: ${movimento.idVendedor}, 
            id_terminal: ${movimento.idTerminal}, 
            id_transacao: ${movimento.idTransacao}, 
            ehcancelado: ${movimento.ehcancelado},
            ehorcamento: ${movimento.ehorcamento},
            ehfinalizado: ${movimento.ehfinalizado},
            valor_total_bruto: ${movimento.valorTotalBruto},
            valor_total_desconto: ${movimento.valorTotalDesconto},
            valor_total_liquido: ${movimento.valorTotalLiquido}, 
            valor_troco: ${movimento.valorTroco},
            valor_total_bruto_produto: ${movimento.valorTotalBrutoProduto},
            valor_total_bruto_servico: ${movimento.valorTotalBrutoServico},
            valor_total_desconto_item_produto: ${movimento.valorTotalDescontoItemProduto},
            valor_total_desconto_item_servico: ${movimento.valorTotalDescontoItemServico},
            valor_total_liquido_produto: ${movimento.valorTotalLiquidoProduto},
            valor_total_liquido_servico: ${movimento.valorTotalLiquidoServico},
            total_itens: ${movimento.totalItens},
            total_quantidade: ${movimento.totalQuantidade},
            ehsincronizado: ${movimento.ehsincronizado},
            data_movimento: "${movimento.dataMovimento}",
            data_fechamento: "${movimento.dataFechamento}",
            data_atualizacao: "${movimento.dataAtualizacao}",
            observacao: "${movimento.observacao}", 
            movimento_items: $_queryItens""";
            _query = _queryParcelas != "" ? _query + "movimento_parcelas: $_queryParcelas" : _query; 
            _query = _query + """
            }
            on_conflict: {
              constraint: movimento_pkey, 
              update_columns: [
                ehorcamento,
                ehcancelado,
                ehfinalizado,
                observacao,
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

      try {
        var data = await _hasuraBloc.hasuraConnect.mutation(_query);
        movimento.id = data["data"]["insert_movimento"]["returning"][0]["id"];
        for (var i = 0; i < movimento.movimentoItem.length; i++) {
          movimento.movimentoItem[i].id = data["data"]["insert_movimento"]["returning"][0]["movimento_items"][i]["id"];
          movimento.movimentoItem[i].idMovimento = movimento.id;
        }
        for (var i = 0; i < movimento.movimentoParcela.length; i++) {
          movimento.movimentoParcela[i].id = data["data"]["insert_movimento"]["returning"][0]["movimento_parcelas"][i]["id"];
          movimento.movimentoParcela[i].idMovimento = movimento.id;
        }
      } catch(error) {
        print("Exception<SaveOnServer> mutation: $error");
      }
    } catch(error) {
      print("Exception<SaveOnServer> $error");
    }
    return this.movimento;
  }

  Future<bool>finalizaMovimento() async {
    String _query = "";
    try {
      _query = """
        {
          atualiza_movimento(args: {pid_movimento: ${movimento.id}}) {
            id
          }
        }
      """;

      try {
        var data = await _hasuraBloc.hasuraConnect.query(_query);
        return data["data"]["atualiza_movimento"][0]["id"] != null && movimento.id == data["data"]["atualiza_movimento"][0]["id"];
      } catch(error) {
        print("Exception<finalizaMovimento> Mutation: $error");
        return false;
      }
    } catch(error) {
      print("Exception<finalizaMovimento> $error");
      return false;
    }
  }

  @override
  Future<IEntity> delete(int id) async {
    await dao.delete(this, id);
    MovimentoItemDAO movimentoItemDAO = MovimentoItemDAO(_hasuraBloc, _appGlobalBloc, movimentoItem);
    await dao.delete(movimentoItemDAO, id);
    MovimentoParcelaDAO movimentoParcelaDAO = MovimentoParcelaDAO(_hasuraBloc, movimentoParcela, _appGlobalBloc);
    await dao.delete(movimentoParcelaDAO, id);
    return this.movimento;
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'id_app': this.movimento.idApp,
      'id': this.movimento.id,
      'id_pessoa': this.movimento.idPessoa,
      'id_cliente': this.movimento.idCliente,
      'id_vendedor': this.movimento.idVendedor,
      'id_transacao': this.movimento.idTransacao,
      'id_terminal': this.movimento.idTerminal,
      'ehorcamento': this.movimento.ehorcamento,
      'ehcancelado': this.movimento.ehcancelado,
      'ehsincronizado': this.movimento.ehsincronizado,
      'ehfinalizado': this.movimento.ehfinalizado,
      'valor_total_bruto': this.movimento.valorTotalBruto,
      'valor_total_desconto': this.movimento.valorTotalDesconto,
      'valor_total_liquido': this.movimento.valorTotalLiquido,
      'valor_troco': this.movimento.valorTroco,
      'valor_total_bruto_produto': this.movimento.valorTotalBrutoProduto,
      'valor_total_bruto_servico': this.movimento.valorTotalBrutoServico,
      'valor_total_desconto_item_produto': this.movimento.valorTotalDescontoItemProduto,
      'valor_total_desconto_item_servico': this.movimento.valorTotalDescontoItemServico,
      'valor_total_liquido_produto': this.movimento.valorTotalLiquidoProduto,
      'valor_total_liquido_servico': this.movimento.valorTotalLiquidoServico,
      'total_itens': this.movimento.totalItens,
      'total_quantidade': this.movimento.totalQuantidade,
      'observacao': this.movimento.observacao,
      'data_movimento': this.movimento.dataMovimento.toString(),
      'data_fechamento': this.movimento.dataFechamento.toString(),
      'data_atualizacao': this.movimento.dataAtualizacao.toString()
    };
  }

  Future<List<Map<dynamic, dynamic>>> getRawQuery(String query) async {
    List<Map<dynamic, dynamic>> result = [];
    result = await dao.getRawQuery(query);
    return result;  
  } 
}