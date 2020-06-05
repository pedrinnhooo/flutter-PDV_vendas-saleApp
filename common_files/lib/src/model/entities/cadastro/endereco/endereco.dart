import 'package:common_files/common_files.dart';

class Endereco implements IEntity {
  int _id;
  int _idPessoa;
  String _apelido;
  String _cep;
  String _logradouro;
  String _numero;
  String _complemento;
  String _bairro;
  String _municipio;
  String _estado;
  String _ibgeMunicipio;
  String _pais;
  int _ehDeletado;
  DateTime _dataCadastro;
  DateTime _dataAtualizacao;

  Endereco(
      {int id,
      int idPessoa,
      String apelido="",
      String cep="",
      String logradouro="",
      String numero="",
      String complemento="",
      String bairro="",
      String municipio="",
      String estado="",
      String ibgeMunicipio,
      String pais,
      int ehDeletado = 0,
      DateTime dataCadastro,
      DateTime dataAtualizacao}) {
    this._id = id;
    this._idPessoa = idPessoa;
    this._apelido = apelido;
    this._cep = cep;
    this._logradouro = logradouro;
    this._numero = numero;
    this._complemento = complemento;
    this._bairro = bairro;
    this._municipio = municipio;
    this._estado = estado;
    this._ibgeMunicipio = ibgeMunicipio;
    this._pais = pais;
    this._ehDeletado = ehDeletado;
    this._dataCadastro = dataCadastro == null ? DateTime.now() : dataCadastro;
    this._dataAtualizacao = dataAtualizacao == null ? DateTime.now() : dataAtualizacao;
  }

  int get id => _id;
  set id(int id) => _id = id;
  int get idPessoa => _idPessoa;
  set idPessoa(int idPessoa) => _idPessoa = idPessoa;
  String get apelido => _apelido;
  set apelido(String apelido) => _apelido = apelido;
  String get cep => _cep;
  set cep(String cep) => _cep = cep;
  String get logradouro => _logradouro;
  set logradouro(String logradouro) => _logradouro = logradouro;
  String get numero => _numero;
  set numero(String numero) => _numero = numero;
  String get complemento => _complemento;
  set complemento(String complemento) => _complemento = complemento;
  String get bairro => _bairro;
  set bairro(String bairro) => _bairro = bairro;
  String get municipio => _municipio;
  set municipio(String municipio) => _municipio = municipio;
  String get estado => _estado;
  set estado(String estado) => _estado = estado;
  String get ibgeMunicipio => _ibgeMunicipio;
  set ibgeMunicipio(String ibgeMunicipio) => _ibgeMunicipio = ibgeMunicipio;
  String get pais => _pais;
  set pais(String pais) => _pais = pais;
  int get ehDeletado => _ehDeletado;
  set ehDeletado(int ehDeletado) => _ehDeletado = ehDeletado;
  DateTime get dataCadastro => _dataCadastro;
  set dataCadastro(DateTime dataCadastro) => _dataCadastro = dataCadastro;
  DateTime get dataAtualizacao => _dataAtualizacao;
  set dataAtualizacao(DateTime dataAtualizacao) =>
      _dataAtualizacao = dataAtualizacao;

  String toString() {
    return '''
      id: ${_id.toString()},    
      idPessoa: ${_idPessoa.toString()},  
      apelido: $_apelido, 
      cep: $_cep, 
      logradouro: $_logradouro, 
      numero: $_numero, 
      complemento: $_complemento, 
      bairro: $_bairro, 
      municipio: $_municipio, 
      estado: $_estado, 
      ibgeMunicipio: $_ibgeMunicipio, 
      pais: $_pais, 
      ehDeleteado: ${_ehDeletado.toString()},
      dataCadastro: ${_dataCadastro.toString()}, 
      dataAtualizacao: ${_dataAtualizacao.toString()}
    ''';  
  }   
  
  Endereco.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _idPessoa = json['id_pessoa'];
    _apelido = json['apelido'];
    _cep = json['cep'];
    _logradouro = json['logradouro'];
    _numero = json['numero'];
    _complemento = json['complemento'];
    _bairro = json['bairro'];
    _municipio = json['municipio'];
    _estado = json['estado'];
    _ibgeMunicipio = json['ibge_municipio'];
    _pais = json['pais'];
    _ehDeletado = json['ehdeletado'];
    _dataCadastro = json['data_cadastro'] != null ? DateTime.parse(json['data_cadastro']) : null;
    _dataAtualizacao = json['data_atualizacao'] != null ? DateTime.parse(json['data_atualizacao']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this._id;
    data['id_pessoa'] = this._idPessoa;
    data['apelido'] = this._apelido;
    data['cep'] = this._cep;
    data['logradouro'] = this._logradouro;
    data['numero'] = this._numero;
    data['complemento'] = this._complemento;
    data['bairro'] = this._bairro;
    data['municipio'] = this._municipio;
    data['estado'] = this._estado;
    data['ibge_municipio'] = this._ibgeMunicipio;
    data['pais'] = this._pais;
    data['ehdeletado'] = this._ehDeletado;
    data['data_cadastro'] = this._dataCadastro.toString();
    data['data_atualizacao'] = this._dataAtualizacao.toString();
    return data;
  }
}
