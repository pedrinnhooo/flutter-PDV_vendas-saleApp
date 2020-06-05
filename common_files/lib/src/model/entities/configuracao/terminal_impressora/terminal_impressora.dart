import 'package:common_files/common_files.dart';

class TerminalImpressora implements IEntity{
  int _id;
  int _idPessoa;
  int _idTerminal;
  int _idCupomLayout;
  String _nome;
  String _tipoImpressora;
  String _macAddress;
  String _ip;
  String _textoCabecalho;
  String _textoRodape;
  int _ehDeletado;
  DateTime _dataCadastro;
  DateTime _dataAtualizacao;
  CupomLayout _cupomLayout;

  TerminalImpressora(
      {int id,
      int idPessoa,
      int idTerminal,
      int idCupomLayout,
      String nome,
      String tipoImpressora,
      String macAddress,
      String ip,
      String textoCabecalho,
      String textoRodape,
      int ehDeletado,
      DateTime dataCadastro,
      DateTime dataAtualizacao,
      CupomLayout cupomLayout}) {
    this._id = id;
    this._idPessoa = idPessoa;
    this._idTerminal = idTerminal;
    this._idCupomLayout = idCupomLayout;
    this._nome = nome;
    this._tipoImpressora = tipoImpressora;
    this._macAddress = macAddress;
    this._ip = ip;
    this._textoCabecalho = textoCabecalho;
    this._textoRodape  = textoRodape;
    this._ehDeletado = ehDeletado;
    this._dataCadastro = dataCadastro;
    this._dataAtualizacao = dataAtualizacao;
    this._cupomLayout = cupomLayout == null ? CupomLayout() : cupomLayout;
  }

  int get id => _id;
  set id(int id) => _id = id;
  int get idPessoa => _idPessoa;
  set idPessoa(int idPessoaGrupo) => _idPessoa = idPessoaGrupo;
  int get idTerminal => _idTerminal;
  set idTerminal(int idTerminal) => _idTerminal = idTerminal;
  int get idCupomLayout => _idCupomLayout;
  set idCupomLayout(int idCupomLayout) => _idCupomLayout = idCupomLayout;
  String get nome => _nome;
  set nome(String nome) => _nome = nome;
  String get tipoImpressora => _tipoImpressora;
  set tipoImpressora(String tipoImpressora) => _tipoImpressora = tipoImpressora;
  String get macAddress => _macAddress;
  set macAddress(String macAddress) => _macAddress = macAddress;
  String get ip => _ip;
  set ip(String ip) => _ip = ip;
  String get textoCabecalho => _textoCabecalho;
  set textoCabecalho(String textoCabecalho) => _textoCabecalho = textoCabecalho;
  String get textoRodape => _textoRodape;
  set textoRodape(String textoRodape) => _textoRodape = textoRodape;
  int get ehDeletado => _ehDeletado;
  set ehDeletado(int ehDeletado) => _ehDeletado = ehDeletado;
  DateTime get dataCadastro => _dataCadastro;
  set dataCadastro(DateTime dataCadastro) => _dataCadastro = dataCadastro;
  DateTime get dataAtualizacao => _dataAtualizacao;
  set dataAtualizacao(DateTime dataAtualizacao) => _dataAtualizacao = dataAtualizacao;
  CupomLayout get cupomLayout => _cupomLayout;
  set cupomLayout(CupomLayout cupomLayout) => _cupomLayout = cupomLayout;

  String toString() {
    return '''
      id: ${_id.toString()},    
      idPessoa: ${_idPessoa.toString()},  
      idTerminal: ${_idTerminal.toString()},  
      idCupomLayout: ${_idCupomLayout.toString()},  
      nome: $_nome, 
      tipoImpressora: $_tipoImpressora, 
      macAddress: $_macAddress, 
      ip: $_ip, 
      textoCabecalho: $_textoCabecalho, 
      textoRodape: $_textoRodape, 
      ehDeletado: ${_ehDeletado.toString()}, 
      dataCadastro: ${_dataCadastro.toString()}, 
      dataAtualizacao: ${_dataAtualizacao.toString()}
    ''';  
  }  

  TerminalImpressora.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _idPessoa = json['id_pessoa'];
    _idTerminal = json['id_terminal'];
    _idCupomLayout = json['id_cupom_layout'];
    _nome = json['nome'];
    _tipoImpressora = json['tipo_impressora'];
    _macAddress = json['mac_address'];
    _ip = json['ip'];
    _textoCabecalho = json['texto_cabecalho'];
    _textoRodape = json['texto_rodape'];
    _ehDeletado = json['ehdeletado'];
    _dataCadastro = DateTime.parse(json['data_cadastro']);
    _dataAtualizacao = DateTime.parse(json['data_atualizacao']);
    if (json['cupom_layout'] != null) {
      _cupomLayout = CupomLayout.fromJson(json['cupom_layout']);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this._id;
    data['id_pessoa'] = this._idPessoa;
    data['id_terminal'] = this._idTerminal;
    data['id_cupom_layout'] = this._idCupomLayout;
    data['nome'] = this._nome;
    data['tipo_impressora'] = this._tipoImpressora;
    data['mac_address'] = this._macAddress;
    data['ip'] = this._ip;
    data['texto_cabecalho'] = this.textoCabecalho;
    data['text_rodape'] = this.textoRodape;
    data['ehdeletado'] = this._ehDeletado;
    data['data_cadastro'] = this._dataCadastro;
    data['data_atualizacao'] = this._dataAtualizacao;
    data['cupom_layout'] = this._cupomLayout;
    return data;
  }
}
