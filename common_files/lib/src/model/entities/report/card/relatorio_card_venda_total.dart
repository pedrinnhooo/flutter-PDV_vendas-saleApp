import 'package:common_files/common_files.dart';

class RelatorioCardVendaTotal extends IEntity {
  double _valorTotalBruto;
  int _quantidadeVendas;
  double _ticketMedio;
  int _quantidadeVendida;

  RelatorioCardVendaTotal({double valorTotalBruto=0, int quantidadeVendas=0, double ticketMedio=0, int quantidadeVendida=0}) {
    this._valorTotalBruto = valorTotalBruto;
    this._quantidadeVendas = quantidadeVendas;
    this._ticketMedio = ticketMedio;
    this._quantidadeVendida = quantidadeVendida;
  }

  double get valorTotalBruto => _valorTotalBruto;
  set valorTotalBruto(double valorTotalBruto) => _valorTotalBruto = valorTotalBruto;
  int get quantidadeVendas => _quantidadeVendas;
  set quantidadeVendas(int quantidadeVendas) => _quantidadeVendas = quantidadeVendas;
  double get ticketMedio => _ticketMedio;
  set ticketMedio(double ticketMedio) => _ticketMedio = ticketMedio;
  int get quantidadeVendida => _quantidadeVendida;
  set quantidadeVendida(int quantidadeVendida) => _quantidadeVendida = quantidadeVendida;

  RelatorioCardVendaTotal.fromJson(Map<String, dynamic> json) {
    _valorTotalBruto = json['valor_total_bruto'];
    _quantidadeVendas = json['quantidade_vendas'];
    _ticketMedio = json['_ticketMedio'];
    _quantidadeVendida = json['quantidade_vendida'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['valor_total_bruto'] = this._valorTotalBruto;
    data['quantidade_vendas'] = this._quantidadeVendas;
    data['ticket_medio'] = this._ticketMedio;
    data['quantidade_vendida'] = this._quantidadeVendida;
    return data;
  }

  static List<RelatorioCardVendaTotal> fromJsonList(List list){
    if(list == null) return null;
    return list
      .map((item) => RelatorioCardVendaTotal.fromJson(item))
      .toList();
  }    

}