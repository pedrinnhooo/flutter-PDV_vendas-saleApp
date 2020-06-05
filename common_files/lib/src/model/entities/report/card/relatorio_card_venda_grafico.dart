import 'package:common_files/common_files.dart';

class RelatorioCardVendaGrafico extends IEntity {
  int _indice;
  String _label;
  double _valor;

  RelatorioCardVendaGrafico({int indice ,String label, double valor}) {
    this._indice = indice;
    this._label = label;
    this._valor = valor;
  }

  int get indice => _indice;
  set indice(int indice) => _indice = indice;
  String get label => _label;
  set label(String label) => _label = label;
  double get valor => _valor;
  set valor(double valor) => _valor = valor;

  RelatorioCardVendaGrafico.fromJson(Map<String, dynamic> json) {
    _indice = json['indice'];
    _label = json['label'];
    _valor = json['valor'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['indice'] = this._indice;
    data['label'] = this._label;
    data['valor'] = this._valor;
    return data;
  }

  static List<RelatorioCardVendaGrafico> fromJsonList(List list){
    if(list == null) return null;
    return list
      .map((item) => RelatorioCardVendaGrafico.fromJson(item))
      .toList();
  }    

}

