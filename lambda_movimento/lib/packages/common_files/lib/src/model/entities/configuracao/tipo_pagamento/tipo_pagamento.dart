import 'package:common_files/src/model/entities/interfaces.dart';

class TipoPagamento implements IEntity {
  int _id;
  int _idPessoaGrupo;
  String _nome;
  String _icone="";
  int _ehDinheiro;
  int _ehFiado;
  int _ehDeletado=0;
  DateTime _dataCadastro;
  DateTime _dataAtualizacao;


  TipoPagamento(
      {int id,
      int idPessoaGrupo,
      String nome,
      String icone="",
      int ehDinheiro,
      int ehFiado,
      int ehDeletado=0,
      DateTime dataCadastro,
      DateTime dataAtualizacao}) {
    this._id = id;
    this._idPessoaGrupo = idPessoaGrupo;
    this._nome = nome;
    this._icone = icone;
    this._ehDinheiro = ehDinheiro;
    this._ehFiado = ehFiado;
    this._ehDeletado = ehDeletado;
    this._dataCadastro = dataCadastro;
    this._dataAtualizacao = dataAtualizacao;
  }

  int get id => _id;
  set id(int id) => _id = id;
  int get idPessoaGrupo => _idPessoaGrupo;
  set idPessoaGrupo(int idPessoaGrupo) => _idPessoaGrupo = idPessoaGrupo;
  String get nome => _nome;
  set nome(String nome) => _nome = nome;
  String get icone => _icone;
  set icone(String icone) => _icone = icone;
  int get ehDinheiro => _ehDinheiro;
  set ehDinheiro(int ehDinheiro) => _ehDinheiro = ehDinheiro;
  int get ehFiado => _ehFiado;
  set ehFiado(int ehFiado) => _ehFiado = ehFiado;
  int get ehDeletado => _ehDeletado;
  set ehDeletado(int ehDeletado) => _ehDeletado = ehDeletado;
  DateTime get dataCadastro => _dataCadastro;
  set dataCadastro(DateTime dataCadastro) => _dataCadastro = dataCadastro;
  DateTime get dataAtualizacao => _dataAtualizacao;
  set dataAtualizacao(DateTime dataAtualizacao) =>
      _dataAtualizacao = dataAtualizacao;

  TipoPagamento.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _idPessoaGrupo = json['id_pessoa_grupo'];
    _nome = json['nome'];
    _icone = json['icone'];
    _ehDinheiro = json['ehdinheiro'];
    _ehFiado = json['ehfiado'];
    _ehDeletado = json['ehdeletado'];
    _dataCadastro = json['data_cadastro'];
    _dataAtualizacao = json['data_atualizacao'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this._id;
    data['id_pessoa_grupo'] = this._idPessoaGrupo;
    data['nome'] = this._nome;
    data['icone'] = this._icone;
    data['ehdinheiro'] = this._ehDinheiro;
    data['ehfiado'] = this._ehFiado;
    data['ehdeletado'] = this._ehDeletado;
    data['data_cadastro'] = this._dataCadastro;
    data['data_atualizacao'] = this._dataAtualizacao;
    return data;
  }
}
