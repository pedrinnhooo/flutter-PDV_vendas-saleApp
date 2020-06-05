import 'package:common_files/common_files.dart';

class Integracao implements IEntity {
  int _id;
  int _idPessoa;
  String _mercadopagoAcessToken;
  String _picpayAcessToken;
  String _mercadopagoUserId;
  int _ehDeletado;
  DateTime _dataCadastro;
  DateTime _dataAtualizacao;
  String _mercadopagoIdLoja;
  Pessoa _pessoa; 
  List<Endereco> _endereco;

  Integracao(
      {int id,
      int idPessoa,
      String mercadopagoAcessToken,
      String picpayAcessToken,
      String mercadopagoUserId,
      int ehDeletado = 0,
      DateTime dataCadastro,
      DateTime dataAtualizacao,
      String mercadopagoIdLoja,
      Pessoa pessoa,
      List<Endereco> endereco}) {
    this._id = id;
    this._idPessoa = idPessoa;
    this._mercadopagoAcessToken = mercadopagoAcessToken;
    this._picpayAcessToken = picpayAcessToken;
    this._mercadopagoUserId = mercadopagoUserId;
    this._ehDeletado = ehDeletado;
    this._dataCadastro = dataCadastro;
    this._dataAtualizacao = dataAtualizacao;
    this._mercadopagoIdLoja = mercadopagoIdLoja;
    this._pessoa = pessoa;
    this._endereco = endereco == null ? [] : endereco;
  }

  int get id => _id;
  set id(int id) => _id = id;
  int get idPessoa => _idPessoa;
  set idPessoa(int idPessoa) => _idPessoa = idPessoa;
  String get mercadopagoAcessToken => _mercadopagoAcessToken;
  set mercadopagoAcessToken(String mercadopagoAcessToken) => _mercadopagoAcessToken = mercadopagoAcessToken;
  String get picpayAcessToken => _picpayAcessToken;
  set picpayAcessToken(String picpayAcessToken) => _picpayAcessToken = picpayAcessToken;
  String get mercadopagoUserId => _mercadopagoUserId;
  set mercadopagoUserId(String mercadopagoUserId) => _mercadopagoUserId = mercadopagoUserId;
  int get ehDeletado => _ehDeletado;
  set ehDeletado(int ehDeletado) => _ehDeletado = ehDeletado;
  DateTime get dataCadastro => _dataCadastro;
  set dataCadastro(DateTime dataCadastro) => _dataCadastro = dataCadastro;
  DateTime get dataAtualizacao => _dataAtualizacao;
  set dataAtualizacao(DateTime dataAtualizacao) => _dataAtualizacao = dataAtualizacao;
  String get mercadopagoIdLoja => _mercadopagoIdLoja;
  set mercadopagoIdLoja(String mercadopagoIdLoja) => _mercadopagoIdLoja = mercadopagoIdLoja;
  Pessoa get pessoa => _pessoa;
  set pessoa(Pessoa pessoa) => _pessoa = pessoa;
  List<Endereco> get endereco => _endereco;
  set endereco(List<Endereco> endereco) => _endereco = endereco;    

  String toString() {
    return '''
      id: ${_id.toString()},    
      idPessoa: ${_idPessoa.toString()},  
      mercadopagoAcessToken: $_mercadopagoAcessToken,
      picpayAcessToken: $_picpayAcessToken,
      mercadopagoUserId: $_mercadopagoUserId, 
      ehdeletado: ${_ehDeletado.toString()}, 
      dataCadastro: ${_dataCadastro.toString()}, 
      dataAtualizacao: ${_dataAtualizacao.toString()}
      mercadopagoIdLoja: ${_mercadopagoIdLoja.toString()},
    ''';  
  }

  Integracao.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _idPessoa = json['id_pessoa'];
    _mercadopagoAcessToken = json['mercadopago_acess_token'];
    _picpayAcessToken = json['picpay_acess_token'];
    _mercadopagoUserId = json['mercadopago_user_id'];
    _ehDeletado = json['ehdeletado'];
    _dataCadastro = DateTime.parse(json['data_cadastro']);
    _dataAtualizacao = DateTime.parse(json['data_atualizacao']);
    _mercadopagoIdLoja = json['mercadopago_id_loja'];
    _pessoa = Pessoa();
    if (json['endereco'] != null) {
      _endereco = new List<Endereco>();
      json['endereco'].forEach((v) {
        _endereco.add(new Endereco.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this._id;
    data['id_pessoa'] = this._idPessoa;
    data['mercadopago_acess_token'] = this._mercadopagoAcessToken;
    data['picpay_acess_token'] = this._picpayAcessToken;
    data['mercadopago_user_id'] = this._mercadopagoUserId;
    data['ehdeletado'] = this._ehDeletado;
    data['data_cadastro'] = this._dataCadastro;
    data['data_atualizacao'] = this._dataAtualizacao;
    data['mercadopago_id_loja'] = this._mercadopagoIdLoja;
    data['pessoa'] = this._pessoa;
    if (this._endereco != null) {
      data['endereco'] = this._endereco.map((v) => v.toJson()).toList();
    }
    return data;
  }

  static List<Integracao> fromJsonList(List list){
    if(list == null) return null;
    return list
      .map((item) => Integracao.fromJson(item))
      .toList();
  }
}