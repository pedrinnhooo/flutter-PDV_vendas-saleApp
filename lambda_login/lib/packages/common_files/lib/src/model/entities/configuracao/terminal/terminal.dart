import '../../../../../common_files.dart';

class Terminal implements IEntity {
  int _id;
  int _idPessoa;
  int _idTransacao;
  String _idDevice;
  String _nome;
  int _ehDeletado;
  DateTime _dataCadastro;
  DateTime _dataAtualizacao;
  String _mercadopagoIdTerminal;
  String _mercadopagoQrCode;
  int _temPicpay;
  Transacao _transacao;

  Terminal(
      {int id,
      int idPessoa,
      int idTransacao,
      String idDevice,
      String nome="",
      int ehDeletado = 0,
      DateTime dataCadastro,
      DateTime dataAtualizacao,
      String mercadopagoIdTerminal,
      String mercadopagoQrCode,
      int temPicpay,
      Transacao transacao}) {
    this._id = id;
    this._idPessoa = idPessoa;
    this._idTransacao = idTransacao;
    this._idDevice = idDevice;
    this._nome = nome;
    this._ehDeletado = ehDeletado;
    this._dataCadastro = dataCadastro;
    this._dataAtualizacao = dataAtualizacao;
    this._mercadopagoIdTerminal = mercadopagoIdTerminal;
    this._mercadopagoQrCode = mercadopagoQrCode;
    this._temPicpay = temPicpay;
    this._transacao = transacao == null ? Transacao() : transacao;
  }

  int get id => _id;
  set id(int id) => _id = id;
  int get idPessoa => _idPessoa;
  set idPessoa(int idPessoa) => _idPessoa = idPessoa;
  int get idTransacao => _idTransacao;
  set idTransacao(int idTransacao) => _idTransacao = idTransacao;
  String get idDevice => _idDevice;
  set idDevice(String idDevice) => _idDevice = idDevice;
  String get nome => _nome;
  set nome(String nome) => _nome = nome;
  int get ehDeletado => _ehDeletado;
  set ehDeletado(int ehDeletado) => _ehDeletado = ehDeletado;
  DateTime get dataCadastro => _dataCadastro;
  set dataCadastro(DateTime dataCadastro) => _dataCadastro = dataCadastro;
  DateTime get dataAtualizacao => _dataAtualizacao;
  set dataAtualizacao(DateTime dataAtualizacao) =>
      _dataAtualizacao = dataAtualizacao;
  String get mercadopagoIdTerminal => _mercadopagoIdTerminal;
  set mercadopagoIdTerminal(String mercadopagoIdTerminal) => _mercadopagoIdTerminal = mercadopagoIdTerminal;
  String get mercadopagoQrCode => _mercadopagoQrCode;
  set mercadopagoQrCode(String mercadopagoQrCode) => _mercadopagoQrCode =mercadopagoQrCode;  
  int get temPicpay => _temPicpay;
  set temPicpay(int temPicpay) => _temPicpay = temPicpay;
  Transacao get transacao => _transacao;
  set transacao(Transacao transacao) => 
      _transacao = transacao;      


  Terminal.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _idPessoa = json['id_pessoa'];
    _idTransacao = json['id_transacao'];
    _idDevice = json['id_device'];
    _nome = json['nome'];
    _ehDeletado = json['ehdeletado'];
    _dataCadastro = json['data_cadastro'] != null ? DateTime.parse(json['data_cadastro']) : null;
    _dataAtualizacao = json['data_atualizacao'] != null ? DateTime.parse(json['data_atualizacao']) : null;
    _mercadopagoIdTerminal = json['mercadopago_id_terminal'];
    _mercadopagoQrCode = json['mercadopago_qr_code'];
    _temPicpay = json['tem_picpay'];
    if (json['transacao'] != null) {
      _transacao = Transacao.fromJson(json);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this._id;
    data['id_pessoa'] = this._idPessoa;
    data['id_transacao'] = this._idTransacao;
    data['id_device'] = this._idDevice;
    data['nome'] = this._nome;
    data['ehdeletado'] = this._ehDeletado;
    data['data_cadastro'] = this._dataCadastro;
    data['data_atualizacao'] = this._dataAtualizacao;
    data['mercadopago_id_terminal'] = this._mercadopagoIdTerminal;
    data['mercadopago_qr_code'] = this._mercadopagoQrCode;
    data['tem_picpay'] = this._temPicpay;
    return data;
  }

  static List<Terminal> fromJsonList(List list){
    if(list == null) return null;
    return list
      .map((item) => Terminal.fromJson(item))
      .toList();
  }  

}
