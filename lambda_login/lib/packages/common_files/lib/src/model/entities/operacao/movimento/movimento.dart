import '../../interfaces.dart';
import '../../../../../common_files.dart';

class Movimento implements IEntity {
  int _idApp;
  int _id;
  int _idPessoa;
  int _idCliente;
  int _idVendedor;
  int _idTransacao;
  int _idTerminal;
  int _ehorcamento;
  int _ehcancelado;
  int _ehsincronizado;
  int _ehfinalizado;
  double _valorRestante = 0;
  double _valorTroco = 0;
  double _valorTotalBruto;
  double _valorTotalDesconto;
  double _valorTotalLiquido;
  double _valorTotalDescontoItem;
  int _totalItens;
  double _totalQuantidade;
  DateTime _dataMovimento;
  DateTime _dataFechamento;
  DateTime _dataAtualizacao;
  List<MovimentoItem> _movimentoItem; 
  List<MovimentoParcela> _movimentoParcela;
  Transacao _transacao;

  Movimento(
      {int idApp, 
      int id,
      int idPessoa = 0,
      int idCliente = 0,
      int idVendedor = 0,
      int idTransacao = 0,
      int idTerminal = 0,
      int ehorcamento = 0,
      int ehcancelado = 0,
      int ehsincronizado = 0,
      int ehfinalizado = 0,
      double valorRestante = 0,
      double valorTotalBruto = 0,
      double valorTotalDesconto = 0,
      double valorTotalLiquido = 0,
      double valorTotalDescontoItem = 0,
      int totalItens = 0,
      double totalQuantidade = 0,
      DateTime dataMovimento,
      DateTime dataFechamento,
      DateTime dataAtualizacao,
      List<MovimentoItem> movimentoItem,
      List<MovimentoParcela> movimentoParcela,
      Transacao transacao}) {
    this._idApp = idApp;
    this._id = id;
    this._idPessoa = idPessoa;
    this._idCliente = idCliente;
    this._idVendedor = idVendedor;
    this._idTransacao = idTransacao;
    this._idTerminal = idTerminal;
    this._ehorcamento = ehorcamento;
    this._ehcancelado = ehcancelado;
    this._ehsincronizado = ehsincronizado;
    this._ehfinalizado = ehfinalizado;
    this._valorRestante = valorRestante;
    this._valorTotalBruto = valorTotalBruto;
    this._valorTotalDesconto = valorTotalDesconto;
    this._valorTotalLiquido = valorTotalLiquido;
    this._valorTotalDescontoItem = valorTotalDescontoItem;
    this._totalItens = totalItens;
    this._totalQuantidade = totalQuantidade;
    this._dataMovimento = dataMovimento != null ? dataMovimento : DateTime.now();
    this._dataFechamento = dataFechamento != null ? dataFechamento : DateTime.now();
    this._dataAtualizacao = dataAtualizacao != null ? dataAtualizacao : DateTime.now();
    this._movimentoItem = movimentoItem == null ? [] : movimentoItem;
    this._movimentoParcela = movimentoParcela == null ? [] : movimentoParcela;
    this._transacao = transacao == null ? Transacao() : transacao;
  }

  int get idApp => _idApp;
  set idApp(int idApp) => _idApp = idApp;
  int get id => _id;
  set id(int id) => _id = id;
  int get idPessoa => _idPessoa;
  set idPessoa(int idPessoa) => _idPessoa = idPessoa;
  int get idCliente => _idCliente;
  set idCliente(int idCliente) => _idCliente = idCliente;
  int get idVendedor => _idVendedor;
  set idVendedor(int idVendedor) => _idVendedor = idVendedor;
  int get idTransacao => _idTransacao;
  set idTransacao(int idTransacao) => _idTransacao = idTransacao;
  int get idTerminal => _idTerminal;
  set idTerminal(int idTerminal) => _idTerminal = idTerminal;
  int get ehorcamento => _ehorcamento;
  set ehorcamento(int ehorcamento) => _ehorcamento = ehorcamento;
  int get ehcancelado => _ehcancelado;
  set ehcancelado(int ehcancelado) => _ehcancelado = ehcancelado;
  int get ehsincronizado => _ehsincronizado;
  set ehsincronizado(int ehsincronizado) => _ehsincronizado = ehsincronizado;
  int get ehfinalizado => _ehfinalizado;
  set ehfinalizado(int ehfinalizado) => _ehfinalizado = ehfinalizado;
  double get valorRestante => _valorRestante;
  set valorRestante(double valorRestante) => _valorRestante = valorRestante;
  double get valorTroco => _valorTroco;
  set valorTroco(double valorTroco) => _valorTroco = valorTroco;
  double get valorTotalBruto => _valorTotalBruto;
  set valorTotalBruto(double valorTotalBruto) =>
      _valorTotalBruto = valorTotalBruto;
  double get valorTotalDesconto => _valorTotalDesconto;
  set valorTotalDesconto(double valorTotalDesconto) =>
      _valorTotalDesconto = valorTotalDesconto;
  double get valorTotalLiquido => _valorTotalLiquido;
  set valorTotalLiquido(double valorTotalLiquido) =>
      _valorTotalLiquido = valorTotalLiquido;
  double get valorTotalDescontoItem => _valorTotalDescontoItem;
  set valorTotalDescontoItem(double valorTotalDescontoItem) =>
      _valorTotalDescontoItem = valorTotalDescontoItem;
  int get totalItens => _totalItens;
  set totalItens(int totalItens) => _totalItens = totalItens;
  double get totalQuantidade => _totalQuantidade;
  set totalQuantidade(double totalQuantidade) =>
      _totalQuantidade = totalQuantidade;
  DateTime get dataMovimento => _dataMovimento;
  set dataMovimento(DateTime dataMovimento) => _dataMovimento = dataMovimento;
  DateTime get dataFechamento => _dataFechamento;
  set dataFechamento(DateTime dataFechamento) =>
      _dataFechamento = dataFechamento;
  DateTime get dataAtualizacao => _dataAtualizacao;
  set dataAtualizacao(DateTime dataAtualizacao) =>
      _dataAtualizacao = dataAtualizacao;
  List<MovimentoItem> get movimentoItem => _movimentoItem;
  set movimentoItem(List<MovimentoItem> movimentoItem) =>
      _movimentoItem = movimentoItem;
  List<MovimentoParcela> get movimentoParcela => _movimentoParcela;
  set movimentoParcela(List<MovimentoParcela> movimentoParcela) =>
      _movimentoParcela = movimentoParcela;
  Transacao get transacao => _transacao;
  set transacao(Transacao transacao) => 
      _transacao = transacao;

   Movimento.fromJson(Map<String, dynamic> json) {
    _idApp = json['id_app'];
    _id = json['id'];
    _idPessoa = json['id_pessoa'];
    _idCliente = json['id_cliente'];
    _idVendedor = json['id_vendedor'];
    _idTransacao = json['id_tansacao'];
    _idTerminal = json['id_terminal'];
    _ehorcamento = json['ehorcamento'];
    _ehcancelado = json['ehcancelado'];
    _ehsincronizado = json['ehsincronizado'];
    _ehfinalizado = json['ehfinalizado'];
    _valorTotalBruto = json['valor_total_bruto'];
    _valorTotalDesconto = json['valor_total_desconto'];
    _valorTotalLiquido = json['valor_total_liquido'];
    _valorTotalDescontoItem = json['valor_total_desconto_item'];
    _totalItens = json['total_itens'];
    _totalQuantidade = json['total_quantidade'];
    _dataMovimento = DateTime.parse(json['data_movimento']);
    _dataFechamento = DateTime.parse(json['data_fechamento']);
    _dataAtualizacao = DateTime.parse(json['data_atualizacao']);
    if (json['movimento_item'] != null) {
      _movimentoItem = new List<MovimentoItem>();
      json['movimento_item'].forEach((v) {
        _movimentoItem.add(new MovimentoItem.fromJson(v));
      });
    }
    if (json['movimento_parcela'] != null) {
      _movimentoParcela = new List<MovimentoParcela>();
      json['movimento_parcela'].forEach((v) {
        _movimentoParcela.add(new MovimentoParcela.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id_app'] = this._idApp;
    data['id'] = this._id;
    data['id_pessoa'] = this._idPessoa;
    data['id_cliente'] = this._idCliente;
    data['id_vendedor'] = this._idVendedor;
    data['id_transacao'] = this._idTransacao;
    data['id_terminal'] = this._idTerminal;
    data['ehorcamento'] = this._ehorcamento;
    data['ehcancelado'] = this._ehcancelado;
    data['ehsincronizado'] = this._ehsincronizado;
    data['ehfinalizado'] = this._ehfinalizado;
    data['valor_total_bruto'] = this._valorTotalBruto;
    data['valor_total_desconto'] = this._valorTotalDesconto;
    data['valor_total_liquido'] = this._valorTotalLiquido;
    data['valor_total_desconto_item'] = this._valorTotalDescontoItem;
    data['total_itens'] = this._totalItens;
    data['total_quantidade'] = this._totalQuantidade;
    data['data_movimento'] = this._dataMovimento.toString();
    data['data_fechamento'] = this._dataFechamento.toString();
    data['data_atualizacao'] = this._dataAtualizacao.toString();
    if (this._movimentoItem != null) {
      data['movimento_item'] =
          this._movimentoItem.map((v) => v.toJson()).toList();
    }
    if (this._movimentoParcela != null) {
      data['movimento_parcela'] =
          this._movimentoParcela.map((v) => v.toJson()).toList();
    }
    return data;
  }

}
