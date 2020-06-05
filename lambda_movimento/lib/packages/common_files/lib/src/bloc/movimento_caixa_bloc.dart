import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:common_files/common_files.dart';
import 'package:common_files/src/model/entities/operacao/movimento/movimento.dart';
import 'package:common_files/src/model/entities/operacao/movimento/movimentoDao.dart';
import 'package:common_files/src/model/entities/operacao/movimento_caixa/movimento_caixa.dart';
import 'package:common_files/src/model/entities/operacao/movimento_caixa/movimento_caixaDao.dart';
import 'package:common_files/src/model/entities/operacao/movimento_caixa/movimento_caixa_parcela.dart';
import 'package:common_files/src/model/entities/operacao/movimento_caixa/movimento_caixa_parcelaDao.dart';
import 'package:common_files/src/model/entities/operacao/movimento_caixa/movimento_caixa_sangria.dart';
import 'package:common_files/src/utils/functions.dart';
import 'package:rxdart/rxdart.dart';

class MovimentoCaixaBloc extends BlocBase {
  HasuraBloc _hasuraBloc;
  MovimentoCaixa movimentoCaixa;
  MovimentoCaixaDAO _movimentoCaixaDAO;

  double _valorRetiradaDisponivel = 0;
  BehaviorSubject<double> _valorRetiradaDisponivelController;
  Observable<double> get valorRetiradaDisponivelOut => _valorRetiradaDisponivelController.stream;

  List<MovimentoCaixaSangria> _movimentoCaixaSangriaList = [];
  BehaviorSubject<List<MovimentoCaixaSangria>> _movimentoCaixaSangriaListController;
  Observable<List<MovimentoCaixaSangria>> get movimentoCaixaSangriaListOut => _movimentoCaixaSangriaListController.stream;

  BehaviorSubject<MovimentoCaixa> _movimentoCaixaController;
  Observable<MovimentoCaixa> get movimentoCaixaOut => _movimentoCaixaController.stream;

  MovimentoCaixaBloc(this._hasuraBloc) {
    movimentoCaixa = MovimentoCaixa();
    _movimentoCaixaDAO = MovimentoCaixaDAO(movimentoCaixa);
    _movimentoCaixaController = BehaviorSubject.seeded(movimentoCaixa);
    _valorRetiradaDisponivelController = BehaviorSubject.seeded(_valorRetiradaDisponivel);
    _movimentoCaixaSangriaListController = BehaviorSubject.seeded(_movimentoCaixaSangriaList);
  }  

  getMovimentoCaixa(DateTime date) async {
    MovimentoCaixa _movimentoCaixa = MovimentoCaixa();
    MovimentoCaixaDAO movimentoCaixaDAO = MovimentoCaixaDAO(_movimentoCaixa);
    movimentoCaixaDAO.filterDataAbertura = date;
    List<dynamic> movimentoCaixaList = await movimentoCaixaDAO.getAll();
    movimentoCaixa = movimentoCaixaList.first;
    _movimentoCaixaController.add(movimentoCaixa);
  }

  Future<bool> temCaixaAbertoAnterior() async {
    MovimentoCaixa _movimentoCaixa = MovimentoCaixa();
    MovimentoCaixaDAO movimentoCaixaDAO = MovimentoCaixaDAO(_movimentoCaixa);
    movimentoCaixaDAO.filterDataAbertura = DateTime.now().subtract(Duration(days: 1));
    movimentoCaixaDAO.filterDataFechamentoAsNull = true;
    List<dynamic> movimentoCaixaList = await movimentoCaixaDAO.getAll();
    _movimentoCaixa = movimentoCaixaList.length > 0 ? movimentoCaixaList.first : null;
    return _movimentoCaixa != null;
  }

  doAberturaCaixa(double valorAbertura) async {
    MovimentoCaixa _movimentoCaixa = MovimentoCaixa();
    MovimentoCaixaDAO movimentoCaixaDAO = MovimentoCaixaDAO(_movimentoCaixa);
    _movimentoCaixa.dataAbertura = DateTime.now();
    _movimentoCaixa.valorAbertura = valorAbertura;
    movimentoCaixa = await movimentoCaixaDAO.insert();

    MovimentoCaixaParcela movimentoCaixaParcela = MovimentoCaixaParcela();
    MovimentoCaixaParcelaDAO movimentoCaixaParcelaDAO = MovimentoCaixaParcelaDAO(movimentoCaixaParcela);
    movimentoCaixaParcela.idAppMovimentoCaixa = movimentoCaixa.idApp;
    movimentoCaixaParcela.idTipoPagamento = 1;
    movimentoCaixaParcela.valor = valorAbertura;
    movimentoCaixaParcela.data = DateTime.now();
    movimentoCaixaParcela.descricao = "Valor de abertura";
    movimentoCaixaParcela = await movimentoCaixaParcelaDAO.insert();

    _movimentoCaixaController.add(movimentoCaixa);
  }

  doFechamentoCaixa(MovimentoCaixa value) async {
    List<Map<dynamic, dynamic>> result = [];
    MovimentoCaixaDAO movimentoCaixaDAO = MovimentoCaixaDAO(value);
    
    result = await movimentoCaixaDAO.getVendaTotal(value.dataAbertura);
    value.vendaTotalValorBruto = result[0]["valor_total_bruto"];
    value.vendaTotalValorDesconto = result[0]["valor_total_desconto"];
    value.vendaTotalValorLiquido = result[0]["valor_total_liquido"];
    value.vendaTotalValorCancelado = result[2]["valor_total_liquido"];
    value.vendaTotalValorDescontoItem = result[0]["valor_total_desconto_item"];
    value.vendaTotalQuantidade = result[0]["total_quantidade"];
    value.vendaTotalQuantidadeCancelada = result[2]["total_quantidade"];
    value.vendaTotalItem = result[0]["total_itens"];
    value.vendaTotalBoletoFechado = result[0]["total_boleto"];
    value.vendaTotalBoletoPedido = result[1]["total_boleto"];
    value.vendaTotalBoletoCancelado = result[2]["total_boleto"];
    value.dataFechamento = DateTime.now();

    value = await movimentoCaixaDAO.insert();
    await getMovimentoCaixa(DateTime.now());
  }

  getValorDisponivelRetirada() async {
    _valorRetiradaDisponivel = await getMovimentoCaixaParcelaDinheiro();
    _valorRetiradaDisponivel += await getMovimentoParcelaDinheiro();
    print("Valor disponivel pra retirada: " + _valorRetiradaDisponivel.toString());
    _valorRetiradaDisponivelController.add(_valorRetiradaDisponivel);
  }

  getValorDisponivelSangria() async {
    await getMovimentoParcelaToSangria();
    List<MovimentoCaixaSangria> movimentoCaixaSangriaList = await getMovimentoCaixaParcelaToSangria();
    if (movimentoCaixaSangriaList.length > 0) {
      for (var i = 0; i < movimentoCaixaSangriaList.length; i++) {
        var novo = _movimentoCaixaSangriaList.firstWhere(
            (mov) => ((mov.idTipoPagamento == movimentoCaixaSangriaList[i].idTipoPagamento)),
            orElse: () => null);

        if (novo != null) {
          novo.valor += movimentoCaixaSangriaList[i].valor;
        } else {
          _movimentoCaixaSangriaList.add(movimentoCaixaSangriaList[i]);
        }
      }  
    }
    //_movimentoCaixaSangriaList = movimentoCaixaSangriaList;
      /*for (var movimentoCaixaSangria in _movimentoCaixaSangriaList) {
        var novo = movimentoCaixaSangriaList.firstWhere(
            (mov) => ((mov.idTipoPagamento == movimentoCaixaSangria.idTipoPagamento)),
            orElse: () => null);
        if (novo != null) {
          movimentoCaixaSangria.valor += novo.valor;
        } else {
          MovimentoCaixaSangria movimentoCaixaSangria = MovimentoCaixaSangria(); 
          movimentoCaixaSangria.idTipoPagamento = 1;
          movimentoCaixaSangria.nomeTipoPagamento = "Dinheiro";
          movimentoCaixaSangria.valor = await getMovimentoCaixaParcelaDinheiro();
          _movimentoCaixaSangriaList.add(movimentoCaixaSangria);
        }
        // if (movimentoCaixaSangria.idTipoPagamento == 1) {
        //   movimentoCaixaSangria.valor += await getMovimentoCaixaParcelaDinheiro();
        // }
        print("Valor ${movimentoCaixaSangria.nomeTipoPagamento} pra retirada: " + movimentoCaixaSangria.valor.roundToDouble().toString());
      }
      } else {
        MovimentoCaixaSangria movimentoCaixaSangria = MovimentoCaixaSangria(); 
        movimentoCaixaSangria.idTipoPagamento = 1;
        movimentoCaixaSangria.nomeTipoPagamento = "Dinheiro";
        movimentoCaixaSangria.valor = await getMovimentoCaixaParcelaDinheiro();
        _movimentoCaixaSangriaList.add(movimentoCaixaSangria);
        print("Valor ${movimentoCaixaSangria.nomeTipoPagamento} pra retirada: " + movimentoCaixaSangria.valor.roundToDouble().toString());
      }*/
    _movimentoCaixaSangriaList.sort((a, b) => a.idTipoPagamento.compareTo(b.idTipoPagamento));
    for (var i = 0; i < _movimentoCaixaSangriaList.length; i++) {
      print("Valor ${_movimentoCaixaSangriaList[i].nomeTipoPagamento} pra retirada: " + _movimentoCaixaSangriaList[i].valor.toStringAsFixed(2));
    }  
  
    _movimentoCaixaSangriaListController.add(_movimentoCaixaSangriaList);
  }

  Future<double> getMovimentoCaixaParcelaDinheiro() async {
    MovimentoCaixa _movimentoCaixa = MovimentoCaixa();
    MovimentoCaixaDAO movimentoCaixaDAO = MovimentoCaixaDAO(_movimentoCaixa);
    List<Map<dynamic, dynamic>> result = [];
    String query = """
      --select m.valor_abertura as valor
      --from movimento_caixa m
      --where date(m.data_abertura) = '${ourDate(DateTime.now())}'

      --union 

      select sum(mp.valor) as valor
      from movimento_caixa_parcela mp
      inner join movimento_caixa mc on mc.id_app = mp.id_app_movimento_caixa
      where date(mc.data_abertura) = '${ourDate(DateTime.now())}'
      and mp.id_tipo_pagamento = 1
    """;
    result = await movimentoCaixaDAO.getRawQuery(query);
    double _valor = result[0]["valor"] != null ? result[0]["valor"] : 0;
    _valor += result.length > 1 ? result[1]["valor"] : 0;
    return _valor;
  }

  Future<double> getMovimentoParcelaDinheiro() async {
    Movimento movimento = Movimento();
    MovimentoDAO movimentoDAO = MovimentoDAO(_hasuraBloc, movimento);
    List<Map<dynamic, dynamic>> result = [];
    String query = """
      select sum(mp.valor) as valor
      from movimento m
      inner join movimento_parcela mp on m.id_app = mp.id_movimento_app
      where date(m.data_movimento) = '${ourDate(DateTime.now())}'
      and (m.ehorcamento = 0) and (m.ehcancelado = 0)
      and (mp.id_tipo_pagamento = 1)      
    """;
    result = await movimentoDAO.getRawQuery(query);
    double _valor;
    _valor = result[0]["valor"] != null ? result[0]["valor"] : 0;
    return _valor;
  }

  Future<List<MovimentoCaixaSangria>> getMovimentoCaixaParcelaToSangria() async {
    Movimento movimento = Movimento();
    MovimentoDAO movimentoDAO = MovimentoDAO(_hasuraBloc, movimento);
    List<Map<dynamic, dynamic>> result = [];
    List<MovimentoCaixaSangria> movimentoCaixaSangriaList = [];
    String query = """
      select sum(mp.valor) as valor, mp.id_tipo_pagamento, t.nome
      from movimento_caixa m
      inner join movimento_caixa_parcela mp on m.id_app = mp.id_app_movimento_caixa
      inner join tipo_pagamento t on t.id = mp.id_tipo_pagamento
      where date(m.data_abertura) = '${ourDate(DateTime.now())}'
      group by mp.id_tipo_pagamento, t.nome
      order by 2
    """;
    result = await movimentoDAO.getRawQuery(query);
    
    for (var i = 0; i < result.length; i++) {
      MovimentoCaixaSangria movimentoCaixaSangria = MovimentoCaixaSangria();
      movimentoCaixaSangria.idTipoPagamento = result[i]["id_tipo_pagamento"];
      movimentoCaixaSangria.nomeTipoPagamento = result[i]["nome"];
      movimentoCaixaSangria.valor = result[i]["valor"] != null ? result[i]["valor"] : 0;
      movimentoCaixaSangriaList.add(movimentoCaixaSangria);
      movimentoCaixaSangria = null;
    }
    return movimentoCaixaSangriaList;
  }

  getMovimentoParcelaToSangria() async {
    Movimento movimento = Movimento();
    MovimentoDAO movimentoDAO = MovimentoDAO(_hasuraBloc, movimento);
    List<Map<dynamic, dynamic>> result = [];
    _movimentoCaixaSangriaList = [];
    String query = """
      select sum(mp.valor) as valor, mp.id_tipo_pagamento, t.nome
      from movimento m
      inner join movimento_parcela mp on m.id_app = mp.id_movimento_app
      inner join tipo_pagamento t on t.id = mp.id_tipo_pagamento
      where date(m.data_movimento) = '${ourDate(DateTime.now())}'
      and (m.ehorcamento = 0) and (m.ehcancelado = 0)
      group by mp.id_tipo_pagamento, t.nome
      order by 2
    """;
    result = await movimentoDAO.getRawQuery(query);
    
    for (var i = 0; i < result.length; i++) {
      MovimentoCaixaSangria movimentoCaixaSangria = MovimentoCaixaSangria();
      movimentoCaixaSangria.idTipoPagamento = result[i]["id_tipo_pagamento"];
      movimentoCaixaSangria.nomeTipoPagamento = result[i]["nome"];
      movimentoCaixaSangria.valor = result[i]["valor"] != null ? result[i]["valor"] : 0;
      _movimentoCaixaSangriaList.add(movimentoCaixaSangria);
      movimentoCaixaSangria = null;
    }
  }

  doReforcoMovimentoCaixa(double valor) async {
    MovimentoCaixaParcela movimentoCaixaParcela = MovimentoCaixaParcela();
    MovimentoCaixaParcelaDAO movimentoCaixaParcelaDAO = MovimentoCaixaParcelaDAO(movimentoCaixaParcela);
    movimentoCaixaParcela.idAppMovimentoCaixa = movimentoCaixa.idApp;
    movimentoCaixaParcela.idTipoPagamento = 1;
    movimentoCaixaParcela.data = DateTime.now();
    movimentoCaixaParcela.descricao = "Reforço";
    movimentoCaixaParcela.valor = valor;
    movimentoCaixaParcela = await movimentoCaixaParcelaDAO.insert();
  }

  doRetiradaMovimentoCaixa(double valor) async {
    MovimentoCaixaParcela movimentoCaixaParcela = MovimentoCaixaParcela();
    MovimentoCaixaParcelaDAO movimentoCaixaParcelaDAO = MovimentoCaixaParcelaDAO(movimentoCaixaParcela);
    movimentoCaixaParcela.idAppMovimentoCaixa = movimentoCaixa.idApp;
    movimentoCaixaParcela.idTipoPagamento = 1;
    movimentoCaixaParcela.data = DateTime.now();
    movimentoCaixaParcela.descricao = "Retirada";
    movimentoCaixaParcela.valor = valor * -1;
    movimentoCaixaParcela = await movimentoCaixaParcelaDAO.insert();
  }


  doSangriaMovimentoCaixa() async {
    for (var i = 0; i < _movimentoCaixaSangriaList.length; i++) {
      MovimentoCaixaParcela movimentoCaixaParcela = MovimentoCaixaParcela();
      MovimentoCaixaParcelaDAO movimentoCaixaParcelaDAO = MovimentoCaixaParcelaDAO(movimentoCaixaParcela);
      movimentoCaixaParcela.idAppMovimentoCaixa = movimentoCaixa.idApp;
      movimentoCaixaParcela.idTipoPagamento = _movimentoCaixaSangriaList[i].idTipoPagamento;
      movimentoCaixaParcela.data = DateTime.now();
      movimentoCaixaParcela.descricao = "Sangria";
      movimentoCaixaParcela.valor =  _movimentoCaixaSangriaList[i].idTipoPagamento == 1 ? 
        (_movimentoCaixaSangriaList[i].valor - 10) * -1 : _movimentoCaixaSangriaList[i].valor * -1;
      movimentoCaixaParcela = await movimentoCaixaParcelaDAO.insert();
      movimentoCaixaParcela = null;
      movimentoCaixaParcelaDAO = null;
    }  
  }

  deleteAll() async{
    _movimentoCaixaDAO.delete(0);
    MovimentoCaixaParcela movimentoCaixaParcela = MovimentoCaixaParcela();
    MovimentoCaixaParcelaDAO movimentoCaixaParcelaDAO = MovimentoCaixaParcelaDAO(movimentoCaixaParcela);
    movimentoCaixaParcelaDAO.delete(0);
  }

  @override
  void dispose() {
    _movimentoCaixaController.close();
    _valorRetiradaDisponivelController.close();
    _movimentoCaixaSangriaListController.close();
    super.dispose();
  }
}