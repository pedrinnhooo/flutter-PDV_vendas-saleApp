import '../../../../../common_files.dart';

class FaqCategoria implements IEntity {
  int _id;
  String _nome;
  int _ehDeletado;
  DateTime _dataAtualizacao;
  DateTime _dataCadastro;
  List<FaqQuestionario> _faqQuestionario;

  FaqCategoria(
      {int id,
      String nome,
      DateTime dataAtualizacao,
      DateTime dataCadastro,
      int ehDeletado,
      List<FaqQuestionario> faqQuestionario}) {
    this._id = id;
    this._nome = nome;
    this._dataAtualizacao = dataAtualizacao;
    this._dataCadastro = dataCadastro;
    this._ehDeletado = ehDeletado;
    this._faqQuestionario = faqQuestionario;
  }

  int get id => _id;
  set id(int id) => _id = id;
  String get nome => _nome;
  set nome(String nome) => _nome = nome;
  int get ehDeletado => _ehDeletado;
  set ehDeletado(int ehDeletado) => _ehDeletado = ehDeletado;
  DateTime get dataCadastro => _dataCadastro;
  set dataCadastro(DateTime dataCadastro) => _dataCadastro = dataCadastro;
  DateTime get dataAtualizacao => _dataAtualizacao;
  set dataAtualizacao(DateTime dataAtualizacao) =>
      _dataAtualizacao = dataAtualizacao;
  List<FaqQuestionario> get faqQuestionario => _faqQuestionario;
  set faqQuestionario(List<FaqQuestionario> faqs) => _faqQuestionario = faqQuestionario;

  FaqCategoria.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _nome = json['nome'];
    _dataAtualizacao = json['data_atualizacao'];
    _dataCadastro = json['data_cadastro'];
    _ehDeletado = json['ehdeletado'];
    if (json['faqs'] != null) {
      _faqQuestionario = new List<FaqQuestionario>();
      json['faq'].forEach((v) {
        _faqQuestionario.add(new FaqQuestionario.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this._id;
    data['nome'] = this._nome;
    data['data_atualizacao'] = this._dataAtualizacao;
    data['data_cadastro'] = this._dataCadastro;
    data['ehdeletado'] = this._ehDeletado;
    if (this._faqQuestionario != null) {
      data['faqQuestionario'] = this._faqQuestionario.map((v) => v.toJson()).toList();
    }
    return data;
  }
}