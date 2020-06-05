import 'package:common_files/common_files.dart';

class RelatorioCardTopCategoria extends IEntity {
  String _nome;
  double _quantidade;
  double _valor;

  RelatorioCardTopCategoria({String nome, double quantidade, double valor}) {
    this._nome = nome;
    this._quantidade = quantidade;
    this._valor = valor;
  }

  String get nome => _nome;
  set nome(String nome) => _nome = nome;
  double get quantidade => _quantidade;
  set quantidade(double quantidade) => _quantidade = quantidade;
  double get valor => _valor;
  set valor(double valor) => _valor = valor;

  RelatorioCardTopCategoria.fromJson(Map<String, dynamic> json) {
    _nome = json['nome'];
    _quantidade = json['quantidade'];
    _valor = json['valor'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['nome'] = this._nome;
    data['quantidade'] = this._quantidade;
    data['valor'] = this._valor;
    return data;
  }

  static List<RelatorioCardTopCategoria> fromJsonList(List list){
    if(list == null) return null;
    return list
      .map((item) => RelatorioCardTopCategoria.fromJson(item))
      .toList();
  }    

}