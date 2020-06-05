import '../../../../../common_files.dart';

class FaqQuestionario implements IEntity {
  int _id;
  int _idFaqCategoria;
  String _pergunta;
  String _resposta;
  int _ehDeletado;
  DateTime _dataAtualizacao;
  DateTime _dataCadastro;

  FaqQuestionario({
    int id,
    int idFaqCategoria, 
    String pergunta, 
    String resposta,
    DateTime dataAtualizacao,
    DateTime dataCadastro,
    int ehDeletado,}) {
    this._id = id;
    this._idFaqCategoria = idFaqCategoria;
    this._pergunta = pergunta;
    this._resposta = resposta;
    this._dataAtualizacao = dataAtualizacao;
    this._dataCadastro = dataCadastro;
    this._ehDeletado = ehDeletado;
  }

  int get id => _id;
  set id(int id) => _id = id;
  int get idFaqCategoria => _idFaqCategoria;
  set idFaqCategoria(int idFaqCategoria) => _idFaqCategoria = idFaqCategoria;
  String get pergunta => _pergunta;
  set pergunta(String pergunta) => _pergunta = pergunta;
  String get resposta => _resposta;
  set resposta(String resposta) => _resposta = resposta;
  int get ehDeletado => _ehDeletado;
  set ehDeletado(int ehDeletado) => _ehDeletado = ehDeletado;
  DateTime get dataCadastro => _dataCadastro;
  set dataCadastro(DateTime dataCadastro) => _dataCadastro = dataCadastro;
  DateTime get dataAtualizacao => _dataAtualizacao;
  set dataAtualizacao(DateTime dataAtualizacao) =>
      _dataAtualizacao = dataAtualizacao;

  FaqQuestionario.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _idFaqCategoria = json['id_faq_categoria'];
    _pergunta = json['pergunta'];
    _resposta = json['resposta'];
    _dataAtualizacao = json['data_atualizacao'];
    _dataCadastro = json['data_cadastro'];
    _ehDeletado = json['ehdeletado'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this._id;
    data['id_faq_categoria'] = this._idFaqCategoria;
    data['pergunta'] = this._pergunta;
    data['resposta'] = this._resposta;
    data['data_atualizacao'] = this._dataAtualizacao;
    data['data_cadastro'] = this._dataCadastro;
    data['ehdeletado'] = this._ehDeletado;
    return data;
  }
}