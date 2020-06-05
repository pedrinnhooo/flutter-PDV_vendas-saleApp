import 'package:common_files/src/model/entities/configuracao/transacao/transacao.dart';
import 'package:common_files/src/model/entities/interfaces.dart';

class Terminal implements IEntity {
  int _id;
  int _idPessoa;
  int _idTransacao;
  String _nome;
  int _ehDeletado;
  DateTime _dataCadastro;
  DateTime _dataAtualizacao;
  Transacao _transacao;

  Terminal(
      {int id,
      int idPessoa,
      int idTransacao,
      String nome="",
      int ehDeletado = 0,
      DateTime dataCadastro,
      DateTime dataAtualizacao,
      Transacao transacao}) {
    this._id = id;
    this._idPessoa = idPessoa;
    this._idTransacao = idTransacao;
    this._nome = nome;
    this._ehDeletado = ehDeletado;
    this._dataCadastro = dataCadastro;
    this._dataAtualizacao = dataAtualizacao;
    this._transacao = transacao == null ? Transacao() : transacao;
  }

  int get id => _id;
  set id(int id) => _id = id;
  int get idPessoa => _idPessoa;
  set idPessoa(int idPessoa) => _idPessoa = idPessoa;
  int get idTransacao => _idTransacao;
  set idTransacao(int idTransacao) => _idTransacao = idTransacao;
  String get nome => _nome;
  set nome(String nome) => _nome = nome;
  int get ehDeletado => _ehDeletado;
  set ehDeletado(int ehDeletado) => _ehDeletado = ehDeletado;
  DateTime get dataCadastro => _dataCadastro;
  set dataCadastro(DateTime dataCadastro) => _dataCadastro = dataCadastro;
  DateTime get dataAtualizacao => _dataAtualizacao;
  set dataAtualizacao(DateTime dataAtualizacao) =>
      _dataAtualizacao = dataAtualizacao;
  Transacao get transacao => _transacao;
  set transacao(Transacao transacao) => 
      _transacao = transacao;      


  Terminal.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _idPessoa = json['id_pessoa'];
    _idTransacao = json['id_transacao'];
    _nome = json['nome'];
    _ehDeletado = json['ehdeletado'];
    _dataCadastro = DateTime.parse(json['data_cadastro']);
    _dataAtualizacao = DateTime.parse(json['data_atualizacao']);
    if (json['transacao'] != null) {
      _transacao = Transacao.fromJson(json);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this._id;
    data['id_pessoa'] = this._idPessoa;
    data['id_transacao'] = this._idTransacao;
    data['nome'] = this._nome;
    data['ehdeletado'] = this._ehDeletado;
    data['data_cadastro'] = this._dataCadastro;
    data['data_atualizacao'] = this._dataAtualizacao;
    return data;
  }

  static List<Terminal> fromJsonList(List list){
    if(list == null) return null;
    return list
      .map((item) => Terminal.fromJson(item))
      .toList();
  }  

}
