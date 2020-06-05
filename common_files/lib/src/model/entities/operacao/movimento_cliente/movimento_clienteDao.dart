import 'package:common_files/common_files.dart';

class MovimentoClienteDAO implements IEntityDAO {
  AppGlobalBloc _appGlobalBloc;
  HasuraBloc _hasuraBloc;
  final String tableName = "movimento_cliente";
  int filterMovimento = 0;
  int filterIdCliente = 0;
  DateTime filterDataInicial;
  bool filterBasico = true;
    
  MovimentoCliente movimentoCliente;
  List<MovimentoCliente> movimentoClienteList;
  
  @override
  Dao dao;

  MovimentoClienteDAO(this._hasuraBloc, this._appGlobalBloc, this.movimentoCliente) {
    dao = Dao();
    movimentoCliente = movimentoCliente == null ? MovimentoCliente() : movimentoCliente;
  }  

  @override
  IEntity fromMap(Map<String, dynamic> map) {}

  @override
  Future<List> getAll({bool preLoad=false}) async {
    String where = "id_pessoa = ${_appGlobalBloc.loja.id} ";
    List<dynamic> args = [];
    List list = [];

    if (!filterBasico) {
      where = filterMovimento > 0 ? where + " and id_app_movimento = $filterMovimento" : where; 
      where = filterDataInicial != null ? where + " and date(data) >= '${ourDate(filterDataInicial)}'" : where; 
      where = filterIdCliente > 0 ? where + " and id_cliente = $filterIdCliente" : where; 
      list = await dao.getList(this, where, args);
    } else {
      String query = """
        select m.*
        from movimento_cliente m
        ${filterIdCliente != 0 ? "where m.id_cliente = $filterIdCliente" : ""}
        order by m.id_app desc
        limit 10
      """;
      list = await dao.getRawQuery(query);
    }

    movimentoClienteList = List.generate(list.length, (i) {
      return MovimentoCliente(
        idApp: list[i]['id_app'],
        id: list[i]['id'],
        idPessoa: list[i]['id_pessoa'],
        idCliente: list[i]['id_cliente'],
        idAppMovimento: list[i]['id_app_movimento'],
        idMovimento: list[i]['id_movimento'],
        idTipoPagamento: list[i]['id_tipo_pagamento'],
        data: DateTime.parse(list[i]['data']),
        valor: list[i]['valor'],
        descricao: list[i]['descricao'],
        observacao: list[i]['observacao'],
        saldo: list[i]['saldo'],
        dataCadastro: DateTime.parse(list[i]['data_cadastro']),
        dataAtualizacao: DateTime.parse(list[i]['data_atualizacao']),
      );
    });
    
    movimentoClienteList.sort((a, b) => a.idApp.compareTo(b.idApp));
   
    return movimentoClienteList;
  }

  Future getAllFromServer({int id, DateTime filterInitialDate, DateTime filterEndDate, int offset}) async {
    String query = """ 
      {
        movimento(
          where: {
            ${id != null ? "id_cliente: {_eq: $id}," : ""}
            
          }, offset: 0, limit: $queryLimit) {
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
          valor_total_desconto_item_produto
          valor_total_desconto_item_servico
          total_itens
          total_quantidade
          data_movimento
          data_fechamento
          data_atualizacao
          valor_troco
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
            observacao
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

    print(query);
    var data = await _hasuraBloc.hasuraConnect.query(query);
    print(data);
    
    List<Movimento> movimentoList = [];
    if( data['data']['movimento'].length > 0){
      for(var i = 0; i < data['data']['movimento'].length; i++){

        // FILL MOVIMENTO.VENDEDOR ENTITY WITH MOVIMENTO DATA
        Pessoa _vendedor;
        if(data['data']['movimento'][i]['pessoaByVendedorId'] != null){
          _vendedor = Pessoa (
            cnpjCpf:          data['data']['movimento'][i]['pessoaByVendedorId']['cnpj_cpf'],
            fantasiaApelido:  data['data']['movimento'][i]['pessoaByVendedorId']['fantasia_apelido'],
            razaoNome:        data['data']['movimento'][i]['pessoaByVendedorId']['razao_nome'],
          );
        }

        // FILL MOVIMENTO.CLIENTE ENTITY WITH MOVIMENTO DATA
        Pessoa _cliente;
        if(data['data']['movimento'][i]['pessoaByClienteId'] != null){
          _cliente = Pessoa (
            cnpjCpf:          data['data']['movimento'][i]['pessoaByClienteId']['cnpj_cpf'],
            fantasiaApelido:  data['data']['movimento'][i]['pessoaByClienteId']['fantasia_apelido'],
            razaoNome:        data['data']['movimento'][i]['pessoaByClienteId']['razao_nome'],
          );
        }

        // FILL MOVIMENTO.MOVIMENTO_ITEM ENTITY WITH MOVIMENTO DATA
        List<MovimentoItem> _movimentoItemList = [];   
        for(var j = 0; j < data['data']['movimento'][i]['movimento_items'].length; j++){
          
          // FILL MOVIMENTO.MOVIMENTO_ITEM.VARIANTE ENTITY WITH MOVIMENTO DATA
          Variante _variante;
          if(data['data']['movimento'][i]['movimento_items'][j]['variante'] != null){
            _variante = Variante(
              nome: data['data']['movimento'][i]['movimento_items'][j]['variante']['nome'], 
            );
          }
          
          // FILL MOVIMENTO.MOVIMENTO_ITEM.PRODUTO.GRADE ENTITY WITH MOVIMENTO DATA
          Grade _grade;
          if(data['data']['movimento'][i]['movimento_items'][j]['produto']['grade'] != null){
            _grade = Grade(
              t1:    data['data']['movimento'][i]['movimento_items'][j]['produto']['grade']['t1'],
              t2:    data['data']['movimento'][i]['movimento_items'][j]['produto']['grade']['t2'],
              t3:    data['data']['movimento'][i]['movimento_items'][j]['produto']['grade']['t3'],
              t4:    data['data']['movimento'][i]['movimento_items'][j]['produto']['grade']['t4'],
              t5:    data['data']['movimento'][i]['movimento_items'][j]['produto']['grade']['t5'],
              t6:    data['data']['movimento'][i]['movimento_items'][j]['produto']['grade']['t6'],
              t7:    data['data']['movimento'][i]['movimento_items'][j]['produto']['grade']['t7'],
              t8:    data['data']['movimento'][i]['movimento_items'][j]['produto']['grade']['t8'],
              t9:    data['data']['movimento'][i]['movimento_items'][j]['produto']['grade']['t9'],
              t10:  data['data']['movimento'][i]['movimento_items'][j]['produto']['grade']['t10'],
              t11:  data['data']['movimento'][i]['movimento_items'][j]['produto']['grade']['t11'],
              t12:  data['data']['movimento'][i]['movimento_items'][j]['produto']['grade']['t12'],
              t13:  data['data']['movimento'][i]['movimento_items'][j]['produto']['grade']['t13'],
              t14:  data['data']['movimento'][i]['movimento_items'][j]['produto']['grade']['t14'],
              t15:  data['data']['movimento'][i]['movimento_items'][j]['produto']['grade']['t15'],
            );
          }
          
          // FILL MOVIMENTO.MOVIMENTO_ITEM.PRODUTO ENTITY WITH MOVIMENTO DATA
          Produto _produto = Produto(
            idAparente: data['data']['movimento'][i]['movimento_items'][j]['produto']['id_aparente'],
            nome:       data['data']['movimento'][i]['movimento_items'][j]['produto']['nome'],
            grade:      _grade
          );

          _movimentoItemList.add(
            MovimentoItem(
              idProduto:      data['data']['movimento'][i]['movimento_items'][j]['id_produto'],
              idVariante:     data['data']['movimento'][i]['movimento_items'][j]['id_variante'],
              gradePosicao:   data['data']['movimento'][i]['movimento_items'][j]['grade_posicao'],
              sequencial:     data['data']['movimento'][i]['movimento_items'][j]['sequencial'],
              quantidade:     double.parse(data['data']['movimento'][i]['movimento_items'][j]['quantidade'].toString()),
              precoCusto:     double.parse(data['data']['movimento'][i]['movimento_items'][j]['preco_custo'].toString()),
              precoTabela:    double.parse(data['data']['movimento'][i]['movimento_items'][j]['preco_tabela'].toString()),
              precoVendido:   double.parse(data['data']['movimento'][i]['movimento_items'][j]['preco_vendido'].toString()),
              totalBruto:     double.parse(data['data']['movimento'][i]['movimento_items'][j]['total_bruto'] != null ? data['data']['movimento'][i]['movimento_items'][j]['total_bruto'].toString() : '0.00'),
              totalDesconto:  double.parse(data['data']['movimento'][i]['movimento_items'][j]['total_desconto'].toString()),
              totalLiquido:   double.parse(data['data']['movimento'][i]['movimento_items'][j]['total_liquido'].toString()),
              observacao:     data['data']['movimento'][i]['movimento_items'][j]['observacao'],
              variante: _variante,
              produto: _produto,          
            )
          );
        }

        // FILL MOVIMENTO.MOVIMENTO_PARCELA ENTITY WITH MOVIMENTO DATA
        List<MovimentoParcela> _movimentoParcelaList = [];   
        for(var x = 0; x < data['data']['movimento'][i]['movimento_parcelas'].length; x++){

          // FILL MOVIMENTO.MOVIMENTO_PARCELA.TIPO_PAGAMENTO ENTITY WITH MOVIMENTO DATA
          TipoPagamento _tipoPagamento = TipoPagamento(
            nome:       data['data']['movimento'][i]['movimento_parcelas'][x]['tipo_pagamento']['nome'],
            ehDinheiro: data['data']['movimento'][i]['movimento_parcelas'][x]['tipo_pagamento']['ehdinheiro'],
            ehFiado:    data['data']['movimento'][i]['movimento_parcelas'][x]['tipo_pagamento']['ehfiado'],
          );

          _movimentoParcelaList.add(
            MovimentoParcela(
              idTipoPagamento:  data['data']['movimento'][i]['movimento_parcelas'][x]['id_produto'],
              valor:            data['data']['movimento'][i]['movimento_parcelas'][x]['id_variante'],
              tipoPagamento:    _tipoPagamento
            )
          );
        }

        // FILL MOVIMENTO ENTITY WITH MOVIMENTO DATA
        movimentoList.add(
          Movimento(
            idApp:                  data['data']['movimento'][i]['id_app'],
            id:                     data['data']['movimento'][i]['id'],
            idPessoa:               data['data']['movimento'][i]['id_pessoa'],
            idCliente:              data['data']['movimento'][i]['id_cliente'],
            idVendedor:             data['data']['movimento'][i]['id_vendedor'],
            idTransacao:            data['data']['movimento'][i]['id_transacao'],
            idTerminal:             data['data']['movimento'][i]['id_terminal'],
            ehorcamento:            data['data']['movimento'][i]['ehorcamento'],
            ehcancelado:            data['data']['movimento'][i]['ehcancelado'],
            ehsincronizado:         data['data']['movimento'][i]['ehsincronizado'],
            ehfinalizado:           data['data']['movimento'][i]['ehfinalizado'],
            valorTotalBruto:        double.parse(data['data']['movimento'][i]['valor_total_bruto'].toString()),
            valorTotalDesconto:     double.parse(data['data']['movimento'][i]['valor_total_desconto'].toString()),
            valorTotalLiquido:      double.parse(data['data']['movimento'][i]['valor_total_liquido'].toString()),
            //valorTotalDescontoItem: double.parse(data['data']['movimento'][i]['valor_total_desconto_item_produto'] != null ? data['data']['movimento'][i]['valor_total_desconto_item_produto'].toString() : '0.00'),
            valorRestante:          double.parse(data['data']['movimento'][i]['valor_troco'].toString()),
            totalItens:             data['data']['movimento'][i]['total_itens'],
            totalQuantidade:        double.parse(data['data']['movimento'][i]['total_quantidade'].toString()),
            dataMovimento:          DateTime.parse(data['data']['movimento'][i]['data_movimento']),
            dataFechamento:         DateTime.parse(data['data']['movimento'][i]['data_fechamento']),
            dataAtualizacao:        DateTime.parse(data['data']['movimento'][i]['data_atualizacao']),
            vendedor:               _vendedor,
            cliente:                _cliente,
            movimentoParcela:       _movimentoParcelaList,
            movimentoItem:          _movimentoItemList,
          )
        );
      }
    }
    return movimentoList;
  }

  @override
  Future<IEntity> getById(int id) async {
    movimentoCliente = await dao.getById(this, id);
    return movimentoCliente;
  }

  @override
  Future<IEntity> insert() async {
    this.movimentoCliente.idApp = await dao.insert(this);
    return this.movimentoCliente;
  }

  @override
  Future<IEntity> delete(int id) async {
    await dao.delete(this, id);
    return this.movimentoCliente;
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'id_app': this.movimentoCliente.idApp,
      'id': this.movimentoCliente.id,
      'id_pessoa': this.movimentoCliente.idPessoa,
      'id_cliente': this.movimentoCliente.idCliente,
      'id_app_movimento': this.movimentoCliente.idAppMovimento,
      'id_movimento': this.movimentoCliente.idMovimento,
      'id_tipo_pagamento': this.movimentoCliente.idTipoPagamento,
      'data': this.movimentoCliente.data.toString(),
      'valor': this.movimentoCliente.valor,
      'descricao': this.movimentoCliente.descricao,
      'observacao': this.movimentoCliente.observacao,
      'saldo': this.movimentoCliente.saldo,
      'data_cadastro': this.movimentoCliente.dataCadastro.toString(),
      'data_atualizacao': this.movimentoCliente.dataAtualizacao.toString(),
    };
  }

  Future<double> getSaldoAtual(int idCliente) async {
    List<Map<dynamic, dynamic>> result = [];
    String query = """
      select m.saldo
      from movimento_cliente m
      where m.id_cliente = $idCliente
      order by m.id_app desc
      limit 1
    """;
    result = await dao.getRawQuery(query);
    return ((result.length > 0) && (result[0]["saldo"].toDouble() != null)) ? result[0]["saldo"].toDouble() : 0;  
  }

}
