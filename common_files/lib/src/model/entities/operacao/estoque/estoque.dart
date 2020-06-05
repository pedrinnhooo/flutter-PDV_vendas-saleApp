import 'package:common_files/common_files.dart';

class Estoque extends IEntity{
  int _id;
  int _idPessoa;
  int _idPessoaGrupo;
  int _idProduto;
  int _idVariante;
  double _estoqueTotal;
  double _et1;
  double _et2;
  double _et3;
  double _et4;
  double _et5;
  double _et6;
  double _et7;
  double _et8;
  double _et9;
  double _et10;
  double _et11;
  double _et12;
  double _et13;
  double _et14;
  double _et15;
  DateTime _dataCadastro;
  DateTime _dataAtualizacao;
  
  Estoque({id, idPessoa, idPessoaGrupo, idProduto, int idVariante, double estoqueTotal=0,
           double et1, double et2, double et3, double et4, double et5, double et6, 
           double et7, double et8, double et9, double et10, double et11, double et12, 
           double et13, double et14, double et15, dataCadastro, dataAtualizacao}){
    this._id = id;
    this._idPessoa = idPessoa;
    this._idPessoaGrupo = idPessoaGrupo;
    this._idProduto = idProduto;
    this._idVariante = idVariante;
    this._estoqueTotal = estoqueTotal;
    this._et1 = et1; 
    this._et2 = et2; 
    this._et3 = et3; 
    this._et4 = et4; 
    this._et5 = et5; 
    this._et6 = et6; 
    this._et7 = et7; 
    this._et8 = et8; 
    this._et9 = et9; 
    this._et10 = et10; 
    this._et11 = et11; 
    this._et12 = et12; 
    this._et13 = et13; 
    this._et14 = et14; 
    this._et15 = et15; 
    this._dataCadastro = dataCadastro;
    this._dataAtualizacao = dataAtualizacao;
  }

  int get id => _id;
  set id(int id) => _id = id;
  int get idPessoa => _idPessoa;
  set idPessoa(int idPessoa) => _idPessoa = idPessoa;
  int get idPessoaGrupo => _idPessoaGrupo;
  set idPessoaGrupo(int idPessoaGrupo) => _idPessoaGrupo = idPessoaGrupo;
  int get idProduto => _idProduto;
  set idProduto(int idProduto) => _idProduto = idProduto;
  int get idVariante => _idVariante;
  set idVariante(int idVariante) => _idVariante = idVariante;
  double get estoqueTotal => _estoqueTotal;
  set estoqueTotal(double estoqueTotal) => _estoqueTotal = estoqueTotal;
  double get et1 => _et1;
  set et1(double et1) => _et1 = et1;
  double get et2 => _et2;
  set et2(double et2) => _et2 = et2;
  double get et3 => _et3;
  set et3(double et3) => _et3 = et3;
  double get et4 => _et4;
  set et4(double et4) => _et4 = et4;
  double get et5 => _et5;
  set et5(double et5) => _et5 = et5;
  double get et6 => _et6;
  set et6(double et6) => _et6 = et6;
  double get et7 => _et7;
  set et7(double et7) => _et7 = et7;
  double get et8 => _et8;
  set et8(double et8) => _et8 = et8;
  double get et9 => _et9;
  set et9(double et9) => _et9 = et9;
  double get et10 => _et10;
  set et10(double et10) => _et10 = et10;
  double get et11 => _et11;
  set et11(double et11) => _et11 = et11;
  double get et12 => _et12;
  set et12(double et12) => _et12 = et12;
  double get et13 => _et13;
  set et13(double et13) => _et13 = et13;
  double get et14 => _et14;
  set et14(double et14) => _et14 = et14;
  double get et15 => _et15;
  set et15(double et15) => _et15 = et15;
  DateTime get dataCadastro => _dataCadastro;
  set dataCadastro(DateTime dataCadastro) => _dataCadastro = dataCadastro;
  DateTime get dataAtualizacao => _dataAtualizacao;
  set dataAtualizacao(DateTime dataAtualizacao) =>
      _dataAtualizacao = dataAtualizacao;

  String toString() {
    return '''
      id: ${_id.toString()},    
      idPessoa: ${_idPessoa.toString()},  
      idPessoaGrupo: ${_idPessoaGrupo.toString()},  
      idProduto: ${_idProduto.toString()},  
      idVariante: ${_idVariante.toString()},  
      estoqueTotal: ${_estoqueTotal.toString()},  
      et1: ${_et1.toString()}, 
      et2: ${_et2.toString()}, 
      et3: ${_et3.toString()}, 
      et4: ${_et4.toString()}, 
      et5: ${_et5.toString()}, 
      et6: ${_et6.toString()}, 
      et7: ${_et7.toString()}, 
      et8: ${_et8.toString()}, 
      et9: ${_et9.toString()}, 
      et10: ${_et10.toString()}, 
      et11: ${_et11.toString()}, 
      et12: ${_et12.toString()}, 
      et13: ${_et13.toString()}, 
      et14: ${_et14.toString()}, 
      et15: ${_et15.toString()}, 
      dataCadastro: ${_dataCadastro.toString()}, 
      dataAtualizacao: ${_dataAtualizacao.toString()}
    ''';  
  }  

  Estoque.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _idPessoa = json['id_pessoa'];
    _idPessoaGrupo = json['id_pessoa_grupo'];
    _idProduto = json['id_produto'];
    _idVariante = json['id_variante'];
    _estoqueTotal = json['estoque_total'].toDouble();
    _et1 = json['et1'].toDouble();
    _et2 = json['et2'].toDouble();
    _et3 = json['et3'].toDouble();
    _et4 = json['et4'].toDouble();
    _et5 = json['et5'].toDouble();
    _et6 = json['et6'].toDouble();
    _et7 = json['et7'].toDouble();
    _et8 = json['et8'].toDouble();
    _et9 = json['et9'].toDouble();
    _et10 = json['et10'].toDouble();
    _et11 = json['et11'].toDouble();
    _et12 = json['et12'].toDouble();
    _et13 = json['et13'].toDouble();
    _et14 = json['et14'].toDouble();
    _et15 = json['et15'].toDouble();
    _dataCadastro = DateTime.parse(json['data_cadastro']);
    _dataAtualizacao = DateTime.parse(json['data_atualizacao']);

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this._id;
    data['id_pessoa'] = this._idPessoa;
    data['id_pessoa_grupo'] = this._idPessoaGrupo;
    data['id_produto'] = this._idProduto;
    data['id_variante'] = this._idVariante;
    data['estoque_total'] = this._estoqueTotal;
    data['et1'] = this._et1;
    data['et2'] = this._et2;
    data['et3'] = this._et3;
    data['et4'] = this._et4;
    data['et5'] = this._et5;
    data['et6'] = this._et6;
    data['et7'] = this._et7;
    data['et8'] = this._et8;
    data['et9'] = this._et9;
    data['et10'] = this._et10;
    data['et11'] = this._et11;
    data['et12'] = this._et12;
    data['et13'] = this._et13;
    data['et14'] = this._et14;
    data['et15'] = this._et15;
    data['data_cadastro'] = this._dataCadastro.toString();
    data['data_atualizacao'] = this._dataAtualizacao.toString();
    return data;
  }
}

class EstoqueGradeMovimento {
  int estoqueAtual;
  int estoqueNovo;

  EstoqueGradeMovimento(){
    estoqueAtual = 0;
  }
}