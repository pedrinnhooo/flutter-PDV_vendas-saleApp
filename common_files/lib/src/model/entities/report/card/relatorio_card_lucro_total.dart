import 'package:common_files/common_files.dart';

class RelatorioCardLucroTotal extends IEntity {
  double _valorTotalLucro;
  double _valorTotalLiquido;
  double _valorTotalCusto;
  double _percentualLucro;

  RelatorioCardLucroTotal({double valorTotalLucro=0, double valorTotalLiquido=0, double valorTotalCusto=0, double percentualLucro=0}) {
    this._valorTotalLucro = valorTotalLucro;
    this._valorTotalLiquido = valorTotalLiquido;
    this._valorTotalCusto = valorTotalCusto;
    this._percentualLucro = percentualLucro;
  }

  double get valorTotalLucro => _valorTotalLucro;
  set valorTotalLucro(double valorTotalLucro) => _valorTotalLucro = valorTotalLucro;
  double get valorTotalLiquido => _valorTotalLiquido;
  set valorTotalLiquido(double _valorTotalLiquido) => _valorTotalLiquido = valorTotalLiquido;
  double get valorTotalCusto => _valorTotalCusto;
  set valorTotalCusto(double valorTotalCusto) => _valorTotalCusto = valorTotalCusto;
  double get percentualLucro => _percentualLucro;
  set percentualLucro(double percentualLucro) => _percentualLucro = percentualLucro;

  RelatorioCardLucroTotal.fromJson(Map<String, dynamic> json) {
    _valorTotalLucro = json['valor_total_lucro'];
    _valorTotalLiquido = json['valor_total_liquido'];
    _valorTotalCusto = json['valor_total_custo'];
    _percentualLucro = json['percentual_lucro'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['valor_total_lucro'] = this._valorTotalLucro;
    data['valor_total_liquido'] = this._valorTotalLiquido;
    data['valor_total_custo'] = this._valorTotalCusto;
    data['percentual_lucro'] = this._percentualLucro;
    return data;
  }

  static List<RelatorioCardLucroTotal> fromJsonList(List list){
    if(list == null) return null;
    return list
      .map((item) => RelatorioCardLucroTotal.fromJson(item))
      .toList();
  }    

}