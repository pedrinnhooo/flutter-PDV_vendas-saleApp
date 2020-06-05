import '../../interfaces.dart';
import '../../../../../common_files.dart';

class MovimentoItem implements IEntity {
  int _idApp;
  int _id;
  int _idMovimentoApp;
  int _idMovimento;
  int _idProduto;
  int _idVariante;
  int _gradePosicao;
  int _sequencial;
  double _quantidade;
  double _precoCusto;
  double _precoTabela;
  double _precoVendido;
  double _totalBruto;
  double _totalLiquido;
  double _totalDesconto;
  int _ehservico;
  int _ehdeletado;
  DateTime _dataCadastro;
  DateTime _dataAtualizacao;
  Produto _produto;

  MovimentoItem(
      {int idApp,
      int id,
      int idMovimentoApp,
      int idMovimento,
      int idProduto,
      int idVariante,
      int gradePosicao,
      int sequencial,
      double quantidade = 0,
      double precoCusto = 0,
      double precoTabela = 0,
      double precoVendido = 0,
      double totalBruto = 0,
      double totalLiquido = 0,
      double totalDesconto = 0,
      int ehservico = 0,
      int ehdeletado = 0,
      DateTime dataCadastro,
      DateTime dataAtualizacao,
      Produto produto}) {
    this._idApp = idApp;
    this._id = id;
    this._idMovimentoApp = idMovimentoApp;
    this._idMovimento = idMovimento;
    this._idProduto = idProduto;
    this._idVariante = idVariante;
    this._gradePosicao = gradePosicao;
    this._sequencial = sequencial;
    this._quantidade = quantidade;
    this._precoCusto = precoCusto;
    this._precoTabela = precoTabela;
    this._precoVendido = precoVendido;
    this._totalBruto = totalBruto;
    this._totalLiquido = totalLiquido;
    this._totalDesconto = totalDesconto;
    this._ehservico = ehservico;
    this._ehdeletado = ehdeletado;
    this._dataCadastro = dataCadastro != null ? dataCadastro : DateTime.now();
    this._dataAtualizacao = dataAtualizacao != null ? dataAtualizacao : DateTime.now();
    this._produto = produto == null ? Produto() : produto;
  }

  int get idApp => _idApp;
  set idApp(int idApp) => _idApp = idApp;
  int get id => _id;
  set id(int id) => _id = id;
  int get idMovimentoApp => _idMovimentoApp;
  set idMovimentoApp(int idMovimentoApp) => _idMovimentoApp = idMovimentoApp;
  int get idMovimento => _idMovimento;
  set idMovimento(int idMovimento) => _idMovimento = idMovimento;
  int get idProduto => _idProduto;
  set idProduto(int idProduto) => _idProduto = idProduto;
  int get idVariante => _idVariante;
  set idVariante(int idVariante) => _idVariante = idVariante;
  int get gradePosicao => _gradePosicao;
  set gradePosicao(int gradePosicao) => _gradePosicao = gradePosicao;
  int get sequencial => _sequencial;
  set sequencial(int sequencial) => _sequencial = sequencial;
  double get quantidade => _quantidade;
  set quantidade(double quantidade) => _quantidade = quantidade;
  double get precoCusto => _precoCusto;
  set precoCusto(double precoCusto) => _precoCusto = precoCusto;
  double get precoTabela => _precoTabela;
  set precoTabela(double precoTabela) => _precoTabela = precoTabela;
  double get precoVendido => _precoVendido;
  set precoVendido(double precoVendido) => _precoVendido = precoVendido;
  double get totalBruto => _totalBruto;
  set totalBruto(double totalBruto) => _totalBruto = totalBruto;
  double get totalLiquido => _totalLiquido;
  set totalLiquido(double totalLiquido) => _totalLiquido = totalLiquido;
  double get totalDesconto => _totalDesconto;
  set totalDesconto(double totalDesconto) => _totalDesconto = totalDesconto;
  int get ehservico => _ehservico;
  set ehservico(int ehservico) => _ehservico = ehservico;
  int get ehdeletado => _ehdeletado;
  set ehdeletado(int ehdeletado) => _ehdeletado = ehdeletado;
  DateTime get dataCadastro => _dataCadastro;
  set dataCadastro(DateTime dataCadastro) => _dataCadastro = dataCadastro;
  DateTime get dataAtualizacao => _dataAtualizacao;
  set dataAtualizacao(DateTime dataAtualizacao) =>
      _dataAtualizacao = dataAtualizacao;
  Produto get produto => _produto;
  set produto(Produto produto) => _produto = produto;

   MovimentoItem.fromJson(Map<String, dynamic> json) {
    _idApp = json['id_app'];
    _id = json['id'];
    _idMovimentoApp = json['id_movimento_app'];
    _idMovimento = json['id_movimento'];
    _idProduto = json['id_produto'];
    _idVariante = json['id_variante'];
    _gradePosicao = json['grade_posicao'];
    _sequencial = json['sequencial'];
    _quantidade = json['quantidade'];
    _precoCusto = json['preco_custo'];
    _precoTabela = json['preco_tabela'];
    _precoVendido = json['preco_vendido'];
    _totalBruto = json['total_bruto'];
    _totalLiquido = json['total_liquido'];
    _totalDesconto = json['total_desconto'];
    _ehservico = json['ehservico'];
    _ehdeletado = json['ehdeletado'];
    _dataCadastro =  DateTime.parse(json['data_cadastro']);
    _dataAtualizacao = DateTime.parse(json['data_atualizacao']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id_app'] = this._idApp;
    data['id'] = this._id;
    data['id_movimento_app'] = this._idMovimentoApp;
    data['id_movimento'] = this._idMovimento;
    data['id_produto'] = this._idProduto;
    data['id_variante'] = this._idVariante;
    data['grade_posicao'] = this._gradePosicao;
    data['sequencial'] = this._sequencial;
    data['quantidade'] = this._quantidade;
    data['preco_custo'] = this._precoCusto;
    data['preco_tabela'] = this._precoTabela;
    data['preco_vendido'] = this._precoVendido;
    data['total_bruto'] = this._totalBruto;
    data['total_liquido'] = this._totalLiquido;
    data['total_desconto'] = this._totalDesconto;
    data['ehservico'] = this._ehservico;
    data['ehdeletado'] = this._ehdeletado;
    data['data_cadastro'] = this._dataCadastro.toString();
    data['data_atualizacao'] = this._dataAtualizacao.toString();
    return data;
  }
}
