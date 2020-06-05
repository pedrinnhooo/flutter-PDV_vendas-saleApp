import 'package:common_files/common_files.dart';

class RelatorioCardTopProduto extends IEntity {
  String _idAparente;
  String _nome;
  double _quantidade;
  double _valor;

  RelatorioCardTopProduto({String idAparente, String nome, double quantidade, double valor}) {
    this._idAparente;
    this._nome = nome;
    this._quantidade = quantidade;
    this._valor = valor;
  }

  String get idAparente => _idAparente;
  set idAparente(String idAparente) => _idAparente = idAparente;
  String get nome => _nome;
  set nome(String nome) => _nome = nome;
  double get quantidade => _quantidade;
  set quantidade(double quantidade) => _quantidade = quantidade;
  double get valor => _valor;
  set valor(double valor) => _valor = valor;

  RelatorioCardTopProduto.fromJson(Map<String, dynamic> json) {
    _idAparente = json['id_aparente'];
    _nome = json['nome'];
    _quantidade = json['quantidade'];
    _valor = json['valor'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id_aparente'] = this._idAparente;
    data['nome'] = this._nome;
    data['quantidade'] = this._quantidade;
    data['valor'] = this._valor;
    return data;
  }

  static List<RelatorioCardTopProduto> fromJsonList(List list){
    if(list == null) return null;
    return list
      .map((item) => RelatorioCardTopProduto.fromJson(item))
      .toList();
  }    

}