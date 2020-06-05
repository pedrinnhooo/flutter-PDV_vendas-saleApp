import '../../../../../common_files.dart';

class Grade implements IEntity {
  int _id;
  int _idPessoaGrupo;
  String _nome;
  String _t1;
  String _t2;
  String _t3;
  String _t4;
  String _t5;
  String _t6;
  String _t7;
  String _t8;
  String _t9;
  String _t10;
  String _t11;
  String _t12;
  String _t13;
  String _t14;
  String _t15;
  int _ehDeletado;
  DateTime _dataCadastro;
  DateTime _dataAtualizacao;

  Grade(
      {int id,
      int idPessoaGrupo,
      String nome,
      String t1="",
      String t2="",
      String t3="",
      String t4="",
      String t5="",
      String t6="",
      String t7="",
      String t8="",
      String t9="",
      String t10="",
      String t11="",
      String t12="",
      String t13="",
      String t14="",
      String t15="",
      int ehDeletado = 0,
      DateTime dataCadastro,
      DateTime dataAtualizacao}) {
    this._id = id;
    this._idPessoaGrupo = idPessoaGrupo;
    this._nome = nome;
    this._t1 = t1;
    this._t2 = t2;
    this._t3 = t3;
    this._t4 = t4;
    this._t5 = t5;
    this._t6 = t6;
    this._t7 = t7;
    this._t8 = t8;
    this._t9 = t9;
    this._t10 = t10;
    this._t11 = t11;
    this._t12 = t12;
    this._t13 = t13;
    this._t14 = t14;
    this._t15 = t15;
    this._ehDeletado = ehDeletado;
    this._dataCadastro = dataCadastro == null ? DateTime.now() : dataCadastro;
    this._dataAtualizacao = dataAtualizacao == null ? DateTime.now() : dataAtualizacao;
  }

  int get id => _id;
  set id(int id) => _id = id;
  int get idPessoaGrupo => _idPessoaGrupo;
  set idPessoaGrupo(int idPessoaGrupo) => _idPessoaGrupo = idPessoaGrupo;
  String get nome => _nome;
  set nome(String nome) => _nome = nome;
  String get t1 => _t1;
  set t1(String t1) => _t1 = t1;
  String get t2 => _t2;
  set t2(String t2) => _t2 = t2;
  String get t3 => _t3;
  set t3(String t3) => _t3 = t3;
  String get t4 => _t4;
  set t4(String t4) => _t4 = t4;
  String get t5 => _t5;
  set t5(String t5) => _t5 = t5;
  String get t6 => _t6;
  set t6(String t6) => _t6 = t6;
  String get t7 => _t7;
  set t7(String t7) => _t7 = t7;
  String get t8 => _t8;
  set t8(String t8) => _t8 = t8;
  String get t9 => _t9;
  set t9(String t9) => _t9 = t9;
  String get t10 => _t10;
  set t10(String t10) => _t10 = t10;
  String get t11 => _t11;
  set t11(String t11) => _t11 = t11;
  String get t12 => _t12;
  set t12(String t12) => _t12 = t12;
  String get t13 => _t13;
  set t13(String t13) => _t13 = t13;
  String get t14 => _t14;
  set t14(String t14) => _t14 = t14;
  String get t15 => _t15;
  set t15(String t15) => _t15 = t15;
  int get ehDeletado => _ehDeletado;
  set ehDeletado(int ehDeletado) => _ehDeletado = ehDeletado;
  DateTime get dataCadastro => _dataCadastro;
  set dataCadastro(DateTime dataCadastro) => _dataCadastro = dataCadastro;
  DateTime get dataAtualizacao => _dataAtualizacao;
  set dataAtualizacao(DateTime dataAtualizacao) =>
      _dataAtualizacao = dataAtualizacao;

  Grade.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _idPessoaGrupo = json['idPessoaGrupo'];
    _nome = json['nome'];
    _t1 = json['t1'];
    _t2 = json['t2'];
    _t3 = json['t3'];
    _t4 = json['t4'];
    _t5 = json['t5'];
    _t6 = json['t6'];
    _t7 = json['t7'];
    _t8 = json['t8'];
    _t9 = json['t9'];
    _t10 = json['t10'];
    _t11 = json['t11'];
    _t12 = json['t12'];
    _t13 = json['t13'];
    _t14 = json['t14'];
    _t15 = json['t15'];
    _ehDeletado = json['ehdeletado'];
    _dataCadastro = json['data_cadastro'] == null ? null : DateTime.parse(json['data_cadastro']);
    _dataAtualizacao = json['data_atualizacao'] == null ? null :  DateTime.parse(json['data_atualizacao']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this._id;
    data['idPessoaGrupo'] = this._idPessoaGrupo;
    data['nome'] = this._nome;
    data['t1'] = this._t1;
    data['t2'] = this._t2;
    data['t3'] = this._t3;
    data['t4'] = this._t4;
    data['t5'] = this._t5;
    data['t6'] = this._t6;
    data['t7'] = this._t7;
    data['t8'] = this._t8;
    data['t9'] = this._t9;
    data['t10'] = this._t10;
    data['t11'] = this._t11;
    data['t12'] = this._t12;
    data['t13'] = this._t13;
    data['t14'] = this._t14;
    data['t15'] = this._t15;
    data['ehdeletado'] = this._ehDeletado;
    data['dataCadastro'] = this._dataCadastro.toString();
    data['dataAtualizacao'] = this._dataAtualizacao.toString();
    return data;
  }
}
